#!/usr/bin/env python3

import argparse
import os
import subprocess
import sys

def build(directory):
    print(f"Building in {directory}")
    subprocess.call("cmake --build .", cwd=directory, shell=True)


def test(directory):
    print(f"Start testing in {directory}")
    for entry in os.scandir(directory):
        print(f"Now testing {entry.path}")
    print("Testing complete!")


def parse_cmd():
    parser = argparse.ArgumentParser()

    parser.add_argument("-b", "--build", help="Specify the build directory")
    parser.add_argument("-c", "--check", help="Test directory to check")

    args = parser.parse_args()
    build_dir, test_dir = args.build, args.check

    build(build_dir)
    test(test_dir)


if __name__ == "__main__":
    parse_cmd()
