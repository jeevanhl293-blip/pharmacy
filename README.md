# Online Pharmacy - Advanced (Django scaffold)
This is a minimal advanced scaffold for an Online Pharmacy Management System.
## Features
- Categories, Medicines, Doctors, Appointments, Lab Tests, Orders
- Bootstrap-based responsive templates
- Search box and basic cart flow
## How to run
1. Create a virtualenv and activate it
2. pip install -r requirements.txt
3. python manage.py migrate
4. python manage.py createsuperuser
5. python manage.py runserver
## Notes
- DEBUG=True and a placeholder SECRET_KEY are used in settings.py; change for production.
- Media and static folders are configured for development.
