//
//  ViewController.swift
//  Coding Challenge
//
//  Created by Carlos Mendoza on 8/23/19.
//  Copyright © 2019 Carlos Mendoza. All rights reserved.
//

import UIKit

class ChallengeViewController: UITableViewController {
    
    var mediaData : [Result?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "MediaCell")
        
        downloadData()
    }

    func setupUI() {
        
        //TableView Syle
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        
        //Navigationbar Style
        navigationItem.title = "Coding Challenge"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        
        //ToolBar Setup
        navigationController?.isToolbarHidden = false
        
        //Loading Indicator Setup
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(loadIndicator)
        window.bringSubviewToFront(loadIndicator)
        
        loadIndicator.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        loadIndicator.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        loadIndicator.heightAnchor.constraint(equalToConstant: 75).isActive = true
        loadIndicator.widthAnchor.constraint(equalTo: loadIndicator.heightAnchor).isActive = true
    }
    
    let loadIndicator :UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        indicator.style = .whiteLarge
        indicator.layer.cornerRadius = 8
        indicator.layer.backgroundColor = UIColor.lightGray.cgColor
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MyCell
        
        cell.nameLabel.text = mediaData[indexPath.row]?.name ?? "Error"
        cell.authorLabel.text = mediaData[indexPath.row]?.artistName ?? "Error"
        cell.mediaTypeLabel.text = mediaData[indexPath.row]?.kind ?? "Error" //TODO: Improve
        
        cell.mediaImage.loadImage(from: mediaData[indexPath.row]?.artworkUrl100 ?? "")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func downloadData() {
        if let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-paid/all/50/explicit.json"){ //TODO: Make Variable
            
            loadIndicator.startAnimating()
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode([String:Feed].self, from: data)
                        
                        if let temp = res["feed"]?.results {
                            self.mediaData = temp
                        }
                    } catch let error {
                        print(error)
                    }
                }
                
                DispatchQueue.main.async {
                    self.loadIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                
                }.resume()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        iconCache.removeAllObjects()
        
    }

}

class MyCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Rounded corner of cells
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Moves cell in from edges if landscape
        if UIApplication.shared.statusBarOrientation.isLandscape {
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 120, bottom: 8, right: 120))
        } else {
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        }
    }
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let mediaImage : UIImageView = {
        let image = UIImageView(image: UIImage())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    let authorLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = UIColor.gray
        return label
    }()
    
    let mediaTypeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func setupUI() {
        contentView.addSubview(mediaImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(mediaTypeLabel)
        
        //All constraints
        mediaImage.widthAnchor.constraint(equalTo: mediaImage.heightAnchor, multiplier: 1).isActive = true
        mediaImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        mediaImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        mediaImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: mediaImage.rightAnchor, constant: 32).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        authorLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0).isActive = true
        authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        mediaTypeLabel.leftAnchor.constraint(equalTo: authorLabel.leftAnchor, constant: 0).isActive = true
        mediaTypeLabel.rightAnchor.constraint(equalTo: authorLabel.rightAnchor, constant: 0).isActive = true
        mediaTypeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        
    }
    
    
}

