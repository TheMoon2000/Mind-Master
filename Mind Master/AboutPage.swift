//
//  AboutPage.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2020/9/9.
//  Copyright © 2020 Calpha Dev. All rights reserved.
//

import UIKit

class AboutPage: UIViewController {
    
    private var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "About"

        // Do any additional setup after loading the view.
        view.backgroundColor = AppColors.background
        
        var style = PLAIN_STYLE
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                style = PLAIN_DARK
                
            }
        }
        
        textView = {
            let tv = UITextView()
            tv.contentInset.top = 20
            tv.contentInset.bottom = 20
            tv.isEditable = false
            tv.backgroundColor = .clear
            tv.dataDetectorTypes = .link
            tv.linkTextAttributes[NSAttributedString.Key.foregroundColor] = AppColors.link
            tv.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tv)
            
            tv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
            tv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
            tv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            return tv
        }()
        
        textView.attributedText = """
## Privacy Policy
        
Mind Master is an app that helps you to practice a variety of cognitive abilities, especially memory. It is designed as a fully offline app, and **does not** collect personal information about you.

## Source

This app is open source. You can checkout my code at https://github.com/TheMoon2000/Mind-Master.
""".attributedText(style: style)
        textView.textColor = AppColors.label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = AppColors.link
    }

}
