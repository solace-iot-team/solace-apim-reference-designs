import { Helper } from './helper';
import { PlatformAPIClient } from './platformapiclient';
import { AppPatch, AppStatus, Organization } from '@solace-iot-team/platform-api-openapi-client';
import { PlatformManagementService, Environment, EnvironmentsService, ApisService, APIProduct, Protocol, ApiProductsService, Developer, DevelopersService, App, AppsService } from '@solace-iot-team/platform-api-openapi-client';

const bootstrapConfig = {
    PLATFORM_PROTOCOL: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_PROTOCOL'),
    PLATFORM_HOST: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_HOST'),
    PLATFORM_PORT: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_PORT'),
    PLATFORM_ADMIN_USER: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_ADMIN_USER'),
    PLATFORM_ADMIN_PWD: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_ADMIN_USER_PWD'),
    ORG_NAME: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_NAME'),
    ORG_API_USR: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER'),
    ORG_API_PWD: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_ORG_API_USER_PWD'),
    SOLACE_CLOUD_URL: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_API_URL'),
    SOLACE_CLOUD_TOKEN: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_TOKEN'),
    // SOLACE_CLOUD_EVENT_PORTAL_URL: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_EVENT_PORTAL_API_URL'),
    SOLACE_CLOUD_EVENT_PORTAL_TOKEN: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_EVENT_PORTAL_TOKEN'),
    SOLACE_CLOUD_DEV_GW_SERVICE_ID: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_DEV_GW_SERVICE_ID'),
    SOLACE_CLOUD_PROD_GW_SERVICE_ID: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_PLATFORM_API_SERVER_SOLACE_CLOUD_PROD_GW_SERVICE_ID'),
    exposure: {
        consumption: {
            api: {
                name: 'consumption-api',
                asyncapi_spec_file: Helper.checkIfFileExists('./asyncapi-specs/ApiConsumption.asyncapi-spec.yml'),    
            },
            apiProducts: {
                dev: {
                    name: 'consumption-development',
                    displayName: 'Consumption Development',
                    description: 'Consumption Development API Product - auto approved, with mock dev events',
                    approvalType: APIProduct.approvalType.AUTO,
                    permissions: [
                        { name: 'region_id', value: '*' }, 
                        { name: 'make', value: '*' },
                        { name: 'model', value: '*' },
                        { name: 'vin', value: '*' },
                        { name: 'event_type', value: 'consumption' }
                    ],
                    protocols:[ 
                        { name: Protocol.name.HTTP, version: '1.1' },
                        { name: Protocol.name.HTTPS, version: '1.1' },
                        { name: Protocol.name.MQTT, version: '3.1.1' },
                        { name: Protocol.name.SECURE_MQTT, version: '3.1.1' },
                        { name: Protocol.name.WS_MQTT, version: '3.1.1' },
                        { name: Protocol.name.WSS_MQTT, version: '3.1.1' }
                    ]
                },
                prod: {
                    name: 'consumption-production',
                    displayName: 'Consumption Production',
                    description: 'Consumption Production API Product - requires approval',
                    approvalType: APIProduct.approvalType.MANUAL,
                    permissions: [
                        { name: 'region_id', value: 'fr, de, it' }, 
                        { name: 'make', value: '*' },
                        { name: 'model', value: '*' },
                        { name: 'vin', value: '*' }
                    ],
                    protocols:[ 
                        { name: Protocol.name.HTTPS, version: '1.1' },
                        { name: Protocol.name.SECURE_MQTT, version: '3.1.1' },
                        { name: Protocol.name.WSS_MQTT, version: '3.1.1' }
                    ]                                        
                }
            }
        }
    },
    consumption: {
        developers: {
            developer_1: {
                firstName: 'Dev1',
                lastName: 'Developer',
                email: 'dev1@partner-co-a.de',
                devApp: {
                    name: 'Dev1-consumption-dev-app'
                },
                prodApp: {
                    name: 'Dev1-consumption-prod-app',
                    permissions: [
                        { name: 'region_id', value: 'de' },
                    ]                
                }
            },
            developer_2: {
                firstName: 'Dev2',
                lastName: 'Developer',
                email: 'dev2@partner-co-b.fr',
                devApp: {
                    name: 'Dev2-consumption-dev-app'
                },
                prodApp: {
                    name: 'Dev2-consumption-prod-app',
                    permissions: [
                        { name: 'region_id', value: 'fr' }
                    ]                
                }
            }
        }
    }
}
Helper.logConfig(bootstrapConfig);

const devEnvironment: Environment = {
    name: 'development',
    description: 'development environment',
    serviceId: bootstrapConfig.SOLACE_CLOUD_DEV_GW_SERVICE_ID
}
const prodEnvironment: Environment = {
    name: 'production',
    description: 'production environment',
    serviceId: bootstrapConfig.SOLACE_CLOUD_PROD_GW_SERVICE_ID
}
const environments = {
    dev: devEnvironment,
    prod: prodEnvironment
} 

