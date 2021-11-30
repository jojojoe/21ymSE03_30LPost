//
//  LPyMainVC.swift
//  LPymPost
//
//  Created by JOJO on 2021/10/28.
//

import UIKit
import SwifterSwift
import SnapKit
import Photos
import YPImagePicker
import DeviceKit


class LPyMainVC: UIViewController, UINavigationControllerDelegate {

    var isEnterFrame: Bool = false
    var isLock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        AFlyerLibManage.event_LaunchApp()
        
        showLoginVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isLock = false
    }
    func showLoginVC() {
        if APLoginMana.currentLoginUser() == nil {
            let loginVC = APLoginMana.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func setupView() {
        
        view.backgroundColor(UIColor(hexString: "#F2F2F2")!)
        //
        let bgImgV = UIImageView()
        bgImgV
            .image("homepage_bg")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let settingBtn = UIButton(type: .custom)
        settingBtn
            .image(UIImage(named: "homepage_info"))
            .adhere(toSuperview: view)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        //
        let storeBtn = UIButton(type: .custom)
        storeBtn
            .image(UIImage(named: "homepage_store"))
            .adhere(toSuperview: view)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender: )), for: .touchUpInside)
        //
        let centerLabel = UILabel()
        centerLabel
            .color(UIColor(hexString: "#454D3D")!)
            .fontName(24, "AvenirNext-DemiBold")
            .text(AppName)
            .textAlignment(.center)
            .adhere(toSuperview: view)
        centerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let coverImgV = UIImageView()
        coverImgV
            .image("homepage_")
            .backgroundColor(UIColor.clear)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        
        coverImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(centerLabel.snp.top).offset(-15)
            $0.width.height.equalTo(74)
        }
        
        //
        let editPBtn = UIButton(type: .custom)
        editPBtn.layer.cornerRadius = 64/2
        editPBtn
            .backgroundColor(UIColor(hexString: "#D9FF66")!)
            .image("homepage_edit")
            .text("Create")
            .font(16, "AvenirNext-DemiBold")
            .titleColor(UIColor(hexString: "#454D3D")!)
            .clipsToBounds()
            .adhere(toSuperview: view)
        editPBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-120)
            $0.width.equalTo(311)
            $0.height.equalTo(64)
            
        }
        editPBtn.addTarget(self, action: #selector(editPBtnClick(sender: )), for: .touchUpInside)
         
        //
        let gridsBtn = UIButton(type: .custom)
        gridsBtn
            .backgroundImage(UIImage(named: "homepage_btn"))
            .image("homepage_grid")
            .text("Grids")
            .titleColor(UIColor(hexString: "#454D3D")!)
            .font(12, "AvenirNext-DemiBold")
            .adhere(toSuperview: view)
        gridsBtn.addTarget(self, action: #selector(gridsBtnClick(sender: )), for: .touchUpInside)
        gridsBtn.snp.makeConstraints {
            $0.left.equalTo(editPBtn.snp.left)
            $0.top.equalTo(editPBtn.snp.bottom).offset(16)
            $0.right.equalTo(editPBtn.snp.centerX)
            $0.height.equalTo(64)
            
        }
        //
        let captionBtn = UIButton(type: .custom)
        captionBtn
            .backgroundImage(UIImage(named: "homepage_btn-1"))
            .image("homepage_text")
            .text("Caption")
            .titleColor(UIColor(hexString: "#454D3D")!)
            .font(12, "AvenirNext-DemiBold")
            .adhere(toSuperview: view)
        captionBtn.addTarget(self, action: #selector(captionBtnClick(sender: )), for: .touchUpInside)
        captionBtn.snp.makeConstraints {
            $0.right.equalTo(editPBtn.snp.right)
            $0.top.equalTo(editPBtn.snp.bottom).offset(16)
            $0.left.equalTo(editPBtn.snp.centerX)
            $0.height.equalTo(64)
            
        }
    }

    @objc func settingBtnClick(sender: UIButton) {
        let vc = LPySettingV()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func storeBtnClick(sender: UIButton) {
        let vc = LPyStoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension LPyMainVC {
    @objc func editPBtnClick(sender: UIButton) {
        isEnterFrame = true
        checkAlbumAuthorization()
    }
    @objc func gridsBtnClick(sender: UIButton) {
        isEnterFrame = false
        checkAlbumAuthorization()
    }
    @objc func captionBtnClick(sender: UIButton) {
        let vc = LPyQuoteVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension LPyMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            DispatchQueue.main.async {
                                self.presentPhotoPickerController()
                            }
                        } else if status == PHAuthorizationStatus.limited {
                            DispatchQueue.main.async {
                                self.presentLimitedPhotoPickerController()
                            }
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
            } else {
                
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                        
                    case .restricted:
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                                DispatchQueue.main.async {
                                    let url = URL(string: UIApplication.openSettingsURLString)!
                                    UIApplication.shared.open(url, options: [:])
                                }
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alert.addAction(confirmAction)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true)
                        }
                    default: break
                    }
                }
                
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.isSquareByDefault = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        picker.navigationBar.backgroundColor = UIColor.white
//        self.navigationController?.pushViewController(picker, animated: true)
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        
        
        if isLock == true {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
            }
        } else {
            isLock = true
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                if self.isEnterFrame == true {
                    let vc = LPyCropVC(originalImg: image)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = LPySlideVC(originalImg: image)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

}



//class LPyMainBottomBtn: UIButton {
//    var iconStr = ""
//    var nameStr = ""
//
//    var iconImgV = UIImageView()
//    var nameLabel = UILabel()
//
//    init(frame: CGRect, name: String, icon: String) {
//        self.iconStr = icon
//        self.nameStr = name
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupView() {
//        iconImgV
//            .image(iconStr)
//            .adhere(toSuperview: self)
//        iconImgV.snp.makeConstraints {
//            $0.top.equalTo(0)
//            $0.centerY.equalToSuperview()
//            $0.width.height.equalTo(64)
//        }
//        //
//        nameLabel
//            .fontName(12, "AvenirNext")
//            .color(UIColor(hexString: ""))
//
//    }
//
//}





