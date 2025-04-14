import SwiftUI
import RealityKit

struct ContentView: View {

    @State private var session: ObjectCaptureSession?
    @State private var imageFolderPath: URL?
    @State private var photogrammetrySession: PhotogrammetrySession?
    @State private var modelFolderPath: URL?
    @State private var isProgressing = false
    @State private var quickLookIsPresented = false

    var modelPath: URL? {
        return modelFolderPath?.appending(path: "model.usdz")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if let session {
                ObjectCaptureView(session: session)

                VStack(spacing: 16) {
                    if session.state == .ready || session.state == .detecting {
                        CreateButton(session: session)
                    }

                    HStack {
                        Text(session.state.label)
                            .bold()
                            .foregroundStyle(.yellow)
                            .padding(.bottom)
                    }
                }
            }

            if isProgressing {
                ArchitectLoadingView()
            }
        }
        .task {
            guard let directory = createNewScanDirectory() else { return }
            session = ObjectCaptureSession()

            modelFolderPath = directory.appending(path: "Models/")
            imageFolderPath = directory.appending(path: "Images/")
            guard let imageFolderPath else { return }
            session?.start(imagesDirectory: imageFolderPath)
        }
        .onChange(of: session?.userCompletedScanPass) { _, newValue in
            if let newValue, newValue {
                session?.finish()
            }
        }
        .onChange(of: session?.state) { _, newValue in
            if newValue == .completed {
                session = nil
                Task {
                    await startReconstruction()
                }
            }
        }
        .sheet(isPresented: $quickLookIsPresented) {
            if let modelPath {
                ARQuickLookView(modelFile: modelPath) {
                    quickLookIsPresented = false
                }
            }
        }
    }

    func createNewScanDirectory() -> URL? {
        guard let capturesFolder = getRootScansFolder() else { return nil }

        let formatter = ISO8601DateFormatter()
        let timestamp = formatter.string(from: Date())
        let newCaptureDirectory = capturesFolder.appendingPathComponent(timestamp, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: newCaptureDirectory, withIntermediateDirectories: true)
        } catch {
            print("Failed to create capture path: \(error)")
        }

        return newCaptureDirectory
    }

    private func getRootScansFolder() -> URL? {
        guard let documentFolder = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        return documentFolder.appendingPathComponent("Scans/", isDirectory: true)
    }

    private func startReconstruction() async {
        guard let imageFolderPath, let modelPath else { return }
        isProgressing = true
        do {
            photogrammetrySession = try PhotogrammetrySession(input: imageFolderPath)
            guard let photogrammetrySession else { return }
            try photogrammetrySession.process(requests: [.modelFile(url: modelPath)])
            for try await output in photogrammetrySession.outputs {
                switch output {
                case .requestError, .processingCancelled:
                    isProgressing = false
                    self.photogrammetrySession = nil
                case .processingComplete:
                    isProgressing = false
                    self.photogrammetrySession = nil
                    quickLookIsPresented = true
                default:
                    break
                }
            }
        } catch {
            print("error", error)
        }
    }
}
