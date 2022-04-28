import CoreData
import UIKit

class DatabaseHelper : UIViewController{
    
    static let shared = DatabaseHelper()
    
    public func getAllParty() -> [PartyModel]{
        
        var partyList = [PartyModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PartyModel")
        
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            
            for result in results{
                let party = result as! PartyModel
                partyList.append(party)
            }
        }
        catch{
            print("fetch failed")
        }
        
        return partyList
    }
    
    func addParty(_ partyList: [PartyModel]) -> [PartyModel]{
        var newPartyList = partyList
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PartyModel", in: context)
        let newParty = PartyModel(entity: entity!, insertInto: context)
        
        newParty.id = newPartyList.count as NSNumber
        
        do{
            try context.save()
            newPartyList.append(newParty)
            print("Added new party")
        }
        catch{
            print("context add party save error")
        }
        
        return newPartyList
    }
    
    func addPokemonToParty(_ partyId: NSNumber, _ pokemonId: NSNumber){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PokemonModel", in: context)
        
        let newPokemon = PokemonModel(entity: entity!, insertInto: context)
        let url = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)/"
        newPokemon.partyId = partyId
        newPokemon.url = url
        
        do{
            try context.save()
            print("Added new party member")
        }
        catch{
            print("context add party member save error")
        }
    }
    
    func getMemberOfParty(_ partyId: NSNumber) -> [PokemonModel]{

        var memberList = [PokemonModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonModel")
        let partyPredicate = NSPredicate(format: "partyId == %@", String(describing: partyId))
        request.predicate = partyPredicate
        
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results{
                let member = result as! PokemonModel
                memberList.append(member)
            }
        }
        catch{
            print("fetch failed")
        }
        
        return memberList
    }
    
    func deleteParty(_ party: PartyModel){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let memberRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonModel")
        let partyRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PartyModel")
        
        let memberPredicate = NSPredicate(format: "partyId == %@", String(describing: party.id))
        let partyPredicate = NSPredicate(format: "id == %@", String(describing: party.id))
        
        memberRequest.predicate = memberPredicate
        partyRequest.predicate = partyPredicate
      
        // delete party members
        do {
            let results:NSArray = try context.fetch(memberRequest) as NSArray
            for result in results{
                context.delete(result as! NSManagedObject)
            }
            try context.save()
        } catch _ {
            print("delete party member error")
        }
        
        // delete party
        do {
            let results:NSArray = try context.fetch(partyRequest) as NSArray
            for result in results{
                context.delete(result as! NSManagedObject)
            }
            try context.save()
        } catch _ {
            print("delete party error")
        }
    }
    
    func deletePartyMember(_ partyMember: PokemonModel){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonModel")
        
        let partyIdPredicate = NSPredicate(format: "partyId == %@", String(describing: partyMember.partyId))
        let idPredicate = NSPredicate(format: "url == %@", String(describing: partyMember.url))
        
        let deletePredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [partyIdPredicate, idPredicate])
        
        request.predicate = deletePredicate

        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results{
                context.delete(result as! NSManagedObject)
            }
            try context.save()
        } catch _ {
            print("delete party member error")
        }
    }
   
}
