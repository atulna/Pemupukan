import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AGRUM - Pemupukan',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PemupukanScreen(),
    );
  }
}

class PemupukanScreen extends StatefulWidget {
  @override
  _PemupukanScreenState createState() => _PemupukanScreenState();
}

class _PemupukanScreenState extends State<PemupukanScreen> {
  // List untuk menyimpan data tanaman dan jadwal pemupukan
  List<Map<String, String>> tanamanList = [
    {"tanaman": "Padi", "pupuk": "Urea", "jadwal": "Setiap 30 hari"},
    {"tanaman": "Jagung", "pupuk": "NPK", "jadwal": "Setiap 25 hari"},
    {"tanaman": "Kopi", "pupuk": "Kompos", "jadwal": "Setiap 45 hari"},
  ];

  List<String> riwayat = [];

  // Fungsi untuk menambahkan tanaman manual
  void addTanaman(String namaTanaman, String jenisPupuk, int intervalHari) {
    setState(() {
      tanamanList.add({
        "tanaman": namaTanaman,
        "pupuk": jenisPupuk,
        "jadwal": "Setiap $intervalHari hari",
      });
    });
  }

  // Fungsi untuk mencatat riwayat pemupukan
  void addRiwayat(String tanaman) {
    setState(() {
      riwayat.add("Pemupukan untuk $tanaman dilakukan pada ${DateTime.now()}");
    });
  }

  // Dialog untuk menambahkan tanaman baru
  void showAddTanamanDialog(BuildContext context) {
    TextEditingController tanamanController = TextEditingController();
    TextEditingController pupukController = TextEditingController();
    TextEditingController intervalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambahkan Tanaman"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tanamanController,
                decoration: InputDecoration(labelText: "Nama Tanaman"),
              ),
              TextField(
                controller: pupukController,
                decoration: InputDecoration(labelText: "Jenis Pupuk"),
              ),
              TextField(
                controller: intervalController,
                decoration:
                    InputDecoration(labelText: "Interval Hari Pemupukan"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                String namaTanaman = tanamanController.text;
                String jenisPupuk = pupukController.text;
                int intervalHari = int.tryParse(intervalController.text) ??
                    30; // Default 30 hari
                if (namaTanaman.isNotEmpty && jenisPupuk.isNotEmpty) {
                  addTanaman(namaTanaman, jenisPupuk, intervalHari);
                }
                Navigator.of(context).pop();
              },
              child: Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pemupukan Tanaman"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showAddTanamanDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tanamanList.length,
              itemBuilder: (context, index) {
                final item = tanamanList[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Tanaman: ${item['tanaman']}"),
                    subtitle: Text(
                        "Pupuk: ${item['pupuk']}\nJadwal: ${item['jadwal']}"),
                    trailing: ElevatedButton(
                      onPressed: () => addRiwayat(item['tanaman']!),
                      child: Text("Catat"),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Text(
            "Riwayat Pemupukan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: riwayat.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(riwayat[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
