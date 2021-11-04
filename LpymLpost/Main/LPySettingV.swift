//
//  LPySettingV.swift
//  LPymPost
//
//  Created by JOJO on 2021/10/28.
//

import UIKit
import SwifterSwift
import MessageUI



class LPySettingV: UIViewController {
    let privacyBtn = UIButton(type: .custom)
    let termsBtn = UIButton(type: .custom)
    let feedbackBtn = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        view
            .backgroundColor(UIColor(hexString: "#F2F2F2")!)
        view.clipsToBounds()
        //
        let topBgV = UIImageView()
        topBgV.backgroundColor(UIColor(hexString: "#D9FF66")!)
            .adhere(toSuperview: view)
        topBgV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY)
        }
        
        //
        let bgImgV = UIImageView()
        bgImgV
            .image("homepage_")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        bgImgV.snp.makeConstraints {
            $0.center.equalTo(topBgV)
            $0.width.height.equalTo(74)
        }
        //
        let nameLabel = UILabel()
        nameLabel
            .fontName(24, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#454D3D")!)
            .text(AppName)
            .adhere(toSuperview: view)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bgImgV.snp.bottom).offset(12)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        let backBtn = UIButton(type: .custom)
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
        let bottomBgV = UIView()
        bottomBgV.backgroundColor(UIColor(hexString: "#FFFFFF")!)
            .adhere(toSuperview: view)
        bottomBgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topBgV.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        //
        feedbackBtn
            .title("Feedback")
            .backgroundColor(UIColor(hexString: "#F7FAED")!)
            .titleColor(UIColor(hexString: "#454C3D")!)
            .font(16, "AvenirNext-DemiBold")
            .adhere(toSuperview: view)
        feedbackBtn.layer.cornerRadius = 64/2
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(311)
            $0.height.equalTo(64)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(bottomBgV)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        //
        privacyBtn
            .title("Privacy Policy")
            .backgroundColor(UIColor(hexString: "#F7FAED")!)
            .titleColor(UIColor(hexString: "#454C3D")!)
            .font(16, "AvenirNext-DemiBold")
            .adhere(toSuperview: view)
        privacyBtn.layer.cornerRadius = 64/2
        
        privacyBtn.snp.makeConstraints {
            $0.width.equalTo(311)
            $0.height.equalTo(64)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(feedbackBtn.snp.top).offset(-16)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        //
        termsBtn
            .title("Terms of use")
            .backgroundColor(UIColor(hexString: "#F7FAED")!)
            .titleColor(UIColor(hexString: "#454C3D")!)
            .font(16, "AvenirNext-DemiBold")
            .adhere(toSuperview: view)
        termsBtn.layer.cornerRadius = 64/2
        
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(311)
            $0.height.equalTo(64)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(16)
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        
    }
 
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func privacyBtnClick(sender: UIButton) {
//        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        let vc = HighLightingViewController(contentUrl: nil)
        vc.pushSaferiVC(url: PrivacyPolicyURLStr)
        
    }
    
    @objc func termsBtnClick(sender: UIButton) {
//        UIApplication.shared.openURL(url: TermsofuseURLStr)
        let vc = HighLightingViewController(contentUrl: nil)
        vc.pushSaferiVC(url: TermsofuseURLStr)
         
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    
}

extension LPySettingV: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
        controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
           
           //打开界面
        self.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}
