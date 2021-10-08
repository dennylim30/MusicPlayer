//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Denny Lim on 08/10/21.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var musicManager = MusicManager()
    var musicList:[MusicModel] = []
    var playedMusic = UIView()
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var cover = UIImageView()
    var songTitle = UILabel()
    var artist = UILabel()
    var playPauseBtn = UIButton()
    var closeBtn = UIButton()
    var sliderTimer = UISlider()
    var audioTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        musicManager.fetchMusic(search: "blackpink") {[weak self] (music) in
            self?.musicList = music
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.renderPlayedMusic()
            }
        }
    }

    @IBAction func searchTextField(_ sender: UITextField) {
        musicManager.fetchMusic(search: sender.text!) {[weak self] (music) in
            self?.musicList = music
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func playMusic(previewUrl: String) {
        let url = URL(string: previewUrl)
        self.player = AVPlayer(url: url!)
        self.player?.play()
        makeTimer()
    }
    
    @objc func playOrPause(sender: UIButton) {
        if sender.titleLabel?.text == "pause" {
            self.player?.pause()
            playPauseBtn.setImage(UIImage(named: "PlayButton"), for: .normal)
            playPauseBtn.setTitle("play", for: .normal)
        } else if sender.titleLabel?.text == "play" {
            self.player?.play()
            playPauseBtn.setImage(UIImage(named: "PauseButton"), for: .normal)
            playPauseBtn.setTitle("pause", for: .normal)
        }
    }
    
    @objc func closeDetail() {
        playedMusic.isHidden = true
        self.player?.pause()
        self.player = nil
    }
    
    func renderPlayedMusic() {
        playedMusic = UIView(frame: CGRect(x: 0, y: view.frame.size.height - (view.frame.size.height / 5), width: view.frame.size.width, height: view.frame.size.height / 5))
        playedMusic.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        view.addSubview(playedMusic)
        
        cover = UIImageView(frame: CGRect(x: 10, y: 10, width: 75, height: 75))
        playedMusic.addSubview(cover)
        
        songTitle = UILabel(frame: CGRect(x: 115, y: 15, width: 150, height: 22))
        songTitle.font = UIFont.boldSystemFont(ofSize: 15.0)
        playedMusic.addSubview(songTitle)
        
        artist = UILabel(frame: CGRect(x: 115, y: 42, width: 100, height: 22))
        artist.font = UIFont.systemFont(ofSize: 13.0)
        playedMusic.addSubview(artist)
        
        playPauseBtn = UIButton(frame: CGRect(x: view.frame.size.width - 80, y: 25, width: 20, height: 20))
        playPauseBtn.imageView?.contentMode = .scaleAspectFit
        playPauseBtn.setImage(UIImage(named: "PauseButton"), for: .normal)
        playPauseBtn.setTitle("pause", for: .normal)
        playPauseBtn.addTarget(self, action: #selector(playOrPause(sender:)), for: .touchUpInside)
        playedMusic.addSubview(playPauseBtn)
        
        closeBtn = UIButton(frame: CGRect(x: view.frame.size.width - 40, y: 28, width: 15, height: 15))
        closeBtn.setImage(UIImage(named: "CloseButton"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeDetail), for: .touchUpInside)
        playedMusic.addSubview(closeBtn)
        
        sliderTimer = UISlider(frame: CGRect(x: 115, y: 80, width: view.frame.size.width - 130, height: 20))
        sliderTimer.isEnabled = false
        playedMusic.addSubview(sliderTimer)
        
        playedMusic.isHidden = true
    }
    
    func makeTimer() {
      if audioTimer != nil {
        audioTimer!.invalidate()
      }
      audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimer(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func onTimer(timer: Timer) {
        let currentTime = player?.currentItem?.currentTime().seconds
        let duration = player?.currentItem?.asset.duration.seconds ?? 0
      
        let percentCompleted = currentTime ?? 0 / duration
      
        sliderTimer.maximumValue = Float(duration)
        sliderTimer.value = Float(percentCompleted)
        
        if sliderTimer.value == sliderTimer.maximumValue {
            audioTimer?.invalidate()
        }
    }
}

//MARK: - TableView
extension MusicPlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if musicList.count-1 > 0 {
            return musicList.count-1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! MusicCell
        let ml = musicList[indexPath.row]
        
        cell.ivCover.load(urlString: ml.artworkUrl)
        cell.songTitle.text = ml.trackName
        cell.artist.text = ml.artistName
        cell.album.text = ml.collectionName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playMusic(previewUrl: musicList[indexPath.row].previewUrl)
        playedMusic.isHidden = false
        playPauseBtn.setImage(UIImage(named: "PauseButton"), for: .normal)
        playPauseBtn.setTitle("pause", for: .normal)
        cover.load(urlString: musicList[indexPath.row].artworkUrl)
        songTitle.text = musicList[indexPath.row].trackName
        artist.text = musicList[indexPath.row].artistName
    }
}

//MARK: - Extension ImageView
extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

