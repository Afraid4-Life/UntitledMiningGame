--Resizes the selected image label to fit the image's pixel size, paste in the command line and press enter

--local id = originalImage:match("(%d+)")
local httpService = game:GetService("HttpService")
local PNG = httpService:GetAsync("https://assetdelivery.roproxy.com/v1/asset?id=87427783714231")

local function parseBigEndian(str, index)
	local b1, b2, b3, b4 = string.byte(str, index, index + 3)
	return ((b1 * 256 + b2) * 256 + b3) * 256 + b4
end

local pngSignature = "\137PNG\r\n\26\n"
if PNG:sub(1, 8) ~= pngSignature then
	warn("Invalid PNG signature")
else
	local chunkType = PNG:sub(13, 16)
	if chunkType ~= "IHDR" then
		warn("IHDR chunk not found in PNG")
	else
		local width = parseBigEndian(PNG, 17)
		local height = parseBigEndian(PNG, 21)
		print("Parsed PNG Dimensions: Width =", width, "Height =", height)
		imageLabel.Size = UDim2.new(0, width, 0, height)
	end
end