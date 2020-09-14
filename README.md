# python-mess-buildenv

This repository contains a branch called `versions/VERSION` for each buildenv docker image.
`VERSION` usually is a python version in the `a.b.c` format.

## Respected tags

The following tags are respected and published

- production
- staging
- development
- cipipeline

## Convenience helpers
In these examples `3.7.8` will be used as target version.

### Build new version
To create a new branch and push it use

    build-version.sh 3.7.8
    
### Delete old version

To remove an old version and push the changes use

    delete-version.sh 3.7.8
    
### Tag version

To tag an existing version and push it use

    tag-version.sh 3.7.8 cipipeline
    
