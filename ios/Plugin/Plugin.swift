import Capacitor
import Photos

@objc(PhotoRoll)
public class PhotoRoll: CAPPlugin {

    lazy var imageManager = PHCachingImageManager()

    @objc func hasLibraryPermission(_ call: CAPPluginCall)  {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
            case .authorized:   call.success(["status": true])
            case .restricted:   call.error("Restricted")
            case .denied:       call.error("REJECTED")
            case .notDetermined: PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) in
                if (status == PHAuthorizationStatus.authorized) {
                    print("agora autorizado")
                    call.success(["status": true])
                } else {
                    print("agora outra coisa")
                    call.success(["status": true])
                }
            })
        }
    }

    @objc func getLastPhotoTaken(_ call: CAPPluginCall) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        if fetchResult.count > 0 {
        let image = getAssetThumbnail(asset: fetchResult.object(at: 0))
        let imageData:Data =  image.pngData()!
        let base64String = imageData.base64EncodedString()
        
            call.success([
                "status": true,
                "image": base64String
            ])  
        } else {
            call.error("Permission Denied")
        }
        
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
