use "../STD/STD.e"

type Position
{
    int Line = 0
    int Character = 0
    int Local = 0
    int Absolute = 0
    char ptr File_Name = 0->address

    func Position(int line, int character, int local, abselute, char ptr file_name){
        Line = line
        Character = character
        Local = local
        Abselute = abselute
        File_Name = file_name
    }

    int GetLinea(){
        return Line
    }
    
    char ptr GetFilePath() {
        return File_Name
    }

    int GetCharacter(){
        return Character
    }

    int GetLocal() {
        return Local
    }

    int GetAbsolute(){
        return Absolute
    }

    int GetFriendlyLine(){
        return Line + 1
    }

    int GetFriendlyCharacter(){
        return Character + 1
    }

    int GetFriendlyAbsolute(){
        return Absolute + 1
    }

    Position ptr NextLine(){
        Line++
		Character = 0
        Local++
		Absolute++
		return this
    }

    Position ptr NextCharacter()
	{
		Character++
		Absolute++
        Local++
		return this;
	}

    Position ptr Clone()
	{
		return New<Position>()->Postion.Position(Line, Character, Local, Absolute)
	}

    #string ToString() 
    #{
    #   TODO: Add operator overload
    #   return (string(File_Name) + ":" + to_string(GetFriendlyLine()) + ":" + to_string(GetFriendlyCharacter()));
    #}
}