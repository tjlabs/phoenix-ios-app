
import SwiftUI

struct LoginView: View {
    @State var path = NavigationPath()
    
    @State private var name: String = ""
    @State private var company: String = ""
    @State private var carNumber: String = ""
    @State private var isChecked: Bool = false
    @State private var isLoginPressed: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                HStack {
                    Text("운전자 명")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.3)
                        .padding(.leading)
                    Text(" : ")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.1)
                        .padding(.leading)
                    TextField("필수 입력", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.6)
                        .padding(.trailing)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                
                HStack {
                    Text("소속")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.3)
                        .padding(.leading)
                    Text(" : ")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.1)
                        .padding(.leading)
                    TextField("필수 입력", text: $company)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.6)
                        .padding(.trailing)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                
                HStack {
                    Text("차량 번호")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.3)
                        .padding(.leading)
                    Text(" : ")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.1)
                        .padding(.leading)
                    TextField("필수 입력", text: $carNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.main.bounds.width * 0.8 * 0.6)
                        .padding(.trailing)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                
                HStack {
                    Text("사용자 정보 저장").font(.system(size: 10))
                    Spacer().frame(width: 10)
                    Image(isChecked ? "checkedBox" : "uncheckedBox")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isChecked.toggle()
                        }
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .trailing)
                
                Spacer().frame(height: 10)
//                NavigationLink(destination: NewView()) {
//                    Image("buttonLogin")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: UIScreen.main.bounds.width * 0.8)
//                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    LoginView()
}
