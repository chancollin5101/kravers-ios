//
//  savedViewController.swift
//  KraversFinal
//
//  Created by Collin Chan on 2018-08-31.
//  Copyright © 2018 Collin Chan. All rights reserved.
//

import UIKit
import Firebase

struct restInfo {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let image: String
    let phone: String
    let rating: Double
    let categoies: String
}

class savedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    @IBAction func onSwipePan(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        print(UIPanGestureRecognizer.self)
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    @IBOutlet weak var savedTableView: UITableView!
    
    var ref: DatabaseReference = Database.database().reference()
    var data = [restInfo]()
    
    let username = Auth.auth().currentUser?.displayName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTableView.delegate = self
        savedTableView.dataSource = self
        ref.child("Users").child(username!).queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            guard let name = value?["name"] as? String else { return }
            guard let address = value?["address"] as? String else { return }
            guard let latitude = value?["latitude"] as? Double else { return }
            guard let longitude = value?["longitude"] as? Double else { return }
            guard let image = value? ["image"] as? String else { return }
            guard let phone = value?["phone"] as? String else { return }
            guard let rating = value?["rating"] as? Double else { return }
            guard let categories = value?["categories"] as? String else { return }
            self.data.insert(restInfo(name: name, address: address, latitude: latitude, longitude: longitude, image: image, phone: phone, rating: rating, categoies: categories), at: 0)
            self.savedTableView.reloadData()
        })
            
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedTableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as! savedCell
        
        cell.restaurant = data[indexPath.row]
        
        return cell
    }
    
    //function for displaying actions after clicking on the saved restaurant
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        vc?.latGG = data[indexPath.row].latitude
        vc?.longGG = data[indexPath.row].longitude
        vc?.nameGG = data[indexPath.row].name
        vc?.cateGG = data[indexPath.row].categoies
        self.navigationController?.pushViewController(vc!, animated: true)*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
