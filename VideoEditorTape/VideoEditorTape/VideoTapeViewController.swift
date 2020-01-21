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
        self.view.backgroundColor = .darkGray
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        let collectionView = TapeCollectionView()
        let cvHeight = UIScreen.main.bounds.size.width / 8 * (UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 500).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: cvHeight).isActive = true
        
        self.setupCollectionViewData { (images) in
            collectionView.itemsToDisplay = images
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionViewData(completion: @escaping ([UIImage]) -> ()) {
        let size: Int64 = 120
        let url = URL(fileURLWithPath: Constants.videoPath)
        let asset = AVAsset(url: url)
        var images = [UIImage]()
        let times = self.makeCMTimeArray(from: asset, ofSize: size)
        let imageSize = self.getImageSize(denominator: 8)
        let imageGenerator = self.getCustomImageGenerator(from: asset, with: imageSize)
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { (requestedTime, imageRef, actualTime, result, error) in
            switch result {
            case .succeeded:
                guard let cgImage = imageRef else { print("unable to transform Image at \(requestedTime)"); break }
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            case .failed:
                guard let error = error else { break }
                print(error.localizedDescription)
            default:
                break
            }
            if images.count == Int(size) {
                completion(images)
                return
            }
        }
        
    }
    
    private func makeCMTimeArray(from asset: AVAsset, ofSize: Int64) -> [NSValue] {
        let duration = asset.duration
        var timestampsArray = [CMTime]()
        let increment = duration.value / ofSize
        var currentValue = CMTime.zero.value
        
        while currentValue < duration.value {
            let time = CMTimeMake(value: currentValue, timescale: duration.timescale)
            timestampsArray.append(time)
            currentValue += increment
        }
        let times = timestampsArray.map { NSValue(time: $0) }
        
        return times
    }
    
    private func getImageSize(denominator: CGFloat) -> CGSize{
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let ratio = width / height
        let imageWidth = width / denominator
        let imageHeight = imageWidth / ratio
        let frame = CGSize(width: imageWidth, height: imageHeight)
        
        return frame
    }
    
    private func getCustomImageGenerator(from asset: AVAsset, with imageSize: CGSize) -> AVAssetImageGenerator {

        let imageGererator = AVAssetImageGenerator(asset: asset)
        imageGererator.requestedTimeToleranceAfter = CMTime.zero
        imageGererator.requestedTimeToleranceBefore = CMTime.zero
        imageGererator.appliesPreferredTrackTransform = true
        
        return imageGererator
    }
}
