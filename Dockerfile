FROM ubuntu

WORKDIR .

COPY . .

CMD ./headless-3.2.3.64 --mode=SERVER