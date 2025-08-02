from rest_framework import generics
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import Quote
from .serializers import QuoteSerializer
import random

class QuoteListView(generics.ListAPIView):
    queryset = Quote.objects.all()
    serializer_class = QuoteSerializer

@api_view(['GET'])
def random_quote(request):
    quotes = Quote.objects.all()
    if quotes.exists():
        quote = random.choice(quotes)
        serializer = QuoteSerializer(quote)
        return Response(serializer.data)
    return Response({'message': 'No quotes available'}, status=404)