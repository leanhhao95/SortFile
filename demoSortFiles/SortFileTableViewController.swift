//
//  SortFileTableViewController.swift
//  demoSortFiles
//
//  Created by Hao on 11/5/17.
//  Copyright © 2017 Hao. All rights reserved.
//

import UIKit

class SortFileTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPhotoServicesIfNeed()
        registerNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initPhotoServicesIfNeed() {
        guard AppDelegate.shared.photoService == nil else {return}
        AppDelegate.shared.photoService = PhotoServices()
    }
    // MARK: - Table view data source
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name.didFinishFetchPHAsset, object: nil)
        
    }
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         print(AppDelegate.shared.photoService!.displayedAssets)
        return AppDelegate.shared.photoService!.displayedAssets.count
       
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cleanerAsset = AppDelegate.shared.photoService!.displayedAssets[indexPath.row]
        let cellIdentifier = cleanerAsset.asset.duration == 0 ? "ImageCell" : "videoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! sortFileTableViewCell
        
        switch cleanerAsset.thumbnailStatus {
        case .goodToGo:
            cell.photoImageView?.image = cleanerAsset.thumbnail
        case .fetching, .failed:
            cell.photoImageView?.image = UIImage(named: "photoDownloadError")
            cell.typeAssetLabel?.text = "Error Asset"
            
            
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
