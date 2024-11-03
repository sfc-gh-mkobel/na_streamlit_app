SS_DB=SPCS_APP
SS_SCHEMA=NAPP
ROLE=nastreamlit_role


help:            ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

snow_create:
	snow app version create V1 --role nastreamlit_role

snow_validate:
	snow app validate --role nastreamlit_role

snow_app_run:
	snow app run --version v1 --role nastreamlit_role