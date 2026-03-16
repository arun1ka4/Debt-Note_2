import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt_model.dart';

class FormPage extends StatefulWidget {
  final Debt? debt;
  final int userId;

  const FormPage({super.key, this.debt, required this.userId});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  late TextEditingController namaController;
  late TextEditingController jumlahController;
  late TextEditingController tanggalHutangController;
  late TextEditingController tanggalJatuhTempoController;

  DateTime? selectedTanggalHutang;
  DateTime? selectedTanggalJatuhTempo;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.debt?.nama ?? "");
    jumlahController = TextEditingController(
      text: widget.debt?.jumlah != null ? widget.debt!.jumlah.toString() : "",
    );

    namaController.addListener(() => setState(() {}));
    jumlahController.addListener(() => setState(() {}));

    if (widget.debt != null) {
      selectedTanggalHutang = widget.debt!.tanggalHutang;
      selectedTanggalJatuhTempo = widget.debt!.tanggalJatuhTempo;
      tanggalHutangController = TextEditingController(
        text:
            "${selectedTanggalHutang!.day}/${selectedTanggalHutang!.month}/${selectedTanggalHutang!.year}",
      );
      tanggalJatuhTempoController = TextEditingController(
        text:
            "${selectedTanggalJatuhTempo!.day}/${selectedTanggalJatuhTempo!.month}/${selectedTanggalJatuhTempo!.year}",
      );
    } else {
      tanggalHutangController = TextEditingController();
      tanggalJatuhTempoController = TextEditingController();
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
    tanggalHutangController.dispose();
    tanggalJatuhTempoController.dispose();
    super.dispose();
  }

  Future<void> pilihTanggal(
    TextEditingController controller,
    bool isHutang,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
        if (isHutang) {
          selectedTanggalHutang = picked;
        } else {
          selectedTanggalJatuhTempo = picked;
        }
      });
    }
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);

    final debt = Debt(
      id: widget.debt?.id,
      userId: widget.userId, // selalu pakai userId dari parameter
      nama: namaController.text,
      jumlah: int.parse(jumlahController.text),
      tanggalHutang: selectedTanggalHutang!,
      tanggalJatuhTempo: selectedTanggalJatuhTempo!,
    );

    try {
      if (widget.debt == null) {
        await supabase.from('debt').insert(debt.toJson());
      } else {
        await supabase.from('debt').update(debt.toJson()).eq('id', debt.id!);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan data: $e")));
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.debt != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Hutang" : "Tambah Hutang",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2F5249),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: namaController,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Nama Penghutang",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2F5249)),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                  suffixIcon: namaController.text.isNotEmpty
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: "Jumlah Hutang",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2F5249)),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: "Rp ",
                  suffixIcon: jumlahController.text.isNotEmpty
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                validator: (value) =>
                    value!.isEmpty ? "Jumlah tidak boleh kosong" : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: tanggalHutangController,
                readOnly: true,
                onTap: () => pilihTanggal(tanggalHutangController, true),
                decoration: InputDecoration(
                  labelText: "Tanggal Hutang",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2F5249)),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Tanggal hutang harus dipilih"
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: tanggalJatuhTempoController,
                readOnly: true,
                onTap: () => pilihTanggal(tanggalJatuhTempoController, false),
                decoration: InputDecoration(
                  labelText: "Tanggal Jatuh Tempo",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2F5249)),
                  ),
                  prefixIcon: const Icon(Icons.event),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Tanggal jatuh tempo harus dipilih"
                    : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSaving ? null : simpanData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF437057),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          "Simpan",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
