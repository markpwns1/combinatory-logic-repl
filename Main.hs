{-

COMBINATORY LOGIC EVALUATOR

The 2 rules of combinatory logic are:
1. K x y = x
2. S x y z = x z (y z)

There is a third, optional rule:
3. I x = x

-}

data Term = Var Char
    | App Term Term

instance Show Term where
    show (Var x) = [x]
    show (App x y) = "(" ++ show x ++ " " ++ show y ++ ")"

evaluate :: Term -> Term
evaluate (App (App (Var 'K') x) y) = evaluate x -- Rule 1
evaluate (App (App (App (Var 'S') x) y) z) = do -- Rule 2
    let z' = evaluate z  
    evaluate $ App (App (evaluate x) z') (App (evaluate y) z')
evaluate (App (Var 'I') x) = evaluate x -- Rule 3
-- Traverse the tree:
evaluate (App x y) = App (evaluate x) (evaluate y)
evaluate (Var x) = Var x

parse :: String -> Term
parse = fst . parse'
    where
        parse' :: String -> (Term, String)
        parse' [] = error "Unexpected end of file"
        parse' (' ':xs) = parse' xs -- Skip whitespace
        parse' ('(':xs) = do
            let (terms, xs') = parseList ([], xs) 
            if null terms then error "Empty parentheses" 
            else (foldl1 App terms, xs')
        parse' (')':xs) = error "Unexpected closing parenthesis"
        parse' (x:xs) = (Var x, xs)

        -- Given a string "x y z)" returns terms [x, y, z] and the rest of the string
        parseList :: ([Term], String) -> ([Term], String)
        parseList (terms, []) = (terms, [])
        parseList (terms, ')':xs) = (terms, xs)
        parseList (terms, xs) = let (term, xs') = parse' xs in parseList (terms ++ [term], xs')

run :: String -> IO ()
run = print . evaluate . parse

main :: IO ()
main = do
    putStrLn "COMBINATORY LOGIC EVALUATOR"
    putStrLn "Try (S x (K y w) (I z)) for example. Type 'quit' to quit."
    let mainLoop = do
        putStr "> "
        input <- getLine
        if input == "quit" then return ()
        else do
            run input
            mainLoop
    mainLoop