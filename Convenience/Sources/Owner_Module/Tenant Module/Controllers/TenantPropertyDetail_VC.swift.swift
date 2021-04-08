//
//  TenantPropertyDetail_VC.swift
//  Convenience
//
//  Created by Narendra-macbook on 30/04/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//


import UIKit
import SVProgressHUD

class TenantPropertyDetail_VC: UIViewController {
    
    //MARK: IBOutlet-
    
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var lblPropertyAddress: UILabel!
    @IBOutlet weak var tblTransactions: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var viewChangeStatus: UIView!
    @IBOutlet weak var viewChangeContainer: UIView!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var lblNotCompleted: UILabel!
    @IBOutlet weak var imbCompleted: UIImageView!
    @IBOutlet weak var imgNotCompleted: UIImageView!
    @IBOutlet weak var viewNodataFound: UIView!
    
    var strPropertyName = ""
    var strPropertyAddress = ""
    var strPropertyImage = ""
    var strUserId = ""
    var strPropertyID = ""
    var isDataLoading:Bool=false
    var isLoadData = false
    var limit:Int=20
    var offset:Int=0
    var isdataLoading:Bool=false
    var totalRecords = Int()
    var arrTransactionList = [String]()
    var arrChangeStutus = [String]()
    var arrTransctionall = [TenantTransHistoryModel]()
    var tenantId = ""
    var property_rent_id = ""
    var Status = ""
    

     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblTransactions.delegate = self
        self.tblTransactions.dataSource = self
        viewNodataFound.isHidden = true
        viewChangeStatus.isHidden = true
        self.arrTransactionList = ["April","May"]
        self.tblTransactions.reloadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrTransctionall.removeAll()
        self.limit = 20
        self.offset = 0
        self.callWebServiceForPropertyList()
        self.initialUiSetup()
  
    }
    
    func initialUiSetup(){
        view1.setViewRadius()
        view1.setshadowView()
        viewChangeContainer.setViewRadius()
        viewChangeContainer.setshadowView()
        imgProperty.layer.cornerRadius = 5
        imgProperty.clipsToBounds = true
        imgProperty.layer.borderWidth = 0.3
        imgProperty.layer.borderColor = #colorLiteral(red: 0.876841807, green: 0.876841807, blue: 0.876841807, alpha: 1)
        self.lblPropertyName.text = self.strPropertyName
        self.lblPropertyAddress.text = self.strPropertyAddress
        let urlImg = URL(string: self.strPropertyImage)
        self.imgProperty.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "property-placeholder"))
    }
    

    
    @IBAction func btnCloseChangeStutus(_ sender: Any) {
        
        viewChangeStatus.isHidden = true
    }
    
    
    @IBAction func btnCompleted(_ sender: Any) {
        imbCompleted.image = #imageLiteral(resourceName: "complete_active_ico")
        imgNotCompleted.image = #imageLiteral(resourceName: "complete_inactive_ico")
        Status = "1"
        print("Status for not completed \(Status)")
    }
    
    @IBAction func btnNotCompleted(_ sender: Any) {
        imbCompleted.image = #imageLiteral(resourceName: "complete_inactive_ico")
        imgNotCompleted.image = #imageLiteral(resourceName: "complete_active_ico")
        Status = "2"
        print("Status for not completed \(Status)")
    }
    
    @IBAction func btnUpdateStatus(_ sender: Any) {
        
        self.callWebforchangeAmountStatus()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        self.tblTransactions.reloadData()
    }
    
    
}

//MARK: Tableview delegates

