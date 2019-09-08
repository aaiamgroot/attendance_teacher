import 'package:attendance_teacher/classes/teaching.dart';
import 'package:attendance_teacher/classes/timings.dart';
import 'package:attendance_teacher/screens/createtiming.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectList extends StatefulWidget {

	Teaching _teaching;

	SubjectList(this._teaching);

	@override
  _SubjectListState createState() => _SubjectListState(_teaching);
}

class _SubjectListState extends State<SubjectList> {

	Teaching _teaching;

	_SubjectListState(this._teaching);

	@override
  Widget build(BuildContext context) {
    return Scaffold(
		appBar: AppBar(
			title: Text('Subjects List'),
		),
		body: getTimings(),
		floatingActionButton: FloatingActionButton(
			child: Icon(Icons.add),
			onPressed: () {
				Navigator.push(context, MaterialPageRoute(builder: (context) {
					return CreateTiming(_teaching);
				}));
			},
		),
	);
  }

  Widget getTimings() {
  	return StreamBuilder<QuerySnapshot> (
		stream: Firestore.instance.collection('teach').document(_teaching.teacherDocumentId).collection('subject').document(_teaching.documentId).collection('timings').snapshots(),
		builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
			if(!snapshot.hasData)
				return Text('Loading');
			return getTimingsList(snapshot);
		},
	);
  }

  getTimingsList(AsyncSnapshot<QuerySnapshot> snapshot) {
		var listView = ListView.builder(itemBuilder: (context, index) {
			if(index<snapshot.data.documents.length) {
				var doc = snapshot.data.documents[index];
				Timings timings = Timings.fromMapObject(doc);
				timings.documentId = doc.documentID;
				return Card(
					child: ListTile(
						title: Text(timings.day),
						subtitle: Text(timings.start+' : '+timings.duration+' hours'),
					),
				);
			}
		});
		return listView;
  }
}