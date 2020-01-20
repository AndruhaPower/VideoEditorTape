//
//  Constants.swift
//  VideoEditorTape
//
//  Created by Andrew on 20/01/2020.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation


class Constants {
    
    static let videoPath: String = {
        guard let path = Bundle.main.path(forResource: "cute_puppies", ofType: "mp4") else { return ""}
        return path
    }()
}
