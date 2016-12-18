
with open("server.bin", "rb") as f:
    data = f.read()

with open("code.h", "w") as f:
    header = "\nstatic const unsigned char code_bin[] = {\n"
    column = 0
    for byte in data:
        header += " " + hex(byte) + ","
        column += 1
        if column == 12:
            column = 0
            header += "\n "
    header = header.rstrip(",\n ")
    header += "\n};\nstatic const unsigned int code_length = "
    header += str(len(data)) + ";\n"

    f.write(header)