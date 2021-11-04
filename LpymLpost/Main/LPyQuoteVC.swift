//
//  LPyQuoteVC.swift
//  LpymLpost
//
//  Created by JOJO on 2021/11/2.
//

import UIKit

class LPyQuoteVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    var collection: UICollectionView!
    
    let unlockAlertView = LPlpyUnlockCoinView()
    var currentUnlockItem: IPyQuoteItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUnlockAlertView()
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
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(8)
            $0.right.left.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: LPyQuoteCell.self)
        
        
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
            
            if LPymCoinManagr.default.coinCount >= LPymCoinManagr.default.coinCostCount {
                DispatchQueue.main.async {
                    if let unlockStr = self.currentUnlockItem?.quoteId {
                        LPymCoinManagr.default.costCoin(coin: LPymCoinManagr.default.coinCostCount)
                        
                        LpyUnlockManager.default.unlock(itemId: unlockStr) {
                            DispatchQueue.main.async {
                                [weak self] in
                                guard let `self` = self else {return}
                                self.collection.reloadData()
                                self.copyCurrentQuote()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Insufficient coins, please buy first!", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
//                            self.navigationController?.pushViewController(LPyStoreVC())
                            self.present(LPyStoreVC(), animated: true, completion: nil)
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.unlockAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockItem = nil
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
                    self.currentUnlockItem = nil
                }
            }
        }
        
    }

    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func showUnlockAlertView(quoteItem: IPyQuoteItem) {
        self.currentUnlockItem = quoteItem
        if quoteItem.isPro == true, !LpyUnlockManager.default.hasUnlock(itemId: quoteItem.quoteId ?? "") {
            showUnlockunlockAlertView()
        } else {
            copyCurrentQuote()
        }
        
        
    }
    
    func copyCurrentQuote() {
        UIPasteboard.general.string = self.currentUnlockItem?.content ?? ""
        HUD.success("Copy Success!")
    }
}

extension LPyQuoteVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LPyQuoteCell.self, for: indexPath)
        let item = DataManager.default.quoteList[indexPath.item]
        cell.updateVipStatus(item: item)
        cell.copyBtnclickBlock = {
            [weak self] quoteI in
            guard let `self` = self else {return}
            if let quoteI_m = quoteI {
                self.showUnlockAlertView(quoteItem: quoteI_m)
            }
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.quoteList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LPyQuoteVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = DataManager.default.quoteList[indexPath.item]
        let str = item.content ?? ""
        let attr = NSAttributedString(string: str, attributes: [.font : UIFont(name: "AvenirNext-DemiBold", size: 20)])
        let width: CGFloat = UIScreen.main.bounds.width - 16 * 2 - 16 * 2
        let size = attr.boundingRect(with: CGSize(width: width, height: CGFloat.infinity), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
        
        
        return CGSize(width: UIScreen.main.bounds.width - 16 * 2, height: size.height + 16 + 72 + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension LPyQuoteVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class LPyQuoteCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let copyBtn = UIButton(type: .custom)
    let contelabel = UILabel()
    let copyLabel = UILabel()
    let coinImgV = UIImageView()
    var currentQuoteItem: IPyQuoteItem?
    
    var copyBtnclickBlock: ((IPyQuoteItem?)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        contentImgV
            .backgroundColor(UIColor(hexString: "#F7FAED")!)
        //
        
        contelabel
            .numberOfLines(0)
            .textAlignment(.center)
            .fontName(20, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#454D3D")!)
            .adhere(toSuperview: contentView)
        contelabel.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(16)
            $0.top.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.bottom.equalTo(contentView).offset(-72)
        }
        
        //
        copyBtn.layer.cornerRadius = 20
        copyBtn
            .backgroundColor(UIColor(hexString: "#D9FF66")!)
            .adhere(toSuperview: contentView)
        copyBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(96)
            $0.height.equalTo(40)
            $0.bottom.equalTo(contentView).offset(-16)
        }
        copyBtn.addTarget(self, action: #selector(copyBtnClick(sender: )), for: .touchUpInside)
        //

        copyLabel
            .fontName(16, "AvenirNext-DemiBold")
            .color(UIColor(hexString: "#454D3D")!)
            .text("Copy")
            .adhere(toSuperview: contentView)
        copyLabel.snp.makeConstraints {
            $0.centerY.equalTo(copyBtn.snp.centerY)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(25)
            $0.centerX.equalTo(copyBtn.snp.centerX)
        }
        //
        
        coinImgV
            .image("editor_coin")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        coinImgV.snp.makeConstraints {
            $0.centerY.equalTo(copyLabel)
            $0.width.height.equalTo(16)
            $0.left.equalTo(copyLabel.snp.right).offset(6)
        }
        
        //
        let cornerImgV = UIImageView()
        cornerImgV
            .image("editor_fold")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentView)
        cornerImgV.snp.makeConstraints {
            $0.right.bottom.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        
    }
    
    func updateVipStatus(item: IPyQuoteItem) {
        currentQuoteItem = item
        contelabel.text = item.content
        if item.isPro == true, !LpyUnlockManager.default.hasUnlock(itemId: item.quoteId ?? "") {
            copyLabel.snp.remakeConstraints {
                $0.centerY.equalTo(copyBtn.snp.centerY)
                $0.width.greaterThanOrEqualTo(1)
                $0.height.equalTo(25)
                $0.centerX.equalTo(copyBtn.snp.centerX).offset(-11)
            }
            coinImgV.isHidden = false
        } else {
            copyLabel.snp.remakeConstraints {
                $0.centerY.equalTo(copyBtn.snp.centerY)
                $0.width.greaterThanOrEqualTo(1)
                $0.height.equalTo(25)
                $0.centerX.equalTo(copyBtn.snp.centerX)
            }
            coinImgV.isHidden = true
        }
    }
    
    @objc func copyBtnClick(sender: UIButton) {
        copyBtnclickBlock?(currentQuoteItem)
    }
    
    
    
}





