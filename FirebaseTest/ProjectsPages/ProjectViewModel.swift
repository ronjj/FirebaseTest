import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import Firebase

class ProjectViewModel: ObservableObject {
    // MARK: - Public properties
    @Published var project: Project
    @Published var modified = false
    
    // MARK: - Internal properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructors
    
    init(project: Project = Project(title: "", color: Color.blue,assignedStudents: [], notes: "...")) {
        self.project = project
        
        self.$project
            .dropFirst()
            .sink { [weak self] project in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Firestore
    
    private var db = Firestore.firestore()
    
    private func addProject(_ project: Project) {
        do {
            let _ = try db.collection("projects").addDocument(from: project)
        }
        catch {
            print(error)
        }
    }
    
    private func updateProject(_ project: Project) {
        if let documentId = project.id {
            do {
                try db.collection("projects").document(documentId).setData(from: project)
            }
            catch {
                print(error)
            }
        }
    }
    
    private func updateOrAddProject() {
        if let _ = project.id {
            self.updateProject(self.project)
        }
        else {
            addProject(project)
        }
    }
    
    private func removeProject() {
        if let documentId = project.id {
            db.collection("projects").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - UI handlers
    
    func handleDoneTapped() {
        self.updateOrAddProject()
    }
    
    func handleDeleteTapped() {
        self.removeProject()
    }
    
}
