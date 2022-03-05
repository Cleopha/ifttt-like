<br />
<div align="center">
  <a href="https://github.com/LedgerHQ/app-ethereum">
    <img src="https://img.icons8.com/nolan/64/paralell-workflow.png">
  </a>

  <h1 align="center">IFTTT-like</h1>

  <p align="center">
    Interconnection service between several services
    <br />
    <a href=""><strong>« Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Cleopha/ifttt-like/issues">Report Bug</a>
    · <a href="https://github.com/Cleopha/ifttt-like/issues">Request Feature</a>
  </p>
</div>
<br/>

<details>
  <summary>Table of Contents</summary>

- [Install](#install)
  - [:rocket: Clone repository](#rocket-clone-repository)
  - [:warning: Requirement](#warning-requirement)
- [:checkered_flag: Quick-Start](#checkered_flag-quick-start)
- [Authors:](#authors)

</details>

## Install

### :rocket: Clone repository

```shell
git clone git@github.com:Cleopha/ifttt-like.git
```

### :warning: Requirement

- [Docker](https://docs.docker.com/get-docker/)
- [Docker-compose](https://docs.docker.com/compose/install/)

## :checkered_flag: Quick-Start

```shell
docker-compose up --build
```

-> http://localhost:3000/

:bulb: Server API documentation is running on `/docs` endpoint and 
GRPC API documentation are available on [http://localhost:7777/workflow/](http://localhost:7777/workflow/)
and [http://localhost:7777/credential/](http://localhost:7777/credential/)

## Documentation

- [Backend](./backend): API system to manage users, workflows and credential
- [Obelix](./obelix): System to watch for action and execute reaction
- [Frontend](./frontend): Mobile and Web application

## Authors:


| [<img src="https://github.com/TomChv.png?size=85" width=85><br><sub>Tom CHAUVEAU</sub>](https://github.com/TomChv) | [<img src="https://github.com/Cleopha.png?size=85" width=85><br><sub>Coline SEGURET</sub>](https://github.com/Cleopha) | [<img src="https://github.com/PtitLuca.png?size=85" width=85><br><sub>Luca GEORGES FRANCOIS</sub>](https://github.com/PtitLuca) 
| :---: | :---: | :---: |

| [<img src="https://github.com/QuentinFringhian.png?size=85" width=85><br><sub>Quentin FRINGHIAN</sub>](https://github.com/QuentinFringhian) | [<img src="https://github.com/Thytu.png?size=85" width=85><br><sub>Valentin DE MATOS</sub>](https://github.com/Thytu) | [<img src="https://github.com/etarc0s.png?size=85" width=85><br><sub>Alexandre GOUASMI</sub>](https://github.com/etarc0s) |
| :---: | :---: | :---: |