//
//  File.swift
//  TicTacToe
//
//  Created by admin on 8/4/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
     var audioPlayer:AVAudioPlayer?
    enum SoundEffect {
        case flip
        case shuffle
        case match
        case nomatch
        case click
        case winning
    }
     func playSound(_ effect:SoundEffect){
        var soundFilename = ""
        //xac dinh am thanh muon mo va gan vao soundFilename
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .click:
            soundFilename = "click"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"
        case .winning:
            soundFilename = "winning"
        }
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else{
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
        }
        let soundURL = URL(fileURLWithPath: bundlePath!)
        do{
            //tao 1 doi duong auido player
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            //Play the sound
            audioPlayer?.play()
        }catch{
            print("Couldn't create the audio player object for sound file\(soundFilename)")
        }
    }
}
