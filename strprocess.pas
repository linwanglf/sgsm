unit strprocess;

interface

uses
  Classes, SysUtils, Graphics, dialogs;
const
  TooLong = ' is too long!';
  EmptyStr = ' is an empty string value!';
  EmptyHex = ' is an empty Hex value!';
  EmptyBinary = ' is an empty binary value!';
  InvalidHex = ' is invalid Hex value!';
  InvalidSize = ' is a invalid value with the binary size.';
  InvalidBinary = ' is invalid binary value!';
  LoopReplace1 = 'The string replaced and the string replacing with are the SAME!';
  LoopReplace2 = 'Case Sensitive is FALSE.' + LoopReplace1;
type
  EStrToCharError = class(exception);
  EHexToIntError = class(exception);
  EIntToBinError = class(exception);
  EBinToIntError = class(exception);
  EReplaceError = class(exception);
  TStrException = class of exception;

{ ����ת��}
function HexToInt(Hex: string): integer; //��һ��ʮ�����Ƶ�ֵת��������
function IntToBin(Int: LongInt; Size: Integer): string; //��һ��ʮ��������ת���ɶ�����ֵ
function BinToInt(Bin: string): LongInt; //��һ��ʮ��������ת���ɶ�����ֵ
function BinToHex(Bin: string; Size: integer): string; //��������ת����ʮ������
function HexToBin(Hex: string; Size: integer): string; //��ʮ������ת���ɶ�����

{�ַ�����}
//�ַ�������
function IsNumberic(Vaule:String):Boolean; ////�ж�һ���ַ����Ƿ�ȫ��Ϊ����
function IsNumber(Ch: char): boolean; //�ж�һ���ַ��Ƿ���һ������
function IsLetter(Ch: char): boolean; //�ж�һ���ַ��Ƿ���һ����ĸ
function IsSign(Ch: char): boolean; //�ж�һ���ַ��Ƿ���һЩ����' '��'\' '>'�ȡ�
function IsPrint(Ch: char): boolean; //�ж�һ���ַ��Ƿ��ǿ���ʾ�������ַ�
{�ַ�������}

//��ת����ת��
function StrToChar(Str: string): char; //�������ַ��Ĵ�ת�����ַ�
function IntToStrPad0(Digital, Size: integer; Before: boolean): string; //��һ��������ת����һ����ǰ�����������ɸ�0�Ĵ�
//�ַ���Ŀ
function GetMaxWordNumber(var MaxLineID: integer; List: TStringList): integer; //��ȡ����е��кż���ĸ����
function GetChineseWordNumber(Str: string): integer; //��ȡһ�����к��ֵĸ���
function GetEnglishWordNumber(Str: string): integer; //��ȡһ������Ӣ����ĸ����

//�ַ�����ռ�
function GetTextOutWidth(Canvas: TCanvas; Str: string; WordSpace: integer): integer; //��ȡһ�������ʱ�Ŀ���(Pixel)
function GetTextOutHeight(Canvas: TCanvas; List: TStringList; LineSpace: integer): integer; //��ȡStringList���ʱ�ĸ߶ȡ�

//��������˳��
function Reversed(Str: string): string; //�����ַ���

//�Ӵ��ڴ��е�λ��
function ReversedPos(SubStr, Str: string): integer; //�������ұߵ�SubStr��Str�е�λ�á���Pos�෴��
function LeftLastPos(Str: string; FindChar: Char): integer; //����ĳһ���ַ��ڴ���ߵ�����λ��
function RightBeforePos(Str: string; FindChar: char): integer; //����ĳһ�ַ����ұ���ǰ��λ��
function LastPos(Str: string; FindChar: char): integer; overload; //����ĳһ�ַ��ڴ�������λ�á����أ���ʾû���������ַ�
function LastPos(Str: string; FindStr: string): integer; overload; //����ĳһ�ַ��ڴ�������λ�á����أ���ʾû���������ַ�
function AnyPos(Str, FindStr: string; CaseSensitive: boolean): integer; //���԰��Ƿ����ִ�Сд�����ҵ�һ��FindStr��λ�ã����๦��ͬPos
function AnyLastPos(Str, FindStr: string; CaseSensitive: boolean): integer; //���԰��Ƿ����ִ�Сд���������һ��FindStr��λ�ã����๦��ͬLastPos
procedure GetSubInfoInStr(Str, SubStr: string; CaseSensitive: boolean; var InfoList: TStringList); //��ȡһ�����������Ӵ��ڴ��е�λ��

//�ַ������滻

