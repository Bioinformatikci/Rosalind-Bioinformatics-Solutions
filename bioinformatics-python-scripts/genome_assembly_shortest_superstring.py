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


def overlap_length(left, right, minimum_overlap=1):
    max_overlap = min(len(left), len(right))

    for size in range(max_overlap, minimum_overlap - 1, -1):
        if left.endswith(right[:size]):
            return size

    return 0


def find_shortest_superstring(sequences):
    fragments = list(sequences.values())

    while len(fragments) > 1:
        best_i = 0
        best_j = 1
        best_overlap = -1

        for i, left in enumerate(fragments):
            for j, right in enumerate(fragments):
                if i == j:
                    continue

                current_overlap = overlap_length(left, right)
                if current_overlap > best_overlap:
                    best_i = i
                    best_j = j
                    best_overlap = current_overlap

        merged = fragments[best_i] + fragments[best_j][best_overlap:]
        fragments = [
            fragment
            for index, fragment in enumerate(fragments)
            if index not in {best_i, best_j}
        ]
        fragments.append(merged)

    return fragments[0] if fragments else ""


def main():
    sequences = read_fasta("gen.fasta")
    print(find_shortest_superstring(sequences))


if __name__ == "__main__":
    main()
