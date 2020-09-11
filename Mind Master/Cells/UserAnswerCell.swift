//
//  UserAnswerCell.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/25.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

/// Used to display the user's answer to a memory recall question.
class UserAnswerCell: UITableViewCell {
    
    private(set) var recallType: RecallType!
    
    private var bgView: UIView!
    
    /// The square indicating the correct answer.
    private var correctSquare: UIButton!
    
    /// The `CircleView` that's directly on top of the correct square.
    private var correctCircle: CircleView!
    
    /// Separates the correct answer from the available answers.
    private var separator: UIView!
    
    /// An array of 4 squares indicating the answers that were available to the user.
    private var optionSquares = [UIButton]()
    
    /// An array of 4 circles on top of each option square, for displaying sizes.
    private var optionCircles = [CircleView]()
    
    /// An array of 4 indicator `UIImageView`s below each of the option squares.s
    private var optionTriangles = [UIImageView]()
    
    var correctAnswer: Any = "" {
        didSet {
            if let char = correctAnswer as? String {
                correctSquare.setTitle(char, for: .normal)
                correctSquare.backgroundColor = nil
            } else if let color = correctAnswer as? UIColor {
                correctSquare.backgroundColor = color
                correctSquare.setTitle(nil, for: .normal)
            } else if let size = correctAnswer as? CGFloat {
                correctCircle.radius = size * correctSquare.frame.width / 2
            }
        }
    }
    
    /// Should be set when initialized.
    var allOptions = [Any]() {
        didSet {
            if allOptions.count < 4 { preconditionFailure() }
            
            for i in 0..<4 {
                if let char = allOptions[i] as? String {
                    optionSquares[i].setTitle(char, for: .normal)
                    optionSquares[i].backgroundColor = nil
                    optionCircles[i].radius = 0
                } else if let color = allOptions[i] as? UIColor {
                    optionSquares[i].backgroundColor = color
                    optionSquares[i].setTitle(nil, for: .normal)
                    optionCircles[i].radius = 0
                } else if let size = allOptions[i] as? CGFloat {
                    optionSquares[i].setTitle(nil, for: .normal)
                    optionCircles[i].radius = size * optionSquares[i].frame.width / 2
                }
            }
        }
    }
    
    var correctIndex: Int = -1 {
        didSet {
            for i in 0..<4 {
                if correctAnswer is String {
                    if i == correctIndex {
                        optionSquares[i].backgroundColor = AppColors.placeholder
                    } else {
                        optionSquares[i].backgroundColor = nil
                    }
                    optionSquares[i].setTitleColor(AppColors.label, for: .normal)
                } else {
                    if i == correctIndex {
                        optionTriangles[i].isHidden = false
                        optionTriangles[i].tintColor = AppColors.lightControl
                    } else {
                        optionTriangles[i].isHidden = true
                    }
                }
            }
        }
    }
    
    var userIndex: Int = -1 {
        didSet {
            if userIndex != correctIndex {
                if correctAnswer is String {
                    optionSquares[userIndex].backgroundColor = AppColors.fatal
                    optionSquares[userIndex].setTitleColor(AppColors.invertedLabel, for: .normal)
                    optionSquares[correctIndex].backgroundColor = nil
                } else {
                    optionTriangles[userIndex].isHidden = false
                    optionTriangles[userIndex].tintColor = AppColors.fatal
                }
            }
        }
    }

    required init(_ type: RecallType) {
        super.init(style: .default, reuseIdentifier: nil)
        
        recallType = type
        selectionStyle = .none
        backgroundColor = .clear
        
        bgView = {
            let view = UIView()
            view.backgroundColor = AppColors.subview
            view.layer.cornerRadius = 8
            view.applyMildShadow()
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            view.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
            let b = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
            b.priority = .defaultHigh
            b.isActive = true
            
            return view
        }()
        
        correctSquare = {
            let button = UIButton()
            formatButton(button)
            
            button.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
            button.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 20).isActive = true
            button.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 20).isActive = true
            
            return button
        }()
        
        correctCircle = {
            let c = CircleView()
            c.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(c)
            c.centerXAnchor.constraint(equalTo: correctSquare.centerXAnchor).isActive = true
            c.centerYAnchor.constraint(equalTo: correctSquare.centerYAnchor).isActive = true
        
            return c
        }()
        
        separator = {
            let line = UIView()
            line.backgroundColor = AppColors.line
            line.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(line)
            
            line.widthAnchor.constraint(equalToConstant: 1).isActive = true
            line.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 10).isActive = true
            line.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -10).isActive = true
            line.centerXAnchor.constraint(equalTo: correctSquare.rightAnchor, constant: 20).isActive = true
            
            return line
        }()
        
        for _ in 0..<4 {
            let button = UIButton()
            formatButton(button)
            button.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
            optionSquares.append(button)
            
            let indicator = UIImageView(image: #imageLiteral(resourceName: "indicator"))
            indicator.isHidden = true
            indicator.contentMode = .scaleAspectFit
            indicator.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(indicator)
            
            indicator.widthAnchor.constraint(equalToConstant: 9).isActive = true
            indicator.heightAnchor.constraint(equalToConstant: 9).isActive = true
            indicator.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            indicator.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
            
            optionTriangles.append(indicator)
            
            // Circle
            let circle = CircleView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(circle)
            
            circle.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            circle.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            optionCircles.append(circle)
        }
        
        optionSquares[0].leftAnchor.constraint(equalTo: separator.centerXAnchor, constant: 20).isActive = true
        optionSquares[1].leftAnchor.constraint(equalTo: optionSquares[0].rightAnchor, constant: 10).isActive = true
        optionSquares[2].leftAnchor.constraint(equalTo: optionSquares[1].rightAnchor, constant: 10).isActive = true
        optionSquares[3].leftAnchor.constraint(equalTo: optionSquares[2].rightAnchor, constant: 10).isActive = true
    }
    
    /// Apply style to the button, as well as calculating its width.
    private func formatButton(_ button: UIButton) {
        button.isUserInteractionEnabled = false
        button.setTitleColor(AppColors.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.borderColor = AppColors.line.cgColor
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        bgView.addSubview(button)
        
        let idealWidth = button.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 1 / 5, constant: -110 / 5)
        idealWidth.priority = .defaultHigh
        idealWidth.isActive = true
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 120).isActive = true
        button.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
