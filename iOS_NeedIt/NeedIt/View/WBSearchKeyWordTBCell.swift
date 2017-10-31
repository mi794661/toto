//
//  WBSearchKeyWordTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/24.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

protocol CellWBSearchKeyWordTBDelegate {
    func callBackSelectItem(indexPath:NSIndexPath)
}

class WBSearchKeyWordTBCell: UITableViewCell {
    private var listArrKey:[WBSearchKeyBean]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellDelegate:CellWBSearchKeyWordTBDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(beanList:[WBSearchKeyBean]) -> Void {
        listArrKey = beanList
        collectionView.reloadData()
    }
}

extension WBSearchKeyWordTBCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = listArrKey else {
            return 0
        }
        return listArrKey!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("idtWBSearchKeyWordCVCell", forIndexPath: indexPath) as! WBSearchKeyWordCVCell
        let index = indexPath.row + 4*indexPath.section
        let bean = listArrKey![index]
        item.keyLabel.text = bean.slogan
        return item
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if (cellDelegate != nil) {
            cellDelegate?.callBackSelectItem(indexPath)
        }
    }
    
}