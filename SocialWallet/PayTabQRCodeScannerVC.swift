//
//  PayTabQRCodeScannerVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import AVFoundation

class PayTabQRCodeScannerVC: BaseQRCodeReaderVC, UIAlertViewDelegate {

    var wallet:Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.removeLeftBarButtonTitle()
        // Do any additional setup after loading the view.
    }
    
    override func scanWasSucessful(metadataObj: AVMetadataMachineReadableCodeObject) {
        
        captureSession?.stopRunning()
        
        let data:NSData? = (metadataObj.stringValue).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        var jsonError:NSError?
        if(data != nil) {
            let json:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
            if(jsonError == nil) {
                let btAddress:String? = json!["bitcoin"] as? String
                let rDescription:String? = json!["receiverDescription"] as? String
                
                if(btAddress != nil && rDescription != nil) {   // everything is fine!
                    let vc:PayTabVC = self.instantiateViewControlerFromStoryboard("PAY_TAB", sbId: "Main") as! PayTabVC
                    
                    vc.transaction.setValue(rDescription, forKey: "receiverDescription")
                    vc.wallet = self.wallet!
                    
                    vc.bitcoinAddress = btAddress
                    vc.receiverDescription = rDescription
                    
                    self.navigationController?.showViewController(vc, sender: nil)
                    
                    return
                }
            }
            
        }
        let alert = UIAlertView(title: "Error"
            , message: "Invalid QR-code."
            , delegate: self
            , cancelButtonTitle: "Ok")
        alert.show()
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        captureSession?.startRunning()
    }

    // MARK: - Navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    (segue.destinationViewController as! PayVC).addressTextField.text = messageLabel.text
    }
    */

}
