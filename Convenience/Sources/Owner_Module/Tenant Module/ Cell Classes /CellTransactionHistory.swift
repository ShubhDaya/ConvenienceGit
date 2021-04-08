
//  CellTransactionHistory.swift
//  Convenience
//
//  Created by Narendra-macbook on 30/04/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.


import UIKit

class CellTransactionHistory: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblAmountList: UITableView!
    @IBOutlet weak var cellView: customView!
    @IBOutlet weak var lblStatus: UILabel!
    var strTime1 : String = ""
    var strDate2 : String = ""
    var strCurrentDate : String = ""
    var arrAmountList = [trnacationModel]()

    override func awakeFromNib() {
        super.awakeFromNib()

      //  cellView.addDashedBorder2()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }


    func CompareDate (strFirstDate:Date, strSecondDate:String) -> String
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
        let date = dateFormatter.date(from: strSecondDate)!
        let dateCurrent = Date()
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date123 = calendar.startOfDay(for: date)
        let date223 = calendar.startOfDay(for: dateCurrent)

        let components = calendar.dateComponents([.day], from: date123, to: date223)

        dateFormatter.dateFormat =  "d MMM yyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale // reset the locale
        let dateString = dateFormatter.string(from: date)

        let dateFormatterNew = DateFormatter()
        dateFormatterNew.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatterNew.dateFormat = "d MMM yyy"
        self.strDate2 = dateFormatterNew.string(from: date)
        print("strDate2 : \(self.strDate2)")

        print("EXACT_DATE : \(dateString)")

        let arr = strSecondDate.components(separatedBy: " ")
        let strTime = arr[1]
        let strTime1 = self.convertTimeFormater(strTime)
        print(strTime1)

        var strFinal = dateString
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
        self.strTime1 = dateFormatter.string(from: date)
        return timeStamp
    }
}

//MARK: Tableview delegates

extension CellTransactionHistory :UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        self.tblHeight.constant = CGFloat(self.arrAmountList.count * 85)

        print(self.tblHeight.constant)
        return self.arrAmountList.count


    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMonthAmountlist", for: indexPath) as! CellMonthAmountlist

        let obj = self.arrAmountList[indexPath.row]
        let amount = Double(obj.stramount) ?? 0.00
        cell.lblAmount.text = "$\(amount)"
        let strCreatedDate = obj.strCreated_at
        cell.lblAmountDate.text = self.CompareDate(strFirstDate:Date(),strSecondDate: strCreatedDate)
        cell.lblAmountTime.text = "\(strTime1)"
       // cell.lblAmountDate.text = obj.strCreated_at

        return cell
    }


}
extension UIView {
  func addDashedBorder2(_ color: UIColor = UIColor.darkGray, withWidth width: CGFloat = 1, cornerRadius: CGFloat = 5, dashPattern: [NSNumber] = [3,3]) {

    let shapeLayer = CAShapeLayer()

    shapeLayer.bounds = bounds
    shapeLayer.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
    shapeLayer.fillColor = nil
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = width
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round // Updated in swift 4.2
    shapeLayer.lineDashPattern = dashPattern
    shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath

    self.layer.addSublayer(shapeLayer)
  }
}

