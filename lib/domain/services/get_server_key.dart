import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKflueyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "task-flow-b8217",
        "private_key_id": "0163f37acf42fca88d4b9dce5ef224ec84318b6b",
        "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDnXrJCiRa0ob4c\no9EjyUt3Weqsp2fpQAitUSQxB5YHIj1KIjy5gAiCfWmRZkdQxgNHJ5dfsxpb8DuO\ndQ7e9Iv9gWPkIQaJ/8p2mRL73jMdAn4HrTDWEW6khdkni87IFdGEIr4hrviJtT+X\nRykQQMjwLYv48thwK5zXu7CEK4TxtwS33dh314X0QOgm34tZboKj3c8Anmri8tyW\nD2XIQpO/B0HbOOja59lICS2395ERacvBuO8gtjTG2d88R3aUc92pyou65xvSSXmI\nwoNxZyn3mPs7BFTYYvY8LwxOPtDbBOPo8MlZkyvFw6jej8NYN+utc/ZE3HzYGVZ3\nS7zeK9cxAgMBAAECggEACb6RwxPzVQaOM2Ds4Sp3AgmomhPviuyA+7ez+Vf98sKi\nPS869SnAx1TRL5KqBJYKXk1QZp3sSXH74tCS9e3rwBtadymy6k36cMtFTZP6qB6f\nleLZRd10a6Zy0mO6K5rLo6/ePRyZkscuQfNOde+ckY0Bh6nGrCwSDiif/bkNf4E8\nGsdtP3g6lBswwr5fETSkjEPHHOo0vQ+8Mc+T5S4D+h6+nesTyl6yCFyEkbfdEPBt\nUOeZTSOHCvEcAAmi511NDYZak1+KxoAtz5RMKPnCEZX4l3EDiDaJNs9F69wDEhxH\n9bJin5rWZuee1x2cqrvSwEUggnA6yThjif4LhE0UaQKBgQD7NB3Zv4skpPzjzpon\nU61xZ6Itbt4ToLMt0GDaVFH977NIM8MtvFAQRgUMOiPKETq3/CL8RRj9iEq+ANIL\nwVsDCYyu2uxbGODjzM1+NnaE2mbzvVlqLmz14g8pLlzf+e9f6+cOWHlzATMwqsU4\nHnENSJ5tIJlqTgYjKUfJLf0ylQKBgQDryaH5GlHZCB5Txi5Ajf87OlEdF4LB5Opw\nYSIW8/SutzFnk4wkIXBArbAjcsAGzHo9xXhP4KdiwvFa+EAD66v5ume+oirgEbGE\njUeDV5tUAUJWIkUouOMWaNOIvqhtnSzhrnLMvEzu+NdaSN1oRiTms56ScPkthKn4\nHJKswBBnLQKBgF0Qud5qMEqrNWXQrRvUzHUvR849PNlYuAlJIhjBFH9XxrwBMVZI\nZgEhb81P3OKH75EqQGvlzZRgYhByjV79i5Jcf1pokRhO50J+JcOUueQOZgX3KKFG\nAeg2kBdZrd7s4dpPs5KFBLmuwCBPpDFeVdPuC4OyiCPyNCPir03BVAThAoGAFYwO\njjoWgrPYOaWhsmqHiX0RzovIejmWJwDpYZmXoaPCEwoLw31+yZpVv1eMLtLe1OhH\nz1zjTwYrkjmfd/xAcgjT1Drzmhhj1Y4nm9wUqL+YtVBaa5dBwVmBAz0RHTtAz7rm\naMlIaoo4+9ouyYmnc6G0ewNx8fPuqGrMCJdgqF0CgYEAnOl73AJa6GhjyZHkK9CR\nC1ycAf5GsETS3uNV79GA2s+skmH9p/FiTZ9D2NOIS4BQ7N0QFUlHAQmigKGeahrp\nFPRXLuUgjH0xQLlAYChadPVH0imFuqqByAmA4J+augG65990STYRnexejkjHDUqS\nly+Nmamwl7AfSICdVyEGqtw=\n-----END PRIVATE KEY-----\n",        "client_email": "firebase-adminsdk-fbsvc@task-flow-b8217.iam.gserviceaccount.com",
        "client_id": "101412654653669045299",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40task-flow-b8217.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
