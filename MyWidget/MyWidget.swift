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
        getTexts { Question in
            let QuestionTitles = Question.map { $0.question_title }
            let entry = SimpleEntry(date: Date(), texts: QuestionTitles)
            completion(entry)
        }
        
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getTexts { Question in

            let QuestionTitles = Question.map { $0.question_title }
            print(QuestionTitles)
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, texts: QuestionTitles)
            let nextRefresh = Calendar.current.date(byAdding: .minute, value: 3, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
    
    // add
    private func getTexts(completion: @escaping ([Question]) -> ()) {
        guard let url = URL(string: "http://27.96.134.196:8080/questions/all-list/1") else {
            print("Invalid URL")
            return
        }
        print("here!")
        print(url)
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
                let Question = try JSONDecoder().decode([Question].self, from: data)
                completion(Question)
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

//struct Event: Decodable {
//    let id: Int
//    let title: String
//    let eventDateUTC: String
//    let eventDateUnix: Int
//    let flightNumber: Int?
//    let details: String
//    let links: Links
//    
//    enum CodingKeys: String, CodingKey {
//        case id, title, eventDateUTC = "event_date_utc", eventDateUnix = "event_date_unix", flightNumber, details, links
//    }
//}
//
//struct Links: Codable {
//    let reddit: String?
//    let article: String?
//    let wikipedia: String?
//}

struct Question: Codable {
    let question_id: Int
    let category_id: Int
    let questioner_id: Int
    let question_title: String
    let question_content: String
    let question_liked_num: Int
    let isLike_active: Bool
    let create_date: String
    let answer_num: Int
    let questioner_name: String
    let is_selection: Bool
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
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 338, height: 48)
                    .background(Color(red: 0.17, green: 0.89, blue: 0.47))
                Text(getFormattedDate()) // 여기에 날짜가 들어갑니다.
                            .font(
                                Font.custom("SUIT", size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(.white)
                            .padding(.leading, 20)
            }
            VStack(alignment: .leading) {
                ForEach(entry.texts.prefix(3), id: \.self) { text in
                    HStack(alignment: .center, spacing: 20) {
                        Text("Q")
                                .font(
                                    Font.custom("Neue Haas Grotesk Display Pro", size: 36).weight(.medium)
                                )
                                .foregroundColor(Color.green)
                                .padding(.leading, 14) // 아이콘 위치 조정
                                .frame(width: 40)
                        
                        Text(text)
                            .font(
                                Font.custom("Neue Haas Grotesk Display Pro", size: 16).weight(.medium)
                            )
                            .lineSpacing(10)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                                                .lineLimit(3) // 두 줄로 제한
                            .padding(.trailing, 14)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
//                    Divider()
                }
            }
            .frame(width: 338, height: 48)
            .offset(x: 0, y: 55)
            Spacer()
        }
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let todayDate = Date()
        return dateFormatter.string(from: todayDate)
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
        MyWidgetEntryView(entry: SimpleEntry(date: Date(), texts: ["안드로이드 앱 개발을 공부하려면 어떤 순서로 공부해야 하는지 궁금합니다."]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
