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
        self.pluginResult?.setKeepCallbackAs(true)
        self.resultArray = [String]()
        self.setNotifications()
        
        print(">>> Test Started \(command.arguments[0])")
        
        if let testID = command.arguments[0] as? String {
            print("\n>>> Test Started <<<\n")
            NetworkTest().performTests(customerID: testID) { success in
                if success {
                    print("\n>>> Test done <<<\n")
                    if let jsonData = try? JSONSerialization.data( withJSONObject: self.resultArray!, options: .prettyPrinted),
                       let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                        self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                        self.commandDelegate!.send(self.pluginResult, callbackId: self.pluginCommand.callbackId)
                    }
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
    
    func cordovaCallback(message: String, testType: TestType){
        if message != "" {
            self.resultArray?.append(message)
            if self.resultArray?.count == 3 {
                if let jsonData = try? JSONSerialization.data( withJSONObject: self.resultArray!, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    self.pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(self.pluginResult, callbackId: self.pluginCommand.callbackId)
                }
            }
        } else {
            self.pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: SDK results for \(testType.rawValue) test was an empty string")
            self.commandDelegate!.send(pluginResult, callbackId: self.pluginCommand.callbackId)
            return
        }
        
    }
    
    //Streambow Notification Methods
    @objc func dwNotification(notification: Notification) {
        print(">>> dwNotification start")
        guard let message = notification.userInfo!["dwResult"] else { return }
        print(">>> dwNotification Message: \(message)")
        //NSLog(">>> dwNotification Message: \(message)")
        if let jsonData = try? JSONSerialization.data( withJSONObject: message, options: .prettyPrinted),
           let json = String(data: jsonData, encoding: String.Encoding.ascii) {
            self.cordovaCallback(message: json, testType: .download)
        }
    }
    
    @objc func upNotification(notification: Notification) {
        print(">>> nupNotification start")
        guard let message = notification.userInfo!["upResult"] else { return }
        print(">>> nupNotification Message: \(message)")
        //NSLog(">>> nupNotification Message: \(message)")
        if let jsonData = try? JSONSerialization.data( withJSONObject: message, options: .prettyPrinted),
           let json = String(data: jsonData, encoding: String.Encoding.ascii) {
            self.cordovaCallback(message: json, testType: .upload)
        }
    }
    
    @objc func pingNotification(notification: Notification) {
        print(">>> pingNotification start")
        guard let message = notification.userInfo!["pingResult"] else { return }
        print(">>> pingNotification Message: \(message)")
        //NSLog(">>> pingNotification Message: \(message)")
        if let jsonData = try? JSONSerialization.data( withJSONObject: message, options: .prettyPrinted),
           let json = String(data: jsonData, encoding: String.Encoding.ascii) {
            self.cordovaCallback(message: json, testType: .ping)
        }
    }
    
}

enum TestType: String {
    case download = "download"
    case upload = "upload"
    case ping = "ping"
}

