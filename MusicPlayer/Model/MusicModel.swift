//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by Denny Lim on 08/10/21.
//

import Foundation

struct MusicData: Codable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Codable {
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let artworkUrl60: String?
    let previewUrl: String?
}

struct MusicModel {
    let artistName: String
    let collectionName: String
    let trackName: String
    let artworkUrl: String
    let previewUrl: String
}