extension TenantPropertyDetail_VC :UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return arrTransctionall.count

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTransactionHistory", for: indexPath) as! CellTransactionHistory
        let obj = self.arrTransctionall[indexPath.row]
        
        cell.lblDate.text = obj.strMonthLabel
        cell.arrAmountList = obj.arrtrancation
        cell.cellView.layer.cornerRadius = 5
        cell.cellView.layer.masksToBounds = true
        if obj.strStatus == "1"{
            cell.lblStatus.text = "Completed"
            cell.lblStatus.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)

        }else{
            cell.lblStatus.text = "Not Completed"
            cell.lblStatus.textColor = #colorLiteral(red: 0.9372549057, green: 0.1646292032, blue: 0.08496480911, alpha: 1)
            
        }
          cell.btnStatus.addTarget(self, action: #selector(btnChangeStatus), for: .touchUpInside)
          cell.btnStatus.tag = indexPath.row
          cell.tblAmountList.reloadData()

        return cell
  
    }
    @objc func btnChangeStatus(sender : UIButton!) {
        let buttonTag = sender.tag
        print(buttonTag)
          viewChangeStatus.isHidden = false
        let obj = self.arrTransctionall[sender.tag]
        print(obj)
    
        var status = obj.strStatus
        tenantId = obj.strbyUserId
        property_rent_id = obj.strPropertyRentId
        Status = obj.strStatus
        if Status == "1"{
            imbCompleted.image = #imageLiteral(resourceName: "complete_active_ico")
            imgNotCompleted.image = #imageLiteral(resourceName: "complete_inactive_ico")

        }else{
            imbCompleted.image = #imageLiteral(resourceName: "complete_inactive_ico")
            imgNotCompleted.image = #imageLiteral(resourceName: "complete_active_ico")
        }
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblTransactions{
            
          //  let obj = self.arrTransctionall[indexPath.row]
          //  viewChangeStatus.isHidden = false
        }
    }
}
extension UIView {
    func addDashedBorder() {
        let color = UIColor.red.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        // shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [3,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

//{{CON_URL}}/api/v1/tenant/transaction-history?property_id=11&tenant_id=11&limit=20&offset=0

extension TenantPropertyDetail_VC{
    func callWebServiceForPropertyList(){
        SVProgressHUD.show()
        objWebServiceManager.requestGet(strURL: WsUrl.GetTenantTransaction+"property_id="+String(strPropertyID)+"&tenant_id="+String(strUserId)+"&limit="+String(self.limit)+"&offset="+String(self.offset), params:nil, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let data = response["data"] as? [String:Any] ?? [:]
                let noDaata = data["data_found"] as? String ?? ""
                let Nodata = data["data_found"] as? Int ?? -1
                self.totalRecords = data["total_records"] as? Int ?? 0

                let transaactionHistory = data["transaction_history_list"] as? [String:Any] ?? [:]
                
                
                if let data = response["data"]as? [String:Any]{
                    if let arrTenantList = data["transaction_history_list"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = TenantTransHistoryModel.init(dict: dic)
                            self.arrTransctionall.append(obj)
                            print(obj)
                        }
                        print(" array trancation alll - \(self.arrTransctionall.count)")

                    }else{
                        
                    }
                    self.tblTransactions.reloadData()
                    
                  //  self.collectionView.reloadData()
                    
                }
             SVProgressHUD.dismiss()

               if Nodata == 0{
                                   if self.arrTransctionall.count == 0{
                                       self.viewNodataFound.isHidden = false
                                       
                                   }else{
                                       self.viewNodataFound.isHidden = true
                                   }
                               }else{
                                   self.viewNodataFound.isHidden = true
                                   
                               }
                self.tblTransactions.reloadData()

            }else
            {
                self.arrTransctionall.removeAll()
                self.limit = 20
                self.offset = 0
                SVProgressHUD.dismiss()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    objAppDelegate.showLogInNavigation()
                }  else{
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
        }) { (error) in
            SVProgressHUD.dismiss()
            
            objAlert.showAlert(message: "Something went wrong.", title: "Alert", controller: self)
        }
    }
}

extension TenantPropertyDetail_VC{
    func callWebforchangeAmountStatus(){
        SVProgressHUD.show()
        let param = [WsParam.UserTenant_id:String(tenantId),
                     WsParam.property_rent_id:String(property_rent_id),
                     WsParam.PaymentStatus:String(Status)]

        objWebServiceManager.requestPatch(strURL: WsUrl.ChangeAmountStatus, params:param, strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()

            let status = response["status"] as? String
            let message = response["message"] as? String ?? ""
            if status == "success"{
                let dic = response["data"] as? [String:Any] ?? [:]
                let alertStatusapi = dic["push_alert_status"] as? Int ?? 0
            
                self.arrTransctionall.removeAll()
                self.limit = 20
                self.offset = 0
                
                self.callWebServiceForPropertyList()
                self.viewChangeStatus.isHidden = true

            }else{
               
                SVProgressHUD.dismiss()
                if message == "k_sessionExpire"{
                    objAlert.showAlert(message: k_sessionExpire, title: kAlertTitle, controller: self)
                    objAppShareData.resetDefaultsAlluserInfo()
                    objAppDelegate.showLogInNavigation()
                }  else{
                    objAlert.showAlert(message:message, title: kAlertTitle, controller: self)
                }
            }
     
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
            objAlert.showAlert(message: "Something went wrong.", title: "Alert", controller: self)
        }
    }
    
}


//MARK:- Paggination Logic
extension TenantPropertyDetail_VC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isdataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblTransactions.contentOffset.y + tblTransactions.frame.size.height) >= tblTransactions.contentSize.height)
            {
                if !isdataLoading{
                    isdataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrTransctionall.count != totalRecords {
                        self.callWebServiceForPropertyList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}
