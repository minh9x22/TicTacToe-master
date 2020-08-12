//
//  ChatRoomViewController.swift
//  TicTacToe
//
//  Created by admin on 8/11/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

var objRoomChat: Room?

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var arrDataMessage = [Chat]()
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var objroom: Room?
    var roomId: String?
    @IBOutlet weak var txtInputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        
     
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Tim key cua room hien tai
        ref?.child("rooms").queryOrdered(byChild: "roomName").queryEqual(toValue: objRoomChat?.roomName).observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                self.roomId = item.key
            }
        })
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref?.child("rooms").child(roomId!).child("chat").observe( .value, with: { (snapshot) in
            self.arrDataMessage = []
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    guard let _iduser = value["idUser"],
                        let _message = value["message"],
                        let _time = value["time"] else {
                            return
                    }
                    let obj = Chat(message: _message as! String, idUser: _iduser as! Int, time: _time as! String)
                    self.arrDataMessage.append(obj)
                    
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func onClickSendButton(_ sender: Any) {
        var iduser = 0
        var time = ""
        if role == "host" {
            iduser = 1
        } else {
            if role == "guess" {
                iduser = 2
            }
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minute = calendar.component(.minute, from: Date())
        time = String(hour)+":"+String(minute)
        ref?.child("rooms").child(roomId!).child("chat").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            var count = 0
            for _ in snapshot.children.allObjects as! [DataSnapshot] {
                count += 1
            }
            
            self.ref?.child("rooms").child(self.roomId!).child("chat").child(String(count+1)).child("message").setValue(self.txtInputText.text)
            self.ref?.child("rooms").child(self.roomId!).child("chat").child(String(count+1)).child("idUser").setValue(iduser)
            self.ref?.child("rooms").child(self.roomId!).child("chat").child(String(count+1)).child("time").setValue(time)
            
            self.txtInputText.text = ""
        })
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDataMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatRoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatRoomTableViewCell
        cell.lblMessage?.text =  "  " + arrDataMessage[indexPath.row].message + "  "
        let _iduser = arrDataMessage[indexPath.row].idUser
        let _time = arrDataMessage[indexPath.row].time
        let _username1 = objRoomChat?.user1.name
        let _username2 = objRoomChat?.user2.name
        if _iduser == 1 {
            cell.chatCellSatckview.alignment = .leading
            cell.lblMessage.layer.borderWidth = 2
            cell.lblMessage.layer.borderColor = UIColor.blue.cgColor
            cell.lblMessage.layer.cornerRadius = 5
            cell.lblMessage.layer.masksToBounds = true
            cell.lblUser?.text = _username1! + " - " + _time
        } else {
            if _iduser == 2 {
                cell.chatCellSatckview.alignment = .trailing
                cell.lblMessage.layer.borderWidth = 2
                cell.lblMessage.layer.borderColor = UIColor.green.cgColor
                cell.lblMessage.layer.cornerRadius = 5
                cell.lblMessage.layer.masksToBounds = true

                cell.lblUser?.text = _time + " - " + _username2!
            } else {
                cell.chatCellSatckview.alignment = .center
                cell.lblUser?.text = ""
            }
        }
        return cell
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
