//
//  GraphUserAnswers.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2021/5/18.
//  Copyright © 2021 Calpha Dev. All rights reserved.
//

import UIKit

class GraphUserAnswers: UIViewController {
    
    private var userConnections: Set<Connection>!
    private var trueConnections: Set<Connection>!
    private(set) var directed: Bool!
    private var titleLabel: UILabel!
    private var messageLabel: UILabel!
    private var answerRing: RingView!
    
    private var legends: UIView!
    private var incorrectKey: UIView!
    private var incorrectLabel: UILabel!
    private var correctKey: UIView!
    private var correctLabel: UIView!
    private var missingKey: UIView!
    private var missingLabel: UILabel!
    
    /// The number of correct edges and directions reconstructed by the user.
    private var correctCount: (edges: Int, directions: Int) {
        return (answerRing.connections.count, answerRing.rightDirections.count)
    }
    
    /// The number of incorrect edges.
    private var incorrectCount: (edges: Int, directions: Int) {
        return (answerRing.wrongConnections.count, answerRing.wrongConnections.count + answerRing.wrongDirections.count)
    }
    
    /// The number of absent edges.
    private var absentCount: (edges: Int, directions: Int) {
        return (answerRing.absentConnections.count, answerRing.absentConnections.count + answerRing.wrongDirections.count)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(userCon: Set<Connection>, trueCon: Set<Connection>, directed: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.userConnections = userCon
        self.trueConnections = trueCon
        self.directed = directed
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = AppColors.background
        view.tintColor = AppColors.connection
        title = "Answers"
        
        setupUI()
    }
    
    private func setupUI() {
        
        titleLabel = {
            let label = UILabel()
            label.text = "Answer Comparison"
            label.textColor = AppColors.label
            label.font = .systemFont(ofSize: 22, weight: .semibold)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
            
            return label
        }()
        
        messageLabel = {
            let label = UILabel()
            label.text = "Total edges: \(trueConnections.count)"
            label.font = .systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor = AppColors.label
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            label.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
            
            return label
        }()
        
        answerRing = {
            let ring = RingView()
            ring.directed = directed
            ring.numberOfDots = PlayerRecord.current.nodeCount
            ring.editable = false
            ring.absentConnections = trueConnections.subtracting(userConnections)
            
            // Check if any of the correct edges are wrong in direction
            var sameConnections = trueConnections.intersection(userConnections)
            var wrongDirections = Set<Connection>()
            var wrongConnections = Set<Connection>()
            var rightDirections = Set<Connection>()
            var rightConnections = Set<Connection>()
            for uc in userConnections {
                if let trueCon = sameConnections.remove(uc) {
                    rightConnections.insert(uc)
                    if uc.indexA != trueCon.indexA {
                        wrongDirections.insert(uc)
                    } else {
                        rightDirections.insert(uc)
                    }
                } else {
                    wrongConnections.insert(uc)
                }
            }
            ring.connections = rightConnections
            ring.rightDirections = rightDirections
            ring.wrongConnections = wrongConnections
            ring.wrongDirections = wrongDirections
                        
            ring.connectionColor = AppColors.correct.withAlphaComponent(0.9)
            ring.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(ring)
            
            ring.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            ring.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -10).withPriority(.defaultHigh).isActive = true
            ring.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
            ring.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
            ring.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95, constant: -40).withPriority(.defaultHigh).isActive = true
            
            return ring
        }()
        
        legends = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
            
            v.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35).withPriority(.defaultHigh).isActive = true
            v.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            v.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, constant: -40).isActive = true
            v.topAnchor.constraint(greaterThanOrEqualTo: answerRing.bottomAnchor, constant: 10).isActive = true
            
            return v
        }()
        
        correctKey = {
            let v = UIView()
            v.backgroundColor = AppColors.correct
            v.layer.cornerRadius = 4
            v.translatesAutoresizingMaskIntoConstraints = false
            legends.addSubview(v)
            
            v.widthAnchor.constraint(equalToConstant: 28).isActive = true
            v.heightAnchor.constraint(equalToConstant: 15).isActive = true
            v.leftAnchor.constraint(equalTo: legends.leftAnchor).isActive = true
            v.topAnchor.constraint(equalTo: legends.topAnchor, constant: 5).isActive = true
            
            return v
        }()
        
        correctLabel = {
            let label = UILabel()
            if directed {
                label.text = "Correct (\(correctCount.edges) edges, \(correctCount.directions) directions)"
            } else {
                label.text = "Correct (\(correctCount.edges) edges)"
            }
            label.textColor = AppColors.label
            label.translatesAutoresizingMaskIntoConstraints = false
            legends.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: correctKey.rightAnchor, constant: 15).isActive = true
            label.centerYAnchor.constraint(equalTo: correctKey.centerYAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: legends.rightAnchor).isActive = true
            
            return label
        }()
        
        incorrectKey = {
            let v = UIView()
            v.backgroundColor = AppColors.incorrect
            v.layer.cornerRadius = 4
            v.translatesAutoresizingMaskIntoConstraints = false
            legends.addSubview(v)
            
            v.widthAnchor.constraint(equalTo: correctKey.widthAnchor).isActive = true
            v.heightAnchor.constraint(equalTo: correctKey.heightAnchor).isActive = true
            v.leftAnchor.constraint(equalTo: correctKey.leftAnchor).isActive = true
            v.topAnchor.constraint(equalTo: correctKey.bottomAnchor, constant: 15).isActive = true
            v.bottomAnchor.constraint(lessThanOrEqualTo: legends.bottomAnchor).isActive = true
            
            return v
        }()
        
        incorrectLabel = {
            let label = UILabel()
            if directed {
                label.text = "Extra (\(incorrectCount.edges) edges, \(incorrectCount.directions) directions)"
            } else {
                label.text = "Extra (\(incorrectCount.edges) edges)"
            }
            label.textColor = AppColors.label
            label.translatesAutoresizingMaskIntoConstraints = false
            legends.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: incorrectKey.rightAnchor, constant: 15).isActive = true
            label.centerYAnchor.constraint(equalTo: incorrectKey.centerYAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: correctLabel.rightAnchor).isActive = true
            
            return label
        }()
        
        missingKey = {
            let v = UIView()
            v.backgroundColor = AppColors.lightControl
            v.layer.cornerRadius = 4
            v.translatesAutoresizingMaskIntoConstraints = false
            legends.addSubview(v)
            
            v.widthAnchor.constraint(equalTo: correctKey.widthAnchor).isActive = true
            v.heightAnchor.constraint(equalTo: correctKey.heightAnchor).isActive = true
            v.leftAnchor.constraint(equalTo: correctKey.leftAnchor).isActive = true
            v.topAnchor.constraint(equalTo: incorrectKey.bottomAnchor, constant: 15).isActive = true
            v.bottomAnchor.constraint(lessThanOrEqualTo: legends.bottomAnchor).isActive = true
            
            return v
        }()
        
        missingLabel = {
            let label = UILabel()
            if directed {
                label.text = "Missing (\(absentCount.edges) edges, \(absentCount.directions) directions)"
            } else {
                label.text = "Missing (\(absentCount.edges) edge)"
            }
            label.textColor = AppColors.label
            label.translatesAutoresizingMaskIntoConstraints = false
            legends.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: missingKey.rightAnchor, constant: 15).isActive = true
            label.centerYAnchor.constraint(equalTo: missingKey.centerYAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: correctLabel.rightAnchor).isActive = true
            
            return label
        }()
    }
    

}
