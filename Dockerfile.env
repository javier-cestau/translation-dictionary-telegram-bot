ARG appdir=/srv/javierc-bot

FROM ruby:2.6.0-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
           build-essential \
           curl \
           git \
           gnupg \
           gstreamer1.0-plugins-base \
           gstreamer1.0-tools \
           gstreamer1.0-x \
           libgl1-mesa-dri \
           libmsgpack-dev \
           libpq-dev \
           libxml2-dev \
           libqt5webkit5-dev \
           libcurl4-openssl-dev \
           openssh-client \
           pdftk \
           qt5-default \
           xauth \
           xvfb \
           r-base-core \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
           nodejs \
           yarn \
    && rm -rf /var/lib/apt/lists/*

ARG appdir
WORKDIR $appdir

COPY Gemfile Gemfile.lock $appdir/
RUN bundle install
COPY init.R $appdir/
RUN Rscript init.R

ENV HOST=0.0.0.0

CMD ["bash"]
