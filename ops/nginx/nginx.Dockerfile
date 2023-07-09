FROM nginx:1.17-alpine

RUN apk add --update --no-cache openssl-dev libffi-dev  musl-dev python3-dev py3-pip gcc openssl bash && \
  ln -fs /dev/stdout /var/log/nginx/access.log && \
  ln -fs /dev/stdout /var/log/nginx/error.log

# Update default packages
RUN apk add --update alpine-sdk
RUN apk add --virtual build-dependencies

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"
RUN pip3 install setuptools_rust
RUN CRYPTOGRAPHY_DONT_BUILD_RUST=1 pip3 install certbot-dns-cloudflare

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./letsencrypt.conf /etc/nginx/letsencrypt.conf
COPY ./dhparams.pem /etc/ssl/dhparams.pem
COPY ./entry.sh /root/entry.sh

ENTRYPOINT ["/bin/bash", "/root/entry.sh"]
