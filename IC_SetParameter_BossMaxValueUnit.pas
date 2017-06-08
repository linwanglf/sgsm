unit IC_SetParameter_BossMaxValueUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, SPComm, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_SetParameter_BossMaxValue = class(TForm)
    comReader: TComm;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    BitBtn3: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Edit_old_password: TEdit;
    Edit_old_Password_Input: TEdit;
    BitBtn_ChangBossPassword: TBitBtn;
    procedure BitBtn_ChangBossPasswordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure BitBtn3Click(Sender: TObject);
    procedure Edit_old_Password_InputKeyPress(Sender: TObject;
      var Key: Char);
  private
    { Private declarations }
  public
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure CheckCMD();
    { Public declarations }
  end;

var
  frm_SetParameter_BossMaxValue: Tfrm_SetParameter_BossMaxValue;
  orderLst, recDataLst, recData_fromICLst: Tstrings;

implementation
uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit, ICmain, Frontoperate_EBincvalueUnit, ICEventTypeUnit;

{$R *.dfm}
//ת�ҷ������ݸ�ʽ �����ַ�ת��Ϊ16����

function Tfrm_SetParameter_BossMaxValue.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '�����������Ϊ��!', '����', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '�����������!', '����', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  for ii := 1 to (length(orderStr) div 2) do
  begin
    tmpStr := copy(orderStr, ii * 2 - 1, 2);
    jj := strToint('$' + tmpStr);
    reTmpStr := reTmpStr + chr(jj);
  end;
  result := reTmpStr;
end;

//�������ݹ���

procedure Tfrm_SetParameter_BossMaxValue.sendData();
var
  orderStr: string;
begin
  if orderLst.Count > curOrderNo then
  begin
    orderStr := orderLst.Strings[curOrderNo];
        //memComSeRe.Lines.Add('==>> '+orderStr);
    orderStr := exchData(orderStr);
    comReader.WriteCommData(pchar(orderStr), length(orderStr));
    inc(curOrderNo);
  end;
end;

//��鷵�ص�����

procedure Tfrm_SetParameter_BossMaxValue.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    2: begin //�����������ֵ����
        for i := 0 to recData_fromICLst.Count - 1 do
          if copy(recData_fromICLst.Strings[i], 9, 2) <> '01' then // д�����ɹ���������
          begin
                       // recData_fromICLst.Clear;
            exit;
          end;
      end;
  end;
end;


//�����趨�ĳ�������

procedure Tfrm_SetParameter_BossMaxValue.BitBtn_ChangBossPasswordClick(Sender: TObject);
var
  myIni: TiniFile;
  Edit_old_password_check: string;
  Edit_new_password_check: string;
  Edit_comfir_password_check: string;
begin
   //�����㷨��������ľ��������õ��㷨ֵ Edit_old_password_check
  if Edit_old_Password_Input.Text = '' then
  begin
    MessageBox(handle, '�������µ�����ֵ��', '����', MB_ICONERROR + MB_OK);
    exit;
  end;
  if StrToInt(Edit_old_Password_Input.Text) > 1024 then
  begin
    ShowMessage('�����ֵ���ܴ���1024');
    exit;
  end;
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.MaxValue := Edit_old_Password_Input.Text; //�����������ֵ
    myIni.WriteString('PLC��������', 'PC����', INit_Wright.MaxValue); //д���ļ�

    INit_Wright.MaxValue := MyIni.ReadString('PLC��������', 'PC����', '500'); //��ȡ���º�ı�ֵ����
    FreeAndNil(myIni);
  end;
  if INit_Wright.MaxValue = Edit_old_Password_Input.Text then
  begin
                   //BitBtn_ChangBossPassword.Enabled:=FALSE;
    Edit_old_Password_Input.Text := '';
    MessageBox(handle, ' �޸ı�ֵ���޳ɹ���', '�ɹ�', MB_OK);
    Edit_old_password.Text := INit_Wright.MaxValue;
    exit;
  end
  else
  begin
                   //BitBtn_ChangBossPassword.Enabled:=FALSE;
    Edit_old_Password_Input.Text := '';
    Edit_old_password.Text := INit_Wright.MaxValue;
    MessageBox(handle, '�޸ı�ֵ����ʧ�ܣ�', 'ʧ��', MB_ICONERROR + MB_OK);
    exit;
  end;
