from django.core.management.base import BaseCommand
from quotes.models import Quote

class Command(BaseCommand):
    help = 'Populate database with sample quotes'

    def handle(self, *args, **options):
        sample_quotes = [
            {"text": "The only way to do great work is to love what you do.", "author": "Steve Jobs"},
            {"text": "Innovation distinguishes between a leader and a follower.", "author": "Steve Jobs"},
            {"text": "Life is what happens to you while you're busy making other plans.", "author": "John Lennon"},
            {"text": "The future belongs to those who believe in the beauty of their dreams.", "author": "Eleanor Roosevelt"},
            {"text": "It is during our darkest moments that we must focus to see the light.", "author": "Aristotle"},
            {"text": "Success is not final, failure is not fatal: it is the courage to continue that counts.", "author": "Winston Churchill"},
            {"text": "The only impossible journey is the one you never begin.", "author": "Tony Robbins"},
            {"text": "In the middle of difficulty lies opportunity.", "author": "Albert Einstein"},
            {"text": "Believe you can and you're halfway there.", "author": "Theodore Roosevelt"},
            {"text": "The only limit to our realization of tomorrow will be our doubts of today.", "author": "Franklin D. Roosevelt"},
        ]

        for quote_data in sample_quotes:
            quote, created = Quote.objects.get_or_create(
                text=quote_data["text"],
                defaults={'author': quote_data["author"]}
            )
            if created:
                self.stdout.write(
                    self.style.SUCCESS(f'Successfully created quote: "{quote.text[:50]}..."')
                )
            else:
                self.stdout.write(f'Quote already exists: "{quote.text[:50]}..."')

        self.stdout.write(
            self.style.SUCCESS(f'Database now contains {Quote.objects.count()} quotes')
        )