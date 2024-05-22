
import SwiftUI

struct LoginView: View {
    @State private var name: String = ""
    @State private var company: String = ""
    @State private var carNumber: String = ""
    @State private var isChecked: Bool = false
    @State private var isLoginPressed: Bool = false
    
    var body: some View {
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
                TextField("Enter your name", text: $name)
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
                TextField("Enter your company", text: $company)
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
                TextField("Enter your car number", text: $carNumber)
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
            
//            Spacer().frame(height: 10) // Add spacing below the HStack
//
//            NavigationLink(destination: NextView()) {
//                Image("buttonLogin")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: UIScreen.main.bounds.width * 0.8)
//                    .scaleEffect(isLoginPressed ? 0.95 : 1.0)
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.2)) {
//                            isLoginPressed.toggle()
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                            isLoginPressed.toggle()
//                        }
//                    }
//            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    LoginView()
}
