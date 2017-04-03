//
//  main.swift
//  section9
//
//  Created by nsg on 4/3/17.
//  Copyright © 2017 nsg. All rights reserved.
//

import Foundation

let ENDPOINT = "http://e65g.herokuapp.com/"
let endpoint = URL(string: ENDPOINT)!
let sema = DispatchSemaphore(value: 0)

let userPass = "class:1234abcd1234"
let authStr = "Basic " + userPass.data(using: .utf8)!.base64EncodedString()
let customConfig = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
customConfig.httpAdditionalHeaders = [ "Authorization": authStr]
var urlSession = URLSession(configuration: customConfig)

let task = urlSession.dataTask(with: endpoint) { (data, response, err) -> Void in
    
    let httpResponse = response as! HTTPURLResponse
    let statusCode = httpResponse.statusCode
    
    print("response status code is \(statusCode)")
    
    var json : [String : Any]?
    guard let goodData = data else {
        print("didn't get good data")
        return
    }
    do {
        json = try JSONSerialization.jsonObject(with: goodData, options: .allowFragments) as? [String: Any]
        print("Got json?\n\(json)")
    } catch {
        print("got bad json")
    }

    
    sema.signal()
}
task.resume()
sema.wait()
