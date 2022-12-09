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
    var resultArray: [Dictionary<String, Any>]?
    
    func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.dwNotification(notification:)), name: Notification.Name(rawValue: "DwDiagnosticNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.upNotification(notification:)), name: Notification.Name(rawValue: "UpDiagnosticNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pingNotification(notification:)), name: Notification.Name(rawValue: "PingDiagnosticNotification"), object: nil)
    }
    
    @objc (performTest:)
    func performTest(_ command: CDVInvokedUrlCommand){
        self.pluginCommand = command
        self.pluginResult = nil
        self.pluginResult?.setKeepCallbackAs(true)
        self.resultArray = [Dictionary<String, Any>]()
        self.setNotifications()
        
        if let testID = command.arguments[0] as? String {
            print("\n>>> Test Started <<<\n")
            
            NetworkTest().performTests(customerID: testID) { success in
                if success {
                    print("\n>>> Test done <<<\n")
                } else {
                    print("\n>>> Not registered <<<\n")
                }
            }
        } else {
            self.pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: missing testID input parameter")
            self.commandDelegate!.send(pluginResult, callbackId: self.pluginCommand.callbackId)
            return
        }
    }
    
    func cordovaCallback(message: Dictionary<String, Any>, testType: TestType){
        if message.count != 0 {
            self.resultArray?.append(message)
            if self.resultArray?.count == 3 {
                if let jsonData = try? JSONSerialization.data( withJSONObject: self.resultArray!, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.utf8) {
                    self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(self.pluginResult, callbackId: self.pluginCommand.callbackId)
                }
            }
        } else {
            self.pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: SDK results for \(testType.rawValue) test was an invalid Dictionary")
            self.commandDelegate!.send(pluginResult, callbackId: self.pluginCommand.callbackId)
            return
        }
        
    }
    
    //Streambow Notification Methods
    @objc func dwNotification(notification: Notification) {
        guard let message = notification.userInfo!["dwResult"] as? Dictionary<String, Any> else { return }
        self.cordovaCallback(message: message, testType: .download)
    }
    
    @objc func upNotification(notification: Notification) {
        guard let message = notification.userInfo!["upResult"] as? Dictionary<String, Any> else { return }
        self.cordovaCallback(message: message, testType: .upload)
    }
    
    @objc func pingNotification(notification: Notification) {
        guard let message = notification.userInfo!["pingResult"] as? Dictionary<String, Any> else { return }
        self.cordovaCallback(message: message, testType: .ping)
    }
    
}

enum TestType: String {
    case download = "download"
    case upload = "upload"
    case ping = "ping"
}

