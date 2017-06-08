unit IC_SetParameter_RightmanageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DB, ADODB, CheckLst,
  ComCtrls, OleCtrls, SPComm, SyncObjs;
type
  Tfrm_IC_SetParameter_Rightmanage = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    DBGrid_User: TDBGrid;
    Panel4: TPanel;
    DataSource_User: TDataSource;
    ADOQuery_User: TADOQuery;
    comReader: TComm;
    GroupBox1: TGroupBox;
    CheckListBox1: TCheckListBox;
    GroupBox4: TGroupBox;
    BitBtn_ADD: TBitBtn;
    BitBtn_Delete: TBitBtn;
    BitBtn_Modify: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Edit_UserNO: TEdit;
    Edit_UserName: TEdit;
    Edit_UserPassword: TEdit;
    Edit_UserType: TComboBox;
    Label3: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Panel3: TPanel;
    Image1: TImage;
    Edit_ID: TEdit;
    CheckBox1: TCheckBox;
    procedure BitBtn4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure BitBtn_ADDClick(Sender: TObject);
    procedure Edit_UserNOKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_UserPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_UserNameKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_UserTypeClick(Sender: TObject);
    procedure BitBtn_ModifyClick(Sender: TObject);
    procedure BitBtn_DeleteClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure InitCheckListBox;
    procedure InitCheckListBoxChecked;
    function MaxRight: string;
    function QueryRight_ID(Right_NAME: string): string;
    procedure ClearArr_Wright_3F;
    procedure InitDataBase;
    procedure SaveRecord_3F_RIGHT_SET(RIGHT_ID: integer);
    procedure SaveRecord_3F_SysUser;
    procedure QueryMax_UserNo;
    procedure DeleteUserRightOld(OperatetionType: string);
     //ɾ���û���¼
    procedure DeleteUser(User_NO: string);

 //ɾ��Ȩ�޼�¼
    procedure DeleteUserRight(User_NO: string);
    procedure SaveRightSelected;
    function CheckInput: boolean;
    procedure Query_3F_SysUser(UserNO: string);
    function CheckRightSelected: boolean;
    procedure CheckCMD();
  end;
var
  frm_IC_SetParameter_Rightmanage: Tfrm_IC_SetParameter_Rightmanage;
  Arr_Wright_3F_length: integer;
  recData_fromICLst: Tstrings;
  ReadCard_OK: boolean;

implementation

uses ICDataModule, ICCommunalVarUnit, ICFunctionUnit;

{$R *.dfm}
//��ʾ��ǰ����Ȩ�޷������

procedure Tfrm_IC_SetParameter_Rightmanage.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_User do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_RIGHT_SET] order by ID DESC';
    SQL.Add(strSQL);
    Active := True;
  end;
end;

//ȡ��

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

//�������

procedure Tfrm_IC_SetParameter_Rightmanage.FormShow(Sender: TObject);
begin
  Arr_Wright_3F_length := StrToInt(MaxRight);
  setlength(Wright_3F, Arr_Wright_3F_length + 1); //��ʼ��Ȩ���������

  ClearArr_Wright_3F;
  InitCheckListBox; //��ʼ��Ȩ����ѡ���
  //InitCheckListBoxChecked; //�õ��ǻ���OnClick�¼�����¼Ȩ����Ϣ�ģ����ǻ����Ƿ�checked?
  InitDataBase;
  Edit_UserType.SetFocus;
  QueryMax_UserNo;

  comReader.StartComm();
  recData_fromICLst := tStringList.Create;
  BitBtn_ADD.Enabled := FALSE;
end;

//��ʼ��Ȩ�������������

procedure Tfrm_IC_SetParameter_Rightmanage.ClearArr_Wright_3F;
var
  i: integer;
begin

  for i := 1 to Arr_Wright_3F_length do //��ʼ��Ȩ�������������
  begin
    Wright_3F[i].Right_NAME := '';
    Wright_3F[i].RIGHT_CODE := '';
    Wright_3F[i].RIGHT_ID := '';
  end;

end;

//��ѯ��ǰ����ѡ���Ȩ�����嵥

procedure Tfrm_IC_SetParameter_Rightmanage.InitCheckListBox;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strTemp: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select RIGHT_NAME from [3F_RIGHT_LIST] order by RIGHT_CODE  Desc';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    CheckListBox1.Items.Clear;
    while not Eof do begin
      strTemp := ADOQTemp.Fields[0].Asstring;
      CheckListBox1.Items.Add(strTemp);

      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;


