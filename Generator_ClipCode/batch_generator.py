#!/usr/bin/python

#
# Copyright (c) 2020 Apple Inc. All rights reserved.
# 
# Licensed under Apple Sample Script License (which
# is contained in the ACC_SAMPLE_SCRIPT_LICENSE.txt
# file distributed with this file).
#

from __future__ import print_function

import os
import csv
import argparse
from subprocess import Popen, PIPE


def generate(out_fname, url, background_col, foreground_col, code_type, logo_type):
    """Generate one App Clip Code using the provided input parameters.
    :param: out_fname The name of the SVG file to save.
    :param: url The URL to encode.
    :param: background_col The background color's hexadecimal representation, for example, 'FFFFFF'.
    :param: foreground_col The foreground color's hexadecimal representation, for  '000000'.
    :param: code_type The App Clip Code's type, either 'nfc' or 'cam'.
    :param: logo_type The App Clip Code's design, either 'none' or 'badge'.
    """

    assert code_type.lower() in [
        "nfc",
        "cam",
    ], "The type must be either 'cam' or 'nfc'"
    assert logo_type.lower() in [
        "none",
        "badge",
    ], "The design type must be either 'none' or 'badge'"

    if not out_fname or os.path.exists(out_fname):
        raise ValueError(out_fname + " already exists")

    cmd = [
        "AppClipCodeGenerator",
        "generate",
        "--url",
        url,
        "--background",
        background_col,
        "--foreground",
        foreground_col,
        "--type",
        code_type,
        "--logo",
        logo_type,
        "--output",
        out_fname,
    ]

    print("Generating", out_fname)
    p = Popen(cmd, stdout=PIPE, stderr=PIPE)
    error = p.communicate()[1]
    if p.returncode != 0:
        raise RuntimeError(error)


def generate_list(input_list, output_folder):
    """Parse the CSV file and generate one App Clip Code for each entry.
    :param: input_list The CSV file that contains the information for each App Clip Code.
    :param: output_folder The folder used to store the generated App Clip Codes' SVG files.
    """

    with open(input_list) as csv_list:
        csv_reader = csv.reader(csv_list, delimiter=",")

        # Skip CSV header
        header = next(csv_reader)
        assert (
            ",".join(header).lower() == "svg file name,url,background color,foreground color,type,logo"
        )

        # Iterate over list
        for row in csv_reader:
            assert len(row) == 6, "Expecting 6 elements on each row."
            row[0] = os.path.join(output_folder, row[0])
            generate(*row)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "input_list", help="The CSV file that contains the information for each App Clip Code."
    )
    parser.add_argument("output_folder", help="Output folder")
    args = parser.parse_args()

    if not args.input_list or not os.path.exists(args.input_list):
        raise ValueError("File", args.input_list, "doesn't exist.")

    if (
        not args.output_folder
        or not os.path.exists(args.output_folder)
        or not os.path.isdir(args.output_folder)
    ):
        raise ValueError("Folder", args.output_folder, "doesn't exist.")

    generate_list(args.input_list, args.output_folder)