// pipeline
const initializeOpenAPI = () => {
    const base: string = PlatformAPIClient.getBaseUrl(bootstrapConfig.PLATFORM_PROTOCOL, bootstrapConfig.PLATFORM_HOST, bootstrapConfig.PLATFORM_PORT);
    PlatformAPIClient.initialize(base, bootstrapConfig.PLATFORM_ADMIN_USER, bootstrapConfig.PLATFORM_ADMIN_PWD, bootstrapConfig.ORG_API_USR, bootstrapConfig.ORG_API_PWD);  
}
const deleteOrg = async() => {
    console.log(`deleting org '${bootstrapConfig.ORG_NAME}' ...`);
    PlatformAPIClient.setManagementUser();
    try {
        await PlatformManagementService.deleteOrganization(bootstrapConfig.ORG_NAME);
    } catch(e) {
        console.log(`deleteOrg error = ${JSON.stringify(e, null, 2)}`);
        if(e.status !== 404 && e.status !== 201) {
            Helper.logError(e);
            process.exit(1);
        }
    }
    console.log('success.');
}
const createOrg = async() => {
    console.log(`creating org '${bootstrapConfig.ORG_NAME}' ...`);
    PlatformAPIClient.setManagementUser();
    let request: Organization = {
        name: bootstrapConfig.ORG_NAME,
        'cloud-token': bootstrapConfig.SOLACE_CLOUD_TOKEN        
    }
    try {
        let response: Organization = await PlatformManagementService.createOrganization(request);
        Helper.logApiResponse(response);
    } catch(e) {
        Helper.logError(e);
        process.exit(1);
    }
    console.log('success.');
}
const registerEnvironmentsWithOrg = async() => {
    console.log('register environments with org ...');
    PlatformAPIClient.setApiUser();
    let k: keyof typeof environments;
    for(k in environments) {
        const request: Environment = environments[k];
        try {
            let response: Environment = await EnvironmentsService.createEnvironment(bootstrapConfig.ORG_NAME, request);
            Helper.logApiResponse(response);
        } catch(e) {
            Helper.logError(e);
            process.exit(1);
        }    
    }
    console.log('success.');
}
const createConsumptionApi = async() => {
    console.log('create consumption api ...');
    const apiSpec: string = Helper.loadYamlFileAsJsonString(bootstrapConfig.exposure.consumption.api.asyncapi_spec_file);
    PlatformAPIClient.setApiUser();    
    try {
        let response: string = await ApisService.createApi(bootstrapConfig.ORG_NAME, bootstrapConfig.exposure.consumption.api.name, apiSpec);
        Helper.logApiResponse(response);
    } catch(e) {
        Helper.logError(e);
        process.exit(1);
    }
    console.log('success.');
}
const createApiProducts = async() => {
    console.log('create api products ...');
    PlatformAPIClient.setApiUser(); 
    let apiProducts = bootstrapConfig.exposure.consumption.apiProducts;
    let k: keyof typeof apiProducts;
    for(k in apiProducts) {
        let apiProduct = apiProducts[k];
        let request: APIProduct = {
            name: apiProduct.name,
            displayName: apiProduct.displayName,
            description: apiProduct.description,
            apis: [ 
                bootstrapConfig.exposure.consumption.api.name
            ],
            approvalType: apiProduct.approvalType,
            attributes: apiProduct.permissions,
            environments: [ 
                environments[k].name
            ],
            protocols: apiProduct.protocols,
            pubResources: [],
            subResources: []
          };
        try {
            let response: APIProduct = await ApiProductsService.createApiProduct(bootstrapConfig.ORG_NAME, request);
            Helper.logApiResponse(response);
        } catch(e) {
            Helper.logError(e);
            process.exit(1);
        }    
    }
    console.log('success.');
}
const createDevelopers = async() => {
    console.log('create developers ...');
    PlatformAPIClient.setApiUser();    
    let developers = bootstrapConfig.consumption.developers;
    let k: keyof typeof developers;
    for(k in developers) {
        let developer = developers[k];
        let request: Developer = {
            email: developer.email,
            firstName: developer.firstName,
            lastName: developer.lastName,
            userName: developer.email
        }
        try {
            let response: Developer = await DevelopersService.createDeveloper(bootstrapConfig.ORG_NAME, request);
            Helper.logApiResponse(response);
        } catch(e) {
            Helper.logError(e);
            process.exit(1);
        }
    }
    console.log('success.');
}
const createDeveloperApps = async() => {
    console.log('create developer apps ...');
    PlatformAPIClient.setApiUser();   
    let developers = bootstrapConfig.consumption.developers;
    let k: keyof typeof developers;
    for(k in developers) {
        let developer = developers[k];
        let requests: Array<App> = [
            {
                name: `${developer.devApp.name}`,
                apiProducts: [ bootstrapConfig.exposure.consumption.apiProducts.dev.name ],
                credentials: Helper.createDefaultCredentials()
            },
            {
                name: `${developer.prodApp.name}`,
                apiProducts: [ bootstrapConfig.exposure.consumption.apiProducts.prod.name ],
                credentials: Helper.createDefaultCredentials()
            }            
        ];
        for(let request of requests) {
            try {
                let response: App = await AppsService.createDeveloperApp(bootstrapConfig.ORG_NAME, developer.email, request);
                Helper.logApiResponse(response);
            } catch(e) {
                Helper.logError(e);
                process.exit(1);
            }        
        }
    }
    console.log('success.');
}
const approvePendingApps = async() => {
    console.log('approve pending prod apps with permissions ...');
    PlatformAPIClient.setApiUser();   
    let developers = bootstrapConfig.consumption.developers;
    let k: keyof typeof developers;
    for(k in developers) {
        let developer = developers[k];
        let request: AppPatch = {
            attributes: developer.prodApp.permissions,
            status: AppStatus.APPROVED
        };
        try {
            let response: App = await AppsService.updateDeveloperApp(bootstrapConfig.ORG_NAME, developer.email, developer.prodApp.name, request);
            Helper.logApiResponse(response);
        } catch(e) {
            Helper.logError(e);
            process.exit(1);
        }        
    }
    console.log('success.');
}

const main = async() => {
    initializeOpenAPI();
    await deleteOrg();
    await createOrg();
    await registerEnvironmentsWithOrg();
    await createConsumptionApi();
    await createApiProducts();
    await createDevelopers();
    await createDeveloperApps();
    await approvePendingApps();
}

main();



