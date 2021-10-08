//
//  MusicCell.swift
//  MusicPlayer
//
//  Created by Denny Lim on 08/10/21.
//

import UIKit

class MusicCell: UITableViewCell {
    
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivCover.layer.cornerRadius = ivCover.frame.size.height / 2
        ivCover.image = UIImage(named: "DefaultCover")
    }
}
