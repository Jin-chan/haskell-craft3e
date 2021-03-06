module Chapter4Exercises where

import Chapter4 hiding (maxThree)
import Test.HUnit
import Test.QuickCheck hiding (Result)

-------------------------------------------------------------------------------
-- Exercise 4.1
-------------------------------------------------------------------------------

-- Copied from Chapter4.hs to allow using Integer
maxThree :: Integer -> Integer -> Integer -> Integer
maxThree x y z = (x `max` y) `max` z

-- Using maxThree, but not max
maxFourA :: Integer -> Integer -> Integer -> Integer -> Integer
maxFourA a b c d
    | (maxThree a b c) >= d   = maxThree a b c
    | otherwise               = d

-- Using max only
maxFourB :: Integer -> Integer -> Integer -> Integer -> Integer
maxFourB a b c d = max (max a b) (max c d)

-- Using maxThree and max
maxFourC :: Integer -> Integer -> Integer -> Integer -> Integer
maxFourC a b c d = (maxThree a b c) `max` d

maxFour = maxFourC

-- All three should yield the same result
prop_maxFour :: Integer -> Integer -> Integer -> Integer -> Bool
prop_maxFour a b c d =
    maxFourA a b c d == maxFourB a b c d &&
    maxFourB a b c d == maxFourC a b c d

-------------------------------------------------------------------------------
-- Exercise 4.2
-------------------------------------------------------------------------------

-- Implementation of between had to be done in Chapter4.hs

-------------------------------------------------------------------------------
-- Exercise 4.3
-------------------------------------------------------------------------------

howManyEqual :: Integer -> Integer -> Integer -> Integer
howManyEqual a b c
    | a == b && b == c = 3
    | a == b           = 2
    | a == c           = 2
    | b == c           = 2
    | otherwise        = 0

-------------------------------------------------------------------------------
-- Exercise 4.4
-------------------------------------------------------------------------------
howManyOfFourEqual :: Integer -> Integer -> Integer -> Integer -> Integer
howManyOfFourEqual a b c d
    | a == b && b == c && c == d    = 4
    | otherwise                     = maxFour (howManyEqual a b c)
                                              (howManyEqual a b d)
                                              (howManyEqual a c d)
                                              (howManyEqual b c d)

-------------------------------------------------------------------------------
-- Exercise 4.8
-------------------------------------------------------------------------------

triArea'' :: Float -> Float -> Float -> Float
triArea'' a b c
    | possible   = sqrt(s*(s-a)*(s-b)*(s-c))
    | otherwise  = 0
    where
      s                                 = (a+b+c)/2
      possible                          = allPositive &&
                                          allSatisfyTriangleInequality
      allPositive                       = a > 0 && b > 0 && c > 0
      allSatisfyTriangleInequality      = satisfyTriangleInequality a b c &&
                                          satisfyTriangleInequality b a c &&
                                          satisfyTriangleInequality c a b
      satisfyTriangleInequality a b c   = a < (b + c)

-------------------------------------------------------------------------------
-- Exercise 4.9
-------------------------------------------------------------------------------

maxThreeOccurs :: Integer -> Integer -> Integer -> (Integer, Integer)
maxThreeOccurs a b c = (maxValue, occurences)
    where
      maxValue      = maxThree a b c
      occurences    = occurrencesOf maxValue
      occurrencesOf n
        | a == n && b == n && c == n   = 3
        | a == n && b == n             = 2
        | a == n && c == n             = 2
        | b == n && c == n             = 2
        | otherwise                    = 1

-------------------------------------------------------------------------------
-- Exercise 4.11, 4.12, 4.13
-------------------------------------------------------------------------------

data Result = Win | Lose | Draw deriving (Show, Eq)

outcome :: Move -> Move -> Result
outcome a b
    | a == beat b   = Win
    | a == lose b   = Lose
    | otherwise     = Draw

