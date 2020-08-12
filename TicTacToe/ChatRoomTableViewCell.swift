//
//  ChatRoomTableViewCell.swift
//  TicTacToe
//
//  Created by admin on 8/11/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var chatCellSatckview: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
