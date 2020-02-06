import Capacitor
import Photos

@objc(PhotoRoll)
public class PhotoRoll: CAPPlugin {
    
    @objc func hasLibraryPermission(_ call: CAPPluginCall)  {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            call.success(["status": true])
        } else {
            call.success(["status": false])
        }
    }

    @objc func getLastPhotoTaken(_ call: CAPPluginCall) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let image = getAssetThumbnail(asset: fetchResult.object(at: 0))
        let imageData:Data =  image.pngData()!
        let base64String = imageData.base64EncodedString()
        
        call.success([
            "image": base64String
        ])
        
    }
    
    @objc func getLastPhotosTaken(_ call: CAPPluginCall) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        let photos = fetchResult
        
        
        call.success()
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        
        return thumbnail
    }
}
