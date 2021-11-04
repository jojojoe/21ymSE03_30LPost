//
//  LPlpyUnlockCoinView.swift
//  LPymPost
//
//  Created by JOJO on 2021/10/28.
//

import UIKit


class LPlpyUnlockCoinView: UIView {

  
  var backBtnClickBlock: (()->Void)?
  var okBtnClickBlock: (()->Void)?
  
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .clear
      
      setupView()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  @objc func backBtnClick(sender: UIButton) {
      backBtnClickBlock?()
  }
  
  func setupView() {
      backgroundColor = UIColor.clear
      //
      var blurEffect = UIBlurEffect(style: .light)
      var blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = self.frame
      addSubview(blurEffectView)
      blurEffectView.snp.makeConstraints {
          $0.left.right.top.bottom.equalToSuperview()
      }
      
      //
      let bgBtn = UIButton(type: .custom)
      bgBtn
          .image(UIImage(named: ""))
          .adhere(toSuperview: self)
      bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
      bgBtn.snp.makeConstraints {
          $0.left.right.top.bottom.equalToSuperview()
      }
      
      //
      let contentV = UIView()
          .backgroundColor(.white)
          .adhere(toSuperview: self)
      contentV.layer.cornerRadius = 24
//      contentV.layer.masksToBounds = true
      contentV.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
      contentV.layer.shadowOffset = CGSize(width: 0, height: 0)
      contentV.layer.shadowRadius = 3
      contentV.layer.shadowOpacity = 0.8
      contentV.snp.makeConstraints {
          $0.centerX.equalToSuperview()
          $0.centerY.equalToSuperview().offset(0)
          $0.width.equalTo(327)
          $0.height.equalTo(412)
      }
      
      //
      let titLab = UILabel()
          .text("Paid Item.")
          .textAlignment(.center)
          .numberOfLines(0)
          .fontName(24, "AvenirNext-Bold")
          .color(UIColor(hexString: "#454D3D")!)
          .adhere(toSuperview: contentV)
      
      titLab.snp.makeConstraints {
          $0.centerX.equalToSuperview()
          $0.bottom.equalTo(contentV.snp.centerY).offset(-6)
          $0.left.equalToSuperview().offset(50)
          $0.height.greaterThanOrEqualTo(1)
      }
      //
      
      let titLab2 = UILabel()
          .text("Using paid item will cost \(LPymCoinManagr.default.coinCostCount) coins.")
          .textAlignment(.center)
          .numberOfLines(0)
          .fontName(16, "AvenirNext-Regular")
          .color(UIColor(hexString: "#454D3D")!.withAlphaComponent(0.6))
          .adhere(toSuperview: contentV)
      
      titLab2.snp.makeConstraints {
          $0.centerX.equalToSuperview()
          $0.top.equalTo(titLab.snp.bottom).offset(10)
          $0.left.equalToSuperview().offset(50)
          $0.height.greaterThanOrEqualTo(1)
      }
      //
       
      let coinImgV = UIImageView()
          .image("store_coin_big")
          .contentMode(.scaleAspectFit)
          .adhere(toSuperview: contentV)
      coinImgV.snp.makeConstraints {
          $0.centerX.equalToSuperview()
          $0.bottom.equalTo(titLab.snp.top).offset(-8)
          $0.width.height.equalTo(96)
      }
      //AvenirNext-DemiBold
      let okBtn = UIButton(type: .custom)
      okBtn.layer.cornerRadius = 32
      okBtn
          .backgroundColor(UIColor(hexString: "#D9FF66")!)
          .text("Yes")
          .font(16, "AvenirNext-DemiBold")
          .titleColor(UIColor(hexString: "#454C3D")!)
          .adhere(toSuperview: contentV)
      okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
      okBtn.snp.makeConstraints {
          $0.top.equalTo(titLab2.snp.bottom).offset(30)
          $0.right.equalTo(contentV.snp.right).offset(-32)
          $0.width.equalTo(123)
          $0.height.equalTo(64)
      }
      //
      let backBtn = UIButton(type: .custom)
      backBtn.layer.cornerRadius = 32
      backBtn
          .text("No")
          .backgroundColor(UIColor(hexString: "#F7FAED")!)
          .font(16, "AvenirNext-DemiBold")
          .titleColor(UIColor(hexString: "#454C3D")!)
          .adhere(toSuperview: contentV)
      
      backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
      
      backBtn.snp.makeConstraints {
          $0.top.equalTo(titLab2.snp.bottom).offset(30)
          $0.left.equalTo(contentV.snp.left).offset(32)
          $0.width.equalTo(123)
          $0.height.equalTo(64)
      }
      //
  }
  @objc func okBtnClick(sender: UIButton) {
      okBtnClickBlock?()
  }
}