procedure Tfrm_IC_SetParameter_Rightmanage.InitCheckListBoxChecked;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strTemp: string;
  i : Integer;
  total : Integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select count(*) from [3F_RIGHT_LIST]';
  i:=0;
  total := 0;
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    total := StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)); //�ַ���ת��Ϊ���Σ�
    while i < total do begin
      CheckListBox1.Checked[i] := true;
      i := i+1;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;




//����ID

function Tfrm_IC_SetParameter_Rightmanage.MaxRight: string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Max(ID) from [3F_RIGHT_LIST]';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
      reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString)
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

//��ʾȨ��ChecklistBox�б�

procedure Tfrm_IC_SetParameter_Rightmanage.CheckListBox1ClickCheck(
  Sender: TObject);
begin
  Wright_3F[CheckListBox1.ItemIndex + 1].Right_NAME := CheckListBox1.Items[CheckListBox1.ItemIndex];
  if Wright_3F[CheckListBox1.ItemIndex + 1].RIGHT_ID = '' then
  begin
    Wright_3F[CheckListBox1.ItemIndex + 1].RIGHT_ID := QueryRight_ID(Wright_3F[CheckListBox1.ItemIndex + 1].Right_NAME);

  end
  else
  begin
    Wright_3F[CheckListBox1.ItemIndex + 1].RIGHT_ID := '';
  end;

end;

//��ѯ��ǰ����ѡ���Ȩ�����嵥

function Tfrm_IC_SetParameter_Rightmanage.QueryRight_ID(Right_NAME: string): string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strTemp: string;

begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select ID from [3F_RIGHT_LIST] where RIGHT_NAME=''' + Right_NAME + '''';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      strTemp := ADOQTemp.Fields[0].Asstring;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
  Result := strTemp;
end;

//�������

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserNOKeyPress(
  Sender: TObject; var Key: Char);
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end
  else if key = #13 then
  begin
    if (length(Edit_UserNO.Text) = 6) then
    begin
      Edit_UserPassword.SetFocus;
    end;
  end;
end;

//�������

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserPasswordKeyPress(
  Sender: TObject; var Key: Char);
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('�������ֻ���������֣�');
  end
  else if key = #13 then
  begin
    if (length(Edit_UserPassword.Text) = 6) then
    begin
      Edit_UserName.SetFocus;
    end;
  end;
end;

//�������

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserNameKeyPress(
  Sender: TObject; var Key: Char);
