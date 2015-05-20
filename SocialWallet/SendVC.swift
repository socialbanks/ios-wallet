//
//  SendVC.swift
//  SocialWallet
//
//  Created by Mauricio de Oliveira on 5/17/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import Foundation
import Parse

class SendVC : BaseTableVC, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items:Array<PFUser> = []
    var wallet:Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = UITextAutocapitalizationType.None;
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user:PFUser = self.items[indexPath.row]
        
        var cell:UserCell;
        cell = self.tableView.dequeueReusableCellWithIdentifier("USER_CELL") as! UserCell
        cell.tag = indexPath.row + 1000
        cell.loadFromUser(user)
        
        return cell
        
    }
    
    //MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        APIManager.sharedInstance.getWalletsWithUserEmailAndSocialBank(searchBar.text
            , socialBank: wallet!.getSocialBank()
            , completion: { (results) -> Void in
                self.items = []
                for wallet in results {
                    self.items.append(wallet.getUser())
                }
                self.tableView.reloadData()
        })
        
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SEND_TO" {
            let vc:SendToVC = segue.destinationViewController as! SendToVC
            let index:Int = sender!.tag - 1000
            vc.userToSend = items[index]
            vc.wallet = self.wallet!
        }
    }
    
}

class UserCell : UITableViewCell {
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    func loadFromUser(obj: PFUser) {
        fullnameLabel.text = (obj["firstName"] as! String) + " " + (obj["lastName"] as! String)
        emailLabel.text = obj.email!
        if let photo = obj["image"] as? PFFile {
            let imageData:NSData = photo.getData()!
            photoImageView.image = UIImage(data: imageData)
        }
        /*fullnameLabel.text = (obj["firstName"] as! String) + (obj["lastObject"] as! String)
        emailLabel.text = obj["email"] as! String
        if let photo = obj["image"] as? PFFile {
            let imageData:NSData = photo.getData()!
            photoImageView.image = UIImage(data: imageData)
        }*/
        
    }
    
}