testRPS = TestList [
    TestCase (assertEqual "rock beats scissors"  Win (outcome Rock Scissors)),
    TestCase (assertEqual "paper beats rock"  Win (outcome Paper Rock)),
    TestCase (assertEqual "scissors beats paper"  Win (outcome Scissors Paper)),
    TestCase (assertEqual "scissors loses to rock" Lose (outcome Scissors Rock)),
    TestCase (assertEqual "rock loses to paper" Lose (outcome Rock Paper)),
    TestCase (assertEqual "paper loses to scissors" Lose (outcome Paper Scissors)),
    TestCase (assertEqual "draw Scissors" Draw (outcome Scissors Scissors)),
    TestCase (assertEqual "draw Paper" Draw (outcome Paper Paper)),
    TestCase (assertEqual "draw Rock" Draw (outcome Rock Rock))
 ]

propCannotBeatAndLoseAgainstTheSame a = beat a /= lose a


-------------------------------------------------------------------------------
-- Exercise 4.15, 4.16
-------------------------------------------------------------------------------

data Temp = Cold | Hot deriving (Eq, Show, Ord)
data Season = Spring | Summer | Autumn | Winter deriving (Eq, Show, Ord)

temperatureIn :: Season -> Temp
temperatureIn Spring = Cold
temperatureIn Summer = Hot
temperatureIn Autumn = Cold
temperatureIn Winter = Cold

data Month = January | February | March | April | May | June |
             July | August | September | October | November| December 
     deriving (Show, Eq, Ord)

seasonIn :: Month -> Season
seasonIn month
    | month <= March        = Spring
    | month <= August       = Summer
    | month <= September    = Autumn
    | otherwise             = Winter

-------------------------------------------------------------------------------
-- Exercise 4.17
-------------------------------------------------------------------------------

rangeProduct :: Integer -> Integer -> Integer
rangeProduct m n
    | n < m     = 0
    | m == n    = n
    | otherwise = (rangeProduct m (n-1)) * n

testRangeProduct = TestList
    [ TestCase (assertEqual "for m > n"  0 (rangeProduct 2 1))
    , TestCase (assertEqual "for m=n=1"  1 (rangeProduct 1 1))
    , TestCase (assertEqual "for m=1,n=2" 2 (rangeProduct 1 2))
    , TestCase (assertEqual "for m=1,n=3" 6 (rangeProduct 1 3))
    , TestCase (assertEqual "for m=1,n=4" 24 (rangeProduct 1 4))
    , TestCase (assertEqual "for m=4,n=4" 4 (rangeProduct 4 4))
    , TestCase (assertEqual "for m=4,n=5" 20 (rangeProduct 4 5))
    ]

-------------------------------------------------------------------------------
-- Exercise 4.18
-------------------------------------------------------------------------------

fac' :: Integer -> Integer
fac' n
    | n < 0   = error "fac only defined on natural numbers"
    | n == 0    = 1
    | otherwise = rangeProduct 1 n

propFac'ShouldBeSameAsFac n
    | n >= 0    = fac n == fac' n
    | otherwise = True

-------------------------------------------------------------------------------
-- Exercise 4.19
-------------------------------------------------------------------------------
multiplyUsingAdd a b
    | a == 0    = 0
    | otherwise = multiplyUsingAdd (a-1) b + b

testMultiplyUsingAddition = TestList
    [ TestCase (assertEqual "0 * 2" 0  (multiplyUsingAdd 0 2))
    , TestCase (assertEqual "2 * 0" 0  (multiplyUsingAdd 2 0))
    , TestCase (assertEqual "1 * 2" 2  (multiplyUsingAdd 1 2))
    , TestCase (assertEqual "2 * 1" 2  (multiplyUsingAdd 2 1))
    , TestCase (assertEqual "3 * 1" 3  (multiplyUsingAdd 3 1))
    , TestCase (assertEqual "1 * 3" 3  (multiplyUsingAdd 1 3))
    , TestCase (assertEqual "2 * 2" 4  (multiplyUsingAdd 2 2))
    , TestCase (assertEqual "7 * 9" 63 (multiplyUsingAdd 7 9))
    ]

propMultiplyUsingAddShouldEqualMul a b
    | a >= 0 && b >= 0  = multiplyUsingAdd a b == a * b
    | otherwise         = True


-------------------------------------------------------------------------------
-- Exercise 4.20
-------------------------------------------------------------------------------
integerSquareRoot :: Integer -> Integer
integerSquareRoot n = isrInternal n n
    where isrInternal n m
            | n*n <= m  = n
            | otherwise = isrInternal (n-1) m

