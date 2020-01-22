//
//  VideoTapeViewController.swift
//  VideoEditorTape
//
//  Created by Andrew on 19/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
import AVFoundation

class VideoTapeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .darkGray
        let collectionView = TapeCollectionView()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -250).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: Constants.imageSize.height).isActive = true
    }
}
