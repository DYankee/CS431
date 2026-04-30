{-# LANGUAGE RecordWildCards #-}
import Control.Concurrent (threadDelay)
import Control.Monad (forM_)
import Data.Array
    ( Ix(range), (!), (//), array, bounds, listArray, Array )
import Data.List (maximumBy)
import Data.Ord (comparing)
import System.CPUTime ( getCPUTime )
import System.Environment (getArgs)
import System.IO
    ( hFlush, hSetBuffering, stdout, BufferMode(BlockBuffering) )
import Text.Printf ( printf )
import Control.DeepSeq (force)
import Control.Exception (evaluate)
import GHC.Stats
    ( getRTSStats,
      getRTSStatsEnabled,
      GCDetails(gcdetails_live_bytes),
      RTSStats(gc) )
import System.Mem (performGC)
import System.FilePath (takeBaseName)

-------------------------------------------------------------------------------
-- Conway's game of life implemented in Haskell. 
-- Simulation settings can be adjusted below in the global configurations

-- optional Args:
--      1. seedFile     - Path to a file containing a starting seed
--      2. height       - height of the simulation
--      3. width        - Width of the simulation

-- Compilation instructions:
--      ghc -threaded -O2 gol.hs -o gol -rtsopts
-- For performance tracking add +RTS -T to the end of flags
-------------------------------------------------------------------------------


-- --- Global Config ---
defaultWidth, defaultHeight, frameCount :: Int
defaultWidth = 24
defaultHeight = 24
frameCount = 300

updateRate :: Int
updateRate = 100000 -- Time between updates in microseconds (100,000ms = 0.1s)

defaultSeed :: String
defaultSeed = "../seeds/default.txt"

-- Tiles
aliveChar, deadChar :: Char
aliveChar = '\x2687' -- ⚇
deadChar  = '\x0387' -- ·

-- --- Types ---


type Grid = Array (Int, Int) Int

data PerformanceStats = PerformanceStats
    { count    :: Int
    , currTime :: Double
    , totalTime:: Double
    , currMem  :: Double -- Haskell's GC stats are complex; using a placeholder here
    , totalMem :: Double
    }

-- --- Logic ---



-- Creates a blank grid initialized to 0
createGrid :: Int -> Int -> Grid
createGrid h w = listArray ((1, 1), (h, w)) (repeat 0)

-- Toroidal neighbor counting
countNeighbors :: Grid -> Int -> Int -> Int
countNeighbors grid y x =
    let ((minY, minX), (maxY, maxX)) = bounds grid
        height = maxY - minY + 1
        width  = maxX - minX + 1
        -- Function to handle toroidal wrapping
        wrap val minV maxV len = ((val - minV) `mod` len) + minV
        
        neighborCoords = [ (wrap (y + dy) minY maxY height, wrap (x + dx) minX maxX width)
                         | dy <- [-1 .. 1], dx <- [-1 .. 1], not (dx == 0 && dy == 0) ]
    in sum [grid ! (ny, nx) | (ny, nx) <- neighborCoords]

-- Function to evolve the grid using List Comprehension (very idiomatic Haskell)
updateGrid :: Grid -> Grid
updateGrid grid = 
    let bnds = bounds grid
    in array bnds [ (idx, nextState idx) | idx <- range bnds ]
  where
    nextState (y, x) =
        let n = countNeighbors grid y x
            isAlive = grid ! (y, x) == 1
        in if isAlive
           then if n == 2 || n == 3 then 1 else 0
           else if n == 3 then 1 else 0

-- --- Seed Loading ---

loadSeed :: FilePath -> Int -> Int -> IO Grid
loadSeed path h w = do
    contents <- readFile path
    let seedLines = lines contents
        seedH = length seedLines
        seedW = maximum (map length seedLines)
        -- Centering logic
        startY = ((h - seedH) `div` 2) + 1
        startX = ((w - seedW) `div` 2) + 1
        
        -- Generate list of coordinate updates
        updates = do
            (r, line) <- zip [0..] seedLines
            (c, char) <- zip [0..] line
            let curY = startY + r
                curX = startX + c
            if curY >= 1 && curY <= h && curX >= 1 && curX <= w
               then return ((curY, curX), if char == '1' then 1 else 0)
               else []
    
    return $ (createGrid h w) // updates

-- --- UI & Performance ---

displayGrid :: Grid -> PerformanceStats -> IO ()
displayGrid grid PerformanceStats {..} = do
    -- ANSI Clear Screen and Reset Cursor
    putStr "\ESC[2J\ESC[H"
    let ((minY, minX), (maxY, maxX)) = bounds grid
        avgTime = totalTime / fromIntegral count
        avgMem  = totalMem / fromIntegral count

    -- Build the grid string
    forM_ [minY..maxY] $ \y -> do
        let row = [ if grid ! (y, x) == 1 then aliveChar else deadChar | x <- [minX..maxX] ]
        putStrLn (intersperse ' ' row)

    putStrLn $ replicate (maxX * 2) '-'
    printf "FRAME: %d\n" count
    printf "TIME: Current: %8.6f s  | Avg: %8.6f s\n" currTime avgTime
    printf "MEM:  Current: %8.4f KB | Avg: %8.4f KB\n" currMem avgMem
    hFlush stdout

intersperse :: a -> [a] -> [a]
intersperse _ [] = []
intersperse _ [x] = [x]
intersperse sep (x:xs) = x : sep : intersperse sep xs

logPerformance :: String -> PerformanceStats -> IO ()
logPerformance filename PerformanceStats{..} = do
    let avgTime = totalTime / fromIntegral count
        avgMem  = totalMem / fromIntegral count
    appendFile filename $ 
        printf "%d,%8.6f,%8.4f,%8.6f,%8.4f\n" count currTime currMem avgTime avgMem

getMemoryUsage :: IO Double
getMemoryUsage = do
    enabled <- getRTSStatsEnabled
    if enabled
        then do
            performGC
            stats <- getRTSStats
            -- Returns current bytes used in the heap converted to KB
            return $ fromIntegral (gcdetails_live_bytes $ gc stats) / 1024.0
        else return 0.0

-- --- Main Loop ---

main :: IO ()
main = do
    -- Enable block buffering
    hSetBuffering stdout (BlockBuffering (Just 4096))

    args <- getArgs
    let seedFile = if not (null args) then head args else defaultSeed
        width    = if length args >= 2 then read (args !! 1) else defaultWidth
        height   = if length args >= 3 then read (args !! 2) else defaultHeight

    grid <- loadSeed seedFile height width
    
    -- Prepare CSV log
    let baseName = takeBaseName seedFile
        logFile = "haskell_" ++ baseName ++ ".csv"
    writeFile logFile "Frame,CalcTime_s,MemUsage_KB,AvgTime_s,AvgMem_KB\n"
    let loop currentGrid stats = do
            if count stats >= frameCount
                then putStrLn "Simulation Complete."
                else do
                    start <- getCPUTime
                    
                    -- Pure calculation
                    nextGrid <- evaluate $ force (updateGrid currentGrid)
                    
                    end <- getCPUTime

                    mem <- getMemoryUsage

                    let diff = fromIntegral (end - start) / (10^12) -- Convert picoseconds to seconds
                        newStats = stats 
                            { count = count stats + 1
                            , currTime = diff
                            , totalTime = totalTime stats + diff
                            -- Dummy memory stats (requires GHC.Stats for real values)
                            , currMem = mem
                            , totalMem = totalMem stats + mem
                            }

                    displayGrid nextGrid newStats
                    logPerformance logFile newStats
                    threadDelay updateRate
                    loop nextGrid newStats

    loop grid (PerformanceStats 0 0 0 0 0)