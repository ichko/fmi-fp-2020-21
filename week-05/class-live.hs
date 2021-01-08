data BinTree a
  = Empty
  | Node a (BinTree a) (BinTree a)
  deriving (Show)

pushBST :: Ord t => t -> BinTree t -> BinTree t
pushBST el Empty = Node el Empty Empty
pushBST el t@(Node root left right)
  | el == root = t
  | el > root = Node root left (pushBST el right)
  | otherwise = Node root (pushBST el left) right

elemBST :: Ord t => t -> BinTree t -> Bool
elemBST _ Empty = False
elemBST el (Node root left right)
  | el == root = True
  | el > root = elemBST el right
  | otherwise = elemBST el left
