VCSREF=$(shell git rev-parse --short HEAD)
DATE=$(shell date --rfc-3339=date)

PDB=puppet docker build --rocker --label-schema \
                --module-path modules --cmd '/usr/bin/supervisord,-n' \
                --factfile=env/$(DOMAIN).txt \
		--no-inventory \
                --image-name $@

all:	base webserver database mailhost
.PHONY:	base webserver database mailhost clean

webserver:
		$(PDB) --expose=80,443 --from debian:jessie-slim
		docker tag $@ $(DOMAIN)/$@:$(VCSREF)

database:
		$(PDB) --expose=3306
		docker tag $@ $(DOMAIN)/$@:$(VCSREF)

mailhost:
		$(PDB) --expose=25
		docker tag $@ $(DOMAIN)/$@:$(VCSREF)

clean:
		yes | docker image prune
