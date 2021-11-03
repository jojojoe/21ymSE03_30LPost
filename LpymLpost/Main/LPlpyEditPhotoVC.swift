//
//  LPlpyEditPhotoVC.swift
//  LPymPost
//
//  Created by JOJO on 2021/10/28.
//

import UIKit
import MaLiang
import Photos

class LPlpyEditPhotoVC: UIViewController {

    var originalImg: UIImage
    var filteredImg: UIImage
    let backBtn = UIButton(type: .custom)
    
    let bottomBar = UIView()
    let toolBar = UIView()
    let canvasBgView = UIView()
    let canvasImgV = UIImageView()
    let brushBgView = UIView()
    
    var canvasBrushView: Canvas!
    
    var toolBarViews: [UIView] = []
    var bottomBtns: [LPyEditPhotoBottomBtn] = []
    let filterBtn = LPyEditPhotoBottomBtn(frame: .zero, nameStr: "Filter")
    let stickerBtn = LPyEditPhotoBottomBtn(frame: .zero, nameStr: "Sticker")
    let brightBtn = LPyEditPhotoBottomBtn(frame: .zero, nameStr: "Bright")
    let contrastBtn = LPyEditPhotoBottomBtn(frame: .zero, nameStr: "Contrast")
    let graffitiBtn = LPyEditPhotoBottomBtn(frame: .zero, nameStr: "Graffiti")
    
    let filterBar = LPyFilterBar()
    let stickerBar = LPyStickerBar()
    let brightBar = LPyBrightSliderBar()
    let contrastBar = LPyBrightSliderBar()
    let graffitibar = LPyGraffitiBar()
    
    var currentBrightness: CGFloat = 0
    var currentContrast: CGFloat = 1
    var currentBurshColor: UIColor = UIColor.white
    
    var viewDidLayoutSubviewsOnce: Once = Once()
    let unlockAlertView = LPlpyUnlockCoinView()
    
    var currentUnlockFitlerName: String?
    var currentUnlockStickerItem: IPyStickerItem?
    
