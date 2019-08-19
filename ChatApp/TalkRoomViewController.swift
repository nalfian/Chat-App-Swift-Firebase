//
//  TalkRoomViewController.swift
//  ChatApp
//
//  Created by Unknown on 03/07/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation
import  UIKit
import FirebaseDatabase

class  TalkRoomViewController :  UITableViewController  {
    
    var dataRef: DatabaseReference? = nil
    var roomData = [String]()
    
    override  func  viewDidLoad () {
        super.viewDidLoad ()
        initDb()
        getRoom()
    }
    
    func getRoom(){
        dataRef?.observe(.childAdded, with: { dataSnapshot in
            self.roomData.append(dataSnapshot.key)
            self.tableView.reloadData()
        })
    }
    
    func initDb(){
        dataRef = Database.database().reference()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return roomData.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case ..<roomData.count:
            cell.textLabel?.text = roomData[indexPath.row]
        default:
            setupTextCreate(cell)
        }
        return cell
    }
    
    func setupTextCreate(_ cell: UITableViewCell){
        cell.textLabel?.text = "+ Create New Room"
        cell.textLabel?.textColor = UIColor.blue
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case ..<roomData.count:
            let roomName = roomData[indexPath.row]
            self.performSegue(withIdentifier: "showRoomView", sender: roomName)
        default:
            showModal()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showRoomView", let targetVC = segue.destination as? ViewController else {
            return
        }

        if let roomName = sender as? String {
            targetVC.roomName = roomName
        }
    }
    
    func showModal(){
        self.performSegue(withIdentifier: "modalCreateRoomView", sender: nil)
    }
    
}
