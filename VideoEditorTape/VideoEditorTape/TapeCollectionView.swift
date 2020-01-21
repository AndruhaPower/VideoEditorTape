//
//  TapeCollectionView.swift
//  VideoEditorTape
//
//  Created by Andrew on 20/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit


class TapeCollectionView: UICollectionView {
    
    var itemsToDisplay = [UIImage]()
    let padding: Int = 4
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionViewLayout = layout
        self.register(FillerCollectionViewCell.self, forCellWithReuseIdentifier: FillerCollectionViewCell.reuseId)
        self.register(TapeCollectionViewCell.self, forCellWithReuseIdentifier: TapeCollectionViewCell.reuseId)
    }
}

extension TapeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemsToDisplay.count+2*self.padding
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0..<self.padding:
            guard let cell = self.dequeueReusableCell(withReuseIdentifier: FillerCollectionViewCell.reuseId, for: indexPath) as? FillerCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case self.padding..<self.itemsToDisplay.count+self.padding:
            guard let cell = self.dequeueReusableCell(withReuseIdentifier: TapeCollectionViewCell.reuseId, for: indexPath) as? TapeCollectionViewCell else { return UICollectionViewCell() }
            let index = indexPath.row - self.padding
            cell.imageView.image = self.itemsToDisplay[index]
            return cell
        case self.itemsToDisplay.count+self.padding..<self.itemsToDisplay.count+2*self.padding:
            guard let cell = self.dequeueReusableCell(withReuseIdentifier: FillerCollectionViewCell.reuseId, for: indexPath) as? FillerCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension TapeCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerScreen: CGFloat = 8
        let ratio = UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height
        let itemWidth = (UIScreen.main.bounds.width / itemsPerScreen)
        let itemHeight = itemWidth / ratio
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