    init(originalImg: UIImage) {
        self.originalImg = originalImg
        self.filteredImg = originalImg
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setpuBtns()
        setupToolBars()
        setupUnlockAlertView()
        
        
        let aTapGR = UITapGestureRecognizer.init(target: self, action: #selector(editingHandlers))
        canvasBgView.addGestureRecognizer(aTapGR)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let Canvasheight: CGFloat = toolBar.frame.minY - backBtn.frame.maxY
        let Canvaswidth: CGFloat = UIScreen.main.bounds.width
        let imgWH = self.originalImg.size.width / self.originalImg.size.height
        let canvasWH = Canvaswidth / Canvasheight
        var fineW: CGFloat = Canvaswidth
        var fineH: CGFloat = Canvaswidth
        
        if imgWH > canvasWH {
            fineW = Canvaswidth
            fineH = Canvaswidth / imgWH
        } else {
            fineH = Canvasheight
            fineW = Canvasheight * imgWH
        }
        let topOffset: CGFloat = (Canvasheight - fineH) / 2
        
        canvasBgView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(fineW)
            $0.bottom.equalTo(toolBar.snp.top).offset(-topOffset)
            $0.top.equalTo(backBtn.snp.bottom).offset(topOffset)
        }
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            [weak self] in
            guard let `self` = self else {return}
            self.viewDidLayoutSubviewsOnce.run({
                self.setupCanvasBrushView()
                self.filterBtnClick(sender: self.filterBtn)
                
            })
        }
        
        

    }
    func setupUnlockAlertView() {
        
        unlockAlertView.alpha = 0
        view.addSubview(unlockAlertView)
        unlockAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }

    func showUnlockunlockAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.unlockAlertView.alpha = 1
        }
        
        unlockAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if IPymCoinManager.default.coinCount >= IPymCoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    
                    var unlockStr = ""
                    if let filtername = self.currentUnlockFitlerName {
                        unlockStr = filtername
                    } else if let stickeritem = self.currentUnlockStickerItem {
                        unlockStr = stickeritem.thumbName ?? ""
                    }
                    
                    IPymCoinManager.default.costCoin(coin: IPymCoinManager.default.coinCostCount)
                    
                    LpyUnlockManager.default.unlock(itemId: unlockStr) {
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            if let unlockSticker = self.currentUnlockStickerItem {
                                guard let stickerImage = UIImage(named: unlockSticker.bigName ?? "") else {return}
                                IPyymAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImage, stickerItem: unlockSticker, atView: self.canvasBgView)
                                self.stickerBar.collection.reloadData()
                            } else if let unlockFilterName = self.currentUnlockFitlerName {
                                self.actionProcessFilter(item: unlockFilterName)
                                self.filterBar.collection.reloadData()
                            }
                        }
                    }
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Insufficient coins, please buy at the store first !", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(LPyStoreVC())
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.unlockAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockStickerItem = nil
                    self.currentUnlockFitlerName = nil
                }
            }
        }
        
        
        unlockAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.unlockAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockStickerItem = nil
                    self.currentUnlockFitlerName = nil
                }
            }
        }
        
    }
    func setupCanvasBrushView() {
        
        self.canvasBrushView = Canvas(frame: CGRect(x: 0, y: 0, width: canvasBgView.bounds.width, height: canvasBgView.bounds.height))
        self.brushBgView.addSubview(self.canvasBrushView)
        self.canvasBrushView.backgroundColor = .clear
        self.canvasBrushView.data.addObserver(self)
        self.canvasBrushView.currentBrush.pointSize = CGFloat(2)
        self.canvasBrushView.currentBrush.pointStep = 0.5
 
        self.canvasBrushView.currentBrush.color = self.currentBurshColor
        self.canvasBrushView.currentBrush.use()
        
        
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
            .text("Save")
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
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(48)
        }
        //
        
        toolBar
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        toolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
            $0.height.equalTo(88)
        }
        //
        let contentBg = UIView()
        contentBg
            .backgroundColor(UIColor.clear)
            .adhere(toSuperview: view)
        contentBg.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom)
            $0.bottom.equalTo(toolBar.snp.top)
        }
        
        //
        canvasBgView
            .backgroundColor(UIColor.lightGray)
            .adhere(toSuperview: view)
            .clipsToBounds()
        canvasBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(15)
            $0.height.equalTo(UIScreen.main.bounds.width - 15 * 2)
            $0.centerY.equalTo(contentBg.snp.centerY)
        }
        //
        
        canvasImgV
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: canvasBgView)
        canvasImgV.snp.makeConstraints {
            $0.center.equalTo(canvasBgView)
            $0.left.top.equalTo(canvasBgView)
        }
        canvasImgV.image = originalImg
        
        //
        brushBgView
            .backgroundColor(.clear)
            .adhere(toSuperview: canvasBgView)
        brushBgView.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(canvasImgV)
        }
        
    }
    
    func setpuBtns() {
        bottomBtns = [filterBtn, stickerBtn, brightBtn, contrastBtn, graffitiBtn]
         
        
        filterBtn.adhere(toSuperview: bottomBar)
        stickerBtn.adhere(toSuperview: bottomBar)
        brightBtn.adhere(toSuperview: bottomBar)
        contrastBtn.adhere(toSuperview: bottomBar)
        graffitiBtn.adhere(toSuperview: bottomBar)
        
        filterBtn.addTarget(self, action: #selector(filterBtnClick(sender:)), for: .touchUpInside)
        stickerBtn.addTarget(self, action: #selector(stickerBtnClick(sender:)), for: .touchUpInside)
        brightBtn.addTarget(self, action: #selector(brightBtnClick(sender:)), for: .touchUpInside)
        contrastBtn.addTarget(self, action: #selector(contrastBtnClick(sender:)), for: .touchUpInside)
        graffitiBtn.addTarget(self, action: #selector(graffitiBtnClick(sender:)), for: .touchUpInside)
        
        
        let btnWidth: CGFloat = UIScreen.main.bounds.width / 5
        let btnHeight: CGFloat = 44
        
        filterBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalToSuperview()
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        stickerBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalTo(filterBtn.snp.right).offset(0)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        brightBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalTo(stickerBtn.snp.right).offset(0)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        contrastBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalTo(brightBtn.snp.right).offset(0)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        graffitiBtn.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalTo(contrastBtn.snp.right).offset(0)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(btnHeight)
        }
        
        
        
        
    }
    
    func actionProcessFilter(item: String) {
        let resultImg = FilterDataTool.pictureProcessData(self.originalImg, matrixName: item)
            
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.filteredImg = resultImg
            self.updateContentImgVStatus()
            
        }
        
    }
    
    func setupToolBars() {
        toolBarViews = [filterBar, stickerBar, brightBar, contrastBar, graffitibar]
        
         
        filterBar.originImg = self.originalImg.scaled(toWidth: 120)
        filterBar.adhere(toSuperview: toolBar)
        filterBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        filterBar.filterDidSelectBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            
            if LpyUnlockManager.default.hasUnlock(itemId: item) {
                self.actionProcessFilter(item: item)
                
            } else {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.currentUnlockFitlerName = item
                    self.currentUnlockStickerItem = nil
                    self.showUnlockunlockAlertView()
                    
                }
                
            }
            
        }
        
        
        stickerBar.adhere(toSuperview: toolBar)
        stickerBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        stickerBar.stickerDidSelectBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            guard let stickerImage = UIImage(named: item.bigName ?? "") else {return}
            
            if item.isPro == true , !LpyUnlockManager.default.hasUnlock(itemId: item.thumbName ?? "") {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.currentUnlockFitlerName = nil
                    self.currentUnlockStickerItem = item
                    self.showUnlockunlockAlertView()
                    
                }
            } else {
                DispatchQueue.main.async {
                    IPyymAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImage, stickerItem: item, atView: self.canvasBgView)
                }
                
            }
        }
        
        //
        
        brightBar.adhere(toSuperview: toolBar)
        brightBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        brightBar.sliderValuechangeBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.currentBrightness = item / 3
                self.updateContentImgVStatus()
            }
        }
        
        //
        contrastBar.adhere(toSuperview: toolBar)
        contrastBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        contrastBar.sliderValuechangeBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                self.currentContrast = (1 + item)
                self.updateContentImgVStatus()
            }
        }
        
        //
        
        graffitibar.adhere(toSuperview: toolBar)
        graffitibar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        graffitibar.sizeSliderValuechangeBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            self.canvasBrushView.currentBrush.pointSize = item * 10 + 2
        }
        graffitibar.colorSliderValuechangeBlock = {
            [weak self] color in
            guard let `self` = self else {return}
            self.canvasBrushView.currentBrush.color = color
        }
        graffitibar.clearBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            self.canvasBrushView.clear()
        }
        //
        filterBar.isHidden = true
        stickerBar.isHidden = true
        brightBar.isHidden = true
        contrastBar.isHidden = true
        graffitibar.isHidden = true
    }
  
    
    func updateContentImgVStatus() {
        
        let img = self.filteredImg
        DispatchQueue.global().async {
            let context = CIContext(options: nil)
            let superImage = CIImage(image: img)
            let lighten = CIFilter(name: "CIColorControls")
            lighten?.setValue(superImage, forKey: kCIInputImageKey)
            lighten?.setValue(self.currentBrightness, forKey: "inputBrightness")
            lighten?.setValue(self.currentContrast, forKey: "inputContrast")
            if let result = lighten?.value(forKey: kCIOutputImageKey) as? CIImage, let fromeRect = superImage?.extent, let cgImage = context.createCGImage(result, from: fromeRect) {
                
                let myImg = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    self.canvasImgV.image = myImg
                }
                
            }
        }
        
    }
    
}

