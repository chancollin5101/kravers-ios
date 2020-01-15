//
//  SuggestionViewController.swift
//  MilkShake
//
//  Created by Collin Chan on 6/8/2018.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import UIKit
import CDYelpFusionKit
import ObjectMapper
import CoreLocation
import Firebase
import FirebaseDatabase

infix operator >!<

func >!< (object1: AnyObject!, object2: AnyObject!) -> Bool {
    return (object_getClassName(object1) != object_getClassName(object2))
}

class SuggestionViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var viewBackground: SwipeableCardViewContainer!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    var moreInfod = false
    var yaYeet = [CDYelpBusiness?]()
    var allCardsArray = [contentCard]()
    var currentLoadedCardsArray = [contentCard]()
    var currentIndex = 0
    var food = ""
    var counter = 0
    var lat = 0.0
    var long = 0.0
    var ref: DatabaseReference = Database.database().reference()
    
    let  MAX_BUFFER_SIZE = 3;
    let  SEPERATOR_DISTANCE = 8;
    let manager = CLLocationManager()
    let email = Auth.auth().currentUser?.email
    let username = Auth.auth().currentUser?.displayName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
        if (manager.location?.coordinate.latitude != nil && manager.location?.coordinate.longitude != nil && moreInfod == false) {
            CDYelpFusionKitManager.shared.apiClient.cancelAllPendingAPIRequests()
            CDYelpFusionKitManager.shared.apiClient.searchBusinesses(byTerm: self.food,
                                                                 location: nil,
                                                                 latitude: Double((manager.location?.coordinate.latitude)!),
                                                                 longitude: Double((manager.location?.coordinate.longitude)!),
                                                                 radius: 1000,
                                                                 categories: nil,
                                                                 locale: nil,
                                                                 limit: nil,
                                                                 offset: 0,
                                                                 sortBy: .rating,
                                                                 priceTiers: nil,
                                                                 openNow: true,
                                                                 openAt: nil,
                                                                 attributes: nil) { (response) in
                                                                    
                                                                    if let response = response,
                                                                        let businesses = response
                                                                            .businesses,
                                                                        businesses.count > 0 {
                                                                        
                                                                        for business in businesses {
                                                                            print(business.name!)
                                                                            self.yaYeet.append(business)
                                                                        }
                                                                        print(self.yaYeet.count as Any)
                                                                    }
            self.loadCardValues(numCards: self.yaYeet.count, dataArray: self.yaYeet as! [CDYelpBusiness])
            }
        } else if (manager.location?.coordinate.latitude != nil && manager.location?.coordinate.longitude != nil && moreInfod == true) {
            self.loadCardValues(numCards: self.yaYeet.count, dataArray: self.yaYeet as! [CDYelpBusiness])

            }
        else {
            CDYelpFusionKitManager.shared.apiClient.cancelAllPendingAPIRequests()
            if moreInfod == false {
            CDYelpFusionKitManager.shared.apiClient.searchBusinesses(byTerm: self.food,
                                                                     location: "Toronto",
                                                                     latitude: nil,
                                                                     longitude: nil,
                                                                     radius: 1000,
                                                                     categories: nil,
                                                                     locale: nil,
                                                                     limit: nil,
                                                                     offset: 0,
                                                                     sortBy: .rating,
                                                                     priceTiers: nil,
                                                                     openNow: true,
                                                                     openAt: nil,
                                                                     attributes: nil) { (response) in
                                                                        
                                                                        if let response = response,
                                                                            let businesses = response.businesses,
                                                                            businesses.count > 0 {
                                                                            
                                                                            for business in businesses {
                                                                                print(business.name!)
                                                                                self.yaYeet.append(business)
                                                                            }
                                                                            print(self.yaYeet.count as Any)
                                                                        }
                                                                        self.loadCardValues(numCards: self.yaYeet.count, dataArray: self.yaYeet as! [CDYelpBusiness])
                }
            } else {
                self.loadCardValues(numCards: self.yaYeet.count, dataArray: self.yaYeet as! [CDYelpBusiness])
            }
        }
    }
    
    @IBAction func touched(_ sender: Any) {
      moreInfod = true
    }
    
    func createCard(image: URL?, name: String?, address: String?, distance: Double?, price: String?) -> contentCard {
        let card = contentCard(frame: CGRect(x: 0, y: 0, width: viewBackground.frame.size.width, height: viewBackground.frame.size.height), image: image, name: name, address: address, distance: distance, price: price)
        card.delegate = self as TinderCardDelegate
        return card
    }
    
    func loadCardValues(numCards: Int, dataArray: [CDYelpBusiness]) {
        
        if dataArray.count > 0 {
            
            let capCount = (dataArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : dataArray.count
            var i = 0
            
            while (i < numCards) {
                let newCard = createCard(image: dataArray[i].imageUrl, name: dataArray[i].name, address: dataArray[i].location!.addressOne, distance: dataArray[i].distance, price: dataArray[i].price)
                if i < capCount {
                    currentLoadedCardsArray.append(newCard)
                }
                i = i+1
            }
            i = 0
            for (i,_) in currentLoadedCardsArray.enumerated() {
                if i > 0 {
                    viewBackground.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                } else {
                    viewBackground.addSubview(currentLoadedCardsArray[i])
                }
            }
            animateCardAfterSwiping()
            perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
        }
    }
    
    @objc func loadInitialDummyAnimation() {
        //UIView.animate(withDuration: 2.0) {
        //self.blurredView.effect = self.effect
        let dummyCard = self.currentLoadedCardsArray.first;
        dummyCard?.shakeAnimationCard()
        //  self.blurredView.effect = nil
        
        //}
    }
    
    @IBAction func likED(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.leftClickAction()()
        
    }
    
    @IBAction func dislikED(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.rightClickAction()()
        
    }
    func theEnd(atCounter: Int?, count: Int?) -> Bool{
        if atCounter!+2 == count {
            return true
        } else {
            return false
        }
    }
    
    
    func removeObjectAndAddNewValues() {
        
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewBackground.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        }
        print(currentIndex)
        animateCardAfterSwiping()
    }
    func animateCardAfterSwiping() {
        
        for (i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
                if i == 0 {
                    card.isUserInteractionEnabled = true
                }
                var frame = card.frame
                frame.origin.y = CGFloat(i * 2)
                card.frame = frame
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




extension SuggestionViewController : TinderCardDelegate{
    
    // action called when the card goes to the left.
    func cardGoesLeft(card: contentCard) {
        removeObjectAndAddNewValues()
        counter = counter + 1
        if counter > yaYeet.count {
            counter = 0
        }
    }
    // action called when the card goes to the right.
    func cardGoesRight(card: contentCard) {
        var place = ""
        for ting in (yaYeet[counter]?.location?.displayAddress)! {
            if (ting == yaYeet[counter]?.location?.displayAddress?.last){
                place.append(ting)
            } else {
            place.append(ting+" ")
            }
        }
        var categories = ""
        for thing in (yaYeet[counter]?.categories)! {
            if (thing >!< yaYeet[counter]?.categories?.last){
                categories.append(thing.title!)
            } else {
            categories.append(thing.title!+", ")
            }
        }
        let restaurant : [String: AnyObject] = ["name": yaYeet[counter]?.name as AnyObject,
                                                "latitude": yaYeet[counter]?.coordinates?.latitude as AnyObject,
                                                "longitude": yaYeet[counter]?.coordinates?.longitude as AnyObject,
                                                "image": yaYeet[counter]?.imageUrl?.absoluteString as AnyObject,
                                                "phone": yaYeet[counter]?.displayPhone as AnyObject,
                                                "rating": yaYeet[counter]?.rating as AnyObject,
                                                "address": place as AnyObject,
                                                "categories": categories as AnyObject]
        self.ref.child("Users").child(username!).childByAutoId().setValue(restaurant)
        removeObjectAndAddNewValues()
        counter = counter + 1
        if counter > yaYeet.count {
            counter = 0
        }
    }
    func currentCardStatus(card: contentCard, distance: CGFloat) {
    }
}





