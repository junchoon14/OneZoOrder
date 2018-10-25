//
//  OrderEditTableViewController.swift
//  OneZoOrder
//
//  Created by Jason Hsu on 2018/8/26.
//  Copyright © 2018 junchoon. All rights reserved.
//

import UIKit

class OrderEditTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var order: TeaData!
    var editOrder: TeaData!
    var buttonTitle: String!
    
    var teaTitles = ["原味 · 食茶", "獨味 · 食茶", "特調 · 食茶", "雷蒙 · 食茶", "蜂蜜 · 食茶", "自然 · 食茶", "奶濃 · 食茶", "拿鐵 · 食茶", "丸作 · 牛乳"]
    var teaPickerHidden = true
    var teaArray = [String]()
    var teaDic = [DrinkList]()
    var teaList_1 = [DrinkList]()
    var teaList_2 = [DrinkList]()
    var teaList_3 = [DrinkList]()
    var teaList_4 = [DrinkList]()
    var teaList_5 = [DrinkList]()
    var teaList_6 = [DrinkList]()
    var teaList_7 = [DrinkList]()
    var teaList_8 = [DrinkList]()
    var teaList_9 = [DrinkList]()
    var drinkTitle: String = "原味 · 食茶"
    var drink: String = ""
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var teaTitleLabel: UILabel!
    @IBOutlet weak var teaPicker: UIPickerView!
    @IBOutlet weak var teaNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cupSegController: UISegmentedControl!
    @IBOutlet weak var sugarSegController: UISegmentedControl!
    @IBOutlet weak var iceSegController: UISegmentedControl!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if nameTextField.text == "" || passwordTextField.text == "" || teaNameLabel.text == "選擇茶飲" {
            let errorAlert = UIAlertController(title: "有資料未輸入", message: "請輸入完整資料", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "Edit", sender: nil)
        }
    }
        
        
        
