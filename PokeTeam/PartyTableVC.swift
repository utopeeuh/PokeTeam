import UIKit
import CoreData

class PartyTableVC: UITableViewController {
    
    private var partyList = [PartyModel]()

    override func viewDidLoad() {
        partyList = DatabaseHelper.shared.getAllParty()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let partyCell = tableView.dequeueReusableCell(withIdentifier: "partyCellId") as! PartyCell
        let memberList = DatabaseHelper.shared.getMemberOfParty(partyList[indexPath.row].id as NSNumber)

        var partyCellGroup = [partyCell.memberLbl1, partyCell.memberLbl2, partyCell.memberLbl3, partyCell.memberLbl4, partyCell.memberLbl5, partyCell.memberLbl6]
        
        for i in 0..<memberList.count {
            let pokemonName = FetchHelper.shared.getPokemonName(memberList[i].url)
            partyCellGroup[i]!.text = pokemonName
        }
        
        return partyCell
    }

    @IBAction func addPartyAction(_ sender: Any) {
        partyList = DatabaseHelper.shared.addParty(partyList)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "partyToMemberSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "partyToMemberSegue")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let partyDetail = segue.destination as? MemberTableVC
            
            let selectedParty : PartyModel!
            selectedParty = partyList[indexPath.row]
            partyDetail!.selectedParty = selectedParty
            
            tableView.deselectRow(at: indexPath , animated: true)
        }
    }
}

