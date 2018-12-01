//
//  GlobalExtension.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/23/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation

extension Global {
    
    
    func globalGETMethod(url:String, getCompletionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil  else {
                getCompletionHandler(nil, error! as NSError)
                return
            }
            getCompletionHandler(data, nil)
        }
        task.resume()
        return task
    }
    
    func searchFlickrPhotos(latitude: Double, longitude: Double, completionHandler: @escaping (_ data: ParsedPhotos?, _ errorString: String?) -> Void) {
        
        let url = Constants.Flickr.photoSearchUrl + "method=" + "\(Constants.Flickr.method)" + "&api_key=" + "\(Constants.Flickr.APIKey)" + "&format=" + "\(Constants.Flickr.format)" + "&safe_search=" + "\(Constants.Flickr.safe_search)" + "&page=" + "\(Constants.Flickr.page)" + "&per_page=" + "\(Constants.Flickr.photosPerPage)" + "&nojsoncallback=" + "\(Constants.Flickr.jsoncallback)" + "&extras=" + "\(Constants.Flickr.extras)" + "&bbox=" + "\(getBoundingBox(latitude: latitude, longitude: longitude))"
        
        _ = globalGETMethod(url: url, getCompletionHandler: {(data, error) in
            guard (error == nil) else {
                completionHandler(nil, error!.localizedDescription)
                return
            }
            DispatchQueue.main.sync {
                do {
                    let jsonDecoder = JSONDecoder()
                    let parsedDataJSON = try jsonDecoder.decode( ParsedPhotos.self, from: data!)
                    guard (parsedDataJSON.photos.pages != 0) else {
                        completionHandler(nil, "No photos found at this location")
                        return
                    }
                    completionHandler(parsedDataJSON, nil)
                } catch {
                    completionHandler(nil, "A problem occured while searching for photos")
                }
            }
        })
    }
    
    func imageDownload(imageUrl: String, completionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) {
        _ = globalGETMethod(url: imageUrl, getCompletionHandler: {(data, error) in
            guard (error == nil) else {
                completionHandler(nil, error!)
                return
            }
            DispatchQueue.main.sync {
                    completionHandler(data, nil)
            }
        })
    }
    
    func getBoundingBox(latitude: Double, longitude: Double)->String {
        let minLon = max(longitude - 0.2, (-180.0, 180.0).0)
        let minLat = max(latitude  - 0.2, (-90.0, 90.0).0)
        let maxLon = min(longitude + 0.2, (-180.0, 180.0).1)
        let maxLat = min(latitude  + 0.2, (-90.0, 90.0).1)
        return "\(minLon),\(minLat),\(maxLon),\(maxLat)"
    }
    
}
