//
//  TapeCollectionView.swift
//  VideoEditorTape
//
//  Created by Andrew on 20/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
import AVFoundation


class TapeCollectionView: UICollectionView {
    
    private var itemsToDisplay = [UIImage]()
    private var currentTimeValue = CMTime.zero.value
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .black
        self.delegate = self
        self.dataSource = self
        self.prefetchDataSource = self
        self.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionViewLayout = layout
        self.register(TapeCollectionViewCell.self, forCellWithReuseIdentifier: TapeCollectionViewCell.reuseId)
        
        self.setupCollectionViewData(cellsAmount: Int(Constants.imagesAndScreens.0 + 5)) { [weak self] (images) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.itemsToDisplay = images
                self.reloadData()
            }
        }
    }
    
    private func setupCollectionViewData(cellsAmount: Int, completion: @escaping ([UIImage]) -> ()) {
           let url = URL(fileURLWithPath: Constants.videoPath)
           let asset = AVAsset(url: url)
           var images = [UIImage]()
           let times = self.makeCMTimeArray(from: asset, withSize: cellsAmount)
           let imageGenerator = self.getCustomImageGenerator(from: asset)
           
           imageGenerator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, imageRef, actualTime, result, error) in
               switch result {
               case .succeeded:
                   guard let cgImage = imageRef else { break }
                   let image = UIImage(cgImage: cgImage)
                   images.append(image)
               case .failed:
                   guard let error = error else { break }
                   print(error.localizedDescription)
               default:
                   break
               }
            if images.count == cellsAmount {
                   completion(images)
               }
           }
       }
    
    private func makeCMTimeArray(from asset: AVAsset, withSize: Int) -> [NSValue] {
        let duration = asset.duration
        var timestampsArray = [CMTime]()
        let increment = duration.value / (Constants.imagesAndScreens.0 * Constants.imagesAndScreens.1)
        guard self.currentTimeValue < (asset.duration.value - 5 * increment) else { return [] }
        
        for _ in 1...withSize {
            let time = CMTimeMake(value: self.currentTimeValue, timescale: duration.timescale)
            timestampsArray.append(time)
            self.currentTimeValue += increment
        }
        let times = timestampsArray.map { NSValue(time: $0) }
        return times
    }
    
    private func getCustomImageGenerator(from asset: AVAsset) -> AVAssetImageGenerator {
        let imageGererator = AVAssetImageGenerator(asset: asset)
        imageGererator.requestedTimeToleranceAfter = CMTime.zero
        imageGererator.requestedTimeToleranceBefore = CMTime.zero
        imageGererator.appliesPreferredTrackTransform = true
        
        return imageGererator
    }
}

extension TapeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.itemsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: TapeCollectionViewCell.reuseId, for: indexPath) as? TapeCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = self.itemsToDisplay[indexPath.row]
        return cell
    }
}

extension TapeCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.imageSize
    }
}

extension TapeCollectionView: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxRow =  indexPaths.map({ $0.row }).max()
        , maxRow > self.itemsToDisplay.count-4 else { return }

        self.setupCollectionViewData(cellsAmount: 1) { [weak self] (images) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.itemsToDisplay.append(contentsOf: images)
                self.reloadData()
            }
        }
    }
}
