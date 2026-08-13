import pandas as pd
import matplotlib.pyplot as plt
from matplotlib_venn import venn3


def read_variants(filepath):

    df = pd.read_csv(filepath,sep="\t")
    return df



def fill_missing(df):
    df["Frequency"] = df.groupby("Population")["Frequency"].transform(lambda x: x.fillna(x.mean()))
    df["Clinical_Significance"] = df.groupby("Population")["Clinical_Significance"].transform(lambda x: x.fillna("Benign"))
    return df


def calc_stats(df):

    stats = df.groupby("Population")["Frequency"].agg(mean="mean",std="std",count="count",min="min",max="max",median="median").reset_index()
    filt = df[df["Clinical_Significance"] == "Pathogenic"]
    counts = filt.groupby("Population")["Clinical_Significance"].count().reset_index(name="Pathogenic_Count")
    return stats, counts




def filter_variants(df):
    df["Pop_Mean_Freq"] = df.groupby("Population")["Frequency"].transform("mean")
    sartlar = ((df["Frequency"]>df["Pop_Mean_Freq"]) & (df["Clinical_Significance"] == "Pathogenic"))
    filtered_df = df[sartlar]
    return filtered_df

def plot_venn(df):
    populations = df["Population"].unique()
    pop_sets = {}
    for pop in populations:
        pop_sets[pop] = set(df[df["Population"] == pop]["Variant"])
        print(pop_sets)
    plt.figure(figsize=(7,7))
    venn3([pop_sets[pop] for pop in populations])
    plt.title("Venn Ortak Benzersiz Varyantlar")
    plt.savefig("venn_diagram.png")
    plt.show()


def main():
    filepath = "variants.tsv"
    df = read_variants(filepath)
    df = fill_missing(df)

    stats,counts = calc_stats(df)
    with open("stats_and_counts.txt", "w") as file:
        file.write(str(stats))
        file.write("\n\n")
        file.write(str(counts))

    filtered_df = filter_variants(df)
    with open("filtered.tsv", "w") as file:
        file.write(str(filtered_df))

    plot_venn(df)


if __name__ == "__main__":
    main()