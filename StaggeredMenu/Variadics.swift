import SwiftUI

extension View {
    func variadic<R: View>(_ transform: @escaping (_VariadicView.Children) -> R) -> some View {
        _VariadicView.Tree(Helper(transform: transform), content: {
            self
        })
    }
}

struct Helper<R: View>: _VariadicView.MultiViewRoot {
    var transform: (_VariadicView.Children) -> R

    func body(children: _VariadicView.Children) -> some View {
        transform(children)
    }
}
