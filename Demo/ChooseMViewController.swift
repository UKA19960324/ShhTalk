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
    @IBOutlet weak var BTN_Bulbasaur: UIButton!
    @IBOutlet weak var BTN_Squirtle: UIButton!
    @IBOutlet weak var BTN_Pikachu: UIButton!
    @IBOutlet weak var BTN_Eevee: UIButton!
    @IBOutlet weak var BTN_Jigglypuff: UIButton!
    @IBOutlet weak var BTN_Oddish: UIButton!
    @IBOutlet weak var BTN_Clefairy: UIButton!
    @IBOutlet weak var BTN_Vulpix: UIButton!
    @IBOutlet weak var BTN_Teddiursa: UIButton!
    @IBOutlet weak var BTN_Jirachi: UIButton!
    @IBOutlet weak var BTN_Haunter: UIButton!
    
    @IBOutlet weak var UpBTNModel:UIButton?
    var ModelName = ""
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ChooseAction(_ sender: UIButton) {
        
        UpBTNModel?.backgroundColor = UIColor.clear
        
        sender.backgroundColor = UIColor.lightGray
        
        UpBTNModel = sender
        
        switch sender {
        case BTN_Charmander:
            ModelName = "Charmander.obj"
            break
        case BTN_Bulbasaur:
            ModelName = "Bulbasaur.obj"
            break
        case BTN_Squirtle:
            ModelName = "Squirtle.obj"
            break
        case BTN_Clefairy:
            ModelName = "Clefairy.obj"
            break
        case BTN_Eevee:
            ModelName = "Eevee.obj"
            break
        case BTN_Jigglypuff:
            ModelName = "Jigglypuff.obj"
            break
        case BTN_Oddish:
            ModelName = "Oddish.obj"
            break
        case BTN_Vulpix:
            ModelName = "Vulpix.obj"
            break
        case BTN_Haunter:
            ModelName = "Haunter.obj"
            break
        case BTN_Teddiursa:
            ModelName = "Teddiursa.obj"
            break
        case BTN_Jirachi:
            ModelName = "Jirachi.obj"
            break
        case BTN_Pikachu:
            ModelName = "Pikachu.obj"
            break
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ShowMViewController
        controller.ModelName = ModelName
        
    }
    

}
