//
//  Filemanger-DocumentsDirectory.swift
//  BucketList
//
//  Created by Alex on 02/04/2022.
//

import Foundation


extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
