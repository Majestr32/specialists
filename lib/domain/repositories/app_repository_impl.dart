import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:os_mime_type/os_mime_type.dart';
import 'package:specialists_analyzer/app/utils/json_extracter.dart';
import 'package:specialists_analyzer/domain/entities/challenge.dart';
import 'package:specialists_analyzer/domain/entities/diagram.dart';
import 'package:specialists_analyzer/domain/entities/diagram_estimation.dart';
import 'package:specialists_analyzer/domain/entities/specialist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'app_repository_contract.dart';

const _specialistsCollectionName = "specialists";
const _diagramsCollectionName = "diagrams";
const _challengesCollectionName = "challenges";

class AppRepositoryImpl implements AppRepository {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  @override
  Stream<List<DiagramEntity>> diagrams({required String specialistId}) {
    final snap = _db
        .collection(_specialistsCollectionName)
        .doc(specialistId)
        .collection(_diagramsCollectionName)
        .snapshots();
    return snap.map(
        (e) => e.docs.map((e) => DiagramEntity.fromJson(e.data())).toList());
  }

  @override
  Stream<List<SpecialistEntity>> specialists({required String challengeId}) {
    final snap = _db
        .collection(_specialistsCollectionName)
        .where("challengeId", isEqualTo: challengeId)
        .snapshots();
    return snap.map(
        (e) => e.docs.map((e) => SpecialistEntity.fromJson(e.data())).toList());
  }

  @override
  Future<void> addSpecialist({required String challengeId, required String name}) async {
    final doc = _db.collection(_specialistsCollectionName).doc();
    await doc.set({'name': name, 'id': doc.id, 'challengeId': challengeId});
  }

  @override
  Future<void> editSpecialist(
      {required String name, required String id}) async {
    final doc = _db.collection(_specialistsCollectionName).doc(id);
    await doc.update({
      'name': name,
    });
  }

  @override
  Future<void> removeSpecialist({required String id}) async {
    await _db.collection(_specialistsCollectionName).doc(id).delete();
  }

