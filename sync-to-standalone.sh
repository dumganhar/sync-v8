#!/bin/bash

set -e

pushd ..

source_dir="./v8/"
exclude_file="./sync-v8/v8-exclude.txt"

do_rsync() {
	destination_dir=$1

	# pushd $source_dir
	# git clean -fdx .

	# if [[ -z $(git status --porcelain) ]]; then
	#     echo "==> Git status is clean."
	# else
	#     echo "==> ERROR: Git status is not clean."
	#     git status
	#     exit 1
	# fi

	# popd

	pushd $destination_dir
	echo "==> ignore changes"
	git checkout -f
	echo "==> clean ..."
	git clean -fdx .
	popd

	rsync -av --exclude-from="$exclude_file" --delete "$source_dir" "$destination_dir"

	pushd $destination_dir

	find . -name "*.pyc" | xargs rm -f
	find . -name ".DS_Store" | xargs rm -f

	# gsed -i "s@\"wasm-spec-tests:v8_wasm_spec_tests\"@#\"wasm-spec-tests:v8_wasm_spec_tests\"@g" ./test/BUILD.gn
	# gsed -i "s@\"test262:v8_test262\"@#\"test262:v8_test262\"@g" ./test/BUILD.gn
	# gsed -i "s@\"mjsunit:v8_mjsunit\"@#\"mjsunit:v8_mjsunit\"@g" ./test/BUILD.gn

	git add -f .

	popd
}

do_rsync "./v8-standalone"

popd
