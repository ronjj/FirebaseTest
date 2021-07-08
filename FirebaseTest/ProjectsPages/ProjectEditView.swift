import SwiftUI

enum Mode {
    case new
    case edit
}

enum Action {
    case delete
    case done
    case cancel
}

struct ProjectEditView: View {
    // MARK: - State
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    // MARK: - State (Initialiser-modifiable)
    @ObservedObject var viewModel = ProjectViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    @State private var newAssigned = ""
    
    
    // MARK: - UI Components
    
    var cancelButton: some View {
        Button(action: { self.handleCancelTapped() }) {
            Text("Cancel")
        }
    }
    
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Done" : "Save")
        }
        .disabled(!viewModel.modified)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextEditor(text:$viewModel.project.title)
                        .font(.custom("SF Pro", size: 18))
                        .frame(height: 125, alignment: .center)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                
                Section(header: Text("Select Status")) {
                    HStack{
                        VStack{
                            Button{
                                self.viewModel.project.color = Color.red
                               
                                
                            }label: {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text("Help Needed")
                        }
                        
                        Spacer()
                        
                        VStack{
                            Button{
                                self.viewModel.project.color = Color.blue
                              
                                
                            }label: {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text("No Help Needed")
                        }
                    }
                    .padding(20)
                }
                
                Section(header: Text("Assign Members")) {
                    ForEach(viewModel.project.assignedStudents, id: \.self) { assignedStudent in
                        Text(assignedStudent)
                    }
                    .onDelete { indices in
                        viewModel.project.assignedStudents.remove(atOffsets: indices)
                    }
                    HStack {
                        TextField("New Person", text: $newAssigned)
                        Button(action: {
                            withAnimation {
                                viewModel.project.assignedStudents.append(newAssigned)
                                newAssigned = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .accessibilityLabel(Text("Add new person"))
                        }
                        .disabled(newAssigned.isEmpty)
                    }
                }
                
                
                Section(header: Text("Project Notes and Description")){
                    TextEditor(text: $viewModel.project.notes)
                        .frame(height: 125, alignment: .center)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                
                if mode == .edit {
                    Section {
                        Button("Delete Project") { self.presentActionSheet.toggle() }
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(mode == .new ? "New Project" : viewModel.project.title)
            .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
            .actionSheet(isPresented: $presentActionSheet) {
                ActionSheet(title: Text("Are you sure?"),
                            buttons: [
                                .destructive(Text("Delete Project"),
                                             action: { self.handleDeleteTapped() }),
                                .cancel()
                            ])
            }
        }
    }
    
    // MARK: - Action Handlers
    
    func handleCancelTapped() {
        self.dismiss()
    }
    
    func handleDoneTapped() {
        self.viewModel.handleDoneTapped()
        self.dismiss()
    }
    
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

