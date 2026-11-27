# digisos-docker-compose
Docker-compose oppsett for digisos. For å gjøre lokal utvikling enklere.

## Tusd/upload og mappe for lagring av filer
Man må gi tilgang til ./tusd-data for at tusd/upload containeren skal kunne lagre filer lokalt. Kjør følgende kommando i terminalen, dette trengs kun én gang:

```shell
sudo chmod -R 777 ./tusd-data
```

## Eksempler

For å starte alle tjenester:

```shell
docker-compose up
```

Du kan hente miljøvariabler fra en env-fil, bruk `--env-file`

```shell
docker-compose --env-file local.env up
```

For å starte mock-alt med API-et:

```shell\
docker-compose up sosialhjelp-mock-alt \
                   sosialhjelp-mock-alt-api
```

For å kjøre alle tjenester bortsett fra f.eks. innsyn-api: 

```shell
docker compose up --scale sosialhjelp-innsyn-api=0 -d
```

For å hente nyeste versjon av images:

```shell
docker-compose pull
```

## Postgres for innsyn-api

`postgres-innsyn` bruker Postgres 18 og databasen `sosialhjelp-innsyn-api`.
Start databasen alene hvis du kjører innsyn-api fra IDE:

```shell
docker compose up -d postgres-innsyn
```

Sett disse miljøvariablene i kjørekonfigurasjonen for innsyn-api:

```dotenv
PGJDBCURL=jdbc:postgresql://localhost:54323/sosialhjelp-innsyn-api?user=postgres&password=postgres
READWRITE_PGJDBCURL=jdbc:postgresql://localhost:54323/sosialhjelp-innsyn-api?user=postgres&password=postgres
```

Porten er bare tilgjengelig på localhost. Standardbruker og lokalt utviklingspassord er `postgres`.
Du kan overstyre passordet med `INNSYN_POSTGRES_PASSWORD` i Compose-miljøet; oppdater da også
tilkoblingsvariablene i IDE. Bruk URL-sikre tegn (bokstaver, tall, bindestrek og understrek) i dette
lokale passordet, siden Compose setter det direkte inn i JDBC-URL-ene.

Når innsyn-api kjører i Compose, bruker den `postgres-innsyn:5432` og venter til databasen er klar.
Med profilen `mock-alt` sletter og gjenoppretter Flyway skjemaet ved hver applikasjonsstart.
Bruk bare denne databasen til lokale testdata, aldri data som må beholdes.

## Autentisering

Mock-oauth2-serveren sender deg til mock-alt. Der velger du en person for å logge
inn gjennom Wonderwall. Du kan opprette og redigere personer fra samme side. Etter
lagring går du tilbake til innloggingen og velger personen.

`sosialhjelp-mock-alt` bruker image-taggen `latest`. Bytt til en bestemt GAR-tag i
`docker-compose.yml` hvis du trenger en bestemt versjon.

For å laste ned images fra Github Container Registry, må man være autentisert.

Lag et Personal Access Token med scope `read:packages`, og husk å enable SSO
(ref: [«Creating a personal access token»](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)).

Gitt brukernavn `$USERNAME` og din PAT lagret i `TOKEN.txt`, kan du kjøre:

```shell
cat ~/TOKEN.txt | docker login ghcr.io -u $USERNAME --password-stdin
```

Utfyllende dokumentasjon om innlogging:
[Authenticating to the Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)


### Mac

For å unngå å få tokenet lagret i klartekst lokalt, kan man bruke [docker-credential-helper](https://github.com/docker/docker-credential-helpers).

Kort oppsummert:
* Kjør `brew install docker-credential-helper`
* Sett `credsStore` til `osxkeychain` i ~/.docker/config.json, eks:
  ```json
  {
    "credsStore": "osxkeychain"
  }
  ```


## Caveats
### Docker-minne
Det kan være nødvendig å justere minne til Docker.

### Debugging
Hvis du får merkelige feilmeldinger om nedlasting av metadata så kan du prøve docker logout og ny login.\
Kanskje relevant tråd: https://github.com/docker/buildx/issues/476
