import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/components/workspace.dart';
import 'package:gestion_de_stock/controllers/client_crtl.dart';
import 'package:gestion_de_stock/imports.dart';

import 'add_client.dart';
import 'client_details.dart';

class ListClients extends StatefulWidget {
  static const String id = 'Gestion Des Clients';
  const ListClients({Key? key}) : super(key: key);

  @override
  State<ListClients> createState() => _ListClientsState();
}

class _ListClientsState extends State<ListClients> {
  int selectedIndex=-1;

  List<Client> clients=[];

  String search='';

  @override
  Widget build(BuildContext context) {
    return WorkSpace(headChildren: [
          HeaderElement(title: 'Créer Client',
              onTap: ()async{
           await showDialog(context: context, builder: (context)=>const AddClient()).then((value) {
              setState((){});
            });
              },
              icon: Icons.person_add,),
              HeaderElement(title: 'Modifier',
                  color: selectedIndex>-1?null: Colors.black54,
                  onTap: ()async{
    if(selectedIndex!=-1){
      await showDialog(context: context, builder: (context)=> AddClient(client: clients[selectedIndex])).then((value) {
               setState((){});
             });
    }
                  },
                  icon: Icons.edit_note,),
              HeaderElement(title: 'Supprimer',
                color: selectedIndex>-1?null: Colors.black54,
                        onTap: (){
                showDialog(context: context, builder: (context)=>AlertDialog(
                  title: const Text("Attention"),
                  content: const Text("Voulez vous vraiment supprimer ce Client?"),
                  actions: [
                    TextButton(onPressed: ()async{
                      await ClientCrtl.deleteClient(clients[selectedIndex]).then((value) {
                        Navigator.pop(context);
                        selectedIndex=-1;
                      });
                    }, child: const Text("Supprimer")),
                    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Annuler'))
                  ],
                ));
                        },
                        icon: Icons.delete,),
    
        ],
          searchBar: SearchField(
                    hint: 'Chercher ce que voulez ...',
                    onSubmitted: (s) {
                      search = s.toLowerCase();
                      setState(() {});
                    }),
    
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('clients').orderBy('createdAt',descending: true).snapshots(),
          builder: (context, snapshot) {
            clients.clear();
            if(snapshot.hasData){
              for (var value in snapshot.data!.docs) {
                clients.add(ClientCrtl.fromJSON(value.data(), value.id));
              }
            }
            return !snapshot.hasData?
                const Center(child: CircularProgressIndicator(),)
                :ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            dividerThickness: 2,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  "Nom",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Prénom",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
    
                              DataColumn(
                                label: Text(
                                  "Téléphone1",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              DataColumn(
                                                  label: Text(
                                                    "Téléphone2",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                              DataColumn(
                                                   label: Text(
                                                     "Wilaya",
                                                     overflow: TextOverflow.ellipsis,
                                                     maxLines: 1,
                                                   ),
                                                 ),
                              DataColumn(
                                label: Text(
                                  "Commune",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Entrée en",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
    
                            ],
                            rows: List.generate(
                                clients.where((element) => conditions(element)).length,
                                (index) => myDataRow(
                                    clients
                                        .where((element) => conditions(element))
                                        .elementAt(index),
                                    index))),
                      ),
                    ),
            );
          }
        ),
        );
      }
      bool conditions(Client element) {
        return element.phone1!.startsWith(search) ||
            element.prenom!.toLowerCase().startsWith(search) ||
            element.nom!.toLowerCase().startsWith(search) ||
            element.commune!.toLowerCase().startsWith(search) ||
            element.wilaya!.toLowerCase().startsWith(search) ;
      }
      DataRow myDataRow(Client client, int index) {
        Color color = (index % 2 == 0)
                ? secondaryColor.withOpacity(0.1)
                : Colors.white54;
        return DataRow(
            onSelectChanged: (b){
              if(b==true){
                selectedIndex=index;
              }
              else{
                selectedIndex=-1;
              }
              setState((){});
            },
            selected: index==selectedIndex,
            color: MaterialStateProperty.all(color), cells: [
          DataCell(
            Text(client.nom ?? ''),
            onTap: () {
              showDetails(client);
            },
          ),
          DataCell(
            Text(client.prenom ?? ''),
            onTap: () {
              showDetails(client);
            },
          ),
          DataCell(
            Text(client.phone1 ?? ''),
            onTap: () {
              showDetails(client);
            },
          ),
          DataCell(
                 Text(client.phone2 ?? '-'),
                 onTap: () {
                   showDetails(client);
                 },
               ),
          DataCell(
            Text(client.wilaya ?? ''),
            onTap: () {
              showDetails(client);
            },
          ),
          DataCell(
                  Text(client.commune ?? ''),
                  onTap: () {
                    showDetails(client);
                  },
                ),
          DataCell(
            Text(client.createdAt != null
                ? client.createdAt!.substring(0, 16)
                : ''),
            onTap: () {
              showDetails(client);
            },
          ),
        ]);
      }
      void showDetails(Client client) {
          showDialog(
              context: context,
              builder: (context) => ClientDetails(
                    client: client,
                  ));
        }
    
    }