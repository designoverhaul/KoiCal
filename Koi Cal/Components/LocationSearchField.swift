import SwiftUI
import MapKit

struct LocationSearchField: View {
    @Binding var searchText: String
    @Binding var location: String
    @StateObject private var searchCompleter = LocationSearchCompleter()
    @State private var showSuggestions = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter location", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { _, newValue in
                    searchCompleter.search(query: newValue)
                    showSuggestions = !newValue.isEmpty
                }
            
            if showSuggestions && !searchCompleter.suggestions.isEmpty {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(searchCompleter.suggestions, id: \.self) { suggestion in
                            Button(action: {
                                searchText = suggestion.title
                                location = suggestion.title
                                showSuggestions = false
                            }) {
                                VStack(alignment: .leading) {
                                    Text(suggestion.title)
                                        .foregroundColor(.primary)
                                    if !suggestion.subtitle.isEmpty {
                                        Text(suggestion.subtitle)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 4)
                .frame(maxHeight: 200)
            }
        }
    }
}

#Preview {
    LocationSearchField(
        searchText: .constant(""),
        location: .constant("")
    )
    .padding()
} 