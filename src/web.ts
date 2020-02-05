import { WebPlugin } from '@capacitor/core';
import { PhotoRollPlugin } from './definitions';

export class PhotoRollWeb extends WebPlugin implements PhotoRollPlugin {
  constructor() {
    super({
      name: 'PhotoRoll',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }
}

const PhotoRoll = new PhotoRollWeb();

export { PhotoRoll };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(PhotoRoll);
