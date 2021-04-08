//
//  HistoryVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 21/01/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
import FSCalendar
import SDWebImage
import SVProgressHUD

class HistoryVC: UIViewController {
    
    //MARK: Variable-
    
    //Calender variables -
    var currentDay = ""
    var curremtMonth = ""
    var curremtYear = ""
    var SelectedDate = ""
    var strcond : NSString?
    var arrpayHistoryMonth = [PaymentHistoryCal_Month_Model]()
    var arrSelectedDateHistory = [paymenthistoryowenrmodel]()
    var arrDates = [paymenthistoryowenrmodel]()
    var objdate  = [String]()
    // local variables
    var StrTime1 : String = ""
    var StrDate2 : String = ""
    var StrCurrentdate : String = ""
    var limit:Int=10
    var offset:Int=0
    var isdataLoading:Bool=false
    var totalRecords = Int()
    var arrhistoryowner = [paymenthistoryowenrmodel]()
    //  private weak var calendar: FSCalendar!
    
    @IBOutlet weak var Calender: FSCalendar!
    let reuseIdentifier = "Cell" // also enter this string as the cell identifier in the storyboard
    let username = UserDefaults.standard.string(forKey: "email")

    
    //MARK: Outlet-
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var imgOwnerImage: UIImageView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFsCalender: UIView!
    @IBOutlet weak var lblDisplayHeader: UILabel!
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var viewSelectedDateHistory: UIView!
    @IBOutlet weak var tblSelectedDateHostory: UITableView!
    @IBOutlet weak var SelecteddateHistoryTbkHeghtCons: NSLayoutConstraint!
   
    @IBOutlet weak var viewSelectedDateHistoryForRadius: UIView!
    
    
    //MARK: App Life Cycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email =  objAppShareData.UserDetail.strEmail
        print(email)
        self.viewFsCalender.isHidden = true
        self.viewNoDataFound.isHidden = true
        self.viewSelectedDateHistory.isHidden = true
        self.tableView.tableFooterView = UIView()

        // Calender.appearance.eventOffset = CGPoint(x: 2, y: 0)
        Calender.dataSource = self
        Calender.delegate = self
        tblSelectedDateHostory.dataSource = self
        tblSelectedDateHostory.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        Calender.calendarHeaderView.isHidden = true
        setUpUi()
        Calender.select(Date())
        Calender.accessibilityIdentifier = "calender"
        self.viewContent.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIdesign()
        limit = 10
        offset = 0
        self.arrhistoryowner.removeAll()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tblSelectedDateHostory.delegate = self
        self.tblSelectedDateHostory.dataSource = self
        Calender.appearance.eventOffset = CGPoint(x: 0, y: 0)
        Calender.appearance.titleFont = UIFont(name:"CMUSerif-Bold",size:16)
        callWebServiceForPaymentHistoryOwner()
        self.lblOwnerName.text = "\(objAppShareData.UserDetail.strFirstName) \(objAppShareData.UserDetail.strLastName)"
        let strimage = objAppShareData.UserDetail.strProfilePicture
        let urlImg = URL(string: strimage)
        self.imgOwnerImage.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "profile_ico"))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK:Button-
    
    @IBAction func btnShowFsCallender(_ sender: Any) {
        self.viewFsCalender.isHidden = false
        self.viewContent.isHidden = true
        self.changeCalenderHeader(date: Date())
        // self.currentDateMonth()
        self.currentDateMonth()
       // objAlert.showAlert(message: kunderDevelopment, title: "Alert", controller: self)
    }
    @IBAction func btnshowHistory(_ sender: Any) {
        self.viewContent.isHidden = false
        self.viewFsCalender.isHidden = true
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
        self.viewSelectedDateHistory.isHidden = true
    }
    
    //MARK: Local Function-
    
    func UIdesign(){
        imgOwnerImage.setImgCircle()
        viewImg.setviewCirclewhite()
        viewImg.setshadowViewCircle()
        viewContent.setViewRadius()
        viewContent.setshadowView()
        viewFsCalender.setViewRadius()
        viewFsCalender.setshadowView()
        viewSelectedDateHistoryForRadius.setViewRadius10()
    }
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    // ****************** Fucntion for use in fscalender ********************************

    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func setUpUi(){
        self.Calender.delegate = self
        self.Calender.dataSource = self
        self.Calender.clipsToBounds = true;
        //  self.Calender.scope = .week
        
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
    
    // ********************* Function for payment history tableview ********************* -
    
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
        self.StrTime1 = dateFormatter.string(from: date)
        
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
}

