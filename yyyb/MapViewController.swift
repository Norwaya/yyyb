//
//  MapViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/21.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
class MapViewController: UIViewController,MAMapViewDelegate, AMapLocationManagerDelegate {

    //MARK: - Properties
    
    let defaultLocationTimeout = 6
    let defaultReGeocodeTimeout = 3
    var context:NSManagedObjectContext!
    var jwdEntity:NSEntityDescription!
    //    let pointAnnotation = MAPointAnnotation()
    
    var mapView: MAMapView!
    var completionBlock: AMapLocatingCompletionBlock!
    lazy var locationManager = AMapLocationManager()
    
    //MARK: - Action Handle
    
    func configLocationManager() {
        locationManager.delegate = self
        
        locationManager.requestLocation(withReGeocode: true, completionBlock: self.completionBlock)
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        locationManager.pausesLocationUpdatesAutomatically = false //设置不允许系统暂停定位
        
        locationManager.allowsBackgroundLocationUpdates = true //允许后台定位
        
        locationManager.locationTimeout = defaultLocationTimeout
        
        locationManager.reGeocodeTimeout = defaultReGeocodeTimeout

    }
    
//    func showSegmentAction(sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 1 {
//            
//            locationManager.stopUpdatingLocation()
//            
//            mapView.removeAnnotation(pointAnnotation)
//        }
//        else {
//            mapView.addAnnotation(pointAnnotation)
//            
//            locationManager.startUpdatingLocation()
//        }
//    }
    func addRecord(sender: UIButton){
        let vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "add01")
        self.navigationController?.pushViewController(vcInstance!, animated: true)
    }
    func takePhoto(sender: UIButton){
        takePhotos()
    
    }
    //MARK: - AMapLocationManagerDelegate
    //定位失败 时调用
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        let error = error as NSError
        NSLog("didFailWithError:{\(error.code) - \(error.localizedDescription)};")
    }
    
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
//        NSLog("moved by user")
    }
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        point.latitude = userLocation.location.coordinate.latitude
        point.longitude = userLocation.location.coordinate.longitude
        let result = gaodeTobaidu(jd: point.longitude, wd: point.latitude)
//        NSLog("(%f %f) -> (%f %f)",point.longitude,point.latitude,result.jd,result.wd)
        if saveEnable(){
            let jwd = NSManagedObject.init(entity: jwdEntity!, insertInto: context) as! Jwd
            jwd.jd  = String.init(format: "%f", result.jd)
            jwd.wd = String.init(format: "%f", result.wd)
            
            
            print("save -------")
            
            let format = DateFormatter.init()
            format.dateFormat = "yyyyMMddHHmmss"
            jwd.xjsj = format.string(from: Date())
            try? context.save()
        }
    }
    
    
    //保存定位地点
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        point.latitude = location.coordinate.latitude
        point.longitude = location.coordinate.longitude
        let result = gaodeTobaidu(jd: point.longitude, wd: point.latitude)
        NSLog("(%f %f) -> (%f %f)",point.longitude,point.latitude,result.jd,result.wd)
        
        //  控制 频率 保存 经纬度
        
        
        
        //NSLog("\nlat: %f \nlon: %f \ndetail: %@ ", point.latitude,point.longitude,point.detailAddress)
        //        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy); reGeocode:\(reGeocode?.formattedAddress)};");
        
//        pointAnnotation.coordinate = location.coordinate
//        mapView.centerCoordinate = location.coordinate
//        mapView.setZoomLevel(15.1, animated: true)
        
    }
    func saveEnable() -> Bool{
        let format = DateFormatter.init()
        format.dateFormat = "ss"
        print("ss:\(format.string(from: Date()))")
         let date = format.string(from: Date())
        print((Int.init(date)!%10 == 0))
       
        return (Int.init(date)!%10 == 0)
    }
    func gaodeTobaidu(jd:Double,wd:Double) -> (jd:Double,wd:Double){
        let x_pi = 3.14159265358979324 * 3000.0 / 180.0;
        let x = jd
        let y = wd
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
        let bd_lon = z * cos(theta) + 0.0065;
        let bd_lat = z * sin(theta) + 0.006;
        return (bd_lon,bd_lat)
    }
    
    func initCompleteBlock() {
        
        self.completionBlock = { [weak self] (location: CLLocation?, regeocode: AMapLocationReGeocode?, error: Error?) in
            
            NSLog("start regeocode ---\(location)")
            if let error = error {
                let error = error as NSError
                NSLog("locError:{\(error.code) - \(error.localizedDescription)};")
                
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    return;
                }
            }
            
            if let location = location {
                
                if let regeocode = regeocode {
                    NSLog("\(regeocode.formattedAddress) \n \(regeocode.citycode!)-\(regeocode.adcode!)-\(location.horizontalAccuracy)m")
                }
                else {
                    NSLog("lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)m")
                }
            }
            
        }
    }
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        jwdEntity = try! NSEntityDescription.entity(forEntityName: "Jwd", in: context)
        let result = try? context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "Jwd")) as! [Jwd] as Array
        for jwd in result! {
            context.delete(jwd )
        }
        try? context.save()
        
        view.backgroundColor = UIColor.white
        self.title = "巡查定位"
        initToolBar()
        initMapView()
        initOtherView()
        
        initCompleteBlock()
        
        configLocationManager()
        backAction()
