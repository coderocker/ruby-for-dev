FROM ruby:2.4.5-alpine3.9
RUN apk add --no-cache shadow build-base g++ git \
    postgresql-dev nodejs \
    sudo \
    curl \
    bash \
    file \
    git \
    gzip \
    libc6-compat \
    ncurses \
    libmagic \
    imagemagick6 \
    imagemagick6-dev \
    freetds-dev ffmpegthumbnailer \
    postgresql-client gmp-dev gcc xvfb \
    openssh-client wget \
    libcurl openssl-dev curl-dev tzdata linux-headers
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && tar xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && mv wkhtmltox/bin/wkhtmlto* /usr/bin/ \
    && ln -nfs /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf \
    && rm -rf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && rm -rf wkhtmltox
RUN gem uninstall -i /usr/local/lib/ruby/gems/2.4.5 bundler \
    && gem install bundler -v '1.17.3' \
    && gem install debase ruby-debug-ide
RUN addgroup -S app_runner \
    && adduser -DS -u 1000 -h /home/app_runner -s /bin/bash app_runner -G app_runner \
    && echo 'app_runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown app_runner:app_runner -R /home/app_runner/
USER app_runner
RUN mkdir /home/app_runner/.ssh \
    && chmod 700 /home/app_runner/.ssh \
    && mkdir /home/app_runner/approot \
    && chmod 755 -R /home/app_runner/approot \
    && mkdir -p /home/app_runner/approot/gem_path/ruby/2.4.5 \
    && chmod 755 -R /home/app_runner/approot/gem_path/ruby/2.4.5
ENV BUNDLE_PATH /home/app_runner/approot/gem_path/ruby/2.4.5
WORKDIR /home/app_runner/approot
