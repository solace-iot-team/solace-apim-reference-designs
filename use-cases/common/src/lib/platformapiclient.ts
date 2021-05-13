
import { OpenAPI } from '@solace-iot-team/platform-api-openapi-client';

enum PlatformAPIClientAuthUser {
    ManagementUser,
    ApiUser    
}

export class PlatformAPIClient {    
    private static managementUser: string;
    private static managementPwd: string;
    private static apiUser: string;
    private static apiPwd: string;
    private static authUser: PlatformAPIClientAuthUser = PlatformAPIClientAuthUser.ApiUser;

    public static getOpenApiUser = async(): Promise<string> => {
        return (PlatformAPIClient.authUser === PlatformAPIClientAuthUser.ApiUser ? PlatformAPIClient.apiUser : PlatformAPIClient.managementUser);
    }  
    public static getOpenApiPwd = async(): Promise<string> => {
        return (PlatformAPIClient.authUser === PlatformAPIClientAuthUser.ApiUser ? PlatformAPIClient.apiPwd : PlatformAPIClient.managementPwd);
    }  
    public static getBaseUrl = (platformProtocol: string, platformHost: string, platformPort: string): string => {
        return `${platformProtocol}://${platformHost}:${platformPort}/v1`;
    }
    public static initialize = (base: string, managementUser: string , managementPwd: string, apiUser: string, apiPwd: string) => {
        PlatformAPIClient.managementUser = managementUser;
        PlatformAPIClient.managementPwd = managementPwd;
        PlatformAPIClient.apiUser = apiUser;
        PlatformAPIClient.apiPwd = apiPwd;
        OpenAPI.BASE = base;
        OpenAPI.USERNAME = PlatformAPIClient.getOpenApiUser;
        OpenAPI.PASSWORD = PlatformAPIClient.getOpenApiPwd;

    }
    public static setApiUser = () => {
        PlatformAPIClient.authUser = PlatformAPIClientAuthUser.ApiUser;
    }
    public static setManagementUser = () => {
        PlatformAPIClient.authUser = PlatformAPIClientAuthUser.ManagementUser;
    }
}
