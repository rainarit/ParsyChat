//
//  ChatViewController.swift
//  ParsyChat
//
//  Created by Ritik Raina on 11/13/19.
//  Copyright © 2019 rraina. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject] = []
    var timer: Timer?
    
    @objc func onTimer() {
       // Add code to be run periodically
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }
    
    func queryMessages() {
        //construct query
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (response, error) in
            if let messages = response {
                self.messages = messages
                self.tableView.reloadData()
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableView.automaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
        queryMessages()
        onTimer()
        
        
    }
    
    func refresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        queryMessages()
        refreshControl.endRefreshing()
    }
    
    @IBAction func send(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
            }
            else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let chatMessage = messages[indexPath.row]
        cell.chatLabel.text = chatMessage["text"] as? String
        if let user = chatMessage["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        }
        else {
            cell.usernameLabel.text = "🤖"
        }
        return cell
    }
}
