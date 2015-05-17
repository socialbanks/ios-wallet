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

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.removeLeftBarButtonTitle()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scanWasSucessful(metadataObj: AVMetadataMachineReadableCodeObject) {
        
        let dataSplit:Array<String> = metadataObj.stringValue!.componentsSeparatedByString("\n")
        let bitcoinAddress:String = dataSplit[0]
        let receiverDescription:String = dataSplit[1]
        
        captureSession?.stopRunning()
        let vc:PayTabVC = self.instantiateViewControlerFromStoryboard("PAY_TAB", sbId: "Main") as! PayTabVC
        
        vc.transaction.setValue(receiverDescription, forKey: "receiverDescription")
        
        
        vc.fullnameLabel!.text = bitcoinAddress
        vc.emailLabel!.text = receiverDescription
        
        self.navigationController?.showViewController(vc, sender: nil)
        
    }

    // MARK: - Navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    (segue.destinationViewController as! PayVC).addressTextField.text = messageLabel.text
    }
    */

}
