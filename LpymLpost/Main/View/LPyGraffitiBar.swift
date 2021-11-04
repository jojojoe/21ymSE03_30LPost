//
//  LPyGraffitiBar.swift
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//

import UIKit


class LPyGraffitiBar: UIView {
    let sizeSlider = UISlider()
    var sizeSliderValuechangeBlock: ((CGFloat)->Void)?
    let colorSlider = UISlider()
    var colorSliderValuechangeBlock: ((UIColor)->Void)?
    let colorSliderImage = UIImage(named: "editor_color")
    var clearBtnClickBlock: (()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let sizeLabel = UILabel()
        sizeLabel
            .fontName(16, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#454D3D")!)
            .text("Size")
            .textAlignment(.left)
            .adhere(toSuperview: self)
        sizeLabel.snp.makeConstraints {
            $0.bottom.equalTo(snp.centerY).offset(-6)
            $0.left.equalTo(16)
            $0.width.equalTo(50)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let colorLabel = UILabel()
        colorLabel
            .fontName(16, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#454D3D")!)
            .textAlignment(.left)
            .text("Color")
            .adhere(toSuperview: self)
        colorLabel.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(6)
            $0.left.equalTo(16)
            $0.width.equalTo(50)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        let clearBtn = UIButton(type: .custom)
        clearBtn.adhere(toSuperview: self)
        clearBtn
            .backgroundColor(UIColor(hexString: "#F7FAED")!)
            .clipsToBounds()
            .image("editor_brush")
        clearBtn.layer.cornerRadius = 8
        clearBtn.addTarget(self, action: #selector(clearBtnClick(sender: )), for: .touchUpInside)
        clearBtn.snp.makeConstraints {
            $0.right.equalTo(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        
        //
        sizeSlider.thumbTintColor = UIColor(hexString: "#454C3D")
        sizeSlider.minimumTrackTintColor = UIColor(hexString: "#DFFF66")
        sizeSlider.maximumTrackTintColor = UIColor(hexString: "#F5F5F5")
        sizeSlider.addTarget(self, action: #selector(sliderValueChange(sender: )), for: .valueChanged)
        sizeSlider.minimumValue = 0
        sizeSlider.maximumValue = 1
        sizeSlider.value = 0
        sizeSlider.adhere(toSuperview: self)
        sizeSlider.snp.makeConstraints {
            $0.centerY.equalTo(sizeLabel.snp.centerY)
            $0.left.equalTo(sizeLabel.snp.right).offset(25)
            $0.right.equalTo(clearBtn.snp.left).offset(-24)
            $0.height.equalTo(40)
        }
        
        //
        colorSlider.thumbTintColor = UIColor(hexString: "#454C3D")
        colorSlider.setMaximumTrackImage(colorSliderImage, for: .normal)
        colorSlider.setMinimumTrackImage(colorSliderImage, for: .normal)
        colorSlider.minimumValue = 0
        colorSlider.maximumValue = 1
        colorSlider.value = 0
        colorSlider.adhere(toSuperview: self)
        colorSlider.snp.makeConstraints {
            $0.centerY.equalTo(colorLabel.snp.centerY)
            $0.left.equalTo(colorLabel.snp.right).offset(25)
            $0.right.equalTo(clearBtn.snp.left).offset(-24)
            $0.height.equalTo(40)
        }
        colorSlider.addTarget(self, action: #selector(colorSliderValueChange(sender: )), for: .touchUpInside)
    }
    
    
    @objc func sliderValueChange(sender: UISlider)  {
        
        sizeSliderValuechangeBlock?((CGFloat(sender.value)))
    }
    
    @objc func colorSliderValueChange(sender: UISlider)  {
        
        let x = (398/2) * CGFloat(sender.value)
        let point = CGPoint(x: x, y: 3)
        if let imgColor = cxg_getPointColor(withImage: colorSliderImage!, point: point) {
            colorSliderValuechangeBlock?(imgColor)
        }
        
    }

    @objc func clearBtnClick(sender: UIButton) {
        clearBtnClickBlock?()
    }
    
}

extension LPyGraffitiBar {
    
    func cxg_getPointColor(withImage image: UIImage, point: CGPoint) -> UIColor? {
        
        guard CGRect(origin: CGPoint(x: 0, y: 0), size: image.size).contains(point) else {
            return nil
        }
        
        if point.x == 0 {
            return UIColor.white
        }
        
        let pointX = trunc(point.x);
        let pointY = trunc(point.y);
        
        let width = image.size.width;
        let height = image.size.height;
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        pixelData.withUnsafeMutableBytes { pointer in
            if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let cgImage = image.cgImage {
                context.setBlendMode(.copy)
                context.translateBy(x: -pointX, y: pointY - height)
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        }
        
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        
        
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return UIColor(r: red, g: green, b: blue, a: alpha)
        }
    }
}

/*
public extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
*/
