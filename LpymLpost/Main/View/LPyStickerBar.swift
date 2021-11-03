//
//  LPyStickerBar.swift
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//

import UIKit

class LPyStickerBar: UIView {

    var collection: UICollectionView!
    var currentStickerItem: IPyStickerItem?
    var stickerDidSelectBlock: ((IPyStickerItem)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: LPyStickerCell.self)
    }

}

extension LPyStickerBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LPyStickerCell.self, for: indexPath)
        
        let sticker = DataManager.default.stickerList[indexPath.item]
         
        cell.contentImgV.image(sticker.thumbName)
        
        if sticker.isPro == true, !LpyUnlockManager.default.hasUnlock(itemId: sticker.thumbName ?? "") {
            cell.proImgV.isHidden = false
        } else {
            cell.proImgV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LPyStickerBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension LPyStickerBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sticker = DataManager.default.stickerList[indexPath.item]
        stickerDidSelectBlock?(sticker)
        currentStickerItem = sticker
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


 
class LPyStickerCell: UICollectionViewCell {
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
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        //
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(56)
        }
        
        //
        proImgV
            .image("editor_coin")
            .adhere(toSuperview: contentView)
        proImgV.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(2)
            $0.right.equalTo(contentView.snp.right).offset(-2)
            $0.width.height.equalTo(16)
        }
    }
}