begin

   {  if not (key in['0'..'9',#8,#13])then
       begin
          key:=#0;
          ShowMessage('�������ֻ���������֣�');
       end
     else }
  if key = #13 then
  begin
       //if (length(Edit_UserPassword.Text)=6) then
    begin
      Edit_UserType.SetFocus;
    end;
  end;
end;

//�û������������

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserTypeClick(
  Sender: TObject);
begin
          //  BitBtn_ADD.SetFocus;
end;


//����Ȩ�޷����¼

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn_ADDClick(Sender: TObject);
begin

  if CheckInput then //�������������Ƿ���ȷ
  begin
   //if CheckRightSelected then //û��ѡ���κ�һ��Ȩ��
    begin
      SaveRightSelected; //����ѡ���Ȩ��
      SaveRecord_3F_SysUser; //�����û�����
      QueryMax_UserNo; //��ѯ�����û����룬��Ϊ�û���������ϵͳ�Զ������
      Edit_UserType.SetFocus;
    end
  //else
  //begin
 //   ShowMessage('�����ǰ�û�����Ȩ�ޣ��������ʧ�ܣ�');
  //  exit;
 // end;
  end
  else
  begin
    exit;
  end;
end;


//�޸�Ȩ�ޣ�ɾ����ԭ��������Ȩ�ޣ�д����ѡ�������Ȩ�ޣ�

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn_ModifyClick(Sender: TObject);
begin
    //������Ȩ�޵Ļ�����׷��һ��ɾ���Ĳ�������
       //���ȵ����Ի������Ѳ����߽�����ɾ��Ȩ�޲���
  if (MessageDlg('�����Ҫ�޸�' + Edit_UserNO.Text + '��Ȩ����', mtInformation, [mbYes, mbNo], 0) = mrYes) then
  begin
    if CheckRightSelected then //û��ѡ���κ�һ��Ȩ��
    begin
      Query_3F_SysUser(TrimRight(Edit_UserNO.Text)); //��ѯ�û����������Ϣ�������汣��ʱʹ��
      DeleteUserRightOld('M'); //ɾ���û���¼��Ȩ�޼�¼
      SaveRightSelected; //����ѡ���Ȩ��
      InitDataBase;
      QueryMax_UserNo; //��ѯ�����û����룬��Ϊ�û���������ϵͳ�Զ������
      Edit_UserType.SetFocus;
    end
    else
    begin
      ShowMessage('�����ǰ�û�����Ȩ�ޣ��������ʧ�ܣ�');
      exit;
    end
  end
  else
  begin
    exit;
  end;

end;

//ɾ���û������Ȩ�޼�¼

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn_DeleteClick(Sender: TObject);
begin

  if (MessageDlg('�����Ҫɾ��' + Edit_UserNO.Text + '������Ȩ����ɾ���󽫲��ɻָ�����', mtInformation, [mbYes, mbNo], 0) = mrYes) then
  begin
    DeleteUserRightOld('D'); //ɾ���û���¼��Ȩ�޼�¼
    InitDataBase;
    QueryMax_UserNo; //��ѯ�����û����룬��Ϊ�û���������ϵͳ�Զ������
    Edit_UserType.SetFocus;
  end
  else
  begin

    exit;

  end;
end;

procedure Tfrm_IC_SetParameter_Rightmanage.DeleteUserRightOld(OperatetionType: string);
begin

  if OperatetionType = 'D' then //ɾ��ʱ����ɾ��Ȩ�޼�¼������ɾ���û���¼
  begin
              //����������û����룬��ѯ�������ݱ����Ƿ�����ؼ�¼3F_SysUser���еĻ�һ��ɾ��
    DeleteUser(TrimRight(Edit_UserNO.Text));
  end;
          //����������û����룬��ѯ�������ݱ����Ƿ�����ؼ�¼3F_RIGHT_SET���еĻ�һ��ɾ��
  DeleteUserRight(TrimRight(Edit_UserNO.Text));
end;

 //ɾ���û���¼

procedure Tfrm_IC_SetParameter_Rightmanage.DeleteUser(User_NO: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'delete  from '
    + ' [3F_SysUser] where [UserNo]=''' + User_NO + '''';

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);
end;
 //ɾ��Ȩ�޼�¼

procedure Tfrm_IC_SetParameter_Rightmanage.DeleteUserRight(User_NO: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
begin
  strSQL := 'delete  from '
    + ' [3F_RIGHT_SET] where [UserNo]=''' + User_NO + '''';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    ADOQ.Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    ADOQ.ExecSQL;
  end;
  FreeAndNil(ADOQ);
end;


//�������������Ƿ�����

function Tfrm_IC_SetParameter_Rightmanage.CheckInput: boolean;
var
  i: integer;
  Input_OK: Boolean;
begin
  Input_OK := TRUE;
  if Edit_UserNO.Text = '' then
  begin
    ShowMessage('�û����벻�ܿ�');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserNO.Text)) <> 6 then
  begin
    ShowMessage('�û����볤�ȱ������6');
    Input_OK := FALSE;
  end
  else if Edit_UserType.Text = '' then
  begin
    ShowMessage('�û����Ͳ��ܿ�');
    Input_OK := FALSE;
  end
  else if Edit_UserType.Text = '��ѡ��' then
  begin
    ShowMessage('��ѡ���û�����');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserType.Text)) < 2 then
  begin
    ShowMessage('��ѡ���û�����');
    Input_OK := FALSE;
  end
  else if Edit_UserName.Text = '' then
  begin
    ShowMessage('�û����Ʋ��ܿ�');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserName.Text)) = 0 then
  begin
    ShowMessage('�û����Ʋ��ܿ�');
    Input_OK := FALSE;
  end
  else if Edit_UserPassword.Text = '' then
  begin
    ShowMessage('�û����벻�ܿ�');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserPassword.Text)) <> 6 then
  begin
    ShowMessage('�û����볤�ȱ������6');
    Input_OK := FALSE;
  end;
  result := Input_OK;
end;

//ȷ���Ƿ��Ѿ�ѡ��Ȩ�޲�����Ȩ�޼�¼

function Tfrm_IC_SetParameter_Rightmanage.CheckRightSelected: boolean;
var
  i: integer;
  Right_Selected: Boolean;
begin
  Right_Selected := false;
  for i := 1 to Arr_Wright_3F_length do
  begin
    if Wright_3F[i].RIGHT_ID <> '' then //ֻҪ��⵽��һ��ѡ����Ȩ�޾Ϳ��Խ��к�������
    begin
      Right_Selected := true;
      break;
    end;
  end;
  result := Right_Selected;
end;

//ȷ���Ƿ��Ѿ�ѡ��Ȩ�޲�����Ȩ�޼�¼

procedure Tfrm_IC_SetParameter_Rightmanage.SaveRightSelected;
var
  i: integer;
begin
  for i := 1 to Arr_Wright_3F_length do
  //for i:= 0 to 22 do
  begin
    if Wright_3F[i].RIGHT_ID <> '' then
    //if  CheckListBox1.Checked[i] then
    begin
      SaveRecord_3F_RIGHT_SET(i);
    end;
  end;

end;


//�����û��嵥

procedure Tfrm_IC_SetParameter_Rightmanage.SaveRecord_3F_SysUser;
var
  ADOQ: TADOQuery;
  strSQL: string;
  strtemp1, strtemp: string;
begin

  begin
    strSQL := 'select * from  [3F_SysUser]  ';

    ADOQ := TADOQuery.Create(nil);
    with ADOQ do begin
      Connection := DataModule_3F.ADOConnection_Main;
      Active := false;
      SQL.Clear;
      SQL.Add(strSQL);
      Active := true;

      Append;

      FieldByName('UserNo').AsString := Edit_UserNO.Text;
      FieldByName('Opration').AsString := Edit_UserType.Text;
      FieldByName('UserName').AsString := Edit_UserName.Text; //ͨ����ȡ��������
      strtemp1 := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
      strtemp := ICFunction.ChangeAreaStrToHEX(Edit_UserPassword.Text);
      FieldByName('UserID').AsString := Edit_UserName.Text; //ͨ����ȡ��������

           //��3��4-copy(strtemp,11,2)
           //��7��8-copy(strtemp,7,2)
           //��11��12-copy(strtemp,3,2)
           //��15��16-copy(strtemp,9,2)
           //��19��20-copy(strtemp,1,2)
           //��23��24-copy(strtemp,5,2)

      FieldByName('UserPassword').AsString := copy(strtemp1, 3, 2) + copy(strtemp, 11, 2) + copy(strtemp1, 12, 2) + copy(strtemp, 7, 2) + copy(strtemp1, 15, 2) + copy(strtemp, 3, 2) + copy(strtemp1, 18, 2) + copy(strtemp, 9, 2) + copy(strtemp1, 15, 2) + copy(strtemp, 1, 2) + copy(strtemp1, 1, 2) + copy(strtemp, 5, 2);

      Post;
      Active := False;
    end;
    FreeAndNil(ADOQ);
  end;

end;


//�����û�Ȩ�޼�¼

procedure Tfrm_IC_SetParameter_Rightmanage.SaveRecord_3F_RIGHT_SET(RIGHT_ID: integer);
begin
  begin
    with ADOQuery_User do begin
      Append;
      FieldByName('ID_USER').AsString := '456AEF';
      FieldByName('ID_RIGHT').AsString := Wright_3F[RIGHT_ID].RIGHT_ID;
      FieldByName('RIGHT_NAME').AsString := Wright_3F[RIGHT_ID].Right_NAME;
      FieldByName('UserNo').AsString := Edit_UserNO.Text;
      FieldByName('UserType').AsString := Edit_UserType.Text;
      FieldByName('UserPassword').AsString := Edit_UserPassword.Text;
      FieldByName('UserName').AsString := Edit_UserName.Text;
      FieldByName('RIGHT_TIME').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
  end;
end;

//���������Ϸ���

procedure Tfrm_IC_SetParameter_Rightmanage.QueryMax_UserNo;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
                 //strSQL:= 'select max(GameNo) from [3F_SysUser]';    //����׷��ͬ���Ĵ���
  strSQL := 'select Count(ID) from [3F_SysUser]'; //����׷��ͬ���Ĵ���
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (ADOQTemp.Fields[0].AsInteger > 0) then
    begin
      i := ADOQTemp.Fields[0].AsInteger;

      if (i + 1) < 10 then
      begin
        nameStr := '00' + IntToStr(i + 1);
      end
      else if ((i + 1) <100) and ((i + 1) > 9) then
      begin
        nameStr := '0' + IntToStr(i + 1);
      end
      else
      begin
        nameStr := IntToStr(i + 1);
      end;
    end
    else
    begin
      nameStr := '001';
    end;
                           //Close;
  end;
  Edit_UserNO.Text := '000' + nameStr;
  Edit_UserPassword.Text := '000' + nameStr;
  FreeAndNil(ADOQTemp);

end;

//��ѯϵͳ�û��嵥��Ϣ

procedure Tfrm_IC_SetParameter_Rightmanage.Query_3F_SysUser(UserNO: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strTemp: string;

begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select * from [3F_SysUser] where UserNo=''' + UserNO + '''';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do begin
      Edit_UserType.Text := FieldByName('Opration').AsString;
      Edit_UserPassword.Text := FieldByName('UserPassword').AsString;
      Edit_UserName.Text := FieldByName('UserName').AsString;
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure Tfrm_IC_SetParameter_Rightmanage.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    Edit_UserNO.Enabled := true;
    Edit_UserPassword.Text := '';
    Edit_UserPassword.Text := '';
    BitBtn_Modify.Enabled := true;
    BitBtn_Delete.Enabled := true;
  end
  else
  begin
    Edit_UserNO.Enabled := false;
    QueryMax_UserNo;
    BitBtn_Modify.Enabled := false;
    BitBtn_Delete.Enabled := false;
  end;
end;

procedure Tfrm_IC_SetParameter_Rightmanage.comReaderReceiveData(
  Sender: TObject; Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //����----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //���������ת��Ϊ16������
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //����---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ�
  end;
end;



//���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ���

procedure Tfrm_IC_SetParameter_Rightmanage.CheckCMD();
var
  tmpStr: string;
begin
   //���Ƚ�ȡ���յ���Ϣ
  Edit_ID.Text := '';
  Edit_UserName.Text := '';
  tmpStr := recData_fromICLst.Strings[0];
  ReadCard_OK := false;
  Creat_USER.ID_CheckNum := copy(tmpStr, 39, 4); //У���
      // if(frm_Frontoperate_EBincvalue.CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//У���
  begin

    Creat_USER.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //֡ͷ43
    Creat_USER.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //��ƬID
    Creat_USER.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //����ID
    Creat_USER.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //������
    if DataModule_3F.Query_ID_OK(Creat_USER.ID_INIT) then
    begin
      ReadCard_OK := TRUE;
    end
    else
    begin
      ReadCard_OK := false; //��ѯ����
      Edit_ID.Text := '��ǰ���Ƿ�!��ȷ���Ƿ�Ϊ���ɵ�½������';
      exit;
    end;
            //Edit2.Text:=copy(INit_Wright.BOSS,8,2);
            //����Ա�Ŀ����ϰ忨
           // if (Creat_USER.ID_type=copy(INit_Wright.BOSS,8,2)) then
           //    begin
                   //ReadCard_OK:=TRUE;
          //     end

    if (Creat_USER.ID_type = copy(INit_Wright.MANEGER, 8, 2)) or (Creat_USER.ID_type = copy(INit_Wright.BOSS, 8, 2)) then
    begin
      ReadCard_OK := TRUE;
    end
    else
    begin
      ReadCard_OK := false; //��ѯ����
    end;

    if not ReadCard_OK then
    begin
      Edit_ID.Text := '��ǰ���Ƿ�!��ȷ���Ƿ�Ϊ���ɵ�½������';
      BitBtn_ADD.Enabled := FALSE;
      exit;
    end
    else
    begin
      Edit_UserName.Text := Creat_USER.ID_INIT;
      Edit_ID.Text := '��ǰ��Ϊ���ɵ�½��,���Լ���Ȩ�����ò�������';
      BitBtn_ADD.Enabled := TRUE;
    end;

  end;


end;

procedure Tfrm_IC_SetParameter_Rightmanage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  recData_fromICLst.Free();
  comReader.StopComm();
end;

end.