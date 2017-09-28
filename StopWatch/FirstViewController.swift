//
//  FirstViewController.swift
//  StopWatch
//
//  Created by peke2 on 2017/06/25.
//  Copyright © 2017年 peke2. All rights reserved.
//

import UIKit
import AVFoundation


class FirstViewController: UIViewController, AVAudioPlayerDelegate, UITextFieldDelegate, ChangeTimeViewDelegate {

	@IBOutlet weak var timeLabel: UILabel!
	
	var changeTimeView = ChangeTimeViewController()
	var selectedButton : UIButton?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		initPlayer()
		//textBellTime1.delegate = self
		//textBellTime2.delegate = self

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.mainView = self
		
		
		changeTimeView = self.storyboard!.instantiateViewController(withIdentifier :"ChangeTime") as! ChangeTimeViewController
		
		changeTimeView.delegate = self;
		
		//	設定ファイルを読み込む
		readFromFile()

		textBellCount1.text = bellCount1.description
		textBellCount2.text = bellCount2.description

		stepperBellCount1.value = Double(bellCount1)
		stepperBellCount2.value = Double(bellCount2)
		
		buttonBellTime1.setTitle(convertToTimeDisp(second: bellTimeSecond1), for:UIControlState.normal)
		buttonBellTime2.setTitle(convertToTimeDisp(second: bellTimeSecond2), for:UIControlState.normal)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func saveConfig()
	{
		writeToFile()
	}

	@IBOutlet weak var stepperBellCount1: UIStepper!
	@IBOutlet weak var stepperBellCount2: UIStepper!
	
	@IBOutlet weak var textBellCount1: UITextField!
	@IBOutlet weak var textBellCount2: UITextField!
	
	@IBOutlet weak var textBellTime1: UITextField!
	@IBOutlet weak var textBellTime2: UITextField!

	@IBOutlet weak var buttonBellTime1: UIButton!
	@IBOutlet weak var buttonBellTime2: UIButton!
	
	//	ベル再生回数の変更
	@IBAction func didChangedStepper1(_ sender: UIStepper){
		bellCount1 = Int32(sender.value)
		textBellCount1.text = String(bellCount1)
	}
	
	@IBAction func didChangedStepper2(_ sender: UIStepper) {
		bellCount2 = Int32(sender.value)
		textBellCount2.text = String(bellCount2)
	}
	
	@IBAction func backHome(segue:UIStoryboardSegue)
	{
		
	}
	
	//	時間変更開始
	@IBAction func didSelectedButton(_ sender: UIButton) {
		self.present(changeTimeView, animated: true, completion: nil)
		selectedButton = sender

		var sec : Int32
		if( sender.restorationIdentifier == "TimeButton1" )
		{
			sec = bellTimeSecond1
		}
		else if( sender.restorationIdentifier == "TimeButton2" )
		{
			sec = bellTimeSecond2
		}
		else
		{
			sec = 0
		}
		
		var elem = convertToTimeArray(second: sec)
		
		changeTimeView.setTime(hour: elem[0], minute:elem[1], second: elem[2])
		
	}
	
	var bellTimeSecond1:Int32 = 0
	var bellTimeSecond2:Int32 = 0
	var bellCount1:Int32 = 0
	var bellCount2:Int32 = 0
	
	var timer = Timer()
	
	var elapsed_seconds:Int32 = 0
	var running = false
	var audioPlayer: AVAudioPlayer!
	var audioPlayer1: AVAudioPlayer!
	var audioPlayer2: AVAudioPlayer!

