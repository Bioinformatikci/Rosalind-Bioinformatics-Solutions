# It reads fasta files and returns as dict.
def read_seq():
    with open("gen.fasta", "r") as file:
        seq_dic = {}
        for i in file:
            if i[0] == ">":
                try:
                    seq_dic[seq_name] = seq.replace("\n", "")
                except Exception:
                    pass
                seq_name = i.replace("\n", "")
                seq = ""
            else:
                seq += i
        seq_dic[seq_name] = seq.replace("\n", "")
    return seq_dic

def find_shortest_superstring(seq_dic):
    for k,v in seq_dic.items():
        pass



def main():
    seq_dic = read_seq()
    find_shortest_superstring(seq_dic)

if __name__ == "__main__":
    main()
