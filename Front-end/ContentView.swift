//
//  ContentView.swift
//  Front-end
//
//  Created by Abdullah Alnutayfi on 07/08/2022.
//

import SwiftUI
import PartialSheet
struct ContentView: View {
    
    @State var isPresented = false
    @State var currentId = ""
    @State var titlee = ""
    @State var des = ""
    @State var toBeUpdatedTitle = ""
    @State var toBeUpdatedDes = ""
    @State var identifier = ""
    @StateObject  var vm : ViewModel
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGray3)
            VStack{
            VStack{
                TextField("Title", text: $titlee)
                    .frame(width: 280, height: 40)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top)
                    .foregroundColor(.black)
                TextField("Description", text: $des)
                    .frame(width: 280, height: 40)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Button {
                    
                    identifier = UUID().uuidString
                    vm.http_request(HTTP_METHOD: "POST", id: identifier,toDoTitle: titlee, toDoDes: des, endPoint: nil)
                    
                    //  save the data into the list temporarily
                    vm.toTos.append(ToDoPOST(_id: identifier, toDoTitle: titlee, toDoDes: des, date: vm.dateFormater.string(from: Date())))
                } label: {
                    RoundedRectangle(cornerRadius:20).foregroundColor(Color(.darkGray))
                        .frame(width: 300,height :40, alignment: .center)
                        .overlay(
                            Text("Add")
                                .foregroundColor(.white)
                    )
                }.padding()
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color(.systemGray5))
            List{
                ForEach(vm.toTos.sorted(by: { d1, d2 in
                    d1.date > d2.date
                })){ toDo in
                    Button(action:{
                        isPresented.toggle()
                        currentId = toDo._id
                        toBeUpdatedDes = toDo.toDoDes
                        toBeUpdatedTitle = toDo.toDoTitle
                        print("#######"+currentId)
                    }){
                    HStack{
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        VStack(alignment:.leading){
                            Text(toDo.toDoTitle)
                            Text(toDo.toDoDes)
                        }
                        Spacer()
                        Button(action: {
                            currentId = toDo._id
                            vm.http_request(HTTP_METHOD: "DELETE", id: currentId, toDoTitle: nil, toDoDes: nil, endPoint: currentId)
                            print(currentId)
                            //  delete the data from the list temporarily
                            vm.toTos.removeAll{$0._id == currentId}
                        }){
                            Image(systemName: "trash")
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            vm.http_request(HTTP_METHOD: "GET", id: nil, toDoTitle: nil, toDoDes: nil, endPoint: nil)
            }
        }
     
    }.edgesIgnoringSafeArea(.bottom)
          .partialSheet(isPresented: $isPresented) {
              VStack{
                  TextField("toDo title", text: $toBeUpdatedTitle)
                      .frame(width: 350)
                  TextField("toDo des", text: $toBeUpdatedDes)
                      .frame(width: 350, height: 40)
                  Button {
                      vm.http_request(HTTP_METHOD: "PATCH", id: currentId, toDoTitle: toBeUpdatedTitle, toDoDes: toBeUpdatedDes, endPoint: currentId)
                      print("#######"+currentId)
                      
                      //  delete the prev data from the list temporarily
                      vm.toTos.removeAll{$0._id == currentId}
                      
                      //  save updated data into the list temporarily
                      vm.toTos.append( ToDoPOST(_id: currentId ,toDoTitle: toBeUpdatedTitle, toDoDes: toBeUpdatedDes, date: vm.dateFormater.string(from: Date())))
                     
                  } label: {
                      RoundedRectangle(cornerRadius:20).foregroundColor(Color(.darkGray))
                          .frame(width: 300,height :40, alignment: .center)
                          .overlay(
                              Text("Update")
                                  .foregroundColor(.white)
                      )
                  }
              }.ignoresSafeArea()
                 
               } .toolbar {
                   ToolbarItem(placement: .principal) {
                       Image(uiImage: UIImage(named: "galen-crout-GVVRHcmd__I-unsplash") ?? UIImage())
                           .resizable()
                           .frame(width: UIScreen.main.bounds.width, height: 150)
                           .scaledToFill()
                   }}
        }
    .attachPartialSheetToRoot()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm:ViewModel())
    }
}
