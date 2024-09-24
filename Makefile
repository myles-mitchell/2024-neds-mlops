# This is a template file - any changes will be overwritten
# To change, update: materials/r_pkgs/02-jrTraRoot/inst/extdata/template/
# and submit an MR
.PHONY: default clean cleaner pristine check_template container feedback gitlab_check

default:
	#Rscript -e "jrTraRoot::pre_build()"
	[ -d notes ] && cd notes && make
	[ -d slides ] && cd slides && make
	Rscript -e "jrTraRoot::update_readme()"

clean:
	Rscript -e "jrTraRoot::clean()"
	Rscript -e "jrNotes2::clean()"
	Rscript -e "jrPresentation2::clean()"
	Rscript -e "jrTraScripts::clean()"
	Rscript -e "jrTraQuiz::clean()"

cleaner:
	Rscript -e "jrTraRoot::cleaner()"
	Rscript -e "jrNotes2::cleaner()"
	Rscript -e "jrPresentation2::cleaner()"
	Rscript -e "jrTraScripts::cleaner()"
	Rscript -e "jrTraQuiz::cleaner()"

pristine:
	Rscript -e "jrTraRoot::pristine()"
	Rscript -e "jrNotes2::pristine()"
	Rscript -e "jrPresentation2::pristine()"
	Rscript -e "jrTraScripts::pristine()"
	Rscript -e "jrTraQuiz::pristine()"

check_template:
	Rscript -e "jrTraRoot::check_template()"

container:
	docker pull registry.gitlab.com/jumpingrivers/training/materials:main
	docker run -ti --rm -v ${PWD}:/root/ -w /root/ --env GITLAB_CI=true registry.gitlab.com/jumpingrivers/training/materials:main /bin/bash

feedback:
ifeq ("x", "x${GITLAB_CI}")
		virtualenv -p python3 venv
		( \
			. venv/bin/activate; \
			pip install tform; \
			tform create-from-config; \
		)
		Rscript -e 'jrPresentation2::create_feedback(); rmarkdown::render("feedback.Rmd")'
endif

gitlab_check:
	make check_template
	make -C notes final
	make -C slides
	make -C slides final
