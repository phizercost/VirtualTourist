//
//  MapCollectionViewControllerExtension.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/24/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

extension MapCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Global.shared.flickrPictures.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Global.shared.flickrPictures.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrPhotoViewCell.identifier, for: indexPath) as! FlickrPhotoViewCell
        cell.imageView.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let picture = Global.shared.flickrPictures[indexPath.row]
        let flickrPhotoViewCell = cell as! FlickrPhotoViewCell
        flickrPhotoViewCell.url = picture.photoUrl!
        loadImage(using: flickrPhotoViewCell, picture: picture, collectionView: collectionView, index: indexPath)
        
    }
    
    
    private func loadImage(using cell: FlickrPhotoViewCell, picture: Picture, collectionView: UICollectionView, index: IndexPath) {
        if let imageData = picture.photo {
            cell.imageView.image = UIImage(data: Data(referencing: imageData as NSData))
        } else {
        if let imageUrl = picture.photoUrl {
                Global.shared.imageDownload(imageUrl: imageUrl) { (data, error) in
                    if let _ = error {
                        return
                    } else if let data = data {
                        DispatchQueue.main.async {
                            
                            if let currentCell = collectionView.cellForItem(at: index) as? FlickrPhotoViewCell {
                                if currentCell.url == imageUrl {
                                    currentCell.imageView.image = UIImage(data: data)
                                }
                            }
                            Global.shared.flickrPictures[index.row].photo = data as NSData

                            PersistenceService.saveContext()
                        }
                    }
                }
            }
        }
    }
    
}
