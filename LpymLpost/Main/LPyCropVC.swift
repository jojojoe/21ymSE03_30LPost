//
//  LPyCropVC.swift
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//

 
import UIKit
import Photos
//import HorizontalDial


class LPyCropVC: UIViewController {
     
    

    var originalImg: UIImage
    
    let backBtn = UIButton(type: .custom)
    let coinAlertView = LPlpyUnlockCoinView()
    var shouldCostCoin: Bool = false
    var collection: UICollectionView!
    let contentBgView = UIView()
//    var horizontalDial: HorizontalDial = HorizontalDial()
    let bottomBar = UIView()
    var currentSizeItem: IPyStickerItem? = DataManager.default.cropSizeList.first
    
    
    public lazy var photoView: IGRPhotoTweakView! = { [unowned self] by in
        
        let photoView = IGRPhotoTweakView(frame: self.contentBgView.bounds,
                                          image: self.originalImg,
                                          customizationDelegate: self)
        

        self.contentBgView.addSubview(photoView)
        
        return photoView
        }(())
    
    
    init(originalImg: UIImage) {
        self.originalImg = originalImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupThemes()
        setupUnlockAlertView()
        setupSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentBgView.sendSubviewToBack(self.photoView)
    }
     

}
//extension LPyCropVC: HorizontalDialDelegate {
//    func horizontalDialDidValueChanged(_ horizontalDial: HorizontalDial) {
//
//        let degrees = horizontalDial.value
//        let radians = IGRRadianAngle.toRadians(CGFloat(degrees))
//        let intDegrees: Int = Int(IGRRadianAngle.toDegrees(radians))
////        self.angleLabel?.text = "\(intDegrees)°"
//        self.photoView.changeAngle(radians: radians)
//    }
//
//    func horizontalDialDidEndScroll(_ horizontalDial: HorizontalDial) {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            [weak self] in
//            guard let `self` = self else {return}
//            DispatchQueue.main.async {
//                self.photoView.stopChangeAngle()
//            }
//
//        }
//
//    }
//}
extension LPyCropVC {
    
    func setupSubviews() {
//        horizontalDial.backgroundColor(UIColor.clear)
//        horizontalDial.minimumValue = -Double(IGRRadianAngle.toRadians(90))
//        horizontalDial.maximumValue = Double(IGRRadianAngle.toRadians(90))
//        horizontalDial.value = 0.0
//        horizontalDial.centerMarkColor = UIColor(hexString: "#EDDCBA")!
//        horizontalDial.centerMarkHeightRatio = 0.8
//        horizontalDial.markColor = UIColor.white.withAlphaComponent(0.5)
//        horizontalDial.markWidth = 1
//        horizontalDial.markCount = 30
//        horizontalDial.adhere(toSuperview: bottomBar)
//        horizontalDial.delegate = self
//        horizontalDial.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.left.equalTo(10)
//            $0.top.equalTo(collection.snp.bottom).offset(10)
//            $0.height.equalTo(40)
//        }
    }
    
    func setupThemes() {
        IGRPhotoTweakView.appearance().backgroundColor = UIColor(hexString: "#454C3D")!
        
        IGRPhotoContentView.appearance().backgroundColor = UIColor.clear
        IGRCropView.appearance().backgroundColor = UIColor.clear
        
        IGRCropGridLine.appearance().backgroundColor = UIColor(hexString: "#454C3D")!
        IGRCropLine.appearance().backgroundColor = UIColor(hexString: "#454C3D")!
        IGRCropCornerView.appearance().backgroundColor = UIColor.clear
        IGRCropCornerLine.appearance().backgroundColor = UIColor(hexString: "#454C3D")!
        IGRCropMaskView.appearance().backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
    
    func setupView() {
        view
            .backgroundColor(UIColor.white)
        view.clipsToBounds()
        //
        let bgImgV = UIImageView()
        bgImgV
//            .image("homepage_bg")
            .backgroundColor(UIColor.white)
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        
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
        let saveBtn = UIButton(type: .custom)
        saveBtn
            .text("Next")
            .backgroundColor(UIColor(hexString: "#D9FF66")!)
            .font(16, "AvenirNext-DemiBold")
            .titleColor(UIColor(hexString: "#454D3D")!)
            .adhere(toSuperview: view)
        saveBtn.layer.cornerRadius = 20
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender: )), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.right.equalTo(-10)
            $0.height.equalTo(40)
            $0.width.greaterThanOrEqualTo(96)
        }
        
        //
        
        bottomBar
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        bottomBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-88)
        }
        //
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        bottomBar.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(88)
        }
        collection.register(cellWithClass: IPmCropSizeCell.self)
        //
