//
//  WellcomeViewController.swift
//  TicTacToe
//
//  Created by admin on 8/6/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

var usernameGB = ""
var arrRoomNameGB = [String]()

class WellcomeViewController: UIViewController {

    @IBOutlet weak var txtPlayerName: UITextField!
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        getArrayRoomName()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArrayRoomName(){
        var arrayRoomName = [String]()
        ref?.child("rooms").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let roomname = value?["roomName"] as! String
                arrayRoomName.append(roomname)
            }
            
            arrRoomNameGB = arrayRoomName
            
        })
        
    }
    
    
    @IBAction func onPlayButtonTapped(_ sender: Any) {
        let name = txtPlayerName.text
        if name == "" || name == nil {
            showAlertDialog(titleAL: "Player name is empty !!", messageAL: "Fill out your name, please !!", btnLeft: "Agree")
        } else {
            performSegue(withIdentifier: "wellcome", sender: nil)
            usernameGB = txtPlayerName.text!
        }
    }
    
    func showAlertDialog(titleAL: String?, messageAL: String?, btnLeft: String?){
        
        //Dialogs
        let acExit = UIAlertController(title: titleAL, message: messageAL, preferredStyle: UIAlertControllerStyle.alert)
        
        //Xu ly khi chon dong y
        acExit.addAction(UIAlertAction(title: btnLeft, style: .default, handler: { (action: UIAlertAction!) in
            self.txtPlayerName.becomeFirstResponder()
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
