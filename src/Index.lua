-- [[ Variable Declarations ]] --

--// Config

local FPS = 60
local Size = 25

local AngleX = 0
local AngleY = 0
local AngleZ = 0

local Points = {}

local Map = {
    [-6] = "`",
    [-5] = "`",
    [-4] = "`",
    [-3] = "`",
    [-2] = "`",
    [-1] = "'",
    [0] = "\"",
    [1] = "+",
    [2] = "*",
    [3] = "$",
    [4] = "#",
    [5] = "#",
    [6] = "@",
    [7] = "@",
}

-- [[ Function Declarations ]] --

local function Update()
    local RotationX = {
        {1, 0, 0},
        {0, math.cos(AngleX), -math.sin(AngleX)},
        {0, math.sin(AngleX), math.cos(AngleX)}
    }
    
    local RotationY = {
        {math.cos(AngleY), 0, math.sin(AngleY)},
        {0, 1, 0},
        {-math.sin(AngleY), 0, math.cos(AngleY)}
    }

    local RotationZ = {
        {math.cos(AngleZ), -math.sin(AngleZ), 0},
        {math.sin(AngleZ), math.cos(AngleZ), 0},
        {0, 0, 1}
    }

    local Projection = {
        {1, 0, 0},
        {0, 1, 0}
    }

    local ZBuffer = {}

    for i, Point in pairs(Points) do
        local Rotated = {
            RotationX[1][1] * Point[1]
            + RotationX[1][2] * Point[2]
            + RotationX[1][3] * Point[3],
            RotationX[2][1] * Point[1]
            + RotationX[2][2] * Point[2]
            + RotationX[2][3] * Point[3],
            RotationX[3][1] * Point[1]
            + RotationX[3][2] * Point[2]
            + RotationX[3][3] * Point[3],
        }

        Rotated = {
            RotationY[1][1] * Rotated[1]
            + RotationY[1][2] * Rotated[2]
            + RotationY[1][3] * Rotated[3],
            RotationY[2][1] * Rotated[1]
            + RotationY[2][2] * Rotated[2]
            + RotationY[2][3] * Rotated[3],
            RotationY[3][1] * Rotated[1]
            + RotationY[3][2] * Rotated[2]
            + RotationY[3][3] * Rotated[3],
        }

        Rotated = {
            RotationZ[1][1] * Rotated[1]
            + RotationZ[1][2] * Rotated[2]
            + RotationZ[1][3] * Rotated[3],
            RotationZ[2][1] * Rotated[1]
            + RotationZ[2][2] * Rotated[2]
            + RotationZ[2][3] * Rotated[3],
            RotationZ[3][1] * Rotated[1]
            + RotationZ[3][2] * Rotated[2]
            + RotationZ[3][3] * Rotated[3],
        }

        local Projected = {
            Projection[1][1] * Rotated[1]
            + Projection[1][2] * Rotated[2]
            + Projection[1][3] * Rotated[3],
            Projection[2][1] * Rotated[1]
            + Projection[2][2] * Rotated[2]
            + Projection[2][3] * Rotated[3],
        }

        local X = math.floor(Projected[1] / 2)
        local Y = math.floor(Projected[2])

        if (not ZBuffer[X]) then
            ZBuffer[X] = {}
        end

        if (not ZBuffer[X][Y]) then
            ZBuffer[X][Y] = Point[3]
        end

        if (Point[3] > ZBuffer[X][Y]) then
            ZBuffer[X][Y] = Point[3]
        end
    end

    for X = -Size, Size - 10 do
        for Y = -Size, Size do
            local Row = ZBuffer[X]

            if (Row) then
                local Depth = Row[Y]

                if (Depth) then
                    io.write(Map[Depth] or "?")
                else
                    io.write("_")
                end
            else
                io.write("_")
            end
        end

        io.write("\n")
    end

    AngleX = AngleX + 0.12
    AngleY = AngleY + 0.12
    AngleZ = AngleZ + 0.12
end

-- [[ Initialize ]] --

do
    --// Constructor

    for X = -Size, Size, .5 do
        for Y = -Size, Size, .5 do
            for Z = -Size, Size, 1 do
                if ((math.sqrt(X^2 + Y^2) - Size / 2)^2 + Z^2) < (Size / 4)^2 then
                    table.insert(Points, {X, Y, Z})
                end
            end
        end
    end
end

do
    --// Update Scheduler

    local Then = os.clock()

    while true do
        local Now = os.clock()

        if ((Now - Then) > (1 / FPS)) then
            Then = Now

            Update()
        end
    end
end
