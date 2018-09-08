//
//  ContinueTableViewCell.swift
//  RummyScoreCount
//
//  Created by Ganesh on 20/08/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

class ContinueTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collnView: UICollectionView!
    @IBOutlet weak var btnContinue: UIButton!
    
    var images = Array<Data>()
    var names = Array<String>()
    let numberOfCellsInRow: CGFloat = 3
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        self.collnView.dataSource = self
        self.collnView.delegate = self
        
    }

    
    //MARK: - UICollectionView Dalegate and DataSource methods..
    //MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContinueCollectionViewCell", for: indexPath) as! ContinueCollectionViewCell
        
        
        Cell.imgPlayer.image = UIImage(data: images[indexPath.row])
        Cell.lblPlayerName.text = names[indexPath.row].uppercased()
        
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let cellWidth : CGFloat = collnView.frame.size.width / numberOfCellsInRow
        let cellheight : CGFloat = collnView.frame.size.width / numberOfCellsInRow
        let cellSize = CGSize(width: cellWidth-10 , height:cellheight-10)
        
        return cellSize
    }
    
}
