ListView(
                  children: [
                    Text(
                        'House Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )
                    ),
                    SizedBox(height: 3,),
                    Text(
                        'TOP SERVICES',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        )
                    ),
                    SizedBox(height: 3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 160,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CartOne()),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              elevation: 2.0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 1),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                        image: AssetImage('assets/Group.png'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 1),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Wash Clothes',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            )
                                        ),
                                        Text(
                                            'Hand Wash',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 160,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              elevation: 2.0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 1),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                        image: AssetImage('assets/washing-machine.png'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 1),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Wash Clothes',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            )
                                        ),
                                        Text(
                                            'Laundry',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 160,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              elevation: 2.0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 1),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                        image: AssetImage('assets/adornment.png'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 1),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Wash Clothes',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            )
                                        ),
                                        Text(
                                            'Hand Wash',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 160,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              elevation: 2.0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 1),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                        image: AssetImage('assets/cutlery.png'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 1),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Wash Clothes',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            )
                                        ),
                                        Text(
                                            'Hand Wash',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text(
                        'Home Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )
                    ),
                    SizedBox(height: 3,),
                    Text(
                        'TOP SERVICES',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        )
                    ),
                    SizedBox(height: 3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 160,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              elevation: 2.0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 1),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                        image: AssetImage('assets/pruning-shears.png'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 1),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Wash Clothes',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            )
                                        ),
                                        Text(
                                            'Hand Wash',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 160,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              color: Colors.white,
                              elevation: 2.0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 1),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image(
                                        image: AssetImage('assets/watering-can.png'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 1),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Wash Clothes',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            )
                                        ),
                                        Text(
                                            'Hand Wash',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0,
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),