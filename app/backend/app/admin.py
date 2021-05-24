from django.contrib import admin
from .models import Zkurrate

class Zkurrate(admin.ModelAdmin):
    list_display = ('title', 'description', 'completed')

# Register models
admin.site.register(Zkurrate)