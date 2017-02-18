//
//  TraceViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/3.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON
class TraceViewController: UIViewController {
    
    var mapView: MAMapView!
    var origTrace: Array<MAMultiPolyline>!
    var processedTrace: Array<MAMultiPolyline>!
    var targetInputFile: NSString!
    var queryOperation: Operation!
    
    let url = "http://\(Contact.getUrl())/sbjl.do"
//     let url = "http://192.168.0.173:8084/sbjl.do"
    
    var gj:String!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//        queryAction()
    }
    func cf(){
        let fm = FileManager.init()
        let directory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let file = directory.appending("/newFile.txt")
        print(file)
        if(!fm.fileExists(atPath: file)){
            fm.createFile(atPath: file, contents: nil, attributes: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "巡查轨迹"
        self.origTrace = Array.init()
        self.processedTrace = Array.init()
        initMapView()
        
        // test trace
        printTrace()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMapView(){
        mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func printTrace(){
        let info = getFromUser()
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json; charset=utf-8"
        ]
        let parameters: Parameters =
            [
                "m":"getXjgjInfo",
                "rq": gj!,
                "unitId": info.ssbm
        ]

        Alamofire.request(url,method:.get,parameters:parameters,headers:headers)
            .responseJSON{
                response in
                let json = JSON.init(response.result.value)
                print(json)
                var code = json["code"]
                if( code == 0){
                    self.customQueryAction(json: json)
                }
        }

        
        
        
    }
    func getFromUser() -> (lrry:String,ssbm:String){
        let app = UIApplication.shared.delegate as! AppDelegate
        let managerObjectContext = app.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        request.predicate = NSPredicate.init(format: "yhm CONTAINS %@", UserDefaults.standard.string(forKey: "currentUserId")!)
        let result = try? managerObjectContext.fetch(request) as! [User] as Array
        if(result?.count == 0){
            return ("nil","nil")
        }
        let user = result?[0]
        print("xm: \(user?.xm) ssbm: \(user?.ssbm)")
        return (user!.llry ?? "",user!.ssbm!)
    }

    func customQueryAction(json:JSON){
//        let gjArray = json["array"]
        let traceManager = MATraceManager.init()
        
        var arr:Array<MATraceLocation> = Array.init()
        var arr2:Array<MATracePoint> = Array.init()
        let arrays = json["array"][0]
        for index in 0..<arrays.count{
            let element = arrays[index]
            print(element)
            let lat:Double = element["wd"].doubleValue
            let lon:Double = element["jd"].doubleValue
            print("\(lat) ->\(lon)")
            let t = element["xjsj"].string
//            let bearing = element["bearing"]
//            let speed = element["speed"]
            print("\(Thread.current)")
            let temp = MATraceLocation.init()
            
            temp.loc = CLLocationCoordinate2D.init(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
            let format = DateFormatter.init()
            format.dateFormat = "yyyy-MM-dd"
            temp.time = (format.date(from: t!)?.timeIntervalSince1970)!
//            temp.angle = bearing as! Double;
//            temp.speed = speed as! Double * 3.6;
            arr.append(temp)
            
            let temp2 = MATracePoint.init()
            let cll = AMapCoordinateConvert(temp.loc, AMapCoordinateType.baidu)
            temp2.latitude = cll.latitude
            temp2.longitude = cll.longitude
            //            temp2.latitude = lat as! CLLocationDegrees
            //            temp2.longitude = lon as! CLLocationDegrees
            arr2.append(temp2)
        }
        //不联网 默认使用这个方法 。联网 是用下面的方法
                self.addTrace(points: arr2, mapview: self.mapView)
        
//        queryOperation = traceManager.queryProcessedTrace(with: arr, type: AMapCoordinateType(rawValue: UInt.max)!, processingCallback: { (index:Int32, arr:[MATracePoint]?) in
//            
//        }, finishCallback: { (arr:[MATracePoint]?, distance:Double) in
//            NSLog("distance=%f", distance)
//            
//            self.addTrace(points: arr, mapview: self.mapView)
//            
//            self.queryOperation = nil;
//        }, failedCallback: { (errCode:Int32, errDesc:String?) in
//            print(errDesc)
//            self.queryOperation = nil
//        })
    }
    
    
    
    
    func addTrace(points:Array<MATracePoint>!, mapview:MAMapView!) {
        let polyline = self.makePolyline(points: points)
        
        if(polyline == nil) {
            return
        }
        
//        if(mapview == self.mapView1) {
//            mapview .removeOverlays(self.origTrace)
//            self.origTrace.removeAll()
//            self.origTrace.append(polyline!)
//            mapview .addOverlays(self.origTrace)
//        } else {
            mapview.removeOverlays(self.processedTrace)
            self.processedTrace.removeAll()
            
            self.processedTrace.append(polyline!)
            mapview .addOverlays(self.processedTrace)
//        }
        
        mapview.setVisibleMapRect((polyline?.boundingMapRect)!, animated:false)
    }

    func makePolyline(points:Array<MATracePoint>!) -> MAMultiPolyline! {
        if(points.count == 0) {
            return nil
        }
        
        let buffer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: points.count)
        var i = 0;
        for element in points {
            buffer[i].latitude = element.latitude;
            buffer[i].longitude = element.longitude;
            i += 1
        }
        
        let ret = MAMultiPolyline.init(coordinates: buffer, count: UInt(i), drawStyleIndexes: [10,20])
        
        buffer.deallocate(capacity: points.count)
        
        return ret
    }
    
    func queryAction() {
        var bundlePath = Bundle.main.path(forResource: "GPSTrace02", ofType: "txt")
   
        targetInputFile = NSString.init(string: bundlePath!)
        
        if(targetInputFile.length <= 0) {
            return
        }
        
        var data = Data.init()
        data .append("[".data(using: String.Encoding.utf8)!)
        
        data.append(try! Data.init(contentsOf: URL.init(fileURLWithPath: targetInputFile as String), options: Data.ReadingOptions.uncachedRead))
        data .append("]".data(using: String.Encoding.utf8)!)
        
        let jsonObj = try? JSONSerialization .jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String:Any]]
        
        let traceManager = MATraceManager.init()
        
        var arr:Array<MATraceLocation> = Array.init()
        var arr2:Array<MATracePoint> = Array.init()
        
        for element in jsonObj! {
            let lat = element["lat"]
            let lon = element["lon"]
            let t = element["loctime"]
            let bearing = element["bearing"]
            let speed = element["speed"]
            
            
            
            let temp = MATraceLocation.init()
            temp.loc = CLLocationCoordinate2D.init(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
            temp.time = t as! Double;
            temp.angle = bearing as! Double;
            temp.speed = speed as! Double * 3.6;
            arr.append(temp)
            
            let temp2 = MATracePoint.init()
            let cll = AMapCoordinateConvert(temp.loc, AMapCoordinateType.baidu)
            temp2.latitude = cll.latitude
            temp2.longitude = cll.longitude
//            temp2.latitude = lat as! CLLocationDegrees
//            temp2.longitude = lon as! CLLocationDegrees
            arr2.append(temp2)
        }
        
//        self.addTrace(points: arr2, mapview: self.mapView)
        
        queryOperation = traceManager.queryProcessedTrace(with: arr, type: AMapCoordinateType(rawValue: UInt.max)!, processingCallback: { (index:Int32, arr:[MATracePoint]?) in
            
        }, finishCallback: { (arr:[MATracePoint]?, distance:Double) in
            NSLog("distance=%f", distance)
            
            self.addTrace(points: arr, mapview: self.mapView)
            
            self.queryOperation = nil;
        }, failedCallback: { (errCode:Int32, errDesc:String?) in
            print(errDesc)
            self.queryOperation = nil
        })
    }

}
extension TraceViewController : MAMapViewDelegate{
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAMultiPolyline.self) {
            let renderer: MAMultiColoredPolylineRenderer = MAMultiColoredPolylineRenderer.init(multiPolyline: overlay as! MAMultiPolyline!)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.cyan
            renderer.strokeColors = [UIColor.red, UIColor.green, UIColor.blue]
            
            return renderer
        }
        
        return nil
    }
}
