import UIKit
import CoreData

class MemberTableVC: UITableViewController{
    @IBOutlet weak var addBtn: UIButton!
    
    var selectedParty : PartyModel? = nil
    
    private var memberList = [PokemonModel]()

    override func viewDidLoad() {
        memberList = DatabaseHelper.shared.getMemberOfParty(selectedParty!.id)
        addBtn.isHidden = memberList.count == 6 ? true : false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memberCell = tableView.dequeueReusableCell(withIdentifier: "memberCellId") as! MemberCell
        
        memberCell.memberLbl.text = FetchHelper.shared.getPokemonName(memberList[indexPath.row].url)
        
        return memberCell
    }

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
            addPokemon!.selectedParty = self.selectedParty
        }
    }
    
}
