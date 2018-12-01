//
//  MapCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/22/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapCollectionViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var fetchedResultsController: NSFetchedResultsController<Picture>!
    var dataController: DataController!
    var pinAnnotation = MKPointAnnotation()
    var pin: Pin!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pin = pin else {
            print("Unable to call current Pin")
            return
        }
        placePin(pin)
        
        fetchPersistedPhotos(pin: pin)
        if Global.shared.flickrPictures.count == 0 {
            getFlickrPhotos(pin)
        }
    }
   
    
    fileprivate func placePin(_ pin: Pin) {
        pinAnnotation.coordinate.longitude = pin.longitude
        pinAnnotation.coordinate.latitude = pin.latitude
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pinAnnotation)
        mapView.setCenter(pinAnnotation.coordinate, animated: true)
    }
    
    func fetchPersistedPhotos(pin: Pin) {
        
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin == %@", argumentArray: [pin])
        do {
            let fetchedPictures = try PersistenceService.context.fetch(fetchRequest)
            Global.shared.flickrPictures = fetchedPictures
        } catch {}
    }
    func raiseAlert(title:String, notification:String) {
        let alert  = UIAlertController(title: title, message: notification, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    private func getFlickrPhotos(_ pin: Pin) {
        
        activityIndicator.startAnimating()
        Global.shared.searchFlickrPhotos(latitude: pin.latitude, longitude: pin.longitude) { (parsedPhotos, error) in
            if (parsedPhotos != nil) {
                if parsedPhotos!.photos.photo.count > 0 {
                for i in 0...parsedPhotos!.photos.photo.count-1 {
                    let pictureToPersist = Picture(context: PersistenceService.context)
                    pictureToPersist.photoUrl = parsedPhotos!.photos.photo[i].url
                    pictureToPersist.pin = pin
                    pictureToPersist.photo = nil
                    Global.shared.flickrPictures.append(pictureToPersist)
                    PersistenceService.saveContext()
                }
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                } else {
                    DispatchQueue.main.async {
                        self.raiseAlert(title: "ERROR", notification: "No photos found for this location")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.raiseAlert(title: "ERROR", notification: error!)
                }
            }
        }
    }
    
}
