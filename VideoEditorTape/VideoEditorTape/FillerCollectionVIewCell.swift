//
//  FillerCollectionVIewCell.swift
//  VideoEditorTape
//
//  Created by Andrew on 21/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit

class FillerCollectionViewCell: UICollectionViewCell {
    
    static let reuseId: String = "fillerCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.backgroundColor = .clear
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
