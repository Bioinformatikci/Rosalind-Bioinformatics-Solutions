file = open("../txt.txt", "r+")

dna_list = []
string = ""
for i in file:
    if i[0] == ">":
        if string != "":
            dna_list.append(string)
        string = ""
        continue
    string += i.replace("\n","")
print(dna_list)

shared_motif_list = []
def create_motif(dna,uzunluk):
    global shared_motif_list
    for i in range(len(dna)-uzunluk+1):
        shared_motif_list.append(dna[i:i+uzunluk])

def all_sub_motifs(dna_len):
    for i in range(1,dna_len+1):
        create_motif(dna_list[0],i)

all_sub_motifs((len(dna_list[0])))

for motif in shared_motif_list[::-1]:
    check = 0
    for dna in dna_list:
        if motif in dna:
            check +=1
    if check == len(dna_list):
        print(motif)
        break



