//
//  AlPLoginVC.swift
//  LpymLpost
//
//  Created by JOJO on 2021/11/10.
//

import Foundation
import FirebaseAuth
import FirebaseAuthUI
import Firebase
import AuthenticationServices
import DeviceKit
import SnapKit
import SwifterSwift

class APPleloGinVC: FUIAuthPickerViewController, FUIAuthDelegate {
    
    /*
    let ppUrl = "http://late-language.surge.sh/Privacy_Agreement.htm"
    let touUrl = "http://late-language.surge.sh/Terms_of_use.htm"
    */
    let def_fontName = ""
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var buttons: [UIButton] = []
    var collection: UICollectionView!
    let bgImageView = UIImageView()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findButtons(subView: self.view)
        setupView()
        
    }
    
    func findButtons(subView: UIView) {
        
        if subView.isKind(of: UIButton.classForCoder()) {
            if let button = subView as? UIButton {
                buttons.append(button)
            }
            return
        } else {
            subView.backgroundColor = .clear
        }
        
        for sv in subView.subviews {
            findButtons(subView: sv)
        }
    }
    
   
    
    @objc func appleButtonClick(button: UIButton) {
        let requestID = ASAuthorizationAppleIDProvider().createRequest()
                // 这里请求了用户的姓名和email
                requestID.requestedScopes = [.fullName, .email]
                
                let controller = ASAuthorizationController(authorizationRequests: [requestID])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
    }
    
    func customFont(fontName: String, size: CGFloat) -> UIFont {
        let stringArray: Array = fontName.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: stringArray[0], ofType: stringArray[1])
        let fontData = NSData.init(contentsOfFile: path ?? "")
        
        let fontdataProvider = CGDataProvider(data: CFBridgingRetain(fontData) as! CFData)
        let fontRef = CGFont.init(fontdataProvider!)!
        
        var fontError = Unmanaged<CFError>?.init(nilLiteral: ())
        CTFontManagerRegisterGraphicsFont(fontRef, &fontError)
        
        let fontName: String =  fontRef.postScriptName as String? ?? ""
        let font = UIFont(name: fontName, size: size)
        
        fontError?.release()
        
        return font ?? UIFont(name: def_fontName, size: size)!
    }
    
    /*
    @objc func buttonClick(button: UIButton) {
        
        switch button.tag {
            
        case 1001:
            let url = URL(string: ppUrl)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break
            
        case 1002:
            let url = URL(string: touUrl)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break

        default:
            break
        }
    }
    */
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
 
}

extension APPleloGinVC {
    func setupView() {
        view.backgroundColor = .black
        let topBgImgV = UIImageView()
        topBgImgV
            .image("")
            .backgroundColor(UIColor(hexString: "#D9FF66")!)
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        topBgImgV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        //
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
        let topContentV = UIView()
        topContentV
            .backgroundColor(.clear)
            .adhere(toSuperview: view)
        topContentV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-250)
        }
        
        
        //
        let appNLabe = UILabel()
        appNLabe
            .fontName(20, "AvenirNext-DemiBold")
            .adjustsFontSizeToFitWidth()
            .textAlignment(.center)
            .color(UIColor(hexString: "#454D3D")!)
            .text(AppName)
            .adhere(toSuperview: view)
            .numberOfLines(0)
        appNLabe.snp.makeConstraints {
            $0.top.equalTo(topContentV.snp.centerY).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(190)
            $0.height.greaterThanOrEqualTo(30)
        }
        //
        //
        let coverImgV = UIImageView()
        coverImgV
            .image("homepage_")
            .backgroundColor(UIColor.clear)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        coverImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(topContentV.snp.centerY)
            $0.width.height.equalTo(74)
        }
        
        //
        let bgBottomView = UIView()
        bgBottomView.backgroundColor = .clear
        view.addSubview(bgBottomView)
        bgBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-250)
        }
        
         
        
        //
        let googleButton = buttons[0]
        googleButton.layer.cornerRadius = 27
        googleButton.layer.masksToBounds = true
        googleButton.setTitle(" Sign in with Google", for: .normal)
        googleButton.setTitleColor(.white, for: .normal)
        googleButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 18)
        googleButton.frame = CGRect.zero
        googleButton.backgroundColor = UIColor(hexString: "#000000")
        googleButton.contentHorizontalAlignment = .center
        bgBottomView.addSubview(googleButton)
        googleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(54)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-76)
        }
        //
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
//        appleButton.backgroundColor = UIColor(hexString: "#454D3D")
        appleButton.layer.cornerRadius = 27
        appleButton.layer.masksToBounds = true
        appleButton.addTarget(self, action: #selector(appleButtonClick(button:)), for: .touchUpInside)
        bgBottomView.addSubview(appleButton)
        appleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(54)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(googleButton.snp.top).offset(-20)
        }
        
        
        // Do any additional setup after loading the view.
        
/*
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.centerX.equalTo(self.view)
        }
        
        let ppButton = UIButton()
        let str = NSMutableAttributedString(string: "Privacy Policy &")
        let strRange = NSRange.init(location: 0, length: str.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#FFFFFF")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: strRange)
        ppButton.setAttributedTitle(str, for: UIControl.State.normal)
        ppButton.contentHorizontalAlignment = .right
        ppButton.tag = 1001
        ppButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(ppButton)
        ppButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.left.equalTo(0)
        }
        
        let tou = UIButton()
        let toustr = NSMutableAttributedString(string: " Terms of Use")
        let toustrRange = NSRange.init(location: 0, length: toustr.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let tounumber = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        toustr.addAttributes([NSAttributedString.Key.underlineStyle: tounumber,
                              NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#FFFFFF")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: toustrRange)
        tou.setAttributedTitle(toustr, for: UIControl.State.normal)
        tou.contentHorizontalAlignment = .left
        tou.tag = 1002
        tou.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(tou)
        tou.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.right.equalTo(-2)
        }
 */
    }
}

extension APPleloGinVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 请求完成，但是有错误
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        // 请求完成， 用户通过验证
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 拿到用户的验证信息，这里可以跟自己服务器所存储的信息进行校验，比如用户名是否存在等。
            //                let detailVC = DetailVC(cred: credential)
            //                self.present(detailVC, animated: true, completion: nil)
            
            print(credential)
            APLoginMana.saveAppleUserIDAndUserName(userID: credential.user, userName: credential.email ?? "")
            self.dismiss(animated: true) {
            }
            
        } else {
            
        }
    }
}

extension APPleloGinVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
        
    }
}

  

 
