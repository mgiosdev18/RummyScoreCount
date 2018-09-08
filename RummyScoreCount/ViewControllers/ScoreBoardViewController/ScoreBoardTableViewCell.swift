//
//  ScoreBoardTableViewCell.swift
//  RummyScoreCount
//
//  Created by Ganesh on 23/08/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

class ScoreBoardTableViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var scoreCollectionView: UICollectionView!
    @IBOutlet weak var lblSystemCount: UILabel!
    @IBOutlet weak var btnHalfCountCheckBox: UIButton!
    @IBOutlet weak var lblRoundTotal: UILabel!
    
    var cards = Array<UIImage>()
    var names = Array<String>()
    let numberOfCellsInRow: CGFloat = 6
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.scoreCollectionView.dataSource = self
        self.scoreCollectionView.delegate = self
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - UICollectionView Dalegate and DataSource methods..
    //MARK: -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScoreBoardCollectionViewCell", for: indexPath) as! ScoreBoardCollectionViewCell
        
        
        Cell.imgCard.image = cards[indexPath.row]
       // Cell.lblPlayerName.text = names[indexPath.row].uppercased()
        
        return Cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let cellWidth : CGFloat = scoreCollectionView.frame.size.width / numberOfCellsInRow
        let cellheight : CGFloat = scoreCollectionView.frame.size.width / numberOfCellsInRow
        let cellSize = CGSize(width: cellWidth-10 , height:cellheight-10)
        
        return cellSize
    }
}
