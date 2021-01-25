//
//  XFirebase.swift
//  ShopAp
//
//  Created by mr Yacine on 11/26/18.
//  Copyright © 2018 mr Yacine. All rights reserved.
//


import UIKit
import Firebase


class Uploader {
    
    static var shared = Uploader()
    
    typealias DidUploadOne1 = (String?) -> ()
    var block: DidUploadOne1?
    
    var DidUploadOne : (() -> ())?
    
    var DidUploadAll : (()->())?
    
    var DidFailedUpload : (()->())?
    
    var UploadedImagesURLS : [String] = []
    
    func Upload(Images : [UIImage]) {
        UploadedImagesURLS = [] ;
        counter = 0
        self.Images = Images
        RecursivUploader()
    }
    
    private var Images : [UIImage] = []
    
    private var counter : Int = 0
    
    
    private func RecursivUploader() {
        if (Images.count > 0) == false { self.DidFailedUpload?() ; return }
        Images[counter].Upload {[weak self] (imageURL) in
            if self == nil { return }
            guard let url = imageURL  else { self?.DidFailedUpload?() ; return }
            self?.UploadedImagesURLS.append(url)
            self?.DidUploadOne?()
            if self?.counter == self!.Images.count - 1 {
                self?.DidUploadAll?()
                print(url)
            } else {
                self?.counter += 1
                self?.RecursivUploader()
            }
        }
    }
    
    fileprivate func UploadInTwoSize(Image : UIImage , completion : @escaping (_ OriginalImage : String? , _ SmallImage : String? , _ ErrorMessage : String?) -> ()) {
        UploadImageToStorage(Image: Image.resize(size: 1000)) { (OriginalImageURL : String?) in
            guard let OriginalImage = OriginalImageURL else { completion(nil , nil , "Error") ; return }
            self.UploadImageToStorage(Image: Image.resize(size: 250)) { (SmallImageURL : String?) in
                guard let SmallImage = SmallImageURL else { completion(nil , nil , "Error") ; return }
                completion(OriginalImage, SmallImage, nil)
            }
        }
    }
    
    fileprivate func UploadImageToStorage(Image : UIImage , Completion : @escaping (String?)->()) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let metadata = StorageMetadata() ; metadata.contentType = "image/png" ; let UID = UUID().uuidString
        let storeImage = storageReference.child("StoredImage").child(UID)
        guard let ImageData = Image.pngData() else {
            print(">>> Error in Converting Image To Data <<<")
            Completion(nil)
            return
        }
        storeImage.putData(ImageData, metadata: metadata) { (meta , error) in
            if error != nil {
                print(">>> Error in uploading image data to storage <<< ")
                Completion(nil)
                return
            } else {
                storeImage.downloadURL(completion: { (url, err) in
                    if err != nil {
                        print(">>> Error in getting url from storage <<< ")
                        return
                    }
                    guard let urlText = url?.absoluteString else {return}
                    Completion(urlText)
                })
                
            }
        }
        
    }
    
}
// MARK: - UPLOAD DATA

// MARK: - GET DOWNLOAD URL


extension UIImage {
    
    func Upload(Completion : @escaping (String?)->()) {
        Uploader.shared.UploadImageToStorage(Image: self) { (ImageURL : String?) in
            guard let ImageURL = ImageURL else {
                print("Download url not found or error to upload")
                return Completion(nil)
            }
            Completion(ImageURL)
        }
    }
    
}

class Admin {
    static func IsAdmin(completion : @escaping ()->()) {
        var admin : Bool = false
        Database.database().reference().child("AdminCanRead").observeSingleEvent(of: .value) {(Snapshot : DataSnapshot) in
            if Snapshot.exists() {
                admin = true
                completion()
            }
        }
    }
    
    static func IsnotAdmin(completion : @escaping ()->()) {
        //var admin : Bool = false
        Database.database().reference().child("AdminCanRead").observeSingleEvent(of: .value) {(Snapshot : DataSnapshot) in
            let exist = Snapshot.exists()
            if !exist {
                print("erreur")
            }
        }
    }
    
    static func IsSuperAdmin(completion : @escaping ()->()) {
        Database.database().reference().child("SuperAdminCanRead").observeSingleEvent(of: .value) {(Snapshot : DataSnapshot) in
            if Snapshot.exists() {
                completion()
            }
        }
    }
}


//
//  FirAuthError.swift
//  Firebase App
//
//  Created by Osama Jassim on 2/23/17.
//  Copyright © 2017 Osama Jassim. All rights reserved.
//

import Foundation
import Firebase

class FirError {
    
    static func Error(Code : Int) -> String {
        
        if let TheError = AuthErrorCode(rawValue: Code) {
            
            switch TheError {
            case .emailAlreadyInUse :
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mail_Used", comment: "")
            case .weakPassword :
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: "Paasw_Weak", comment: "")
            case .networkError :
                return  LocalizationSystem.sharedInstance.localizedStringForKey(key: "Err_Conn", comment: "")
            case .userNotFound :
                return  LocalizationSystem.sharedInstance.localizedStringForKey(key: "No_ExistMail", comment: "")
            case .invalidEmail :
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: "Err_Mail", comment: "")
            case .wrongPassword :
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: "Passw_wrong", comment: "")
            default :
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: "Uknoun_err", comment: "")
            }
            
        }
        
        return "خطا غير معروف"
    }
    
}




