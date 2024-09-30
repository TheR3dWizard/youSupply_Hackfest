
# Functions

## 1 Save paths to file

- Call /path/get
- save output to file under "curpaths"

## 1.1 view all paths from file

- get all paths 
- return type: 
    {
        [
        startloc
        distance
        ]
    }
- have button to do 1.2 for every path

## 1.2 view specific path

- use the key to find a specific path
- return type:
    [
        {
            loc
            action
        }
    ]
- have button to do 1.3

## 1.3 accept path

- find specific path under curpath
- add path to accpath
- get nodeids from path
- send nodeids using /path/accept

## 2 view accepted path

- find path from accpath
- return type:
    {
        completedstep
        [
            loc
            action
        ]
    }
- have button to do 2.1

## 2.1 Mark as completed

- call path/markstep
- call path/lookup
- save to accpath
- go to 2
