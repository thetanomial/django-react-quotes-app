from django.contrib import admin
from .models import Quote

@admin.register(Quote)
class QuoteAdmin(admin.ModelAdmin):
    list_display = ('text', 'author', 'created_at')
    list_filter = ('author', 'created_at')
    search_fields = ('text', 'author')
    ordering = ('-created_at',)