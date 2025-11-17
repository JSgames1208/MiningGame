local suffixes = {
	"", -- 10^0
	"K", -- 10^3
	"M", -- 10^6
	"B", -- 10^9
	"T", -- 10^12
	"Qa", -- Quadrillion     (10^15)
	"Qi", -- Quintillion     (10^18)
	"Sx", -- Sextillion      (10^21)
	"Sp", -- Septillion      (10^24)
	"Oc", -- Octillion       (10^27)
	"No", -- Nonillion       (10^30)
	"Dc", -- Decillion       (10^33)
	"UnDc", -- Undecillion     (10^36)
	"DuDc", -- Duodecillion    (10^39)
	"TrDc", -- Tredecillion    (10^42)
	"QaDc", -- Quattuordecillion (10^45)
	"QiDc", -- Quindecillion   (10^48)
	"SxDc", -- Sedecillion     (10^51)
	"SpDc", -- Septendecillion (10^54)
	"OcDc", -- Octodecillion   (10^57)
	"NoDc", -- Novemdecillion  (10^60)
	"Vg", -- Vigintillion    (10^63)
}

local function formatNumber(n)
	if n < 1000 then
		return tostring(n)
	end

	local magnitude = math.floor(math.log10(n) / 3)
	local suffix = suffixes[magnitude + 1] or "?"

	local scaled = n / (1000 ^ magnitude)

	local str = string.format("%.3g", scaled)
	str = str:gsub("(%..-)0+$", "%1")
	str = str:gsub("%.$", "")

	return str .. suffix
end

return formatNumber
