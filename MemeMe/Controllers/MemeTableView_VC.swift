//
//  MemeTableView_VC.swift
//  MemeMe
//
//  Created by Reem on 27/04/2019.
//  Copyright © 2019 Reem. All rights reserved.
//

import UIKit

class MemeTableView_VC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARk: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: - VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
//        tableView.estimatedRowHeight = 50
//        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Memes Stored!\nClick '+' to create a new Meme."
            tableView.separatorStyle = .none
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableMemeDetails"  {
            if let cell = sender as? MemeTableViewCell {
                let destination = segue.destination as! MemeDetails_VC
                destination.detailMeme = appDelegate.memes[(tableView.indexPath(for: cell)?.row)!] 
            }
        }
    }
    
    
}


extension MemeTableView_VC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("MemeTableViewCell", owner: self, options: nil)?.first as! MemeTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath) as! MemeTableViewCell
        cell.bottomLbl.text = appDelegate.memes[indexPath.row].bottomText
        cell.topLbl.text = appDelegate.memes[indexPath.row].topText
        cell.imageView?.image = appDelegate.memes[indexPath.row].memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTableMemeDetails", sender: tableView.cellForRow(at: indexPath))
    }

}
