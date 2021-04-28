# digisos-docker-compose
Docker-compose oppsett for digisos. For å gjøre lokal utvikling enklere.

Kjør `docker-compose up`

## Lokal utvikling
### Docker-minne
Det kan være nødvendig å justere minne til Docker.

### Docker-login
For å laste ned images fra Github Package Registry må man være autentisert. For å autentisere deg mot Github, se:\
https://docs.github.com/en/packages/guides/configuring-docker-for-use-with-github-packages#authenticating-with-a-personal-access-token

Lag et Personal Access Token med scope `read:packages`. Husk å enable SSO.\
Deretter kjør `$ cat ~/TOKEN.txt | docker login https://docker.pkg.github.com -u USERNAME --password-stdin` hvor `USERNAME` er ditt Github-brukernavn.

Det kan hende du må logge ut før du forsøker å logge inn.