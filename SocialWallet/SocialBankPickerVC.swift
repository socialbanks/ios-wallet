//
//  BankPickerVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class SocialBankPickerVC: UITableViewController {
    
    var items:Array<SocialBank>?
    
    func generateFakeData() {
        items = [];
        
        items!.append(SocialBank(dictionary: [
            "name": "Palmas"
            ,"balance": 123.12
            ,"isBitcoin": false
            ])!)
        items!.append(SocialBank(dictionary: [
            "name": "Bens"
            ,"balance": 1.95
            ,"isBitcoin": false
            ])!)
        items!.append(SocialBank(dictionary: [
            "name": "Bitcoin"
            ,"balance": 0.00012
            ,"isBitcoin": true
            ])!)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateFakeData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items != nil {
            return self.items!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.items == nil {
            return self.tableView.dequeueReusableCellWithIdentifier("BlankCell") as! UITableViewCell
        }
        
        let socialBank = self.items![indexPath.row] as SocialBank
        var cell:UITableViewCell;
        
        if(socialBank.isBitcoin!) {
            cell = self.tableView.dequeueReusableCellWithIdentifier("BitcoinCell") as! BitcoinCell
            (cell as! BitcoinCell).loadFromSocialBank(socialBank)
        }else{
            cell = self.tableView.dequeueReusableCellWithIdentifier("SocialBankCell") as! SocialBankCell
            (cell as! SocialBankCell).loadFromSocialBank(socialBank)
        }
        
        return cell
        
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SocialBankSelected" {
            let selectedIndex:Int = self.tableView.indexPathForSelectedRow()!.row;
            if selectedIndex == self.items!.count - 1 {
                return; // can't select the "bitcoin" row
            }
            let selectedSocialBank:SocialBank = items![selectedIndex]
            (segue.destinationViewController as! SocialBankDetailsVC).socialBank = selectedSocialBank;
        }
    }
    

}

class SocialBankCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    func loadFromSocialBank(object:SocialBank) {
        self.nameLabel.text = object.name
        self.balanceLabel.text = object.balance.description
    }
    /*
    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var saldoLabel: UILabel!
    @IBOutlet weak var vencimentoLabel: UILabel!
        
    
        func loadFromPFObject(object:PFObject) {
            
            self.empresaLabel.text = object["empresa"].description
            
            if let vencimento = object["vencimento"] as? NSDate {
                self.vencimentoLabel.text = "Vencimento " + dateToString(vencimento)
            }
            
            if let valor = object["valor"] as? Float {
                self.valorLabel.text = "Valor " + moneyString(valor) + " MM"
            }
            
            if let saldo = object["saldo"] as? Float {
                self.saldoLabel.text = "Saldo " + moneyString(saldo) + " MM"
            }
            
            
            
        }
        
        func updateBackground(number:Int) {
            if number % 2 == 0 {
                self.contentView.backgroundColor = UIColor(rgb: 0xF9F9F9)
            } else {
                self.contentView.backgroundColor = UIColor.whiteColor()
            }
        }
    */
}

class BitcoinCell: UITableViewCell {
    
    @IBOutlet weak var convertedBalanceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    func loadFromSocialBank(object:SocialBank) {
        self.convertedBalanceLabel.text = "2.50 BRL"
        self.balanceLabel.text = object.balance.description + " BTC"
    }
}