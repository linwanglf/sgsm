{*
1. Ŀǰʹ�õ�������232����ģ�飬������Ҫ׷����������̫��ģ�鼰CPU�Դ�232�ڡ�USB��
*}
unit ICPLCCommunicationUnit;

interface
uses  SysUtils,IniFiles,ACTCOMLKLib_TLB, ACTETHERLib_TLB,Dialogs;
type
  TICPLCCommunication = class
    function ReadDataFromPLC(UnitName:string; var PLCData:array of integer): Boolean;
    function WriteDataToPLC(UnitName:string; PLCData:array of integer): Boolean;
 //   function ReadDataFromPLC_netport(UnitName:string; var PLCData:array of integer): Boolean;
    function ReadDataFromPLC_netport(UnitName:string;var PLCData:array of integer): Boolean;
    function WriteDataToPLC_netport(UnitName:string; PLCData:array of integer): Boolean;
    function WriteData(AddressName,strValue:String):Boolean;  //д������
    procedure InitPLC; //ͨ������ģ��
    procedure InitPLC_netport(strIP:string;strStationNO:integer); //ͨ����̫����ģ��
    procedure ClosePLC;

  private
    { Private declarations }
  public
    { Public declarations }
    
  end;

var
  ICPLCCommunication : TICPLCCommunication;
  PLCCommu_RWValue : TActQJ71C24;   //ͨ������232ģ��ڶ�дPLC���ڴ�����
  PLCCommu_RWValue_netport: TActQJ71E71TCP;   //ͨ������232ģ��ڶ�дPLC���ڴ�����
  bOPen:Boolean;
implementation
uses ICCommunalVarUnit;


procedure TICPLCCommunication.ClosePLC;
begin
  PLCCommu_RWValue.Close;
end;

procedure TICPLCCommunication.InitPLC;
var
  myIni:TIniFile;
  com,baudRate,parity,cpuType,DataBit:Integer;
  strSetting,strTemp:String;
  iPos:Integer;
  Ret:integer;
begin
  com:=1;
  baudRate:=9600;
  parity:=1;
  cpuType:=34;
  DataBit:=8;
  
  myIni:=TIniFile.Create(SystemWorkGroundFile);
  cpuType:=myIni.ReadInteger('PLC����','�ͺ�',34);
  com:=myIni.ReadInteger('PLC��������','�˿�',1);
  strSetting:=myIni.ReadString('PLC��������','����','9600,n,8,1');

  //������
  iPos:=Pos(',',strSetting);
  strTemp:=Copy(strSetting,1,iPos-1);
  strSetting:=Copy(strSetting,iPos+1,Length(strSetting)-iPos);
  try
    baudRate:=StrToInt(strTemp);
  Except
    baudRate:=9600;
    end;
  {//У��
  iPos:=Pos(',',strSetting);
  strTemp:=Copy(strSetting,1,iPos-1);
  strSetting:=Copy(strSetting,iPos+1,Length(strSetting)-iPos);
  if(StrLower(PAnsiChar(strTemp))='n') then
    parity:=1
  else if(StrLower(PAnsiChar(strTemp))='e') then
    parity:=2;
  //����λ
  iPos:=Pos(',',strSetting);
  strTemp:=Copy(strSetting,1,iPos-1);
  strSetting:=Copy(strSetting,iPos+1,Length(strSetting)-iPos);
  try
    DataBit:=StrToInt(strTemp);
  Except
    DataBit:=8;
    end;
  PLCCommu_RWValue.ActControl:=DataBit;
  }
  PLCCommu_RWValue:=TActQJ71C24.Create(nil);
  PLCCommu_RWValue.ActCpuType := cpuType;
  PLCCommu_RWValue.ActPortNumber:=com;
  PLCCommu_RWValue.ActBaudRate:=baudRate;
  //PLCCommu_RWValue.ActParity:=parity;
  Ret:=PLCCommu_RWValue.Open;
  bOPen:=True;
  if(Ret<>0) then begin
    bOPen:=False;
    end;

  myIni.Free;
end;

