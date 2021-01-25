/*
  Author: kenoxite

  Description:
  Randomly selects and plays a music track belonging to the passed category. 


  Parameter (s):
  _this select 0: _category

  Returns:


  Examples:

*/
params ["_category"];
private ["_tracks"];
_tracks = [""];
switch (_category) do {
case "intro": {
  _tracks = [
              "LeadTrack04_F_Tacops",
              "AmbientTrack04a_F_Tacops",
              "Track04_Underwater1"
            ];
  };           
};
playMusic selectRandom _tracks;
