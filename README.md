# digisos-docker-compose
Docker-compose oppsett for digisos. For å gjøre lokal utvikling enklere.

Kjør `docker-compose up`

Kommando for å hente ned nyeste images: \
`docker-compose pull`
(NB: må være innlogget)

## Lokal utvikling
### Docker-minne
Det kan være nødvendig å justere minne til Docker.

### Docker-login
For å laste ned images fra Github Package Registry må man være autentisert. For å autentisere deg mot Github, se:\
https://docs.github.com/en/packages/guides/configuring-docker-for-use-with-github-packages#authenticating-with-a-personal-access-token

Lag et Personal Access Token med scope `read:packages`, og husk å enable SSO. Lagre tokenet i en fil, eks `TOKEN.txt`\
Deretter kjør `cat ~/TOKEN.txt | docker login https://docker.pkg.github.com -u USERNAME --password-stdin` hvor `USERNAME` er ditt Github-brukernavn.\
Evt: `cat ~/TOKEN.txt | docker login https://docker.pkg.github.com -u x-access-token --password-stdin`

### Debugging
Hvis du får merkelige feilmeldinger om nedlasting av metadata så kan du prøve docker logout og ny login.\
Kanskje relevant tråd: https://github.com/docker/buildx/issues/476
