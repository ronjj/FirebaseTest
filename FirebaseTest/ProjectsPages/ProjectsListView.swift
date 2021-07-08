import SwiftUI

struct ProjectsListView: View {
    // MARK: - State
    @StateObject var viewModel = ProjectsViewModel()
    @ObservedObject var viewModel2 = ProjectViewModel()
    @State var presentAddProjectSheet = false
   
    
    // MARK: - UI Components
    private var addButton: some View {
        Button(action: { self.presentAddProjectSheet.toggle() }) {
            Image(systemName: "plus")
        }
    }
    
    private func projectRowView(project: Project) -> some View {
        NavigationLink(destination: ProjectDetailsView(project: project )) {
            HStack{
                VStack(alignment: .leading) {
                    Text(project.title)
                        .font(.headline)
                    
                    HStack{
                        Text("Project Creator Name")
                            .font(.subheadline)
                        Image(systemName: "calendar.badge.clock")
                            .font(.body)
                            .foregroundColor(Color.red)
                    }
                }
                Spacer()
                
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(project.color)
            }
            .padding(20)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach (viewModel.projects) { project in
                    projectRowView(project: project)
                }
                .onDelete() { indexSet in
                    viewModel.removeProjects(atOffsets: indexSet)
                }
            }
            .navigationBarTitle("Projects")
            .navigationBarItems(trailing: addButton)
            .onAppear() {
                print("ProjectsListView appears. Subscribing to data updates.")
                self.viewModel.subscribe()
            }
            .sheet(isPresented: self.$presentAddProjectSheet) {
                ProjectEditView()
            }
        }
    }
}
