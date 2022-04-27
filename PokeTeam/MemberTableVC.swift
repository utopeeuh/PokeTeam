import UIKit
import CoreData

class MemberTableVC: UITableViewController{
    var selectedParty : PartyModel? = nil
    
    private var memberList = [PokemonModel]()

    override func viewDidLoad() {
        memberList = DatabaseHelper.shared.getMemberOfParty(selectedParty!.id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memberCell = tableView.dequeueReusableCell(withIdentifier: "memberCellId") as! MemberCell
        
        memberCell.memberLbl.text = FetchHelper.shared.getPokemonName(memberList[indexPath.row].url)
        
        return memberCell
    }

//    @IBAction func addPartyAction(_ sender: Any) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "PartyModel", in: context)
//        let newParty = PartyModel(entity: entity!, insertInto: context)
//
//        newParty.id = partyList.count as NSNumber
//
//        do{
//            try context.save()
//            partyList.append(newParty)
//            tableView.reloadData()
//            print("saved!")
//        }
//        catch{
//            print("context save error")
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "addPokemonSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addPokemonSegue")
        {
            let addPokemon = segue.destination as? PokeListTableVC
            print(addPokemon)
            addPokemon!.selectedParty = self.selectedParty
        }
    }
    
}
