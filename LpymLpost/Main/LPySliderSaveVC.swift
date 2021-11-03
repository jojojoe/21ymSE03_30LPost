//
//  LPySliderSaveVC.swift
//  LpymLpost
//
//  Created by JOJO on 2021/11/2.
//

import UIKit
import Photos

class LPySliderSaveVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    var shareBtn = UIButton(type: .custom)
    var saveBtn = UIButton(type: .custom)
    
    var images: [UIImage]
    var previewRects: [CGRect]
    
    init(images: [UIImage], rects: [CGRect]) {
        self.images = images
        self.previewRects = rects
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPreview()
    }
    
    func setupPreview() {
        for (ind, rct) in previewRects.enumerated() {
            let img = images[ind]
            let imgV = UIImageView(frame: rct)
            imgV.layer.borderColor = UIColor.white.cgColor
            imgV.layer.borderWidth = 0.5
            imgV
                .contentMode(.scaleAspectFill)
                .image(img)
                .adhere(toSuperview: view)
            
        }
        
    }
    
    func setupView() {
        view.backgroundColor(.white)
        
        backBtn
            .image(UIImage(named: "editor_arrow_left"))
            .adhere(toSuperview: view)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        shareBtn
            .image(UIImage(named: "editor_share"))
            .adhere(toSuperview: view)
        shareBtn.addTarget(self, action: #selector(shareBtnClick(sender: )), for: .touchUpInside)
        shareBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.width.height.equalTo(44)
        }
        
        //
        saveBtn
            .backgroundColor(UIColor(hexString: "#D9FF66")!)
            .text("Save")
            .font(16, "AvenirNext-DemiBold")
            .titleColor(UIColor(hexString: "#454D3D")!)
            .adhere(toSuperview: view)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            $0.height.equalTo(64)
            $0.width.equalTo(311)
            $0.centerX.equalToSuperview()
        }
        saveBtn.layer.cornerRadius = 32
        
        //
        
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        saveImgsToAlbum(imgs: self.images)
    }
    
    @objc func shareBtnClick(sender: UIButton) {
        let ac = UIActivityViewController(activityItems: self.images, applicationActivities: nil)
        ac.modalPresentationStyle = .fullScreen
        ac.completionWithItemsHandler = {
            (type, flag, array, error) -> Void in
            if flag == true {
                 
            } else {
                
            }
        }
        self.present(ac, animated: true, completion: nil)
    }
    
    
}



extension LPySliderSaveVC {
    
    
    func saveImgsToAlbum(imgs: [UIImage]) {
        HUD.hide()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            saveToAlbumPhotoAction(images: imgs)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({[weak self] (status) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    if status != .authorized {
                        return
                    }
                    self.saveToAlbumPhotoAction(images: imgs)
                }
            })
        } else {
            // 权限提示
            albumPermissionsAlet()
        }
    }
    
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.showSaveSuccessAlert()
                }
                
            }) { (finish, error) in
                if error != nil {
                    HUD.error("Sorry! please try again")
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        

        DispatchQueue.main.async {
            let title = ""
            let message = "Photo Storage Successful."
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okText, style: .cancel, handler: { (alert) in
                 DispatchQueue.main.async {
                 }
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func albumPermissionsAlet() {
        let alert = UIAlertController(title: "Ooops!", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] (actioin) in
            self?.openSystemAppSetting()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSystemAppSetting() {
        let url = NSURL.init(string: UIApplication.openSettingsURLString)
        let canOpen = UIApplication.shared.canOpenURL(url! as URL)
        if canOpen {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
 
}
