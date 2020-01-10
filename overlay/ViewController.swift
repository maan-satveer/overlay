//
//  ViewController.swift
//  overlay
//
//  Created by MacStudent on 2020-01-10.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import  MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {
   var locationManager = CLLocationManager()
    @IBOutlet var mapview: MKMapView!
    let places = Place.getPlaces()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.showsUserLocation = true
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        addAnnotation()
       // addPolyLine()
        addPolygon()
    }
    func addAnnotation() {
        mapview.delegate = self
        mapview.addAnnotations(places)
        let overlays = places.map{ (MKCircle(center: $0.coordinate, radius: 1000))}
        mapview.addOverlays(overlays)
    }
    func addPolyLine(){
        let locations = places.map{$0.coordinate}
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapview.addOverlay(polyline)
    }
    func addPolygon(){
         let locations = places.map{$0.coordinate}
        let polygon = MKPolygon(coordinates: locations, count: locations.count)
        mapview.addOverlay(polygon)
    }


}
extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        else{
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place_2x")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle{
            let rendrer = MKCircleRenderer(overlay: overlay)
                 rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
                 rendrer.strokeColor = UIColor.green
                 rendrer.lineWidth = 2
                 return rendrer
        }
        else if overlay is MKPolyline{
            let rendrer = MKPolylineRenderer(overlay: overlay)
                            //rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
                            rendrer.strokeColor = UIColor.blue
                            rendrer.lineWidth = 10
                            return rendrer
        }
        else if overlay is MKPolygon{
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.orange
            rendrer.lineWidth = 2
            return rendrer
        }
     return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place, let title = annotation.title  else {
            return
        }
        let alertcontroller = UIAlertController(title: "welcome to \(title)", message: "have a good time in \(title)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertcontroller.addAction(cancelAction)
        present(alertcontroller, animated: true, completion:  nil)
    }
}
