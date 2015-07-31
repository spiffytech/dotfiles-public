#!/bin/zsh
REPOSITORY=home_backups:spiffytop.attic

# Backup all of /home and /var/www except a few
# excluded directories
attic create --stats              \
    $REPOSITORY::`date +%Y-%m-%d_%H:%M:%S`  \
    Documents                               \
    Music                                   \
    Pictures                                \

# Use the `prune` subcommand to maintain 7 daily, 4 weekly
# and 6 monthly archives.
attic prune -v $REPOSITORY --keep-within=24H --keep-daily=7 --keep-weekly=4 --keep-monthly=6 --keep-yearly=1
