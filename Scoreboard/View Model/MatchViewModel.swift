//
//  ViewModel.swift
//  Scoreboard
//
//  Created by Hemant Gore on 26/02/20.
//  Copyright © 2020 Dream Big. All rights reserved.
//

import Foundation

class MatchViewModel {
    
    static let endpoint = "https://cricket.yahoo.net/sifeeds/cricket/live/json/sapk01222019186652.json"
    //"https://cricket.yahoo.net/sifeeds/cricket/live/json/nzin01312019187360.json"
    
    static var isOffline = false
    
    var match: Match?
    var teams: [Team] = []
    var firstTeamViewModel: TeamViewModel?
    var secondTeamViewModel: TeamViewModel?
    var selectedTeam: TeamState = .first
    var updateHandler: () -> Void = {}
    var firstInning: Inning?
    var secondInning: Inning?


}

extension MatchViewModel {
    
    func callMatchAPI(completionHandler: @escaping ((Bool) -> Void)) {
        let service = ServiceHandler.sharedInstance
        service.getAPIData(URLString: MatchViewModel.endpoint, objectType: Match.self) { [weak self] (Respose) in
            switch Respose {
            case .success(let match):
                debugPrint(match)
                self?.match = match
                DispatchQueue.main.async {
                    self?.createTeams()
                    if (self?.teams.count ?? 0 ) == 2 {
                        self?.initializeTeams()
                        self?.initializeInnings()
                        completionHandler(true)
                        return
                    }
                }
                completionHandler(false)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completionHandler(false)
            }
        }
    }

}

extension MatchViewModel {
    private func getFirstTeam() -> Team {
        return teams[0]
    }
    
    private func getSecondTeam() -> Team {
        return teams[1]
    }
    
    private func initializeTeams() {
        self.firstTeamViewModel = TeamViewModel(team: getFirstTeam())
        self.secondTeamViewModel = TeamViewModel(team: getSecondTeam())
        guard let firstTeamViewModel = self.firstTeamViewModel, let secondTeamViewModel = self.secondTeamViewModel else { return }
        CoreDataManager.shared.create(teamViewModel: firstTeamViewModel)
        CoreDataManager.shared.create(teamViewModel: secondTeamViewModel)
    }
    
    private func createTeams() {
        if MatchViewModel.isOffline {
            DispatchQueue.main.async {
                self.teams = CoreDataManager.shared.fetchData()
                return
            }
            
        }
        guard let match = self.match else { return }
        for (_, value) in match.teams {
            teams.append(value)
        }
    }
}

extension MatchViewModel {
    private func getSelectedViewModel(of team: TeamState) -> TeamViewModel? {
        switch team {
        case .first:
            return firstTeamViewModel
        case .second:
            return secondTeamViewModel
        }
    }
    
    func getFullName(of team: TeamState) -> String {
        guard let teamViewModel = getSelectedViewModel(of: team) else { return "" }
        return teamViewModel.getFullName()
    }
    
    func getShortName(of team: TeamState) -> String {
        guard let teamViewModel = getSelectedViewModel(of: team) else { return "" }
        return teamViewModel.getShortName()
    }
}

extension MatchViewModel {
    func switchSelectedTeam() {
        selectedTeam = selectedTeam == TeamState.first ? TeamState.second: TeamState.first
        updateHandler()
    }
    func numberOfPlayers() -> Int {
        guard let teamViewModel = getSelectedViewModel(of: selectedTeam) else { return 0 }
        return teamViewModel.getplayerCount()
    }
    
    func getPlayer(for index: Int) -> Player? {
        guard let teamViewModel = getSelectedViewModel(of: selectedTeam) else { return nil }
        return teamViewModel.getPlayer(for: index)
        
    }
}

extension MatchViewModel {
    func initializeInnings() {
        self.firstInning = self.match?.innings.first(where: { (inning) -> Bool in
            inning.number == "First"
        })
        self.secondInning = self.match?.innings.first(where: { (inning) -> Bool in
            inning.number == "Second"
        })
    }
}
