//
//  PayTabQRCodeScannerVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import AVFoundation

class PayTabQRCodeScannerVC: BaseQRCodeReaderVC {

    var wallet:Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.removeLeftBarButtonTitle()
        // Do any additional setup after loading the view.
    }
    
    override func scanWasSucessful(metadataObj: AVMetadataMachineReadableCodeObject) {
        
        captureSession?.stopRunning()
        let dataSplit:Array<String> = metadataObj.stringValue!.componentsSeparatedByString("\n")
        let bitcoinAddress:String = dataSplit[0]
        let receiverDescription:String = dataSplit[1]
        
        
        let vc:PayTabVC = self.instantiateViewControlerFromStoryboard("PAY_TAB", sbId: "Main") as! PayTabVC
        
        vc.transaction.setValue(receiverDescription, forKey: "receiverDescription")
        vc.wallet = self.wallet!
        
        vc.bitcoinAddress = bitcoinAddress
        vc.receiverDescription = receiverDescription
        
        self.navigationController?.showViewController(vc, sender: nil)
        
    }

    // MARK: - Navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    (segue.destinationViewController as! PayVC).addressTextField.text = messageLabel.text
    }
    */

}
