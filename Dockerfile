#ARG PIHOLE_VERSION
FROM pihole/pihole:2023.02.2
RUN apt update && apt install -y unbound wget

COPY pihole-unbound/lighttpd-external.conf /etc/lighttpd/external.conf 
COPY pihole-unbound/unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY pihole-unbound/99-edns.conf /etc/dnsmasq.d/99-edns.conf
RUN mkdir -p /etc/services.d/unbound
COPY pihole-unbound/unbound-run /etc/services.d/unbound/run
RUN wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints
RUN apt install -y nano

ENTRYPOINT ./s6-init

#HEALTHCHECK CMD dig @127.0.0.1 pi.hole || exit 1
