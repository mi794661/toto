//
//  WBQuestionNaireVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias callBackQuestionNaireVC = (isFinished: Bool) -> Void

class WBQuestionNaireVC: WBBaseViewController {
    
    private var beanRebate:WBRebateBean!
    var retQuestionNaireClosure:callBackQuestionNaireVC?
    func initWithClosureQuestionNaire(bean:WBRebateBean,closure:callBackQuestionNaireVC?){
        retQuestionNaireClosure = closure
        beanRebate = bean
    }
    
    private var questionBean: WBParseQuestionBean?
    private var anserBean: Dictionary<Int, Int> = Dictionary()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "调查问卷"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBQuestionNaireVC.onBackNavAction))
        self.tableView.tableFooterView = UIView()
        
        requestQuestionAnswerContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onBackNavAction() {
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
}

extension WBQuestionNaireVC {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (questionBean != nil) {
            return (questionBean?.questions.count)! + 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return 2
        }
        if section == ((questionBean?.questions.count)! + 1) {
            return 1
        }
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.row {
            if indexPath.section == ((questionBean?.questions.count)! + 1) {
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBQuestionNaireSubmitTBCell", forIndexPath: indexPath) as! WBQuestionNaireSubmitTBCell
                cell.selectionStyle = .None
                cell.submitButton.removeTarget(self, action: #selector(WBQuestionNaireVC.onClickSubmitAnser), forControlEvents: .TouchUpInside)
                cell.submitButton.addTarget(self, action: #selector(WBQuestionNaireVC.onClickSubmitAnser), forControlEvents: .TouchUpInside)
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBQuestionNaireTitleTBCell", forIndexPath: indexPath) as! WBQuestionNaireTitleTBCell
            cell.selectionStyle = .None
            if 0 == indexPath.section {
                cell.titleLabel.text = "所属订单"
            }else{
                configureCell(cell, atIndexPath: indexPath)
            }
            return cell
        }
        if 0 == indexPath.section {
            let orderBean = questionBean?.order
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBQuestionNaireHeaderTBCell", forIndexPath: indexPath) as! WBQuestionNaireHeaderTBCell
            cell.selectionStyle = .None
            cell.configureCell(orderBean!)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBQuestionNaireAnserTBCell", forIndexPath: indexPath) as! WBQuestionNaireAnserTBCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func configureCell(cell: UITableViewCell ,atIndexPath indexPath: NSIndexPath) {
        cell.fd_enforceFrameLayout = false
        if 0 == indexPath.row {
            if 0 == indexPath.section {
            }else{
                let bean = questionBean?.questions[indexPath.section-1]
                (cell as! WBQuestionNaireTitleTBCell).questionBean = bean
            }
            return
        }
        let bean = self.questionBean?.questions[indexPath.section-1]
        (cell as! WBQuestionNaireAnserTBCell).titleLabel.tag = indexPath.row
        let indexChoosed = anserBean.integerForKey(indexPath.section - 1)
        (cell as! WBQuestionNaireAnserTBCell).configureCell(indexChoosed)
        (cell as! WBQuestionNaireAnserTBCell).questionBean = bean
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 0 == indexPath.section {
            if 1 == indexPath.row {
                return 100;
            }
            return 44
        }
        if 0 == indexPath.row && indexPath.section == ((questionBean?.questions.count)! + 1) {
            return 44
        }
        
        if  0 == indexPath.row {
            return tableView.fd_heightForCellWithIdentifier("idtWBQuestionNaireTitleTBCell", cacheByIndexPath: indexPath, configuration: { ( cell: AnyObject!) in
                self.configureCell((cell as! WBQuestionNaireTitleTBCell), atIndexPath: indexPath)
            })
        }
        return tableView.fd_heightForCellWithIdentifier("idtWBQuestionNaireAnserTBCell", cacheByIndexPath: indexPath, configuration: { ( cell: AnyObject!) in
            self.configureCell((cell as! WBQuestionNaireAnserTBCell), atIndexPath: indexPath)
        })        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if 0 == indexPath.row {
            return
        }
        if 0 == indexPath.section {
            return
        }
        
        anserBean.updateValue(indexPath.row, forKey: (indexPath.section - 1))
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
    }
    
}

extension WBQuestionNaireVC {
    
    func onClickSubmitAnser() {
        if anserBean.values.count == (questionBean?.questions.count)! {
            
            let sortedKeys = Array(anserBean.keys).sort(<)
            var arrSubmit:[String] = []
            for index in 0...sortedKeys.count-1 { //arrSubmit.append(anserBean.integerForKey(index))
                let numIndex = anserBean.integerForKey(index)
                switch numIndex {
                case 1:
                    arrSubmit.append("a")
                    break
                case 2:
                    arrSubmit.append("b")
                    break
                case 3:
                    arrSubmit.append("c")
                    break
                case 4:
                    arrSubmit.append("d")
                    break
                default:
                    arrSubmit.append("d")
                    break
                }
            }
            let strUpload = (arrSubmit as NSArray).componentsJoinedByString(",")
            requestSubmitQuestionAnswerContent(strUpload)
            return
        }
        SVProgressHUD.showErrorWithStatus("还有未完成的问答！")
    }
    
    private func requestQuestionAnswerContent() {
        let urlStr = WBNetManager.sharedInstance.getQuestionListURL()
        print("调查问卷页面:\(urlStr)")//{"qid": "2","oid": "5","token": "1581132815511111458563578"}
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(objects: [token, beanRebate.oid, beanRebate.dataId], forKeys: ["token","oid","qid"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            if isSuccess {
                self.questionBean = WBParseQuestionBean(json: json)
                self.tableView.reloadData()
            }
            if isFailure {
            }
            
        }
    }
    
    private func requestSubmitQuestionAnswerContent(answerStr:String) {
        let urlStr = WBNetManager.sharedInstance.getQuestionAnswerSubmitURL()
        print("提交调查问卷的答案:\(urlStr)")//{"qid": "2","oid": "5","token": "1581132815511111458563578"}
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(objects: [token, beanRebate.oid, beanRebate.dataId ,answerStr], forKeys: ["token","oid","qid","data"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            let retoBJ = WBParseNetBase(json: json)
            
            if isSuccess {
                if retoBJ.isDataOk() {
                    self.retQuestionNaireClosure?(isFinished:true)
                    self.onBackNavAction()
                    
                }
                return
            }
            if isFailure {
            }
            SVProgressHUD.showErrorWithStatus(retoBJ.msg ?? "网络错误！")
            
        }
    }
    
    
}