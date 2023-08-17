//
//  ShareDetails.swift
//  BookSharer
//
//  Created by 최성빈 on 2023/07/01.
//

import SwiftUI

struct ShareDetails: View {
    var board: BoardDTO
    
    var body: some View {
        NavigationLink(destination: SharePost()) {
            VStack(alignment: .leading, spacing: 13)  {
                HStack(alignment: .center, spacing: 0) {
                    Text("책 이미지")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 52)
                .padding(.vertical, 0)
                .frame(height: 166, alignment: .center)
                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(board.boardTitle)
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                    HStack(alignment: .center, spacing: 4){
                        Image(systemName: "heart")
                            .font(.system(size: 12))
                    }
                }
            }
        }
    }
}

struct ShareDetails_Previews: PreviewProvider {
    static var previews: some View {
        ShareDetails(board: BoardDTO(boardGiveId: 1,
                                       boardTitle: "예시 게시물 제목",
                                       userSeq: 1,
                                       categoryId: "",
                                       bookStory: "예시 책 내용",
                                      
                                       stateUnderscore: "",
                                       stateNotes: "",
                                       stateCover: "",
                                       stateWrittenName: "",
                                       statePageColorChange: "",
                                       statePageDamage: "",
                                       cityId: "",
                                       meetWantLocation: ""))
    }
}


