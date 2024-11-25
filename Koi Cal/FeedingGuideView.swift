import SwiftUI

struct FeedingGuideView: View {
    let dismiss: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with close button
                HStack {
                    Text("Feeding Guide")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: dismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
                .padding(.bottom, 5)
                
                // Content sections
                GuideSection(
                    title: "The five-minute rule",
                    content: "Only give koi enough food that they can eat in five minutes. If there's food left over, remove it and give them less next time. It's better to underfeed koi than overfeed them."
                )
                
                GuideSection(
                    title: "Feeding temperature",
                    content: "Wait until the pond water is consistently 50°F before feeding koi. In the spring, feed them sparingly because their metabolism is affected by the water temperature."
                )
                
                GuideSection(
                    title: "Food type",
                    content: "Choose a high-quality, complete koi food. The protein source should be a type of fish, like anchovy or fish meal."
                )
                
                GuideSection(
                    title: "Food type and location",
                    content: "Floating food is popular because it's fun to watch koi eat and it's easy to check their health. Sinking food is preferred by more experienced hobbyists."
                )
                
                GuideSection(
                    title: "Food storage",
                    content: "Store koi food pellets in an airtight container in a cool, dry place. Replace the pellets seasonally because oxidation can make them unhealthy."
                )
                
                GuideSection(
                    title: "Feeding technique",
                    content: "Try different feeding techniques. Scatter food on the surface to encourage swimming, or hold food in your hand to build trust."
                )
                
                GuideSection(
                    title: "Bonding",
                    content: "Use feeding time to bond with your koi. They can recognize the person who feeds them and may even eat from your hand."
                )
                
                GuideSection(
                    title: "Some food can promote color",
                    content: "High-quality food can promote color. Foods rich in carotenoids like Spirulina, krill, shrimp, and astaxanthin can enhance reds, oranges, and yellows."
                )
                
                GuideSection(
                    title: "Avoid feeding before storms",
                    content: "Low atmospheric pressure during storms can make it harder for koi to digest food, so pause feeding before a storm."
                )
                
                GuideSection(
                    title: "Monitor Health",
                    content: "Watch how your koi react to feeding. If they're not eating or seem lethargic, it might be too cold or they could be ill."
                )
                
                GuideSection(
                    title: "Growth vs. Maintenance",
                    content: "Younger koi might need more protein for growth. Older koi might benefit from lower protein diets to prevent obesity."
                )
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

struct GuideSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
} 