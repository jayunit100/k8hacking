FROM google/golang:latest

# Add source to gopath.  This is defacto required for go apps.
ADD ./src /gopath/src/
# $GOPATH/[src/a/b/c]
# go build a/b/c
# go run main

# So that we can easily run and install
WORKDIR /gopath/src/

# Install the code (the executables are in the main dir)  This will get the deps also.
RUN go get main
#RUN go build main

# Expected that you will override this in production kubernetes.
CMD /gopath/bin/main
