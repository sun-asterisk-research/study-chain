#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGCAP}/$7/" \
        ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${ORGCAP}/$7/" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=academy
ORGCAP=Academy
P0PORT=30110
P1PORT=30110
CAPORT=7054
PEERPEM=/fabric/crypto-config/peerOrganizations/academy.certificate.com/tlsca/tlsca.academy.certificate.com-cert.pem
CAPEM=/fabric/crypto-config/peerOrganizations/academy.certificate.com/ca/ca.academy.certificate.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $ORGCAP)" > /fabric/connection-academy.json


ORG=student
ORGCAP=Student
P0PORT=30110
P1PORT=30110
CAPORT=7054
PEERPEM=/fabric/crypto-config/peerOrganizations/student.certificate.com/tlsca/tlsca.student.certificate.com-cert.pem
CAPEM=/fabric/crypto-config/peerOrganizations/student.certificate.com/ca/ca.student.certificate.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM $ORGCAP)" > /fabric/connection-student.json
