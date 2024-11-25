import SwiftUI
import Foundation

// Add the color definitions at the top of the file
extension Color {
    static let koiBrown = Color(red: 0x58/255.0, green: 0x41/255.0, blue: 0x1F/255.0)
    static let firstFeeding = Color(red: 0xF1/255.0, green: 0xDB/255.0, blue: 0xC4/255.0)
    static let secondFeeding = Color(red: 0xC0/255.0, green: 0xA6/255.0, blue: 0x81/255.0)
    static let thirdFeeding = Color(red: 0x58/255.0, green: 0x41/255.0, blue: 0x1F/255.0)
}

// Add this struct at the top
struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date?
}

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var feedingData: FeedingData
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State private var displayedMonth: Date = Date()
    
    var body: some View {
        VStack(spacing: 15) {
            // Month header - only show for previous months
            if !calendar.isDate(displayedMonth, equalTo: Date(), toGranularity: .month) {
                Text(monthYearString(from: displayedMonth))
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5)
            }
            
            // Days of week header
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth()) { calendarDay in
                    if let date = calendarDay.date {
                        DayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            feedingCount: feedingData.getFeedingCount(for: date),
                            onTap: { 
                                if date <= Date() {
                                    selectedDate = date
                                }
                            },
                            isFuture: date > Date()
                        )
                    } else {
                        Color.clear
                            .aspectRatio(1, contentMode: .fill)
                    }
                }
            }
        }
        .padding()
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 50 {
                        // Swipe right - show previous month
                        if let newDate = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
                            displayedMonth = newDate
                        }
                    } else if value.translation.width < -50 {
                        // Swipe left - return to newer month
                        if let newDate = calendar.date(byAdding: .month, value: 1, to: displayedMonth),
                           newDate <= Date() {  // Only allow up to current month
                            displayedMonth = newDate
                        }
                    }
                }
        )
    }
    
    private func daysInMonth() -> [CalendarDay] {
        let range = calendar.range(of: .day, in: .month, for: displayedMonth)!
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var days: [CalendarDay] = Array(repeating: CalendarDay(date: nil), count: firstWeekday - 1)
        
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(CalendarDay(date: date))
            }
        }
        
        while days.count % 7 != 0 {
            days.append(CalendarDay(date: nil))
        }
        
        return days
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
            displayedMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
            displayedMonth = newDate
        }
    }
}

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let feedingCount: Int
    let onTap: () -> Void
    let isFuture: Bool
    
    var feedingColor: Color {
        switch feedingCount {
        case 1: return Color.firstFeeding
        case 2: return Color.secondFeeding
        case 3: return Color.thirdFeeding
        default: return .clear
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            Text("\(Calendar.current.component(.day, from: date))")
                .foregroundColor(
                    isFuture ? Color.gray.opacity(0.8) :  // Changed from 0.6 to 0.8 for better visibility
                    feedingCount == 3 ? Color(red: 0xE4/255.0, green: 0xDA/255.0, blue: 0xCC/255.0) : 
                    .primary
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .background(
                    Circle()
                        .fill(feedingColor)
                )
                .overlay(
                    Circle()
                        .stroke(Color.koiBrown, lineWidth: 3)
                        .opacity(isSelected ? 1 : 0)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isFuture)
    }
} 
