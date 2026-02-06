local function getAlphabet()
	local s = ""
	for i = 0, 25 do s = s .. string.char(65 + i) end
	for i = 0, 25 do s = s .. string.char(97 + i) end
	for i = 0, 9  do s = s .. string.char(48 + i) end
	return s .. "+/"
end

local alphabet = getAlphabet()
local map = {}
for i = 1, #alphabet do
	map[alphabet:sub(i, i)] = i - 1
end

local function encode(input)
	local out = {}
	local i = 1

	while i <= #input do
		local b1 = string.byte(input, i) or 0
		local b2 = string.byte(input, i + 1) or 0
		local b3 = string.byte(input, i + 2) or 0

		local n = b1 * 65536 + b2 * 256 + b3

		out[#out+1] = alphabet:sub(math.floor(n / 262144) % 64 + 1, math.floor(n / 262144) % 64 + 1)
		out[#out+1] = alphabet:sub(math.floor(n / 4096) % 64 + 1,  math.floor(n / 4096) % 64 + 1)
		out[#out+1] = i + 1 > #input and "=" or alphabet:sub(math.floor(n / 64) % 64 + 1, math.floor(n / 64) % 64 + 1)
		out[#out+1] = i + 2 > #input and "=" or alphabet:sub(n % 64 + 1, n % 64 + 1)

		i = i + 3
	end

	return table.concat(out)
end

local function decode(input)
	local bits = {}
	for i = 1, #input do
		local c = input:sub(i, i)
		if c ~= "=" then
			local v = map[c]
			for j = 5, 0, -1 do
				bits[#bits+1] = math.floor(v / 2^j) % 2
			end
		end
	end

	local out = {}
	for i = 1, #bits, 8 do
		if bits[i+7] ~= nil then
			local n = 0
			for j = 0, 7 do
				n = n * 2 + bits[i + j]
			end
			out[#out+1] = string.char(n)
		end
	end

	return table.concat(out)
end

return {
	encode = encode,
	decode = decode
}
