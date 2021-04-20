
import fs from 'fs';
import _ from 'lodash';
import yaml from "js-yaml";
import { ApiError, Credentials } from '@solace-iot-team/platform-api-openapi-client';

export class Helper {    
    public static createDefaultCredentials() : Credentials {
        return {
            expiresAt: -1
        };
    }
    public static loadYamlFileAsJsonString = (apiSpecPath: string): string => {
        const b: Buffer = fs.readFileSync(apiSpecPath);
        const obj = yaml.load(b.toString());
        return JSON.stringify(obj);
    }
    public static getMandatoryEnvVarValue = (envVar: string): string => {
        const value: any = (process.env[envVar] === undefined) ? null : process.env[envVar];
        if (value == null) throw new Error(`>>> ERROR: missing env var: ${envVar}`);
        return value;
    }
    public static checkIfFileExists = (path: string): string => {
        if(!fs.existsSync(path)) {
            throw new Error(`>>>> ERROR: file not found: ${path}`);
        }
        return path;
    }
    public static cloneHideSecrets = (config: any) => _.transform(config, (r:any, v:any, k:string) => {
        if(_.isObject(v)) {
            r[k] = Helper.cloneHideSecrets(v)
        } else if(typeof k === 'string') {
            let _k = k.toLowerCase();
            if( _k.includes('token')        ||
                _k.includes('pwd')          ||
                _k.includes('service_id')   ||
                _k.includes('serviceid')    ) {
                    r[k] = '***';
            } else {
                r[k] = v;
            }
        } else {
            r[k] = v;
        }
    })
    public static logConfig = (config: any): void => {
        let c = Helper.cloneHideSecrets(config);
        console.log(`config=\n${JSON.stringify(c, null, 2)}`);
    }
    public static logApiResponse = (response: any): void => {
        let c = Helper.cloneHideSecrets(response);
        console.log(`response=\n${JSON.stringify(c, null, 2)}`);
    }
    public static isInstanceOfApiError(error: any): boolean {
        let apiError: ApiError = error;
        if(apiError.status === undefined) return false;
        if(apiError.statusText === undefined) return false;
        if(apiError.url === undefined) return false;
        if(apiError.message === undefined) return false; 
        return true;
    }
    public static logError = (e: any): void => {
        let _e: string;
        if(Helper.isInstanceOfApiError(e)) _e = JSON.stringify(e, null, e);
        else _e = e;
        console.log(`>>> ERROR: ${_e}`);
    }
}
