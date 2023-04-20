with open("weight.mem", "w") as f:
    for i in range(16*16):
        f.write(f'{i%16:x} ')
    f.close()