//
//  CommunityViewModel.swift
//  BookSharer
//
//  Created by 최성빈 on 2023/09/25.
//

import Foundation

struct CommunityDTO: Codable {
    let board_id: Int?
    let board_title: String?
    let category_id: String?
    let board_story: String?
    let boardImageUrls: [String]?
    let date: String?
    let likeCount: Int?
    
    let user_seq: String?
    let nickName: String?
    let UserImageUrl: String?
    let UserGrade: String?

    init(board_id: Int? = nil,
         board_title: String? = nil,
         category_id: String? = nil,
         board_story: String? = nil,
         boardImageUrls: [String]? = nil,
         date: String? = nil,
         likeCount: Int? = nil,
         user_seq: String? = nil,
         nickName: String? = nil,
         UserImageUrl: String? = nil,
         UserGrade: String? = nil) {
        self.board_id = board_id
        self.board_title = board_title
        self.category_id = category_id
        self.board_story = board_story
        self.boardImageUrls = boardImageUrls
        self.date = date
        self.likeCount = likeCount
        self.user_seq = user_seq
        self.nickName = nickName
        self.UserImageUrl = UserImageUrl
        self.UserGrade = UserGrade
    }
}



class CommunityViewModel: ObservableObject {
    
    private let delegateHelper = URLSessionDelegateHelper()
    
    //[#1. 게시글 등록 ] -저장 완료-
    func savePosting(type: String, communityDTO: CommunityDTO, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://43.200.206.14:8443/\(type)Posting/")! // Remove the trailing slash
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let encoder = JSONEncoder()
        if let data = try? encoder.encode(communityDTO) {
            request.httpBody = data

            let session = URLSession(configuration: .default, delegate: delegateHelper, delegateQueue: nil)
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    completion(.failure(NSError(domain: "ResponseError", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }
                
                if let data = data {
                    let dataString = String(data: data, encoding: .utf8)
                    print("Server response: \(dataString ?? "No data string")")
                    
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let message = jsonResponse["message"] as? String {
                            completion(.success(message))
                        } else {
                            completion(.failure(NSError(domain: "ResponseError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "ResponseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response data"])))
                }
            }.resume()
        } else {
            completion(.failure(NSError(domain: "EncodingError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to encode data"])))
        }
    }

    
    // 게시판 불러오기
    func fetchCommunityPosts(type: String,  completion: @escaping (Result<[CommunityDTO], Error>) -> Void) {
        let urlString = "https://43.200.206.14:8443/\(type)posting/All" // 원하는 API 엔드포인트로 수정
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        // URLSession 생성 시 delegate 설정
        let session = URLSession(configuration: .default, delegate: delegateHelper, delegateQueue: nil)

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let CommunityDTOList = jsonObject?["CommunityDTOList"] as? [[String: Any]] {
                    let communityDTOList = try decoder.decode([CommunityDTO].self, from: JSONSerialization.data(withJSONObject: CommunityDTOList))
                    completion(.success(communityDTOList))
                } else {
                    print("Failed to find 'posts' array in JSON response.")
                    completion(.failure(NSError(domain: "JSON Parsing Error", code: -3, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }

        }

        task.resume()
    }
}
