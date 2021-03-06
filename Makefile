
GOPATH := ${PWD}
export GOPATH
TAG=`git describe --tags`
VERSION ?= `git describe --tags`
LDFLAGS=-ldflags "-s -extldflags \"--static\" -w -X main.version=${VERSION}"

build = echo "\n\nBuilding $(1)-$(2)" && CGO_ENABLED=0 GOOS=$(1) GOARCH=$(2) go build ${LDFLAGS} -o dist/goiplookup_${VERSION}_$(1)_$(2) \
	&& bzip2 dist/goiplookup_${VERSION}_$(1)_$(2)

geoiplookup: goiplookup.go
	go get github.com/oschwald/geoip2-golang
	CGO_ENABLED=0 go build ${LDFLAGS}

clean:
	rm -rf pkg src goiplookup

release:
	mkdir -p dist
	rm -f dist/goiplookup_${VERSION}_*
	$(call build,linux,amd64)
	$(call build,linux,386)
	$(call build,linux,arm)
	$(call build,linux,arm64)
	$(call build,darwin,amd64)
	$(call build,darwin,386)

