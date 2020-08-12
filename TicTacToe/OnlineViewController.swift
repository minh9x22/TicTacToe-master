//
//  OnlineViewController.swift
//  TicTacToe
//
//  Created by admin on 8/5/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

var objRoomGB: Room?
var role: String?

class OnlineViewController: UIViewController {
    var soundMNG = SoundManager()
    
    //Cac outlet cua button
    @IBOutlet weak var btnTag1: UIButton!
    @IBOutlet weak var btnTag2: UIButton!
    @IBOutlet weak var btnTag3: UIButton!
    @IBOutlet weak var btnTag4: UIButton!
    @IBOutlet weak var btnTag5: UIButton!
    @IBOutlet weak var btnTag6: UIButton!
    @IBOutlet weak var btnTag7: UIButton!
    @IBOutlet weak var btnTag8: UIButton!
    @IBOutlet weak var btnTag9: UIButton!
    
    var arrButtonBox:[UIButton]!
    
    //Cac outlet con lai
    @IBOutlet weak var labelTurnUser: UILabel!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var lblGuessName: UILabel!
    @IBOutlet weak var switchTurnUser: UISwitch!
    
    var objroom: Room?
    
    
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var countroom = 0
    var roomId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func onSwitchTurnUser(_ sender: UISwitch) {
        
        let turnuser = objroom?.turnUser
        
        if turnuser == 1 {
            ref?.child("rooms").child(roomId!).child("turnUser").setValue(2)
        } else {
            ref?.child("rooms").child(roomId!).child("turnUser").setValue(1)
        }
    }
    
    @IBAction func unwindToOnlineViewController(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        
        //Tim key cua room hien tai va xu ly cho user guess va host
        ref?.child("rooms").queryOrdered(byChild: "roomName").queryEqual(toValue: objRoomGB?.roomName).observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                self.roomId = item.key
            }
            if role == "guess"{
                //Navigate from listroom screen -- role = "guess"
                let ref = self.ref?.child("rooms").child(self.roomId!)
                ref?.child("user2").child("name").setValue(usernameGB)
                ref?.child("userNumber").setValue(2)
            } else {
                //Navigate from createroom screen -- role = "host"
                
            }
            print("Vao check lable")

            //bat su kien realtime khi thay doi cho cac view
            self.ref?.child("rooms").observe( .value, with: { (snapshot) in
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
                        self.objroom = Room(roomName: _roomname as! String, gameIsActive: _gameisactive as! Bool, turnUser: _turnuser as! Int, userNumber: _usernum as! Int, user1: user1obj, user2: user2obj, gameState: arrTag)
                    }
                }
                
                
                self.lblHostName.text = self.objroom?.user1.name
                if self.objroom?.user2.name == "" {
                    self.lblGuessName.text = ". . ."
                } else {
                    self.lblGuessName.text = self.objroom?.user2.name
                }
                
                if self.objroom?.turnUser == 1 {
                    self.labelTurnUser.text = "Player turning: "+(self.objroom?.user1.name)!
                } else {
                    self.labelTurnUser.text = "Player turning: "+(self.objroom?.user2.name)!
                }
                
                //Tach mang game state ra de xuly
                var gameState = [0,0,0,0,0,0,0,0,0]
                for item in (self.objroom?.gameState)!  {
                    gameState[item.seq] = item.value
                }
                
