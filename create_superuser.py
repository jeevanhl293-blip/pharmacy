import os
import sys

# This script must be run from the project root and with PYTHONPATH that includes manage.py's project
# Usage: python create_superuser.py <username> <email> <password>

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print('Usage: python create_superuser.py <username> <email> <password>')
        sys.exit(2)
    username, email, password = sys.argv[1], sys.argv[2], sys.argv[3]

    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'pharmacy_project.settings')
    import django
    django.setup()
    from django.contrib.auth import get_user_model
    User = get_user_model()
    if User.objects.filter(username=username).exists():
        print(f"User '{username}' already exists")
        sys.exit(0)
    User.objects.create_superuser(username=username, email=email, password=password)
    print(f"Superuser '{username}' created")
