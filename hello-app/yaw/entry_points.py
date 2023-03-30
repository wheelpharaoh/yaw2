"""
yaw.entry_points.py
~~~~~~~~~~~~~~~~~~~~~~

This module contains the entry-point functions for the yaw module,
that are referenced in setup.py.
"""

from sys import argv

from . import main as yaw_main


def main() -> None:
    """Main package entry point.

    Delegates to other functions based on user input.
    """

    try:
        user_cmd = argv[1]
        if user_cmd == 'start':
            yaw_start()
        else:
            RuntimeError('please supply a command for yaw - e.g. start.')
    except IndexError:
        RuntimeError('please supply a command for yaw - e.g. start.')
    return None


def yaw_start() -> None:
    """Start webserver."""

    yaw_main()

    return None
