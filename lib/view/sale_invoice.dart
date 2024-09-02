import 'dart:convert';
import 'package:billing/model/customer.dart';
import 'package:billing/services/bill_pdf_service.dart';
import 'package:billing/view/bill_preview_screen.dart';

import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
//import 'package:asset/asset.dart';
class SaleInvoice extends StatefulWidget {
  const SaleInvoice({super.key});

  @override
  State<SaleInvoice> createState() => _SaleInvoiceState();
}

class _SaleInvoiceState extends State<SaleInvoice> {
bool gstSwitch = false;
 DateTime _selectedDate = DateTime.now();
 final BillPdfService billPdfService = BillPdfService();
//serachable dropdown
  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic>? selectedData;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }
  Future<void> loadJsonData() async {
    final jsonString = await rootBundle.rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);

    setState(() {
      dataList = jsonResponse.map((data) => Map<String, dynamic>.from(data)).toList();
    });
  }

  void onNameSelected(Map<String, dynamic>? selected) {
    if (selected != null) {
      setState(() {
        selectedData = selected;
        nameController.text = selected['name'] ?? '';
        mobileNumberController.text = selected['mobileNumber'] ?? '';
        addressController.text = selected['address'] ?? '';
        gstNumberController.text = selected['gstNumber'] ?? '';
      });
    } else {
      // Handle null case, maybe clear the text fields or do nothing
      setState(() {
        nameController.clear();
        mobileNumberController.clear();
        addressController.clear();
        gstNumberController.clear();
      });
    }
  }



