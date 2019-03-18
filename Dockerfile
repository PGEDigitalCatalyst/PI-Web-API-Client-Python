FROM continuumio/miniconda3:latest

WORKDIR /app
# the CombinedCA.cer stuff will go away with artifactory
ADD requirements.txt CombinedCA.cer* /app/
RUN if [ -f ./CombinedCA.cer ]; then mkdir -p ~/.pip; printf "[global]\ncert=/app/CombinedCA.cer\n" > ~/.pip/pip.conf; printf "ssl_verify: /app/CombinedCA.cer\n" > ~/.condarc; fi

RUN pip install -r requirements.txt

ADD . /app