//
//  MainMenu.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    
    private var topBanner: UIVisualEffectView!
    private var titleLabel: UILabel!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.canvas
        
        navigationItem.backBarButtonItem = .init(title: "Back", style: .plain, target: nil, action: nil)
        
        topBanner = {
            let effect: UIVisualEffect
            if #available(iOS 12.0, *), traitCollection.userInterfaceStyle == .dark {
                effect = UIBlurEffect(style: .regular)
            } else {
                effect = UIBlurEffect(style: .light)
            }
            let banner = UIVisualEffectView(effect: effect)
            banner.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(banner)
            
            banner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            banner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            banner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            return banner
        }()
        
        titleLabel = {
            let label = UILabel()
            label.text = "Mind Master"
            label.font = .systemFont(ofSize: 24, weight: .semibold)
            label.textColor = AppColors.label
            label.translatesAutoresizingMaskIntoConstraints = false
            topBanner.contentView.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: topBanner.safeAreaLayoutGuide.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: topBanner.centerYAnchor, constant: 14).isActive = true
            label.bottomAnchor.constraint(equalTo: topBanner.bottomAnchor, constant: -25).isActive = true
            
            return label
        }()
        
        topBanner.layoutIfNeeded()
        
        tableView = {
            let tv = UITableView()
            tv.tableFooterView = UIView()
            tv.separatorStyle = .none
            tv.backgroundColor = .clear
            tv.contentInset.top = topBanner.frame.maxY
            tv.contentInset.bottom = 5
            tv.register(ChallengeTypeCell.classForCoder(), forCellReuseIdentifier: "cell")
            tv.delegate = self
            tv.dataSource = self
            tv.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(tv, belowSubview: topBanner)
            
            tv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tv.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            return tv
        }()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.view.backgroundColor = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let effect: UIVisualEffect
        if #available(iOS 12.0, *), traitCollection.userInterfaceStyle == .dark {
            effect = UIBlurEffect(style: .regular)
        } else {
            effect = UIBlurEffect(style: .light)
        }
        
        topBanner.effect = effect
    }
    
}



extension MainMenu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChallengeTypeCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Reaction Time"
            cell.icon.image = #imageLiteral(resourceName: "timer").withRenderingMode(.alwaysTemplate)
            cell.icon.tintColor = AppColors.reaction
        case 1:
            cell.titleLabel.text = "Short-term Memory"
            cell.icon.image = #imageLiteral(resourceName: "memory").withRenderingMode(.alwaysTemplate)
            cell.icon.tintColor = AppColors.memory
        case 2:
            cell.titleLabel.text = "About"
            cell.icon.image = #imageLiteral(resourceName: "info")
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ReactionChallengeMenu()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = MemoryChallenge()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = AboutPage()
            navigationController?.pushViewController(vc, animated: true)
        default:
            let alert = UIAlertController(title: "Mode Unavailable", message: "The selected mode is still in development.", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            present(alert, animated: true)
            break
        }
    }
    
}
