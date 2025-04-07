#!/bin/bash

set -e

function generate() {
    echo " -> Generating symbol=$1 dot=$2 ..."
    openscad -D symbol=\"$1\" -D dot=$2 -o keycap_$1.stl --export-format binstl --hardwarnings keycap.scad
    echo " -> Done"
}

generate A false
generate B false
generate C false
generate D false
generate E false
generate F false
generate G false
generate H false
generate I false
generate J false
generate K false
generate L false
generate M false
generate N true
generate O false
generate P false
generate Q false
generate R false
generate S false
generate T true
generate U false
generate V false
generate W false
generate X false
generate Y false
generate Z false
