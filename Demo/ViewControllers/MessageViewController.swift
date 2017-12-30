//
//  MessageViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    var items = [Conversation]()
    var selectedUser: User?
    let CopeMtlFile = [ "Squirtle","Haunter","Teddiursa","Pikachu","Jirachi","Bulbasaur","Clefairy","Eevee","Jigglypuff","Oddish","Vulpix","Charmander" ]
    let CopeTgaFile = [ "ZenigameDh","ZenigameEyeDh","GhostDh","GhostEyeDh","HimegumaDh","HimegumaEyeDh","HimegumaMouthDh","PikachuDh","PikachuEyeDh","PikachuHohoDh","JirachiDh","JirachiEye3Dh","JirachiEyeDh","JirachiMouthDh","FushigidaneDh","FushigidaneEyeDh","pippi_0_0","pippi_0_1","pippi_0_2","purin_0_0","NazonokusaDh","NazonokusaEyeDh","NazonokusaMouthDh","RokonDh","RokonEyeDh","RokonMouthDh","hitokage_0_0","hitokage_0_1" ]
    let CopePngFile = [ "PikachuMouthDh","pm0133_00_Body1","pm0133_00_Eye1","pm0133_00_Mouth1" ]
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideButton()
        self.fetchData()
        if UserDefaults.standard.bool(forKey: "First") == false{
            var toFile = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(toFile.path + "\n\n\n\n\n")
            var check = true
            for R in CopeMtlFile{
                let File = Bundle.main.url(forResource: R , withExtension: "mtl")!
                var toMtlFile = toFile.appendingPathComponent(R + ".mtl")
                do {
                    try FileManager.default.copyItem(at: File, to: toMtlFile)
                }catch{
                    print("複製材質檔出錯")
                }
            }
            toFile = toFile.appendingPathComponent("Textures")
            do{
                try FileManager.default.createDirectory(atPath: toFile.path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("創建資料夾錯誤")
            }
            
            for R in CopeTgaFile{
                let File = Bundle.main.url(forResource: R, withExtension: "tga")!
                let toTgaFile = toFile.appendingPathComponent(R + ".tga")
                do{
                    try FileManager.default.copyItem(at: File, to: toTgaFile)
                }catch{
                    print ("複製圖片檔錯誤")
                }
            }
            
            for R in CopePngFile{
                let File = Bundle.main.url(forResource: R, withExtension: "png")!
                let toPngFile = toFile.appendingPathComponent(R + ".png")
                do{
                    try FileManager.default.copyItem(at: File, to: toPngFile)
                }catch{
                    print ("複製圖片檔錯誤")
                }
            }
            if check{
                UserDefaults.standard.set(true,forKey: "Firest")
                UserDefaults.standard.synchronize()
            }
        }
    }
 
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Downloads conversations
    func fetchData() {
        if let id = Auth.auth().currentUser?.uid {
            Conversation.showConversations(forUserID: id , completion: { (conversations) in
                DispatchQueue.main.async {
                    self.items = conversations
                    self.messageTableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.nameLabel.text = items[indexPath.row].user.name
        cell.photoImageView.image = items[indexPath.row].user.profilePic
        let message = self.items[indexPath.row].lastMessage.content as! String
        if message != "" {
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                cell.messageLabel.text = message
            case .photo:
                cell.messageLabel.text = "Photo"
            case .location:
                cell.messageLabel.text = "Location"
            case .model:
                cell.messageLabel.text = "Model"
            }
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
        }
        else {
            cell.timeLabel.text = ""
            cell.messageLabel.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.items[indexPath.row].user
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatViewController
            vc.currentUser = self.selectedUser
        }
    }
    
}
