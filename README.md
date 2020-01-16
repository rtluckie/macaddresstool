# macaddresstool
A tool to retrieve information about MAC Addresses that uses macaddress.io

## Usage
### Installation Options
1. Download the [wrapper script](https://raw.githubusercontent.com/rtluckie/macaddresstool/master/hack/macaddresstool) and place it somewhere on your $PATH
1. Install binary locally by running `make install-bin`.
  - Installed to $GOPATH/bin/
2. Build the image with `make build` (see the above wrapper script for example invocation)

 
### Setup
* Signup for [macaddress.io](https://macaddress.io/signup) and get API KEY
* Set environment variable `export MACADDRESSIO_API_KEY='<YOUR_API_KEY>'`
* You can also pass the API key as an argument (see `macaddresstool --help` for details)

## Security
* API Key is set via an environment variable
* Docker container runs as non-root user 
* Docker image metadata labels to enable validation
* Use minimal base image w/ zero OS dependencies
* Minimal golang dependencies (3 direct, 1 indirect, 12 transitive)

## Examples

**json output** (default)
```bash
$ macaddresstool --address 44:38:39:ff:ef:57 | jq
{
  "blockDetails": {
    "assignmentBlockSize": "MA-L",
    "blockFound": true,
    "blockSize": 16777216,
    "borderLeft": "443839000000",
    "borderRight": "443839FFFFFF",
    "dateCreated": "2012-04-08",
    "dateUpdated": "2015-09-27"
  },
  "macAddressDetails": {
    "administrationType": "UAA",
    "applications": [
      "Multi-Chassis Link Aggregation (Cumulus Linux)"
    ],
    "comment": "",
    "isValid": true,
    "searchTerm": "44:38:39:ff:ef:57",
    "transmissionType": "unicast",
    "virtualMachine": "Not detected",
    "wiresharkNotes": "No details"
  },
  "vendorDetails": {
    "companyAddress": "650 Castro Street, suite 120-245 Mountain View CA 94041 US",
    "companyName": "Cumulus Networks, Inc",
    "countryCode": "US",
    "isPrivate": false,
    "oui": "443839"
  }
}
```

**Yaml output**
```bash
$ macaddresstool --address 44:38:39:ff:ef:57 --output yaml 
blockDetails:
  assignmentBlockSize: MA-L
  blockFound: true
  blockSize: 16777216
  borderLeft: "443839000000"
  borderRight: 443839FFFFFF
  dateCreated: "2012-04-08"
  dateUpdated: "2015-09-27"
macAddressDetails:
  administrationType: UAA
  applications:
  - Multi-Chassis Link Aggregation (Cumulus Linux)
  comment: ""
  isValid: true
  searchTerm: 44:38:39:ff:ef:57
  transmissionType: unicast
  virtualMachine: Not detected
  wiresharkNotes: No details
vendorDetails:
  companyAddress: 650 Castro Street, suite 120-245 Mountain View CA 94041 US
  companyName: Cumulus Networks, Inc
  countryCode: US
  isPrivate: false
  oui: "443839"
```

**Limit output to `vendorDetails`**
```bash
$ macaddresstool --address 44:38:39:ff:ef:57 --selector 'vendorDetails' | jq
{
  "companyAddress": "650 Castro Street, suite 120-245 Mountain View CA 94041 US",
  "companyName": "Cumulus Networks, Inc",
  "countryCode": "US",
  "isPrivate": false,
  "oui": "443839"
}
```

**Limit output to `vendorDetails.companyName`**
```bash
$ macaddresstool --address 44:38:39:ff:ef:57 --selector 'vendorDetails.companyName'
Cumulus Networks, Inc
```
