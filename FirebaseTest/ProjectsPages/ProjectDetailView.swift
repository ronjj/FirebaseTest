import SwiftUI

struct ProjectDetailsView: View {
    // MARK: - State
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditProjectSheet = false
    @ObservedObject var viewModel = ProjectViewModel()
    @ObservedObject var viewModels = ProjectViewModel()
    
    // MARK: - State (Initialiser-modifiable)
    
    var project: Project
   
    
    // MARK: - UI Components
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
            Text("Edit")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                HStack{
                    Text("Project Creator")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                        .frame(width: 280)
                        //.fixedSize()
                        .padding(.bottom, 50)
                        .padding(.leading, -65)
                    
                    Spacer()
                }
                
                VStack(spacing: 50){
                    Group{
                        HStack{
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundColor(project.color)
                            Spacer()
                           
                            
                        }
                        
                        HStack{
                            
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                            Spacer()
                            Text(project.notes)
                                .font(.body)
                            Spacer()
                            
                        }
                        
                        HStack{
                            Image(systemName: "person.3.fill")
                                .font(.title)
                            Spacer()
                            ForEach(project.assignedStudents, id: \.self) { assignedStudent in
                                Label(assignedStudent, systemImage: "person")
                                    .accessibilityLabel(Text("Person"))
                                    .accessibilityValue(Text(assignedStudent))
                                    .font(.body)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 25)
                    }
                    
                    Button{
                    } label: {
                       Text("contact officer")
                        .background(Color.red)
                    }
                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
        .navigationBarTitle(project.title)
        .navigationBarItems(trailing: editButton {
            self.presentEditProjectSheet.toggle()
        })
        .onAppear() {
            print("ProjectDetailsView.onAppear() for \(self.project.title)")
        }
        .onDisappear() {
            print("ProjectDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditProjectSheet) {
            ProjectEditView(viewModel: ProjectViewModel(project: project), mode: .edit) { result in
                if case .success(let action) = result, action == .delete {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

