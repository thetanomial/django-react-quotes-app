import json
import asyncio
import random
from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async
from .models import Quote
from .serializers import QuoteSerializer

class QuoteConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        self.should_send_quotes = True
        asyncio.create_task(self.send_periodic_quotes())

    async def disconnect(self, close_code):
        self.should_send_quotes = False

    async def send_periodic_quotes(self):
        while self.should_send_quotes:
            quote_data = await self.get_random_quote()
            if quote_data:
                await self.send(text_data=json.dumps({
                    'type': 'quote',
                    'data': quote_data
                }))
            await asyncio.sleep(15)

    @database_sync_to_async
    def get_random_quote(self):
        quotes = Quote.objects.all()
        if quotes.exists():
            quote = random.choice(quotes)
            serializer = QuoteSerializer(quote)
            return serializer.data
        return None