//�ַ������滻--��RepStr����SignCharλ��ǰ����֮��ĵĴ�
function ReplaceLeft(Str, RepStr: string; SignChar: char): string; //RepStr�滻SignCharǰ��������ַ� �����û���ҵ���Ӧ���ַ��ͷ���ԭ��
function ReplaceMiddle(Str, RepStr: string; SignChar: char): string; //��RepStr�滻��һ�������һ��SignChar ֮��������ַ�
function ReplaceRight(Str, RepStr: string; SignChar: char): string; //��RepStr�滻SignChar����������ַ�.���û���ҵ���Ӧ���ַ��ͷ���ԭ��
function ReplaceBoth(Str, RepStr: string; SignChar: char): string; //��RepStr�滻��ߵ�һ��ǰ����ұߵ�һ����������д�
//�ַ������滻--��SpecifiedChar����SignCharλ��ǰ����֮���SignChar
function ReplaceLeftChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻����ߵ���һ������SignChar֮�������SignChar�ַ�
function ReplaceMiddleChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻����ߵ���һ������SignChar��ʼ �� ���ұ߿�ʼ����һ������SignChar֮�������SignChar
function ReplaceRightChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻�����ұߵ���һ������SignChar֮�������SignChar�ַ�
function ReplaceBothChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻����ߵ���һ������SignChar֮���Լ������ұߵ���һ������SignChar֮�������SignChar�ַ�
function ReplaceAllChar(Str: string; RepChar, SignChar: char): string; //��RepChar���洮�����е�SignChar
//�ַ������滻--��RepStr����SignStr
function ReplaceFirstStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //��RepStr�滻��һ��SignStr
function ReplaceLastStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //��RepStr�滻���һ��SignStr
function ReplaceBothStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //��RepStr�滻��ǰ��������һ��SignStr
function ReplaceAllStr(Str, RepStr, SignStr: string; CaseSensitive: boolean; var RepCount: integer): string; //��RepStr�滻���е�SignStr
//�ַ�����ɾ��
function TrimLeftChar(Str: string; DelChar: char): string; //ɾ��Str����ߵ�ָ���ַ�
function TrimRightChar(Str: string; DelChar: char): string; //ɾ��Str���ұߵ�ָ���ַ�
function TrimBoth(Str: string; DelChar: char): string; //ɾ��Str�����ұߵ�ָ���ַ�
function TrimAll(Str: string; DelChar: char): string; //ɾ��Str�����е�ָ���ַ�
function TrimMiddle(Str: string; DelChar: char): string; //ɾ���м��ָ���ַ�������ߺ��ұߵ�һ������ָ���ַ�֮�䣩

//��ȡ�ַ������Ӵ�
//�ַ�����ȡ����ȡĳһ�ַ������ҡ��м���ַ���
function GetLeftStr(Str: string; SpecifiedChar: char): string; //��ȡ�ַ���ĳһ�ض��ַ�����һ������ߵ������ַ����������ض��ַ���
function GetMiddleStr(Str: string; SpecifiedChar: Char): string; //��ȡ�ַ���ĳһ�ض��ַ�����һ�������һ����֮��������ַ����������ض��ַ���
function GetRightStr(Str: string; SpecifiedChar: char): string; //��ȡ�ַ���ĳһ�ض��ַ�����һ�����ұߵ������ַ����������ض��ַ���
//�ַ�����ȡ����ȡĳһ�ַ��������ַ�������ͬ���ַ���ɣ��м���ַ���
function GetMiddleString(Str: string; SpecifiedChar: Char): string;
//�ַ�����ȡ����ȡ�����ַ�����ͬ�Ĳ���
function GetLeftSameStr(Str1, Str2: string): string; //��ȡ���ַ��������ͬ�Ĳ���
function GetRightSameStr(Str1, Str2: string): string; //��ȡ���ַ����ұ���ͬ�Ĳ���
//�ַ�����ȡ����ȡ�����ַ�����ͬ�Ĳ���
procedure GetRightDiverse(var Str1, Str2: string); //��ȡ�����ַ�����ͬ���ֵ��ұ߲�ͬ����
procedure GetLeftDiverse(var Str1, Str2: string); //��ȡ�����ַ�����ͬ������߲�ͬ����
//�ַ����ıȽ�
function FindDiverseLeftPos(Str1, Str2: string): integer; //�������Ҳ������ַ����в�ͬ��λ�á��ո����
function FindDiverseRightPos(Str1, Str2: string): integer; //��������������ַ����в�ͬ��λ�á� �ո����

//�ַ����Ĳ���
function RepeatChar(ReChar: char; Count: integer): string; //��ĳһ�ַ��ظ�Count��;
implementation

procedure EStrProcess(ExceptType: TStrException; Value, ErrorInfo: string);
begin
  raise ExceptType.Create(Value + ErrorInfo); ;
end;

////////////////////////////////////////////////////////////////////////////////
{
  ����ת��
}


