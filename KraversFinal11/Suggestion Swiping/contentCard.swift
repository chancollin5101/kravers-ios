//
//  contentCard.swift
//  my attempt in CDYelpFusionKit
//
//  Created by Collin Chan on 9/8/2018.
//  Copyright © 2018 Collin Chan. All rights reserved.
//
import UIKit

let THERESOLD_MARGIN = (UIScreen.main.bounds.size.width/2) * 0.75
let SCALE_STRENGTH : CGFloat = 4
let SCALE_RANGE : CGFloat = 0.90


protocol TinderCardDelegate: NSObjectProtocol {
    func cardGoesLeft(card: contentCard)
    func cardGoesRight(card: contentCard)
    func currentCardStatus(card: contentCard, distance: CGFloat)
}

class contentCard: UIView {
    
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    var imageViewStatus = UIImageView()
    var overLayImage = UIImageView()
    var isLiked = false
    
    weak var delegate: TinderCardDelegate?
    
    public init(frame: CGRect, image: URL?, name: String?, address: String?, distance: Double?, price: String?) {
        super.init(frame: frame)
        setupView(image: image, name: name, address: address, distance: distance, price: price)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(image: URL?, name: String?, address: String?, distance: Double?, price: String?) {
        
        layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowColor = UIColor.darkGray.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = false
        
        originalPoint = center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
        
        let background = UIView(frame:bounds)
        background.backgroundColor = UIColor.init(red: 224/255, green: 215/255, blue: 66/255, alpha: 1.0)
        addSubview(background)
        
        let image1: UIImage?
        if image != nil {
            let imageData:NSData = NSData(contentsOf: image!)!
            image1 = UIImage(data: imageData as Data)
        } else {
            image1 = UIImage(named: "imageNot")
        }
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 50))
        imageView.image = image1
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true;
        addSubview(imageView)
        
        var realName = ""
        if name != nil {
            realName = name!
        } else {
            realName = "Name Not Available"
        }
            let nameLabel = UILabel(frame:CGRect(x: 8, y: bounds.height-60, width: 200, height: 50))
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = realName
            nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            nameLabel.textAlignment = .left
            nameLabel.textColor = .gray
            addSubview(nameLabel)
        
        var realAddress = ""
        if address != nil {
            realAddress = address!
        } else {
            realAddress = "Address Not Available"
        }
            let addressLabel = UILabel(frame:CGRect(x: 8, y: bounds.height-40, width: bounds.width, height: 50))
            addressLabel.translatesAutoresizingMaskIntoConstraints = false
            addressLabel.text = realAddress
            addressLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
            addressLabel.textAlignment = .left
            addressLabel.textColor = .gray
            addSubview(addressLabel)
        
        var realPrice = ""
        if price != nil {
            realPrice = price!
        } else {
            realPrice = "n/a"
        }
            let priceLabel = UILabel(frame:CGRect(x:bounds.width-108, y: bounds.height-55, width:100, height: 40))
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            priceLabel.text = realPrice
            priceLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            priceLabel.textAlignment = .right
            priceLabel.textColor = .gray
            addSubview(priceLabel)
        
        
        var roundedDistance = ""
        if distance != nil {
            roundedDistance = String(Double(round(10*(distance!/1000))/10))+" km away"
        } else {
            roundedDistance = "n/a"
        }
        let distanceLabel = UILabel(frame:CGRect(x:bounds.width-108, y: bounds.height-35, width:100, height: 40))
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.text = roundedDistance
        distanceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        distanceLabel.textAlignment = .right
        distanceLabel.textColor = .gray
        addSubview(distanceLabel)
        
        imageViewStatus = UIImageView(frame: CGRect(x: (bounds.width / 2) - 37.5, y: 25, width: 75, height: 75))
        imageViewStatus.alpha = 0
        addSubview(imageViewStatus)
        
        overLayImage = UIImageView(frame:bounds)
        overLayImage.alpha = 0
        addSubview(overLayImage)
        
    }

    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = self.center;
            break;
        //in the middle of a swipe
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            updateOverlay(xCenter)
            break;
            
        // swipe ended
        case .ended:
            afterSwipeAction()
            break;
            
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
    }
    func updateOverlay(_ distance: CGFloat) {
        delegate?.currentCardStatus(card: self, distance: distance)
    }
    
    func afterSwipeAction() {
        
        if xCenter > THERESOLD_MARGIN {
            rightAction()
        }
        else if xCenter < -THERESOLD_MARGIN {
            leftAction()
        }
        else {
            //reseting image
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.delegate?.currentCardStatus(card: self, distance:0)
            })
        }
    }
    
    func rightAction() {
        
        let finishPoint = CGPoint(x: frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesRight(card: self)
        print("WATCHOUT RIGHT (LIKED)")
    }
    
    func leftAction() {
        
        let finishPoint = CGPoint(x: -frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesLeft(card: self)
        print("WATCHOUT LEFT (DISLIKED)")
    }
    func rightClickAction() {
        
        imageViewStatus.image = #imageLiteral(resourceName: "likeEmoji")
        overLayImage.image = #imageLiteral(resourceName: "overlay_like")
        let finishPoint = CGPoint(x: center.x + frame.size.width * 2, y: center.y)
        imageViewStatus.alpha = 0.5
        overLayImage.alpha = 0.5
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: 1)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesRight(card: self)
        print("WATCHOUT RIGHT ACTION")
    }
    
    func leftClickAction() {
        
        imageViewStatus.image = #imageLiteral(resourceName: "dislikeEmoji")
        overLayImage.image = #imageLiteral(resourceName: "overlay_skip")
        let finishPoint = CGPoint(x: center.x - frame.size.width * 2, y: center.y)
        imageViewStatus.alpha = 0.5
        overLayImage.alpha = 0.5
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: -1)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesLeft(card: self)
        print("WATCHOUT LEFT ACTION")
    }
    
    
    func rollBackCard(){
        
        UIView.animate(withDuration: 0.5) {
            self.removeFromSuperview()
        }
    }
    
    func shakeAnimationCard(){
        
        imageViewStatus.image = #imageLiteral(resourceName: "dislikeEmoji")
        overLayImage.image = #imageLiteral(resourceName: "overlay_skip")
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.center = CGPoint(x: self.center.x - (self.frame.size.width / 2), y: self.center.y)
            self.transform = CGAffineTransform(rotationAngle: -0.2)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_) -> Void in
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.imageViewStatus.alpha = 0
                self.overLayImage.alpha = 0
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: {(_ complete: Bool) -> Void in
                self.imageViewStatus.image = #imageLiteral(resourceName: "likeEmoji")
                self.overLayImage.image =  #imageLiteral(resourceName: "overlay_like")
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.imageViewStatus.alpha = 1
                    self.overLayImage.alpha = 1
                    self.center = CGPoint(x: self.center.x + (self.frame.size.width / 2), y: self.center.y)
                    self.transform = CGAffineTransform(rotationAngle: 0.2)
                }, completion: {(_ complete: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.imageViewStatus.alpha = 0
                        self.overLayImage.alpha = 0
                        self.center = self.originalPoint
                        self.transform = CGAffineTransform(rotationAngle: 0)
                    })
                })
            })
        })
        
        print("WATCHOUT SHAKE ACTION")
    }
}
