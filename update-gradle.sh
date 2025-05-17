#!/bin/bash

read -r -d '' TASK_BLOCK << 'EOF'

task deployDefaultNodes(type: net.corda.plugins.Cordform, dependsOn: ['jar']) {
    nodeDefaults {
        projectCordapp {
            deploy = false
        }
        cordapp project(':contracts')
        cordapp project(':workflows')
        runSchemaMigration = true
    }
    node {
        name "O=Notary,L=London,C=GB"
        notary = [validating : false]
        p2pPort 10002
        rpcSettings {
            address("0.0.0.0:10003")
            adminAddress("0.0.0.0:10043")
        }
    }
    node {
        name "O=PartyA,L=London,C=GB"
        p2pPort 10005
        rpcSettings {
            address("0.0.0.0:10006")
            adminAddress("0.0.0.0:10046")
        }
        rpcUsers = [[ user: "user1", "password": "test", "permissions": ["ALL"]]]
    }
    node {
        name "O=PartyB,L=New York,C=US"
        p2pPort 10008
        rpcSettings {
            address("0.0.0.0:10009")
            adminAddress("0.0.0.0:10049")
        }
        rpcUsers = [[ user: "user1", "password": "test", "permissions": ["ALL"]]]
    }
        node {
        name "O=PartyC,L=New York,C=US"
        p2pPort 10011
        rpcSettings {
            address("0.0.0.0:10012")
            adminAddress("0.0.0.0:10052")
        }
        rpcUsers = [[ user: "user1", "password": "test", "permissions": ["ALL"]]]
    }
}
EOF

# build.gradle に追記
echo "$TASK_BLOCK" >> ./cordapp/build.gradle
echo "Added deployDefaultNodes into build.gradle"