function IsNumberic(Vaule:String):Boolean;   //�ж�Vaule�ǲ�������
var
i:integer;
begin
result:=true;   //���÷���ֵΪ�ǣ��棩
Vaule:=trim(Vaule); //ȥ�ո�
for i:=1 to length(Vaule) do //׼��ѭ��
    begin
      if  not (Vaule[i]  in ['0'..'9']) then //���Vaule�ĵ�i���ֲ���0-9�е���һ��
        begin
          result:=false; //����ֵ ���ǣ��٣�
          exit; //�˳�����
        end;
    end;
end;



function HexToInt(Hex: string): integer; //��һ��ʮ�����Ƶ�ֵת�������� ����˵����Hex:��ת����ʮ������ֵ
var
  HexDigital: set of char;
  i: integer;
  Digital: string;
begin
  HexDigital := ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f'];
  if Length(Hex) = 0 then EStrProcess(EHexToIntError, Hex, EmptyHex);
  for i := 1 to Length(Hex) do begin
    Digital := Copy(Hex, i, 1);
    if (i = 1) and (digital = '$') then Continue;
    if not (StrToChar(Digital) in HexDigital) then EStrProcess(EHexToIntError, Hex, InvalidHex);
  end;
  Digital := Copy(Hex, 1, 1);
  if Digital <> '$' then Hex := '$' + Hex;
  Result := StrToInt(Hex);
end;

function IntToBin(Int: LongInt; Size: Integer): string; //��һ��ʮ��������ת���ɶ�����ֵ ����˵����Int:��ת��������ֵ  Size:ת����Ŀ��ȣ�4λ 8λ �����
var
  i: Integer;
begin
  if Size < 1 then EStrProcess(EIntToBinError, IntToStr(Size), InvalidSize);
  for i := Size downto 1 do begin
    if Int and (1 shl (Size - i)) <> 0 then Result := '1' + Result
    else Result := '0' + Result;
  end;
end;

function BinToInt(Bin: string): LongInt; //��һ��ʮ��������ת���ɶ�����ֵ  ����˵����Bin:��ת���Ķ�����ֵ��
var
  i, Size: Integer;
  Bit: string;
begin
  Result := 0;
  Size := Length(Bin);
  if Size = 0 then EStrProcess(EBinToIntError, Bin, EmptyBinary);
  for i := Size downto 1 do begin
    Bit := Copy(Bin, i, 1);
    if (Bit <> '1') and (Bit <> '0') then EStrProcess(EBinToIntError, Bin, InvalidBinary);
    if Bit = '1' then Result := Result + (1 shl (Size - i));
  end;
end;

function BinToHex(Bin: string; Size: integer): string; //��������ת����ʮ������  Bin:��ת���Ķ�����ֵ  Size:ת����ʮ�����ƵĿ���
begin
  Result := IntToHex(BinToInt(Bin), Size);
end;

function HexToBin(Hex: string; Size: integer): string; //��ʮ������ת���ɶ����� Bin:��ת����ʮ������ֵ  Size:ת���ɶ����ƵĿ���
begin
  Result := IntToBin(HexToInt(Hex), Size);
end;
/////////////////////////////////////////////////////////////////////////////////
{
 
  �ַ�����
 
}
//�ַ�����

function IsNumber(Ch: char): boolean; //�ж�һ���ַ��Ƿ���һ������
begin
  Result := ((Ch >= '0') and (Ch <= '9'));
end;

function IsLetter(Ch: char): boolean; //�ж�һ���ַ��Ƿ���һ����ĸ
begin
  Result := ((Ch >= 'a') and (Ch <= 'z')) or ((Ch >= 'A') and (Ch <= 'Z'));
end;

function IsSign(Ch: char): boolean; //�ж�һ���ַ��Ƿ���һЩ����' '��'\' '>'�ȡ�
type
  TSign = set of Char;
var
  Sign: TSign;