extension LPlpyEditPhotoVC {
    @objc func filterBtnClick(sender: LPyEditPhotoBottomBtn) {
        showToolBar(btn: filterBtn, toolView: filterBar)
    }
    @objc func stickerBtnClick(sender: LPyEditPhotoBottomBtn) {
        showToolBar(btn: stickerBtn, toolView: stickerBar)
    }
    @objc func brightBtnClick(sender: LPyEditPhotoBottomBtn) {
        showToolBar(btn: brightBtn, toolView: brightBar)
    }
    @objc func contrastBtnClick(sender: LPyEditPhotoBottomBtn) {
        showToolBar(btn: contrastBtn, toolView: contrastBar)
    }
    @objc func graffitiBtnClick(sender: LPyEditPhotoBottomBtn) {
        showToolBar(btn: graffitiBtn, toolView: graffitibar)
    }
    
    @objc func editingHandlers() {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
    }
    
    func showToolBar(btn: LPyEditPhotoBottomBtn, toolView: UIView) {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
        
        for btn_m in bottomBtns {
            if btn == btn_m {
                btn_m.isCurrentSelect(isSelect: true)
            } else {
                btn_m.isCurrentSelect(isSelect: false)
            }
        }
        for toolView_m in toolBarViews {
            if toolView_m == toolView {
                toolView_m.isHidden = false
            } else {
                toolView_m.isHidden = true
            }
        }
        
        if btn == graffitiBtn {
            brushBgView.isUserInteractionEnabled = true
        } else {
            brushBgView.isUserInteractionEnabled = false
        }
        
    }
}

