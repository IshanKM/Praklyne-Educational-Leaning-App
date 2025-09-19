import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

  
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let ctx = controller.container.viewContext

        let obj = NSEntityDescription.insertNewObject(forEntityName: "CourseProgressEntity", into: ctx)
        obj.setValue(Int16(4), forKey: "completedDays")
        obj.setValue(4.5, forKey: "completedHours")
        obj.setValue(Int16(3), forKey: "currentStreak")
        obj.setValue(Int16(12), forKey: "overallProgress")

        try? ctx.save()
        return controller
    }()

    init(inMemory: Bool = false) {

        let model = Self.makeModel()
        container = NSPersistentContainer(name: "CourseDataModel", managedObjectModel: model)

        if inMemory {
            let desc = NSPersistentStoreDescription()
            desc.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [desc]
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load Core Data store: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()


        let entity = NSEntityDescription()
        entity.name = "CourseProgressEntity"
        entity.managedObjectClassName = "NSManagedObject"


        let completedDays = NSAttributeDescription()
        completedDays.name = "completedDays"
        completedDays.attributeType = .integer16AttributeType
        completedDays.isOptional = false
        completedDays.defaultValue = 0

        let completedHours = NSAttributeDescription()
        completedHours.name = "completedHours"
        completedHours.attributeType = .doubleAttributeType
        completedHours.isOptional = false
        completedHours.defaultValue = 0.0

        let currentStreak = NSAttributeDescription()
        currentStreak.name = "currentStreak"
        currentStreak.attributeType = .integer16AttributeType
        currentStreak.isOptional = false
        currentStreak.defaultValue = 0

        let overallProgress = NSAttributeDescription()
        overallProgress.name = "overallProgress"
        overallProgress.attributeType = .integer16AttributeType
        overallProgress.isOptional = false
        overallProgress.defaultValue = 0

        entity.properties = [completedDays, completedHours, currentStreak, overallProgress]
        model.entities = [entity]
        return model
    }
}
