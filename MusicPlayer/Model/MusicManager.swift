//
//  MusicManager.swift
//  MusicPlayer
//
//  Created by Denny Lim on 08/10/21.
//

import Foundation

struct MusicManager {
    let musicURL = "https://itunes.apple.com/search?"
    
    func fetchMusic(search searchKeyword: String, completionHandler: @escaping ([MusicModel]) -> Void) {
        let url = URL(string: musicURL + "term=\(searchKeyword)")!
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("Error fetching music data: \(String(describing: error))")
                return
            }
            
            if let safeData = data {
                let music = self.parseJSON(safeData)
                completionHandler(music)
            }
        }).resume()
    }
    
    func parseJSON(_ musicData: Data) -> [MusicModel] {
        let decoder = JSONDecoder()
        var music: [MusicModel] = []
        
        do {
            let decodedData = try decoder.decode(MusicData.self, from: musicData)
            
            for item in decodedData.results {
                music.append(MusicModel(artistName: item.artistName ?? "-", collectionName: item.collectionName ?? "-", trackName: item.trackName ?? "-", artworkUrl: item.artworkUrl60 ?? "-" ,previewUrl: item.previewUrl ?? "-"))
            }
            return music
            
        } catch {
            print("Error fetching music data: \(error)")
            return []
        }
    }
}