testIntegerSquareRoot = TestList
    [ TestCase (assertEqual "4"     2 (integerSquareRoot 4))
    , TestCase (assertEqual "15"    3 (integerSquareRoot 15))
    , TestCase (assertEqual "16"    4 (integerSquareRoot 16))
    ]


-------------------------------------------------------------------------------
-- Exercise 4.21
-------------------------------------------------------------------------------

f :: Integer -> Integer
f 0 = 0
f 1 = 44
f 2 = 17
f _ = 0

maxOfFn:: (Integer->Integer) -> Integer -> Integer
maxOfFn f limit
    | limit < 0     = error "not defined for limit < 0"
    | limit == 0    = f 0
    | otherwise     = max (f limit) (maxOfFn f (limit-1))

testMaxOfFn = TestList
    [ TestCase (assertEqual "f 0 is always the max" 0   (maxOfFn f 0))
    , TestCase (assertEqual "f 1 is > f 0" 44           (maxOfFn f 1))
    , TestCase (assertEqual "f 2 is < f 1" 44           (maxOfFn f 2))
    , TestCase (assertEqual "f 1 is max"   44           (maxOfFn f 99))
    ]

prop_maxOfFn_mod limit
    | limit < 0 = True
    | otherwise = (maxOfFn f limit) < divisor
    where
        divisor = 5
        f n = mod n divisor


-------------------------------------------------------------------------------
-- Exercise 4.22
-------------------------------------------------------------------------------

any0TestFn :: Integer -> Integer
any0TestFn 0 = 1
any0TestFn 1 = 99
any0TestFn 2 = 42
any0TestFn 3 = 0

-- any of f 0 to f limit is zero
any0 :: (Integer->Integer) -> Integer -> Bool
any0 f limit
    | limit < 0     = error "not defined for limit < 0"
    | limit == 0    = f 0 == 0
    | otherwise     = f limit == 0 || (any0 f (limit-1))


-------------------------------------------------------------------------------
-- Exercise 4.23
-------------------------------------------------------------------------------
regions' :: Integer -> Integer
regions' x = (sumFun id x) + 1

prop_regionsImplementations a
    | a >=0     = regions a == regions' a
    | otherwise = True


-------------------------------------------------------------------------------
-- Exercise 4.33 / 4.34
-------------------------------------------------------------------------------

test_allEqual = TestList
    [ TestCase (assertEqual "all equal"         True  (allEqual 1 1 1))
    , TestCase (assertEqual "1st and 2nd eq"    False (allEqual 1 1 2))
    , TestCase (assertEqual "1st and 3rd eq"    False (allEqual 1 2 1))
    , TestCase (assertEqual "2nd and 3rd eq"    False (allEqual 2 1 1))
    , TestCase (assertEqual "all different"     False (allEqual 1 2 3))

    , TestCase (assertEqual "with 0 Equal"      False (allEqual 0 0 1))
    , TestCase (assertEqual "with 0 different"  True  (allEqual 0 0 0))

    , TestCase (assertEqual "all neg equal"     True   (allEqual (-1) (-1) (-1)))
    , TestCase (assertEqual "all neg 2 diff"    False  (allEqual (-1) (-2) (-2)))
    , TestCase (assertEqual "all neg different" False  (allEqual (-1) (-2) (-3)))
    , TestCase (assertEqual "all neg different" False  (allEqual (-3) (-2) (-1)))
    , TestCase (assertEqual "all neg different" False  (allEqual (-3) (-1) (-2)))

    , TestCase (assertEqual "m negative"        False  (allEqual (-1) ( 1) ( 1)))
    , TestCase (assertEqual "n negative"        False  (allEqual ( 1) (-1) (-1)))
    , TestCase (assertEqual "p negative"        False  (allEqual ( 1) ( 1) (-1)))

    , TestCase (assertEqual "neg, 0, pos"       False  (allEqual (-1) ( 0) ( 1)))
    , TestCase (assertEqual "neg, pos, 0"       False  (allEqual (-1) ( 1) ( 0)))
    , TestCase (assertEqual "0, pos, neg"       False  (allEqual (-1) ( 1) ( 0)))
    , TestCase (assertEqual "0, neg, pos"       False  (allEqual ( 0) (-1) ( 1)))
    ]

