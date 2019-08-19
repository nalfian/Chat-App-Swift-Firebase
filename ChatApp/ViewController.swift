//
//  ViewController.swift
//  ChatApp
//
//  Created by Unknwon on 01/07/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameInputView: UITextField!
    @IBOutlet weak var messageTextView: UITextField!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    var databaseRef: DatabaseReference!
    let userDefaults = UserDefaults.standard
    var roomName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDb()
        getChatFromRoom()
        setupKeyboard()
        setupView()
    }
    
    func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func setupView(){
        nameInputView.delegate = self
        nameInputView.text = userDefaults.object(forKey: "name") as? String ?? ""
    }
    
    func initDb(){
         databaseRef = Database.database().reference().child(roomName!)
    }
    
    func getChatFromRoom(){
        databaseRef.observe(.childAdded, with: { snapshot in
            if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message = obj["message"] {
                let currentText = self.textView.text
                self.textView.text = (currentText ?? "") + "\n\(name) : \(message)"
            }
        })
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        view.endEditing(true)
        
        if let name = nameInputView.text, let message = messageTextView.text {
            let messageData = ["name": name, "message": message]
            databaseRef.childByAutoId().setValue(messageData)
            
            messageTextView.text = ""
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            inputViewBottom.constant = keyboardFrameInfo.cgRectValue.height
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        inputViewBottom.constant = 0
    }
    
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let inputText = textField.text else {
            return true
        }
        userDefaults.set(inputText, forKey: "name")
        userDefaults.synchronize()
        return true
    }
}

