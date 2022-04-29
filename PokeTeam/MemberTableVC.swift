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
        
        let pokemon = FetchHelper.shared.getPokemon(memberList[indexPath.row].url)
                                                            
        let memberCell = tableView.dequeueReusableCell(withIdentifier: "memberCellId") as! MemberCell
        
        memberCell.memberLbl.text = pokemon!.name.capitalized
        memberCell.memberImg.load(url: URL(string: (pokemon?.sprites.frontDefault)!)!)
        
        memberCell.memberIdLbl.text = { () -> String in
            var stringId = ""
            if(pokemon!.id < 10){
                stringId = "00"
            }
            else if(pokemon!.id < 100){
                stringId = "0"
            }
            stringId += String(describing: pokemon!.id)
            return stringId
        }()
        
        memberCell.memberType.text  = { () -> String in
            var stringType = ""
            for i in 0..<pokemon!.types.count {
                stringType += pokemon!.types[i].type.name.capitalized
                if(pokemon!.types.count > 1 && i == 0){
                    stringType += " / "
                }
            }
            return stringType
        }()
        
        
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {

                // remove the item from the data model
                DatabaseHelper.shared.deletePartyMember(memberList[indexPath.row])
                memberList.remove(at: indexPath.row)

                // delete the table view row
                tableView.deleteRows(at: [indexPath], with: .fade)

            }
        }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension MemberTableVC : PokemonSelectionDelegate{
    func didTapChoice() {
        loadMemberList()
        tableView.reloadData()
    }

}

