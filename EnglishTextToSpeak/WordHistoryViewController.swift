//
//  WordHistoryViewController.swift
//  EnglishTextToSpeak
//
//  Created by kenji on 2020/07/14.
//  Copyright © 2020 momo. All rights reserved.
//

import UIKit
import AVFoundation

class WordHistoryViewController:UIViewController{
    
    var speechSynthesizer : AVSpeechSynthesizer!
    @IBOutlet weak var wordHistoryTableView: UITableView!
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        wordHistoryTableView.reloadData()
        
        setUpView()
        
        
    }
    func setUpView(){
        wordHistoryTableView.tableFooterView = UIView()
        wordHistoryTableView.delegate = self
        wordHistoryTableView.dataSource = self
        wordHistoryTableView.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .rgba(red: 39, green: 49, blue: 79, alpha: 1)
        navigationItem.title = "履歴"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        
       
    }
    func text2speak(text:String){
        // AVSpeechSynthesizerのインスタンス作成
        
        self.speechSynthesizer = AVSpeechSynthesizer()
        // 読み上げる、文字、言語などの設定
        let utterance = AVSpeechUtterance(string:text) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 言語
        utterance.rate = 0.5; // 読み上げ速度
        utterance.pitchMultiplier = 1.5; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0.01; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
    }
}

extension WordHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historyWord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = wordHistoryTableView.dequeueReusableCell(withIdentifier: cellId,for:indexPath) as! WordHistoryTableViewCell
        cell.backgroundColor = .white
        cell.word = historyWord[indexPath.row]!
        
        let button = cell.pushedSpeechButton
        button?.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        cell.pushedSpeechButton.tag = indexPath.row
        
        return cell
        
    }
    @objc func buttonEvent(_ sender: UIButton) {
        text2speak(text: historyWord[sender.tag] ?? "")
    }
    
}

class WordHistoryTableViewCell:UITableViewCell{
    @IBOutlet weak var wordLable: UILabel!
    
    @IBOutlet weak var pushedSpeechButton: UIButton!
    
    var word : String?{
        didSet{
            wordLable.text = word
            wordLable.textColor = .black
            
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
