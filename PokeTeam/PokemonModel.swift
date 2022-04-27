import CoreData

@objc(PokemonModel)

class PokemonModel : NSManagedObject{
    @NSManaged var partyId : NSNumber
    @NSManaged var url : String
}
