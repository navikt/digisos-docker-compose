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

For å starte et subsett av tjenester, spesifiser dem etter «up»:

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

## Autentisering

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
