-- import Prelude hiding (Maybe)
-- BST

data Tree a = Empty | Tree a (Tree a) (Tree a) deriving (Show)

unitTree :: a -> Tree a
unitTree val = Tree val Empty Empty

-- DO IN CLASS
-- bstPush :: Ord a => a -> Tree a -> Tree a
-- bstPush val Empty = unitTree val
-- bstPush val t@(Tree root l r)
--   | val == root = t
--   | val > root = Tree root l (bstPush val r)
--   | otherwise = Tree root (bstPush val l) r

-- tree :: Tree Integer
-- tree = foldr bstPush Empty [30, 29 .. 1]

-- IN CLASS - bstElem

-- Record syntax

data Student' = Student' String String Int Float

firstName' :: Student' -> String
firstName' (Student' firstname _ _ _) = firstname

-- vs

data Student = Student
  { firstName :: String,
    lastName :: String,
    facultyNumber :: Int,
    gpa :: Float
  }
  deriving (Show)

students :: [Student]
students =
  [ Student
      { firstName = "Iliya",
        lastName = "Zh",
        facultyNumber = 81125,
        gpa = 3.4
      },
    Student
      { firstName = "Ivan",
        lastName = "Petrov",
        facultyNumber = 81126,
        gpa = 5.4
      },
    Student
      { firstName = "Petyr",
        lastName = "Ivanov",
        facultyNumber = 81127,
        gpa = 3.8
      },
    Student
      { firstName = "Svilen",
        lastName = "Andonov",
        facultyNumber = 81128,
        gpa = 7.0
      }
  ]

passingGrade :: Float
passingGrade = 4.5

-- Find all students with gpa >= passingGrade
-- DO IN CLASS
passingStudents :: [Student]
passingStudents =
  filter (\s -> gpa s > passingGrade) students
