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
    
    func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.dwNotification(notification:)), name: Notification.Name(rawValue: "DwDiagnosticNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.upNotification(notification:)), name: Notification.Name(rawValue: "UpDiagnosticNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pingNotification(notification:)), name: Notification.Name(rawValue: "PingDiagnosticNotification"), object: nil)
    }
    
    @objc (performTest:)
    func performTest(_ command: CDVInvokedUrlCommand){
        self.pluginCommand = command
        self.pluginResult = nil
        self.pluginResult?.keepCallback = true
        self.resultArray = [String]()
        self.setNotifications()
        
        print(">>> Test Started")
        self.pluginResult?.setKeepCallbackAs(true)
        NetworkTest().performTests(customerID: "NOS12345") { success in
            if success {
                print("\n>>> Test done <<<\n")
            } else {
                print("\n>>> Not registered <<<\n")
            }
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