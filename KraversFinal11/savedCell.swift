//
//  savedCell.swift
//  
//
//  Created by Collin Chan on 2018-08-31.
//

import UIKit

class savedCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameTing: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressting: UILabel!
    @IBOutlet weak var categoriesTing: UILabel!
        
    var restaurant: restInfo! {
        didSet{
            nameTing.text = restaurant.name
            addressting.text = restaurant.address
            categoriesTing.text = restaurant.categoies
            let imageData:NSData = NSData(contentsOf: URL(string: restaurant.image)!)!
            let image1 = UIImage(data: imageData as Data)
            thumbImageView.image = image1
            print(restaurant.rating)
            if restaurant.rating == 0.0 {
                ratingImageView.image = UIImage(named: "zeroStars")
            } else if restaurant.rating > 0.0 && restaurant.rating <= 0.5 {
                ratingImageView.image = UIImage(named: "zeroHalfStars")
            } else if restaurant.rating > 0.5 && restaurant.rating <= 1.0 {
                ratingImageView.image = UIImage(named: "oneStars")
            } else if restaurant.rating > 1.0 && restaurant.rating <= 1.5 {
                ratingImageView.image = UIImage(named: "oneHalfStars")
            } else if restaurant.rating > 1.5 && restaurant.rating <= 2.0 {
                ratingImageView.image = UIImage(named: "twoStars")
            } else if restaurant.rating > 2.0 && restaurant.rating <= 2.5 {
                ratingImageView.image = UIImage(named: "twoHalfStars")
            } else if restaurant.rating > 2.5 && restaurant.rating <= 3.0 {
                ratingImageView.image = UIImage(named: "threeStars")
            } else if restaurant.rating > 3.0 && restaurant.rating <= 3.5 {
                ratingImageView.image = UIImage(named: "threeHalfStars")
            } else if restaurant.rating > 3.5 && restaurant.rating <= 4.0 {
                ratingImageView.image = UIImage(named: "fourStars")
            } else if restaurant.rating > 4.0 && restaurant.rating <= 4.5 {
                ratingImageView.image = UIImage(named: "fourHalfStars")
            } else if restaurant.rating > 4.5 && restaurant.rating <= 5.0 {
                ratingImageView.image = UIImage(named: "fiveStars")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
