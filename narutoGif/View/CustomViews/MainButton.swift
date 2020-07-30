//
//  MainButton.swift
//  narutoGif
//
//  Created by TXB4 on 28/07/2020.
//  Copyright © 2020 TobaIbrahim. All rights reserved.
//

import UIKit

class MainButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        // we are telling xcode to override all initial methods that uibutton has (override init) and also let us use the properties of uibutton in our subclass - (super.init)
        
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        // this is a mandotory init method for storyboard, although we are not using storyboard we still have to pass it in
         
    }
    
    // we create an init meaning and initialiser that is called when we create a uibutton,we have passed this init two parameters that return a ui colour and title this enables us to pick these settings without having default values and changing them later.
    
    init(backgroundColor: UIColor, title: String,cornerRadius:CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cornerRadius
        configure()
        
    }
    
    
    private func configure() {
        setTitleColor(Colours.appBackground, for: .normal)
        titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
}
