import SwiftUI

// MARK: - Chat Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let role: MessageRole
    let text: String
    let timestamp: Date

    enum MessageRole {
        case user, ai, error
    }
}

// MARK: - AI Chat View Model
@MainActor
class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var inputText = ""

    private let service = GeminiService()

    private var geminiHistory: [GeminiService.GeminiMessage] {
        messages.compactMap { msg in
            guard msg.role != .error else { return nil }
            return GeminiService.GeminiMessage(
                role: msg.role == .user ? "user" : "model",
                text: msg.text
            )
        }
    }

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isLoading else { return }

        inputText = ""
        messages.append(ChatMessage(role: .user, text: text, timestamp: Date()))
        isLoading = true

        // Pass history EXCLUDING the last user message (already captured above)
        let historyForAPI = Array(geminiHistory.dropLast())

        service.sendMessage(history: historyForAPI, newMessage: text) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            switch result {
            case .success(let reply):
                self.messages.append(ChatMessage(role: .ai, text: reply, timestamp: Date()))
            case .failure(let error):
                self.messages.append(ChatMessage(role: .error, text: "⚠️ \(error.localizedDescription)", timestamp: Date()))
            }
        }
    }

    func clearChat() { messages = [] }
}

// MARK: - Quick Suggestion Chips
private let suggestions = [
    "Explain Newton's Laws 🔬",
    "Quiz me on Science ⚡",
    "Help with English grammar 📝",
    "What is photosynthesis? 🌿",
    "Explain Ohm's Law 💡",
    "Translate to Sinhala 🇱🇰"
]

// MARK: - Main Chat View
struct AIChatView: View {
    @StateObject private var viewModel = AIChatViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isInputFocused: Bool
    @State private var showClearAlert = false

    var body: some View {
        VStack(spacing: 0) {
            chatHeader

            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        if viewModel.messages.isEmpty {
                            emptyStateView
                        } else {
                            ForEach(viewModel.messages) { msg in
                                MessageBubble(message: msg)
                                    .id(msg.id)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                            }
                            if viewModel.isLoading {
                                TypingIndicator()
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                                    .id("typing")
                            }
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, minHeight: 600)
                    .contentShape(Rectangle())
                }
                .contentShape(Rectangle())
                // ✅ Dismiss keyboard when tapping the scroll area
                .onTapGesture { isInputFocused = false }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isLoading) { loading in
                    if loading { withAnimation { proxy.scrollTo("typing", anchor: .bottom) } }
                }
            }

            inputBar
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .bottom)
        .alert("Clear Conversation?", isPresented: $showClearAlert) {
            Button("Clear", role: .destructive) { viewModel.clearChat() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all messages in this conversation.")
        }
    }

    // MARK: – Header
    private var chatHeader: some View {
        HStack(spacing: 12) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }

            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "#6C63FF"), Color(hex: "#1A73E8")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .shadow(color: Color(hex: "#1A73E8").opacity(0.4), radius: 6, y: 2)

            VStack(alignment: .leading, spacing: 1) {
                Text("Praklyne AI")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                HStack(spacing: 5) {
                    Circle().fill(Color.green).frame(width: 7, height: 7)
                    Text("Online · Educational Assistant")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.85))
                }
            }

            Spacer()

            if !viewModel.messages.isEmpty {
                Button(action: { showClearAlert = true }) {
                    Image(systemName: "trash")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .padding(.top, safeAreaTop())
        .background(
            LinearGradient(
                colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
    }

    // MARK: – Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 20)

            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "#1A73E8").opacity(0.12), Color(hex: "#6C63FF").opacity(0.12)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 48))
                    .foregroundStyle(LinearGradient(
                        colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
            }

            VStack(spacing: 8) {
                Text("Ask Me Anything!")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("I'm your personal AI learning assistant.\nAsk me to explain topics, quiz you, or help\nwith English grammar and vocabulary.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Try asking:")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(suggestions, id: \.self) { chip in
                        Button(action: {
                            viewModel.inputText = chip
                            viewModel.sendMessage()
                        }) {
                            Text(chip)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#1A73E8"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#1A73E8").opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color(hex: "#1A73E8").opacity(0.2), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 8)

            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(minHeight: 480)
    }

    // MARK: – Input Bar
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .bottom, spacing: 12) {

                // ── Text field ──
                HStack(spacing: 8) {
                    TextField("Ask anything...", text: $viewModel.inputText, axis: .vertical)
                        .font(.system(size: 15))
                        .lineLimit(1...4)
                        .focused($isInputFocused)

                    if !viewModel.inputText.isEmpty {
                        Button(action: { viewModel.inputText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                // ── Send button (always visible, changes style based on state) ──
                Button(action: {
                    isInputFocused = false
                    viewModel.sendMessage()
                }) {
                    ZStack {
                        // ✅ Use a ZStack with two overlapping circles to avoid
                        // the broken LinearGradient.asColor() issue
                        if viewModel.isLoading {
                            Circle()
                                .fill(Color(.systemFill))
                                .frame(width: 40, height: 40)
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.secondary)
                        } else if viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Circle()
                                .fill(Color(.systemFill))
                                .frame(width: 40, height: 40)
                            Image(systemName: "arrow.up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.secondary)
                        } else {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 40, height: 40)
                                .shadow(color: Color(hex: "#1A73E8").opacity(0.4), radius: 6, y: 2)
                            Image(systemName: "arrow.up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.2), value: viewModel.inputText.isEmpty)
                .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))

            Color(.systemBackground)
                .frame(height: safeAreaBottom())
        }
    }

    private func safeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 44
    }

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ChatMessage

    var isUser: Bool  { message.role == .user }
    var isError: Bool { message.role == .error }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 60) }

            if !isUser {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 28, height: 28)
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 3) {
                Text(message.text)
                    .font(.system(size: 15))
                    .foregroundColor(isUser ? .white : (isError ? .red : .primary))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        Group {
                            if isUser {
                                LinearGradient(
                                    colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            } else if isError {
                                Color.red.opacity(0.08)
                            } else {
                                Color(.secondarySystemBackground)
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(
                        color: isUser ? Color(hex: "#1A73E8").opacity(0.25) : Color.black.opacity(0.05),
                        radius: 4, y: 2
                    )

                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.7))
                    .padding(.horizontal, 4)
            }

            if !isUser { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Typing Indicator (animated dots)
struct TypingIndicator: View {
    @State private var animate = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 28, height: 28)
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
            }

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.secondary.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .scaleEffect(animate ? 1.35 : 0.75)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: animate
                        )
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)

            Spacer(minLength: 60)
        }
        .onAppear { animate = true }
    }
}
