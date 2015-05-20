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
    //var rowsToExpand:Array<Int> = []
    
    func initRefreshControl() {
        let refreshControl:UIRefreshControl = UIRefreshControl()
        self.refreshControl = refreshControl;
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.resetRefreshControl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLeftMenuButton()
        initRefreshControl()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setDefaultTitleLogo()
        self.tableView.reloadData()
        self.fetchData()
    }
    
    //MARK: - UITableView Delegate
    func fetchData() {
        self.showLoading()
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.willRefreshData()
            APIManager.sharedInstance.getWalletsFromCurrentUser { (results) -> Void in
                self.items = results
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.didRefreshData()
                    self.refreshControl?.endRefreshing()
                    self.hideLoading();
                }
            }
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.rowHeight
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
        //self.rowsToExpand = []
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
        
        if segue.identifier == "SEND" {
            let vc:SendVC = segue.destinationViewController as! SendVC
            let index:Int = sender!.tag - 3000
            vc.wallet = items[index] as? Wallet
        }
    }
    
    
    @IBAction func optionsTest(sender: AnyObject) {
        /*(sender as! UIView).hidden = true
        self.rowsToExpand.append(sender.tag-10000)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()*/
    }
    
    //MARK: - Refreshcontrol
    @IBAction func refresh(sender: AnyObject) {
        self.fetchData()
    }
    
    func didRefreshData() {
        self.refreshControl?.endRefreshing()
        //let data = "Wallets updated"
        let data = "Pull to refresh wallets"
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        self.refreshControl?.attributedTitle = NSAttributedString(string: data, attributes: [ NSParagraphStyleAttributeName: paragraphStyle ])
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("resetRefreshControl"), userInfo: nil, repeats: false)
    }
    
    func resetRefreshControl() {
        let data = "Pull to refresh wallets"
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        self.refreshControl?.attributedTitle = NSAttributedString(string: data, attributes: [ NSParagraphStyleAttributeName: paragraphStyle ])
    }
    
    func willRefreshData() {
        //let data = "Refreshing wallets"
        let data = "Pull to refresh wallets"
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        self.refreshControl?.attributedTitle = NSAttributedString(string: data, attributes: [ NSParagraphStyleAttributeName: paragraphStyle ])
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
    
    //@IBOutlet weak var optionsButton: UIButton!

    func loadFromWallet(object:Wallet, indexPath:NSIndexPath) {
        
        self.nameLabel.text = object.getSocialBank().getName()
        
        let balance:Int = object.getBalance()
        let balanceMajor:Int = balance/100
        let balanceMinor:Int = balance % 100
        
        if balanceMinor < 10 {
            self.balanceLabel.text = balanceMajor.description + "," + "0" + balanceMinor.description
        }else{
            self.balanceLabel.text = balanceMajor.description + "," + balanceMinor.description

        }
        
        self.iconImageView.image = object.getSocialBank().getImage()
        
        payTabButton.tag = 1000 + indexPath.row
        receiveButton.tag = 2000 + indexPath.row
        sendButton.tag = 3000 + indexPath.row
        historyButton.tag = 4000 + indexPath.row
        //optionsButton.tag = 10000 + indexPath.row
        //optionsButton.hidden = false
    }

    
    
}
