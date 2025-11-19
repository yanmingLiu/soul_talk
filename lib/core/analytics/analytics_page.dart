// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'analytics_data.dart';
// import 'analytics_db.dart';

// class AnalyticsPage extends StatefulWidget {
//   const AnalyticsPage({super.key});

//   @override
//   State<AnalyticsPage> createState() => _AnalyticsPageState();
// }

// class _AnalyticsPageState extends State<AnalyticsPage> {
//   final _adLogService = AnalyticsDB.instance;
//   List<AnalyticsData> _logs = [];
//   bool _isLoading = true;
//   // final String _filterType = 'all'; // all, pending, failed

//   @override
//   void initState() {
//     super.initState();
//     _loadLogs();
//   }

//   Future<void> _loadLogs() async {
//     setState(() => _isLoading = true);
//     try {
//       final box = await _adLogService.box;
//       var logs = box.values.toList();

//       // // Apply filter
//       // switch (_filterType) {
//       //   case 'pending':
//       //     logs = logs.where((log) => !log.isUploaded).toList();
//       //     break;
//       //   case 'failed':
//       //     logs = logs.where((log) => !log.isSuccess).toList();
//       //     break;
//       // }

//       // Sort by createTime descending
//       logs.sort((a, b) => b.createTime.compareTo(a.createTime));

//       setState(() {
//         _logs = logs;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _logs.isEmpty
//               ? const Center(child: Text('No datas'))
//               : RefreshIndicator(
//                   onRefresh: _loadLogs,
//                   color: Colors.blue,
//                   child: ListView.builder(
//                     itemCount: _logs.length,
//                     itemBuilder: (context, index) {
//                       final log = _logs[index];

//                       var name = log.eventType;

//                       return ListTile(
//                         title: Text(
//                           name,
//                           style: const TextStyle(
//                             color: Colors.deepOrange,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'id: ${log.id}',
//                               style: const TextStyle(color: Colors.blue),
//                             ),
//                             Text(
//                               'Created: ${DateTime.fromMillisecondsSinceEpoch(log.createTime)}',
//                             ),
//                             if (log.uploadTime != null)
//                               Text(
//                                 'Uploaded: ${DateTime.fromMillisecondsSinceEpoch(log.uploadTime!)}',
//                               ),
//                             Row(
//                               children: [
//                                 Icon(
//                                   log.isUploaded
//                                       ? Icons.cloud_done
//                                       : Icons.cloud_upload,
//                                   color: log.isUploaded
//                                       ? Colors.green
//                                       : Colors.orange,
//                                   size: 16,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   log.isUploaded ? 'Uploaded' : 'Pending',
//                                   style: TextStyle(
//                                     color: log.isUploaded
//                                         ? Colors.green
//                                         : Colors.orange,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 if (log.isUploaded)
//                                   Icon(
//                                     log.isSuccess
//                                         ? Icons.check_circle
//                                         : Icons.error,
//                                     color: log.isSuccess
//                                         ? Colors.green
//                                         : Colors.red,
//                                     size: 16,
//                                   ),
//                                 const SizedBox(width: 4),
//                                 if (log.isUploaded)
//                                   Text(
//                                     log.isSuccess ? 'Success' : 'Failed',
//                                     style: TextStyle(
//                                       color: log.isSuccess
//                                           ? Colors.green
//                                           : Colors.red,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text('Log Details - ${log.eventType}'),
//                               content: SingleChildScrollView(
//                                 child: SelectableText(
//                                   log.data,
//                                 ), // 替换为SelectableText
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text('Close'),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.content_copy),
//                                   onPressed: () {
//                                     Clipboard.setData(
//                                       ClipboardData(text: log.data),
//                                     );
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             'Log data copied to clipboard'), // 提示内容
//                                         duration:
//                                             Duration(seconds: 1), // 显示时长（默认4秒）
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }
// }
