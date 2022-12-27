import 'package:assignment2/constant.dart';
import 'package:assignment2/services/getdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin{

  TabController? _tabController;

  var getdataprovider = ChangeNotifierProvider((ref) => GetDataProvider());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
    Future.delayed(Duration(milliseconds: 100),(){
      getdata();
    });
  }

  getdata()async{
    await ref.read(getdataprovider).getData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    var upcoming = ref.watch(getdataprovider).upcoming;
    var live = ref.watch(getdataprovider).live;
    var completed = ref.watch(getdataprovider).completed;
    var status = ref.watch(getdataprovider).status;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Watches'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

            ],
          ),
        ),
      ),
      body: status == ApiStatus.Stable || status == ApiStatus.Loading
      ? MyLoader()
      : Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Container(
                    child: Text('Upcoming',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text('Live',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text('Completed',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListContainer(data: upcoming,status: 'Upcoming'),
                  ListContainer(data: live,status: 'Live'),
                  ListContainer(data: completed,status: 'Game Over'),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class ListContainer extends StatelessWidget {
  List data;
  var status;
  ListContainer({Key? key,required this.data,required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: data.length,
      shrinkWrap: true,
      itemBuilder: (context,i){
        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20,20,20,10),
                child: Text('${data[i]['name']}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Divider(thickness: 2),
              Padding(
                padding: EdgeInsets.fromLTRB(20,10,20,20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${data[i]['teams']['a']['short_name']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('Mega',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    Text('${data[i]['teams']['b']['short_name']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20,10,20,10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: Colors.red.shade900,
                ),
                child: Row(
                  children: [
                    Text('$status',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
