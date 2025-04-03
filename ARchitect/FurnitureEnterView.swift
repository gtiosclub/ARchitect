import SwiftUI

struct FurnitureEntryView: View {
    @State private var allProjects: [[String: Any]] = UserDefaults.standard.array(forKey: "allProjects") as? [[String: Any]] ?? []
    @State private var isShowingARView = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to ARchitect!")
                    .font(.title)
                    .padding()

                Text("All Projects")
                    .font(.headline)
                    .padding(.top)

                ScrollView {
                    ForEach(allProjects.indices, id: \.self) { index in
                        if let screenshotData = allProjects[index]["screenshot"] as? Data,
                           let screenshot = UIImage(data: screenshotData) { // Convert Data back to UIImage
                            NavigationLink {
                                ProjectDetailsViewWrapper(project: allProjects[index])
                            } label: {
                                VStack {
                                    Image(uiImage: screenshot)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                        .cornerRadius(10)
                                        .padding()

                                    if let title = allProjects[index]["name"] as? String {
                                        Text(title)
                                            .font(.headline)
                                            .padding(.bottom, 5)
                                    }

                                    if let description = allProjects[index]["description"] as? String {
                                        Text(description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .onAppear {
                refreshProjects() // Explicitly refresh projects when the view appears
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ProjectSaved"))) { _ in
                refreshProjects() // Refresh projects when a project is saved
            }
            .toolbar {
                Button("Start AR") {
                    isShowingARView = true
                }
            }
            .fullScreenCover(isPresented: $isShowingARView) {
                ARViewControllerWrapper()
            }
        }
    }

    private func refreshProjects() {
        if let savedProjects = UserDefaults.standard.array(forKey: "allProjects") as? [[String: Any]] {
            allProjects = savedProjects
        } else {
            // If the data is invalid or missing, reset to an empty array
            allProjects = []
            UserDefaults.standard.set(allProjects, forKey: "allProjects")
        }
    }
}

struct ARViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController()
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {}
}


struct ProjectDetailsViewWrapper: UIViewControllerRepresentable {
    var project: [String: Any]

    func makeUIViewController(context: Context) -> ProjectDetailsViewController {
        let projectDetailsVC = ProjectDetailsViewController()
        projectDetailsVC.project = project
        projectDetailsVC.screenshotImage = UIImage(data: project["screenshot"] as? Data ?? Data()) // Convert Data to UIImage
        projectDetailsVC.projectName = project["name"] as? String ?? ""
        projectDetailsVC.projectDescription = project["description"] as? String ?? ""
        return projectDetailsVC
    }

    func updateUIViewController(_ uiViewCotroller: ProjectDetailsViewController, context: Context) {}
}


#Preview {
    FurnitureEntryView()
}
