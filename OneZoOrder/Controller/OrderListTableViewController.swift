//
//  OrderListTableViewController.swift
//  OneZoOrder
//
//  Created by Jason Hsu on 2018/8/26.
//  Copyright © 2018 junchoon. All rights reserved.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    
    var searchController: UISearchController?
    var getOrder: TeaData!
    var teaOrders = [TeaData]()
    var seachResult = [TeaData]()
    var password: String!
    
    
    
    @IBOutlet weak var listSearchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        getData()
        print(teaOrders)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return teaOrders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderListTableViewCell
        
        var order = teaOrders[indexPath.row]
        order.id = String(teaOrders.count)
        cell.numberLabel.text = "No.\(order.id)"
        cell.nameLabel.text = order.name
        cell.teaNameLabel.text = order.teaName
        cell.priceLabel.text = order.price
        cell.noteLabel.text = order.note
        cell.noteLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.noteLabel.numberOfLines = 0
        cell.cupLabel.text = order.cup == "0" ? "M" : "L"
        //選糖度
        switch order.sugar {
        case "0":
            cell.sugarLabel.text = "平常糖"
        case "1":
            cell.sugarLabel.text = "少糖"
        case "2":
            cell.sugarLabel.text = "半糖"
        case "3":
            cell.sugarLabel.text = "微糖"
        case "4":
            cell.sugarLabel.text = "無糖"
        default:
            cell.sugarLabel.text = "Error"
        }
        //選冰度
        switch order.ice {
        case "0":
            cell.iceLabel.text = "平常冰"
        case "1":
            cell.iceLabel.text = "少冰"
        case "2":
            cell.iceLabel.text = "微冰"
        case "3":
            cell.iceLabel.text = "去冰"
        case "4":
            cell.iceLabel.text = "常溫"
        case "5":
            cell.iceLabel.text = "熱飲"
        default:
            cell.iceLabel.text = "Error"
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    // MARK: - Data Process
    @IBAction func unwindToOrderListView(segue: UIStoryboardSegue) {
        
        if let source = segue.source as? OrderEditTableViewController, let order = source.order {
           
            if order.name == "" || order.password == "" || order.teaName == "  選擇茶飲" {
                //顯示錯誤視窗
                let errorAlert = UIAlertController(title: "有資料未輸入", message: "請輸入完整資料", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
            } else {
                teaOrders.insert(order, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                getOrder = order
                print(getOrder)
                sendData()
            }
        }
    }

        func sendData() {
            
            let url = URL(string: "https://sheetdb.io/api/v1/5b8961965a7fd")
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
            let orderData: [String: String] = ["id": getOrder.id, "name": getOrder!.name, "password": getOrder!.password, "teaName": getOrder!.teaName, "price": getOrder!.price, "cup": getOrder!.cup, "sugar": getOrder!.sugar, "ice": getOrder!.ice, "note": getOrder!.note, "editable": getOrder.editable]
            let postData: [String: Any] = ["data": orderData]
            do {
                let data = try JSONSerialization.data(withJSONObject: postData, options: [])
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (reData, response, error) in
                    if let returnData = reData, let dic = (try? JSONSerialization.jsonObject(with: returnData)) as? [String: String] {
                        print(dic)
                    }
                }
                task.resume()
            }
            catch {
                
            }
        }
        
    
    func getData() {
        let urlStr = "https://sheetdb.io/api/v1/5b8961965a7fd"//.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data, let dic = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for list in dic! {
                    if let teaList = TeaData(json: list) {
                        self.teaOrders.append(teaList)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func editData() {
        let url = URL(string: "https://sheetdb.io/api/v1/5b8961965a7fd")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //task.resume()
    }
    
    func deleteData() {
        let url = URL(string: "https://sheetdb.io/api/v1/5b8961965a7fd")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //task.resume()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // MARK: - Table view trailing Swipe Actions
    //設置向左滑，就會出現刪除和編輯訂單的按鈕
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //生成"刪除"功能的按鈕
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (action, sourceView, compeletionHandler) in
            self.teaOrders.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //取消動作按鈕
            compeletionHandler(true)
            
        }
        //生成"編輯"功能的按鈕
        let editAction = UIContextualAction(style: .normal, title: "編輯") { (action, sourceView, compeletionHandler) in
            //self.name = self.teaOrders[indexPath.row].name
            self.getOrder = self.teaOrders[indexPath.row]
            print(self.password)
            self.inputPassword()
            //取消動作按鈕
            compeletionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeConfiguration
    }
    
    // MARK: - UIAlertController
    //產生密碼視窗
    func inputPassword() {
        //產生Alert視窗
        let checkAlert = UIAlertController(title: nil, message: "請輸入密碼", preferredStyle: .alert)
        // 產生確認按鍵
        let okAction = UIAlertAction(title: "確認", style: .default) { (action: UIAlertAction) in
            //let nameAlertTextField  = checkAlert.textFields![0] as UITextField
            let passwordAlertTextField = checkAlert.textFields![0] as UITextField
            if passwordAlertTextField.text! == self.getOrder.password  {
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "OrderEdit") as? OrderEditTableViewController {
                    controller.editOrder = self.getOrder
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                self.dismiss(animated: true, completion: nil)
                
            } else {

                let errorAlert = UIAlertController(title: "資料錯誤", message: "請重新輸入密碼", preferredStyle: .alert)
                 // 產生確認按鍵
                let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                //顯示錯誤視窗
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        // 產生取消按鍵
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        // 增加Password的Text Field到AlertController
        checkAlert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "請輸入密碼"
            textField.borderStyle = UITextField.BorderStyle.roundedRect
        })
        checkAlert.addAction(cancelAction)
        checkAlert.addAction(okAction)
        // 顯示Alert
        self.present(checkAlert, animated: true, completion: nil)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}