//
//  MerchandiseViewController.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/5/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit
import Alamofire

class MerchandiseViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var window: UIWindow?
    var loadingView : UIView?
    @IBOutlet var tableViewProduct : UITableView?
    var productArray : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        loadingView = MyUtils.customLoader(self.window)
        tableViewProduct?.isHidden=true
        self.retrieveData()
    }

    func retrieveData(){
        if Connectivity.isConnectedToInternet {
            self.view.addSubview(loadingView!)
            let baseURL :String = RestcallManager.sharedInstance.getBaseUrl()
            let strURL : String = baseURL + "listOfItems"
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
                        let responseData = webResponse?.Data.data(using: .utf8)!
                        let decoder = JSONDecoder()
                        
                        do {
                            let dataArray = try decoder.decode([ProductMaster].self, from: responseData!)
                            DataStore.sharedInstance.addProduct(dataArray as NSArray)
                            self.populateData()
                        } catch {
                            print(error)
                        }
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
    }
    
    func populateData(){
        loadingView?.removeFromSuperview()
        tableViewProduct?.isHidden=false
        productArray = (DataStore.sharedInstance.getProduct()).mutableCopy() as! NSMutableArray
        tableViewProduct?.reloadData()
    }
    
    //tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //make sure you use the relevant array sizes
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : ProductCell! = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        if(cell == nil)
        {
            cell = Bundle.main.loadNibNamed("ProductCell", owner: self, options: nil)![0] as! ProductCell;
        }
        let productObj: ProductMaster = productArray[indexPath.row] as! ProductMaster
        cell.lblProductName.text = productObj.item_name
        cell.lblProductDesc.text = productObj.item_des
        cell.lblProductPrice.text = productObj.item_price
        
        cell.imgProduct.contentMode = .scaleAspectFill
        cell.imgProduct.clipsToBounds = true
//        AsyncImageLoader.shared().cancelLoadingImages(forTarget: cell.imgProduct)
//        cell.imgProduct.image = UIImage(named: "user")
//        cell.imgProduct.imageURL = URL(string: productObj.item_image1!)
        
        load_image(image_url_string: productObj.item_image1!, view:cell.imgProduct)

        return cell as ProductCell
    }
    
    func load_image(image_url_string:String, view:UIImageView)
    {
        
        var image_url: NSURL = NSURL(string: image_url_string)!
        let image_from_url_request: NSURLRequest = NSURLRequest(url: image_url as URL)
        
        NSURLConnection.sendAsynchronousRequest(
            image_from_url_request as URLRequest, queue: OperationQueue.main,
            completionHandler: {(response: URLResponse!,
                data: Data!,
                error: Error!) -> Void in

                if error == nil && data != nil {
                    view.image = UIImage(data: data)
                }

        })
        
        
//        let request = URLRequest(url: URL(string: image_url_string)!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//
//            do {
//                if error == nil && data != nil {
//                    view.image = UIImage(data: data!)
//                }
//            } catch {
//                print("error")
//            }
//
//        })
        
//       task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
