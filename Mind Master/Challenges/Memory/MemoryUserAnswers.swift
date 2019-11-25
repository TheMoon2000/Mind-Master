//
//  MemoryUserAnswers.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/25.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class MemoryUserAnswers: UIViewController {
    
    private var parentVC: MemoryChallenge!
    
    private var resultTable: UITableView!
    
    required init(parent: MemoryChallenge) {
        super.init(nibName: nil, bundle: nil)
        
        self.parentVC = parent
        self.title = "You Answers (\(parent.score.text!) correct)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.canvas
        
        resultTable = {
            let tv = UITableView()
            tv.backgroundColor = .clear
            tv.dataSource = self
            tv.delegate = self
            tv.tableFooterView = UIView()
            tv.separatorStyle = .none
            tv.contentInset.top = 5
            tv.contentInset.bottom = 5
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


extension MemoryUserAnswers: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentVC.userIndices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UserAnswerCell(PlayerRecord.current.memoryTestType)
        
        cell.correctAnswer = parentVC.recallList[indexPath.row]
        cell.allOptions = parentVC.recallOptions[indexPath.row]
        cell.correctIndex = parentVC.correctIndices[indexPath.row]
        cell.userIndex = parentVC.userIndices[indexPath.row]
        
        return cell
    }
    
}