//MARK:FSCalendarDelegate/Datasouce-

extension HistoryVC: FSCalendarDelegate,FSCalendarDelegateAppearance,FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM"
        let dateString3 = dateFormatter3.string(from: date)
        //print("datenew1",dateString3)
        strcond  = dateString3 as NSString
        print("datenew1",strcond!)
        let eventScaleFactor: CGFloat = 1.2
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
        
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = self.dateFormatter2.string(from: date)
        for d in arrpayHistoryMonth{
            let date = d.strPaymentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datenew = dateFormatter.string(from: dateFromString as Date)

            if datenew.contains(dateString) {
                    objdate.append(dateString)

                return 1
            }
        }
        return 0
        
    }
    

    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
               let dateString = self.dateFormatter2.string(from: date)
             print(dateString)
        // let datestring2 : String = dateFormatter1.string(from:date)

         if objdate.contains(dateString)
         {
            return nil
         }
         else if objdate.contains(dateString)
         {
            return nil
         }
         else{
             return nil
         }
    }
    
    private func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        
        for d in arrpayHistoryMonth{
            let date = d.strPaymentDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datenew = dateFormatter.string(from: dateFromString as Date)
            print("new  calendar",dateString)
            objdate.append(datenew)
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
        for element in objdate {
          print(element)
        }
        
      if objdate.contains("\(SelectedDate)") {
         //item found, do what you want
        print("it is contain ")
        self.GetpaymentHistoryDateType()

      }
      else{
        print("it is not contain ")
       
         //item not found
        // objdate.append(item)
      }
      
    }
  
}

