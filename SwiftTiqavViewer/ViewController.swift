//
//  ViewController.swift
//  SwiftPractiveTableView
//
//  Created by himara2 on 2014/06/03.
//  Copyright (c) 2014年 himara2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate {
    
    @IBOutlet var tableView : UITableView
    let baseUrl = "http://img.tiqav.com/"
    var tiqavs: String[] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "tiqav images"
        self.reload()
    }
    
    func reload() {
        // Thanks to tiqav api! ( http://dev.tiqav.com/ )
        let URL = NSURL(string: "http://api.tiqav.com/search/random.json")
        let Req = NSURLRequest(URL: URL)
        let connection: NSURLConnection = NSURLConnection(request: Req, delegate: self, startImmediately: false)
        
        NSURLConnection.sendAsynchronousRequest(Req,
            queue: NSOperationQueue.mainQueue(),
            completionHandler: self.fetchResponse)
    }
    
    func fetchResponse(res: NSURLResponse!, data: NSData!, error: NSError!) {
        let json: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSArray
        
        tiqavs = []
        
        for img: NSDictionary! in json {
            var imgId = img.objectForKey("id") as String
            var ext = img.objectForKey("ext") as String
            
            var imageUrl = baseUrl + imgId + "." + ext
            tiqavs += imageUrl
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            })
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        return tiqavs.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 120;
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell! {
        let cell: TiqavCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as TiqavCell
        
        var imageUrl = tiqavs[indexPath.row] as String
        
        cell.tiqavUrlLabel.text = imageUrl;
        cell.tiqavImageView.image = nil;
        
        var q_global: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        var q_main: dispatch_queue_t  = dispatch_get_main_queue();
        
        dispatch_async(q_global, {
            var imageURL: NSURL = NSURL.URLWithString(imageUrl)
            var imageData: NSData = NSData(contentsOfURL: imageURL)
            
            var image: UIImage = UIImage(data: imageData)
            
            dispatch_async(q_main, {
                cell.tiqavImageView.image = image;
                cell.layoutSubviews()
                })
            })
        return cell;
    }
    
    func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        var text: String = tiqavs[indexPath.row]
        
        // show alert
        let alertView: UIAlertView = UIAlertView()
        alertView.title = "taped"
        alertView.message = text
        alertView.addButtonWithTitle("close")
        alertView.show()
    }
    
    @IBAction func reloadBtnTouched(sender : AnyObject) {
        self.reload()
        self.tableView.scrollRectToVisible(CGRect(x:0 , y: 0, width: 1,height:1), animated: true)
    }
}