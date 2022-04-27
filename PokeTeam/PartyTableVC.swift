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

        var partyCellGroup = [partyCell.memberLbl1.text, partyCell.memberLbl2.text, partyCell.memberLbl3.text, partyCell.memberLbl4.text, partyCell.memberLbl5.text, partyCell.memberLbl6.text]
        
        for i in 0..<memberList.count {
            partyCellGroup[i] = FetchHelper.shared.getPokemonName(memberList[i].url)
        }
        
        return partyCell
        
    }

    @IBAction func addPartyAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PartyModel", in: context)
        let newParty = PartyModel(entity: entity!, insertInto: context)
        
        newParty.id = partyList.count as NSNumber
        
        do{
            try context.save()
            partyList.append(newParty)
            tableView.reloadData()
            print("saved!")
        }
        catch{
            print("context save error")
        }
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

