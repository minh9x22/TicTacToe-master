//
//  ListRoomViewController.swift
//  TicTacToe
//
//  Created by admin on 8/7/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var arrRoomGB = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        ref?.child("rooms").observe( .value, with: { (snapshot) in
            self.arrRoomGB = []
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    guard let _roomname = value["roomName"],
                        let _usernum = value["userNumber"],
                        let _gameisactive = value["gameIsActive"],
                        let _turnuser = value["turnUser"] else {
                        return
                    }
                    
                    let user1 = value["user1"] as! NSDictionary
                    let _username1 = user1["name"] as! String
                    let _userid1 = user1["idUser"] as! Int
                    let user1obj = User(idUser: _userid1, name: _username1)
                    let user2 = value["user2"] as! NSDictionary
                    let _username2 = user2["name"] as! String
                    let _userid2 = user2["idUser"] as! Int
                    let user2obj = User(idUser: _userid2, name: _username2)
                    let gamestate = value["gameState"] as? NSDictionary
                    var arrTag = [Tag]()
                    for item in gamestate! {
                        let state = item.value as? NSDictionary
                        let iduser = state?["idUser"] as! Int
                        let value = state?["value"] as! Int
                        let i = state?["seq"] as! Int
                        let tagobj = Tag(seq: i, idUser: iduser, value: value)
                        arrTag.append(tagobj)
                    }
                    let roomobj = Room(roomName: _roomname as! String, gameIsActive: _gameisactive as! Bool, turnUser: _turnuser as! Int, userNumber: _usernum as! Int, user1: user1obj, user2: user2obj, gameState: arrTag)
                    self.arrRoomGB.append(roomobj)
                }
            }
            self.tableView.reloadData()
        })
        
//        databaseHandle = ref?.child("rooms").observe(.childAdded, with: { (snapshot) in
//            if let value = snapshot.value as? NSDictionary {
//                guard let _roomname = value["roomName"] else {
//                    return
//                }
//                let _usernum = value["userNumber"] as! Int
//                let user1 = value["user1"] as! NSDictionary
//                let _username1 = user1["name"] as! String
//                let _userid1 = user1["idUser"] as! Int
//                let user1obj = User(idUser: _userid1, name: _username1)
//                let user2 = value["user2"] as! NSDictionary
//                let _username2 = user2["name"] as! String
//                let _userid2 = user2["idUser"] as! Int
//                let user2obj = User(idUser: _userid2, name: _username2)
//                let gamestate = value["gameState"] as? NSDictionary
//                var arrTag = [Tag]()
//                for item in gamestate! {
//                    let state = item.value as? NSDictionary
//                    let iduser = state?["idUser"] as! Int
//                    let value = state?["value"] as! Int
//                    let tagobj = Tag(idUser: iduser, value: value)
//                    arrTag.append(tagobj)
//                }
//                let roomobj = Room(roomName: _roomname as! String, userNumber: _usernum, user1: user1obj, user2: user2obj, gameState: arrTag)
//
//                self.arrRoomGB.append(roomobj)
//
//                self.tableView.reloadData()
//            }
//
//
//
//        })
//
//        ref?.removeObserver(withHandle: databaseHandle!)
        
    }
    
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRoomGB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "roomcell", for: indexPath) as! RoomTableViewCell
        cell.lblRoomName?.text = arrRoomGB[indexPath.row].roomName
        
        if arrRoomGB[indexPath.row].userNumber == 1 {
            cell.lblRoomStatus?.text = "Empty"
            cell.lblRoomStatus.textColor = UIColor.blue
            cell.lblUserWaiting.text = arrRoomGB[indexPath.row].user1.name + "'s waiting for you ..."
        } else {
            cell.lblRoomStatus?.text = "Full"
            cell.lblRoomStatus.textColor = UIColor.red
            cell.lblUserWaiting.text = ""
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inroom" {
            let indexPath = tableView.indexPathForSelectedRow!
            objRoomGB = arrRoomGB[indexPath.row]
            arrRoomGB[indexPath.row].user2.name = usernameGB
            role = "guess"
        }
    }
    
    @IBAction func unwindToListRoomTableViewController (for unwindSegue: UIStoryboardSegue) {
        
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
