//
//  ViewController.swift
//  AlmofireSamp
//
//  Created by 田中 慎 on 2015/04/15.
//  Copyright (c) 2015年 Tanaka Makoto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    var articles = [Article]()
    
    @IBOutlet weak var tableView: UITableView!
    let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView?.dataSource = self
        tableView?.delegate = self
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = "Coolhomme"
        
        apiRequest()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func apiRequest() {
        
        println("self: --------\(self)")
        
        let url = "http://coolhomme.jp/api"
        Alamofire.request(.GET, url, parameters: nil)
            .response { (request, response, data, error) in
                println(request)
                println(response)
                
                if let error = error{
                    println(error)
                }
        }
        
        Alamofire.request(.GET, url)
            .responseJSON { (_, response, data, error) in
                if (response?.statusCode == 200) {
                    
                    var request = NSURLRequest(URL: NSURL(string: url)!)
                    var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
                    
                    if data != nil{
                        var json = JSON(data: data!)
                        let count: Int? = json["result"].array?.count
                        
                        if let count = count {
                            for index in 0 ... count - 1 {
                                let article = Article(json: json["result"][index])
                                self.articles.append(article)
                            }
                        }
                    }
                    
                    println("self2: --------\(self)")
                    
                    println(" -------------------------")
                    println(self.articles)
                    println(self.articles.count)
                    println(" -------------------------")
                    
                } else {
                    // error
                    println(error)
                }
        }
    }
}

// MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate {
    // table選択時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println("articles[indexPath.row].linkUrl : \(articles[indexPath.row].linkUrl)")
        performSegueWithIdentifier("detail", sender: articles[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource{

    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("self3: --------\(self)")
        
        println("self.articles: \(self.articles)")
        println("articles.count ------------ \(self.articles.count)")
        return articles.count
    }
    
    // 値入れ
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        
        cell.textLabel?.text = articles[indexPath.row].title as String
        
        // imageUrlを確認
        var imageUrl:NSURL! = articles[indexPath.row].imagelUrl
        
        // 画像をセルにセット
        if let imageUrl = imageUrl {
            var imageData: NSData? = NSData(contentsOfURL: imageUrl)!
            var image : UIImage! = UIImage(data: imageData!)
            //println("The loaded image: \(image)")
            cell.imageView?.image = image
        }
        return cell
    }
}
