//menu data list
import 'package:flutter/material.dart';

List dataList = [
  {
    "id": 1,
    "level": 0,
    "icon": Icons.home_outlined,
    "title": "Dashboard",
    "children": [],
  },

  {
    "id": 2,
    "level": 0,
    "icon": Icons.list_rounded,
    "title": "Nomenclator",
    "children": [
      {
        "id": 3,
        "level": 1,
        "title": "Produse",
      },
      {
        "id": 4,
        "level": 1,
        "title": "Tip Produse",
      },
      {
        "id": 5,
        "level": 1,
        "title": "Unități de Măsură",
      },
      {
        "id": 6,
        "level": 1,
        "title": "Parteneri",
      }
    ]
  },

  //menu data item
  {
    "id": 7,
    "level": 0,
    "icon": Icons.login_outlined,
    "title": "Intrari",
    "children": [
      {
        "id": 8,
        "level": 1,
        "title": "Avize Furnizor",
      },
      {
        "id": 9,
        "level": 1,
        "title": "Facturi Furnizor",
      },
      {
        "id": 10,
        "level": 1,
        "title": "NIR-uri",
      }
    ]
  },

  //menu data item
  {
    "id": 11,
    "level": 0,
    "icon": Icons.logout_outlined,
    "title": "Ieșiri",
    "children": [
      {
        "id": 12,
        "level": 1,
        "icon": Icons.paypal,
        "title": "Avize Client",
      },
      {
        "id": 13,
        "level": 1,
        "icon": Icons.credit_card,
        "title": "Facturi Client",
        "subtitle": "Vânzare - Facturi de Vânzare",
      }
    ]
  },

  //menu data item
  {
    "id": 14,
    "level": 0,
    "icon": Icons.warehouse_outlined,
    "title": "Depozit",
    "children": [
      {
        "id": 15,
        "level": 1,
        "title": "Bon de Consum",
      },
      {
        "id": 16,
        "level": 1,
        "title": "Nota de Predare",
      }
    ]
  },

  //menu data item
  {
    "id": 17,
    "level": 0,
    "icon": Icons.precision_manufacturing_outlined,
    "title": "Producție",
    "children": [
      {
        "id": 18,
        "level": 1,
        "title": "Rapoarte Producție",
      },
      {
        "id": 19,
        "level": 1,
        "title": "Rețete",
      },
    ]
  },

  //menu data item
  {
    "id": 20,
    "level": 0,
    "icon": Icons.topic_outlined,
    "title": "Rapoarte",
    "children": [
      {
        "id": 21,
        "level": 1,
        "title": "Print Raport Producție",
      },
      {
        "id": 22,
        "level": 1,
        "title": "Stocuri",
      },
      {
        "id": 23,
        "level": 1,
        "title": "Avize Client Nefacturate",
      },
      {
        "id": 24,
        "level": 1,
        "title": "Avize Furnizor Nerecepționate",
      },
    ]
  },
];
