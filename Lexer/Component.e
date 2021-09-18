use "../STD/STD.e"
use "Position.e"

use std

type Component 
{
    String Value
    vector<Component> Components
    Node ptr node = 0->(Node ptr)
    Position Location
    long Flags

    func Component(String value, long flags){
        Value = value
        Flags = flags
    }

    func Components(String value, Position pos, long flags){
        Value = value
        Flags = flags
        Location = pos
    }
    
    bool is(long flag)
    {
        if ((Flags & flag) == flag){
            return 1
        }
        return 0
    }
    bool Has(List<long> f) {
        bool Result = true
        while (int i = 0; i < f.Size; i++){
            if (is(f.At(i)) == false){
                Result = false
                return Result
            }
        }
        return Result
    }
    #List<Component ptr> Get_all() {
    #    use Flags
    #
    #    List<Component ptr> Result;
    #
    #    Result.push_back(this);
    #
    #    if (is(PAREHTHESIS_COMPONENT))
    #        for (auto& i : Components) {
    #            vector<Component*> tmp = i.Get_all();
    #            Result.insert(Result.end(), tmp.begin(), tmp.end());
    #        }
    #
    #    return Result;
    #}
}