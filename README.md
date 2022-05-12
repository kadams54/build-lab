# Build Lab

This repo is an experiment to see if building a particular Python library (confluent-kafka) succeeds or fails in four different environments:

* Python 3.9.8 and `pip`
* Python 3.9.8 and `poetry`
* Python 3.10.4 and `pip`
* Python 3.10.4 and `poetry`

## Hypothesis

I believe the compile errors will happen regardless of whether pip or poetry or used. Furthermore, I believe fixing the compile error requires switching to Python 3.9.x (which has pre-compiled wheels available) _and_ deleting/recreating the virtualenv.

## Findings

I thought about putting this at the end, but you all are busy people, so here you go: when I run the experiment on my local setup (an M1 Mac), I see the compile error across all four environments. I'd expected to see it for both `pip` and `poetry` in Python 3.10.4, but also seeing it in 3.9.8 surprised me. Upon further reflection, I suspected that this was due to being on an ARM architecture, which is even less likely to have a pre-compiled wheel available. I'm looking forward to repeating the experiment on an x86 machine to see if that changes the results.

## Requirements

You'll need the following installed. Note that I used the versions noted below, all of which represented the most-up-to-date available when I ran my experiment on 2022/05/11:

* [pyenv](https://github.com/pyenv/pyenv) 2.3.0
* [poetry](https://python-poetry.org/) 1.1.13
* Python 3.9.8 and 3.10.4 installed via `pyenv`

You'll also need to make sure you don't have your `CPATH` set, for example, in your `.bashrc`. My first attempt at this failed because I'd forgotten that I'd setup my `.zshrc` to correctly setup the `CPATH` so that the `librdkafka.h` was in a location that could be found. Consequently I never saw the error the first time through and was very confused.

## Methodology

*The short version:*

Run `./start.sh` to test all the combinations listed above. See which ones spit out errors about `librdkafka.h`.

*The longer version:*

`./start.sh` does the following:

1. Changes into each subdirectory, which sets the proper python version via `.python-version`.
1. Makes sure the `virtualenv` is deleted.
1. Uses either `pip` or `poetry` to install* `confluent-kafka`; the output is then grep'd for any mentions of `librdkafka.h`.
1. Cleans up the `virtualenv` and any other build artifacts, e.g., `poetry.lock`.

Note that, as much as possible, caching was disabled throughout the process. The reason: to force a complete rebuild of `confluent-kafka`.
