//
//  SocialBankDetailsVC.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class SocialBankDetailsVC: BaseTableVC, UITableViewDelegate {
    
    var socialBank:SocialBank?
    var items:Array<Transaction>?
    
    var topX:CGFloat!
    var topY:CGFloat!
    var maxWidth:CGFloat!
    
    @IBOutlet weak var socialBankView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    func generateFakeData() {
        items = [];
        
        let dict:Dictionary = [
            "date": "01/01/2001"
            ,"description": "This is a test"
            ,"amount": 123.12
        ]
        
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        items!.append(Transaction(dictionary: dict)!)
        
        /*items!.append(SocialBank(dictionary: [
        "name": "Bitcoin"
        ,"balance": 0.00012
        ,"isBitcoin": true
        ])!)
        */
        self.tableView.reloadData()
    }
    
    func initSocialBankHeader() {
        let frameView:CGRect = self.view.frame;
        topX = frameView.origin.x
        topY = frameView.origin.y
        maxWidth = frameView.width
        self.socialBankView.frame = CGRectMake(topX, topY, maxWidth, 0)
        self.socialBankView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        initSocialBankHeader()
        generateFakeData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.nameLabel.text = socialBank?.name
        self.balanceLabel.text = socialBank?.balance.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UITableView Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 144
    }
    
    //override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      //  return ""
    //}
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView(frame: CGRectMake(topX, topY, maxWidth, 144))
        self.socialBankView.frame = CGRectMake(topX, topY, maxWidth, 144)
        view.addSubview(self.socialBankView)
        return view
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items != nil {
            return self.items!.count
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.items == nil {
            return self.tableView.dequeueReusableCellWithIdentifier("BlankCell") as! UITableViewCell
        }
        
        let transaction = self.items![indexPath.row] as Transaction
        let cell:TransactionCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionCell") as! TransactionCell
        cell.loadFromTransaction(transaction)
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.rowHeight
    }
    
    /*
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //let scrollOffset:CGFloat = scrollView.contentOffset.y + self.tableView.frame.size.height - self.socialBankView.frame.size.height - 16
        //self.socialBankView.frame = CGRectMake(topX, topY+100000, maxWidth, 144)
        
        //var frame:CGRect = self.socialBankView.frame
        //frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.socialBankView.frame.size.height - 16
        //self.socialBankView.frame = frame
        //self.view.bringSubviewToFront(self.socialBankView)
    }
    */

}

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    //@IBOutlet weak var comeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func loadFromTransaction(object:Transaction) {
        self.dateLabel.text = object.date
        self.descriptionLabel.text = object.descriptionText
        
        if(object.amount > 0) {
            self.amountLabel.text = "+ " + object.amount.description
            self.amountLabel.textColor = UIColor.greenColor()
        }else{
            self.amountLabel.text = "- " + fabsf(object.amount).description
            self.amountLabel.textColor = UIColor.redColor()
        }
    }
}
