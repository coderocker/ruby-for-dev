FROM ruby:2.3.3
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && cp /etc/apt/sources.list /etc/apt/sources.list_backup
ADD ./sources.list /etc/apt/sources.list
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y
RUN apt-get install -y apt-utils git build-essential libpq-dev nodejs

# Optional packages
RUN apt-get install -y sudo imagemagick imagemagick-common \
    libmagickcore-dev libmagickwand-dev libmagick++-dev \
    libmagickwand-6-headers freetds-dev ffmpegthumbnailer \
    postgresql-client libgmp-dev
RUN gem uninstall -i /usr/local/lib/ruby/gems/2.3.0 bundler
RUN gem install bundler -v '1.16.2'
# Dir which share source code
ENV PATH /usr/lib/x86_64-linux-gnu/ImageMagick-6.9.7/bin-q16:$PATH
RUN apt-get -y autoremove && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash app_runner
RUN adduser app_runner sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER app_runner
RUN mkdir /home/app_runner/.ssh
RUN mkdir /home/app_runner/approot
RUN mkdir -p /home/app_runner/gem_path/ruby/2.3.0
ENV BUNDLE_PATH /home/app_runner/gem_path/ruby/2.3.0
ENV GEM_PATH /home/app_runner/gem_path/ruby/2.3.0
ENV GEM_HOME /home/app_runner/gem_path/ruby/2.3.0
WORKDIR /home/app_runner/approot
