//
//  TeamTableViewCell.swift
//  Scoreboard
//
//  Created by Hemant Gore on 26/02/20.
//  Copyright © 2020 Dream Big. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    static let cellID = "PlayerCellID"
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var captain: UILabel!
    @IBOutlet var wicketKeeper: UILabel!
    
    @IBOutlet var style: UILabel!
    @IBOutlet var battingAverage: UILabel!
    @IBOutlet var strikeRate: UILabel!
    @IBOutlet var runs: UILabel!
    
    @IBOutlet var bowlingStyle: UILabel!
    @IBOutlet var bowlingAverage: UILabel!
    @IBOutlet var economyRate: UILabel!
    @IBOutlet var wickets: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(player: Player) {
        self.playerNameLabel?.text = player.nameFull
        self.style.text = player.batting.style
        self.battingAverage.text = player.batting.average
        self.strikeRate.text = player.batting.strikerate
        self.runs.text = player.batting.runs
        
        self.bowlingStyle.text = player.bowling.style
        self.bowlingAverage.text = player.bowling.average
        self.economyRate.text = player.bowling.economyrate
        self.wickets.text = player.bowling.wickets
        
        captain.isHidden = true
        wicketKeeper.isHidden = true
        let iscaptain = player.iscaptain ?? false
        let isWicketKeeper = player.iskeeper ?? false
            if iscaptain, isWicketKeeper {
               captain.isHidden = false
                wicketKeeper.isHidden = false
            } else if iscaptain {
                captain.text = "c"
                captain.isHidden = false
            } else if isWicketKeeper {
                captain.isHidden = false
                captain.text = "wk"
            }
            
        
    }

}
