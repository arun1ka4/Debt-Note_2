import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_model.dart';
import 'form_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final int userId;
  final String namaUsaha;

  const HomePage({super.key, required this.userId, required this.namaUsaha});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<Debt> debtList = [];
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  final NumberFormat currencyFormatter = NumberFormat('#,##0', 'id_ID');
  int? selectedIndex;
  bool isLoading = true;

  int get totalHutang => debtList.fold(0, (sum, d) => sum + d.jumlah);
  int get totalJatuhTempo => debtList
      .where((d) => d.tanggalJatuhTempo.isBefore(DateTime.now()))
      .length;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('debt')
          .select()
          .eq('user_id', widget.userId)
          .order('tanggal_hutang');
      setState(() {
        debtList = (response as List).map((e) => Debt.fromJson(e)).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> hapusData(int id) async {
    await supabase.from('debt').delete().eq('id', id);
    setState(() => selectedIndex = null);
    fetchData();
  }

  // FIX: Tambahkan supabase.auth.signOut()
  Future<void> logout() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2F5249),
        elevation: 0,
        title: const Text(
          "DebtNote",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary card
                Container(
                  color: const Color(0xFF2F5249),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Kiri: nama usaha + total hutang
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.namaUsaha,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Total Hutang",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp ${currencyFormatter.format(totalHutang)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 4),
                            if (totalJatuhTempo > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "$totalJatuhTempo Jatuh Tempo",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // List
                Expanded(
                  child: debtList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wallet_sharp,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Belum ada hutang tercatat",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Tekan + untuk menambahkan",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                          itemCount: debtList.length,
                          itemBuilder: (context, index) {
                            final debt = debtList[index];
                            final isSelected = selectedIndex == index;
                            final isLewatTempo = debt.tanggalJatuhTempo
                                .isBefore(DateTime.now());

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: isLewatTempo
                                    ? const BorderSide(
                                        color: Colors.redAccent,
                                        width: 1.2,
                                      )
                                    : BorderSide.none,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => setState(() {
                                  selectedIndex = isSelected ? null : index;
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            debt.nama,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isLewatTempo)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                "Jatuh Tempo",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Rp ${currencyFormatter.format(debt.jumlah)}",
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2F5249),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 13,
                                            color: Color.fromARGB(
                                              255,
                                              148,
                                              201,
                                              113,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Hutang: ${formatter.format(debt.tanggalHutang)}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Icon(
                                            Icons.event,
                                            size: 13,
                                            color: Colors.redAccent,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Tenggat: ${formatter.format(debt.tanggalJatuhTempo)}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isSelected) ...[
                                        const Divider(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.orange,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                "Edit",
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            FormPage(
                                                              debt: debt,
                                                              userId:
                                                                  widget.userId,
                                                            ),
                                                      ),
                                                    )
                                                    .then((_) => fetchData());
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton.icon(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                "Hapus",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () =>
                                                  hapusData(debt.id!),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => FormPage(userId: widget.userId),
                ),
              )
              .then((_) => fetchData());
        },
        backgroundColor: const Color(0xFF437057),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
