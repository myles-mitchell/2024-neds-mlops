# This is a template file - any changes will be overwritten
# To change, update: materials/r_pkgs/02-jrTraRoot/inst/extdata/template/
# and submit an MR
.PHONY: final clean cleaner pristine force

MAIN = index

$(MAIN).pdf: *.Rmd ../config.yml
	Rscript -e "jrTraRoot::pre_build()"
	Rscript -e "jrNotes2::render()"
	Rscript -e "jrTraRoot::update_readme()"

final: $(MAIN).pdf
	Rscript -e "jrNotes2::create_final()"

clean:
	Rscript -e "jrNotes2::clean()"

cleaner:
	Rscript -e "jrNotes2::cleaner()"

pristine:
	Rscript -e "jrNotes2::pristine()"

# The -B switch can also be used to force make to ignore timestamps.
# However, force is easier to remember than the -B flag.
force:
	touch $(MAIN).Rmd
	$(MAKE)
