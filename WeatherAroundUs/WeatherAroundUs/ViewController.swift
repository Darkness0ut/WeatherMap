//
//  ViewController.swift
//  WeatherAroundUs
//
//  Created by Kedan Li on 15/2/25.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Spring

class ViewController: UIViewController, GMSMapViewDelegate, InternetConnectionDelegate {

    @IBOutlet var clockButton: ClockView!
    @IBOutlet var mapView: MapView!
    @IBOutlet var searchBar: CitySearchView!
    @IBOutlet var card: CardView!
    @IBOutlet var timeLine: TimeLineView!
    @IBOutlet var returnBut: ReturnButton!
    @IBOutlet var returnCurrentPositionButton: DesignableButton!
    
    @IBOutlet var searchBarLength: NSLayoutConstraint!
    
    var fullLengthOfSearchBar:CGFloat!
    
    var smallImageView: ImageCardView!
    var searchResultList: SearchResultView!
    
    var weatherCardList = [UIImageView]()
    
    var draggingGesture: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        mapView.parentController = self
        clockButton.parentController = self
        timeLine.parentController = self
        returnBut.parentController = self
        searchBar.parentController = self
        card.parentViewController = self
        
        returnCurrentPositionButton.alpha = 0
        var tapGestureRecoYu = UITapGestureRecognizer(target: self, action: "tappedCard:")
        self.card.addGestureRecognizer(tapGestureRecoYu)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        fullLengthOfSearchBar = UIScreen.mainScreen().bounds.width * 2 / 3

        searchResultList = SearchResultView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        searchResultList.frame = CGRectMake(self.searchBar.frame.origin.x + 3, self.searchBar.frame.origin.y + self.searchBar.frame.height + 10, fullLengthOfSearchBar - 6, 0)
        self.view.addSubview(searchResultList)
        searchBar.delegate = searchResultList
        searchResultList.parentController = self
        
    }
    
    override func viewDidAppear(animated: Bool) {

        clockButton.setup()
        timeLine.setup()
        card.setup()
        searchBar.setup()
        
        returnCurrentPositionButton.layer.cornerRadius = returnCurrentPositionButton.frame.width / 2
        returnCurrentPositionButton.layer.shadowOffset = CGSizeMake(1, 1)
        returnCurrentPositionButton.layer.shadowRadius = 1
        returnCurrentPositionButton.layer.shadowOpacity = 0.5
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cityDetailSegue" {
            let toView = segue.destinationViewController as! CityDetailViewController
            toView.cityID = WeatherInfo.currentCityID
            
            if card.imageUrlReady {
                toView.tempImage = card.smallImage.image
            }else{
                toView.tempImage = UIImage(named: (((WeatherInfo.citiesAroundDict[WeatherInfo.currentCityID] as! [String : AnyObject])["weather"] as! [AnyObject])[0] as! [String : AnyObject])["icon"] as! String + ".jpg")
            }
            //avoid label overlay
            clockButton.timeLab.removeFromSuperview()
            returnBut.dissAppear()
            searchBar.hideSelf()
            searchResultList.removeCities()
            card.hideSelf()
            card.removeAllViews()
        }
    }
    
    func tappedCard(sender: UITapGestureRecognizer) {

            if returnCurrentPositionButton.alpha != 0 {
                returnCurrentPositionButton.animation = "fadeOut"
                returnCurrentPositionButton.animate()
            }
            // will display the card when return
            performSegueWithIdentifier("cityDetailSegue", sender: self)
            
    }
    
    @IBAction func returnFromWeatherDetail(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func returnCurrentPositionButtonDidPressed(sender: DesignableButton) {
        
        if UserLocation.centerLocation != nil{
            mapView.shouldDisplayCard = true
            mapView.displayIcon(mapView.camera.target)
            mapView.animateToLocation(UserLocation.centerLocation.coordinate)
        }
    }

}

