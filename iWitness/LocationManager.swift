//
//  LocationManager.swift
//  iWitness
//
//  Created by Sravani on 06/01/16.
//  Copyright © 2016 PTG. All rights reserved.
//

import UIKit
import CoreLocation


class LocationManager: NSObject,CLLocationManagerDelegate {

    static let sharedInstance = LocationManager()
    var locationManager = CLLocationManager()
    var isStarted = false
    var currentLocation:CLLocation!
    var locationStatus:CLAuthorizationStatus!
    
    
    
    
    override init() {
    
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      //  locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation
        
        locationStatus = CLAuthorizationStatus.notDetermined
        
    
    }
    
    func startLocation()
    {
//        if isStarted
//        {
//            return
//        }
//        
//        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined){
//            
//            locationManager.requestAlwaysAuthorization()
//        }
//        else{
//            self.isStarted = true
//
//        }
//        locationManager.startUpdatingLocation()
//
        
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
              
                locationManager.requestWhenInUseAuthorization()
                return
                
        }
        
        if isStarted
        {
            return
        }

        self.isStarted = true
        
        locationManager.startUpdatingLocation()
        
    }
    
    func stopLocation()
    {
      if !isStarted
      {
       return
      }
        
      self.isStarted = false
      locationManager.stopUpdatingLocation()
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
   
        locationStatus = status
    
    }

  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let newlocation = locations.last as CLLocation!
        if currentLocation != nil{
        //checking repo
            let distance = newlocation?.distance(from: currentLocation)
            if(Double(distance!) < 10){
             return
            }
        }
        
        currentLocation = newlocation
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotification_LocationUpdated), object: nil)
        
    }

     func locationManager(_ manager: CLLocationManager,
        didFailWithError error: Error)
    {
        
    }
    

}
