from django.urls import path
from .views import QuoteListView, random_quote

urlpatterns = [
    path('quotes/', QuoteListView.as_view(), name='quote-list'),
    path('quotes/random/', random_quote, name='random-quote'),
]