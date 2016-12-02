//
//  SingleLocationAloneViewController.swift
//  officialDemoLoc
//
//  Created by liubo on 10/8/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

import UIKit

class SingleLocationAloneViewController: UIViewController, AMapLocationManagerDelegate {
    
    //MARK: - Properties
    
    let defaultLocationTimeout = 6
    let defaultReGeocodeTimeout = 3
    
    var displayLabel: UILabel!
    var completionBlock: AMapLocatingCompletionBlock!
    lazy var locationManager = AMapLocationManager()
    
    //MARK: - Action Handle
    
    func configLocationManager() {
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.locationTimeout = defaultLocationTimeout
        
        locationManager.reGeocodeTimeout = defaultReGeocodeTimeout
    }
    
    func cleanUpAction() {
        locationManager.stopUpdatingLocation()
        
        locationManager.delegate = nil
        
        displayLabel.text = nil
    }
    
    func reGeocodeAction() {
        displayLabel.text = nil
        
        locationManager.requestLocation(withReGeocode: true, completionBlock: completionBlock)
    }
    
    func locAction() {
        displayLabel.text = nil
        
        locationManager.requestLocation(withReGeocode: false, completionBlock: completionBlock)
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        
        initToolBar()
        
        initNavigationBar()
        
        initDisplayLabel()
        
        initCompleteBlock()
        
        configLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    //MARK: - Initialization
    
    func initCompleteBlock() {
        
        completionBlock = { [weak self] (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            if let error = error {
                let error = error as NSError
                NSLog("locError:{\(error.code) - \(error.localizedDescription)};")
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    return;
                }
            }
            
            if let location = location {
                
                if let regeocode = regeocode {
                    self?.displayLabel.text = "\(regeocode.formattedAddress) \n \(regeocode.citycode!)-\(regeocode.adcode!)-\(location.horizontalAccuracy)m"
                }
                else {
                    self?.displayLabel.text = "lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)m"
                }
            }
            
        }
    }
    
    func initDisplayLabel() {
        
        displayLabel = UILabel(frame: view.bounds)
        displayLabel.backgroundColor = UIColor.clear
        displayLabel.textColor = UIColor.black
        displayLabel.textAlignment = .center
        displayLabel.numberOfLines = 0
        
        view.addSubview(displayLabel)
    }
    
    func initToolBar() {
        let flexble = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let reGeocodeItem = UIBarButtonItem(title: "带逆地理定位", style: .plain, target: self, action: #selector(reGeocodeAction))
        let locItem = UIBarButtonItem(title: "不带逆地理定位", style: .plain, target: self, action: #selector(locAction))
        
        setToolbarItems([flexble, reGeocodeItem, flexble, locItem, flexble], animated: false)
    }
    
    func initNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clean", style: .plain, target: self, action: #selector(cleanUpAction))
    }

}