end;

procedure Tfrm_SetParameter_BossMaxValue.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  orderLst.Free();
  recDataLst.Free();
  recData_fromICLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //�����ID��ȡ��������Ϣ
  Edit_old_password.Text := '';
end;

procedure Tfrm_SetParameter_BossMaxValue.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
end;

procedure Tfrm_SetParameter_BossMaxValue.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  recData_fromICLst := tStringList.Create;
  Edit_old_Password_Input.SetFocus;

end;

procedure Tfrm_SetParameter_BossMaxValue.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //����----------------
  tmpStrend := 'STR';
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //���������ת��Ϊ16������
       // if  (intTohex(ord(tmpStr[ii]),2)='4A') then
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
     // Edit1.Text:=recStr;
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //����---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
         //AnswerOper();//���ȷ���Ƿ�����Ҫ�ظ�IC��ָ��
  end;
    //����---------------
  if curOrderNo < orderLst.Count then // �ж�ָ���Ƿ��Ѿ���������ϣ����ָ�����С��ָ���������������
    sendData()
  else begin
    checkOper();
  end;

end;
 //���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_SetParameter_BossMaxValue.CheckCMD();
var
  i: integer;
  tmpStr: string;
  stationNoStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;
begin
   //���Ƚ�ȡ���յ���Ϣ
  tmpStr := recData_fromICLst.Strings[0];

  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //У���

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷ43
  end;
                 //1���жϴ˿��Ƿ�Ϊ�Ѿ���ɳ�ʼ��
  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //��ƬID
    Receive_CMD_ID_Infor.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //����ID
    Receive_CMD_ID_Infor.Password_3F := copy(recData_fromICLst.Strings[0], 17, 6); //����
    Receive_CMD_ID_Infor.Password_USER := copy(recData_fromICLst.Strings[0], 23, 6); //�û�����
    Receive_CMD_ID_Infor.ID_value := copy(recData_fromICLst.Strings[0], 29, 8); //��������
    Receive_CMD_ID_Infor.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //������

                 //1���ж��Ƿ�������ʼ������ֻ��3F��ʼ�����Ŀ�������Ϊ���ܿ�AA �� �ϰ忨BB�Ĳ��ܲ���
               //  if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) and ( (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.Produecer_3F,8,2))or (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.BOSS,8,2)) ) then
    if ((Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) or (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.BOSS, 8, 2))) then

    begin
      BitBtn_ChangBossPassword.Enabled := true; //�����޸��������
      Edit_old_password.Text := INit_Wright.MaxValue; //��ԭ����������ʾ���Ƿ���Ҫ���Ǳ��*����ʾ��
      Edit_old_Password_Input.SetFocus;
                          //Label4.Caption:='������';
      Edit_old_Password_Input.Text := '������';
    end
    else //�������ܿ�AA��Ҳ�����ϰ忨BB
    begin
      Edit_old_password.Text := '';
                          //Label4.Caption:='����Ȩ��!';
      Edit_old_Password_Input.Text := '����Ȩ��!';
      exit;
    end;
  end;

end;


procedure Tfrm_SetParameter_BossMaxValue.BitBtn3Click(Sender: TObject);
begin
  Close;
end;


procedure Tfrm_SetParameter_BossMaxValue.Edit_old_Password_InputKeyPress(
  Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ����������');
  end
  else if key = #13 then
  begin

    if length(Edit_old_Password_Input.Text) = 6 then
      BitBtn_ChangBossPassword.setfocus;
  end;

end;


end.