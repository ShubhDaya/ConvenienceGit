
import  Foundation


class PaymentModel : NSObject{
            
        var strmonth: String = ""
        var strtext: String = ""
        var stryear: String = ""
    
        init(dict : [String : Any]) {
            let text = dict["text"] as? String ?? ""
            self.strtext = text
          
            
            if let month = dict["month"] as? String{
                      self.strmonth = month
                  }else if let month = dict["month"] as? Int{
                      self.strmonth = "\(month)"
                  }
                  if let year = dict["year"] as? String {
                      self.stryear = year
                  }else if let year = dict["year"] as? Int {
                      self.stryear = String(year)
                      
                  }

        }
}
