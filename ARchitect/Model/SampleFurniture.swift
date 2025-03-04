import Swift

struct SampleFurniture {
    static let recent: [FurnitureItem] = [
        FurnitureItem(name: "Dining Table", imageName: "Dining_Table", isLocked: false),
        FurnitureItem(name: "Wardrobe", imageName: "Wardrobe", isLocked: false)
    ]
    
    static let table: [FurnitureItem] = [
        FurnitureItem(name: "Dining Table", imageName: "Dining_Table", isLocked: false)
    ]
    
    static let wardobe: [FurnitureItem] = [
        FurnitureItem(name: "Wood Wardrobe", imageName: "Wardrobe", isLocked: false)
        FurnitureItem(name: "Blue Wardrobe", imageName: "blueWardrobe", isLocked: false)
    ]

    static let chair: [FurnitureItem] = [
        FurnitureItem(name: "Modern Chair", imageName: "ModernChair2D", isLocked: false)
    ]

    static let couch: [FurnitureItem] = [
        FurnitureItem(name: "Grey Couch", imageName: "GreyCouch2D", isLocked: false)
        FurnitureItem(name: "Long Grey Couch", imageName: "longGreyCouch", isLocked: false)
        FurnitureItem(name: "Green Sofa", imageName: "greenSofa", isLocked: false)
    ]
    
}

