# ArtifactAi

[![Lifecycle: Alpha](https://img.shields.io/badge/lifecycle-alpha-a0c3d2.svg)](https://img.shields.io/badge/lifecycle-alpha-a0c3d2.svg)

## Get started

This is an [Elixir](https://elixir-lang.org/) application built using the [Phoenix Framework](https://www.phoenixframework.org/). Before you begin, please take a minute to read through the [Installation Guide](https://hexdocs.pm/phoenix/installation.html). By installing dependencies beforehand, you'll be able to get the application up and running smoothly.

First start a PostgreSQL database:

```console
$ docker pull postgres:alpine
$ docker run --detach --name artifact_ai -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:alpine
```

Then start the Phoenix server:

```console
$ mix setup
$ mix phx.server
```

Now you can visit http://localhost:4000 in your browser.
