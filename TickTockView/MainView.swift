import SwiftUI

struct MainView: View {
    var body: some View {
        // 倒數 60 秒
        TickTockView(
            futureDate: Calendar.current.date(byAdding: .minute, value: 60, to: Date())!
        )
        .frame(width: 200, height: 100)
    }
}

struct TickTockView: View {
    let futureDate: Date
    
    // 每秒更新一次
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var now = Date()
    @State private var animate = true  // 控制縮放動畫

    // 剩餘秒數
    var remaining: Int {
        Int(max(0, (futureDate.timeIntervalSince(now))))
    }

    var body: some View {
        HStack {
            Image(systemName: "timer")
                .imageScale(.large)
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(.white)
            
            Spacer().frame(width:10)
            
            // 倒數計時文字
            Text(remaining, format: .number)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: 70)
                .contentTransition(.numericText()) // 數字翻頁效果
                .animation(.easeInOut(duration: 0.1), value: animate)
                .padding(.all, 8)
        }
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.3),
                            Color.indigo.opacity(0.8),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .onReceive(timer) { time in
            // 加入翻頁 & 縮放動畫
            withAnimation(.snappy) {
                now = time
            }
            animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animate = false
            }
        }
    }
}

// MARK: - 預覽
struct TickTockView_Previews: PreviewProvider {
    static var previews: some View {
        TickTockView(
            futureDate: Calendar.current.date(byAdding: .second, value: 1000, to: Date())!
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
