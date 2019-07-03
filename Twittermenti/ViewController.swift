//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let swifter = Swifter(consumerKey: "NuSY3LhZ9N3grMdMR9J0nJnWS", consumerSecret: "uzWi6uyTrIu2gzkzgKgLgilm7iukuaxzW4NGvCN9XSY1a2r6eo")

    let tweetNum = 100
    
    let sentimentClassifier = SentimentClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        if let searchText = textField.text{
            swifter.searchTweet(using: searchText , lang: "en", count: tweetNum, tweetMode: .extended, success: { (results, metadata) in
                
                var tweets = [SentimentClassifierInput]()
                for i in 0..<self.tweetNum{
                    if let tweet = results[i]["full_text"].string{
                        let input = SentimentClassifierInput(text: tweet)
                        tweets.append(input)
                    }
                }
                let score = self.predictionScore(with: tweets)
                
                self.updateUI(score: score)
                
            }) { (error) in
                print("some error in searching tweets \(error)")
            }
        }
    
    }
    
    func predictionScore(with tweets : [SentimentClassifierInput]) -> Int{
        var score = 0
        do{
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            
            for prediction in predictions{
                if prediction.label == "Pos"{
                    score += 1
                }
                else if prediction.label == "Neg"{
                    score -= 1
                }
            }           
        }catch{
            print("error predicting \(error)")
        }
        return score
    }
    
    func updateUI(score : Int){
        if score > 20{
            sentimentLabel.text = "😍"
        }else if score > 10{
            sentimentLabel.text = "😃"
        }else if score > 5{
            sentimentLabel.text = "🙂"
        }else if score > -5{
            sentimentLabel.text = "😐"
        }else if score > -10{
            sentimentLabel.text = "😣"
        }else {
            sentimentLabel.text = "🤮"
        }
    }
}


