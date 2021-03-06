# Cosmos-SatNOGS-SpaceTrack-Interface [CoSSI]

[![license](https://img.shields.io/github/license/oresat/uniclogs-cossi)](./LICENSE)
[![pypi](https://img.shields.io/pypi/v/uniclogs-cossi)](https://pypi.org/project/uniclogs-cossi/)
[![read the docs](https://img.shields.io/readthedocs/uniclogs-cossi)](https://uniclogs-cossi.readthedocs.io)
[![issues](https://img.shields.io/github/issues/oresat/uniclogs-cossi/bug)](https://github.com/oresat/uniclogs-cossi/labels/bug)
[![unit tests](https://img.shields.io/github/workflow/status/oresat/uniclogs-cossi/Unit%20Tests)](https://github.com/oresat/uniclogs-cossi/actions/workflows/unit-tests.yaml)
[![deployment](https://img.shields.io/github/workflow/status/oresat/uniclogs-cossi/Deploy%20to%20PyPi)](https://github.com/oresat/uniclogs-cossi/actions/workflows/deployment.yaml)

An application for fetching the latest relevant satellite metadata and telemetry from SatNOGSs' and Space-Tracks' API's for immediate digestion by the Portland State Aerospace Society's UniClOGS server and respective services.

***

# Quick Start

### Installation

`$` `pip install uniclogs-cossi`

### Environment Variables

Certain environment variables are required depending on which features are needed.

**SpaceTrack:**

These are required in order to fetch the latest TLE data.

*(See: Space-Track's [faq](https://www.space-track.org/documentation#howto) for setting up authentication)*

* `SPACETRACK_USERNAME`
* `SPACETRACK_PASSWORD`

**SatNOGS:**

These are required in order to fetch satellite metadata and telemetry.

*(See: SatNOGS's [api page](https://db.satnogs.org/api) for setting up authentication)*

* `SATNOGS_DB_TOKEN`

**COSMOS DART:**

These are required in order to submit data to COSMOS ground-station services, such as DART.

* `DART_HOST`
* `DART_PORT`
* `DART_DB`
* `DART_USERNAME`
* `DART_PASSWORD`

### Run

`$` `uniclogs-cossi`

*(Help and usage)*

`$` `uniclogs-cossi --help`

### Examples

In order to use COSI, it requires a known NORAD ID of an active satellite that is at least registered in [SatNOGS](https://db.satnogs.org) if you wish to grab satellite metadata and telemetry and [Space-Track](https://www.space-track.org) if you wish to grab a satellite's latest TLE's.

*([Register with SatNOGS here](https://wiki.satnogs.org/Satellite_Operator_Guide#2.2_Add_a_new_Mission))*


**Get Latest TLE for Bobcat-1:** *(NORAD ID: 46922)*

`$` `uniclogs-cossi --tle 46922`

**Get Satellite Metadata and telemetry for Bobcat-1:**

`$` `uniclogs-cossi --satellite-metadata --telemetry 46922`

**Get Telemetry for OreFlat0 in SatNOGS DB Dev and decode it using the OreFlat0 decoder:**

`$` `uniclogs-cossi --telemetry --decode --satnogs-dev 99910`

***

# Development and Contribution

### Documentation

Check out our [Read The Docs](https://uniclogs-software.readthedocs.io) pages for more info on the applications and the various systems it interacts with.

### Install Locally

`$` `pip install -e .[dev]`

*(Note: the `-e` flag creates a symbolic-link to your local development version. Set it once, and forget it)*

### Create Documentation Locally

`$` `make -C docs clean html`

*(Note: documentation is configured to auto-build with ReadTheDocs on every push to master)*
