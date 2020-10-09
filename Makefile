.DEFAULT_GOAL: run

LOCALDEV = "http://localhost:4000"
REPOSITORY = "https://github.com/martinrosso/martinrosso.github.io.git"
REPOSITORY_NAME = "martinrosso.github.io"


update:
	@echo "Update Jekyll Dependencies"
	bundle update
	# bundle update github-pages


build: update clean
	@echo "Build the page to _site"
	bundle exec jekyll build


run: 
	@echo "Build and deploy in development mode"
	firefox --private-window ${LOCALDEV} &
	bundle exec jekyll serve --livereload


deploy: update build
	@echo "Deploy to github pages"
# check whether this is NOT the github pages repository
	@echo "Make sure you are on the right repository (PRIVATE)"
# The below grep command will count try to find the pattern REPOSITORY_NAME
# If it does occure at least once the exit code will be 0, otherwise 1.
# We REVERT the exit code using !. Make will abort if the pattern occurs,
# i.e. with this is the WRONG REPOSITORY
	git config remote.origin.url | ( ! grep -q ${REPOSITORY_NAME} )
# If the above command failes, Make does not continue
	@echo "Push release branch to github pages:"
# from the current epository, take the 'release' branch,
# push it into the github pages repository master branch
	git push ${REPOSITORY} release:master --force 
	@echo "Done"


clean:
	@echo "Clean directory"
	rm -rf "./_site"

