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
   
}
