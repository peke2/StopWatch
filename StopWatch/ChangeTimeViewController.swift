//
//  ChangeTimeViewController.swift
//  StopWatch
//
//  Created by peke2 on 2017/07/17.
//  Copyright © 2017年 peke2. All rights reserved.
//

import UIKit

protocol ChangeTimeViewDelegate {
	func didTimeChanged(hour h:Int, minute m:Int, second s:Int)
}


class ChangeTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	var delegate : ChangeTimeViewDelegate! = nil
	
	var defaultHour:Int = 0
	var defaultMinute:Int = 0
	var defaultSecond:Int = 0
	
	@IBOutlet weak var changeTimePickerView: UIPickerView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		changeTimePickerView.delegate = self
		changeTimePickerView.dataSource = self
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setTime(hour h:Int32, minute m:Int32, second s:Int32)
	{
		changeTimePickerView.selectRow(Int(h), inComponent: 0, animated: false)
		changeTimePickerView.selectRow(Int(m), inComponent: 1, animated: false)
		changeTimePickerView.selectRow(Int(s), inComponent: 2, animated: false)
		
		defaultHour = Int(h)
		defaultMinute = Int(m)
		defaultSecond = Int(s)
	}
	
	
	//	コンポーネント数を返す
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		//	「時」「分」「秒」
		return 3
	}

	//	コンポーネント中の項目数を返す
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
	
		//	「12」時間「60」分「60」秒
		let numRows = [12, 60, 60]
		return numRows[component]
	}
	
	//	各コンポーネントの横幅を返す
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return 100;
	}
	
	
	//	各項目の内容を返す
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

		let title = ["時間", "分", "秒"]
		return row.description + title[component]
	}

	
	//	項目が選択された
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
	}
	
	@IBAction func didDecided(_ sender: UIButton) {
		let hour = changeTimePickerView.selectedRow(inComponent: 0)
		let minute = changeTimePickerView.selectedRow(inComponent: 1)
		let second = changeTimePickerView.selectedRow(inComponent: 2)
	
		print("選択["+hour.description+":"+minute.description+":"+second.description+"]")
	
		self.delegate.didTimeChanged(hour: hour, minute: minute, second: second)
	
	}
	
	@IBAction func didCanceled(_ sender: UIButton) {
		print("キャンセルされました")
		self.delegate.didTimeChanged(hour: defaultHour, minute: defaultMinute, second: defaultSecond)
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
