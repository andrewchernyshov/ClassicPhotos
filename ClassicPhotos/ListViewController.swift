//
//  ListViewController.swift
//  ClassicPhotos
//
//  Created by Richard Turton on 03/07/2014.
//  Copyright (c) 2014 raywenderlich. All rights reserved.
//

import UIKit
import CoreImage

let dataSourceURL = NSURL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")

class ListViewController: UITableViewController {
  
  var photos = [PhotoRecord]()
    let pendingOperations = PendingOperations()
    
    //private methods
    
    func fetchPhotoDetails() {
        
        let request = NSURLRequest(URL: dataSourceURL!)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            
            if data != nil {
                
                let datasourceDictionary = NSPropertyListSerialization.propertyListWithData(data!, options: Int(NSPropertyListMutabilityOptions.Immutable.rawValue), format: nil) as! Dictionary
                
            }
            
        }
        
        
    }
    
    
    //ViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Classic Photos"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // #pragma mark - Table view data source
  
  override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
    return photos.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) 
    let rowKey = photos.allKeys[indexPath.row] as! String
    
    var image : UIImage?
    if let imageURL = NSURL(string:photos[rowKey] as! String),
    imageData = NSData(contentsOfURL:imageURL){
      //1
      let unfilteredImage = UIImage(data:imageData)
      //2
      image = self.applySepiaFilter(unfilteredImage!)
    }
    
    // Configure the cell...
    cell.textLabel?.text = rowKey
    if image != nil {
      cell.imageView?.image = image!
    }
    
    return cell
  }
  
  
  func applySepiaFilter(image:UIImage) -> UIImage? {
    let inputImage = CIImage(data:UIImagePNGRepresentation(image)!)
    let context = CIContext(options:nil)
    let filter = CIFilter(name:"CISepiaTone")
    filter!.setValue(inputImage, forKey: kCIInputImageKey)
    filter!.setValue(0.8, forKey: "inputIntensity")
    if let outputImage = filter!.outputImage {
      let outImage = context.createCGImage(outputImage, fromRect: outputImage.extent)
      return UIImage(CGImage: outImage)
    }
    return nil
    
  }
  
}
