//
//  Constants.swift
//  VideoEditorTape
//
//  Created by Andrew on 20/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit


class Constants {
    
    static let videoPath: String = {
        guard let path = Bundle.main.path(forResource: "cute_puppies", ofType: "mp4") else { return ""}
        return path
    }()
    
    static let imageSize: CGSize = {
        let imagesPerScreen: CGFloat = 6
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        guard height != 0 else { return CGSize.zero }
        let ratio = width / height
        let imageWidth = width / imagesPerScreen
        guard ratio != 0 else { return CGSize.zero }
        let imageHeight = imageWidth / ratio
        
        let frame = CGSize(width: imageWidth, height: imageHeight)
        return frame
    }()
}
