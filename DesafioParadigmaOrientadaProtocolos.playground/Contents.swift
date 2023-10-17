import UIKit

protocol Pedido {
    var id: Int { get }
    var itens: [ItemPedido] { get set }
    var valorTotal: Double { get }
    
    mutating func adicionarItem(_ item: ItemPedido)
    mutating func removerItem(_ item: ItemPedido)
    func listarItens()
}


struct PedidoOnline: Pedido {
    let id: Int
    var itens: [ItemPedido]
    
    var valorTotal: Double {
        return itens.reduce(0.0) { $0 + $1.subtotal }
    }
    
    mutating func adicionarItem(_ item: ItemPedido) {
        itens.append(item)
    }
    
    mutating func removerItem(_ item: ItemPedido) {
        if let index = itens.firstIndex(of: item) {
            itens.remove(at: index)
        }
    }
    
    func listarItens() {
        print("Itens do pedido:")
        for item in itens {
            print("\(item.quantidade) x \(item.produto.descricao) - R$ \(item.subtotal)")
        }
        print("Valor total: R$ \(valorTotal)")
    }
}


protocol Produto: Equatable {
    var codigo: String { get }
    var descricao: String { get }
    var preco: Double { get }
}


struct ProdutoSimples: Produto {
    let codigo: String
    let descricao: String
    let preco: Double
}


struct ItemPedido: Equatable {
    let produto: any Produto
    let quantidade: Int
    
    var subtotal: Double {
        return Double(quantidade) * produto.preco
    }
    
    static func ==(lhs: ItemPedido, rhs: ItemPedido) -> Bool {
        return lhs.produto.codigo == rhs.produto.codigo && lhs.quantidade == rhs.quantidade
    }
}


var pedido = PedidoOnline(id: 1, itens: [])

let produto1 = ProdutoSimples(codigo: "001", descricao: "X-Tudo", preco: 30.0)
let produto2 = ProdutoSimples(codigo: "002", descricao: "Cachorro Quente", preco: 10.0)

let item1 = ItemPedido(produto: produto1, quantidade: 2)
let item2 = ItemPedido(produto: produto2, quantidade: 3)

pedido.adicionarItem(item1)
pedido.adicionarItem(item2)
pedido.listarItens()
pedido.removerItem(item1)
pedido.listarItens()
