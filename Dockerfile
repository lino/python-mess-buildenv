# This file needs a pythonversion supplied at the end of the file
# Example: ARG PYTHONVERSION=3.7.8
FROM linoio/python-mess-buildenv-base:latest
ARG PYTHONVERSION
ENV PYTHON_VERSION=${PYTHONVERSION}
MAINTAINER lino@lino.io
RUN scripts/python-install.sh ${PYTHONVERSION}
