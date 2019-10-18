func < <T> (_ lhs: T?, _ rhs: T?) -> Bool where T : Comparable {
    switch (lhs == nil, rhs == nil) {
    case (false, false):
        return lhs! < rhs!
    case (true, true):
        return false
    case (true, false):
        return true
    case (false, true):
        return false
    }
}
