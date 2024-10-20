-- 4.1 4.2 4.3 4.5 4.6 4.7 4.8

data Arv a = Vazia | No a (Arv a) (Arv a) deriving (Show)

-- 4.1

sumArv :: Num a => Arv a -> a
sumArv Vazia = 0
sumArv (No n left right) = n + sumArv left + sumArv right

-- 4.2

listar :: Arv a -> [a]
listar Vazia = []
listar (No n left right) = listar right ++ [n] ++ listar left

-- 4.3

nivel :: Int → Arv a → [a]
nivel _ Vazia = []
nivel 0 (No x _ _ ) = [x]
nivel n (No _ left right) = nivel (n-1) left ++ nivel (n-1) right

-- 4.5

mapArv :: (a -> b) -> Arv a -> Arv b
mapArv _ Vazia = Vazia
mapArv f (No x left right) = No (f x) (mapArv f left) (mapArv f right)

-- 4.6
--(a)
mais_dir :: Arv a → a 
mais_dir Vazia = error "Empty tree"
mais_dir (No x _ Vazia) = x
mais_dir (No _ _ right) = mais_dir right

--(b)
remover :: Ord a => a -> Arv a -> Arv a
remover _ Vazia = Vazia
remover x (No y left right) 
    | x < y = No y (remover x left) right
    | x > y = No y left (remover x right)
    | otherwise = removerNo (No y left right)

removerNo :: Ord a=> Arv a  -> Arv a
removerNo Vazia = error "Empty Tree"
removerNo (No _ Vazia right) = right
removerNo (No _  left Vazia) = left
removerNo (No _  left right) = No n (remover n left) right
    where n = maisDir left

-- 4.7


-- 4.8
data Expr = Lit Integer
          | Op Ops Expr Expr
          | If BExp Expr Expr
          
data Ops = Add | Sub | Mul | Div | Mod

eval :: Expr -> Integer
eval (Lit n) = n
eval (Op Add e1 e2) = eval e1 + eval e2
eval (Op Sub e1 e2) = eval e1 - eval e2
eval (Op Mul e1 e2) = eval e1 * eval e2
eval (Op Div e1 e2) = eval e1 `div` eval e2
eval (Op Mod e1 e2) = eval e1 `mod` eval e2
eval (If b e1 e2) = if bEval b then eval e1 else eval e2


data BExp = BoolLit Bool
          | And BExp BExp
          | Not BExp
          | Equal Expr Expr
          | Greater Expr Expr

bEval :: BExp -> Bool
bEval (BoolLit b) = b
bEval (And b1 b2) = bEval b1 && bEval b2
bEval (Not b) = not (bEval b)
bEval (Equal e1 e2) = eval e1 == eval e2
bEval (Greater e1 e2) = eval e1 > eval e2

instance Show Expr where
    show (Lit n) = show n
    show (Op Add e1 e2) = "(" ++ show e1 ++ " + " ++ show e2 ++ ")"
    show (Op Sub e1 e2) = "(" ++ show e1 ++ " - " ++ show e2 ++ ")"
    show (Op Mul e1 e2) = "(" ++ show e1 ++ " * " ++ show e2 ++ ")"
    show (Op Div e1 e2) = "(" ++ show e1 ++ " / " ++ show e2 ++ ")"
    show (Op Mod e1 e2) = "(" ++ show e1 ++ " % " ++ show e2 ++ ")"
    show (If b e1 e2) = "if " ++ show b ++ " then " ++ show e1 ++ " else " ++ show e2

instance Show BExp where
    show (BoolLit b) = show b
    show (And b1 b2) = "(" ++ show b1 ++ " && " ++ show b2 ++ ")"
    show (Not b) = "not " ++ show b
    show (Equal e1 e2) = "(" ++ show e1 ++ " == " ++ show e2 ++ ")"
    show (Greater e1 e2) = "(" ++ show e1 ++ " > " ++ show e2 ++ ")"
