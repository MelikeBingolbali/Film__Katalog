import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MiniKatalogApp());
}

class Film {
  final int id;
  final String ad;
  final String tur;
  final String aciklama;
  final String resim;
  final double puan;

  Film({
    required this.id,
    required this.ad,
    required this.tur,
    required this.aciklama,
    required this.resim,
    required this.puan,
  });
}

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.amber[700]!,
          secondary: Colors.grey[300]!,
          surface: Colors.black87,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f0f1e), Color(0xFF1a1a1a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Mini Katalog",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Şifre",
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KatalogAnaSayfa(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Giriş Yap",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KatalogAnaSayfa extends StatefulWidget {
  const KatalogAnaSayfa({super.key});

  @override
  State<KatalogAnaSayfa> createState() => _KatalogAnaSayfaState();
}

class _KatalogAnaSayfaState extends State<KatalogAnaSayfa> {
  final List<Film> filmListesi = List.generate(20, (index) {
    final titles = [
      "Yıldızlararası Macera",
      "Son Krallık",
      "Gölgelerin Peşinde",
      "Kalp ve Tutku",
      "Komedi Rüzgarı",
      "Zamanın Ötesinde",
      "Kayıp Şehir",
      "Kara Liste",
      "Aşkın Renkleri",
      "Gülümseme Terapisi",
      "Rüya Avcısı",
      "Sonsuz Yolculuk",
      "Gizli Kahraman",
      "Sessiz Çığlık",
      "Kırık Kalpler",
      "Gizemli Ada",
      "Kayıp Zaman",
      "Alev Dansı",
      "Derin Sessizlik",
      "Hayallerin Peşinde"
    ];
    final types = [
      "Bilim Kurgu",
      "Macera / Dram",
      "Aksiyon / Suç",
      "Romantik / Dram",
      "Dram / Komedi"
    ];
    return Film(
      id: index + 1,
      ad: titles[index],
      tur: types[index % types.length],
      aciklama:
          "Bu, '${titles[index]}' filminin detaylı açıklamasıdır. İzleyiciye eşsiz bir deneyim sunar.",
      resim: "https://picsum.photos/400/600?random=${index + 1}",
      puan: 7.5 + Random().nextDouble() * 2.5,
    );
  });

  final Set<Film> favoriler = {};
  late List<Film> displayedFilms;
  final searchController = TextEditingController();
  String selectedTur = "Tümü";
  final List<String> tumTurler = [
    "Tümü",
    "Bilim Kurgu",
    "Macera / Dram",
    "Aksiyon / Suç",
    "Romantik / Dram",
    "Dram / Komedi"
  ];

  @override
  void initState() {
    super.initState();
    displayedFilms = List.from(filmListesi);
  }

  void filterFilms(String query) {
    setState(() {
      displayedFilms = filmListesi.where((film) {
        final matchTur =
            selectedTur == "Tümü" ? true : film.tur == selectedTur;
        final matchAd = film.ad.toLowerCase().contains(query.toLowerCase());
        return matchTur && matchAd;
      }).toList();
    });
  }

  void filterByTur(String tur) {
    setState(() {
      selectedTur = tur;
      filterFilms(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Katalog"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavorilerScreen(favoriler: favoriler),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: filterFilms,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Film ara...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tumTurler.length,
              itemBuilder: (context, index) {
                final tur = tumTurler[index];
                final selected = tur == selectedTur;
                return GestureDetector(
                  onTap: () => filterByTur(tur),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? Colors.amber[700] : Colors.grey[850],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(tur,
                            style: TextStyle(
                                color: selected ? Colors.black : Colors.white))),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: displayedFilms.length,
              itemBuilder: (context, index) {
                final film = displayedFilms[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FilmDetaySayfasi(film: film, favoriler: favoriler),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 6,
                    color: Colors.grey[850],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Image.network(film.resim,
                                fit: BoxFit.cover, width: double.infinity)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(film.ad,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  maxLines: 2),
                              Text(film.tur,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilmDetaySayfasi extends StatefulWidget {
  final Film film;
  final Set<Film> favoriler;

  const FilmDetaySayfasi(
      {super.key, required this.film, required this.favoriler});

  @override
  State<FilmDetaySayfasi> createState() => _FilmDetaySayfasiState();
}

class _FilmDetaySayfasiState extends State<FilmDetaySayfasi> {
  @override
  Widget build(BuildContext context) {
    bool isFavori = widget.favoriler.contains(widget.film);

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.film.ad), backgroundColor: Colors.black87),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.film.resim,
                width: double.infinity, height: 400, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.film.tur,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.amber)),
                  const SizedBox(height: 10),
                  Text(widget.film.aciklama,
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (isFavori) {
                            widget.favoriler.remove(widget.film);
                            isFavori = false;
                          } else {
                            widget.favoriler.add(widget.film);
                            isFavori = true;
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(isFavori
                                  ? "${widget.film.ad} favorilere eklendi!"
                                  : "${widget.film.ad} favorilerden çıkarıldı!")),
                        );
                      },
                      icon: Icon(Icons.favorite,
                          color: isFavori ? Colors.red : Colors.black),
                      label: Text(isFavori ? "Favorilerde" : "Favorilere Ekle",
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavorilerScreen extends StatelessWidget {
  final Set<Film> favoriler;

  const FavorilerScreen({super.key, required this.favoriler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Favoriler"), backgroundColor: Colors.black87),
      body: favoriler.isEmpty
          ? const Center(
              child: Text("Favori film yok!", style: TextStyle(fontSize: 18)))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriler.length,
              itemBuilder: (context, index) {
                final film = favoriler.elementAt(index);
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 6,
                  color: Colors.grey[850],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Image.network(film.resim,
                              fit: BoxFit.cover, width: double.infinity)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(film.ad,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 2),
                            Text(film.tur,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}