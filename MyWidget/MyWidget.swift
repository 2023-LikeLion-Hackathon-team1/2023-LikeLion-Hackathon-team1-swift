//
//  MyWidget.swift
//  MyWidget
//
//  Created by 최혜림 on 8/15/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), texts: ["empty"])
    }
    
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        getTexts { events in
            let eventTitles = events.map { $0.title }
            let entry = SimpleEntry(date: Date(), texts: eventTitles)
            completion(entry)
        }
        
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getTexts { events in
            let eventTitles = events.map { $0.title }
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, texts: eventTitles)
            let nextRefresh = Calendar.current.date(byAdding: .minute, value: 3, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
    
    // add
    private func getTexts(completion: @escaping ([Event]) -> ()) {
        guard let url = URL(string: "https://api.spacexdata.com/v3/history") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let events = try JSONDecoder().decode([Event].self, from: data)
                completion(events)
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let texts: [String]
}

struct TextModel: Codable {
    enum CodingKeys : String, CodingKey {
        case datas = "data"
    }
    let datas: [String]
}

struct Event: Decodable {
    let id: Int
    let title: String
    let eventDateUTC: String
    let eventDateUnix: Int
    let flightNumber: Int?
    let details: String
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id, title, eventDateUTC = "event_date_utc", eventDateUnix = "event_date_unix", flightNumber, details, links
    }
}

struct Links: Codable {
    let reddit: String?
    let article: String?
    let wikipedia: String?
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry
    
    private var randomColor: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    var body: some View {
        //        ZStack {
        //            randomColor.opacity(0.7)
        //            Text(entry.texts.first ?? "")
        //            .foregroundColor(Color.white)
        //            .lineLimit(1)
        //        }
        VStack() {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 338, height: 48)
                    .background(Color(red: 0.17, green: 0.89, blue: 0.47))
                Text("질문 탐색하기")
                    .font(
                        Font.custom("SUIT", size: 18)
                            .weight(.semibold)
                    )
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 8) {
                ForEach(entry.texts.prefix(5), id: \.self) { text in
                    HStack(alignment: .top, spacing: 20) {
                        Text(text)
                            .font(
                                Font.custom("Neue Haas Grotesk Display Pro", size: 16).weight(.medium)
                            )
                            .lineSpacing(24)
                            .foregroundColor(.black)
                    }
                    Divider()
                }
            }
            .frame(width: 338, height: 48)
            .offset(x: 0, y: 55)
            Spacer()
        }
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("위젯 예제")
        .description("랜덤 텍스트를 불러오는 위젯 예제입니다")
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: SimpleEntry(date: Date(), texts: ["empty"]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
