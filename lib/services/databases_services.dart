import 'package:cloud_firestore/cloud_firestore.dart';

class DatabasesServices {
  static final DatabasesServices _instance = DatabasesServices._internal();

  factory DatabasesServices() {
    return _instance;
  }

  DatabasesServices._internal();

  final db = FirebaseFirestore.instance;
  List<String> _age = [];
  String moviesRec = "";
  setAges(moviesRec) {
    if (moviesRec == "Anak-anak") {
      _age = ["SU"];
    } else if (moviesRec == "Remaja") {
      _age = ["SU", "13+"];
    } else if (moviesRec == "Dewasa") {
      _age = ["SU", "13+", "18+", "21+"];
    } else {
      _age = [];
      print("Kategori usia tidak diketahui.");
    }
    print(_age);
  }

  getAges() {
    print(moviesRec);
    print(_age);
    if (_age.isEmpty) {
      print("Kategori usia tidak diketahui.");
    }
  }

  addData(Map<String, dynamic> data) async {
    try {
      await db.collection("movies").add(data);
      print("Data berhasil ditambahkan");
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> read() async {
    try {
      final querySnapshot = await db
          .collection("movies")
          .where("kategori_usia", whereIn: _age)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error reading data: $e');
      return [];
    }
  }

  final collectionName = 'moviesRec';
  Future<void> deleteAllDocuments(String collectionName) async {
    try {
      // Ambil referensi koleksi
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);

      // Ambil semua dokumen dalam koleksi
      QuerySnapshot snapshot = await collectionRef.get();

      // Iterasi melalui dokumen dan hapus satu per satu
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print("Semua dokumen dalam koleksi '$collectionName' berhasil dihapus.");
    } catch (e) {
      print("Terjadi kesalahan saat menghapus dokumen: $e");
    }
  }

  Future<void> refresh() async {
    try {
      await deleteAllDocuments(collectionName);
      print("Koleksi berhasil di-refresh.");
    } catch (e) {
      print("Terjadi kesalahan saat me-refresh koleksi: $e");
    }
  }

  // Fungsi search
  Future<List<Map<String, dynamic>>> performSearch(String query) async {
    List<Map<String, dynamic>> searchResults = [];

    if (query.isEmpty) {
      return searchResults;
    }

    try {
      final snapshot = await db
          .collection('movies')
          .where('judul', isGreaterThanOrEqualTo: query)
          .where('judul', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      for (var doc in snapshot.docs) {
        searchResults.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception('Error searching: $e');
    }

    return searchResults;
  }
}