//date picker
Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Default is the current date
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const BackButtonIcon(),
            onPressed: () { },
          ),
        title: const Text('Sale Invoice',style: TextStyle(fontSize: 20),),
        actions: [
          AnimatedToggleSwitch<bool>.size(
            current: gstSwitch,
            values: const[false, true],
            iconOpacity: 0.1,
            indicatorSize: const Size.fromWidth(80),
            customIconBuilder: (context, local, global)=> Text(
              local.value ? 'Comp' : 'GST',
              style: TextStyle(
                  color: Color.lerp(Colors.black, Colors.white, local.animationValue)
              ),
            ),
            
            iconAnimationType: AnimationType.onHover,
            style:ToggleStyle(
                indicatorColor: Colors.grey,
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow:[
                  const BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 1,
                 
                  )
                ]
            ),
            selectedIconScale: 1.0,
            onChanged: (value) => setState(() => gstSwitch=value ),

          ),
        ],
      ),
   

      body:
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
                children: [
                  Column(
                     children: [
                      Card(
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                           const Expanded(
                        child: Text('Invoice No.', style: TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                        ),
                          Expanded(
                         child:TextButton(
                         onPressed: () => _selectDate(context),
                         child: Text(
                         DateFormat('d/MM/y').format(_selectedDate),
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                            ),
                      ),
                       ),
                          ],
                                

                              ),

                  ),
                       const SizedBox(height: 0,),
                   
                           
             Padding(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                GestureDetector(
                  onTap: () async {
                    final selected = await showSearch<Map<String, dynamic>>(
                      context: context,
                      delegate: DataSearch(dataList),
                    );
                    onNameSelected(selected); // Handle potential null
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: nameController,
                      decoration:const InputDecoration(
                        labelText: 'Name',
                        //suffixIcon: Icon(Icons.search),
                          //border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
               
                TextField(
                  controller: mobileNumberController,
                  decoration:const InputDecoration(labelText: 'Mobile Number'),
                ),
                TextField(
                  controller: addressController,
                  decoration:const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: gstNumberController,
                  decoration:const InputDecoration(labelText: 'GST Number'),
                ),
              ],
            ),
          ),
        ),
      ),
                              
              const SizedBox(height: 8,),
                Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,

                              child: ElevatedButton.icon(onPressed: (){},
                                label: const Text('Add Item',style: TextStyle(color: Colors.black),),
                                icon: const Icon(Icons.add_box,color: Colors.grey,),
                                style: ElevatedButton.styleFrom(
                                    shape:  RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        )
                                    )
                                ),


                              ),

                              ),
                          ),
                        ),            
        
                    const  SizedBox(height: 8,),
 
                       const Card(
                         child: Padding(
                           padding: EdgeInsets.all(8.0),
                           child: Column(
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Text('1. BOAT NIRVANNA UNO',
                                     style:TextStyle(fontSize: 20,color: Colors.grey,
                                     fontWeight: FontWeight.bold) ,),
                                   SizedBox(width: 30,),
                                   Text(
                                     'Rs.4032.00',style:TextStyle(fontSize: 18,color: Colors.grey,
                                   ),
                                   ),
                                   
                                 ],

                               ),
                               SizedBox(height: 8,),
                               Row(
                                 children: [
                               Text('Item Subtotal',style: TextStyle(fontSize: 18),),
                               SizedBox(width: 120,),
                               Text('3 x 1200 = 3600.00'),
                                       ],
                                 ),
                               SizedBox(height: 8,),
                               Row(
                                 children: [
                               Text('Discount(%) 0%',style: TextStyle(fontSize: 18),),
                               SizedBox(width: 200,),
                               Text('0.00'),
                                       ],
                                 ),
                               SizedBox(height: 8,),
                               Row(
                                 children: [
                               Text('GST 12%',style: TextStyle(fontSize: 18),),
                               SizedBox(width: 250,),
                               Text('432.00'),
                                       ],
                                 ),
                               SizedBox(height: 8,),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   Icon(Icons.delete_forever,color: Colors.green,),
                                 ],
                               ),

                             ],
                           ),
                         ),

                       ),
                       const SizedBox(height: 8,),
                        Card(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             children: [
                              const Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Text('Add Other Details',
                                     style:TextStyle(fontSize: 14,color: Colors.red,) ,),
                                   SizedBox(width: 50,),
                                 ],
                               ),
                             const  SizedBox(height: 8,),
                             const  Row(
                                 children: [
                               Text('Total Disc : 0.00',style: TextStyle(fontSize: 18),),
                               SizedBox(width: 100,),
                               Text('Total GST:432.00'),
                                       ],
                                 ),
                            const   SizedBox(height: 8,),
                            const   Row(
                                 children: [
                               Text('Total Qty: 3.00',style: TextStyle(fontSize: 18),),
                               SizedBox(width: 90,),
                               Text('Total Sub Amt:3600.00'),
                                       ],
                                 ),
                             const  SizedBox(height: 8,),
                              const Row(
                                 children: [
                               Text('Total Amount',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500 ),),
                               SizedBox(width: 170,),
                               Text('4032',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                                       ],
                                 ),
                             const  SizedBox(height: 8,),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   OutlinedButton(
                                     child:const Text("Credit",style: TextStyle(color: Colors.grey),),
                                     onPressed: (){},
                                   ),
                                  const SizedBox(
                                     width: 10,
                                   ),
                                   OutlinedButton(
                                     child:const Text("Cash",style: TextStyle(color: Colors.grey),),
                                     onPressed: (){},
                                   ),

                                 ],

                               ),
                               const SizedBox(height: 8,),

                                   SizedBox(
                                     width: double.infinity,
                                     height: 60,
                                     child: ElevatedButton.icon(onPressed: ()async{
                                      final customerName = nameController.text;
                  final address = addressController.text;
                  final mobileNumber = mobileNumberController.text;
                  final gstNumber = gstNumberController.text;
                  final date = _selectedDate;

                  // Ensure that the controllers have valid values
                  if (customerName.isNotEmpty &&
                      address.isNotEmpty &&
                      mobileNumber.isNotEmpty &&
                      gstNumber.isNotEmpty) {
                    // Generate the PDF
                    final pdfData = await billPdfService.generateBillPDF(
                      customerName: customerName,
                      address: address,
                      mobileNumber: mobileNumber,
                      gstNumber: gstNumber,
                      date: date,
                    );

                    // Pass the PDF data to the preview screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillPreviewScreen(
                          pdfData: pdfData,
                        ),
                      ),
                    );
                  } else {
                    // Handle invalid input
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                                     
                                     },

                                       label: const Text('Save',style: TextStyle(color: Colors.black),),
                                       icon: const Icon(Icons.save,color: Colors.grey,),
                                       style: ElevatedButton.styleFrom(
                                         shape:  RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(18.0),
                                             side: const BorderSide(
                                               color: Colors.grey,
                                               width: 2.0,
                                             )
                                         )
                                       ),
                                     ),
                                   )
                             ],
                           ),
                         ),

                       )
                     ],
                   ),



                ],
              ),

      ),

 

    );
  }
}
class DataSearch extends SearchDelegate<Map<String, dynamic>> {
  final List<Map<String, dynamic>> dataList;

  DataSearch(this.dataList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, dataList as Map<String, dynamic>); // This can return null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = dataList.where((element) =>
        element['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item['name']),
          subtitle: Text(
            'Mobile: ${item['mobileNumber']}\nAddress: ${item['address']}\nGST: ${item['gstNumber']}',
          ),
          onTap: () {
            close(context, results[index]);  // Returns selected item
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = dataList.where((element) =>
        element['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Text(item['name']),
          subtitle: Text(
            'Mobile: ${item['mobileNumber']}\nAddress: ${item['address']}\nGST: ${item['gstNumber']}',
          ),
          onTap: () {
            query = suggestions[index]['name'];
            showResults(context);
          },
        );
      },
    );
  }
}