  @override
  Future<DiagramEstimation> estimateDiagram(
      {required String specialistId,
      required String diagramId,
      required String taskDescription}) async {
    final diagram =
        await fetchDiagram(specialistId: specialistId, diagramId: diagramId);
    const url = "https://api.openai.com/v1/chat/completions";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${dotenv.env['CHATGPT_API_KEY']}',
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      "Твоя задача оцінити прикріплену діаграму фахівця та дати їй об'єктивну оцінку по певним критеріям, оцінити по 10-ти бальній шкалі. Обов'язково перевірь чи дана діаграма відповідає наступному опису: \"$taskDescription\". Критерії за якими необхідно аналізувати: 1. Відповідність бізнес вимогам. Ось на що необхідно орієнтуватись при оцінці: Бал 1-3 Діаграма значно не відповідає бізнес-вимогам, більшість ключових аспектів не враховано.. Бал 4-6 Відповідність часткова, присутні деякі бізнес-вимоги, але важливі елементи пропущені. Бал 7 Діаграма відповідає більшості ключових бізнес-вимог, однак відсутні або неточно представлені деякі другорядні вимоги, що можуть вплинути на виконання менш важливих функцій системи. Бал 8 Діаграма охоплює всі основні бізнес-вимоги та більшість другорядних, але можливі незначні неточності або пропуски, які незначно впливають на загальне розуміння системи. Бал 9 Діаграма відповідає всім основним і другорядним бізнес-вимогам, повністю передаючи задум системи. Присутні лише незначні неточності або нетривіальні відхилення, які не впливають на функціональність. Бал 10 Діаграма повністю відповідає всім бізнес-вимогам, включаючи як основні, так і деталізовані аспекти. Жодних пропусків чи неточностей немає, модель повністю та бездоганно відображає запити бізнесу. 2. Структурна коректність. Ось на що необхідно орієнтуватись при оцінці: Бал 1-3 Діаграма значно порушує структуру системи: відсутні основні зв’язки, елементи розміщені хаотично, є логічні помилки. Бал 4-6 Структура частково коректна, але важливі зв’язки пропущені або представлені невірно, що може викликати значні труднощі при реалізації. Бал 7 Діаграма має здебільшого коректну структуру, але деякі другорядні зв’язки відсутні або неточно представлені, що може вплинути на незначні частини системи. Бал 8 Діаграма відображає коректну структуру з усіма основними зв’язками, але можливі незначні відхилення в деталях, які не впливають на загальне розуміння структури. Бал 9 Діаграма відповідає всім вимогам структурної коректності, містить правильні зв’язки, ієрархії та залежності, за винятком мінімальних неточностей, що незначно впливають на інтерпретацію. Бал 10 Повна структурна коректність: жодних пропусків чи логічних помилок, діаграма повністю відповідає вимогам, відображаючи чітку і точну структуру системи. 3. Зрозумілість. Ось на що необхідно орієнтуватись при оцінці: Бал 1-3 Діаграма практично незрозуміла для сторонніх: використовуються малозрозумілі позначення, відсутні необхідні пояснення або підписи, що ускладнює інтерпретацію. Бал 4-6 Діаграма частково зрозуміла, основні елементи можна розпізнати, але присутні значні труднощі у розумінні зв’язків або деталей, що може затримувати роботу. Бал 7 Діаграма здебільшого зрозуміла, але є кілька складних місць або неточностей, які можуть потребувати пояснень від автора. Бал 8 Діаграма є зрозумілою для більшості користувачів, хоча певні елементи можуть вимагати уточнення. В цілому діаграма передає інформацію чітко і зрозуміло. Бал 9 Діаграма повністю зрозуміла, містить зрозумілі позначення, підписи та структуру, за винятком мінімальних неточностей, які незначно впливають на сприйняття. Бал 10 Повна зрозумілість: діаграма є інтуїтивно зрозумілою, легко інтерпретується та не потребує додаткових пояснень, усі елементи оформлені чітко і логічно. 4. Розширюваність. Бал 1-3 Діаграма має дуже низьку розширюваність: спроби внести зміни спричиняють значні порушення і переробки. Бал 4-6 Часткова розширюваність: деякі елементи можуть бути змінені або додані, але це потребує значних зусиль і часу. Бал 7 Діаграма має здебільшого розширювану структуру, але внесення змін потребує певних коригувань у менш важливих частинах. Бал 8 Діаграма добре спроектована з урахуванням розширюваності; основні зміни можуть бути внесені без значних проблем. Бал 9 Діаграма має високу розширюваність, всі основні елементи добре продумані для можливого розширення, мінімальні коригування. Бал 10 Повна розширюваність: будь-які зміни та доповнення можуть бути внесені без порушення структури або перевантаження системи. Результат твоєї відповіді повинен бути у форматі json та мати наступну структуру: { \"bussiness_requirements\": {score}, \"structure\": {score}, \"clear\": {score}, \"extension\": {score}, \"digram\": \"{plantUML}\" } plantUML параметр це текстова репрезентація діаграми що була надана тобі в форматі plantUML розмітки. Якщо прикріплене зображення не є діаграмою, то просто поверни відповідь  { \"bussiness_requirements\": 0, \"structure\": 0, \"clear\": 0, \"extension\": 0, } Якщо діаграма зовсім не відноситься до початкового опису та описує щось інше, то все рівно вистав оцінки на основі початкового опису, навіть якщо вони будуть занадто низькі. Не потрібно включати додаткових полів чи додаткової текстової інформації до своєї відповіді. Також твій json результат повинен бути записаний в один рядок, тобто строкований.",
                },
                {
                  "type": "image_url",
                  "image_url": {"url": diagram.imgUrl},
                },
              ],
            },
          ],
          "max_tokens": 3000,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseText = data['choices'][0]['message']['content'];
        final estimationJson = extractFirstJson(responseText);
        if(estimationJson == null) throw Exception("Couldn`t analyze digram");
        await _db
            .collection(_specialistsCollectionName)
            .doc(specialistId)
            .collection(_diagramsCollectionName)
            .doc(diagramId)
            .update({'estimation': estimationJson});
        return DiagramEstimation.fromJson(estimationJson!);
      } else {
        print("Error: ${response.statusCode}");
        throw Exception("Couldn`t analyze digram");
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  @override
  Future<DiagramEntity> fetchDiagram(
      {required String specialistId, required String diagramId}) async {
    final snap = await _db
        .collection(_specialistsCollectionName)
        .doc(specialistId)
        .collection(_diagramsCollectionName)
        .doc(diagramId)
        .get();
    return DiagramEntity.fromJson(snap.data()!);
  }

  @override
  Future<void> addDiagram(
      {required String fileName,
      required Uint8List bytes,
      required String specialistId}) async {
    final snap = await _storage.ref(fileName).putData(bytes,
        SettableMetadata(contentType: mimeFromFileName(fileName: fileName)));
    final imgRef = snap.ref.name;
    final imgUrl = await snap.ref.getDownloadURL();
    final doc = _db
        .collection(_specialistsCollectionName)
        .doc(specialistId)
        .collection(_diagramsCollectionName)
        .doc();
    return doc.set(
        {'id': doc.id, 'name': fileName, 'imgUrl': imgUrl, 'imgRef': imgRef});
  }

  @override
  Future<void> removeDiagram(
      {required String specialistId, required String diagramId}) async {
    final diagram =
        await fetchDiagram(specialistId: specialistId, diagramId: diagramId);
    await _storage.ref(diagram.imgRef).delete();
    await _db
        .collection(_specialistsCollectionName)
        .doc(specialistId)
        .collection(_diagramsCollectionName)
        .doc(diagramId)
        .delete();
  }

  @override
  Future<void> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.setCustomParameters({'prompt': 'select_account'});
    await _auth.signInWithPopup(googleProvider);
  }

  @override
  Future<void> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "371355211487-ql3jt35c2mujsrpmjoj9jof938p17jr8.apps.googleusercontent.com");
    await googleSignIn.disconnect();
    return _auth.signOut();
  }

  @override
  Stream<User?> get users => _auth.authStateChanges();

  @override
  Future<void> addChallenge(
      {required String userId,
      required String name,
      required String requirements}) {
    final doc = _db.collection(_challengesCollectionName).doc();
    return doc.set({
      'id': doc.id,
      'userId': userId,
      'name': name,
      'requirements': requirements
    });
  }

  @override
  Stream<List<ChallengeEntity>> challenges({required String userId}) {
    final snap = _db
        .collection(_challengesCollectionName)
        .where("userId", isEqualTo: userId)
        .snapshots();
    return snap.map(
        (e) => e.docs.map((e) => ChallengeEntity.fromJson(e.data())).toList());
  }

  @override
  Future<void> editChallenge(
      {required String id,
      required String name,
      required String requirements}) {
    return _db
        .collection(_challengesCollectionName)
        .doc(id)
        .update({'name': name, 'requirements': requirements});
  }

  @override
  Future<void> removeChallenge({required String id}) {
    return _db.collection(_challengesCollectionName).doc(id).delete();
  }

  @override
  Future<void> estimateSpecialist({required String id, required String taskDescription}) async{
    final specialist = await fetchSpecialist(id: id);

    const url = "https://api.openai.com/v1/chat/completions";

    final diagramsForEstimation = await fetchDiagrams(specialistId: id);
    List<DiagramEstimation> estimations = [];

    for(var diagramForEstimation in diagramsForEstimation){
      if(diagramForEstimation.estimation != null){
        estimations.add(diagramForEstimation.estimation!);
      }else{
        int attempts = 3;
        int attempt = 1;
        DiagramEstimation? estimation;
        do{
          try{
            estimation = await estimateDiagram(specialistId: id, diagramId: diagramForEstimation.id, taskDescription: taskDescription);
            break;
          }catch(e) {
            attempt++;
          }
        }while(attempt < attempts);
        if(estimation == null){
          throw Exception("Couldn`t analyze diagrams");
        }
        estimations.add(estimation);
      }
    }

    final estimationsJson = estimations.map((e) => e.toJson()).toList().toString();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'UTF-8',
          'Authorization':
          'Bearer ${dotenv.env['CHATGPT_API_KEY']}',
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                  '''Ось результати оцінки діаграм IT фахівця, виведених в формі json: $estimationsJson. Поле bussiness_requirements це оцінка від 1 до 10-ти наскільки діаграма відповідає бізнес вимогам,  structure - структурна коректність, clear - зрозумілість, extension - розширюваність, digram - plantUML текстова репрезентація діаграми. Твоя задача оцінити фахівця згідно критеріїв:
                1. Глибина розуміння вимог проекту. Обчислюється як середнє значення оцінок за критерієм відповідність бізнес-вимогам для всіх діаграм спеціаліста.
                2. Ефективність структурування та організування системи. Визначається як середнє значення оцінок за критеріями структурна коректність та розширюваність.
                3. Логічність та узгодженість. Середнє значення оцінок за критерієм зрозумілість, з додатковим врахуванням відповідності між діаграмами для забезпечення логічної цілісності та відсутності протиріч. За невідповідність між діаграмами, невідповідність може відніматись 1-3 бали в залежності від ступеня порушення логічної зв’язності діаграм.
                Також обов’язково твоя відповідь повинна містити json результат в форматі:
                {
                “requirements_understanding”: {score},
                “structuring_and_organization”: {score},
                “logic_and_coherence”: {score},
                “comment”: {comment}
                }
                requirements_understanding - результат оцінки “Відповідність бізнес-вимогам” від 1 до 10-ти.
                structuring_and_organization - результат оцінки “Ефективність структурування та організування системи” від 1 до 10-ти.
                logic_and_coherence - результат оцінки “Логічність та узгодженість” від 1 до 10-ти.
                comment - короткий опис професійності спеціаліста.Не потрібно включати додаткових полів чи додаткової текстової інформації до своєї відповіді. Також твій json результат повинен бути записаний в один рядок, тобто строкований.
                ''',
                },
              ],
            },
          ],
          "max_tokens": 3000,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseText = data['choices'][0]['message']['content'] as String;
        final estimationJson = extractFirstJson(responseText);
        if(estimationJson!.containsKey("comment")){
          estimationJson["comment"] = utf8.decode((estimationJson["comment"] as String).runes.toList());
        }
        await _db
            .collection(_specialistsCollectionName)
            .doc(specialist.id)
            .update({'estimation': estimationJson});
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Future<SpecialistEntity> fetchSpecialist({required String id}) async{
    final snap = await _db
        .collection(_specialistsCollectionName)
        .doc(id)
        .get();
    return SpecialistEntity.fromJson(snap.data()!);
  }

  @override
  Future<List<DiagramEntity>> fetchDiagrams({required String specialistId}) async{
    final snap = await _db
        .collection(_specialistsCollectionName)
        .doc(specialistId)
        .collection(_diagramsCollectionName)
        .get();
    return snap.docs.map((e) => DiagramEntity.fromJson(e.data())).toList();
  }

  AppRepositoryImpl({
    required FirebaseFirestore db,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _db = db,
        _storage = storage,
        _auth = auth;
}
