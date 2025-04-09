//
//  PostView.swift
//  ARchitect
//
//  Created by Amiire kolawole on 2025-03-03.
//

import SwiftUI

struct PostView: View {
    @ObservedObject var post: Post
    @State private var showComments = false
    @State private var showMenuSheet = false
    @State private var showPopUp = false
    @State private var showPopUpIndex: Int? = nil
    
    let environment: VREnvironmentConfig
    let objects: [VREnvironmentConfig.VRObjectConfig]
    
    init(post: Post, showComments: Bool = false) {
        let postID = post.id
        
        self.post = post
        self.showComments = showComments
        
        //Firebase call for getting an environment with just the post ID
        let environments = [VREnvironmentConfig(postID: postID)]
        environment = environments.first(where: { $0.id == postID}) ?? VREnvironmentConfig(postID: postID)
        
        objects = environment.objects
    }
    
    var body: some View {
        VStack {
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
                        
                        ARSessionView2(config: environment)
                            .aspectRatio(16/9, contentMode: .fit)
                            .cornerRadius(12)
                            .padding(.horizontal, 22)
                        
                        Spacer().frame(height: 30)
                        // Description
                        Text(post.description)
                            .font(.custom("SF Pro Display",size:16))
                            .padding(.horizontal,22)
                        Spacer().frame(height: 10)
                        Text(post.time_ago())
                            .font(.custom("SF Pro Display",size:12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.horizontal,22)
                        Spacer().frame(height: 20)
                        //Featured
                        FeaturedInPost(objects: objects, showPopUp: $showPopUp, showPopUpIndex: $showPopUpIndex)
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
                                post.user_liked.toggle()
                                post.likes += post.user_liked ? 1 : -1
                                
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
                        .padding(.horizontal, 60) // Adds 20 margin to both sides of the HStack
                        .frame(maxWidth: .infinity)
                        
                    
                    }
                    
                
                }
                
            }
            
            if showPopUp, let index = showPopUpIndex {
                GalleryView(
                    objects: objects,
                    isPresented: $showPopUp,
                    currentImageIndex: index
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .sheet(isPresented: $showComments) {
            CommentSectionView(viewModel: $post.commentsModel)
        }
        .sheet(isPresented: $showMenuSheet) {
            MenuSheet(post: post)
        }
        
    }
}


struct FeaturedInPost: View {
    @State var objects: [VREnvironmentConfig.VRObjectConfig]
    @Binding var showPopUp: Bool
    @Binding var showPopUpIndex: Int?
    let filters = [
        ("Chairs", "chair.fill"),
        ("Drawers", "archivebox.fill"),
        ("Lights", "lightbulb.fill"),
        ("Beds", "bed.double.fill"),
        ("Sofas", "couch.fill"),
        ("Desks", "desk.fill"),
        ("Shelves", "books.vertical.fill")
    ]
    let colors: [Color] = [.red, .green, .blue, .orange, .purple]
    
    var body: some View {
        Text("Featured In This Post")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.custom("SF Pro Display",size:18))
            .foregroundColor(Color(red: 102/255, green: 82/255, blue: 56/255))
            .padding(.horizontal,22)

        HStack {
            let objectsWithIndices = Array(objects.enumerated())
            
            ForEach(objectsWithIndices, id: \.element.id) { index, object in
                let imageName = filters.first(where: { $0.0 == object.filter })?.1 ?? "questionmark.circle.fill"
                Button {
                    showPopUpIndex = index
                    showPopUp.toggle()
                } label: {
                    Image(systemName: imageName)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(colors[index % colors.count].opacity(0.2))
                        .clipShape(Circle())
                }
            }
            
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal,22)
    }
}


struct GalleryView: View {
    let objects: [VREnvironmentConfig.VRObjectConfig]
    @Binding var isPresented: Bool
    @State var currentImageIndex: Int = 0
    let filters = [
        ("Chairs", "chair.fill"),
        ("Drawers", "archivebox.fill"),
        ("Lights", "lightbulb.fill"),
        ("Beds", "bed.double.fill"),
        ("Sofas", "couch.fill"),
        ("Desks", "desk.fill"),
        ("Shelves", "books.vertical.fill")
    ]
    
    var body: some View {
        ZStack {
            Color(.sRGB,red: 249/255, green: 237/255, blue: 215/255)
                .ignoresSafeArea()
            
            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Gallery
                TabView(selection: $currentImageIndex) {
                    ForEach(0..<objects.count, id: \.self) { index in
                        let imageName = filters.first(where: { $0.0 == objects[index].filter })?.1 ?? "questionmark.circle.fill"
                        VStack {
                            Text(objects[index].displayName)
                                .font(.title)
                                .padding(.bottom)
                            
                            Image(systemName: imageName)
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                            
                            // Description
                            Text(objects[index].description)
                                .padding()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .padding()
        }
    }
}


#Preview {
    @Previewable @State var post = Post(
        username: "username",
        userImage: "person.circle.fill",
        title: "1990 Vintage",
        imageName: "ar_room1",
        description: "Bold interior design project that revives the vibrant energy of the early '80s.",
        likes: 120
    )
    
    PostView(post: post)
}
