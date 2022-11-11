//
//  ContentView.swift
//  StaggeredMenu
//
//  Created by Chris Eidhof on 02.11.22.
//

import SwiftUI

struct MenuAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context[HorizontalAlignment.center]
    }
}

extension HorizontalAlignment {
    static let menu = HorizontalAlignment(MenuAlignment.self)
}

struct MenuLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
                .frame(width: 40, height: 40)
                .background {
                    Circle()
                        .foregroundColor(.primary.opacity(0.1))
                }
                .alignmentGuide(.menu, computeValue: {
                    $0[HorizontalAlignment.center]
                })
        }
        .font(.footnote)
    }
}

struct Staggered: ViewModifier {
    var open: Bool
    var delay: Double

    func body(content: Content) -> some View {
        VStack {
            if open {
                content
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.default.delay(delay), value: open)
   }
}

extension View {
    func stagger(open: Bool, delay: Double) -> some View {
        modifier(Staggered(open: open, delay: delay))
    }
}

struct StaggeredItems<Content: View>: View {
    var open: Bool
    @ViewBuilder var content: Content

    var body: some View {
        content.variadic { views in
            ForEach(Array(views.enumerated()), id: \.offset) { (offset, element) in
                let delay = open ? views.count-1-offset : offset
                element
                    .stagger(open: open, delay: Double(delay) * 0.3)
            }
        }
    }
}

struct Menu: View {

    @State private var open = false
    var body: some View {
        VStack(alignment: .menu) {
            StaggeredItems(open: open) {
                Label("Add Note", systemImage: "note.text")
                Label("Add Photo", systemImage: "photo")
                Label("Add Video", systemImage: "video")
            }
            Button {
                open.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .frame(width: 50, height: 50)
                    .background {
                        Circle()
                            .fill(Color.primary.opacity(0.1))
                    }
            }
        }
        .labelStyle(MenuLabelStyle())
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            Menu()
                .padding(30)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