procedure TICPLCCommunication.InitPLC_netport(strIP:string;strStationNO:integer);
var
  myIni:TIniFile;
  com,baudRate,parity,cpuType,DataBit:Integer;
  strSetting,strTemp:String;
  iPos:Integer;
  Ret:integer;
begin



  PLCCommu_RWValue_netport:=TActQJ71E71TCP.Create(nil);
  PLCCommu_RWValue_netport.ActHostAddress:= strIP;
  PLCCommu_RWValue_netport.ActStationNumber:=strStationNO;
  PLCCommu_RWValue_netport.ActCpuType:=34;
  PLCCommu_RWValue_netport.ActNetworkNumber:= 1;
  PLCCommu_RWValue_netport.ActIONumber:=1023;
  Ret:=PLCCommu_RWValue_netport.Open;
  if  Ret<>0 then
  begin
           ShowMessage('����ʧ��');
                   exit;
  end;
end;

function TICPLCCommunication.ReadDataFromPLC_netport(UnitName:string; var PLCData:array of integer):Boolean;
var
  Ret : integer;
begin
  if(Length(PLCData)>1) then 
    Ret := PLCCommu_RWValue_netport.ReadDeviceBlock(UnitName, Length(PLCData), PLCData[0])
  else
    Ret := PLCCommu_RWValue_netport.ReadDeviceRandom(UnitName, Length(PLCData), PLCData[0]);//OK
  Result := (Ret=0);
end;

function TICPLCCommunication.WriteDataToPLC_netport(UnitName:string; PLCData:array of integer):Boolean;
var
  Ret : integer;
begin
  //PLCData�������UnitSize��PLC����
  //Ret := PLCCommu_RWValue.WriteDeviceRandom(UnitName, Length(PLCData), PLCData[0]);    //The WriteDeviceRandom method is executed.
  if(Length(PLCData)>1) then
    Ret := PLCCommu_RWValue_netport.WriteDeviceBlock(UnitName, Length(PLCData), PLCData[0])
  else
    Ret := PLCCommu_RWValue_netport.WriteDeviceRandom(UnitName, Length(PLCData), PLCData[0]);

  Result := (Ret=0);
end;


function TICPLCCommunication.ReadDataFromPLC(UnitName:string;var PLCData:array of integer):Boolean;
var
  Ret : integer;
begin
  if(Length(PLCData)>1) then 
    Ret := PLCCommu_RWValue.ReadDeviceBlock(UnitName, Length(PLCData), PLCData[0])
  else
    Ret := PLCCommu_RWValue.ReadDeviceRandom(UnitName, Length(PLCData), PLCData[0]);//OK
  Result := (Ret=0);
end;

function TICPLCCommunication.WriteDataToPLC(UnitName:string; PLCData : array of integer):Boolean;
var
  Ret : integer;
begin
  //PLCData�������UnitSize��PLC����
  //Ret := PLCCommu_RWValue.WriteDeviceRandom(UnitName, Length(PLCData), PLCData[0]);    //The WriteDeviceRandom method is executed.
  if(Length(PLCData)>1) then
    Ret := PLCCommu_RWValue.WriteDeviceBlock(UnitName, Length(PLCData), PLCData[0])
  else
    Ret := PLCCommu_RWValue.WriteDeviceRandom(UnitName, Length(PLCData), PLCData[0]);

  Result := (Ret=0);
end;

// д���ݵ�PLC�ĺ���
function TICPLCCommunication.WriteData(AddressName,strValue:String):Boolean;
Var
  PLCWriteData:Array of Integer;
  strTemp:String;
  iFor,i:integer;
  Sendok:Boolean;
begin
  SetLength(PLCWriteData,Length(strValue));
  iFor:= (Length(strValue)+1) Div 2;
  For i:=0 to iFor-1 do begin
    strTemp:=IntToHex(Ord(strValue[i*2+2]),2)+IntToHex(Ord(strValue[i*2+1]),2);
    PLCWriteData[i]:=StrToInt('$'+strTemp);
    end;
    Sendok:=ICPLCCommunication.WriteDataToPLC_netport(AddressName,PLCWriteData);
    
    Result := Sendok;
end;



end.