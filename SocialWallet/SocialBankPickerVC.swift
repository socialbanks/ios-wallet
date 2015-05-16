//
//  BankPickerVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class SocialBankPickerVC: BaseTableVC {
    
    var items:Array<SocialBank> = []
    var rowsToExpand:Array<Int> = []
    
    func generateFakeData() {
        items = [];
        
        items.append(SocialBank(dictionary: [
            "name": "Palmas"
            ,"balance": 123.12
            ,"isBitcoin": false
            ])!)
        items.append(SocialBank(dictionary: [
            "name": "Bens"
            ,"balance": 1.95
            ,"isBitcoin": false
            ])!)
        /*items!.append(SocialBank(dictionary: [
            "name": "Bitcoin"
            ,"balance": 0.00012
            ,"isBitcoin": true
            ])!)
        */
        self.tableView.reloadData()
    }
    
    func fetchData() {
        APIManager.sharedInstance.getBalances { (results, error) -> Void in
            let result:NSArray = results!["result"] as! NSArray
            self.items = []
            for dict in result {
                self.items.append(SocialBank(dictionary: dict as! NSDictionary)!)
            }
            self.tableView.reloadData()
            println("end")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        self.setupLeftMenuButton()
        self.rowsToExpand = [];
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setDefaultTitleLogo()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if contains(self.rowsToExpand, indexPath.row) {
            return self.tableView.rowHeight + 96
        }else{
            return self.tableView.rowHeight
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let socialBank = self.items[indexPath.row] as SocialBank
        var cell:UITableViewCell;
        
        if(socialBank.isBitcoin!) {
            cell = self.tableView.dequeueReusableCellWithIdentifier("BitcoinCell") as! BitcoinCell
            (cell as! BitcoinCell).loadFromSocialBank(socialBank)
        }else{
            cell = self.tableView.dequeueReusableCellWithIdentifier("SocialBankCell") as! SocialBankCell
            (cell as! SocialBankCell).loadFromSocialBank(socialBank, indexPath: indexPath)
        }
        
        return cell
        
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.rowsToExpand = []
        if segue.identifier == "SocialBankSelected" {
            let selectedIndex:Int = self.tableView.indexPathForSelectedRow()!.row;
            /*
            if selectedIndex == self.items!.count - 1 {
                return; // can't select the "bitcoin" row
            }
            */
            let selectedSocialBank:SocialBank = items[selectedIndex]
            (segue.destinationViewController as! SocialBankDetailsVC).socialBank = selectedSocialBank;
        }
    }
    
    
    @IBAction func optionsTest(sender: AnyObject) {
        (sender as! UIView).hidden = true
        self.rowsToExpand.append(sender.tag-10000)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    

}

class SocialBankCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var payTabButton: UIButton!
    
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var optionsButton: UIButton!

    func loadFromSocialBank(object:SocialBank, indexPath:NSIndexPath) {
        self.nameLabel.text = object.name
        self.balanceLabel.text = object.balance.description
        
        payTabButton.tag = 1000 + indexPath.row
        receiveButton.tag = 2000 + indexPath.row
        sendButton.tag = 3000 + indexPath.row
        historyButton.tag = 4000 + indexPath.row
        optionsButton.tag = 10000 + indexPath.row
        optionsButton.hidden = false
    }

    
    
}

class BitcoinCell: UITableViewCell {
    
    @IBOutlet weak var convertedBalanceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    func loadFromSocialBank(object:SocialBank) {
        self.convertedBalanceLabel.text = "2.50 BRL"
        self.balanceLabel.text = object.balance.description + " BTC"
    }
}