import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assetController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  String _selectedCategory = 'คอมพิวเตอร์';
  String _selectedSeverity = 'High';
  String _building = 'อาคาร A';
  String _floor = 'ชั้น 4';
  String _room = 'ห้องประชุม';

  @override
  void dispose() {
    _assetController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'แจ้งซ่อมใหม่',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.send_outlined),
                        label: const Text('ส่งคำขอ'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildCard(
                        width: isWide ? constraints.maxWidth * 0.45 : constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ข้อมูลปัญหา', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'หมวดหมู่ปัญหา'),
                              value: _selectedCategory,
                              items: const [
                                'คอมพิวเตอร์',
                                'ไฟฟ้า',
                                'เครื่องปรับอากาศ',
                                'เฟอร์นิเจอร์',
                                'อื่นๆ',
                              ]
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedCategory = value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _assetController,
                              decoration: InputDecoration(
                                labelText: 'ทรัพย์สิน',
                                hintText: 'ค้นหาเช่น PC-01, Printer-12',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _detailsController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: 'รายละเอียดอาการ',
                                hintText: 'อธิบายปัญหาและอาการที่พบ',
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildCard(
                        width: isWide ? constraints.maxWidth * 0.45 : constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('สถานที่เกิดเหตุ', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'อาคาร'),
                              value: _building,
                              items: const ['อาคาร A', 'อาคาร B', 'อาคาร C']
                                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _building = value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'ชั้น'),
                              value: _floor,
                              items: const ['ชั้น 1', 'ชั้น 2', 'ชั้น 3', 'ชั้น 4', 'ชั้น 5']
                                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _floor = value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'ห้อง'),
                              value: _room,
                              items: const ['ห้องประชุม', 'ห้องทำงาน', 'โถงทางเดิน', 'คลังพัสดุ']
                                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _room = value);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                labelText: 'ปักหมุดตำแหน่ง (ถ้ามี)',
                                hintText: 'วางลิงก์หรือรายละเอียดเพิ่มเติม',
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildCard(
                        width: constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ความเร่งด่วน', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: ['Low', 'Medium', 'High', 'Urgent'].map((level) {
                                final isSelected = _selectedSeverity == level;
                                return ChoiceChip(
                                  label: Text(level),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() => _selectedSeverity = level);
                                  },
                                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.darkGrey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  selectedColor: Theme.of(context).colorScheme.primary,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            Text('แนบรูป/วิดีโอ', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: List.generate(
                                3,
                                (index) => _AttachmentPlaceholder(index: index + 1),
                              )
                                ..add(
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.file_upload_outlined),
                                    label: const Text('อัปโหลดไฟล์'),
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('ส่งคำขอ'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required double width, required Widget child}) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ส่งคำขอเรียบร้อย')),
      );
    }
  }
}

class _AttachmentPlaceholder extends StatelessWidget {
  const _AttachmentPlaceholder({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mediumGrey.withOpacity(0.4)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text('ไฟล์ #$index', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
