#!/usr/bin/env bash

echo "Bootstrapping..."

CONTAINER="hsbe_shell_command_1"
IN_DOCKER_DIR="/tmp"

# Creates a temp directory
ts=$(date +%s)
tmp_dir_in_docker="${IN_DOCKER_DIR}/${ts}"
docker exec -i "${CONTAINER}" mkdir ${tmp_dir_in_docker}

# Copies the python part of the script into temp directory
tail -n+$(awk '/^__CODE_STARTS__/ {print NR + 1; exit 0;}' $0) $0 | docker exec -i "${CONTAINER}" bash -c "tail -n+0 > ${tmp_dir_in_docker}/code.py"

echo "Running python..."
# unset SENTRY_DSN is to prevent noise internally. No-op for external use
docker exec -i "${CONTAINER}" bash -c "unset SENTRY_DSN; source /var/www/venv/bin/activate; cd ${tmp_dir_in_docker}; python code.py $*;tar zcf ${tmp_dir_in_docker}.tar.gz -C $(dirname ${tmp_dir_in_docker}) $(basename ${tmp_dir_in_docker}) && rm -rf ${tmp_dir_in_docker}"

exit 0

__CODE_STARTS__
# Standard run/python path to ensure imports work properly
import sys
sys.path.append('/var/www/forms/forms')

# Initialize Django
import django
django.setup()

from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType

from form_extraction.user_permissions import APPLICATION_PERMS
from user_profile.models import UserProfile

codenames = []
for perm_map in APPLICATION_PERMS:
    for group, permissions in perm_map.items():
        for perm in permissions:
            codenames.append(perm.codename)

up_content_type = ContentType.objects.get_for_model(UserProfile)
for db_instance in Permission.objects.filter(codename__in=codenames):
    if db_instance.content_type != up_content_type:
        print(f'Unexpected content type: {db_instance.content_type}, fixing...')
        db_instance.content_type = up_content_type
        db_instance.save(update_fields=['content_type'])
        print(f'Updated')
