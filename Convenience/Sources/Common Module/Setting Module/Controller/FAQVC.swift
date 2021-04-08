//
//  FAQVC.swift
//  Convenience
//
//  Created by MACBOOK-SHUBHAM V on 05/02/20.
//  Copyright © 2020 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit

class FAQVC: UIViewController {
    
    //MARK: Variables-
    var arrData = [FAQ_Model]()
    var cellHeights = [IndexPath: CGFloat]()
    
    //MARK:IBoutlets-
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var view1: UIView!
    
    //MARK:AppLifeCycle-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.UiDesign()
        self.tableview.rowHeight = UITableView.automaticDimension
        self.tableview.estimatedRowHeight = 600
        self.tableview.reloadData()
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for obj in arrData{
            obj.isSelected = false
        }
        self.tableview.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
        for obj in arrData{
            obj.isSelected = false
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    //MARK: Buttons-
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:Loacal Methods-
    func UiDesign(){
        
        self.view1.setViewRadius()
        self.view1.setshadowView()
        
    }
    func loadData(){
        
        arrData.append(FAQ_Model.init(Questions: "How long does it take for me to recieve my order?", Answers: """
            Not for a long time. Transitioning the web to HTTPS is going to take some timeThe first thing we’re going to do is require HTTPS for new features. So whatever your website does today, it will still work for months or years. In the long run, there is some discussion of removing or limiting features that are currently available to unencrypted sites. Those changes will be announced well ahead of any change,so you’ll have time to update your site either to not rely on those features or, we hope, to
              move to HTTPS. And any such changes will be made only after consultation with the web community, to make sure we’re striking an appropriate balance between functionality and security
            """, isSelected: false))
        arrData.append(FAQ_Model.init(Questions: "What is your return and exchange policy?"
            , Answers: """
    If you want to use HTTPS, you’ll have to get a certificate. Tha doesn’t mean you have to buy one though! There are multiple free certificate providers in the market right now (e.g.,StartSSL, WoSign, and soon Let’s Encrypt). Some web platforms will provide you a certificate for free (e.g., Cloudflare). For those who prefer to run their own server, Mozilla already offersan HTTPS configuration generator.
    """
            , isSelected: false))
        arrData.append(FAQ_Model.init(Questions: "What do I change my shipping address?", Answers: """
     Go to Your Orders. Select Order Details link for the order you want to change. To edit orders shipped by Amazon, select Change next to the details you want to modify (delivery shipping address, payment method, gift options, etc.).
     """, isSelected: false))
        arrData.append(FAQ_Model.init(Questions: "How do I recieve customer support?", Answers: "We are focused on the health and safety of our associates and based on regional regulations and social distancing requirements this has resulted in extended response times. We ask for your patience in this challenging time as our teams work to deliver this vital service to customers everywhere, especially to those, like the elderly, who are most vulnerable.", isSelected: false))
        arrData.append(FAQ_Model.init(Questions: "What do I do if I entered an incorrect shipping address?", Answers: " Make note of the address and ship to correct address. 2) Cancel the transaction and have the buyer replace the order with the correct shipping address. In this case, send the buyer a message. Hopefully, you can help the customer correct the address before the package has been delivered.", isSelected: false))
        arrData.append(FAQ_Model.init(Questions: "Do you ship to my country?", Answers: "Yes we Do.", isSelected: false))
        arrData.append(FAQ_Model.init(Questions: "will my items come in one package?", Answers: "Accoding number of items.", isSelected: false))
        arrData.append(FAQ_Model.init(Questions: "What about my home router? Or my printer?", Answers: "..........", isSelected: false))
        self.tableview.reloadData()
    }
    
}

//MARK: UITableViewDelegate,UITableViewDataSource-

extension FAQVC:UITableViewDelegate,UITableViewDataSource{
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        arrData.count
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQCell
        let obj = arrData[indexPath.row]
        cell.lblQuestion.text = obj.Questions
        if obj.isSelected == true{
            cell.lblAnswer.text = obj.Answers
            cell.imgColappes.image = #imageLiteral(resourceName: "upper_arrow_ico")
        }else{
            cell.imgColappes.image = #imageLiteral(resourceName: "down_arrow_ico")
            cell.lblAnswer.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrData[indexPath.row]
        if obj.isSelected == true{
            obj.isSelected = false
        }else{
            for obj1 in self.arrData{
                obj1.isSelected = false
            }
            obj.isSelected = true
        }
        self.tableview.reloadData()
        
    }
    
    
    
}
