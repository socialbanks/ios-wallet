//
//  AddSocialBankVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/17/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit
import Parse

class AddSocialBankVC: BaseTableVC, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var items:Array<SocialBank> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    //MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let socialBank:SocialBank = self.items[indexPath.row]
        
        var cell:SocialBankCell;
        cell = self.tableView.dequeueReusableCellWithIdentifier("SOCIAL_BANK_CELL") as! SocialBankCell
        cell.tag = indexPath.row + 1000
        cell.loadFromSocialBank(socialBank)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*let relation:PFRelation = PFUser.currentUser()!.relationForKey("wallet");
        let newWallet:Wallet = PFObject(className: "Wallet") as! Wallet
        newWallet
        
        [relation addObject:post];
        [user saveInBackground];
        */
    }

    //MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        APIManager.sharedInstance.getSocialBanksWithName(searchBar.text, completion: { (results) -> Void in
            self.items = []
            for socialBank in results {
                self.items.append(socialBank)
            }
            self.tableView.reloadData()
        })
        
    }
    

}

class SocialBankCell: UITableViewCell {
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    func loadFromSocialBank(obj: SocialBank) {
        bankNameLabel.text = obj.getName()
        addressLabel.text = obj.getAddress()
        photoImageView.image = obj.getImage()
        
    }
    
}
