#!/usr/bin/env python3

import subprocess
import os
import argparse
import json


ENV_TERRAFORM_FOLDER = 'REDDITAPP_TERRAFORM_FOLDER'
APP_IP_OUTPUT_KEY = 'external_ip_address_app'
DB_IP_OUTPUT_KEY = 'external_ip_address_db'


def get_terraform_outputs(folder_path):
    with subprocess.Popen(['terraform', 'output'], cwd=folder_path, stdout=subprocess.PIPE) as process:
        return process.communicate()[0].decode('utf-8')


def parse_terraform_outputs(terraform_output_lines):
    return dict(map(parse_terraform_output_line, terraform_output_lines))


def parse_terraform_output_line(line):
    (name, value) = line.split(' = ')
    return (name, value)


def get_parsed_terraform_outputs():
    terraform_path = os.environ.get(ENV_TERRAFORM_FOLDER)

    output = get_terraform_outputs(terraform_path)
    output_lines = output.splitlines()

    return parse_terraform_outputs(output_lines)


class ExampleInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.yandex_terraform_inventory()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return an empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print(json.dumps(self.inventory))

    def yandex_terraform_inventory(self):
        terraform_outputs = get_parsed_terraform_outputs()

        app_instance_ip = terraform_outputs[APP_IP_OUTPUT_KEY]
        db_instance_ip = terraform_outputs[DB_IP_OUTPUT_KEY]

        return {
            'app': {
                'hosts': ['appserver']
            },
            'db': {
                'hosts': ['dbserver']
            },
            '_meta': {
                'hostvars': {
                    'appserver': {
                        'ansible_host': app_instance_ip
                    },
                    'dbserver': {
                        'ansible_host': db_instance_ip
                    }
                }
            }
        }

    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action='store_true')
        parser.add_argument('--host', action='store')
        self.args = parser.parse_args()


ExampleInventory()
