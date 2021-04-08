//
//  HomeTenantVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 24/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import FSCalendar
import SVProgressHUD

class HomeTenantVC: UIViewController {
    
    //MARK: variables-
    
    var StrTime : String = ""
    var StrDate : String = ""
    var strCurrentdate : String = ""
    var limit:Int=10
    var offset:Int=0
    var isdataLoading:Bool=false
    var totalRecords = Int()
    
    //Calender variables -
    var currentDay = ""
    var curremtMonth = ""
    var curremtYear = ""
    var SelectedDate = ""
    var strcond : NSString?
    var arrSelectedDateHistoryTenant = [paymenthistoryowenrmodel]()
    
    var arrpayHistoryMonthTenant = [PaymentHistoryCal_Month_Model]()
    
    var arrhistory = [paymenthistoryModel]()
    var arrobjdate  = [String]()
    
    //MARK: IBOutlet-
    
    @IBOutlet weak var viewCalender: UIView!
    @IBOutlet weak var FsCalendar: FSCalendar!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewimg: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblDisplayHeader: UILabel!
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var Calender: FSCalendar!
    @IBOutlet weak var viewSelctedDateHisotry: UIView!
    @IBOutlet weak var viewselectedDateContainerRadius: UIView!
    
    @IBOutlet weak var tblSelectedDateHistory: UITableView!
    
    @IBOutlet weak var tblSelectedDateHeigthConstant: NSLayoutConstraint!
    
    //MARK: ViewLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // var username = objAppShareData.UserDetail.strFullName
        // print(username)
        self.viewCalender.isHidden = true
        self.viewNoDataFound.isHidden = true
        viewSelctedDateHisotry.isHidden = true
        Calender.dataSource = self
        Calender.delegate = self
        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        self.tblSelectedDateHistory.delegate = self
        self.tblSelectedDateHistory.dataSource = self
        self.tblHistory.tableFooterView = UIView()
        Calender.calendarHeaderView.isHidden = true
        Calender.select(Date())
        Calender.accessibilityIdentifier = "calender"
        self.UIdesign()
        
        Calender.select(Date())
        Calender.accessibilityIdentifier = "calender"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        limit = 10
        offset = 0
        
        self.arrhistory.removeAll()
        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        self.tblSelectedDateHistory.delegate = self
        self.tblSelectedDateHistory.dataSource = self
        Calender.appearance.titleFont = UIFont(name:"CMUSerif-Bold",size:16)

        callWebServiceForPaymentHistory()
        
        self.lblUserName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgProfile.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
        Calender.appearance.eventOffset = CGPoint(x: 0, y: 0)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: Buttton Action -
    
    @IBAction func btnBackToList(_ sender: Any) {
    }
    
    @IBAction func btnShowFsCallender(_ sender: Any) {
        self.viewCalender.isHidden = false
        self.viewContent.isHidden = true
        self.changeCalenderHeader(date: Date())
        self.currentDateMonth()
    }
    @IBAction func btnshowHistory(_ sender: Any) {
        self.viewContent.isHidden = false
        self.viewCalender.isHidden = true
    }
    
    @IBAction func btnNextMonth(_ sender: Any) {
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = 1 // For prev button -1, For next button 1
        Calender.currentPage = _calendar.date(byAdding: dateComponents, to:  Calender.currentPage)!
        self.Calender.setCurrentPage( Calender.currentPage, animated: true)
        
    }
    @IBAction func btnPreviousAction(_ sender: Any) {
        let _calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = -1 // For prev button -1, For next button 1
        Calender.currentPage = _calendar.date(byAdding: dateComponents, to:  Calender.currentPage)!
        self.Calender.setCurrentPage( Calender.currentPage, animated: true)
    }
    
    
    @IBAction func btnCloseSelectedDateHistory(_ sender: Any) {
        self.viewSelctedDateHisotry.isHidden = true
        
    }
    
    
    
    //MARK: Local Methods -
    
    func UIdesign(){
        imgProfile.setImgCircle()
        viewimg.setviewCirclewhite()
        viewimg.setshadowViewCircle()
        viewContent.setViewRadius()
        viewContent.setshadowView()
        viewCalender.setViewRadius()
        viewCalender.setshadowView()
        viewselectedDateContainerRadius.setViewRadius10()
        self.changeCalenderHeader(date: Date())
        self.Calender.clipsToBounds = true;
    }
    
    
    
    
    func changeCalenderHeader(date : Date){
        let formate = DateFormatter()
        formate.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        formate.dateFormat = "MMMM, yyyy"
        let strCalenderHeader = formate.string(from: date)
        self.lblDisplayHeader.text = strCalenderHeader
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.changeCalenderHeader(date: calendar.currentPage)
        self.currentDateMonth()
    }
    
