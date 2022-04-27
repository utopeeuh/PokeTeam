import UIKit
import CoreData

class PokeListTableVC : UITableViewController{
    var selectedParty : PartyModel? = nil
    
    private var pokemonList = [Pokemon]()

    override func viewDidLoad() {
        pokemonList = FetchHelper.shared.getAllPokemon()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeListCell = tableView.dequeueReusableCell(withIdentifier: "pokeListCellId") as! PokeListCell
        
        pokeListCell.pokemonLbl.text = pokemonList[indexPath.row].name
        
        return pokeListCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //detect row select
        print(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