//        let rotateSlide = UISlider()
//        rotateSlide.maximumTrackTintColor = UIColor(hexString: "#FFFFFF")
//        rotateSlide.minimumTrackTintColor = UIColor(hexString: "#FFFFFF")
//        rotateSlide.setThumbImage(UIImage(named: ""), for: .normal)
//        rotateSlide.adhere(toSuperview: bottomBar)
//        rotateSlide.addTarget(self, action: #selector(rotateSlideChange(sender: )), for: .valueChanged)
//        rotateSlide.addTarget(self, action: #selector(onEndTouchAngleControl(sender: )), for: .touchUpInside)
//        rotateSlide.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.left.equalTo(40)
//            $0.top.equalTo(collection.snp.bottom).offset(10)
//            $0.height.equalTo(40)
//        }
//        rotateSlide.minimumValue = -Float(IGRRadianAngle.toRadians(90))
//        rotateSlide.maximumValue = Float(IGRRadianAngle.toRadians(90))
//        rotateSlide.value = 0.0
        
        //
        
        contentBgView
            .backgroundColor(UIColor.black.withAlphaComponent(0.5))
            .adhere(toSuperview: view)
        contentBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(4)
            $0.bottom.equalTo(bottomBar.snp.top).offset(0)
        }
        contentBgView.clipsToBounds()
        
    }
    
    
}

extension LPyCropVC {
    func resetView() {
        self.photoView.resetView()
        self.photoView.stopChangeAngle()
   }
    
    func cropAction() {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: self.photoView.radians)
        // scale
        
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        if let fixedImage = self.originalImg.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(transform,
                                                       zoomScale: self.photoView.scrollView.zoomScale,
                                                       sourceSize: self.originalImg.size,
                                                       cropSize: self.photoView.cropView.frame.size,
                                                       imageViewSize: self.photoView.photoContentView.bounds.size)
            
            let image = UIImage(cgImage: imageRef)
            
            debugPrint("result image = \(image)")
            let resizeImg = image.scaled(toWidth: 1500) ?? image
            
            let vc = LPlpyEditPhotoVC(originalImg: resizeImg)
            self.navigationController?.pushViewController(vc, animated: true)
            
            
//            saveToAlbumPhotoAction(images: [image])
        }
    }
}

extension LPyCropVC {
    func checkTopProAlertStatus() -> Bool {
        if let currentSize_m = currentSizeItem {
            return currentSize_m.isPro
        }
        return false
    }
    
    func updateCropSize(sizeStr: String) {
        if sizeStr == "Original" {
            self.photoView.resetAspectRect()
        } else {
            self.photoView.setCropAspectRect(aspect: sizeStr)
        }
        
    }
    
    
}

extension LPyCropVC {
    @objc func backBtnClick(sender: UIButton) {
        IPyymAddonManager.default.clearAddonManagerDefaultStatus()
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        if currentSizeItem?.isPro == true, !LpyUnlockManager.default.hasUnlock(itemId: currentSizeItem?.thumbName ?? "") {
            showUnlockCoinAlertView()
        } else {
            cropAction()
        }
        
    }
    @objc func rotateSlideChange(sender: UISlider) {
        let radians: CGFloat = CGFloat(sender.value)
        let intDegrees: Int = Int(IGRRadianAngle.toDegrees(radians))
//        self.angleLabel?.text = "\(intDegrees)°"
        self.photoView.changeAngle(radians: radians)
    }
    
    @objc func onEndTouchAngleControl(sender: UISlider) {
        self.photoView.stopChangeAngle()
    }
}


extension LPyCropVC {
    func setupUnlockAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }
    
    
    func showUnlockCoinAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
        
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if IPymCoinManager.default.coinCount >= IPymCoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    IPymCoinManager.default.costCoin(coin: IPymCoinManager.default.coinCostCount)
                    LpyUnlockManager.default.unlock(itemId: self.currentSizeItem?.thumbName ?? "") {
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.collection.reloadData()
                        }
                    }
                    
                    self.cropAction()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Not enough coins available, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.present(LPyStoreVC(), animated: true, completion: nil)
                            
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                 
            }
        }
        
        
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { _ in
                
            }
        }
    }
}