    func currentdate(_ calender:FSCalendar){
        let currentPageDate = Calender.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        print(month)
    }
    
    func currentDateMonth(){
        // func for get current month same day details - and current page month/year
        let date = Date()
        let components = date.get(.day, .month, .year)
        if let day = components.day, let month = components.month, let year = components.year {
            print("currentDay: \(day), curremtMonth: \(month), curremtYear: \(year)")
        }
        
        //Get current page month and year -
        let currentPageDate = Calender.currentPage
        
        let month = Calendar.current.component(.month, from: currentPageDate)
        let year = Calendar.current.component(.year, from: currentPageDate)
        let day = Calendar.current.component(.day, from: currentPageDate)
        
        currentDay = "\(day)"
        curremtMonth = "\(month)"
        curremtYear = "\(year)"
        print(month)
        self.GetpaymentHistoryOneMonth()
        
    }
    
    
    //MARK: - Functions
    
    func convertDateFormater(_ date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date1 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        //self.strDate = dateFormatter.(from: date!)
        return  date1 ?? Date()
        
    }
    
    func convertTimeFormater(_ time: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date)
        self.StrTime = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    func compareDate(date : String){
        let date = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let datenew = dateFormatter.string(from: dateFromString as Date)
        print("datee",datenew)
        
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
}
//MARK: Tablview Data Source/Delegate Methods-

extension HomeTenantVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        if tableView == tblSelectedDateHistory
        {
            
            self.tblSelectedDateHeigthConstant.constant = CGFloat(arrSelectedDateHistoryTenant.count * 90)
            
            return  arrSelectedDateHistoryTenant.count
            tblSelectedDateHistory.reloadData()
            
        }
        else
        {
            
            return arrhistory.count
            tblHistory.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblSelectedDateHistory
        {
            let cell = tblSelectedDateHistory.dequeueReusableCell(withIdentifier: "TenantSelectedDateHistoryCell")  as! TenantSelectedDateHistoryCell
            let obj = arrSelectedDateHistoryTenant[indexPath.row]
            let amount = Double(obj.stramount) ?? 0.0
            cell.lblAmount.text? = "$\(amount)"
            cell.lblPropertyName.text? = obj.strproperty_name ?? ""
            let strCreatedDate = obj.strCreated_at
            cell.lblDate.text = self.CompareDate(strFirstdate:Date() , strSeconddate: strCreatedDate)
                      
            return cell
            tblSelectedDateHistory.reloadData()
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
            let obj = arrhistory[indexPath.row]
            let amount = Double(obj.stramount) ?? 0.0
            cell.lblAmount.text? = "$\(amount)"
            cell.lblaccountDeatail.text = obj.strproperty_name
            
            let strCreatedDate = obj.strCreated_at
            cell.lblTransactionTime.text = self.CompareDate(strFirstdate:Date() , strSeconddate: strCreatedDate)
            // cell.lblTransactionTime.text = obj.strpayment_date
            return cell
            tblHistory.reloadData()
            
        }
    }
}


//MARK: FSCalendarDelegate Source/Delegate Methods-

extension HomeTenantVC : FSCalendarDelegate,FSCalendarDelegateAppearance,FSCalendarDataSource{
    
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM"
        let dateString3 = dateFormatter3.string(from: date)
        //print("datenew1",dateString3)
        strcond  = dateString3 as NSString
        let eventScaleFactor: CGFloat = 1.2
             cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
        print("datenew1",strcond!)
        
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = self.dateFormatter2.string(from: date)
        for d in arrpayHistoryMonthTenant{
            let date = d.strPaymentDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datenew = dateFormatter.string(from: dateFromString as Date)
            if datenew.contains(dateString) {
                arrobjdate.append(dateString)
                return 1
            }
        }
        return 0
        
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        
        for d in arrpayHistoryMonthTenant{
            let date = d.strPaymentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datenew = dateFormatter.string(from: dateFromString as Date)
            print("new  calendar",dateString)
            // calendar.appearance.eventOffset = CGPoint(x: 0, y: -3)
            if datenew.contains(dateString) {
                
                return nil
            }
        }
        return nil
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        
        let selectedDates = calendar.selectedDates.map({self.dateFormatter2.string(from: $0)})
        print("selected dates is \(selectedDates)")
        let currentselected = "\(self.dateFormatter2.string(from: date))"
        SelectedDate = currentselected
        print("Selected Date is - \(SelectedDate)")
        
