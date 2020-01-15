//
//  ViewController.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import UIKit
import CDYelpFusionKit
import ObjectMapper
import CoreLocation
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, SwipeableCardViewDataSource, StoryboardInstantiable, ViewControllerDelegate, SearchViewControllerDelegate {
    
    static var storyboardType: Storyboard = .tabBar
    
    let model = Model();
    
    var delegate: SwipeableCardViewDelegate?

    @IBOutlet weak var swipeableCardView: SwipeableCardViewContainer!
    @IBOutlet weak var likeIcon: UIButton!
    @IBOutlet weak var dislikeIcon: UIButton!
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let food = model.getCategory();
        
        model.delegate = self
        model.setNewCategory(food)
        loadData();
    
    }
    
    func reloadAfterData() {
        self.swipeableCardView.dataSource = self
        self.swipeableCardView.reloadData()
    }
    
    func updateSearchType(type: [CDYelpBusinessCategoryFilter]) {
        model.setNewCategory(type)
    }
    
    func loadData(){
        let backgroundThread = DispatchQueue.global(qos: .background);
        backgroundThread.async {
            do{
                try self.model.fetchData();
            }
            catch {
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
        
}
    
    //MORE INFO PASSING INFO ONTO MORE INFO PAGE
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is moreInfoViewController
        {
            let bc = segue.destination as? moreInfoViewController
            if (sender as! UIButton) == moreInfoButton {
                bc?.name = yaYeet[counter]!.name!
                bc?.phone = yaYeet[counter]!.displayPhone!
                bc?.rating = yaYeet[counter]!.rating!
                bc?.address = yaYeet[counter]!.location!.displayAddress!
                bc?.lat = yaYeet[counter]!.coordinates!.latitude!
                bc?.long = yaYeet[counter]!.coordinates!.longitude!
            }
        }
    }*/

// MARK: - SwipeableCardViewDataSource

extension ViewController {
    
    func numberOfCards() -> Int {
        return viewModels.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let viewModel = viewModels[index]
        let cardView = SampleSwipeableCard()
        cardView.viewModel = viewModel
        if (swipeableCardView.counter == 5) {
            let dvc = popupViewController.initializeFromStoryboard();
            
            self.present(dvc, animated: true, completion: nil)
        }
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
}

extension ViewController {
    
    var viewModels: [SampleSwipeableCellViewModel] {
        var subViewModels: [SampleSwipeableCellViewModel] = []

        for restaurant in model.getLists() {
            let image1: UIImage?
            if restaurant?.imageUrl != nil {
                let imageData:NSData = NSData(contentsOf: (restaurant?.imageUrl!)!)!
                image1 = UIImage(data: imageData as Data)
            } else {
                image1 = UIImage(named: "imageNot")
            }
            let card = SampleSwipeableCellViewModel(title: (restaurant?.name)!,
                subtitle:(restaurant?.categories?.first?.title)!, image: image1!)
            subViewModels.append(card)
        }
        return subViewModels
    }
    
}

