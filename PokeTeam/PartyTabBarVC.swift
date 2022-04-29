import UIKit

class PartyTabBarVC : UITabBarController{
    var selectedParty : PartyModel? = nil
    
    var partyMemberVC : PartyNavbarVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partyMemberVC = (self.viewControllers![0] as? PartyNavbarVC)! //Reference to first child
        partyMemberVC.selectedParty = self.selectedParty
//        femaleVC = self.viewControllers![1] as? FemaleOptionsViewController //Reference to second child
    }
}
