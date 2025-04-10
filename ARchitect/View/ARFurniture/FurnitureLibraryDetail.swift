import SwiftUI
import QuickLook

struct FurnitureDetailView: View {
    let item: FurnitureItem
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
                Spacer()
                
                Text(item.name)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                NavigationLink(destination: Furniture3DView(item: item)) { // go to 3D View
                    Text("View In 3D")
                        .bold()
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Furniture Details")
        }
    }
}

// actual VR view
//struct Furniture3DView: View {
//    let item: FurnitureItem
//    
//    var body: some View {
//        VStack {
//            Text("This is a placeholder")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("3D View")
//    }
//}

struct FurnitureLibraryDetail_Previews: PreviewProvider {
    static var previews: some View {
        FurnitureDetailView(item: FurnitureItem(name: "Grey Couch", tags: ["Modern", "Grey"], imageName: "GreyCouch2D"))
    }
}
