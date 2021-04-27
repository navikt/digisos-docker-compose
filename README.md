# digisos-docker-compose
Docker-compose oppsett for digisos. For å gjøre lokal utvikling enklere.
Kjør `docker-compose up`

## Lokal utvikling
### Docker-minne
Det kan være nødvendig å justere minne til Docker.

### Docker-login
For å laste ned images fra Github Package Registry må man være autentisert. For å autentisere deg mot Github:

Lag et Personal Access Token med scope `read:packages`. Husk å enable SSO
Deretter kjør `docker login https://docker.pkg.github.com -u USERNAME --password-stdin` hvor `USERNAME` er ditt Github-brukernavn.
