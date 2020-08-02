//
//  ViewController.swift
//  EnglishTextToSpeak
//
//  Created by kenji on 2020/07/12.
//  Copyright © 2020 momo. All rights reserved.
//

import CropViewController
import UIKit
import Firebase
import AVFoundation




var historyWord : [String?] = ["editor","eat","string"]

class ViewController:UIViewController, UIImagePickerControllerDelegate,UIScrollViewDelegate, UINavigationControllerDelegate{
    
    var takeImage:UIImage?
    var onesFirstWillApear:Bool?
    var speechSynthesizer : AVSpeechSynthesizer!
    
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var OCRTextLabel: UILabel!
    override func viewDidLoad() {
           super.viewDidLoad()
        setUpView()
    }
    func getHistoryWord()->[String?]{
        
        return historyWord
    }
    func addList(text:String?){
        
        historyWord.append(text!)
    }
    func setUpView(){
       
        navigationItem.title = "English Text-to-Speech"
        navigationController?.navigationBar.barTintColor = .rgba(red: 39, green: 49, blue: 79, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        
        
        let goHistoryButton = UIBarButtonItem(title: "履歴", style: .plain, target: self, action: #selector(tappedGoHistoryButton))
        
        navigationItem.rightBarButtonItem = goHistoryButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        OCRTextLabel.layer.cornerRadius = 20
        OCRTextLabel.textColor = .black
        OCRTextLabel.backgroundColor = .rgba(red: 242, green: 242, blue: 247, alpha: 1)
        OCRTextLabel.clipsToBounds = true
        OCRTextLabel.layer.borderWidth = 1
        takePhotoButton.layer.cornerRadius = 50
        
        takePhotoButton.setTitleColor(.white, for: .normal)
    }
    
    @objc func tappedGoHistoryButton(){
        let storyborad = UIStoryboard(name: "WordHistory", bundle: nil)
        let wordHistoryViewController = storyborad.instantiateViewController(withIdentifier: "WordHistoryViewController") as! WordHistoryViewController
        navigationController?.pushViewController(wordHistoryViewController, animated: true)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        if onesFirstWillApear == true{
            let cropViewController = CropViewController(image:takeImage ?? UIImage())
            cropViewController.delegate = self
            present(cropViewController, animated: true, completion: nil)
        }
        onesFirstWillApear = false
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        // UIImagePickerController カメラを起動する
        present(picker, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        takeImage = info[.originalImage] as! UIImage
        onesFirstWillApear = true
        
        // UIImagePickerController カメラが閉じる
        self.dismiss(animated: true, completion: nil)
        
    }

    
    func Image2TextTransformer(inputimage:UIImage?){
        var output:String?
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: inputimage ?? UIImage())
        textRecognizer.process(visionImage) { result, error in
            if error == nil{
                output = result?.text ?? ""
                self.addList(text: output)
                self.OCRTextLabel.text =  result?.text ?? ""
                self.text2speak(text:  result?.text ?? "")
                
            }
          // Recognized text
        }
       
        
    }
    func text2speak(text:String){
        // AVSpeechSynthesizerのインスタンス作成
        
        self.speechSynthesizer = AVSpeechSynthesizer()
        // 読み上げる、文字、言語などの設定
        
        let utterance = AVSpeechUtterance(string:text) // 読み上げる文字
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 言語
        utterance.rate = 0.5; // 読み上げ速度
        utterance.pitchMultiplier = 1.5; // 読み上げる声のピッチ
        utterance.preUtteranceDelay = 0.2; // 読み上げるまでのため
        self.speechSynthesizer.speak(utterance)
        
    }

    
}
extension ViewController: CropViewControllerDelegate {

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        Image2TextTransformer(inputimage: image)

        cropViewController.dismiss(animated: true, completion: nil)
    }

    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        // キャンセル時
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}


    
  

