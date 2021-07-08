import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct Project: Identifiable, Codable{
    @DocumentID var id: String? = UUID().uuidString
    
    var title: String
    /* I used Google Auth in my full app*/
   // var creator: String = Auth.auth().currentUser?.displayName ?? "N/A"
    var color: Color
    var assignedStudents: [String]
    var notes: String

    
    enum CodingKeys: String, CodingKey {
        case title
        //case creator
        case color
        case assignedStudents
        case notes
   }
}



