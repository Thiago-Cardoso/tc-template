FROM ruby:2.7.1
MAINTAINER dev
RUN echo 'Acquire::Check-Valid-Until no;' > /etc/apt/apt.conf.d/99no-check-valid-until
RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
ENV APP_HOME /app
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:/app/:$PATH
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

RUN gem install bundler -v 1.17.2
RUN bundle install --with test
ADD . $APP_HOME

# Copy our Gemfile to inside the container
COPY . .
RUN bundle install
RUN chmod 755 template.rb
ENTRYPOINT ["sh", "entry.sh"]
