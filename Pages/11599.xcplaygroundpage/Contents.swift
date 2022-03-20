import Foundation

struct DoubleStackQueue<Element> {
    private var inbox: [Element] = []
    private var outbox: [Element] = []
    
    var isEmpty: Bool{
        return inbox.isEmpty && outbox.isEmpty
    }
    
    var count: Int{
        return inbox.count + outbox.count
    }
    
    var front: Element? {
        return outbox.last ?? inbox.first
    }
    
    init() { }
    
    init(_ array: [Element]) {
        self.init()
        self.inbox = array
    }
    
    mutating func enqueue(_ n: Element) {
        inbox.append(n)
    }
    
    mutating func dequeue() -> Element {
        if outbox.isEmpty {
            outbox = inbox.reversed()
            inbox.removeAll()
        }
        return outbox.removeLast()
    }
}

extension DoubleStackQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.init()
        inbox = elements
    }
}


let dx = [0,1,0,-1]
let dy = [1,0,-1,0]

struct Point: Hashable {
    let x: Int
    let y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}
func solution() -> Int {
    var board = [[String]]()
    for _ in 0..<12 {
        board.append(readLine()!.map{String($0)})
    }
    
    func isBound(_ xx: Int, _ yy: Int) -> Bool {
        return xx >= 0 && yy >= 0 && xx < 12 && yy < 6
    }
    
    func burst() -> Bool{
        var answer = true
        var newBoard = board
        var q = DoubleStackQueue<Point>()
        for i in 0..<12 {
            for j in 0..<6 {
                if newBoard[i][j] == "." {
                    continue
                }
                let flag = newBoard[i][j]
                q.enqueue(Point(i, j))
                var visited = Set<Point>()
                while !q.isEmpty {
                    let a = q.dequeue()
                    for k in 0..<4{
                        let xx = a.x+dx[k]
                        let yy = a.y+dy[k]
                        if !isBound(xx, yy) || newBoard[xx][yy] != flag { continue }
                        let p = Point(xx, yy)
                        if visited.contains(p) { continue }
                        q.enqueue(p)
                        visited.insert(p)
                    }
                }
                
                if visited.count > 3 {
                    answer = false
                    for p in visited {
                        newBoard[p.x][p.y] = "."
                    }
                }
            }
        }
        board = newBoard
        return answer
    }
    
    func assemble() {
        for i in 0..<6{
            var q = DoubleStackQueue<String>()
            for j in stride(from: 11, to: -1, by: -1) {
                if board[j][i] != "." {
                    q.enqueue(board[j][i])
                }
            }
            for j in stride(from: 11, to: -1, by: -1) {
                board[j][i] = q.isEmpty ? "." : q.dequeue()
            }
        }
    }
    
    var ans = 0
    while !burst() {
        assemble()
        ans += 1
    }
    return ans
}

print(solution())
