import UIKit

class PartyNavbarVC : UINavigationController{
    
    var selectedParty : PartyModel? = nil
    var partyMemberVC : MemberTableVC!
    
    override func viewDidLoad() {
        partyMemberVC = (self.viewControllers[0] as? MemberTableVC)
        partyMemberVC.selectedParty = self.selectedParty
    }
}
