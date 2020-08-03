//
//  MainViewController.swift
//  narutoGif
//
//  Created by TXB4 on 28/07/2020.
//  Copyright © 2020 TobaIbrahim. All rights reserved.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK
import AVFoundation

class MainViewController: UIViewController {
    
    
    //MARK: Properties
    var networkUrlArray = [String?]()
    var urlArray        = [String]()
    var urlString   = String()
    var gifImage    = GiphyYYImage()
    var copiedGif   = String()
    let pasteBoard  = UIPasteboard.general
    
    
    
    var audioPlayer: AVAudioPlayer = {
        var audioPlayer = AVAudioPlayer()
        var sound       = Bundle.main.path(forResource: "kamui3", ofType: "m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
            
        catch {
            print("DEBUG: Audio player error \(error.localizedDescription)")
        }
        return audioPlayer
    }()
    
    let copyGifLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font  = UIFont.preferredFont(forTextStyle: .headline)
        label.minimumScaleFactor = 0.75
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        label.textAlignment   = .center
        label.font            = UIFont.systemFont(ofSize:24,weight: .bold)
        label.textColor       = Colours.appOrange
        label.text            = "Copy"
        return label
    }()
    
    let homeButton: UIImageView = {
        let homeButton = UIImageView()
        homeButton.image = UIImage(named: "Star")
        homeButton.contentMode = .scaleAspectFit
        homeButton.clipsToBounds = true
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        return homeButton
    }()
    
    
    let mainButton:MainButton = {
        let button = MainButton(backgroundColor: Colours.appOrange, title: "GENERATE", cornerRadius: 12)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    let staticImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tobi2")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let staticImageBorder:UIView = {
        let border = UIView()
        border.backgroundColor = Colours.appOrange
        border.translatesAutoresizingMaskIntoConstraints = false
        border.layer.cornerRadius = 12
        return border
    }()
    
    
    let avatar: GiphyYYAnimatedImageView = {
        let imageView = GiphyYYAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        testNetworkCall()

    }
    
    //MARK: Helpers
    
    func randomName() -> String {
        let md = RandomNames()
        let name = md.names
        let randomNumber = Int.random(in: 0...name.count)
        return name[randomNumber]
    }
    
    
    func testNetworkCall() {
        
        NetworkManager.shared.getGifImage(pagination: "1", name:randomName()) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.failure(let error):
                print("DEBUG: \(error.localizedDescription)")
                
            case.success(let gif):
//                var randomInt           = 1
//                randomInt               += 1
//                    print("DEBUG: URL ARRAY = \(gif.data[0].url)")
//                let mappedUrl = gif.data[0].images.map{$0.value.url}
//                self.networkUrlArray.append(contentsOf: mappedUrl)
//                    print("DEBUG: networkUrlArray ARRAY = \(self.networkUrlArray)")
                for (value) in gif.data[0].images {
                    
                    guard let safeValue = value.value.url else {return}
                    self.urlArray.append(safeValue)
                    let snapshopValue             = safeValue
                    self.copiedGif                = snapshopValue
                    guard let fileUrl             = URL(string: snapshopValue) else {return}
                    self.load(url: fileUrl)
                        
                }
                print("DEBUG: URL ARRAY = \(self.urlArray)")

            }
            
        }
        
    }
    
    func configureUI() {
        view.backgroundColor = Colours.appBackground
        view.addSubview(staticImage)
        view.addSubview(mainButton)
        view.addSubview(homeButton)
        view.addSubview(avatar)
        view.addSubview(copyGifLabel)
        
        
        staticImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: mainButton.topAnchor, trailing: view.trailingAnchor, paddingTop: 150, paddingLeft: 20, paddingBottom: 90, paddingRight: 20, width: 500, height: 510)
        
        avatar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: mainButton.topAnchor, trailing: view.trailingAnchor, paddingTop: 150, paddingLeft: 20, paddingBottom: 90, paddingRight: 20, width: 500, height: 510)
        
        mainButton.anchor(top: staticImage.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 100, paddingLeft: 54, paddingBottom: 74, paddingRight: 54, width: 268, height: 53)
        
        homeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 23, paddingLeft: 23, paddingBottom: 729, paddingRight: 292, width: 50, height: 50)
        
        copyGifLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: homeButton.trailingAnchor, bottom: staticImage.topAnchor, trailing: view.trailingAnchor, paddingTop: 10, paddingLeft: 210, paddingBottom: 10, paddingRight: 5, width: 70, height: 70)
        
        
        let tapAction         = UITapGestureRecognizer(target: self, action: #selector(copyButtonTapped))
        copyGifLabel.isUserInteractionEnabled = true
        copyGifLabel.addGestureRecognizer(tapAction)
        
        
        let tap               = UITapGestureRecognizer(target: self, action: #selector(kunaiButtonTapped))
        homeButton.isUserInteractionEnabled = true
        homeButton.addGestureRecognizer(tap)
        
        
        audioPlayer.setVolume(0.1, fadeDuration: 1)
        
        
    }
    
    
    @objc func kunaiButtonTapped() {
        print("DEBUG: KUNAI TAPPED")
        
        avatar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: mainButton.topAnchor, trailing: view.trailingAnchor, paddingTop: 150, paddingLeft: 20, paddingBottom: 5, paddingRight: 20, width: 700, height: 900)
        
        let path = Bundle(for: MainViewController.self).path(forResource: "sassy", ofType: "gif")
        let image = GiphyYYImage(contentsOfFile: path ?? "")
        avatar.isHidden = false
        self.avatar.image = image
        
    }
    
    @objc func copyButtonTapped() {
        print("DEBUG: Copy Button pressed")
        pasteBoard.string = urlString
        guard let copiedString = pasteBoard.string else {return}
        print("DEBUG: Copy URL = \(copiedString)")
        
        let alert = UIAlertController(title: "Copied", message: "Gif copied to clipboard", preferredStyle: .alert)
        alert.view.tintColor = Colours.appOrange
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
        }))
        
        if copiedString.isEmpty {
            print("DEBUG: Gif not copied")
        }
            
        else {
            print("DEBUG: Gif copied Sucessfully")
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @objc func buttonPressed() {
        
        testNetworkCall()
        audioPlayer.play()
        let path = Bundle(for: MainViewController.self).path(forResource: "ezgif.com-video-to-gif-5", ofType: "gif")
        let image = GiphyYYImage(contentsOfFile: path ?? "")
        self.avatar.image = image
        
        staticImage.isHidden = true
        avatar.isHidden = false
        print("DEBUG: Button pressed")
        
        var randomInt           = 1
        randomInt               += 1
        let randomUrl           = self.urlArray[0]
        guard let fileUrl       = URL(string: randomUrl) else {return}
        self.urlString          = (randomUrl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.load(url: fileUrl)
            print("DEBUG: URL ARRAY = \(self.networkUrlArray)")
            self.avatar.image       = self.gifImage
        }
    }
    
    func load(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                guard let image = GiphyYYImage(data: data) else {return}
                self!.gifImage = image
                
            }
        }
    }
}


