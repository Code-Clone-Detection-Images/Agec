FROM openjdk:18-alpine3.15

ENV HOME=/home/agec-user
# github naming
ENV AGEC_HOME="$HOME/agec-master"

RUN addgroup --gid 1000 agec-user && adduser --uid 1000 --ingroup agec-user --home "$HOME" --disabled-password agec-user

RUN apk add --update --no-cache bash wget unzip python2
RUN python2 -m ensurepip

WORKDIR "$HOME"
# retrieve the git repo; TODO: test with tag v1.0
RUN wget https://github.com/tos-kamiya/agec/archive/refs/heads/master.zip --directory-prefix "$HOME"
RUN unzip master.zip
RUN rm -rf master.zip

COPY test "$HOME/test"
COPY run_agec.sh /

RUN chmod +x /run_agec.sh && /run_agec.sh
RUN diff -w "$HOME/clones.txt" "$HOME/test/expected.txt"
RUN rm -rf "$HOME/clones.txt" "$HOME/test"

USER agec-user

ENTRYPOINT [ "bash" ]