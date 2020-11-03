FROM ubuntu

WORKDIR .

COPY . .

EXPOSE 5000

CMD ./headless-3.2.3.64 --mode=SERVER