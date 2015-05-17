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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generateAction(sender: AnyObject) {
        let address = wallet!.getBitcoinAddress()
        let stringData:String = address + "\n" + descriptionField.text!
        let data:NSData = stringData.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let qrFilter:CIFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")
        
        self.qrCodeImageView.image = nil
        self.qrCodeImageView.image = UIImage(CIImage: qrFilter.outputImage)
        self.qrCodeImageView.setNeedsDisplay()
    }

    // MARK: UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
