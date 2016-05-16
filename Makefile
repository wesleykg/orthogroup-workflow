FAA: $(patsubst data/%.FAA, data/%_aligned.fasta, $(wildcard data/*.FAA))

FNA: $(patsubst data/%.FNA, data/%_aligned.fasta, $(wildcard data/*.FNA))

download:
	cd data/ ; python ../scripts/0_download.py wanted_accessions.txt
	cd data/ ; find . -mindepth 1 -ipath "*.f?a" -exec cp {} . \;

data/%_filtered.fasta: data/%.FAA data/wanted_species.txt
	cd data/ ; python ../scripts/1_filter.py $(notdir $^)

data/%_filtered.fasta: data/%.FNA data/wanted_species.txt
	cd data/ ; python ../scripts/1_filter.py $(notdir $^)

data/%_cleaned.fasta: data/%_filtered.fasta
	cd data/ ; python ../scripts/2_clean.py $(notdir $^)

data/%_aligned.fasta : data/%_cleaned.fasta
	cd data/ ; python ../scripts/3_align.py $(notdir $^)

clean:
	rm -f data/*_filtered.fasta data/*_cleaned.fasta data/*_aligned.fasta \
	data/*_missing.fasta

cleanall:
	rm -f data/*.FNA data/*.FAA data/*_filtered.fasta data/*_cleaned.fasta \
	data/*_aligned.fasta data/*_missing.fasta

.PHONY: FAA FNA download clean cleanall
.DELETE_ON_ERROR:
#.PRECIOUS: data/%_filtered.fasta data/%_cleaned.fasta