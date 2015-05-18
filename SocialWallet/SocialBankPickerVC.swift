//
//  BankPickerVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class SocialBankPickerVC: BaseTableVC {
    
    var items:Array<PFObject> = []
    var rowsToExpand:Array<Int> = []
    
    func fetchData() {
        APIManager.sharedInstance.getWalletsFromCurrentUser { (results) -> Void in
            self.items = results
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        self.setupLeftMenuButton()
        self.rowsToExpand = [];
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setDefaultTitleLogo()
        self.tableView.reloadData()
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
        
        let wallet:Wallet = self.items[indexPath.row] as! Wallet
        
        var cell:WalletCell;
        
        cell = self.tableView.dequeueReusableCellWithIdentifier("WALLET_CELL") as! WalletCell
        cell.loadFromWallet(wallet, indexPath: indexPath)
        
        return cell
        
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.rowsToExpand = []
        if segue.identifier == "RECEIVE" {
            let vc:ReceiveVC = segue.destinationViewController as! ReceiveVC
            let index:Int = sender!.tag - 2000
            vc.wallet = items[index] as? Wallet
        }
        
        if segue.identifier == "HISTORY" {
            let vc:HistoryVC = segue.destinationViewController as! HistoryVC
            let index:Int = sender!.tag - 4000
            vc.wallet = items[index] as? Wallet
        }
        
        if segue.identifier == "PAY_TAB" {
            let vc:PayTabQRCodeScannerVC = segue.destinationViewController as! PayTabQRCodeScannerVC
            let index:Int = sender!.tag - 1000
            vc.wallet = items[index] as? Wallet
        }
    }
    
    
    @IBAction func optionsTest(sender: AnyObject) {
        (sender as! UIView).hidden = true
        self.rowsToExpand.append(sender.tag-10000)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    

}

class WalletCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var payTabButton: UIButton!
    
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var optionsButton: UIButton!

    func loadFromWallet(object:Wallet, indexPath:NSIndexPath) {
        
        self.nameLabel.text = object.getSocialBank().getName()
        
        let balance:Int = object.getBalance()
        let balanceMajor:Int = balance/100
        let balanceMinor:Int = balance % 100
        
        self.balanceLabel.text = balanceMajor.description + "," + balanceMinor.description
        
        payTabButton.tag = 1000 + indexPath.row
        receiveButton.tag = 2000 + indexPath.row
        sendButton.tag = 3000 + indexPath.row
        historyButton.tag = 4000 + indexPath.row
        optionsButton.tag = 10000 + indexPath.row
        optionsButton.hidden = false
    }

    
    
}
