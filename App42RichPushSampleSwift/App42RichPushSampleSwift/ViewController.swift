//
//  ViewController.swift
//  App42RichPushSampleSwift
//
//  Created by Purnima on 11/04/17.
//  Copyright © 2017 Shephertz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var pushTypeTextField: UITextField!
    @IBOutlet weak var pushPickerView: UIPickerView!
    
    let richPushArray = [app42RichPushTypeImage, app42RichPushTypeOpenUrl, app42RichPushTypeHTML, app42RichPushTypeVideo, app42RichPushTypeYouTubeVideo]
    let imageStr = "http://cdn.shephertz.com/repository/files/a97bf47de509c32f702e562cab2e7508389fb7d67d3322c4714c09aef4305f7c/e07985e3ddb8a537c457313aaa4402b80c5d66b3/port1push.jpg"
    let webStr = "http://blogs.shephertz.com/"
    var htmlStr = ""
    let videoStr = "http://cdn.shephertz.com/repository/files/cf077a193208596a23db85efe861c415f07b02ab3c605a234e594cb49b617762/689baa570914fa57f19b40c90f55e9912cacd547/ssassa.mp4"
    var youtubeStr = ""
    
//    let pushNotification : PushNotificationService = App42API.buildPushService() as! PushNotificationService
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTextField.text = "Hello From App42!"
        userNameTextField.text = App42API.getLoggedInUser()
        pushTypeTextField.isUserInteractionEnabled = false
        
        htmlStr = "<html><p style=background:aliceblue><b>Hello friend,</b>how are you?</p></html>"
//        "<html><head> <title>App42 Rich HTML Push</title></head><body><p>App42 Rich Push Sample</p><img src='\(imageStr)' alt='App42 Rish HTML Push' border='0'/><video controls><source src='http://stackoverflow.com/questions/31216758/how-can-i-add-nsapptransportsecurity-to-my-info-plist-file'></video></body></html>"
        
        youtubeStr = "<iframe width=\"\(self.view.frame.size.width)\" height=\"\(self.view.frame.size.height)\" src=\"https://www.youtube.com/embed/qTSDL94_Y7M\" frameborder=\"0\" allowfullscreen></iframe>"
      
        createPickerView()
        
    }
    
    func createPickerView() {
        pushPickerView.dataSource = self
        pushPickerView.delegate = self
        pushPickerView.showsSelectionIndicator = true
        
//        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ViewController.doneButtonClcik))
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: self.view.frame.size.height - pushPickerView.frame.size.height, width: pushPickerView.frame.size.width, height: 40.0))
//        let buttonArray = [doneButton]
//        toolBar.setItems(buttonArray, animated: true)
//        pushTypeTextField.inputView = pushPickerView
//        pushTypeTextField.inputAccessoryView = toolBar
    }

    func doneButtonClcik() {
        pushTypeTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func sendPushBtnClcik(_ sender: Any) {
        
        
        let username = App42API.getLoggedInUser()// userNameTextField.text?.replacingOccurrences(of: " ", with: "")
        let message = messageTextField.text
        let type = pushTypeTextField.text
        if !(username?.isEmpty)! && !(message?.isEmpty)! {
            
            let messageDict : [AnyHashable : Any] = [APP42_RICHPUSH_ALERT : message!, APP42_RICHPUSH_TYPE : type!, APP42_RICHPUSH_CONTENT : content]
            print("messageDict:----- \(messageDict)")

            let pushNotification = App42API.buildPushService() as! PushNotificationService
            pushNotification.sendPushMessage(toUser: username!, withMessageDictionary: messageDict, completionBlock: { (success, response, exception) in
                
                print(response ?? "hello")
//                print((exception?.reason)!)
                
                if success{
                    self.showAlertViewWithMessage(message: "Push sent to \(username) successfully.", title: "")
                }
                else{
                    self.showAlertViewWithMessage(message: (exception?.reason)!, title: "App42 Exception")
                }
            })
            
        }else{
            self.showAlertViewWithMessage(message: "Check Params required to perform the request!!", title: "Inavlid Params")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return richPushArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return richPushArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pushTypeTextField.text = richPushArray[row]

        if row == 0 {
            content = imageStr
        }else if row == 1{
            content = webStr
        }else if row == 2{
            content = htmlStr
        }else if row == 3{
            content = videoStr
        }else if row == 4{
            content = youtubeStr
        }
        
        print("content detail: \(content)")
    }
    
    func showAlertViewWithMessage(message : String, title : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion:nil)
        
    }
}

