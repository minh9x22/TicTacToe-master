//
//  ViewController.swift
//  TicTacToe
//
//  Created by admin on 8/4/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activatePlayer = 1 //Cross
    var gameState = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
    var gameIsActive = true
    let winningCombinations = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    var soundMNG = SoundManager()
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action(_ sender: UIButton) {
        
        if gameState[sender.tag-1] == 0 && gameIsActive == true{
            gameState[sender.tag-1] = activatePlayer
            if activatePlayer == 1 {
                sender.setImage(UIImage(named: "x"), for: UIControlState())
                soundMNG.playSound(.click)
                activatePlayer = 2
            }else{
                sender.setImage(UIImage(named: "o"), for: UIControlState())
                soundMNG.playSound(.click)
                activatePlayer = 1
            }
        }
        
        for combination in winningCombinations {
            if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] {
                gameIsActive = false
                if gameState[combination[0]] == 1 {
                    //Cross has won
                    soundMNG.playSound(.winning)
                    label.text = "Cross has won !!"
                } else {
                    //Nought has won
                    soundMNG.playSound(.winning)
                    label.text = "Nought has won !!"
                }
                
                playAgainButton.isHidden = false
                label.isHidden = false
            }
        }
        
        gameIsActive = false
        
        for i in gameState {
            if i == 0 {
                gameIsActive = true
                break
            }
        }
        
        if gameIsActive == false
        {
            label.text = "IT was a Draw"
            label.isHidden = false
            playAgainButton.isHidden = false
        }
        
        print(gameState)
    }
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBAction func playAgain(_ sender: Any) {
        gameState = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
        gameIsActive = true
        activatePlayer = 1
        
        playAgainButton.isHidden = true
        label.isHidden = true
        
        for i in 1...9 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState())
        }
    }
    
  


}

