# cap-photo-roll

[![npm version](https://badge.fury.io/js/cap-photo-roll.svg)](https://badge.fury.io/js/cap-photo-roll)

A Capacitor API for retrieving Photos from your device Camera Roll. A work in progress.



## Installation

```
npm i --save cap-photo-roll
```

## Usage


### Angular

```typescript
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { Plugins } from '@capacitor/core';

const { PhotoRoll } = Plugins;

@Component({
    selector: 'app-gallery',
    template: '<img [src]="domSanitizer.bypassSecurityTrustUrl(lastPhoto)" />'
})
export class GalleryPage {
    private lastPhoto = '';

    async getPhoto() {
        const latestPhoto = await PhotoRoll.getLastPhotoTaken();

        this.lastPhoto = 'data:image/png;base64, ' + result.image;
}

```
