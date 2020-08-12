//
//  DataStructure.swift
//  TicTacToe
//
//  Created by admin on 8/6/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation


struct Room {
    var roomName: String
    var gameIsActive: Bool
    var turnUser: Int
    var userNumber: Int
    var user1: User
    var user2: User
    var gameState: [Tag]
}

struct Tag {
    var seq: Int
    var idUser: Int
    var value: Int
}

struct User {
    var idUser: Int
    var name: String
}

struct Chat {
    var message: String
    var idUser: Int
    var time: String
}

