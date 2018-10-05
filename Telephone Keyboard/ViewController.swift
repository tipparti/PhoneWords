//
//  ViewController.swift
//  Telephone Keyboard
//
//  Created by mobility on 10/5/18.
//  Copyright © 2018 TMobil. All rights reserved.
//

import UIKit
import JCDialPad

class ViewController: UIViewController, JCDialPadDelegate {
    
    var dialPadView: JCDialPad?
    var mnemonics = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let buttons = JCDialPad.defaultButtons()
        self.dialPadView = JCDialPad(frame: self.view.frame)
        self.dialPadView?.buttons = buttons
        self.dialPadView?.delegate = self
        
        let backgroundView: UIImageView = UIImageView(frame: self.view.frame)
        backgroundView.image = UIImage(named: "wallpaper")
        self.dialPadView?.backgroundView = backgroundView
        
        if self.dialPadView != nil {
            self.view.addSubview(self.dialPadView!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dialPad(_ dialPad: JCDialPad!, shouldInsertText text: String!, forButtonPress button: JCPadButton!) -> Bool {
        mnemonics.append(text)
        print(PhoneWords.sharedInstance.getWordfromKeyMap(text: mnemonics))
        return false
    }
}


