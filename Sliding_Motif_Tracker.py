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

def read_motifs():
    with open("4/mofitlerin_dagılım_ist_ozet/motif.fasta", "r") as file:
        motif_list = []
        for i in file:
            motif_list.append(i.removesuffix("\n"))

    motif_chain = "".join(motif_list)
    return motif_list,motif_chain

def find_motifs(seq_dic,motif_chain,motif_list):
    results = ""
    for k,v in seq_dic.items():
        for i,n in enumerate(v):
            if v[i:i+len(motif_chain)] == motif_chain:
                results += f"Sequence: {k}\nChain found at index: {i}\nMotif 1 {motif_list[0]} at: {i}\nMotif 2 {motif_list[1]} at: {i+3}\nMotif 3 {motif_list[2]} at: {i+6}\n Total chain lenght: {len(motif_chain)}\n"
    return results
def write(results):
    with open("motif_chain_hits.txt", "w") as file:
        file.write(results)

def main():
    seg_dic = read_seq()
    motif_list,motif_chain = read_motifs()
    results = find_motifs(seg_dic,motif_chain, motif_list)
    write(results)

if __name__ == "__main__":
    main()