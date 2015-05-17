//
//  HistoryVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/16/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class HistoryVC: BaseTableVC {

    var wallet:Wallet?
    
    var items:Array<Transaction> = []
    
    func fetchData() {
        /*APIManager.sharedInstance.getBalances { (results, error) -> Void in
        let result:NSArray = results!["result"] as! NSArray
        self.items = []
        for dict in result {
        self.items.append(SocialBank(dictionary: dict as! NSDictionary)!)
        }
        self.tableView.reloadData()
        println("end")
        }*/
        items = []
        APIManager.sharedInstance.getTransactionsFromWallet(wallet!, completion: { (results) -> Void in
            var i = 0
            for transaction in results {
                i = i+1
                println(i)

                if(transaction.getSenderWallet() != nil && self.wallet!.isEqual(transaction.getSenderWallet()!)) {
                    transaction.isSender = true
                }
                if(transaction.getReceiverWallet() != nil && self.wallet!.isEqual(transaction.getReceiverWallet()!)) {
                    transaction.isSender = false
                }
                
                self.items.append(transaction)
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    //MARK: - UITableView Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TransactionCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionCell") as! TransactionCell
        
        //cell.loadFromTransaction(transaction)
        let transaction = self.items[indexPath.row]
        cell.loadFromTransaction(transaction)
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }

}


class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func loadFromTransaction(object:Transaction) {
        dateLabel.text = object.createdAt!.description
        timeLabel.text = ""
        
        if(object.isSender) {
            operationLabel.text = "-"
            descriptionLabel.text = object.getSenderDescription()
        }else{
            operationLabel.text = "+"
            descriptionLabel.text = object.getReceiverDescription()
        }
        
        let major:Int = object.getValue()/100
        let minor:Int = object.getValue() % 100
        
        amountLabel.text = major.description + "," + minor.description
        
        
        /*self.dateLabel.text = object.date
        self.descriptionLabel.text = object.descriptionText
        
        if(object.amount > 0) {
            self.amountLabel.text = "+ " + object.amount.description
            self.amountLabel.textColor = UIColor.greenColor()
        }else{
            self.amountLabel.text = "- " + fabsf(object.amount).description
            self.amountLabel.textColor = UIColor.redColor()
        }*/
    }
}