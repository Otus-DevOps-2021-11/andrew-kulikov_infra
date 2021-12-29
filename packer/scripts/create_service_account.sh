#!/bin/bash
SVC_ACCT="packer"
FOLDER_ID="b1gtckbo97fa9l1lqac7"
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
ACCT_ID=$(yc iam service-account get $SVC_ACCT | \
          grep ^id | \
          awk '{print $2}')
yc resource-manager folder add-access-binding --id $FOLDER_ID \
                                              --role editor \
                                              --service-account-id $ACCT_ID
yc iam key create --service-account-id $ACCT_ID --output ~/yandexcloud/key.json
