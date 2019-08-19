//
//  CreateTalkRoomViewCOntroller.swift
//  ChatApp
//
//  Created by Unknown on 04/07/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class CreateTalkViewController: UIViewController {
    
    @IBOutlet weak var nputNameRoomView: UITextField!
    var dataRef: DatabaseReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatabase()
    }
    
    private func initDatabase() {
        dataRef = Database.database().reference()
    }
    
    @IBAction func createRoom(_ sender: Any) {
        createRoomInDb()
        dismiss(animated: true, completion: nil)
    }
    
    func createRoomInDb(){
        if let roomName = nputNameRoomView.text, !roomName.isEmpty{
            let instanceValue = ["name":"Alfian", "message":"Hello World!"]
            dataRef?.child(roomName).childByAutoId().setValue(instanceValue)
        }
    }

}
