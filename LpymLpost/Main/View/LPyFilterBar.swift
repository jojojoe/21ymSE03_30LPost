//
//  LPyFilterBar.swift
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//

import UIKit

class LPyFilterBar: UIView {
    var collection: UICollectionView!
    var originImg: UIImage?
    var currentFilterName: String?
    var filterDidSelectBlock: ((String)->Void)?
    
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
        collection.register(cellWithClass: LPyFilterCell.self)
    }

}

extension LPyFilterBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LPyFilterCell.self, for: indexPath)
        let filterName = DataManager.default.filterNameList[indexPath.item]
        if let originImg_m = originImg {
            let resultImg = FilterDataTool.pictureProcessData(originImg_m, matrixName: filterName)
            cell.contentImgV.image = resultImg
        }
        if currentFilterName == filterName {
            cell.selectV.isHidden = false
        } else {
            cell.selectV.isHidden = true
        }
        if !LpyUnlockManager.default.hasUnlock(itemId: filterName) {
            cell.proImgV.isHidden = false
        } else {
            cell.proImgV.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.filterNameList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension LPyFilterBar: UICollectionViewDelegateFlowLayout {
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

extension LPyFilterBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = DataManager.default.filterNameList[indexPath.item]
        filterDidSelectBlock?(name)
        currentFilterName = name
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


 
class LPyFilterCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectV = UIView()
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
            $0.top.right.bottom.left.equalToSuperview()
        }
        //
        selectV
            .backgroundColor(.clear)
            .adhere(toSuperview: contentView)
        selectV.layer.borderColor = UIColor(hexString: "#454C3D")?.cgColor
        selectV.layer.borderWidth = 3
        selectV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
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



