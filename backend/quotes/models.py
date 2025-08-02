from django.db import models

class Quote(models.Model):
    text = models.TextField()
    author = models.CharField(max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'"{self.text}" - {self.author}'

    class Meta:
        ordering = ['-created_at']