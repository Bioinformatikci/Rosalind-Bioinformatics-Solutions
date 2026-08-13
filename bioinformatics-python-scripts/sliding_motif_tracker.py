def read_fasta(filepath):
    sequences = {}
    current_name = None
    current_sequence = []

    with open(filepath, "r", encoding="utf-8") as file:
        for line in file:
            line = line.strip()
            if not line:
                continue

            if line.startswith(">"):
                if current_name is not None:
                    sequences[current_name] = "".join(current_sequence)
                current_name = line[1:]
                current_sequence = []
            else:
                current_sequence.append(line)

    if current_name is not None:
        sequences[current_name] = "".join(current_sequence)

    return sequences


def read_motifs(filepath):
    with open(filepath, "r", encoding="utf-8") as file:
        motif_list = [line.strip() for line in file if line.strip()]

    motif_chain = "".join(motif_list)
    return motif_list, motif_chain


def find_motifs(sequences, motif_chain, motif_list):
    results = []

    for sequence_name, sequence in sequences.items():
        for index in range(len(sequence) - len(motif_chain) + 1):
            if sequence[index:index + len(motif_chain)] == motif_chain:
                results.append(
                    "\n".join(
                        [
                            f"Sequence: {sequence_name}",
                            f"Chain found at index: {index}",
                            f"Motif 1 {motif_list[0]} at: {index}",
                            f"Motif 2 {motif_list[1]} at: {index + len(motif_list[0])}",
                            f"Motif 3 {motif_list[2]} at: {index + len(motif_list[0]) + len(motif_list[1])}",
                            f"Total chain length: {len(motif_chain)}",
                        ]
                    )
                )

    return "\n\n".join(results)


def write_results(results, filepath):
    with open(filepath, "w", encoding="utf-8") as file:
        file.write(results)


def main():
    sequences = read_fasta("gen.fasta")
    motif_list, motif_chain = read_motifs("motifs.fasta")
    results = find_motifs(sequences, motif_chain, motif_list)
    write_results(results, "motif_chain_hits.txt")


if __name__ == "__main__":
    main()
