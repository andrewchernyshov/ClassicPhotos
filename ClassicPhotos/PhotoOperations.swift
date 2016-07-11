//
//  PhotoOperations.swift
//  ClassicPhotos
//
//  Created by Andrew Chernyhov on 11.07.16.
//  Copyright © 2016 raywenderlich. All rights reserved.
//

import UIKit

enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}

class PhotoRecord {
    let name:String
    let url:NSURL
    var state = PhotoRecordState.New
    var image = UIImage(named:"Placeholder")
    
    init(name:String, url:NSURL) {
        self.name = name
        self.url = url
    }
    
}


class PendingOperations {
    
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress = [NSIndexPath:NSOperation]()
    lazy var filtrationQueue:NSOperationQueue = {
        
        var queue = NSOperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    
}


class ImageDownloader: NSOperation {
    
    let photoRecord:PhotoRecord
    
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL: self.photoRecord.url)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.photoRecord.image = UIImage(data: imageData!)
            self.photoRecord.state = .Downloaded
        } else {
            self.photoRecord.state = .Failed
            self.photoRecord.image = UIImage(named: "Failed")
        }
        
    }
}






































