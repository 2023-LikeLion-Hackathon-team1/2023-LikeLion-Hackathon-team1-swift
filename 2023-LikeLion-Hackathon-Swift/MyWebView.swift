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
        getTexts { questions in
            for question in questions {
                    print("Title: \(question.question_title)")
//                    print("Event Date UTC: \(event.eventDateUTC)")
//                    print("Details: \(event.details)")
                    
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

private func getTexts(completion: @escaping ([Question]) -> ()) {
    guard let url = URL(string: "http://27.96.134.196:8080/questions/all-list/1") else {
        print("Invalid URL")
        return
    }
    print("?? why")
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
            let questions = try JSONDecoder().decode([Question].self, from: data)
            completion(questions)
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