begin
  Sign := [' ', '~', '`', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '|', '\', '[', ']', '{', '}', ':', ';', '''', '"', '<', '>', ',', '.', '?', '/'];
  Result := Ch in Sign;
end;

function IsPrint(Ch: char): boolean; //�ж�һ���ַ��Ƿ��ǿ���ʾ�������ַ�
begin
  Result := IsLetter(Ch) or IsNumber(Ch) or IsSign(Ch);
end;
//////////////////////////////////////////////////////////////////////////////////
{
  �ַ�������
}

//��ת����ת��

function StrToChar(Str: string): Char; //�������ַ��Ĵ�ת�����ַ� ����˵����Str:��ת���Ĵ�
begin
  if Length(Str) = 0 then EStrProcess(EStrToCharError, Str, EmptyStr);
  if Length(Str) > 1 then EStrProcess(EStrToCharError, Str, Toolong);
  Result := Str[1];
end;

function IntToStrPad0(Digital, Size: integer; Before: boolean): string; //��һ��������ת����һ����ǰ�����������ɸ�0�Ĵ�
var
  Len: integer;
begin
  Result := IntToStr(Digital);
  Len := Length(Result);
  while Len < Size do begin
    if Before then Result := '0' + Result
    else Result := Result + '0';
    Len := Length(Result);
  end;
end;

//�ַ���Ŀ

function GetMaxWordNumber(var MaxLineID: integer; List: TStringList): integer; //��ȡ����е��кż���ĸ����
var
  i: integer;
  Len: integer;
begin
  Result := 0;
  if List.Count = 0 then Exit;
  for i := 0 to List.Count - 1 do begin
    Len := Length(List.strings[i]);
    if Len >= Result then begin
      Result := Len;
      MaxLineID := i;
    end;
  end;
end;

function GetChineseWordNumber(Str: string): integer; //��ȡһ�����ĺ��ֵĸ���
var
  i: integer;
  CurrentChar: char;
  CurrentStr: string;
begin
  Result := 0;
  if Length(Str) = 0 then Exit;
  for i := 1 to Length(Str) do begin
    CurrentStr := Copy(Str, i, 1);
    CurrentChar := CurrentStr[1];
    if Ord(CurrentChar) >= 127 then Result := Result + 1;
  end;
  Result := Result div 2;
end;

function GetEnglishWordNumber(Str: string): integer; //��ȡӢ����ĸ�ĸ���
begin
  Result := Length(Str) - 2 * GetChineseWordNumber(Str);
end;

//�ַ�����ռ� (ͼ��ģʽ)

function GetTextOutWidth(Canvas: TCanvas; Str: string; WordSpace: integer): integer; //��ȡһ�������ʱ�Ŀ���(Pixel)
var
  i: integer;
  CurrentStr: string;
  CurrentChar: Char;
begin
  i := 1;
  Result := 0;
  if Length(Str) = 0 then Exit;
  while i <= Length(Str) do begin
    CurrentStr := Copy(Str, i, 1);
    CurrentChar := CurrentStr[1];
    if Ord(CurrentChar) >= 127 then begin
      CurrentStr := Copy(Str, i, 2);
      inc(i);
    end;
    Result := Result + Canvas.TextWidth(CurrentStr) + WordSpace;
    inc(i);
  end;
end;

function GetTextOutHeight(Canvas: TCanvas; List: TStringList; LineSpace: integer): integer; //��ȡStringList���ʱ�ĸ߶ȡ�
var
  i: integer;
begin
  Result := 0;
  if List.Count = 0 then Exit;
  for i := 0 to List.Count - 1 do begin
    if i <> List.Count - 1 then Result := Result + Canvas.TextHeight(List.Strings[i]) + LineSpace
    else Result := Result + Canvas.TextHeight(List.Strings[i]);
  end;
end;

//��������˳��

function Reversed(Str: string): string; //�����ַ���
var
  Len: integer;
  RevStr, temp: string;
  i: integer;
begin
  Result := Str;
  Len := Length(Str);
  if len = 0 then Exit;
  if Len = 1 then Exit;
  SetLength(RevStr, Len);
  for i := Len - 1 downto 0 do begin
    temp := Str[Len - i];
    RevStr[i + 1] := Str[Len - i];
  end;
  Result := RevStr;
end;

//�Ӵ��ڴ��е�λ��

function ReversedPos(SubStr, Str: string): integer; //�������ұߵ�SubStr��Str�е�λ�á���Pos�෴��
var
  Len: integer;
  Position: integer;
begin
  Len := Length(Str);
  Str := Reversed(Str);
  SubStr := Reversed(SubStr);
  Position := Pos(SubStr, Str);
  if Position <> 0 then Result := Len - Position + 1 - (Length(SubStr) - 1)
  else Result := 0;
end;

function LeftLastPos(Str: string; FindChar: Char): integer; //����ĳһ���ַ��ڴ���ߵ�����λ�� ���أ���ʾû���������ַ�
var
  Len, i: integer;
begin
  Len := Length(Str);
  Result := 0;
  for i := 1 to Len do begin
    if Str[i] = FindChar then begin
      if i = Len then Result := Len;
      continue;
    end else begin
      Result := i - 1;
      Break;
    end;
  end;
end;

function RightBeforePos(Str: string; FindChar: char): integer; //����ĳһ�ַ����ұ���ǰ��λ��  ���أ���ʾû���������ַ�
var
  RevStr: string;
  RevPos, Len: integer;
begin
  Len := Length(Str);
  RevStr := Reversed(Str);
  RevPos := LeftLastPos(RevStr, FindChar);
  if Str <> '' then begin
    if Str[Len] <> FindChar then Result := 0
    else Result := Length(Str) - RevPos + 1;
  end else Result := 0;
end;

function LastPos(Str: string; FindChar: char): integer; //����ĳһ�ַ��ڴ�������λ�á����أ���ʾû���������ַ�
begin
  Result := ReversedPos(FindChar, Str);
end;

function LastPos(Str: string; FindStr: string): integer; //����ĳһ�ַ��ڴ�������λ�á����أ���ʾû���������ַ�
begin
  Result := ReversedPos(FindStr, Str);
end;

function AnyPos(Str, FindStr: string; CaseSensitive: boolean): integer; //���԰��Ƿ����ִ�Сд�����ң����๦��ͬPos
begin
  if CaseSensitive then Result := Pos(FindStr, Str)
  else begin
    Str := AnsiUpperCase(Str);
    FindStr := AnsiUpperCase(FindStr);
    Result := Pos(FindStr, Str);
  end;
end;

function AnyLastPos(Str, FindStr: string; CaseSensitive: boolean): integer; //���԰��Ƿ����ִ�Сд���������һ��FindStr��λ�ã����๦��ͬLastPos
begin
  if CaseSensitive then Result := LastPos(Str, FindStr)
  else begin
    Str := AnsiUpperCase(Str);
    FindStr := AnsiUpperCase(FindStr);
    Result := LastPos(Str, FindStr);
  end;
end;

procedure GetSubInfoInStr(Str, SubStr: string; CaseSensitive: boolean; var InfoList: TStringList); //��ȡһ�����������Ӵ��ڴ��е�λ��
var //InfoList���ص�һЩ������SubStr��
  RelativePos, AbsolutePos: integer; //Str�е�λ�á�
  CutLen, Len, SubLen: integer;
begin
  InfoList.Clear;
  SubLen := Length(SubStr);
  CutLen := 0;
  repeat
    Len := Length(Str);
    RelativePos := AnyPos(Str, SubStr, CaseSensitive);
    if RelativePos = 0 then begin
      if CutLen = 0 then InfoList := nil;
      Continue;
    end;
    Str := Copy(Str, RelativePos + SubLen, Len - RelativePos - SubLen + 1);
    AbsolutePos := CutLen + RelativePos;
    InfoList.Add(IntToStr(AbsolutePos));
    CutLen := CutLen + RelativePos + SubLen - 1;
  until ((Len < SubLen) or (RelativePos = 0));
end;
//�ַ������滻

//�ַ������滻--��String����SignCharλ��ǰ����֮��ĵĴ�

function ReplaceLeft(Str, RepStr: string; SignChar: char): string; //RepStr�滻��ߵ�һ��SignCharǰ��������ַ� �����û���ҵ���Ӧ���ַ��ͷ���ԭ��
var
  SignStr: string;
  Position, Len: integer;
begin
  SignStr := '1';
  SignStr[1] := SignChar;
  Result := Str;
  Len := Length(Str);
  Position := Pos(SignStr, Str);
  if Position <> 0 then begin //���û���ҵ���Ӧ���ַ��ͷ���ԭ��
    Str := Copy(Str, Position, Len - Position + 1);
    Result := RepStr + Str;
  end;
end;

function ReplaceMiddle(Str, RepStr: string; SignChar: char): string; //��RepStr�滻��һ�������һ��SignChar ֮��������ַ�
var
  LeftStr, MidStr, RightStr: string;
begin
  LeftStr := GetLeftStr(Str, SignChar);
  RightStr := GetRightStr(Str, SignChar);
  MidStr := GetMiddleStr(Str, SignChar);
  if MidStr = '' then begin
                          //������ֻ������SignChar���ҽ�����һ��
    Result := Str; //������û��SignChar�ַ�ʱ��
                          //������ֻ��һ��SignChar�ַ�ʱ��
                          //����ԭ��
  end else begin
    MidStr := RepStr;
    Result := LeftStr + SignChar + MidStr + SignChar + RightStr;
  end;
end;

function ReplaceRight(Str, RepStr: string; SignChar: char): string; //��RepStr�滻�ұߵ�һ��SignChar����������ַ� �����û���ҵ���Ӧ���ַ��ͷ���ԭ��
var
  Count: integer;
  SignStr: string;
begin
  SignStr := '1';
  SignStr[1] := SignChar;
  Result := Str;
  Count := ReversedPos(SignStr, Str);
  if Count <> 0 then begin //���û���ҵ���Ӧ���ַ��ͷ���ԭ��
    Str := Copy(Str, 1, Count);
    Result := Str + RepStr;
  end;
end;

function ReplaceBoth(Str, RepStr: string; SignChar: char): string; //��RepStr�滻��ߵ�һ��SignCharǰ����ұߵ�һ��SignChar��������д�
begin
  Result := ReplaceLeft(Str, RepStr, SignChar);
  Result := ReplaceRight(Result, RepStr, SignChar);
end;


//�ַ������滻--��SpecifiedChar����SignCharλ��ǰ����֮���SignChar

function ReplaceLeftChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻����ߵ���һ������SignChar֮�������SignChar�ַ�
var
  LeftPos, i: integer;
begin
  LeftPos := LeftLastPos(Str, SignChar);
  for i := 1 to LeftPos do Str[i] := RepChar;
  Result := Str;
end;

function ReplaceMiddleChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻����ߵ���һ������SignChar��ʼ �� ���ұ߿�ʼ����һ������SignChar֮�������SignChar
var
  LeftStr, RightStr, MidStr: string;
  LeftPos, RightPos, Len: integer;
begin
  Len := Length(Str);
  LeftPos := LeftLastPos(Str, SignChar);
  RightPos := RightBeforePos(Str, SignChar);
  LeftStr := Copy(Str, 1, LeftPos);
  if RightPos = 0 then RightStr := ''
  else RightStr := Copy(Str, RightPos, Len);
  MidStr := GetMiddleString(Str, SignChar);
  if MidStr = '' then Result := Str
  else begin
    MidStr := ReplaceAllChar(MidStr, RepChar, SignChar);
    Result := LeftStr + MidStr + RightStr;
  end;
end;

function ReplaceRightChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻�����ұߵ���һ������SignChar֮�������SignChar�ַ�
var
  RightPos, i: integer;
begin
  RightPos := RightBeforePos(Str, Signchar);
  if RightPos = 0 then begin
    Result := Str;
  end else begin
    for i := RightPos to Length(Str) do begin
      Str[i] := RepChar;
    end;
    Result := Str;
  end;
end;

function ReplaceBothChar(Str: string; RepChar, SignChar: char): string; //��RepChar�滻����ߵ���һ������SignChar֮���Լ������ұߵ���һ������SignChar֮�������SignChar�ַ�
begin
  Result := ReplaceLeftChar(Str, RepChar, SignChar);
  Result := ReplaceRightChar(Result, RepChar, SignChar);
end;

function ReplaceAllChar(Str: string; RepChar, SignChar: char): string; //��RepChar���洮�����е�SignChar
var
  i: integer;
begin
  for i := 1 to Length(Str) do begin
    if Str[i] = SignChar then Str[i] := RepChar;
  end;
  Result := Str;
end;

//�ַ������滻--��RepStr����SignStr

function ReplaceFirstStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //��RepStr�滻��һ��SignStr
var
  FirstPos, Len, RepLen: integer;
  LeftStr, RightStr: string;
begin
  LeftStr := '';
  RightStr := '';
  RepLen := Length(SignStr);
  Len := Length(Str);
  FirstPos := AnyPos(Str, SignStr, CaseSensitive);
  if FirstPos = 0 then Result := Str
  else begin
    LeftStr := Copy(Str, 1, FirstPos - 1);
    RightStr := Copy(Str, FirstPos + RepLen, Len - FirstPos - RepLen + 1);
    Result := LeftStr + RepStr + RightStr;
  end;
end;

function ReplaceLastStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //��RepStr�滻���һ��SignStr
var
  LastPos1, Len, RepLen: integer;
  LeftStr, RightStr: string;
begin
  LeftStr := '';
  RightStr := '';
  RepLen := Length(SignStr);
  Len := Length(Str);
  LastPos1 := AnyLastPos(Str, SignStr, CaseSensitive);
  if LastPos1 = 0 then Result := Str
  else begin
    LeftStr := Copy(Str, 1, LastPos1 - 1);
    RightStr := Copy(Str, LastPos1 + RepLen, Len - LastPos1 - RepLen + 1);
    Result := LeftStr + RepStr + RightStr;
  end;
end;

function ReplaceBothStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //��RepStr�滻��ǰ��������һ��SignStr
begin
  Result := ReplaceFirstStr(Str, RepStr, SignStr, CaseSensitive);
  Result := ReplaceLastStr(Result, RepStr, SignStr, CaseSensitive);
end;

function ReplaceAllStr(Str, RepStr, SignStr: string; CaseSensitive: boolean; var RepCount: integer): string; //��RepStr�滻���е�SignStr
var
  FirstPos: integer;
  Len, SignLen: integer;
  LeftStr, RightStr: string;
  Tmp1, Tmp2: string;
begin
  RepCount := 0;
  SignLen := Length(SignStr);
  if CaseSensitive then begin
    if RepStr = SignStr then EStrProcess(EReplaceError, '', LoopReplace1);
  end else begin
    Tmp1 := AnsiUpperCase(RepStr);
    Tmp2 := AnsiUpperCase(SignStr);
    if Tmp1 = Tmp2 then EStrProcess(EReplaceError, '', LoopReplace2);
  end;
  repeat
    Len := Length(Str);
    FirstPos := AnyPos(Str, SignStr, CaseSensitive);
    if FirstPos = 0 then Continue;
    LeftStr := Copy(Str, 1, FirstPos - 1);
    RightStr := Copy(Str, FirstPos + SignLen, Len - FirstPos - SignLen + 1);
    Str := LeftStr + RepStr + RightStr;
    Inc(RepCount);
  until (FirstPos = 0);
  Result := Str;
end;


//�ַ�����ɾ��

function TrimLeftChar(Str: string; DelChar: char): string; //ɾ��Str����ߵ�ָ���ַ�
var
  Len, i: integer;
  Temp: string;
begin
  Temp := '';
  Len := Length(Str);
  for i := 1 to Len do begin
    if Temp = '' then begin
      if Str[i] <> DelChar then Temp := Temp + Str[i];
    end else Temp := Temp + Str[i];
  end;
  Result := Temp;
end;

function TrimRightChar(Str: string; DelChar: char): string; //ɾ��Str���ұߵ�ָ���ַ�
var
  ReverseStr: string;
begin
  ReverseStr := Reversed(Str);
  ReverseStr := TrimLeftChar(ReverseStr, DelChar);
  Result := Reversed(ReverseStr);
end;

function TrimBoth(Str: string; DelChar: char): string; //ɾ��Str�����ұߵ�ָ���ַ�
var
  Str1: string;
begin
  Str1 := TrimLeftChar(Str, DelChar);
  Str1 := TrimRightChar(Str1, DelChar);
  Result := Str1;
end;

function TrimAll(Str: string; DelChar: char): string; //ɾ��Str�����е�ָ���ַ�
var
  Str1: string;
  i: integer;
begin
  Str1 := '';
  for i := 1 to Length(Str) do begin
    if Str[i] <> DelChar then begin
      Str1 := Str1 + Str[i];
    end;
  end;
  Result := Str1;
end;

function TrimMiddle(Str: string; DelChar: char): string; //ɾ���м��ָ���ַ�������ߺ��ұߵ�һ������ָ���ַ�֮�䣩
var //����ô�ȫ������DelChar�ַ���ɣ���ȫ��ɾ�� ��DelChar:='*'
  LeftPos, RightPos, Len: integer; //eg:Str:='****dd**d***'; result:='dd**d';
  LeftStr, RightStr, MiddleStr: string; //eg:Str:='******';Result:='******';
begin //eg:Str:='ddd***';Result:='ddd';
  LeftStr := ''; //eg:Str:='****ddd';Result:='ddd';
  RightStr := ''; //eg:Str:='ddd';Result:='ddd';
  MiddleStr := ''; //eg:Str:='';Result:='';
  Len := Length(Str);
  LeftPos := LeftLastPos(Str, DelChar);
  RightPos := RightBeforePos(Str, DelChar);
  LeftStr := Copy(Str, 1, LeftPos);
  if RightPos = 0 then RightStr := ''
  else RightStr := Copy(Str, RightPos, Len - RightPos + 1);
  MiddleStr := GetMiddleString(Str, DelChar);
  if MiddleStr = '' then Result := MiddleStr //���StrΪ�մ������ؿմ���Strȫ������ָ���ַ���ɣ�ɾ�������ַ������ؿմ�
  else begin
    Result := LeftStr + TrimAll(MiddleStr, DelChar) + RightStr;
  end;
end;


//��ȡ�ַ������Ӵ�

//��ȡĳһ�ַ������ҡ��м���ַ���

function GetLeftStr(Str: string; SpecifiedChar: char): string; //��ȡ�ַ���ĳһ�ض��ַ�����һ������ߵ������ַ����������ض��ַ���
var
  PosLeft: integer;
begin
  PosLeft := Pos(SpecifiedChar, Str);
  Result := Copy(Str, 1, PosLeft - 1);
end;

function GetMiddleStr(Str: string; SpecifiedChar: Char): string; //��ȡ�ַ���ĳһ�ض��ַ�����һ�������һ����
var //֮��������ַ������������˵��ض��ַ���e
  PosLeft, PosRight: integer; // eg:Str:=C:\llw\delphi MiddleStr:='llw'
begin // eg:Str:=C:\llw\delphi\Program MiddleStr:=llw\delphi
  PosLeft := Pos(SpecifiedChar, Str);
  PosRight := ReversedPos(SpecifiedChar, Str);
                                                  //������ֻ������SpecifiedChar���ҽ�����һ��
                                                  //������û��SpecifiedChar�ַ�ʱ��
  Result := Copy(Str, PosLeft + 1, PosRight - PosLeft - 1); //������ֻ��һ��SpecifiedChar�ַ�ʱ��
                                                  //���ؿմ�

end;

function GetRightStr(Str: string; SpecifiedChar: char): string; //��ȡ�ַ���ĳһ�ض��ַ�����һ�����ұߵ������ַ����������ض��ַ���
var
  PosRight: integer;
begin
  PosRight := ReversedPos(SpecifiedChar, Str);
  if PosRight = 0 then Result := ''
  else Result := Copy(Str, PosRight + 1, Length(Str) - PosRight)
end;

//�ַ�����ȡ����ȡĳһ�ַ��������ַ�������ͬ���ַ���ɣ��м���ַ���

function GetMiddleString(Str: string; SpecifiedChar: Char): string; //��ȡ�ַ������ұ�֮�䣨������һ��ָ���ַ���
var //�ұߵ�һ��ָ���ַ�֮�䲻�������˵�ָ���ַ����Ĵ���SpecifiedChar:='*'
  LeftPos, RightPos, Len: integer; //eg Str:='***dkd***kdk****' ;MiddleString:='dkd***kdk';
begin //eg Str:='**ddd**';MiddleString:='ddd';
  Len := Length(Str); //eg Str:='ddd**';MiddleString:='ddd';
  LeftPos := LeftLastPos(Str, SpecifiedChar); //eg Str:='**ddd';MiddleString:='ddd';
  RightPos := RightBeforePos(Str, SpecifiedChar); //eg Str:='';middleString:='';
  if RightPos = 0 then begin //eg Str:='****';middleString:='';
    Result := Copy(Str, LeftPos + 1, Len - LeftPos); //eg Str:='dddd';middleString:='dddd';
  end else Result := Copy(Str, LeftPos + 1, RightPos - LeftPos - 1); //eg Str:='d*d*d';middleString:='d*d*d';
end;

//�ַ�����ȡ����ȡ�����ַ�����ͬ�Ĳ���

function GetLeftSameStr(Str1, Str2: string): string; //��ȡ���ַ��������ͬ�Ĳ���
var
  LeftPos: integer;
begin
  if Str1 = Str2 then begin
    Result := Str1;
    Exit;
  end;
  LeftPos := FindDiverseLeftPos(Str1, Str2);
  Result := Copy(Str1, 1, LeftPos - 1);
end;

function GetRightSameStr(Str1, Str2: string): string; //��ȡ���ַ����ұ���ͬ�Ĳ���
var
  RightPos, Len1, Len2: integer;
  Str: string;
begin
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Len1 >= Len2 then Str := Str1
  else Str := Str2;
  RightPos := FindDiverseRightPos(Str1, Str2);
  Result := Copy(Str, RightPos + 1, Length(Str) - RightPos);
end;

//�ַ�����ȡ����ȡ�����ַ�����ͬ�Ĳ���

procedure GetRightDiverse(var Str1, Str2: string); //��ȡ�����ַ�����ͬ���ֵ��ұ߲�ͬ����
var
  LeftPos: integer;
  Len1, Len2: integer;
begin
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Str1 = Str2 then begin
    Str1 := '';
    Str2 := '';
    Exit;
  end;
  LeftPos := FindDiverseLeftPos(Str1, Str2);
  Str1 := Copy(Str1, LeftPos, Len1 - LeftPos + 1);
  Str2 := Copy(Str2, LeftPos, Len2 - LeftPos + 1);
end;

procedure GetLeftDiverse(var Str1, Str2: string); //��ȡ�����ַ�����ͬ������߲�ͬ����
var
  RightPos: integer;
  Len1, Len2: integer;
begin
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  RightPos := FindDiverseRightPos(Str1, Str2);
  if Len1 >= Len2 then begin
    Str1 := Copy(Str1, 1, RightPos);
    Str2 := Copy(Str2, 1, RightPos - (Len1 - Len2));
  end else begin
    Str1 := Copy(Str1, 1, RightPos - (Len2 - Len1));
    Str2 := Copy(Str2, 1, RightPos);
  end;
end;


//�ַ����ıȽ�

function FindDiverseLeftPos(Str1, Str2: string): integer; //�������Ҳ������ַ����в�ͬ�ĵط����ո����
var
  Len1, Len2, i, Count: integer;
begin
  Result := 0;
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Str1 = Str2 then begin
    Result := 0;
    Exit;
  end;
  if Len1 >= Len2 then Count := Len2
  else Count := Len1;
  for i := 1 to Count do begin
    if Str1[i] <> Str2[i] then begin
      Result := i;
      Break;
    end;
    if i = Count then Result := i + 1;
  end;
end;

function FindDiverseRightPos(Str1, Str2: string): integer; //��������������ַ����в�ͬ��λ�á��ո����
var
  Len1, Len2, i, Count: integer;
begin
  Result := 0;
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Str1 = Str2 then begin
    Result := 0;
    Exit;
  end;
  if Len1 >= Len2 then begin
    Count := Len1;
    Str2 := RepeatChar(' ', Len1 - Len2) + Str2;
  end else begin
    Count := Len2;
    Str1 := RepeatChar(' ', Len2 - Len1) + Str1;
  end;
  for i := Count downto 1 do begin
    if Str1[i] <> Str2[i] then begin
      Result := i;
      Break;
    end;
  end;
end;

//�ַ����Ĳ���

function RepeatChar(ReChar: char; Count: integer): string; //��ĳһ�ַ��ظ�Count��;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Count do begin
    Result := ReChar + Result;
  end;
end;

end.