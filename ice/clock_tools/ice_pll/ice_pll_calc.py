# SIMPLE MODE
icestick_ref_clk_mhz = 12
settings = []
for divr in range(0, 16):
    for divf in range(0, 64):
        for divq in range(0, 8):
            vco_mhz = (float(icestick_ref_clk_mhz) * (float(divf) + 1)) / (float(divr) + 1)
            pllout_mhz = vco_mhz / (2 ** divq)
            if (1066 >= vco_mhz) and (vco_mhz >= 533):
                if (275 >= pllout_mhz) and (pllout_mhz >=16):
                    settings.append((pllout_mhz, divr, divf, divq))
sorted_settings = sorted(settings, key=lambda d: d[0])

for setting in sorted_settings:
    v = "// PLLOUT = "+str(setting[0])+"MHz\n"
    v+= "//     parameter p_divr = 4'd"+str(setting[1])+";\n"
    v+= "//     parameter p_divf = 7'd"+str(setting[2])+";\n"
    v+= "//     parameter p_divq = 3'd"+str(setting[3])+";\n"
    print v,
