//
//  MyWebView.swift
//  2023-LikeLion-Hackathon-Swift
//
//  Created by 최혜림 on 8/11/23.
//

import SwiftUI
import WebKit

struct MyWebView: UIViewRepresentable {
    
    
    var urlToLoad: String
    
    //ui view 만들기
    func makeUIView(context: Context) -> WKWebView {
        getTexts { events in
            for event in events {
                    print("Title: \(event.title)")
                    print("Event Date UTC: \(event.eventDateUTC)")
                    print("Details: \(event.details)")
                    if let articleLink = event.links.article {
                        print("Article: \(articleLink)")
                    }
                    if let wikipediaLink = event.links.wikipedia {
                        print("Wikipedia: \(wikipediaLink)")
                    }
                    print("================================")
                }
        }
        
        //unwrapping
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        //웹뷰 인스턴스 생성
        let webView = WKWebView()
        
        //웹뷰를 로드한다
        webView.load(URLRequest(url: url))
        return webView
    }
    
    //업데이트 ui view
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MyWebView>) {
        
    }
}

struct MyWebView_Previews: PreviewProvider {
    static var previews: some View {
        MyWebView(urlToLoad: "https://likelion-hackathon-2023.netlify.app/")
    }
}

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

//struct TextModel: Codable {
//    enum CodingKeys : String, CodingKey {
//        case datas = "data"
//    }
//    let datas: [Event]
//}

//struct Question {
//    let question_id: Int
//    let question_title: String
//    let question_content: String
//    let questioner_id: Int
//    let create_date: Date
//    let questionLikeCount: Int
//    let imageUrls: [String]
//    let userImage: String
//}

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
