import secrets

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.db import models


class CustomUserManager(BaseUserManager):
    def create_user(self, username, email, password=None):
        if username is None:
            raise ValueError("Users must have a username.")
        if email is None:
            raise ValueError("Users must have an email address.")

        email = self.normalize_email(email)
        user = self.model(username=username, email=email)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, email, password=None):
        raise NotImplementedError("Superuser creation is not implemented.")

class CustomUser(AbstractBaseUser):
    id = models.AutoField(primary_key=True, unique=True, editable=False)
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=255, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    objects = CustomUserManager()
    USERNAME_FIELD = 'username'

    def __str__(self):
        return self.username
