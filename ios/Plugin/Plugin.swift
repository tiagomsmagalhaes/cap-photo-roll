import Foundation
import Photos
import Capacitor
import WebKit


@objc(PhotoRoll)
public class PhotoRoll: CAPPlugin {
    static let DEFAULT_QUANTITY = 25
    static let DEFAULT_TYPES = "photos"
    static let DEFAULT_THUMBNAIL_WIDTH = 256
    static let DEFAULT_THUMBNAIL_HEIGHT = 256

    lazy var imageManager = PHCachingImageManager()
    
    struct Photo: Codable {
        var identifier: String
        var data: String
        var creationDate: String
        var fullWidth: Int
        var fullHeight: Int
        var thumbnailWidth: CGFloat
        var thumbnailHeight: CGFloat
    }

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
    
    @objc func getPhotos(_ call: CAPPluginCall) {
        self.fetchResultAssetsToJs(call)
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
    
    
    func fetchResultAssetsToJs(_ call: CAPPluginCall) {
        var assets: [Encodable] = []
        
        let quantity = call.getInt("quantity", PhotoRoll.DEFAULT_QUANTITY)!
        
        var targetCollection: PHAssetCollection?
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: options)

        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.version = .current
        requestOptions.deliveryMode = .opportunistic
        requestOptions.isSynchronous = true
        
        let thumbnailWidth = call.getInt("thumbnailWidth", PhotoRoll.DEFAULT_THUMBNAIL_WIDTH)!
        let thumbnailHeight = call.getInt("thumbnailHeight", PhotoRoll.DEFAULT_THUMBNAIL_HEIGHT)!
        let thumbnailSize = CGSize(width: thumbnailWidth, height: thumbnailHeight)
        let thumbnailQuality = call.getInt("thumbnailQuality", 95)!

        
        fetchResult.enumerateObjects { (asset, count, stop) in
            if asset.mediaType == .video {
                return
            }
            
            self.imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: requestOptions, resultHandler: { (fetchedImage, _) in
                guard let image = fetchedImage else {
                    return
                }
                
                let identifier = asset.localIdentifier
                let data = image.jpegData(compressionQuality: CGFloat(thumbnailQuality) / 100.0)?.base64EncodedString()
                
                var creationDate: String = ""

                let dateFormatter = DateFormatter()
            
                if (asset.creationDate != nil) {
                    creationDate = dateFormatter.string(from: (asset.creationDate ?? nil)!)
                }
                
                let photo = Photo(identifier: identifier, data: data!, creationDate: creationDate, fullWidth: asset.pixelWidth, fullHeight: asset.pixelHeight, thumbnailWidth: image.size.width, thumbnailHeight: image.size.height)
                
                let encoder = JSONEncoder()
                
                
                do {
                    let encodedPhoto = try encoder.encode(photo)
                    assets.append(encodedPhoto)
                } catch {
                    print(error)
                }
            })
        }
        
        call.success([
            "status": true,
            "photos": assets
        ])
    }
}
