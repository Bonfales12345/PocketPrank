import SwiftUI

extension AnyTransition {
    static func slideFromRight() -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active:   OffsetModifier(x:  500),
                identity: OffsetModifier(x:  0)
            ),
            removal: .modifier(
                active:   OffsetModifier(x: -500),
                identity: OffsetModifier(x:  0)
            )
        )
    }
}

private struct OffsetModifier: ViewModifier {
    let x: CGFloat
    func body(content: Content) -> some View {
        content.offset(x: x)
    }
}

struct PocketSetupFlowView: View {
    @EnvironmentObject private var setup: PocketSetupState

    var body: some View {
        VStack(spacing: 0) {
            header
            content
                .padding(.top, 16)
            Spacer(minLength: 12)
            footer
                .padding(.bottom, 8)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .presentationDetents([.height(470)])
        .presentationBackground(Color.white)
        .presentationCornerRadius(44)
        .presentationDragIndicator(.hidden)
    }

    @ViewBuilder
    private var header: some View {
        HStack {
            Spacer()
            if setup.step == .intro {
                Button {
                    setup.isPresentingSetup = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.55))
                        .frame(width: 28, height: 28)
                        .background(Color.black.opacity(0.08), in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 28)
    }

    @ViewBuilder
    private var content: some View {
        Group {
            switch setup.step {
            case .intro:       IntroStepView()
            case .swayDamping: SwayDampingStepView()
            case .osUpdate:    OSUpdateStepView()
            case .appInstall:  AppInstallStepView()
            case .installing:  InstallingStepView()
            case .complete:    CompleteStepView()
            }
        }
        .frame(maxWidth: .infinity)
        .id(setup.step)
        .transition(.slideFromRight())
    }

    @ViewBuilder
    private var footer: some View {
        switch setup.step {
        case .intro:
            GlassButtonRow(primaryTitle: "Set Up", showsSecondary: false) {
                setup.advance()
            } secondaryAction: { }

        case .swayDamping:
            GlassButtonRow(primaryTitle: "Continue", showsSecondary: false) {
                setup.advance()
            } secondaryAction: { }

        case .osUpdate:
            GlassButtonRow(primaryTitle: "Update", secondaryTitle: "Later") {
                setup.advance()
            } secondaryAction: {
                setup.skip()
            }

        case .appInstall:
            GlassButtonRow(primaryTitle: "Install", secondaryTitle: "Later") {
                setup.advance()
            } secondaryAction: {
                setup.skip()
            }

        case .installing:
            EmptyView()

        case .complete:
            GlassButtonRow(primaryTitle: "Done", showsSecondary: false) {
                setup.finish()
            } secondaryAction: { }
        }
    }
}

private struct GlassButtonRow: View {
    let primaryTitle: String
    var secondaryTitle: String? = nil
    var showsSecondary: Bool = true
    let primaryAction: () -> Void
    let secondaryAction: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Button(action: primaryAction) {
                Text(primaryTitle)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.glassProminent)
            .tint(.blue)

            if showsSecondary, let secondaryTitle {
                Button(action: secondaryAction) {
                    Text(secondaryTitle)
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.glass)
            }
        }
        .padding(.top, 12)
    }
}

private struct IntroStepView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("iPhone Pocket")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            PocketProductImage()
                .frame(height: 150)

            Text("Set up your iPhone Pocket to enable MagSafe pairing, Sway Damping, and Find My integration.")
                .font(.system(size: 15))
                .foregroundColor(Color.black.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
        }
    }
}

private struct SwayDampingStepView: View {
    @EnvironmentObject private var setup: PocketSetupState

    var body: some View {
        VStack(spacing: 16) {
            Text("Sway Damping")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            PocketProductImage()
                .frame(height: 130)

            VStack(spacing: 10) {
                Slider(value: $setup.swayValue)
                    .tint(.blue)

                Text("Drag the slider to adjust how freely your iPhone Pocket swings while in motion.")
                    .font(.system(size: 13))
                    .foregroundColor(Color.black.opacity(0.55))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 4)
        }
    }
}

private struct OSUpdateStepView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("PocketOS 27")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            PocketOSIcon()
                .frame(width: 110, height: 110)
                .shadow(radius: 8, y: 4)

            Text("This is a Beta Version. Performance and Security may suffer.")
                .font(.system(size: 15))
                .foregroundColor(Color.black.opacity(0.55))
                .multilineTextAlignment(.center)
        }
    }
}

private struct AppInstallStepView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Pocket App")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(colors: [Color(red: 0.4, green: 0.65, blue: 1.0),
                                                 Color(red: 0.05, green: 0.3, blue: 0.95)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 46, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 110, height: 110)
            .shadow(radius: 8, y: 4)

            Text("The Pocket app is required to pair your accessory and manage settings.")
                .font(.system(size: 15))
                .foregroundColor(Color.black.opacity(0.55))
                .multilineTextAlignment(.center)
        }
    }
}

private struct InstallingStepView: View {
    @EnvironmentObject private var setup: PocketSetupState

    var body: some View {
        VStack(spacing: 16) {
            Text("Pocket App")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(colors: [Color(red: 0.4, green: 0.65, blue: 1.0),
                                                 Color(red: 0.05, green: 0.3, blue: 0.95)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .overlay {
                        Circle()
                            .trim(from: 0, to: setup.installProgress)
                            .stroke(.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .padding(6)
                    }
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 46, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 110, height: 110)
            .shadow(radius: 8, y: 4)

            VStack(spacing: 6) {
                Text("Installing…")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
                Text("\(Int(setup.installProgress * 100))%")
                    .font(.system(size: 13))
                    .foregroundColor(Color.black.opacity(0.55))
                    .contentTransition(.numericText())
            }
            .padding(.top, 4)
        }
        .padding(.bottom, 20)
    }
}

private struct CompleteStepView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Setup Complete")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            PocketProductImage()
                .frame(height: 150)

            Text("Your iPhone Pocket is ready to use.")
                .font(.system(size: 15))
                .foregroundColor(Color.black.opacity(0.55))
        }
    }
}

private struct PocketProductImage: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.white)
            .overlay {
                Image("iphonepocket")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(16)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.07), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct PocketOSIcon: View {
    var body: some View {
        Image("pocketos")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}
