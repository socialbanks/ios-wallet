//
//  SocialBankDetailsVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class SocialBankDetailsVC: UITableViewController {
    
    var socialBank:SocialBank?
    var items:Array<Transaction>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items != nil {
            return 2 + self.items!.count
        } else {
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:SocialBankCell = self.tableView.dequeueReusableCellWithIdentifier("SocialBankCell") as! SocialBankCell
            cell.loadFromSocialBank(self.socialBank!)
            return cell
        }
        
        if indexPath.row == 1 {
            return self.tableView.dequeueReusableCellWithIdentifier("ReceivePayCell") as! UITableViewCell
        }
        
        if self.items == nil {
            return self.tableView.dequeueReusableCellWithIdentifier("BlankCell") as! UITableViewCell
        }
        
        let transaction = self.items![indexPath.row] as Transaction
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("BlankCell") as! UITableViewCell
        // NOT LOADING TRANSACTION CELLS!
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 96
        } else if indexPath.row == 1 {
            return 64
        } else {
            return self.tableView.rowHeight
        }
    }


}