                self.arrButtonBox = [self.btnTag1,self.btnTag2,self.btnTag3, self.btnTag4, self.btnTag5, self.btnTag6, self.btnTag7, self.btnTag8, self.btnTag9]
                //Gan giao dien cho cac box
                for (i,item) in gameState.enumerated() {
                    if item == 1 {
                        self.arrButtonBox[i].setImage(UIImage(named: "x"), for: UIControlState())
                    }
                    if item == 2 {
                        self.arrButtonBox[i].setImage(UIImage(named: "o"), for: UIControlState())
                    }
                }
                
            })
        })
        
       
        
    }
    
    @IBAction func onPlayAgainTapped(_ sender: Any) {
       resetForPlayAgain()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //get list initial room
        ref?.child("rooms").observe( .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let key = child.key as String
                if key == self.roomId {
                    self.countroom += 1
                }
                
            }
            
            if role == "guess" && self.countroom == 0{
                self.showAlertDialog(titleAL: "Room Event", messageAL: "The room host has left this room !!", btnLeft: "Back to List")
            } else {
                self.countroom = 0
            }
        })
        
        

        
    }
    
    @IBAction func onQuitTapped(_ sender: Any) {
        if role == "guess"{
            // role = "guess" -- leave room
            let ref = self.ref?.child("rooms").child(roomId!)
            ref?.child("user2").child("name").setValue("")
            ref?.child("userNumber").setValue(1)
            //Ha man hinh cho segue present modally
            presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            // role = "host" -- leave room
            FirebaseDatabase.Database.database().reference(withPath: "rooms").child(roomId!).removeValue()
            
            //Cat room name hien tai ra khoi mang arrRoomNameGB
            for (index,item) in arrRoomNameGB.enumerated() {
                if item == objRoomGB?.roomName {
                    arrRoomNameGB.remove(at: index)
                }
            }
            
            
            
            //Ha man hinh cho segue present modally
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //Thiet lap mot cai room status
    

    @IBAction func onChatTapped(_ sender: Any) {
     
       
    }
    
    @IBAction func onTicTacTeo(_ sender: UIButton) {
        let ref = self.ref?.child("rooms").child(self.roomId!)
        let tag = sender.tag - 1
        let turnuser = objroom?.turnUser
        let gameisactive = objroom?.gameIsActive
        var checkedbox = 0
        var countCheckFullBox = 0
        
        
        //Kiem tra ko cho user khac danh de` len o da danh roi
        for item in (objroom?.gameState)! {
            if item.seq == tag {
                checkedbox = item.value
            }
        }
        
        if role == "host" && turnuser == 1 && gameisactive == true && checkedbox == 0 {
            let iduser1 = objroom?.user1.idUser
            ref?.child("gameState").child("tag" + String(tag)).child("idUser").setValue(iduser1)
            ref?.child("gameState").child("tag" + String(tag)).child("value").setValue(1)
            ref?.child("turnUser").setValue(2)
        } else {
            if role == "guess" && turnuser == 2 && gameisactive == true && checkedbox == 0 {
                let iduser2 = objroom?.user2.idUser
                ref?.child("gameState").child("tag" + String(tag)).child("idUser").setValue(iduser2)
                ref?.child("gameState").child("tag" + String(tag)).child("value").setValue(2)
                ref?.child("turnUser").setValue(1)
            }
        }
        
       
        
        
        //bat su kien realtime khi thay doi cho cac view
        self.ref?.child("rooms").child(self.roomId!).observe( .value, with: { (snapshot) in
        
                if let value = snapshot.value as? NSDictionary {
                    guard let _roomname = value["roomName"],
                        let _usernum = value["userNumber"],
                        let _turnuser = value["turnUser"],
                        let _gameisactive = value["gameIsActive"] else {
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
                    self.objroom = Room(roomName: _roomname as! String, gameIsActive: _gameisactive as! Bool, turnUser: _turnuser as! Int, userNumber: _usernum as! Int, user1: user1obj, user2: user2obj, gameState: arrTag)
                }
            
            //Tach mang game state ra de xuly
            var gameState = [0,0,0,0,0,0,0,0,0]
            for item in (self.objroom?.gameState)!  {
                gameState[item.seq] = item.value
            }
            
            self.arrButtonBox = [self.btnTag1,self.btnTag2,self.btnTag3, self.btnTag4, self.btnTag5, self.btnTag6, self.btnTag7, self.btnTag8, self.btnTag9]
            //Gan giao dien cho cac box
            for (i,item) in gameState.enumerated() {
                if item == 1 {
                    self.arrButtonBox[i].setImage(UIImage(named: "x"), for: UIControlState())
                }
                if item == 2 {
                    self.arrButtonBox[i].setImage(UIImage(named: "o"), for: UIControlState())
                }
            }
            
            for item in gameState {
                if item == 0 {
                    countCheckFullBox += 1
                }
            }
            
                // Tinh toan ket qua sau khi da click full box xong
                for combination in self.winningCombinations {
                    if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] {
                        ref?.child("gameIsActive").setValue(true)
                        if gameState[combination[0]] == 1 {
//                            Host win
                            if role == "host" {
                                self.showAlertDialogGameResult(titleAL: " Congratulation!!", messageAL: "You have won this game!!", btnLeft: "Play again")
                            } else {
                                if role == "guess" {
                                     self.showAlertDialogGameResult(titleAL: " Don't worry!!", messageAL: "You have lost this game!!You can anoth", btnLeft: "Play again")
                                }
                            }
                        } else {
//                            Guess win
                            if role == "guess" {
                                self.showAlertDialogGameResult(titleAL: " Congratulation!! ", messageAL: "You have won this game!! ", btnLeft: "Play again")
                            } else {
                                if role == "host" {
                                    self.showAlertDialogGameResult(titleAL: " Don't worry!! ", messageAL: "You have lost this game!! You can another game ", btnLeft: "Play again")
                                }
                            }
                        }
                       
                    } else {
                        //Draw
                        if countCheckFullBox == 0 {
                            if role == "host"{
                                self.showAlertDialogGameResult(titleAL: " Congratulation!!", messageAL: "You have drawn this game!!", btnLeft: "Play again")
                            } else {
                                if role == "guess" {
                                     self.showAlertDialogGameResult(titleAL: " Congratulation!!", messageAL: "You have drawn this game!!", btnLeft: "Play again")
                                }
                                
                            }
                            
                        }
                    }
                    
                }
            
        })

    }
    
    
    func getRoomId(){
        ref?.child("rooms").queryOrdered(byChild: "roomName").queryEqual(toValue: objRoomGB?.roomName).observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
               self.roomId = item.key
            }
            
        })
    }
    
    func resetForPlayAgain(){
        let ref = self.ref?.child("rooms").child(roomId!)
        ref?.child("gameIsActive").setValue(true)
        if role == "host" {
            ref?.child("turnUser").setValue(1)
        } else {
            ref?.child("turnUser").setValue(2)
        }
        //Khoi tao game state
        for i in 0...8 {
            // -- clear game state trong roomid
            let ref = self.ref?.child("rooms").child(roomId!).child("gameState").child("tag"+String(i))
            ref?.child("seq").setValue(i)
            ref?.child("idUser").setValue(0)
            ref?.child("value").setValue(0)
        }
        
        ref?.observe( .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                guard let _roomname = value["roomName"],
                    let _usernum = value["userNumber"],
                    let _turnuser = value["turnUser"],
                    let _gameisactive = value["gameIsActive"] else {
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
                self.objroom = Room(roomName: _roomname as! String, gameIsActive: _gameisactive as! Bool, turnUser: _turnuser as! Int, userNumber: _usernum as! Int, user1: user1obj, user2: user2obj, gameState: arrTag)
            }
            self.arrButtonBox = [self.btnTag1,self.btnTag2,self.btnTag3, self.btnTag4, self.btnTag5, self.btnTag6, self.btnTag7, self.btnTag8, self.btnTag9]
            
            for item in self.arrButtonBox {
                item.setImage(nil, for: UIControlState())
            }
            
        })
    }
    
    func onChatTapped(){
      
       
    }
    
    func showAlertDialog(titleAL: String?, messageAL: String?, btnLeft: String?){
        
        //Dialogs
        let acExit = UIAlertController(title: titleAL, message: messageAL, preferredStyle: UIAlertControllerStyle.alert)
        
        //Xu ly khi chon dong y
        acExit.addAction(UIAlertAction(title: btnLeft, style: .default, handler: { (action: UIAlertAction!) in
            //Ha man hinh cho segue present modally
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        
        //Xu ly khi chon dismiss
        acExit.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action: UIAlertAction!) in
//            acExit.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }))
        
        present(acExit, animated: true, completion: nil)
        
    }
    
    func showAlertDialogGameResult(titleAL: String?, messageAL: String?, btnLeft: String?){
        
        //Dialogs
        let acExit = UIAlertController(title: titleAL, message: messageAL, preferredStyle: UIAlertControllerStyle.alert)
        
        //Xu ly khi chon dong y
        acExit.addAction(UIAlertAction(title: btnLeft, style: .default, handler: { (action: UIAlertAction!) in
            self.resetForPlayAgain()
        }))
        
        //Xu ly khi chon dismiss
        acExit.addAction(UIAlertAction(title: "Chat Room!", style: .default, handler: { (action: UIAlertAction!) in
            self.onChatTapped()
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
