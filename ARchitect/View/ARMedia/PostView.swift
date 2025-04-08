//
//  PostView.swift
//  ARchitect
//
//  Created by Amiire kolawole on 2025-03-03.
//

import SwiftUI

struct PostView: View {
    @State var post: Post
    @State private var showComments = false
    @State private var showMenuSheet = false
    @State private var showPopUp = false
    @State private var showLikes = false
    var body: some View {
        NavigationView {
            ZStack{
                Color(.sRGB,red: 249/255, green: 237/255, blue: 215/255)
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    //header
                    Text(post.username + "'s Post")
                        .font(.custom("SF Pro Display",size:18))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color(red: 102/255, green: 82/255, blue: 56/255))
                        .frame(height: 58)
                    Divider()
                        .background(Color.gray)
                        .frame(maxWidth: .infinity)
                    
                    ScrollView{
                        // User Info and Options
                        Spacer().frame(height: 5)
                        HStack {
                            Image(systemName: post.userImage)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            Text(post.username)
                                .font(.custom("SF Pro Display",size:14))
                                .foregroundColor(Color(red: 102/255, green: 82/255, blue: 56/255))
                            
                            
                            Spacer()
                            Button {
                                showMenuSheet = true
                            } label: {
                                   Image(systemName: "ellipsis")
                                       .frame(width: 30, height: 30)
                                       .foregroundColor(.black)
                               }
                            
                        }
                        .padding(.horizontal,20)
                        Spacer().frame(height: 30)
                        // AR Image with Overlays
                        NavigationLink(destination: ARFeedView()) {
                            ZStack(alignment: .topLeading) {
                                Image(post.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(20)
                                RoundedRectangle(cornerRadius: 25)

                            }
                            .padding(.horizontal,22)
                        }
                        Spacer().frame(height: 30)
                        // Description
                        Text(post.description)
                            .font(.custom("SF Pro Display",size:16))
                            .padding(.horizontal,22)
                        Text(post.timeAgo)
                            .font(.custom("SF Pro Display",size:10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.horizontal,22)
                        Spacer().frame(height: 40)
                        //Featured
                        Text("Featured In This Post")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("SF Pro Display",size:18))
                            .foregroundColor(Color(red: 102/255, green: 82/255, blue: 56/255))
                            .padding(.horizontal,22)

                        HStack{
                            Circle()
                                .fill(.red)
                                .frame(width: 80)
                                .onTapGesture {
                                    showPopUp = true
                                }
                            Circle()
                                .fill(.blue)
                                .frame(width: 80)
                                .onTapGesture {
                                    showPopUp = true
                                }
                            
                        }
                        
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,22)
                    }
                    ZStack {
                        // Other content, such as background and ScrollView

                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.sRGB,red: 99/255, green: 83/255, blue: 70/255))
                            .frame(width: 362, height: 64)
                            .padding(.horizontal, 20)
//                            .zIndex(1)
                            .background(Color.clear)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        HStack{
                            Button {
                                if post.user_liked {
                                    post.likes -= 1
                                } else {
                                    post.likes += 1
                                }
                                post.user_liked.toggle()
                                
                            } label: {
                                   Image(systemName: post.user_liked ? "heart.fill" : "heart")
                                    .font(.custom("SF Pro Display",size:24))
                                    .foregroundColor(post.user_liked ? .red : .white)
                               }
                            Spacer()
                            Button {
                                showComments = true
                            } label: {
                                   Image(systemName: "bubble.left")
                                    .font(.custom("SF Pro Display",size:24))
                                       .foregroundColor(.white)
                               }
                            Spacer()
                            Button {
                                showMenuSheet = true
                            } label: {
                                   Image(systemName: "square.and.arrow.up")
                                    .font(.custom("SF Pro Display",size:24))
                                       .foregroundColor(.white)
                               }
                        }
                        .padding(.horizontal, 40) // Adds 20 margin to both sides of the HStack
                        .frame(maxWidth: .infinity)
                        
                    
                    }
                    
                
                }
                // Overlay the pop-up when showPopUp is true
                if showPopUp {
                    InformationPopUpView(didClose: {
                        showPopUp = false
                    })
                    .transition(.opacity)
                    .zIndex(1)
                }
                
            }
        }
        .sheet(isPresented: $showComments) {
            ZStack{
                Color(.sRGB,red: 249/255, green: 237/255, blue: 215/255)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer().frame(height: 5)
                    .background(Color(.sRGB,red: 249/255, green: 237/255, blue: 215/255))
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 5)
                    CommentSectionView(viewModel: post.commentsModel)
                }
                
                .padding(.horizontal,20)
            }
            .presentationDetents([.fraction(0.8)])

        }
        .sheet(isPresented: $showMenuSheet) {
            ZStack{
                Color(.sRGB,red: 249/255, green: 237/255, blue: 215/255)
                    .edgesIgnoringSafeArea(.all)
                Spacer().frame(height: 5)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 5)
                VStack() {
                    Button {
                        print("Option 1 tapped")
                    } label: {
                        Label("Share this post", systemImage: "square.and.arrow.up")
                            .cornerRadius(10)
                            .foregroundStyle(Color(.black))
                    }
                    Divider()
                    Button {
                        print("Option 2 tapped")
                    } label: {
                        Label("Hide this post", systemImage: "eye.slash")
                            .cornerRadius(10)
                            .foregroundStyle(Color(.black))
                    }
                    Divider()
                    Button {
                        print("Option 3 tapped")
                    } label: {
                        Label("Go to profile", systemImage: "person.circle")
                            .cornerRadius(10)
                            .foregroundStyle(Color(.black))
                    }
                }
                .padding(.vertical, 10)
                .background(Color(red: 102/255, green: 82/255, blue: 56/255,opacity: 0.31))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1))
                .padding(20)
                .presentationDetents([.fraction(0.3)])
                .background(Color(.sRGB,red: 249/255, green: 237/255, blue: 215/255))
            }
            
            

        }        
        
    }
}


#Preview {
    PostView(
        post:Post(
            username: "username",
            userImage: "person.circle.fill", // SF Symbol for user avatar
            title: "1990 Vintage",
            imageName: "ar_room1", // Replace with actual asset name
            tags: ["vintage", "retro", "vibe"],
            description: "Bold interior design project that revives the vibrant energy of the early '80s. It marries vivid color schemes, geometric patterns, and nostalgic accents with contemporary comforts.",
            timeAgo: "4 days ago",
            likes: 120)
    )
}
