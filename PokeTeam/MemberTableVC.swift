import UIKit
import CoreData

class MemberTableVC: UITableViewController{
    @IBOutlet weak var addBtn: UIButton!
    
    var selectedParty : PartyModel? = nil
    
    private var memberList = [PokemonModel]()

    override func viewDidLoad() {
        loadMemberList()
    }
    
    func loadMemberList(){
        memberList = DatabaseHelper.shared.getMemberOfParty(selectedParty!.id)
        addBtn.isHidden = memberList.count == 6 ? true : false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memberCell = tableView.dequeueReusableCell(withIdentifier: "memberCellId") as! MemberCell
        
        memberCell.memberLbl.text = FetchHelper.shared.getPokemonName(memberList[indexPath.row].url).capitalized
        
        return memberCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showPokemonDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addPokemonSegue")
        {
            let addPokemon = segue.destination as? PokeListTableVC
            addPokemon!.selectedParty = self.selectedParty
            addPokemon?.pokemonSelectionDelegate = self
        }
        if(segue.identifier == "showPokemonDetailSegue")
        {
            let showPokemon = segue.destination as? PokemonDetailVC
            let indexPath = tableView.indexPathForSelectedRow!
            showPokemon!.pokemonUrl = memberList[indexPath.row].url
            
            tableView.deselectRow(at: indexPath , animated: true)
        }
    }
}

extension MemberTableVC : PokemonSelectionDelegate{
    func didTapChoice() {
        loadMemberList()
        tableView.reloadData()
    }

}