        print(currentselected)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        print(monthPosition)
        //           for element in objdate {
        //             print(element)
        //           }
        
        if arrobjdate.contains("\(SelectedDate)") {
            //item found, do what you want
            print("it is contain ")
            self.GetpaymentHistoryDateTypeTenant()
            
        }
        else{
            print("it is not contain ")
            
            //item not found
            // objdate.append(item)
        }
        
        //  self.GetpaymentHistoryOneMonth()
        
        
    }
    
}


//MARK:  Webservice -

extension HomeTenantVC{
    func callWebServiceForPaymentHistory(){
        SVProgressHUD.show()
        //  self.arrPendingList.removeAll()
        // let param = [WsParam.user:objAppSharedata.UserDetail.strUserType] as [String : Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.GetPaymentHistoryTenant+"type=list&for="+String(objAppShareData.UserDetail.strUserType+"&limit="+String(limit)+"&offset="+String(offset)), params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            // let datafound = response["data_found"] as? String ?? ""
            //let dataFound = response["data_found"] as? Int ?? 0
            
            if status == "success"{
                SVProgressHUD.dismiss()
                
                let data = response["data"] as? [String:Any] ?? [:]
                let dataFound = data["data_found"] as? Int ?? 0
                let propertyList = data["property_list"] as? [String:Any] ?? [:]
                if dataFound == 0{
                    if self.arrhistory.count == 0 {
                        self.viewNoDataFound.isHidden = false
                        
                    }
                    
                }else {
                    if let arrproperty = data["payment_history_list"]as? [[String:Any]]{
                        
                        for dic in arrproperty{
                            let obj = paymenthistoryModel.init(dict: dic)
                            self.arrhistory.append(obj)
                            print(obj)
                        }
                        print(self.arrhistory.count)
                        self.tblHistory.reloadData()
                        
                        self.arrhistory = self.arrhistory.sorted(by: { (obj1, obj2) -> Bool in
                            let obj1 = obj1.strCreated_at
                            let obj2 = obj2.strCreated_at
                            return (obj1.localizedCaseInsensitiveCompare(obj2) == .orderedDescending)
                        })
                        self.tblHistory.reloadData()
                    }else {
                        self.tblHistory.reloadData()
                        SVProgressHUD.dismiss()
                        
                    }
                    
                }
                
            }
            else{
                
                
                              
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
            
            print(error)
        }
    }
}


extension HomeTenantVC{
    func GetpaymentHistoryDateTypeTenant(){
         SVProgressHUD.show()
        self.arrSelectedDateHistoryTenant.removeAll()
        objWebServiceManager.requestGet(strURL: WsUrl.GetHitoryOfDateType+"for="+String(objAppShareData.UserDetail.strUserType)+"&date="+String(SelectedDate), params:nil, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                   SVProgressHUD.dismiss()
                
                let data = response["data"] as? [String:Any] ?? [:]
                let datafound = Int(data["data_found"] as? String ?? "") ?? 0
                let userdata = data["data_found"] as? Int ?? 0
                print(userdata)
                print(datafound)
                
                self.totalRecords = response["total_records"] as? Int ?? 0
                
                if let data = response["data"]as? [String:Any]{
                    if let arrTenantList = data["payment_history_date"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = paymenthistoryowenrmodel.init(dict: dic)
                            self.arrSelectedDateHistoryTenant.append(obj)
                            
                            print(obj)
                        }
                        print(self.arrSelectedDateHistoryTenant.count)
                    }else{
                        self.tblSelectedDateHistory.reloadData()
                    }
                }
                self.tblSelectedDateHistory.reloadData()
                
                 SVProgressHUD.dismiss()
                if userdata == 0{
                    if self.arrSelectedDateHistoryTenant.count == 0{
                        //self.viewNodataFound.isHidden = false
                        self.viewSelctedDateHisotry.isHidden = true
                        
                    }else{
                        //   self.viewNodataFound.isHidden = true
                    }
                }else{
                    
                    self.viewSelctedDateHisotry.isHidden = false
                    
                    
                }
                self.tblSelectedDateHistory.reloadData()
                
            }else{
                // self.arrTenantList.removeAll()
           
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
            
            //    objIndicator.stopActivityIndicator()
            objAlert.showAlert(message: "Something went wrong.", title: "Alert", controller: self)
        }
    }
}


