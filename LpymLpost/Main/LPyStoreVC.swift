//
//  LPyStoreVC.swift
//  LPymPost
//
//  Created by JOJO on 2021/10/28.
//

 
import UIKit
import NoticeObserveKit
import ZKProgressHUD

class LPyStoreVC: UIViewController {
    private var pool = Notice.ObserverPool()
    var collection: UICollectionView!
    let topCoinLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupView()
        addNotificationObserver()
        
    }
    
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = ( "\(LPymCoinManagr.default.coinCount)")
            }
        }
        .invalidated(by: pool)
        
    }
    
    
    func setupView() {
        view
            .backgroundColor(UIColor(hexString: "#F2F2F2")!)
        view.clipsToBounds()
        //
        let bgImgV = UIImageView()
        bgImgV
            .image("homepage_bg")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        let backBtn = UIButton(type: .custom)
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "editor_arrow_left"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        let restoreBtn = UIButton(type: .custom)
        restoreBtn
            .backgroundColor(UIColor(hexString: "#FFD966")!)
            .titleColor(UIColor(hexString: "#454D3D")!)
            .font(20, "AvenirNext-DemiBold")
            .text("Restore")
            .adhere(toSuperview: view)
        restoreBtn.layer.cornerRadius = 20
        restoreBtn.addTarget(self, action: #selector(restoreBtnClick(sender:)), for: .touchUpInside)
        restoreBtn.snp.makeConstraints {
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.right.equalTo(-10)
            $0.width.equalTo(96)
            $0.height.equalTo(40)
        }
        
         
        //
        let iconImgV = UIImageView()
        iconImgV
            .image("store_coin_big")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(20)
            $0.width.height.equalTo(96)
        }
        
        //
        
        topCoinLabel
            .color(UIColor(hexString: "#454D3D")!)
            .text("\(LPymCoinManagr.default.coinCount)")
            .fontName(16, "AvenirNext-DemiBold")
            .adhere(toSuperview: view)
        topCoinLabel.snp.makeConstraints {
            $0.top.equalTo(iconImgV.snp.bottom).offset(10)
            $0.centerX.equalTo(iconImgV.snp.centerX)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
         
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: LPyStoreCell.self)
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
    
    @objc func restoreBtnClick(sender: UIButton) {
        ZKProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            ZKProgressHUD.dismiss()
            ZKProgressHUD.showSuccess("Restore Success", autoDismissDelay: 1)
        }
    }
    

}


extension LPyStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LPyStoreCell.self, for: indexPath)
        let item = LPymCoinManagr.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "x \(item.coin)"
        if let localPrice = item.localPrice {
            cell.priceLabel.text = item.localPrice
        } else {
            cell.priceLabel.text = "$\(item.price)"
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LPymCoinManagr.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LPyStoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let cellwidth: CGFloat = UIScreen.main.bounds.width - (16 * 2)
        let cellHeight: CGFloat = 88
        
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = 16
        return UIEdgeInsets(top: 20, left: left, bottom: 20, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 15
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 15
        return padding
    }
    
}

extension LPyStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = LPymCoinManagr.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func selectCoinItem(item: IPyStoreItem) {
        // core
        
        PurchaseManagerLink.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                ZKProgressHUD.showSuccess("Purchase successful.")
            } else {
                ZKProgressHUD.showError("Purchase failed.")
            }
        }
        //
        
//        LPymCoinManagr.default.purchaseIapId(item: item) { (success, errorString) in
//
//            if success {
//                ZKProgressHUD.showSuccess("Purchase successful.")
//            } else {
//                ZKProgressHUD.showError("Purchase failed.")
//            }
//        }
    }
    
}

class LPyStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var iconImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var priceBgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor =  UIColor(hexString: "#F7FAED")
        bgView.backgroundColor = UIColor.clear
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        iconImageV.backgroundColor = .clear
        iconImageV.contentMode = .scaleAspectFit
        iconImageV.image = UIImage(named: "store_coin")
        contentView.addSubview(iconImageV)
        iconImageV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(24)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
            
        }
         
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel
            .color(UIColor(hexString: "#454D3D")!)
            .numberOfLines(1)
            .fontName(16, "AvenirNext-DemiBold")
            .textAlignment(.left)
            .adhere(toSuperview: bgView)

        coinCountLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageV.snp.right).offset(13)
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        
        //
        bgView.addSubview(priceBgImgV)
        priceBgImgV
            .backgroundColor(UIColor(hexString: "#D9FF66")!)
            .contentMode(.scaleToFill)
            .image("Subtract")
//        priceBgImgV.layer.cornerRadius = 8
//        priceBgImgV.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
//        priceBgImgV.layer.shadowOffset = CGSize(width: 0, height: 2)
//        priceBgImgV.layer.shadowRadius = 2
//        priceBgImgV.layer.shadowOpacity = 0.8
//
        
        priceBgImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-24)
            $0.width.equalTo(187/2)
            $0.height.equalTo(40)
        }
        priceBgImgV.layer.cornerRadius = 20
        //
        priceLabel.textColor = UIColor(hexString: "#454D3D")
        priceLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints {
            $0.center.equalTo(priceBgImgV)
            $0.height.greaterThanOrEqualTo(22)
            $0.left.equalTo(priceBgImgV.snp.left).offset(6)
        }
        
        //
//        let bottomLine = UIView()
//        bottomLine
//            .backgroundColor(UIColor(hexString: "#EDDCBA")!)
//            .adhere(toSuperview: contentView)
//        bottomLine.snp.makeConstraints {
//            $0.left.equalTo(56)
//            $0.bottom.equalToSuperview()
//            $0.centerX.equalToSuperview()
//            $0.height.equalTo(0.5)
//        }
        
    }
     
}

