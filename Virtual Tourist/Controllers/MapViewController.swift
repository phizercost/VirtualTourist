//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/22/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var footer: UIView!
    
    let pin = MKPointAnnotation()
    var pins = [Pin]()
    
    //var currentPin: Pin!
    
    
    
    
    
    var dbURL = URL(string: "")
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        footer.isHidden = true
        fetchPins()
        addPinGesture()
        
    }
    
    fileprivate func addPinGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
    }
    
    fileprivate func fetchPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            let fetchedPins = try PersistenceService.context.fetch(fetchRequest)
            self.pins = fetchedPins
            addAnnotatedPins(self.pins)
        } catch {}
    }
    
    @objc func addAnnotation(press: UILongPressGestureRecognizer){
        let location = press.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        if press.state == .began {
            pin.coordinate = coordinates
            mapView.addAnnotation(pin)
        } else if press.state == .changed {
            pin.coordinate = coordinates
        } else if press.state == .ended {
            let pinToPersist = Pin(context: PersistenceService.context)
            pinToPersist.longitude = pin.coordinate.longitude
            pinToPersist.latitude = pin.coordinate.latitude
            PersistenceService.saveContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MapCollectionViewController {
            guard let pin = sender as? Pin else {
                return
            }
            let controller = segue.destination as! MapCollectionViewController
            controller.pin = pin
            Global.shared.pin  = pin
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        footer.isHidden = !editing
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }
        
        mapView.deselectAnnotation(annotation, animated: true)
        let lat = String(annotation.coordinate.latitude)
        let lon = String(annotation.coordinate.longitude)
        if let pin = PersistenceService.loadPin(latitude: lat, longitude: lon) {
            if isEditing {
                mapView.removeAnnotation(annotation)
                PersistenceService.context.delete(pin)
                PersistenceService.saveContext()
                return
            }
            performSegue(withIdentifier: "showPinPhotos", sender: pin)
        }
    }
    func addAnnotatedPins(_ pins: [Pin]) {
        for pin in pins where pin.latitude != 0.0 && pin.longitude != 0.0 {
            let annotation = MKPointAnnotation()
            let lat = Double(pin.latitude)
            let lon = Double(pin.longitude)
            annotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
}
