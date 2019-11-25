//
//  ReactionChallengeMenu.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/22.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class ReactionChallengeMenu: UIViewController {
    
    private var menuTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reaction Challenges"
        view.backgroundColor = AppColors.canvas
        
        navigationItem.backBarButtonItem = .init(title: "Challenges", style: .plain, target: nil, action: nil)

        menuTable = {
            let tv = UITableView()
            tv.tableFooterView = UIView()
            tv.separatorStyle = .none
            tv.backgroundColor = .clear
            tv.contentInset.top = 5
            tv.contentInset.bottom = 5
            tv.register(ChallengeTypeCell.classForCoder(), forCellReuseIdentifier: "cell")
            tv.delegate = self
            tv.dataSource = self
            tv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tv)
            
            tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            return tv
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           
        navigationController?.navigationBar.tintColor = AppColors.reaction
    }
}

extension ReactionChallengeMenu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChallengeTypeCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Classic"
            cell.icon.image = #imageLiteral(resourceName: "single-tap")
        case 1:
            cell.titleLabel.text = "Grid Space"
            cell.icon.image = #imageLiteral(resourceName: "grid")
        case 2:
            cell.titleLabel.text = "Color Dodge"
            cell.icon.image = #imageLiteral(resourceName: "dodge")
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ReactionTimeChallenge()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = GridChallenge()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = ColorDodgeChallenge()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
