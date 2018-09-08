//
//  CompletedGamesTableViewCell.swift
//  RummyScoreCount
//
//  Created by Ganesh on 13/08/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

class CompletedGamesTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var btnViewScores: UIButton!
    
    @IBOutlet weak var tblCollectionView: UICollectionView!
    
    var images = Array<Data>()
    var names = Array<String>()
    let numberOfCellsInRow: CGFloat = 3

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tblCollectionView.dataSource = self
        self.tblCollectionView.delegate = self
        
       // self.tblCollectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewID")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - UICollectionView Dalegate and DataSource methods..
    //MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedGamesCollectionViewCell", for: indexPath) as! CompletedGamesCollectionViewCell
        
        
        Cell.playerImg.image = UIImage(data: images[indexPath.row])
        Cell.lblPlayerName.text = names[indexPath.row].uppercased()
        
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let cellWidth : CGFloat = tblCollectionView.frame.size.width / numberOfCellsInRow
        let cellheight : CGFloat = tblCollectionView.frame.size.width / numberOfCellsInRow
        let cellSize = CGSize(width: cellWidth-10 , height:cellheight-10)
        
        return cellSize
    }
    
}

