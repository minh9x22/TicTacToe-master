//
//  CreateRoomViewController.swift
//  TicTacToe
//
//  Created by admin on 8/6/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateRoomViewController: UIViewController {
    
    @IBOutlet weak var txtRoomName: UITextField!
    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?
    var roomname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtRoomName.text = ""
        ref = Database.database().reference()
        createNewRoomName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onViewListButtonTapped(_ sender: Any) {
       
    }
    
    @IBAction func onCreateRoom(_ sender: Any) {
        let ref = self.ref?.child("rooms").child(roomname)
        var countcheck = 0
        var arrTag = [Tag]()
        
        
        for item in arrRoomNameGB {
            if item == txtRoomName.text {
                countcheck += 1
            }
        }
        
        if countcheck > 0 || txtRoomName.text == nil || txtRoomName.text == "" {
             showAlertDialog(titleAL: "Room name issue !", messageAL: "Your room name has already existed. Please, chose another name for your room !!", btnLeft: "Ok")
        } else
        {
            //Khoi tao game state
            for i in 0...8 {
                // -- khoi tao tag array tren firebase
                let ref = self.ref?.child("rooms").child(roomname).child("gameState").child("tag"+String(i))
                ref?.child("seq").setValue(i)
                ref?.child("idUser").setValue(0)
                ref?.child("value").setValue(0)
                
                // -- khoi tao tag array truyen vao room screen (OnlineViewController)
                let objTag = Tag(seq: i, idUser: 0, value: 0)
                arrTag.append(objTag)
            }
            
            //Khoi tao room chat
            ref?.child("chat").child("0").child("message").setValue("👋 wave your friend! 👋")
            ref?.child("chat").child("0").child("idUser").setValue(0)
            ref?.child("chat").child("0").child("time").setValue("")
            
            //Khoi tao room name
            ref?.child("roomName").setValue(txtRoomName.text)
            arrRoomNameGB.append(txtRoomName.text!)
            
            //Khoi tao user
            ref?.child("user1").child("idUser").setValue(1)
            ref?.child("user1").child("name").setValue(usernameGB)
            ref?.child("user2").child("idUser").setValue(2)
            ref?.child("user2").child("name").setValue("")
            
            //Khoi tao number of user
            ref?.child("userNumber").setValue(1)
            
            //Khoi tao gameIsActive va turnUser
            ref?.child("gameIsActive").setValue(true)
            ref?.child("turnUser").setValue(1)
            
            //Khoi tao objRoom truyen vao room screen (OnlineViewController)
            let user1 = User(idUser: 1, name: usernameGB)
            let user2 = User(idUser: 2, name: "")
            
            objRoomGB = Room(roomName: txtRoomName.text!, gameIsActive: true, turnUser: 0, userNumber: 1, user1: user1, user2: user2, gameState: arrTag)
            role = "host"
            performSegue(withIdentifier: "hostinroom", sender: (Any).self)
        }
    }
    
    @IBAction func unwindToCreateRoomViewController (for unwindSegue: UIStoryboardSegue) {
        
    }
    
    func createNewRoomName(){
        var countroom = 0
        ref?.child("rooms").observe( .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            countroom = (value!.count)
            self.roomname = "room" + String(countroom + 1)
            
        })
        
    }

//    func getAllListRoom(){
//        var arrRoom = [Room]()
//
//
//        ref?.child("rooms").observe(.value, with: { (snapshot) in
//
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                let value = child.value as? NSDictionary
//                let _roomname = value?["roomName"] as! String
//                let _usernum = value?["userNumber"] as! Int
//                let user1 = value?["user1"] as! NSDictionary
//                let _username1 = user1["name"] as! String
//                let _userid1 = user1["idUser"] as! Int
//                let user1obj = User(idUser: _userid1, name: _username1)
//                let user2 = value?["user2"] as! NSDictionary
//                let _username2 = user2["name"] as! String
//                let _userid2 = user2["idUser"] as! Int
//                let user2obj = User(idUser: _userid2, name: _username2)
//                let gamestate = value?["gameState"] as? NSDictionary
//                var arrTag = [Tag]()
//                for item in gamestate! {
//                    let state = item.value as? NSDictionary
//                    let iduser = state?["idUser"] as! Int
//                    let value = state?["value"] as! Int
//                    let tagobj = Tag(idUser: iduser, value: value)
//                    arrTag.append(tagobj)
//                }
//                let roomobj = Room(roomName: _roomname, userNumber: _usernum, user1: user1obj, user2: user2obj, gameState: arrTag)
//                arrRoom.append(roomobj)
//            }
//
//            arrRoomGB = arrRoom
//
//        })
//    }
    
    func showAlertDialog(titleAL: String?, messageAL: String?, btnLeft: String?){
        
        //Dialogs
        let acExit = UIAlertController(title: titleAL, message: messageAL, preferredStyle: UIAlertControllerStyle.alert)
        
        //Xu ly khi chon dong y
        acExit.addAction(UIAlertAction(title: btnLeft, style: .default, handler: { (action: UIAlertAction!) in
            self.txtRoomName.becomeFirstResponder()
        }))
        
        //Xu ly khi chon dismiss
        acExit.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action: UIAlertAction!) in
            acExit.dismiss(animated: true, completion: nil)
        }))
        
        present(acExit, animated: true, completion: nil)
        
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
