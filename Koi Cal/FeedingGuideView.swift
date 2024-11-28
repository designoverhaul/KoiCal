import SwiftUI

struct FeedingGuideView: View {
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Best Practices")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    GuideSection(
                        title: "Feeding Schedule",
                        content: "Feed 2-3 times per day when water temperature is above 50°F (10°C). Reduce feeding in colder temperatures and stop completely below 50°F."
                    )
                    
                    GuideSection(
                        title: "The five-minute rule",
                        content: "Only give koi enough food that they can eat in five minutes. If there's food left over, remove it and give them less next time. It's better to underfeed koi than overfeed them."
                    )
                    GuideSection(
                        title: "Feeding temperature",
                        content: "Wait until the pond water is consistently 50°F before feeding koi. In the spring, feed them sparingly because their metabolism is affected by the water temperature. "
                    )
                    GuideSection(
                        title: "Sinking or Floating",
                        content: "Floating food is popular because it's fun to watch koi eat and it's easy to check their health. Sinking food is preferred by more experienced hobbyists. "
                    )
                    GuideSection(
                        title: "Food storage",
                        content: "Store koi food pellets in an airtight container in a cool, dry place. Replace the pellets seasonally because oxidation can make them unhealthy."
                    )
                    GuideSection(
                        title: "Feeding technique",
                        content: "Try different feeding techniques. Scatter food on the surface to encourage swimming, or hold food in your hand to build trust."
                    )
                    GuideSection(
                        title: "Bonding",
                        content: "Use feeding time to bond with your koi. They can recognize the person who feeds them and may even eat from your hand. "
                    )
                    GuideSection(
                        title: "Promoting Color",
                        content: "xxxxxxxxx"
                    )
                    GuideSection(
                        title: "Food Types",
                        content: "High-quality food can promote color. Foods rich in carotenoids like Spirulina, krill, shrimp, and astaxanthin can enhance reds, oranges, and yellows."
                    )
                    
                    GuideSection(
                        title: "Monitor Health",
                        content: "Watch how your koi react to feeding. If they're not eating or seem lethargic, it might be too cold or they could be ill."
                    )
                    
                    GuideSection(
                        title: "Amount Per Feeding",
                        content: "Feed only what your koi can consume in 5 minutes. Remove uneaten food to maintain water quality."
                    )
                    GuideSection(
                        title: "Growth vs. Maintenance",
                        content: "Younger koi might need more protein for growth. Older koi might benefit from lower protein diets to prevent obesity."
                    )
                    
                    GuideSection(
                        title: "Seasonal Tips",
                        content: "Spring/Fall: Gradually adjust feeding as temperatures change. Summer: Peak feeding season.  Winter: Minimal to no feeding below 50°F"
                    )
                }
                .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(20)
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
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
} 
