//
//  GridHighscoreEntry.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2019/11/22.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import UIKit

class GridHighscoreEntry: UITableViewCell {
    
    private var bgView: UIView!
    private(set) var titleLabel: UILabel!
    private(set) var valueLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        let h = heightAnchor.constraint(equalToConstant: 60)
        h.priority = .defaultHigh
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
            view.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            let b = view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            b.priority = .defaultHigh
            b.isActive = true
            
            return view
        }()
        
        titleLabel = {
            let label = UILabel()
            label.textColor = AppColors.label
            label.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(label)
            
            label.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 15).isActive = true
            label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
            
            return label
        }()
        
        valueLabel = {
           let label = UILabel()
            label.textColor = AppColors.prompt
            label.translatesAutoresizingMaskIntoConstraints = false
            bgView.addSubview(label)
            
            label.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: -15).isActive = true
            label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
            
            return label
        }()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
