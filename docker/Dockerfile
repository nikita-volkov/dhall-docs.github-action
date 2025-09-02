FROM ubuntu:25.10

RUN apt-get update
RUN apt-get install cabal-install -y
RUN apt-get install libghc-zlib-dev -y

RUN cabal update
RUN cabal install dhall-docs-1.0.12 --install-method=copy --installdir=/usr/local/bin

RUN rm -rf ~/.cabal

COPY entrypoint.bash /usr/local/bin/


ENTRYPOINT ["entrypoint.bash"]