// ya29.c.c0ASRK0Ga45vfI6JZXV3dXbSo9PbUo4xjvTufGCbhYeUT_IFYMFUC5YPd9uCmVp5x6A3OmvIwegeQ--pPWzkzCVKgxbpxjoTO0Z0HS065O14rz_QGXOOzxiAtXWrAayVh5bImJG8Ano0__DDpmaDOqM5hI5-gWwhuJzK5_mNtuTaPk35mH1__UFmYQhRY_lFV8ue0NeCdubsvBmLBjoZnPxKCxz-64QxTwwdmj7uZfsT4R3k9F_5p916PY8uE4Wt2ILEttY3CnsTsIcEV84B9LA1iJFqs_bqjkSHd1ed0SG5zcziqyGQ5yA9Yn9FRjbFCWetsdcuoXMKLpAoyZrnRvt7Nq9uZRg7GJEv91x7Cg1lZq2gawwBNb6lyt_aO9L389D4cSdz-9un3oyJ8mJ7XbydjxpVsF6QWhpxBfI1zqq-zUt76uM7Rh0ye042f0_OVjf12gsu8Q0vhVdYtZFzoXaUZq0jk2IZ_aYV7oW7zZ9-0zps__BvQeZidVj7rFgZyb3R0W79jJV6JcXb7Mm3va2-8VZ_3hqpjBf0nftS0g60oocO_erbprFJ6SfJy4XYZ383yYQnVs7YkerVklJgeWlje92fgjqRprry_pkrM9Fscs0-kJny1BhJ0it-exZJly7l5YB1v98IIoJ4os1bvyM4pkxY_rIfV_rSkt60u2x_Oe82qWR2nUw9Qk0fMaJQ6IlIi8uQOXVtFzuquMu8RdvnMkla9O1eRVxgrxlhalqpSY1U2mV6iYtsjokF44eQFlyz315qZSeJse_cjmW88QZwd8RQ96R7xSyxwFMu3jqpRparzXIJd2Yo-WYj5-vblotdUVYt8otalqxzzi68zOnJIvlMcSvfpvpvnW2qIYxFQj0-vnsl7S1Y0lfZOh6o2qW4i-s7h-sohe6bm2xti3pqZc3b_lrsQ21SR-6j2t8UqIxsYI4IkOY4177iIVJuZ_4lhmg2sB_WR_hBix9jhn57mI8yaJkIJX5itpnB5lyWh1_j5tQMcl2x
// ya29.c.c0ASRK0GaGl3QRHw-aCNhqy87Q2V0f80nLmhmo6-UVZfVQsk7vWyXKmUOKx5DuAaqudC9XRvQ08v8MTv2HNQkHeTjGlP1AdLMsYbYQliaJP2rRX_e_6kapdbNSZR_EL7O2VL9S-b1wdocvQR0KDyv0Mdjf0EmJ-iFkyBUg39rgZyBXqJAOaxFq0taaVSUHvIG5R8AYNl6tD5Cb4GCom0v9Y33QB4QbdG9QzpqjDssK79Ks0uR94VqR6RBzxG3ZvUkLCoxuaoSYB1omuQNnJWSVMuNGH-SbFrQWs5aW9wbVg9Xz78EgrOphbedqTKCigI8Pr6meLaZ-ozAEXoZN_ru6FYe1Wy5UcnycitafK5AYZ1rgSvfrtvl2X0smXvO0T389A36zun4ovhO4qbo5XJtgySpdJ_eWO-lexMWqkr3qBQO7-nWrZdY-s42vurnyUtyxcVjclnRkmXwYOquzkrQxQFtJyolX_Wj1JY_B1zUX3bciVWjQlpsBnIm7elr7o4ijj9v2tk_d2bM9OWFwWdYhucWrVhe465xbSYkie6nJ6dFqXt0f94WYUVQJV6mZ2ssUZ0h8UMzyiZY9SJeQQrw93lbati-B_c-37cUywa2qV5IgyOadw6islbolqF2kJ2XdqR0Y0uQhZdkVqamYuZeotByzQhi39seoWf_-Fw1rmsS9_nu6yZ4mW8cdtrXnB68wa--8wOwW6Boo-Ihffd92a4sX6y-pZqbknRaRlwzl0R3kMozuBcB0rry7qhRmSQg1lOn0FXasnlUl0boo838RSui0p147OrjXro0q1Ys45ixhUOOseh5ldIII9848XxoaZxS7eylt4mOxlshpXk-gX6RUw1zlhi8xauJmh7UlUel2MvqxOFYa8O1tqOh5Wprdvkb5F0VsOky5uwWZUYdksavyJXJhXsxYvWr3MwJ0pz-0aUxSdWW7XcWMQkFZ66X_BbWz8YMf6h7ZnZRXpeoQxiq0_YF_z-tml7c_eZkVI44wrc9iIbJy7R