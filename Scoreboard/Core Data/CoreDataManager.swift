//
//  CoreDataManager.swift
//  Scoreboard
//
//  Created by Hemant Gore on 02/03/20.
//  Copyright © 2020 Dream Big. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    func create(teamViewModel: TeamViewModel) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let teamEntity = TeamEntity(context: managedContext)
        teamEntity.fullName = teamViewModel.team?.nameFull ?? ""
        teamEntity.shortName = teamViewModel.team?.nameShort ?? ""
        teamViewModel.players.forEach { (player) in
            
            let playerEntity = PlayerEntity(context: managedContext)
            
            playerEntity.id = player.ID
            playerEntity.batAvg = player.batting.average
            playerEntity.batStyle = player.batting.style
            playerEntity.strikeRate = player.batting.strikerate
            playerEntity.runs = player.batting.runs
            
            playerEntity.bowlAvg = player.bowling.average
            playerEntity.bowlStyle = player.bowling.style
            playerEntity.ecoRate = player.bowling.economyrate
            playerEntity.wickets = player.bowling.wickets
            playerEntity.isCaptain = player.iscaptain ?? false
            playerEntity.isWicketKeeper = player.iskeeper ?? false
            
            teamEntity.addToPlayers(playerEntity)
        }
        
        do {
            try managedContext.save()
        } catch let error {
            debugPrint(error.localizedDescription)
        }

    }
    
    func fetchData() -> [Team] {
        var teams: [Team] = []
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TeamEntity> = TeamEntity.fetchRequest()
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            result.forEach { (teamEntity) in
                teams.append(teamEntityToModel(entity: teamEntity))
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
        return teams
    }
    
    func teamEntityToModel(entity: TeamEntity) -> Team {
        let fullName = entity.fullName ?? ""
        let shortName = entity.shortName ?? ""
        let players = entity.players?.allObjects as? [PlayerEntity] ?? []
        var playerDict: [String: Player] = [:]
        players.forEach { (playerEntity) in
            if let ID = playerEntity.id {
                playerDict[ID] = playerEntityToModel(entity: playerEntity)
            }
        }
        return Team(nameFull: fullName, nameShort: shortName, players: playerDict)
    }
    
    func playerEntityToModel(entity: PlayerEntity) -> Player {
        let batting = Batting(style: entity.batStyle ?? "", average: entity.batAvg ?? "", strikerate: entity.strikeRate ?? "", runs: entity.runs ?? "")
        let bowling = Bowling(style: entity.bowlStyle ?? "", average: entity.bowlAvg ?? "", economyrate: entity.ecoRate ?? "", wickets: entity.wickets ?? "")
        
        return Player(position: "", nameFull: "", batting: batting, bowling: bowling, iscaptain: entity.isCaptain, iskeeper: entity.isWicketKeeper, ID: entity.id ?? "")
    }
}
