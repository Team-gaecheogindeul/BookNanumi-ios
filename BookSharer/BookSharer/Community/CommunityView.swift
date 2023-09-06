//
//  CommunityView.swift
//  BookSharer
//
//  Created by 최성빈 on 2023/09/04.
//

import SwiftUI

struct CommunityView: View {

    //Menu가 보이는지 안 보이는지에 대한 변수 선언
    
    @Binding var showMenu : Bool
    
     var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation{
                        self.showMenu = false
                    }
                }
        }
        return GeometryReader{ geometry in
                ZStack(alignment:.leading) {
                    CommunityMainView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .offset(x:self.showMenu ? geometry.size.width/2 : 0)
                    
                    if self.showMenu {
                        MenuView(showMenu: $showMenu)
                                           .frame(width:geometry.size.width/2)
                                        .transition(.move(edge: .leading))
                                   }
                }
            .gesture(drag)  //drag로 메뉴 슬라이딩 제어
            }


         
    }
}

struct CommunityMainView: View {
    
    @Binding var showMenu : Bool
    
    var body: some View {
        VStack {
            ComuTopbar(showMenu: $showMenu)
            Divider()
            
            ScrollView {
                popularCommu()
                
                AllCommu()
            }
            .padding(.all, 14.0)
            
            Spacer()
                
        }

    }
}

// 사이드 메뉴
struct MenuView: View {
    @Binding var showMenu : Bool
    
    var body: some View {
        VStack(alignment: .leading){
            NavigationLink {
                freeCommu()
            } label: {
                Text("자유게시판")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding(.top, 100)
            }
            
            
            Text("학습 게시판")
                .foregroundColor(.gray)
                .font(.headline)
                .padding(.top, 30)
            
            Text("고등학교 입시 게시판")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding(.top, 30)
            
            Text("대학교 입시 게시판")
                .foregroundColor(.gray)
                .font(.headline)
                .padding(.top, 30)
            

            
            Spacer()
        }
        .padding(.leading, 14.0)
        .frame(maxWidth: .infinity, alignment:.leading)
        .background(Color(UIColor.systemGray5))
    }
}


struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(showMenu: .constant(false))
    }
}
