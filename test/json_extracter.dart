import 'package:flutter_test/flutter_test.dart';
import 'package:specialists_analyzer/app/utils/json_extracter.dart';

void main(){
  test("Json identification works", (){
    String str = '''
    ```json
{ "bussiness_requirements": 9, "structure": 9, "clear": 8, "extension": 9, "digram": "@startuml\nactor Player\nparticipant GameManager\nparticipant LevelManager\nparticipant BirdController\nparticipant PhysicsEngine\nparticipant UIManager\nparticipant Slingshot\nparticipant Bird\n\nPlayer -> GameManager: startLevel(level)\nGameManager -> LevelManager: loadLevel(level)\nLevelManager -> BirdController: updateHUD(level info)\nPlayer -> BirdController: pullBackAndAim()\nPlayer -> BirdController: releaseBird()\nBirdController -> PhysicsEngine: calculateTrajectory()\nBirdController -> PhysicsEngine: checkCollision(bird, obstacles, pigs)"}
    ''';

    final json = extractFirstJson(str);
    expect(json, isNotNull);
  });
}