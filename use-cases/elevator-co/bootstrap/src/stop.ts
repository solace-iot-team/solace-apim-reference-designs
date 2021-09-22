import { Helper } from './lib/helper';
import { PlatformAPIClient } from './lib/platformapiclient';
import { AdministrationService, Organization } from '@solace-iot-team/platform-api-openapi-client';

let bootstrapConfig = {
    PLATFORM_PROTOCOL: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_CONNECTOR_SERVER_PROTOCOL'),
    PLATFORM_HOST: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_CONNECTOR_SERVER_HOST'),
    PLATFORM_PORT: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_CONNECTOR_SERVER_PORT'),
    PLATFORM_ADMIN_USER: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_ADMIN_USER'),
    PLATFORM_ADMIN_PWD: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_ADMIN_USER_PWD'),
    ORG_API_USR: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_ORG_API_USER'),
    ORG_API_PWD: Helper.getMandatoryEnvVarValue('APIM_BOOTSTRAP_ORG_API_USER_PWD'),
}
Helper.logConfig(bootstrapConfig);

// pipeline
const initializeOpenAPI = () => {
    const base: string = PlatformAPIClient.getBaseUrl(bootstrapConfig.PLATFORM_PROTOCOL, bootstrapConfig.PLATFORM_HOST, bootstrapConfig.PLATFORM_PORT);
    PlatformAPIClient.initialize(base, bootstrapConfig.PLATFORM_ADMIN_USER, bootstrapConfig.PLATFORM_ADMIN_PWD, bootstrapConfig.ORG_API_USR, bootstrapConfig.ORG_API_PWD);
}
const deleteAllOrgs = async() => {
  console.log(`delete all orgs ...`);
  PlatformAPIClient.setManagementUser();
  try {
    console.log(`get all orgs ...`);
    const organizationList: Organization[] = await AdministrationService.listOrganizations();
    console.log(`list of orgs: \n${JSON.stringify(organizationList, null, 2)}`);
    for(const organization of organizationList) {
      console.log(`deleting org:${organization.name} ...`);
      await AdministrationService.deleteOrganization(organization.name);
      console.log('org deleted.');
    }
  } catch(e: any) {
      console.log(`error = \n${JSON.stringify(e, null, 2)}`);
      Helper.logError(e);
      process.exit(1);
  }
  console.log('success.');
}

const main = async() => {
  initializeOpenAPI();
  await deleteAllOrgs();
}

main();
