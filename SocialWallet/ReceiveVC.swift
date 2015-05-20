//
//  ReceiveVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class ReceiveVC: BaseVC, UITextFieldDelegate {
    
    var wallet:Wallet?
    
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionField.delegate = self
        
        /*
        let filter2data = CIFilter(name: "CIPhotoEffectChrome")
        filter2data.setValue(CIImage(image: imageView.image), forKey: kCIInputImageKey)
        self.filter2image.image = UIImage(CIImage: filter2data.outputImage)
        */
        
        
    }
    
    @IBAction func generateAction(sender: AnyObject) {
        let address = wallet!.getBitcoinAddress()
        let stringData:String = "{\"bitcoin\":\"" + address + "\",\"receiverDescription\":\"" + descriptionField.text! + "\"}"
        let data:NSData = stringData.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let qrFilter:CIFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")
        
        self.qrCodeImageView.image = nil
        self.qrCodeImageView.image = UIImage(CIImage: qrFilter.outputImage)
        qrCodeImageView.layer.magnificationFilter = kCAFilterNearest
        self.qrCodeImageView.setNeedsDisplay()
        qrCodeImageView.layer.magnificationFilter = kCAFilterNearest
    }

    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
