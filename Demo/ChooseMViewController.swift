//
//  ChooseMViewController.swift
//  
//
//  Created by user on 2017/9/27.
//
//

import UIKit

class ChooseMViewController: UIViewController {
    
    @IBOutlet weak var BTN_Charmander: UIButton!
    var ModelName = ""
    var BChooseOne = false
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ChooseAction(_ sender: UIButton) {
        
        if sender.backgroundColor == UIColor.clear{
            
            if BChooseOne == false{
                
                BChooseOne = true
                sender.backgroundColor = UIColor.blue
                
                switch sender {
                case BTN_Charmander:
                    ModelName = "Charmander.obj"
                    break
                    
                default:
                    break
                }
            }
        }else {
            ModelName = ""
            BChooseOne = false
            sender.backgroundColor = UIColor.clear
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ShowMViewController
        controller.ModelName = ModelName
        
    }
    

}
