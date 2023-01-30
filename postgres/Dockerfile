FROM postgres:15.1

# local
RUN localedef -i ko_KR -c -f UTF-8 -A /usr/share/locale/locale.alias ko_KR.UTF-8
ENV LANG ko_KR.utf8

# install contributed packages
RUN apt-get update -y
RUN apt-get install -y postgresql-contrib
