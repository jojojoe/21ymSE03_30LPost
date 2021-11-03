//
//  LPyBrightSliderBar.swift
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//

import UIKit

class LPyBrightSliderBar: UIView {
    let slider = UISlider()
    var sliderValuechangeBlock: ((CGFloat)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        slider.isContinuous = false
        slider.thumbTintColor = UIColor(hexString: "#454C3D")
        slider.minimumTrackTintColor = UIColor(hexString: "#DFFF66")
        slider.maximumTrackTintColor = UIColor(hexString: "#F5F5F5")
        slider.addTarget(self, action: #selector(sliderValueChange(sender: )), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.adhere(toSuperview: self)
        slider.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalTo(40)
            $0.height.equalTo(40)
        }
        
    }
    
    
    @objc func sliderValueChange(sender: UISlider)  {
        sliderValuechangeBlock?((CGFloat(sender.value)))
    }

}
