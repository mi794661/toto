//
//  WBQuestionNaireAnserTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/30.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBQuestionNaireAnserTBCell: UITableViewCell {
    
    @IBOutlet weak var chooseImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var questionBean: WBQuestionBean! {
        didSet{
            switch titleLabel.tag {
            case 1:
                titleLabel.text = questionBean.selecta
                break
            case 2:
                titleLabel.text = questionBean.selectb
                break
            case 3:
                titleLabel.text = questionBean.selectc
                break
            case 4:
                titleLabel.text = questionBean.selectd
                break
            default:
                break
            }
        }
    }
    
    
    func configureCell(indexChoosed:Int) {
        chooseImageView.image = UIImage(named: "dcwj_main_rb")
        
        switch titleLabel.tag  {
        case 1:
            if 1 == indexChoosed {
                chooseImageView.image = UIImage(named: "dcwj_main_rb_click")
            }
            break
        case 2:
            if 2 == indexChoosed {
                chooseImageView.image = UIImage(named: "dcwj_main_rb_click")
            }
            break
        case 3:
            if 3 == indexChoosed {
                chooseImageView.image = UIImage(named: "dcwj_main_rb_click")
            }
            break
        case 4:
            if 4 == indexChoosed {
                chooseImageView.image = UIImage(named: "dcwj_main_rb_click")
            }
            break
        default:
            break
        }
    }
    
}
