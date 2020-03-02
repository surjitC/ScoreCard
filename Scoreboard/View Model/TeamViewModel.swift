//
//  TeanViewModel.swift
//  Scoreboard
//
//  Created by Hemant Gore on 26/02/20.
//  Copyright © 2020 Dream Big. All rights reserved.
//

import Foundation

class TeamViewModel {
    
    var team: Team?
    var players: [Player] = []
    
    init(team: Team) {
        self.team = team
        self.players = self.allPlayer()
    }
    
    func allPlayer() -> [Player] {
        guard let team = self.team else { return [] }
        var players: [Player] = []
        for (id, var player) in team.players {
            player.ID = id
            players.append(player)
        }
        return players
    }
    func getplayerCount() -> Int {
        return self.players.count
    }
    func getPlayer(for index: Int) -> Player {
        return self.players[index]
    }
    
    
    func getFullName() -> String {
        guard let team = self.team else { return "" }
        return team.nameFull
    }
    
    func getShortName() -> String {
        guard let team = self.team else { return "" }
        return team.nameShort
    }
}
