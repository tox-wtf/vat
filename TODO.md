# TODO

- [ ] Fix release script
- [ ] Make ERROR and WARN logs less ugly
    - [x] Move timeout errors to rust
    - [ ] Clean up redundant error messages
    - [ ] Capture common error messages from stderr and map them to an `Error`
        - [ ] `fatal: unable to access 'https://gcc.gnu.org/git/gcc.git/': The requested URL returned error: 500` -> `Error::Http(Code)`
- [ ] Write a shell script to find package versions that have not been updated
  in a while. These might then be manually confirmed.
- [ ] Consider supporting nvchecker
- [ ] Support chances at the channel level