//MARK:- Paggination Logic
extension HomeTenantVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isdataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblHistory.contentOffset.y + tblHistory.frame.size.height) >= tblHistory.contentSize.height)
            {
                if !isdataLoading{
                    isdataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrhistory.count != totalRecords {
                        callWebServiceForPaymentHistory()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}

extension HomeTenantVC{
    func GetpaymentHistoryOneMonth(){
        SVProgressHUD.show()
        self.arrpayHistoryMonthTenant.removeAll()
        objWebServiceManager.requestGet(strURL: WsUrl.GetHitoryOfMonthsCalener+"for="+String(objAppShareData.UserDetail.strUserType)+"&month="+String(curremtMonth)+"&year="+String(curremtYear), params:nil, queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
            if status == "success"{
                SVProgressHUD.dismiss()
                
                let data = response["data"] as? [String:Any] ?? [:]
                let datafound = Int(data["data_found"] as? String ?? "") ?? 0
                let userdata = data["data_found"] as? Int ?? 0
                print(userdata)
                print(datafound)
                
                self.totalRecords = response["total_records"] as? Int ?? 0
                
                if let data = response["data"]as? [String:Any]{
                    if let arrTenantList = data["payment_history_calendar"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = PaymentHistoryCal_Month_Model.init(dict: dic)
                            self.arrpayHistoryMonthTenant.append(obj)
                            self.compareDate(date: obj.strPaymentDate)
                            
                            print(obj)
                        }
                        self.Calender.reloadData()
                        
                    }else{
                        self.Calender.reloadData()
                    }
                    
                    
                }
                SVProgressHUD.dismiss()
                //                if datafound == 0{
                //                    if self.arrTenantList.count == 0{
                //                        self.viewNodataFound.isHidden = false
                //
                //                    }else{
                //                        self.viewNodataFound.isHidden = true
                //                    }
                //                }else{
                //                    self.viewNodataFound.isHidden = true
                //
                //                }
                //self.tblView.reloadData()
                self.Calender.reloadData()
                
            }else{
                // self.arrTenantList.removeAll()
                self.limit = 10
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
            
            //    objIndicator.stopActivityIndicator()
            objAlert.showAlert(message: "Something went wrong.", title: "Alert", controller: self)
        }
    }
}


extension HomeTenantVC{
    
    
    func CompareDate (strFirstdate:Date, strSeconddate:String) -> String
    {//"14/01/2020"   "2020-01-13 14:23:09 PM"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        // SecondDateString = strSecondDate
        
        //df.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        df.dateFormat = "dd/MM/yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strSeconddate)!
        let dateCurrent = Date()
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date123 = calendar.startOfDay(for: date)
        let date223 = calendar.startOfDay(for: dateCurrent)
        let components = calendar.dateComponents([.day], from: date123, to: date223)
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale // reset the locale
        let dateString = dateFormatter.string(from: date)
        
        let dateFormatterNew = DateFormatter()
        dateFormatterNew.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatterNew.dateFormat = "MMMM d, yyyy"
        self.StrDate = dateFormatterNew.string(from: date)
        
        print("EXACT_DATE : \(dateString)")
        
        var strFinal = ""
        let arr = strSeconddate.components(separatedBy: " ")
        let strTime = arr[1]
        let strTime1 = self.convertTimeFormater(strTime)
        if components.day == 0{
            strFinal = "Today " + strTime1
        }else if components.day == 1{
            strFinal = "Yesterday " + strTime1
        }else{
            strFinal = "\(self.StrDate) " + strTime1
        }
        return strFinal
    }
    
    func relativePast(for date : Date,currentDate : Date) -> String {
        
        let units = Set<Calendar.Component>([.day, .hour, .minute, .second])
        let components = Calendar.current.dateComponents(units, from: date, to: currentDate)
        
        if (components.day! > 0) {
            return (components.day! > 1 ? "\(components.day!) days ago" : "Yesterday")
            
        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
            
        } else if components.minute! > 0 {
            print("\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago"))
            return "\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago")
            
        } else {
            return "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
        }
    }
}

