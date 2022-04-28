//
//  MainPageVC.swift
//  PokeTeam
//
//  Created by Tb. Daffa Amadeo Zhafrana on 28/04/22.
//

import UIKit

class MainPageVC : UIViewController{
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "goToPartiesSegue", sender: self)
    }
}
