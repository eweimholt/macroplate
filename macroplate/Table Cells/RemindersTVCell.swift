//
//  RemindersTVCell.swift
//  
//
//  Created by Elise Weimholt on 10/9/20.
//

import UIKit
import Foundation

class RemindersTVCell: UITableViewCell {
    
    //var videoImageView = UIImageView()
    var videoTitleLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(videoImageView)
        addSubview(videoTitleLabel)
        //configureImageView()
        configureTitleLabel()
        setConstraints()


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*func configureImageView() {
        videoImageView.layer.cornerRadius = 15
        videoImageView.clipToBounds = true
        
    }*/
    
    func configureTitleLabel() {
        videoTitleLabel.numberOfLines = 0
        videoTitleLabel.adjustFontSizeToFitWidth = true
        
    }
    
    func setConstraints() {
        
        
    }
}