extension LPlpyEditPhotoVC {
    @objc func backBtnClick(sender: UIButton) {
        IPyymAddonManager.default.clearAddonManagerDefaultStatus()
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        IPyymAddonManager.default.cancelCurrentAddonHilightStatus()
        
        UIGraphicsBeginImageContextWithOptions(canvasBgView.bounds.size, false, UIScreen.main.scale)
        
         self.canvasBgView.drawHierarchy(in: canvasBgView.bounds, afterScreenUpdates: true)
        let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        if let img = screenShotImage {
            saveImgsToAlbum(imgs: [img])
        }
        
    }
    
}

extension LPlpyEditPhotoVC {
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

extension LPlpyEditPhotoVC: DataObserver {
    /// called when a line strip is begin
    func lineStrip(_ strip: LineStrip, didBeginOn data: CanvasData) {
//        self.redoButton.isEnabled = false
    }
    
    /// called when a element is finished
    func element(_ element: CanvasElement, didFinishOn data: CanvasData) {
//        self.undoButton.isEnabled = true
    }
    
    /// callen when clear the canvas
    func dataDidClear(_ data: CanvasData) {
        
    }
    
    /// callen when undo
    func dataDidUndo(_ data: CanvasData) {
//        self.undoButton.isEnabled = true
//        self.redoButton.isEnabled = data.canRedo
    }
    
    /// callen when redo
    func dataDidRedo(_ data: CanvasData) {
//        self.undoButton.isEnabled = true
//        self.redoButton.isEnabled = data.canRedo
    }
}



class LPyEditPhotoBottomBtn: UIButton {
    var nameStr: String
    let nameLabel = UILabel()
    let pointV = UIView()
    
    init(frame: CGRect, nameStr: String) {
        self.nameStr = nameStr
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {

        nameLabel
            .fontName(14, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#454C3D")!)
            .text(nameStr)
            .adjustsFontSizeToFitWidth()
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-4)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        
        pointV.backgroundColor(UIColor(hexString: "#454C3D")!)
            .adhere(toSuperview: self)
        pointV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.width.height.equalTo(4)
        }
        pointV.layer.cornerRadius = 2
        
    }
    
    func isCurrentSelect(isSelect: Bool) {
        if isSelect == true {
            nameLabel
                .color(UIColor(hexString: "#454C3D")!)
            pointV.isHidden = false
        } else {
            nameLabel
                .color(UIColor(hexString: "#454C3D")!.withAlphaComponent(0.5))
            pointV.isHidden = true
        }
    }
    
}
