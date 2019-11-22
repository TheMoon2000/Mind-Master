//
//  ChallengeTypeCell.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class ChallengeTypeCell: UITableViewCell {
    
    private var bgView: UIView!
    private(set) var icon: UIImageView!
    private(set) var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        let h = heightAnchor.constraint(equalToConstant: 90)
        h.priority = .defaultLow
        h.isActive = true
        
        bgView = {
            let view = UIView()
            view.backgroundColor = AppColors.subview
            view.layer.cornerRadius = 8
            view.applyMildShadow()
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            view.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
            let b = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7)
            b.priority = .defaultHigh
            b.isActive = true
            
            return view
        }()
        
        icon = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(iv)
            
            iv.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 18).isActive = true
            iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
            iv.heightAnchor.constraint(equalToConstant: 28).isActive = true
            iv.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
            
            return iv
        }()
        
        titleLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 15).isActive = true
            label.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -16).isActive = true
            label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
            
            return label
        }()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(animated, animated: animated)
        
        bgView.backgroundColor = highlighted ? AppColors.selected : AppColors.subview
    }

}
