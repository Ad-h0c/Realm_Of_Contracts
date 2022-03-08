// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract prisonerDilemma {
    bool p1;
    bool p2;
    string punishment;
    constructor(){ //Before the interrogation both prisoners haven't confessed anything so false.
        p1 = false;
        p2 = false;
    }
    //True is equal to prisoner confessing.
    //False is equal to prisoner not confessing.
    function prisonerone(bool response) public  returns(bool) {
        if(response == true){
            p1 = true;
        }
        return p1;
    }

        function prisonertwo(bool response) public  returns(bool) {
        if(response == true){
            p2 = true;
        }
        return p2;
    }
    
    function decision() public returns(string memory) {      
        if(p1 == true && p2 == true){ //In case of both prisoners confess.
            punishment = "Prisoner 1 and prisoner 2 both gets 5 years of punishment";
        } else if(p1 == true && p2 == false){ //In case of only prisoner one confess.
            punishment = "prisoner 1 gets 3 years of punishment and prisoner 2 gets 9 years of punishment";
        } else if(p1 == false && p2 == true){ //In case of only prisoner two confess.
            punishment = "prisoner 1 gets 10 years of punishment and prisoner 2 gets 2 years of punishment";
        } else if(p1 == false && p2 == false){ //In case of both prisoner kept silent.
            punishment = "Prisoner 1 and prisoner 2 both gets 2 years of punishment";
        }
        return punishment;
    }
    
}