//        guard nameTextField.text == "", passwordTextField.text == "", teaNameLabel.text != "選擇茶飲" else {
//            self.performSegue(withIdentifier: "Edit", sender: nil)
//            return
//        }
//
//        let errorAlert = UIAlertController(title: "有資料未輸入", message: "請輸入完整資料", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
//        errorAlert.addAction(okAction)
//        self.present(errorAlert, animated: true, completion: nil)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        teaPicker.delegate = self
        teaPicker.dataSource = self
        
        //讀取茶的文字檔(TeaList.txt)
        if let url = Bundle.main.url(forResource: "TeaList", withExtension: "txt"), let teaData = try? String(contentsOf: url) {
            //將資料去掉"\n"轉為陣列
            teaArray = teaData.components(separatedBy: "\n")
        }
        for i in 0..<teaArray.count {
            if i % 2 == 0 {
                let drinkName = teaArray[i]
                let drinkPrice = teaArray[i + 1]
                teaDic.append(DrinkList(drinkName: drinkName, drinkPrice: drinkPrice))
            }
        }
        teaList_1 += teaDic[0...6]
        teaList_2 += teaDic[7...13]
        teaList_3 += teaDic[14...18]
        teaList_4 += teaDic[19...22]
        teaList_5 += teaDic[23...25]
        teaList_6 += teaDic[26...31]
        teaList_7 += teaDic[32...37]
        teaList_8 += teaDic[38...43]
        teaList_9 += teaDic[44...49]
        
        if let editOrder = editOrder {
            print(editOrder)
            nameTextField.isEnabled = false
            nameTextField.textColor = UIColor.gray
            nameTextField.text = editOrder.name
            passwordTextField.text = editOrder.password
            teaNameLabel.text = editOrder.teaName
            priceLabel.text = editOrder.price
            cupSegController.selectedSegmentIndex = Int(editOrder.cup)!
            sugarSegController.selectedSegmentIndex =  Int(editOrder.sugar)!
            iceSegController.selectedSegmentIndex =  Int(editOrder.ice)!
            noteTextField.text = editOrder.note
        }
        
    }
    
    // MARK: - UITableView
    //點擊茶飲顯示列，切換選擇器係數
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            togglePickerView()
        }
        //點選離開後，取消點選
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func togglePickerView() {
        teaPickerHidden = !teaPickerHidden
        tableView.beginUpdates() //開始更新tableView
        tableView.endUpdates()  //結束更新tableView
    }
    //控制cell高度為0則為隱藏，其他則為預設高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if teaPickerHidden && indexPath.section == 0 && indexPath.row == 3 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // MARK: - UIPickerView
    
    //設置pickerView組成的個數
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //設置每個組成顯示的個數
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return teaTitles.count
        case 1:
            switch drinkTitle {
            case "原味 · 食茶":
                return teaList_1.count
            case "獨味 · 食茶":
                return teaList_2.count
            case "特調 · 食茶":
                return teaList_3.count
            case "雷蒙 · 食茶":
                return teaList_4.count
            case "蜂蜜 · 食茶":
                return teaList_5.count
            case "自然 · 食茶":
                return teaList_6.count
            case "奶濃 · 食茶":
                return teaList_7.count
            case "拿鐵 · 食茶":
                return teaList_8.count
            case "丸作 · 牛乳":
                return teaList_9.count
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    //設置每個組成顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return teaTitles[row]
        case 1:
            switch drinkTitle {
            case "原味 · 食茶":
                return teaList_1[row].drinkName
            case "獨味 · 食茶":
                return teaList_2[row].drinkName
            case "特調 · 食茶":
                return teaList_3[row].drinkName
            case "雷蒙 · 食茶":
                return teaList_4[row].drinkName
            case "蜂蜜 · 食茶":
                return teaList_5[row].drinkName
            case "自然 · 食茶":
                return teaList_6[row].drinkName
            case "奶濃 · 食茶":
                return teaList_7[row].drinkName
            case "拿鐵 · 食茶":
                return teaList_8[row].drinkName
            case "丸作 · 牛乳":
                return teaList_9[row].drinkName
            default:
                return nil
            }
        default:
            return nil
        }
    }
    //設置選擇後的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            teaTitleLabel.text = teaTitles[row]
            drinkTitle = teaTitles[row]
            updateDrink(0)
            teaPicker.reloadAllComponents()
            teaPicker.selectRow(0, inComponent: 1, animated: true)
        case 1:
            updateDrink(row)
            switch drinkTitle {
            case "原味 · 食茶":
                teaNameLabel.text = teaList_1[row].drinkName
                priceLabel.text = teaList_1[row].drinkPrice
            case "獨味 · 食茶":
                teaNameLabel.text = teaList_2[row].drinkName
                priceLabel.text = teaList_2[row].drinkPrice
            case "特調 · 食茶":
                teaNameLabel.text = teaList_3[row].drinkName
                priceLabel.text = teaList_3[row].drinkPrice
            case "雷蒙 · 食茶":
                teaNameLabel.text = teaList_4[row].drinkName
                priceLabel.text = teaList_4[row].drinkPrice
            case "蜂蜜 · 食茶":
                teaNameLabel.text = teaList_5[row].drinkName
                priceLabel.text = teaList_5[row].drinkPrice
            case "自然 · 食茶":
                teaNameLabel.text = teaList_6[row].drinkName
                priceLabel.text = teaList_6[row].drinkPrice
            case "奶濃 · 食茶":
                teaNameLabel.text = teaList_7[row].drinkName
                priceLabel.text = teaList_7[row].drinkPrice
            case "拿鐵 · 食茶":
                teaNameLabel.text = teaList_8[row].drinkName
                priceLabel.text = teaList_8[row].drinkPrice
            case "丸作 · 牛乳":
                teaNameLabel.text = teaList_9[row].drinkName
                priceLabel.text = teaList_9[row].drinkPrice
            default:
                print("Error")
            }
        default:
            break
        }
    }
    
    func updateDrink(_ row: Int) {
        if drinkTitle == "原味 · 食茶" {
            drink = teaList_1[row].drinkName
        } else if drinkTitle == "獨味 · 食茶" {
            drink = teaList_2[row].drinkName
        } else if drinkTitle == "特調 · 食茶" {
            drink = teaList_3[row].drinkName
        } else if drinkTitle == "雷蒙 · 食茶" {
            drink = teaList_4[row].drinkName
        } else if drinkTitle == "蜂蜜 · 食茶" {
            drink = teaList_5[row].drinkName
        } else if drinkTitle == "自然 · 食茶" {
            drink = teaList_6[row].drinkName
        } else if drinkTitle == "奶濃 · 食茶" {
            drink = teaList_7[row].drinkName
        } else if drinkTitle == "拿鐵 · 食茶" {
            drink = teaList_8[row].drinkName
        } else if drinkTitle == "丸作 · 牛乳" {
            drink = teaList_9[row].drinkName
        } else {
            print("Error")
        }
    }
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let name = nameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let teaName = teaNameLabel.text ?? ""
        let price = priceLabel.text ?? ""
        let cup = cupSegController.selectedSegmentIndex.description
        let sugar = sugarSegController.selectedSegmentIndex.description
        let ice = iceSegController.selectedSegmentIndex.description
        let note = noteTextField.text ?? ""
    
        let teaData: [String: Any] = ["name": name, "password": password, "teaName": teaName, "price": price, "cup": cup, "sugar": sugar, "ice": ice, "note": note]
        order = TeaData(json: teaData)
        buttonTitle = navigationItem.rightBarButtonItem?.title

    }
    
}
