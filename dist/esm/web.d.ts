import { WebPlugin } from '@capacitor/core';
import { PhotoRollPlugin } from './definitions';
export declare class PhotoRollWeb extends WebPlugin implements PhotoRollPlugin {
    constructor();
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}
declare const PhotoRoll: PhotoRollWeb;
export { PhotoRoll };
