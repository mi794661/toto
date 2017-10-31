//
//  WBMessageTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMessageTBCell: UITableViewCell {
    
    @IBOutlet weak var contentInfoLable: UILabel!
    @IBOutlet weak var dateInfoLabel: UILabel!
    @IBOutlet weak var titleNameLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentInfoLable.numberOfLines = 2
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(bean:WBMessageBriefBean) -> Void {
        titleNameLable.text = bean.title
        dateInfoLabel.text = bean.time
        contentInfoLable.text = bean.content
        
    }
    
}
