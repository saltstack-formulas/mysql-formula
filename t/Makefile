

test_container:
	( for f in *.sh; do ./$$f && continue; echo FAIL $$f; exit 1 ; done )

test_container_fast:
	( for f in *.sh; do T_CACHE_PACKAGES=1 ./$$f && continue; echo FAIL $$f; exit 1 ; done )

