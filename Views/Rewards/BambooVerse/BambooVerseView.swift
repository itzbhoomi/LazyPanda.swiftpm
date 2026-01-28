import SwiftUI
import SwiftData

struct BambooVerseView: View {

    @EnvironmentObject var coinManager: CoinManager
    @Environment(\.modelContext) private var modelContext

    @Query private var items: [BambooVerseItemEntity]

    // MARK: - Shop inventory
    private let shopItems: [BambooItem] = [
        BambooItem(name: "Flowers", imageName: "flowers", price: 10),
        BambooItem(name: "Bamboo chairs & table", imageName: "chairs", price: 20),
        BambooItem(name: "Lanterns", imageName: "lanterns", price: 60),
        BambooItem(name: "Gazebo", imageName: "gazebo", price: 100)
    ]

    @State private var showShop = false
    @State private var sparkleItemID: UUID?

    // MARK: - Alerts
    @State private var showMessage = false
    @State private var messageText = ""

    @State private var showDeleteAlert = false
    @State private var itemToDelete: BambooVerseItemEntity?

    // MARK: - Selection & Slider
    @State private var selectedItemID: UUID?
    @State private var sliderValue: CGFloat = 1.0

    var body: some View {
        ZStack {

            Image("bambooverse")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            header

            // MARK: - Placed Items
            ForEach(items) { item in
                ZStack {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 160 * item.scale,
                            height: 160 * item.scale
                        )
                        .shadow(
                            color: selectedItemID == item.id
                                ? .yellow.opacity(0.6)
                                : .clear,
                            radius: 12
                        )
                        .shadow(
                            color: selectedItemID == item.id
                                ? .blue.opacity(0.35)
                                : .clear,
                            radius: 24
                        )
                        .onTapGesture {
                            if selectedItemID == item.id {
                                selectedItemID = nil
                            } else {
                                selectedItemID = item.id
                                sliderValue = item.scale
                            }
                        }
                        .onLongPressGesture(minimumDuration: 0.6) {
                            itemToDelete = item
                            showDeleteAlert = true
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if selectedItemID == item.id {
                                        item.position = value.location
                                    }
                                }
                        )

                    if sparkleItemID == item.id {
                        SparkleView()
                            .offset(x: 20, y: -20)
                    }
                }
                .position(item.position)
            }

            sizeSlider
            shopButton
            shopSheet
        }
        // ✅ Modifiers MUST be here
        .animation(.easeInOut(duration: 0.25), value: showShop)

        // MARK: - Delete Alert
        .alert("Remove this item?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let item = itemToDelete {
                    modelContext.delete(item)
                    if selectedItemID == item.id {
                        selectedItemID = nil
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This item will be permanently removed from your BambooVerse.")
        }

        // MARK: - Info Alert
        .alert(messageText, isPresented: $showMessage) {
            Button("OK", role: .cancel) {}
        }
    }
}

private extension BambooVerseView {

    var header: some View {
        VStack {
            Text("Your BambooVerse")
                .font(.custom("Cochin", size: 26))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [.black, .brown],
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .cornerRadius(40)
                .padding(.top, 16)
            Spacer()
        }
    }

    var sizeSlider: some View {
        Group {
            if let selectedID = selectedItemID,
               let item = items.first(where: { $0.id == selectedID }) {

                VStack {
                    Spacer()
                    Slider(
                        value: Binding(
                            get: { sliderValue },
                            set: {
                                sliderValue = $0
                                item.scale = $0
                            }
                        ),
                        in: 0.5...2.0,
                        step: 0.05
                    )
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .accentColor(.brown)
                    .padding(.bottom, 100)
                }
            }
        }
    }

    var shopButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation { showShop = true }
                } label: {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            LinearGradient(colors: [.black, .brown],
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                        .clipShape(Circle())
                        .shadow(radius: 6)
                }
                .padding(.trailing, 44)
                .padding(.bottom, 92)
            }
        }
    }

    var shopSheet: some View {
        Group {
            if showShop {
                BambooShopSheet(
                    items: shopItems,
                    balance: coinManager.wallet.balance,
                    onBuy: { item in
                        if coinManager.spend(item.price, reason: .bambooVerseItem) {

                            let newItem = BambooVerseItemEntity(
                                name: item.name,
                                imageName: item.imageName,
                                price: item.price,
                                position: CGPoint(x: 200, y: 400),
                                scale: 1.0
                            )

                            modelContext.insert(newItem)

                            sparkleItemID = newItem.id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                sparkleItemID = nil
                            }

                            messageText = "Yay! Your BambooVerse just got cozier ✨"
                        } else {
                            messageText = "Oh no… this item needs more coins 🥺"
                        }

                        showMessage = true
                    },
                    onClose: {
                        withAnimation { showShop = false }
                    }
                )
            }
        }
    }
}
