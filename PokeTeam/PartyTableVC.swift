import UIKit
import CoreData
import Kingfisher

class PartyTableVC: UITableViewController {
    
    private var partyList = [PartyModel]()
    
    override func viewDidLoad() {
        partyList = DatabaseHelper.shared.getAllParty()
        if(partyList.isEmpty){
            addPartyAction(self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let partyCell = tableView.dequeueReusableCell(withIdentifier: "partyCellId", for: indexPath) as! PartyCell
        var memberList = DatabaseHelper.shared.getMemberOfParty(partyList[indexPath.row].id as NSNumber)
        
        var partyCellGroup = [partyCell.memberImg1, partyCell.memberImg2, partyCell.memberImg3, partyCell.memberImg4, partyCell.memberImg5, partyCell.memberImg6]
        
        for i in 0..<6 {
            if(i > memberList.count-1){
                
                partyCellGroup[i]!.image = UIImage(named: "GreyOval")
            }
            else{
                let imgUrl = URL(string: (FetchHelper.shared.getPokemon(memberList[i].url)?.sprites.frontDefault)!)
                partyCellGroup[i]!.kf.setImage(with: imgUrl)
            }
            
        }
        
        partyCellGroup.removeAll()
        memberList.removeAll()
        
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
            
            let partyDetail = segue.destination as? PartyTabBarVC
            
            let selectedParty : PartyModel!
            selectedParty = partyList[indexPath.row]
            partyDetail!.selectedParty = selectedParty
            
            tableView.deselectRow(at: indexPath , animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {

                // remove the item from the data model
                DatabaseHelper.shared.deleteParty(partyList[indexPath.row])
                partyList.remove(at: indexPath.row)

                // delete the table view row
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
    }
    
    
}

