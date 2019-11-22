//
//  ReactionTimeChallenge.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class ReactionTimeChallenge: UIViewController {
    
    private var tapArea: UIButton!
    private var highScore: UILabel!
    
    private let startTitle = "Tap to Start"
    private let testTitle = "Press when Color Changes..."
    private let pressTitle = "Tap Now!"
    
    private var pressTimer: Timer?
    private var pressTime = Date.timeIntervalSinceReferenceDate

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reaction Time"
        view.backgroundColor = AppColors.background
        
        // Do any additional setup after loading the view.
        
        tapArea = {
            let button = UIButton(type: .custom)
            button.backgroundColor = AppColors.tapOff
            button.tintColor = AppColors.label
            button.layer.cornerRadius = 8
            button.applyMildShadow()
            button.setTitle(startTitle, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
            
            button.setContentHuggingPriority(.defaultLow, for: .vertical)
            
            button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTriggered), for: .touchUpInside)
            
            return button
        }()
        
        
        highScore = {
            let label = UILabel()
            if let record = PlayerRecord.current.reaction {
                label.text = "High score: \(Int(round(record * 1000)))ms"
            } else {
                label.text = "No high score."
            }
            label.textAlignment = .center
            label.numberOfLines = 2
            label.font = .systemFont(ofSize: 16)
            label.textColor = AppColors.value
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            label.topAnchor.constraint(equalTo: tapArea.bottomAnchor, constant: 30).isActive = true
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
            label.setContentHuggingPriority(.required, for: .vertical)
           
            return label
        }()
    }
    
    @objc private func buttonTriggered() {
        if pressTimer == nil && tapArea.title(for: .normal) == startTitle {
            self.tapArea.setTitle(testTitle, for: .normal)
            UISelectionFeedbackGenerator().selectionChanged()
            let randomTime = Double.random(in: 3.0...8.0)
            let timer = Timer.init(fire: Date(timeIntervalSinceNow: randomTime), interval: 0, repeats: false) { timer in
                self.tapArea.backgroundColor = AppColors.reaction
                self.tapArea.setTitle(self.pressTitle, for: .normal)
                self.pressTime = Date.timeIntervalSinceReferenceDate
            }
            pressTimer = timer
            RunLoop.main.add(timer, forMode: .default)
        } else {
            pressTimer = nil
        }
    }
    
    @objc private func buttonPressed() {
        
        if tapArea.title(for: .normal) == startTitle {
            return
        } else if tapArea.title(for: .normal) == pressTitle {
            let duration = Date.timeIntervalSinceReferenceDate - pressTime
            if duration < (PlayerRecord.current.reaction ?? .infinity) {
                PlayerRecord.current.reaction = duration
            }
            
            let highest = Int(round(PlayerRecord.current.reaction! * 1000))
            let current = Int(round(duration * 1000))
            highScore.text = "Current time: \(current)ms | High score: \(highest)ms"
            
        } else if tapArea.title(for: .normal) == testTitle {
            pressTimer?.invalidate()
            let alert = UIAlertController(title: "You pressed too early!", message: "Please wait until the tap area turns green.", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel, handler: { _ in
                self.pressTimer = nil
            }))
            present(alert, animated: true)
        }
        
        tapArea.setTitle(startTitle, for: .normal)
        UIView.animate(withDuration: 0.1) {
            self.tapArea.backgroundColor = AppColors.tapOff
        }
    }

}
