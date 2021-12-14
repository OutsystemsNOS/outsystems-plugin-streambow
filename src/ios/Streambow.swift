//
//  Streambow.swift
//  Streambow SDK
//
//  Created by Andre Grillo on 02/12/2021.
//

import Foundation
import FeedbackFramework
import CoreLocation

@objc(Streambow)
class Streambow: CDVPlugin, CLLocationManagerDelegate {
    var pluginResult = CDVPluginResult()
    var pluginCommand = CDVInvokedUrlCommand()
    let locationManager = CLLocationManager()
    var userCoordinates: CLLocationCoordinate2D?
    var resultArray: [String]?
    
    @objc(initializer:)
    func initializer(command: CDVInvokedUrlCommand){
        print(">>> Initializing Plugin")
        if let getUserLocation = command.arguments[0] as? Bool {
            if getUserLocation{
                setupCoreLocation()
            }
        } else {
            print("Error: Missing input parameters")
        }
        self.pluginCommand = command
        self.pluginResult = nil
        self.pluginResult?.keepCallback = true
        self.resultArray = [String]()
        self.setNotifications()
    }
    
    @objc
    func SDKsetup(){
        Main().initializer()
    }
    
    func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.dwNotification(notification:)), name: Notification.Name(rawValue: "DwDiagnosticNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.upNotification(notification:)), name: Notification.Name(rawValue: "UpDiagnosticNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pingNotification(notification:)), name: Notification.Name(rawValue: "PingDiagnosticNotification"), object: nil)
    }
    
    @objc (performTest:)
    func performTest(_ command: CDVInvokedUrlCommand){
        print(">>> Test Started")
        self.pluginResult?.setKeepCallbackAs(true)
        let _ = NetworkTest().performTests()
        { success in
            if success == true {
                    print(">>> Registration Done")
            } else {
                print(">>> Not registered")
            }
        }
    }
    
    @objc(performFeedbackDiagnostic:)
    func performFeedbackDiagnostic(command: CDVInvokedUrlCommand){
        self.pluginResult?.setKeepCallbackAs(true)
        if let inOutStatus = command.arguments[0] as? Int, let feedbackType = command.arguments[1] as? Int {
            self.setupCoreLocation()
            if let userLocation = self.userCoordinates {
                let _ = Feedback().performFeedbackDiagnostic(latitude: String(userLocation.latitude), longitude: String(userLocation.longitude), inOutStatus: inOutStatus, feedbackType: feedbackType)
                { success in
                    if success == true {
                            print("Done")
                    }else{
                        print("Not registered")
                    }
                }
            } else {
                print("Could not get user location")
            }
        } else {
            print("Missing input parameters")
        }
    }
    
    //Core Location Setup
    func setupCoreLocation() {
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location Services are not enabled")
        }
    }
    func cordovaCallback(message: String){
        self.resultArray?.append(message)
        if self.resultArray?.count == 3 {
            if let jsonData = try? JSONSerialization.data( withJSONObject: self.resultArray!, options: .prettyPrinted),
               let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                self.commandDelegate!.send(self.pluginResult, callbackId: self.pluginCommand.callbackId)
            }
        }
    }
    
    //Core Location Delegate Methods
    @objc
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        self.userCoordinates = location
        print(">>> locations = \(location.latitude) \(location.longitude)")
    }
    @objc
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }

    //Streambow Notification Methods
    @objc func dwNotification(notification: Notification) {
        guard let message = notification.userInfo!["dwResult"] else { return }
        print(">>> dwNotification Message: \(message)")
        if let jsonData = try? JSONSerialization.data( withJSONObject: message, options: .prettyPrinted),
           let json = String(data: jsonData, encoding: String.Encoding.ascii) {
            self.cordovaCallback(message: json)
        }
    }
    
    @objc func upNotification(notification: Notification) {
        guard let message = notification.userInfo!["upResult"] else { return }
        print(">>> nupNotification Message: \(message)")
        if let jsonData = try? JSONSerialization.data( withJSONObject: message, options: .prettyPrinted),
           let json = String(data: jsonData, encoding: String.Encoding.ascii) {
            self.cordovaCallback(message: json)
        }
    }
    
    @objc func pingNotification(notification: Notification) {
        guard let message = notification.userInfo!["pingResult"] else { return }
        print(">>> pingNotification Message: \(message)")
        if let jsonData = try? JSONSerialization.data( withJSONObject: message, options: .prettyPrinted),
           let json = String(data: jsonData, encoding: String.Encoding.ascii) {
            self.cordovaCallback(message: json)
        }
    }
    
}

