//
//  LPySlideVC.swift
//  LpymLpost
//
//  Created by JOJO on 2021/11/2.
//

import UIKit


class LPySlideVC: UIViewController {

    var originalImg: UIImage
    
    let backBtn = UIButton(type: .custom)
    let bottomBar = UIView()
    let slide1_3 = LPySliderTypeBtn(frame: .zero, typeItem: .slider1_3)
    let slide2_3 = LPySliderTypeBtn(frame: .zero, typeItem: .slider2_3)
    let slide3_3 = LPySliderTypeBtn(frame: .zero, typeItem: .slider3_3)
    let canvasBgView = UIView()
    var viewDidLayoutSubviewsOnce: Once = Once()
    var slideView: LPySliderView?
    
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
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let Canvasheight: CGFloat = bottomBar.frame.minY - backBtn.frame.maxY
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
        debugPrint("layout did")
        debugPrint("layout did fineW = \(fineW)")
        debugPrint("layout did fineH = \(fineH)")
        canvasBgView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(fineW)
            $0.bottom.equalTo(bottomBar.snp.top).offset(-topOffset)
            $0.top.equalTo(backBtn.snp.bottom).offset(topOffset)
        }
        
        //
        viewDidLayoutSubviewsOnce.run {
            DispatchQueue.main.async {
                let slideView = LPySliderView(frame: CGRect(x: 0, y: 0, width: fineW, height: fineH), contentImage: self.originalImg)
                self.slideView = slideView
                slideView.adhere(toSuperview: self.canvasBgView)
                slideView.updateSliderStyle(sliderType: .slider1_3)
                self.slide1_3.setupSelecStatus(isSele: true)
            }
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
            $0.height.equalTo(136)
        }
        
        
        
        slide1_3.adhere(toSuperview: bottomBar)
        slide2_3.adhere(toSuperview: bottomBar)
        slide3_3.adhere(toSuperview: bottomBar)
        
        slide1_3.layer.cornerRadius = 8
        slide2_3.layer.cornerRadius = 8
        slide3_3.layer.cornerRadius = 8
        
        let btnWidth: CGFloat = 104
        let offseta: CGFloat = (UIScreen.main.bounds.width - (btnWidth * 3)) / 4
        
        slide1_3.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalTo(bottomBar).offset(offseta)
            $0.width.height.equalTo(btnWidth)
        }
        slide2_3.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalTo(slide1_3.snp.right).offset(offseta)
            $0.width.height.equalTo(btnWidth)
        }
        slide3_3.snp.makeConstraints {
            $0.centerY.equalTo(bottomBar)
            $0.left.equalTo(slide2_3.snp.right).offset(offseta)
            $0.width.height.equalTo(btnWidth)
        }
        
        
        slide1_3.addTarget(self, action: #selector(slide1_3Click(sender: )), for: .touchUpInside)
        slide2_3.addTarget(self, action: #selector(slide2_3Click(sender: )), for: .touchUpInside)
        slide3_3.addTarget(self, action: #selector(slide3_3Click(sender: )), for: .touchUpInside)
        
        //
        canvasBgView
            .backgroundColor(UIColor.lightGray)
            .adhere(toSuperview: view)
            .clipsToBounds()
        canvasBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(15)
            $0.height.equalTo(UIScreen.main.bounds.width - 15 * 2)
            $0.centerY.equalTo(view.snp.centerY)
        }
        //
        
    }
    
    
     
    
}

extension LPySlideVC {
    
}

extension LPySlideVC {
    @objc func slide1_3Click(sender: LPySliderTypeBtn) {
        slide1_3.setupSelecStatus(isSele: true)
        slide2_3.setupSelecStatus(isSele: false)
        slide3_3.setupSelecStatus(isSele: false)
        slideView?.updateSliderStyle(sliderType: .slider1_3)
    }
    @objc func slide2_3Click(sender: LPySliderTypeBtn) {
        slide2_3.setupSelecStatus(isSele: true)
        slide1_3.setupSelecStatus(isSele: false)
        slide3_3.setupSelecStatus(isSele: false)
        slideView?.updateSliderStyle(sliderType: .slider2_3)
    }
    @objc func slide3_3Click(sender: LPySliderTypeBtn) {
        slide3_3.setupSelecStatus(isSele: true)
        slide2_3.setupSelecStatus(isSele: false)
        slide1_3.setupSelecStatus(isSele: false)
        slideView?.updateSliderStyle(sliderType: .slider3_3)
    }
    
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        if let imgs = slideView?.processSlideImages(), let areas = slideView?.sliderAreaViews {
            var rec: [CGRect] = []
            
            for area in areas {
                if let rect = self.slideView?.convert(area.frame, to: view) {
                    rec.append(rect)
                }
                
            }
            let vc = LPySliderSaveVC(images: imgs, rects: rec)
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
}



class LPySliderTypeBtn: UIButton {
    let iconImageV = UIImageView()
    let nameLabel = UILabel()
    
    var sliderType: SliderType = .slider1_3
    
    init(frame: CGRect, typeItem: SliderType) {
        sliderType = typeItem
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        var iconName: String = ""
        var name: String = ""
        switch sliderType {
        case .slider1_3:
            iconName = "editor_girds1"
            name = "1x3"
        case .slider2_3:
            iconName = "editor_girds2"
            name = "2x3"
        case .slider3_3:
            iconName = "editor_girds3"
            name = "3x3"
        }
        //
        nameLabel
            .textAlignment(.center)
            .text(name)
            .fontName(16, "AvenirNext-Regular")
            .color(UIColor(hexString: "#454D3D")!)
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        iconImageV
            .image(iconName)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self)
        iconImageV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top).offset(-6)
            $0.width.height.equalTo(37)
        }
        setupSelecStatus(isSele: false)
    }
    
    func setupSelecStatus(isSele: Bool) {
        if isSele {
            self.backgroundColor(UIColor(hexString: "#D9FF66")!)
        } else {
            self.backgroundColor(UIColor(hexString: "#F7FAED")!)
        }
    }
    
    
}

