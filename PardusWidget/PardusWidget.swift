//
//  AROpenEntityWidget.swift
//  ArjoWidgetsExtension
//
//  Created by Igor Postoev on 29.11.24..
//

import WidgetKit
import SwiftUI

struct AROpenEntityItem {
    
    let label: String
    let value: String
}

struct AROpenEntityEntry: TimelineEntry {
    
    let date: Date
    let title: String
    let items: [AROpenEntityItem]
    
    init(date: Date,
         title: String = "",
         items: [AROpenEntityItem] = []) {
        self.date = date
        self.title = title
        self.items = items
    }
}

struct AROpenEntityProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> AROpenEntityEntry {
        AROpenEntityEntry(date: Date(),
                        title: "Last synchronization date")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = AROpenEntityEntry(date: Date(),
                                    title: "Last synchronization date")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        
        var entries: [Entry] = []
        
        entries.append(AROpenEntityEntry(date: currentDate,
                                         title: "Assessments",
                                         items: [.init(label: "Meal1", value: "mealId1"),
                                                 .init(label: "Meal2", value: "mealId2"),
                                                 .init(label: "Meal3", value: "mealId3")]))
        
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct AROpenEntityEntryView : View {
    
    var entry: AROpenEntityEntry
    
    var body: some View {
        VStack(spacing: 8) {
            Text(entry.title)
                .font(.caption)
            Spacer().frame(height: 10)
            ForEach(entry.items, id: \.value) { item in
                Link(destination:  URL(string: "pardus://\(item.value)")!) {
                    HStack {
                        Text(item.label)
                        Spacer()
                    }
                }
                .frame(height: 50)
                .padding(8)
                .background(Color(.green))
                .cornerRadius(8)
            }
            Spacer()
        }
    }
}

struct AROpenEntityWidget: Widget {
    
    let kind = "PardusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AROpenEntityProvider()) { entry in
            if #available(iOS 17.0, *) {
                AROpenEntityEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                AROpenEntityEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Arjo")
        .description("Shows last synchronization date.")
    }
}

#Preview(as: .systemLarge) {
    AROpenEntityWidget()
} timeline: {
    AROpenEntityEntry(date: Date(),
                      title: "Assessments",
                      items: [.init(label: "Meal1", value: "mealId1"),
                              .init(label: "Meal2", value: "mealId2"),
                              .init(label: "Meal3", value: "mealId3")])
}

