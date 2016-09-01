FROM fluent/fluentd:latest
MAINTAINER Viktor Petersson <petersson@gmail.com>
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

USER root
RUN apk --no-cache --update add sudo build-base ruby-dev && \
    sudo -u fluent gem install fluent-plugin-secure-forward fluent-plugin-elasticsearch fluent-plugin-record-reformer && \
    rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem && sudo -u fluent gem sources -c && \
    apk del sudo build-base ruby-dev && rm -rf /var/cache/apk/*
ADD fluent.conf /fluentd/etc/fluent.conf
EXPOSE 24284

CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
