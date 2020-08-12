//
//  RoomTableViewCell.swift
//  TicTacToe
//
//  Created by admin on 8/7/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIcon: UILabel!
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var lblRoomStatus: UILabel!
    @IBOutlet weak var lblUserWaiting: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