//        mapView.addAnnotation(pointAnnotation)
        locationManager.startUpdatingLocation()
    }
    func backAction(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(test(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "上传", style: UIBarButtonItemStyle.done, target: self, action: #selector(upload(sender:)))
    }
    func test(sender: UIBarButtonItem){
        //处理 未上传的 报告
        let rbjl = try! context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "Rbxx"))
        let kbjl = try! context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "Kbxx"))
        
        if(rbjl.count + kbjl.count > 0){
            return
        }
        NSLog("deal daily and express")
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    func upload(sender: UIBarButtonItem){
        let vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "upload")
        vcInstance?.navigationController?.isToolbarHidden = true
        self.navigationController?.pushViewController(vcInstance!, animated: true)
    }
    var toolbar: UIToolbar!
    override func viewWillAppear(_ animated: Bool) {
        NSLog("view will appear")
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NSLog("view did appear")
        super.viewDidAppear(animated)
        
        
    }
    
    func initMapView() {
        mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
        view.addSubview(mapView)
    }
    var gpsButton: UIButton!
    func initOtherView(){
        
        toolbar = navigationController?.toolbar
        let zoomPannelView = self.makeZoomPannelView()
        zoomPannelView.center = CGPoint.init(x: self.view.bounds.size.width -  zoomPannelView.bounds.width/2 - 10, y: self.view.bounds.size.height - toolbar.bounds.height -  zoomPannelView.bounds.width/2 - 30)
        
        zoomPannelView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleLeftMargin]
        self.view.addSubview(zoomPannelView)
        
        gpsButton = self.makeGPSButtonView()
        gpsButton.center = CGPoint.init(x: gpsButton.bounds.width / 2 + 10, y:self.view.bounds.size.height - toolbar.bounds.height -  gpsButton.bounds.width / 2 - 20)
        self.view.addSubview(gpsButton)
        gpsButton.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleRightMargin]
    }
    func makeGPSButtonView() -> UIButton! {
        let ret = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        ret.backgroundColor = UIColor.white
        ret.layer.cornerRadius = 4
        
        ret.setImage(UIImage.init(named: "gpsStat1"), for: UIControlState.normal)
        ret.addTarget(self, action: #selector(self.gpsAction), for: UIControlEvents.touchUpInside)
        
        return ret
    }
    
    func makeZoomPannelView() -> UIView {
        let ret = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 98))
        
        let incBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 49))
        incBtn.setImage(UIImage.init(named: "increase"), for: UIControlState.normal)
        incBtn.sizeToFit()
        incBtn.addTarget(self, action: #selector(self.zoomPlusAction), for: UIControlEvents.touchUpInside)
        
        let decBtn = UIButton.init(frame: CGRect.init(x: 0, y: 49, width: 53, height: 49))
        decBtn.setImage(UIImage.init(named: "decrease"), for: UIControlState.normal)
        decBtn.sizeToFit()
        decBtn.addTarget(self, action: #selector(self.zoomMinusAction), for: UIControlEvents.touchUpInside)
        
        ret.addSubview(incBtn)
        ret.addSubview(decBtn)
        
        return ret
    }
    //MARK:- event handling
    func zoomPlusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom+1, animated: true)
    }
    
    func zoomMinusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom-1, animated: true)
    }
    
    func gpsAction() {
        if(self.mapView.userLocation.isUpdating && self.mapView.userLocation.location != nil) {
            self.mapView.setCenter(self.mapView.userLocation.location.coordinate, animated: true)
            self.gpsButton.isSelected = true
            mapView.userTrackingMode = MAUserTrackingMode.follow
        }
    }
//    func initToolBar() {
//        let flexble = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        
//        showSegment.addTarget(self, action: #selector(showSegmentAction(sender:)), for: .valueChanged)
//        showSegment.selectedSegmentIndex = 0
//        
//        setToolbarItems([flexble, UIBarButtonItem(customView: showSegment), flexble], animated: false)
//    }
    func initToolBar(){
        let flexble = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let one = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action:  #selector(addRecord(sender:)))
        let carema = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(takePhoto(sender:)))
        setToolbarItems([flexble, one,flexble ,carema, flexble], animated: true)
        

    }
    //MARK: - MAMapView Delegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAPointAnnotation {
            let pointReuseIndetifier = "pointReuseIndetifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? MAPinAnnotationView
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.canShowCallout  = false
            annotationView?.animatesDrop    = false
            annotationView?.isDraggable     = false
            annotationView?.image           = UIImage(named: "icon_location.png")
            
            return annotationView
        }
        
        return nil
    }
    override func viewWillDisappear(_ animated: Bool) {
        //save the current position
        
//        mapView.removeAnnotation(pointAnnotation)
        
        
        if self.isMovingFromParentViewController{
            locationManager.stopUpdatingLocation()
        }else{
            savePosition()
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    var point = CurrentPoint()
    func savePosition(){
        if (point != nil){
            let dic =  UserDefaults.standard
            dic.set(point.latitude, forKey: "lat")
            dic.set(point.longitude, forKey: "lon")
            dic.set(point.detailAddress, forKey: "add")
            dic.synchronize()
//            print("\(dic.double(forKey: "lat")) - \(dic.double(forKey: "lon")) - \(dic.string(forKey: "add"))")
        }
    }
}
extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePhotos(){
        //判断相机是否可用 可以就调用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
//            picker.allowsEditing = true  // 允许拍摄图片后编辑
            self.present(picker, animated: true, completion: nil)
        } else {
            print("can't find camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("photo finished")
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, nil, nil, nil)
        UIView.animate(withDuration: 0.001, animations: {
            picker.dismiss(animated: false, completion: {
                self.present(picker, animated: true, completion: nil)
            })
        })
        //        UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel imagepicker ")
        picker.dismiss(animated: true, completion: {
            print("dismiss picker")
        })

    }
}
class CurrentPoint: NSObject{
    var latitude: Double = 108.0
    var longitude: Double = 34.8
    var detailAddress: String = ""
    
}
