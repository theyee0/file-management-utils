# file-management-utils
Program for managing and backing up files, especially with heavily nested directories

## Building Documentation
The documentation for manage.sh is provided as a mandoc page.
To build an HTML copy with groff:
```
groff -mandoc manage.1 -Thtml > manage.html
```

## Running
```
./manage.sh [OPTIONS] SOURCE
```

Check the manual page for examples of usage and detailed descriptions of flags.