-- solution from book
allEqual m n p = ((m + n + p) == 3*p)

-- different solution for a quickCheck
allEqual' m n p = m == n && n ==p
prop_allEqual m n p =  allEqual m n p == allEqual' m n p

-- discussion: quickCheck ftw! lots of combinations here, hard to find all
--             failing test cases...

-------------------------------------------------------------------------------
-- Exercise 4.35 / 4.36
-------------------------------------------------------------------------------

test_allDifferent = TestList
    -- all different
    [ TestCase ( assertEqual "pos, pos, pos"    True  (allDifferent 1 2 3))
    , TestCase ( assertEqual "pos, pos, 0"      True  (allDifferent 1 2 0))
    , TestCase ( assertEqual "pos, pos, neg"    True  (allDifferent 1 2 (-1)))
    , TestCase ( assertEqual "pos, 0, pos"      True  (allDifferent 1 0 1))
    , TestCase ( assertEqual "pos, 0, neg"      True  (allDifferent 1 0 (-1)))
    , TestCase ( assertEqual "pos, neg, pos"    True  (allDifferent 1 (-1) 2))
    , TestCase ( assertEqual "pos, neg, 0"      True  (allDifferent 1 (-1) 0))
    , TestCase ( assertEqual "pos, neg, neg"    True  (allDifferent 1 (-1) (-2)))

    , TestCase ( assertEqual "0, pos, pos"      True  (allDifferent 0 1 2))
    , TestCase ( assertEqual "0, pos, neg"      True  (allDifferent 0 1 (-1)))
    , TestCase ( assertEqual "0, neg, pos"      True  (allDifferent 0 (-1) 1))
    , TestCase ( assertEqual "0, neg, neg"      True  (allDifferent 0 (-1) (-2)))

    , TestCase ( assertEqual "neg, pos, pos"    True  (allDifferent (-1) 1 2))
    , TestCase ( assertEqual "neg, pos, 0"      True  (allDifferent (-1) 1 0))
    , TestCase ( assertEqual "neg, pos, neg"    True  (allDifferent (-1) 1 (-1)))
    , TestCase ( assertEqual "neg, 0, pos"      True  (allDifferent (-1) 0 (1)))
    , TestCase ( assertEqual "neg, 0, neg"      True  (allDifferent (-1) (0) (-2)))
    , TestCase ( assertEqual "neg, neg, pos"    True  (allDifferent (-1) (-2) 1))
    , TestCase ( assertEqual "neg, neg, 0"      True  (allDifferent (-1) (-2) 0))
    , TestCase ( assertEqual "neg, neg, neg"    True  (allDifferent (-1) (-2) (-3)))

    -- two or more zeros -> can't be all different
    , TestCase ( assertEqual "0, 0, pos"        False  (allDifferent 0 0 1))
    , TestCase ( assertEqual "0, 0, neg"        False  (allDifferent 0 0 (-1)))
    , TestCase ( assertEqual "pos, 0, 0"        False  (allDifferent 1 0 0))
    , TestCase ( assertEqual "neg, 0, 0"        False  (allDifferent (-1) 0 0))
    , TestCase ( assertEqual "0, pos, 0"        False  (allDifferent 0 1 0))
    , TestCase ( assertEqual "0, neg, 0"        False  (allDifferent 0 (-1) 0))
    , TestCase ( assertEqual "0, 0, 0"          False  (allDifferent 0 0 0))

    -- other cases of two equal
    , TestCase ( assertEqual "all pos, a b b"   False (allDifferent 1 2 2))
    , TestCase ( assertEqual "all pos, a b a"   False (allDifferent 1 2 1))
    , TestCase ( assertEqual "all pos, b b a"   False (allDifferent 2 2 1))
    , TestCase ( assertEqual "all neg, a b b"   False (allDifferent (-1) (-2) (-2)))
    , TestCase ( assertEqual "all neg, a b a"   False (allDifferent (-1) (-2) (-1)))
    , TestCase ( assertEqual "all neg, b b a"   False (allDifferent (-2) (-2) (-1)))

    -- there are even more but I'm a bit bored now ;)
    ]

-- attempt from book
allDifferent :: Integer -> Integer -> Integer -> Bool
allDifferent m n p = (m/=n) && (n/=p)
