//
//  ViewController.swift
//  WeatherSwiftyJSON
//
//  Created by Ebony Nyenya on 8/6/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    var session = NSURLSession.sharedSession()
    
    var kelvins : Float?
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var enterCityFld: UITextField!
    
    
    @IBOutlet weak var cityLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadData(cityName: String){
        
        if let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q="+cityName){
        
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            //display error message in event of an error
            if error != nil {
                
                var alert = UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "Ok")
                
                alert.show()
                
            }
                
            else {
                
                var error : NSError?
                
                //json dictionary
                let json = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: &error) as! [String: AnyObject]
                
                let main = json["main"] as! [String:AnyObject]
                
                let temp = main["temp"] as! Float
                
                let weather = json["weather"] as! [[String:AnyObject]]
                
                var weatherDescription = weather[0]["description"] as! String
                
                self.kelvins = temp
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.weatherLabel.text = temp.description + " K " + weatherDescription
                    
                })
                
                
                //Bonus #1 - parsing json data using SwiftyJSON
                //        let json = JSON(data: data)
                
                //        let temp = json["main"]["temp"].float
                
                //         self.kelvins = temp
                
                
                //        dispatch_async(dispatch_get_main_queue(), {
                //
                //             self.weatherLabel.text = temp!.description + " K"
                //
                //        })
                
            }
            
        })
        
        
        task.resume()
            
        }
        
    }
    
    //Bonus #2 - converting default Kelvin to F or C
    @IBAction func cOrF(sender: UISegmentedControl) {
        
        //change from Kelvin to F
        if sender.selectedSegmentIndex == 0 {
            var farenheit = 1.8 * (kelvins! - 273) + 32
            
            self.weatherLabel.text = farenheit.description + " F"
            println("Did change to F")
            
        }
            //change from Kelvin to C
        else {
            var celsius = kelvins! - 273
            
            self.weatherLabel.text = celsius.description + " C"
            
        }
        
    }
    
    //Bonus #3 - choosing a city instead of using NYC as a default
    @IBAction func gimmeWeather(sender: AnyObject) {
        
        loadData(enterCityFld.text)
        
        cityLbl.text = enterCityFld.text
        
        enterCityFld.text = ""

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