	func startTimer()
	{
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(FirstViewController.updateTime)), userInfo: nil, repeats: true)
		
	}
	
	
	func updateTime()
	{
		elapsed_seconds += 1
		
		updateTimerDisp()
		
		if 0<bellCount1
		{
			if bellTimeSecond1 == elapsed_seconds
			{
				for i in 0...bellCount1-1 {
					playBell(delaySec: 0.5*Double(i))
				}
			}
		}
		if 0<bellCount2
		{
			if bellTimeSecond2 == elapsed_seconds
			{
				for i in 0...bellCount2-1 {
					playBell(delaySec: 0.5*Double(i))
				}
			}
		}
	}

	//	時分秒を秒に変換
	func convertToSecond(hour h:Int, minute m:Int, second s:Int)->Int32
	{
		return Int32(h*3600+m*60+s)
	}

	//	秒を時分秒それぞれの要素の配列に変換
	func convertToTimeArray(second s:Int32)->[Int32]
	{
		var sec = s
		let hour = sec / 3600
		sec -= hour * 3600
		let minute = sec / 60
		sec -= minute * 60
		
		return [hour, minute, sec]
	}
	
	//	秒を表示形式に変換
	func convertToTimeDisp(second s:Int32)->String
	{
		let elem = convertToTimeArray(second: s)
		return String.init(format: "%02d:%02d:%02d", elem[0], elem[1], elem[2])
	}

	//	時間表示を更新
	func updateTimerDisp()
	{
		timeLabel.text = convertToTimeDisp(second: elapsed_seconds)
	}
	
	//	再生用のPlayerを初期化
	func initPlayer()
	{
		let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: "bell", ofType: "mp3")!)
		do
		{
			audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
			audioPlayer.delegate = self
			audioPlayer.setVolume(1.0, fadeDuration: 0)
			audioPlayer.prepareToPlay()

			audioPlayer1 = try AVAudioPlayer(contentsOf: audioPath)
			audioPlayer1.delegate = self
			audioPlayer1.setVolume(1.0, fadeDuration: 0)
			audioPlayer1.prepareToPlay()
			
			audioPlayer2 = try AVAudioPlayer(contentsOf: audioPath)
			audioPlayer2.delegate = self
			audioPlayer2.setVolume(1.0, fadeDuration: 0)
			audioPlayer2.prepareToPlay()
		}
		catch{
			
		}
	}

	func playBell(delaySec:Double=0)
	{
		let delay:Double = delaySec
		if( false == audioPlayer.isPlaying )
		{
			audioPlayer.play(atTime:audioPlayer.deviceCurrentTime + delay)
			//audioPlayer.play()
		}
		else if( false == audioPlayer1.isPlaying )
		{
			audioPlayer1.play(atTime: audioPlayer.deviceCurrentTime + delay)
		}
		else if( false == audioPlayer2.isPlaying )
		{
			audioPlayer2.play(atTime: audioPlayer.deviceCurrentTime + delay)
		}
	}
	
	//	設定ファイルの書き出し・読み込み
	let configFileName = NSHomeDirectory() + "/Documents/user_config.plist"
	
	func writeToFile()
	{
		//print("write to:"+configFileName)

		let dict : NSMutableDictionary = [:]
		dict.setValue(bellTimeSecond1, forKey: "second1")
		dict.setValue(bellTimeSecond2, forKey: "second2")
		dict.setValue(bellCount1, forKey: "count1")
		dict.setValue(bellCount2, forKey: "count2")

		dict.write(toFile: configFileName, atomically: true)
	}
	
	func readFromFile()
	{
		//print("write to:"+configFileName)
		
		let dict : NSMutableDictionary? = NSMutableDictionary(contentsOfFile: configFileName)
		
		if( dict == nil )
		{
			print("設定ファルがありません")
			return
		}
		
		bellTimeSecond1 = dict!.value(forKey:"second1") as! Int32
		bellTimeSecond2 = dict!.value(forKey:"second2") as! Int32
		bellCount1 = dict!.value(forKey:"count1") as! Int32
		bellCount2 = dict!.value(forKey:"count2") as! Int32
		
	}
	
	//	時間変更モーダルで変更があった
	func didTimeChanged(hour h: Int, minute m: Int, second s: Int) {
		//	選択されたボタンが取得できなければ何もしない
		if( selectedButton == nil )	{return}
		
		let btn : UIButton = selectedButton!
		
		let sec	= convertToSecond(hour: h, minute: m, second: s)
		let disp = convertToTimeDisp(second: sec)
		if( btn.restorationIdentifier == "TimeButton1" )
		{
			bellTimeSecond1 = sec
			buttonBellTime1.setTitle(disp, for: UIControlState.normal)
		}
		else if( btn.restorationIdentifier == "TimeButton2" ){
			bellTimeSecond2 = sec
			buttonBellTime2.setTitle(disp, for: UIControlState.normal)
		}
		
	}
	
	
	@IBAction func onStart(_ sender: UIButton) {
		if( running == false )
		{
			startTimer()
			running = true
		}
	}
	
	@IBAction func onStop(_ sender: UIButton) {
		if( running == true )
		{
			timer.invalidate()
			running = false
		}
	}
	
	@IBAction func onReset(_ sender: UIButton) {
		timer.invalidate()
		elapsed_seconds = 0
		running = false
		updateTimerDisp()
	}
	
	//テスト用
	@IBAction func onBell(_ sender: UIButton) {
		playBell()
	}
}

