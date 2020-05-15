FROM ffettes/cli:cli-raw

USER root
RUN \
     echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
     apt update && apt install -y apt-utils apt-transport-https ca-certificates gnupg && \
     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
     apt install -y google-cloud-sdk && \
     apt remove -y apt install -y apt-utils apt-transport-https ca-certificates gnupg && apt autoremove

CMD gcloud init