extension HistoryVC{
    
    
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
        self.StrDate2 = dateFormatterNew.string(from: date)
        
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
            strFinal = "\(self.StrDate2) " + strTime1
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

//MARK:  Webservice -

extension HistoryVC{
    func callWebServiceForPaymentHistoryOwner(){
        SVProgressHUD.show()
      
        
        objWebServiceManager.requestGet(strURL: WsUrl.GetPaymentHistoryTenant+"type=list&for="+String(objAppShareData.UserDetail.strUserType+"&limit="+String(limit)+"&offset="+String(offset)), params:[:], queryParams: [:], strCustomValidation: "", success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            let status = response["status"] as? String ?? ""
            let message = response["message"] as? String ?? ""
             let datafound = response["data_found"] as? String ?? ""
            let dataFound = response["data_found"] as? Int ?? 0
            
            if status == "success"{
                SVProgressHUD.dismiss()
                
                let data = response["data"] as? [String:Any] ?? [:]
                self.totalRecords = data["total_records"] as? Int ?? 0
                let dataFound = data["data_found"] as? Int ?? 0
                let propertyList = data["property_list"] as? [String:Any] ?? [:]
                if dataFound == 0{
                    if self.arrhistoryowner.count == 0 {
                        self.viewNoDataFound.isHidden = false
                    }
                    
                }else {
                    if let arrproperty = data["payment_history_list"]as? [[String:Any]]{
                        
                        for dic in arrproperty{
                            let obj = paymenthistoryowenrmodel.init(dict: dic)
                            self.arrhistoryowner.append(obj)
                            print(obj)
                        }
                        print(self.arrhistoryowner.count)
                        self.tableView.reloadData()
                        
                        self.arrhistoryowner = self.arrhistoryowner.sorted(by: { (obj1, obj2) -> Bool in
                            let obj1 = obj1.strCreated_at
                            let obj2 = obj2.strCreated_at
                            return (obj1.localizedCaseInsensitiveCompare(obj2) == .orderedDescending)
                        })
                        self.tableView.reloadData()
                    }else {
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        
                    }
                    
                }
                
            }
            else{
                      if dataFound ==  0{
                      self.viewNoDataFound.isHidden = false
                       }
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
            SVProgressHUD.dismiss()
            
            //    objIndicator.stopActivityIndicator()
            objAlert.showAlert(message: "Something went wrong.", title: "Alert", controller: self)
        }
    }
}
//MARK:- Paggination Logic
extension HistoryVC{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isdataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if !isdataLoading{
                    isdataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrhistoryowner.count != totalRecords {
                        callWebServiceForPaymentHistoryOwner()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}


extension HistoryVC{
    func GetpaymentHistoryOneMonth(){
        SVProgressHUD.show()
        //  self.arrTenantList.removeAll()
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
                    self.totalRecords = data["total_records"] as? Int ?? 0

                    if let arrTenantList = data["payment_history_calendar"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = PaymentHistoryCal_Month_Model.init(dict: dic)
                            self.arrpayHistoryMonth.append(obj)
                            self.compareDate(date: obj.strPaymentDate)
                        
                            print(obj)
                        }
                        self.Calender.reloadData()
                        
                    }else{
                        self.Calender.reloadData()
                    }
                }
                SVProgressHUD.dismiss()

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

//MARK: Websevice for Payment Hisotry Date Type -

extension HistoryVC{
    func GetpaymentHistoryDateType(){
        SVProgressHUD.show()
          self.arrSelectedDateHistory.removeAll()
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
                
                
                if let data = response["data"]as? [String:Any]{
                    self.totalRecords = data["total_records"] as? Int ?? 0

                    if let arrTenantList = data["payment_history_date"]as? [[String:Any]]{
                        for dic in arrTenantList{
                            let obj = paymenthistoryowenrmodel.init(dict: dic)
                            self.arrSelectedDateHistory.append(obj)
                            
                            print(obj)
                        }
                        print(self.arrSelectedDateHistory.count)
                    }else{
                        self.tblSelectedDateHostory.reloadData()
                    }
                }
                self.tblSelectedDateHostory.reloadData()

                SVProgressHUD.dismiss()
                                if userdata == 0{
                                    if self.arrSelectedDateHistory.count == 0{
                                        //self.viewNodataFound.isHidden = false
                               self.viewSelectedDateHistory.isHidden = true

                                    }else{
                                     //   self.viewNodataFound.isHidden = true
                                    }
                                }else{
                                        
                                        self.viewSelectedDateHistory.isHidden = false
                                

                                }
                self.tblSelectedDateHostory.reloadData()
                
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

// get current Date Month -
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}



//MARK: Tablview Data Source/Delegate Methods-

extension HistoryVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == tblSelectedDateHostory
               {
                
                self.SelecteddateHistoryTbkHeghtCons.constant = CGFloat(arrSelectedDateHistory.count * 90)

                    return  arrSelectedDateHistory.count
                tblSelectedDateHostory.reloadData()

               }
               else
               {

                 return  arrhistoryowner.count
                tableView.reloadData()

               }
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tblSelectedDateHostory
             {
                 let cell = tblSelectedDateHostory.dequeueReusableCell(withIdentifier: "SelectedDateHistoryCell")  as! SelectedDateHistoryCell
                 let obj = arrSelectedDateHistory[indexPath.row]
            
                let amount = Double(obj.stramount) ?? 0.0
                print(amount)
            
                cell.lblAmount.text? = "$\(amount)"
                cell.lblPropertyName.text? = obj.strproperty_name ?? ""
                let strCreatedDate = obj.strCreated_at
                cell.lblDate.text = self.CompareDate(strFirstdate:Date() , strSeconddate: strCreatedDate)
                cell.lblName.text = obj.strtenantName
                 return cell
                tblSelectedDateHostory.reloadData()

             }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell", for: indexPath) as! HistoryTableCell
        let obj = arrhistoryowner[indexPath.row]
            let amount = Double(obj.stramount) ?? 0.0
            print(amount)
        cell.lblAmount.text  = "$\(amount)"
        cell.lblaccountDeatail.text = obj.strproperty_name
        cell.lblStatus.text = obj.strtenantName
        let strCreatedDate = obj.strCreated_at
        cell.lblTransactionTime.text = self.CompareDate(strFirstdate:Date() , strSeconddate: strCreatedDate)
     
        
        return cell
            tableView.reloadData()

        }
    }
}
