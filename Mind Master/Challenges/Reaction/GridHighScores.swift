//
//  GridHighScores.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/22.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class GridHighScores: UIViewController {
    
    private var challenge: GridChallenge!
    private var scoreTable: UITableView!
    
    required init(parent: GridChallenge) {
        super.init(nibName: nil, bundle: nil)
        
        self.challenge = parent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "High Scores"
        view.backgroundColor = AppColors.canvas
        
        scoreTable = {
            let tv = UITableView(frame: .zero, style: .grouped)
            tv.dataSource = self
            tv.delegate = self
            tv.separatorStyle = .none
            tv.backgroundColor = .clear
            tv.contentInset.top = 5
            tv.contentInset.bottom = 5
            tv.register(GridHighscoreEntry.classForCoder(), forCellReuseIdentifier: "cell")
            tv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tv)
            
            tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            return tv
        }()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}


extension GridHighScores: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PlayerRecord.current.gridRecord.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || tableView.numberOfSections == 1 {
            return challenge.maxIterations - challenge.minIterations + 1
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.numberOfSections == 1 {
            return "All High Scores"
        } else {
            return ["Best score", "All High Scores"][section]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GridHighscoreEntry
        
        if indexPath.section == 1 || tableView.numberOfSections == 1 {
            let index = (challenge.minIterations + indexPath.row) * 5
            cell.titleLabel.text = "\(index) Iterations:"
            if let record = PlayerRecord.current.gridRecord[index] {
                cell.valueLabel.text = String(format: "%.3fs / tap", record / Double(index))
            } else {
                cell.valueLabel.text = "Not Attempted"
            }
        } else {
            var bestIterations = 0
            var currentBest = Double.infinity
            for (key, value) in PlayerRecord.current.gridRecord {
                if value / Double(key) < currentBest {
                    bestIterations = key
                    currentBest = value / Double(key)
                }
            }
            cell.titleLabel.text = "\(bestIterations) Iterations:"
            cell.valueLabel.text = String(format: "%.3f taps / s", 1 / currentBest)
        }
        
        return cell
    }
}