//extension LPyCropVC {
//    func saveToAlbumPhotoAction(images: [UIImage]) {
//        DispatchQueue.main.async(execute: {
//            PHPhotoLibrary.shared().performChanges({
//                [weak self] in
//                guard let `self` = self else {return}
//                for img in images {
//                    PHAssetChangeRequest.creationRequestForAsset(from: img)
//                }
//            }) { (finish, error) in
//                if finish {
//                    DispatchQueue.main.async {
//                        [weak self] in
//                        guard let `self` = self else {return}
//                        self.showSaveSuccessAlert()
//                        if self.shouldCostCoin {
//                            IPymCoinManager.default.costCoin(coin: IPymCoinManager.default.coinCostCount)
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        [weak self] in
//                        guard let `self` = self else {return}
//                        if error != nil {
//                            let auth = PHPhotoLibrary.authorizationStatus()
//                            if auth != .authorized {
//                                self.showDenideAlert()
//                            }
//                        }
//                    }
//                }
//            }
//        })
//    }
//
//    func showSaveSuccessAlert() {
//        HUD.success("Photo saved successful.")
//    }
//
//    func showDenideAlert() {
//        DispatchQueue.main.async {
//            [weak self] in
//            guard let `self` = self else {return}
//            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
//            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
//                DispatchQueue.main.async {
//                    let url = URL(string: UIApplication.openSettingsURLString)!
//                    UIApplication.shared.open(url, options: [:])
//                }
//            })
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//            alert.addAction(confirmAction)
//            alert.addAction(cancelAction)
//
//            self.present(alert, animated: true)
//        }
//    }
//
//}

extension LPyCropVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: IPmCropSizeCell.self, for: indexPath)
        let item = DataManager.default.cropSizeList[indexPath.item]
        cell.contentImgV.image(item.thumbName)
        
        if let currentSizeItem_m = currentSizeItem {
            if item.thumbName == currentSizeItem_m.thumbName {
                cell.contentImgV.image("\(item.thumbName ?? "")_selected")
            } else {
                cell.contentImgV.image(item.thumbName)
            }
        }

        if item.isPro == true, !LpyUnlockManager.default.hasUnlock(itemId: item.thumbName ?? "") {
            cell.proImgV.isHidden = false
        } else {
            cell.proImgV.isHidden = true
        }
            
         
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.cropSizeList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LPyCropVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - 15 * 2) / 5
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension LPyCropVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = DataManager.default.cropSizeList[indexPath.item]
        updateCropSize(sizeStr: item.bigName ?? "")
        currentSizeItem = item
        collectionView.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

extension LPyCropVC: IGRPhotoTweakViewCustomizationDelegate {
    func borderColor() -> UIColor {
        self.customBorderColor()
    }
    
    func borderWidth() -> CGFloat {
        self.customBorderWidth()
    }
    
    func cornerBorderWidth() -> CGFloat {
        self.customCornerBorderWidth()
    }
    
    func cornerBorderLength() -> CGFloat {
        self.customCornerBorderLength()
    }
    
    func cropLinesCount() -> Int {
        self.customCropLinesCount()
    }
    
    func gridLinesCount() -> Int {
        self.customGridLinesCount()
    }
    
    func isHighlightMask() -> Bool {
        self.customIsHighlightMask()
    }
    
    func highlightMaskAlphaValue() -> CGFloat {
        self.customHighlightMaskAlphaValue()
    }
    
    func canvasInsets() -> UIEdgeInsets {
        self.customCanvasInsets()
    }
    
    //MARK: - Customization
    
    open func customBorderColor() -> UIColor {
        return UIColor(hexString: "#454C3D")!
    }
    
    open func customBorderWidth() -> CGFloat {
        return 1.0
    }
    
    open func customCornerBorderWidth() -> CGFloat {
        return kCropViewCornerWidth
    }
    
    open func customCornerBorderLength() -> CGFloat {
        return kCropViewCornerLength
    }
    
    open func customCropLinesCount() -> Int {
        return kCropLinesCount
    }
    
    open func customGridLinesCount() -> Int {
        return kGridLinesCount
    }
    
    open func customIsHighlightMask() -> Bool {
        return false
    }
    
    open func customHighlightMaskAlphaValue() -> CGFloat {
        return 0.3
    }
    
    open func customCanvasInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: kCanvasHeaderHeigth, left: 0, bottom: 0, right: 0)
    }
}

class IPmCropSizeCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let proImgV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalTo(6)
        }
        //
        proImgV
            .image("editor_coin")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        proImgV.snp.makeConstraints {
            $0.top.right.equalTo(contentView)
            $0.width.height.equalTo(13)
        }
        
    }
}


