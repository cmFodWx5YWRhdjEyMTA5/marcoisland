//
//  PayNowPageViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/12/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire

class PayNowPageViewController: UIViewController, PayPalPaymentDelegate {

    var environment:String = PayPalEnvironmentProduction {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default
    
    //@IBOutlet weak var successView: UIView!
    
    var window: UIWindow?
    var loadingView : UIView?
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDesc: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var btnBuyNow: UIButton!
    var productID : String?
    var prodObj : ProductMaster?
    
    var orderID : String?
    var paypal_state : String?
    var paypal_payment_id : String?
    var paypal_payment_amount : String?
    var currency_code : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        loadingView = MyUtils.customLoader(self.window)
        prodObj = DataStore.sharedInstance.getProductByID(productID!)
        viewCell.layer.cornerRadius = 10;
        viewCell.contentMode = .scaleAspectFill
        viewCell.clipsToBounds = true
        btnBuyNow.layer.cornerRadius = 10
        btnBuyNow.clipsToBounds = true
        MyUtils.load_image(image_url_string: (prodObj?.item_image1)!, view:imgProduct!)
        lblProductName.text = prodObj?.item_name
        lblProductDesc.text = prodObj?.item_des
        lblProductPrice.text = prodObj?.item_price
        
        
        //successView.isHidden = true
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Marco Island"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    
    // MARK: Single Payment
    @IBAction func buyProductAction(_ sender: AnyObject) {
        
        if Connectivity.isConnectedToInternet {
            self.view.addSubview(loadingView!)
            let baseURL :String = RestcallManager.sharedInstance.getBaseUrl()
//            let strURL : String = baseURL + "orderPlacing?member_id="+MyUtils.getUserDefault(key: "memberID")
//            +"&item_id="+productID+"&parent_child=P&purchase_qty=1&price_per_unit="+\(prodObj?.item_price)!+"&total_amt = "+
//            (prodObj?.item_price)!
            
            var strURL : String = baseURL + "orderPlacing?member_id="+MyUtils.getUserDefault(key: "memberID")+"&item_id="+productID!
           strURL = strURL + "&parent_child=P&purchase_qty=1&price_per_unit="
            strURL = strURL + (prodObj?.item_price)!+"&total_amt="+(prodObj?.item_price)!
           
            Alamofire.request(strURL)
                .responseJSON { response in
                    
                    guard response.result.error == nil else {
                        print(response.result.error!)
                        return
                    }
                    
                    guard let json = response.result.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    
                    var webResponse: WebServiceResponse? = nil
                    webResponse = WebServiceResponse().initWithJsonData(jsonData: json) as? WebServiceResponse
                    if webResponse != nil && (webResponse?.StatusCode == "0") && webResponse?.Data != nil {
                        self.orderID = webResponse?.Data
                        self.callPaypalService()
                    }
                    else if webResponse != nil && (webResponse?.StatusCode != "0") && webResponse?.Data != nil {
                        MyUtils.sharedInstance.showAlertViewDialog(title: "Oops!!!", msg: (webResponse?.Data)!, controller: self, okClicked: {
                        })
                    }
                    else{
                        MyUtils.sharedInstance.showAlertViewDialog(title: "Oops!!!", msg: "We are having an issue connecting to server. Please try again after some time.", controller: self, okClicked: {
                        })
                    }
            }
        }
        else{
            MyUtils.sharedInstance.showAlertViewDialog(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
        
        //callPaypalService()
    }
    
    
    func callPaypalService(){
        resultText = ""
        
        // Optional: include multiple items
        let item1 = PayPalItem(name: (prodObj?.item_name)!, withQuantity: 1, withPrice: NSDecimalNumber(string: prodObj?.item_price), withCurrency: "USD", withSku: "")
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: (prodObj?.item_name)!, intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            print("Payment not processalbe: \(payment)")
        }
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        resultText = ""
        //successView.isHidden = true
        paymentViewController.dismiss(animated: true, completion: nil)
        self.loadingView?.removeFromSuperview()
        let alertController = UIAlertController(title: "Failed!!!", message: "Payment has been cancelled", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            self.sendCompletedPaymentToServer(completedPayment: completedPayment)
        })
    }
    
    // MARK: Helpers
    
    func sendCompletedPaymentToServer(completedPayment: PayPalPayment) {
        print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        self.resultText = completedPayment.description
        
        paypal_payment_amount = String(describing: completedPayment.amount)
        currency_code = completedPayment.currencyCode
        var paymentResultDict = completedPayment.confirmation
        let response_type = paymentResultDict["response_type"] as? String
        let responseObj = paymentResultDict["response"] as! NSObject?
        paypal_payment_id = responseObj?.value(forKey: "id") as? String
        paypal_state = responseObj?.value(forKey: "state") as? String
        
        if response_type == "payment" &&  paypal_state == "approved" {
            OrderConfirmation()
        }
    }
    
    
    func OrderConfirmation(){
        if Connectivity.isConnectedToInternet {
            self.view.addSubview(loadingView!)
            let baseURL :String = RestcallManager.sharedInstance.getBaseUrl()
            
            var strURL : String = baseURL + "orderUpdating?order_id="+orderID!+"&payment_id="+paypal_payment_id!
            strURL = strURL + "&pay_success="+paypal_state!
            
            Alamofire.request(strURL)
                .responseJSON { response in
                    
                    guard response.result.error == nil else {
                        print(response.result.error!)
                        return
                    }
                    
                    guard let json = response.result.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    
                    var webResponse: WebServiceResponse? = nil
                    webResponse = WebServiceResponse().initWithJsonData(jsonData: json) as? WebServiceResponse
                    if webResponse != nil && (webResponse?.StatusCode == "0") && webResponse?.Data != nil {
                        self.loadingView?.removeFromSuperview()
                        let alertController = UIAlertController(title: "Success!!!", message: "Payment successful", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                            self.dismiss(animated: true, completion: nil)
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else if webResponse != nil && (webResponse?.StatusCode != "0") && webResponse?.Data != nil {
                        self.loadingView?.removeFromSuperview()
                        MyUtils.sharedInstance.showAlertViewDialog(title: "Oops!!!", msg: (webResponse?.Data)!, controller: self, okClicked: {
                        })
                    }
                    else{
                        self.loadingView?.removeFromSuperview()
                        MyUtils.sharedInstance.showAlertViewDialog(title: "Oops!!!", msg: "We are having an issue connecting to server. Please try again after some time.", controller: self, okClicked: {
                        })
                    }
            }
        }
        else{
            MyUtils.sharedInstance.showAlertViewDialog(title: "Alert!", msg: "No Internet connection.", controller: self, okClicked: {
            })
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
