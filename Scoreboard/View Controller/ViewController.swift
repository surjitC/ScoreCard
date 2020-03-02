//
//  ViewController.swift
//  Scoreboard
//
//  Created by Hemant Gore on 26/02/20.
//  Copyright © 2020 Dream Big. All rights reserved.
//

import UIKit
enum TeamState: Int {
    case first
    case second
}

class ViewController: UIViewController {

    @IBOutlet var teamsSegmentControl: UISegmentedControl!
    
    @IBOutlet var tableView: UITableView!
    let matchViewModel = MatchViewModel()
    
    @IBOutlet var teamName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        matchViewModel.updateHandler = tableView.reloadData
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let blurEffect = UIBlurEffect(style: .regular)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = view.frame
//        self.view.addSubview(blurView)
        view.bringSubviewToFront(tableView)
        view.bringSubviewToFront(teamsSegmentControl)
        view.bringSubviewToFront(teamName)
        matchViewModel.callMatchAPI { [weak self] (success) in
            debugPrint(success)
            if success {
                MatchViewModel.isOffline = false
            } else {
                MatchViewModel.isOffline = true
            }
            DispatchQueue.main.async {
                self?.setSegmentTitle()
            }
            
        }
    }
    
    func setSegmentTitle() {
        teamName.text = self.matchViewModel.getFullName(of: .first)
        self.teamsSegmentControl.setTitle(self.matchViewModel.getShortName(of: .first), forSegmentAt: TeamState.first.rawValue)
        self.teamsSegmentControl.setTitle(self.matchViewModel.getShortName(of: .second), forSegmentAt: TeamState.second.rawValue)
        self.tableView.reloadData()
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        debugPrint(sender.selectedSegmentIndex)
        if let selectedTeam = TeamState(rawValue: sender.selectedSegmentIndex) {
            teamName.text = self.matchViewModel.getFullName(of: selectedTeam)
        }
        matchViewModel.switchSelectedTeam()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchViewModel.numberOfPlayers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.cellID, for: indexPath) as? PlayerTableViewCell,
            let player = matchViewModel.getPlayer(for: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configureCell(player: player)
        return cell
    }
    
    
}
