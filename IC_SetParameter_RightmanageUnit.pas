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
     //删除用户记录
    procedure DeleteUser(User_NO: string);

 //删除权限记录
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
//显示当前所有权限分配情况

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

//取消

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

//窗体加载

procedure Tfrm_IC_SetParameter_Rightmanage.FormShow(Sender: TObject);
begin
  Arr_Wright_3F_length := StrToInt(MaxRight);
  setlength(Wright_3F, Arr_Wright_3F_length + 1); //初始化权限数组变量

  ClearArr_Wright_3F;
  InitCheckListBox; //初始化权限组选择框
  //InitCheckListBoxChecked; //用的是基于OnClick事件来记录权限信息的，不是基于是否checked?
  InitDataBase;
  Edit_UserType.SetFocus;
  QueryMax_UserNo;

  comReader.StartComm();
  recData_fromICLst := tStringList.Create;
  BitBtn_ADD.Enabled := FALSE;
end;

//初始化权限数组变量内容

procedure Tfrm_IC_SetParameter_Rightmanage.ClearArr_Wright_3F;
var
  i: integer;
begin

  for i := 1 to Arr_Wright_3F_length do //初始化权限数组变量内容
  begin
    Wright_3F[i].Right_NAME := '';
    Wright_3F[i].RIGHT_CODE := '';
    Wright_3F[i].RIGHT_ID := '';
  end;

end;

//查询当前可以选择的权限组清单

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
    total := StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)); //字符串转换为整形？
    while i < total do begin
      CheckListBox1.Checked[i] := true;
      i := i+1;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;




//最大的ID

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

//显示权限ChecklistBox列表

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

//查询当前可以选择的权限组清单

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

//输入控制

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserNOKeyPress(
  Sender: TObject; var Key: Char);
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if (length(Edit_UserNO.Text) = 6) then
    begin
      Edit_UserPassword.SetFocus;
    end;
  end;
end;

//输入控制

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserPasswordKeyPress(
  Sender: TObject; var Key: Char);
begin

  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字！');
  end
  else if key = #13 then
  begin
    if (length(Edit_UserPassword.Text) = 6) then
    begin
      Edit_UserName.SetFocus;
    end;
  end;
end;

//输入控制

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserNameKeyPress(
  Sender: TObject; var Key: Char);
begin

   {  if not (key in['0'..'9',#8,#13])then
       begin
          key:=#0;
          ShowMessage('输入错误，只能输入数字！');
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

//用户类型输入控制

procedure Tfrm_IC_SetParameter_Rightmanage.Edit_UserTypeClick(
  Sender: TObject);
begin
          //  BitBtn_ADD.SetFocus;
end;


//保存权限分配记录

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn_ADDClick(Sender: TObject);
begin

  if CheckInput then //检查输入的内容是否正确
  begin
   //if CheckRightSelected then //没有选择任何一个权限
    begin
      SaveRightSelected; //保存选择的权限
      SaveRecord_3F_SysUser; //保存用户名单
      QueryMax_UserNo; //查询最大的用户代码，因为用户代码是由系统自动生存的
      Edit_UserType.SetFocus;
    end
  //else
  //begin
 //   ShowMessage('请给当前用户分配权限，否则操作失败！');
  //  exit;
 // end;
  end
  else
  begin
    exit;
  end;
end;


//修改权限（删除掉原来的所有权限，写入新选择的所有权限）

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn_ModifyClick(Sender: TObject);
begin
    //在添加权限的基础上追加一个删除的操作就行
       //首先弹出对话框，提醒操作者将进行删除权限操作
  if (MessageDlg('真的需要修改' + Edit_UserNO.Text + '的权限吗？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
  begin
    if CheckRightSelected then //没有选择任何一个权限
    begin
      Query_3F_SysUser(TrimRight(Edit_UserNO.Text)); //查询用户名单相关信息，给后面保存时使用
      DeleteUserRightOld('M'); //删除用户记录和权限记录
      SaveRightSelected; //保存选择的权限
      InitDataBase;
      QueryMax_UserNo; //查询最大的用户代码，因为用户代码是由系统自动生存的
      Edit_UserType.SetFocus;
    end
    else
    begin
      ShowMessage('请给当前用户分配权限，否则操作失败！');
      exit;
    end
  end
  else
  begin
    exit;
  end;

end;

//删除用户及相关权限记录

procedure Tfrm_IC_SetParameter_Rightmanage.BitBtn_DeleteClick(Sender: TObject);
begin

  if (MessageDlg('真的需要删除' + Edit_UserNO.Text + '的所有权限吗？删除后将不可恢复！！', mtInformation, [mbYes, mbNo], 0) = mrYes) then
  begin
    DeleteUserRightOld('D'); //删除用户记录和权限记录
    InitDataBase;
    QueryMax_UserNo; //查询最大的用户代码，因为用户代码是由系统自动生存的
    Edit_UserType.SetFocus;
  end
  else
  begin

    exit;

  end;
end;

procedure Tfrm_IC_SetParameter_Rightmanage.DeleteUserRightOld(OperatetionType: string);
begin

  if OperatetionType = 'D' then //删除时不单删除权限记录，而且删除用户记录
  begin
              //根据输入的用户代码，查询数据数据表中是否有相关记录3F_SysUser，有的话一起被删除
    DeleteUser(TrimRight(Edit_UserNO.Text));
  end;
          //根据输入的用户代码，查询数据数据表中是否有相关记录3F_RIGHT_SET，有的话一起被删除
  DeleteUserRight(TrimRight(Edit_UserNO.Text));
end;

 //删除用户记录

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
 //删除权限记录

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


//检测输入的内容是否完善

function Tfrm_IC_SetParameter_Rightmanage.CheckInput: boolean;
var
  i: integer;
  Input_OK: Boolean;
begin
  Input_OK := TRUE;
  if Edit_UserNO.Text = '' then
  begin
    ShowMessage('用户代码不能空');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserNO.Text)) <> 6 then
  begin
    ShowMessage('用户代码长度必须等于6');
    Input_OK := FALSE;
  end
  else if Edit_UserType.Text = '' then
  begin
    ShowMessage('用户类型不能空');
    Input_OK := FALSE;
  end
  else if Edit_UserType.Text = '请选择' then
  begin
    ShowMessage('请选择用户类型');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserType.Text)) < 2 then
  begin
    ShowMessage('请选择用户类型');
    Input_OK := FALSE;
  end
  else if Edit_UserName.Text = '' then
  begin
    ShowMessage('用户名称不能空');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserName.Text)) = 0 then
  begin
    ShowMessage('用户名称不能空');
    Input_OK := FALSE;
  end
  else if Edit_UserPassword.Text = '' then
  begin
    ShowMessage('用户密码不能空');
    Input_OK := FALSE;
  end
  else if length(Trim(Edit_UserPassword.Text)) <> 6 then
  begin
    ShowMessage('用户密码长度必须等于6');
    Input_OK := FALSE;
  end;
  result := Input_OK;
end;

//确认是否已经选择权限并保存权限记录

function Tfrm_IC_SetParameter_Rightmanage.CheckRightSelected: boolean;
var
  i: integer;
  Right_Selected: Boolean;
begin
  Right_Selected := false;
  for i := 1 to Arr_Wright_3F_length do
  begin
    if Wright_3F[i].RIGHT_ID <> '' then //只要检测到有一个选择了权限就可以进行后续操作
    begin
      Right_Selected := true;
      break;
    end;
  end;
  result := Right_Selected;
end;

//确认是否已经选择权限并保存权限记录

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


//新增用户清单

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
      FieldByName('UserName').AsString := Edit_UserName.Text; //通过读取管理卡号
      strtemp1 := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);
      strtemp := ICFunction.ChangeAreaStrToHEX(Edit_UserPassword.Text);
      FieldByName('UserID').AsString := Edit_UserName.Text; //通过读取管理卡号

           //第3、4-copy(strtemp,11,2)
           //第7、8-copy(strtemp,7,2)
           //第11、12-copy(strtemp,3,2)
           //第15、16-copy(strtemp,9,2)
           //第19、20-copy(strtemp,1,2)
           //第23、24-copy(strtemp,5,2)

      FieldByName('UserPassword').AsString := copy(strtemp1, 3, 2) + copy(strtemp, 11, 2) + copy(strtemp1, 12, 2) + copy(strtemp, 7, 2) + copy(strtemp1, 15, 2) + copy(strtemp, 3, 2) + copy(strtemp1, 18, 2) + copy(strtemp, 9, 2) + copy(strtemp1, 15, 2) + copy(strtemp, 1, 2) + copy(strtemp1, 1, 2) + copy(strtemp, 5, 2);

      Post;
      Active := False;
    end;
    FreeAndNil(ADOQ);
  end;

end;


//新增用户权限记录

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

//根据最大游戏编号

procedure Tfrm_IC_SetParameter_Rightmanage.QueryMax_UserNo;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
                 //strSQL:= 'select max(GameNo) from [3F_SysUser]';    //考虑追加同名的处理
  strSQL := 'select Count(ID) from [3F_SysUser]'; //考虑追加同名的处理
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

//查询系统用户清单信息

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
   //接收----------------
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2); //将获得数据转换为16进制数
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
  recData_fromICLst.Clear;
  recData_fromICLst.Add(recStr);
    //接收---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;
end;



//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_IC_SetParameter_Rightmanage.CheckCMD();
var
  tmpStr: string;
begin
   //首先截取接收的信息
  Edit_ID.Text := '';
  Edit_UserName.Text := '';
  tmpStr := recData_fromICLst.Strings[0];
  ReadCard_OK := false;
  Creat_USER.ID_CheckNum := copy(tmpStr, 39, 4); //校验和
      // if(frm_Frontoperate_EBincvalue.CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin

    Creat_USER.CMD := copy(recData_fromICLst.Strings[0], 1, 2); //帧头43
    Creat_USER.ID_INIT := copy(recData_fromICLst.Strings[0], 3, 8); //卡片ID
    Creat_USER.ID_3F := copy(recData_fromICLst.Strings[0], 11, 6); //卡厂ID
    Creat_USER.ID_type := copy(recData_fromICLst.Strings[0], 37, 2); //卡功能
    if DataModule_3F.Query_ID_OK(Creat_USER.ID_INIT) then
    begin
      ReadCard_OK := TRUE;
    end
    else
    begin
      ReadCard_OK := false; //查询数据
      Edit_ID.Text := '当前卡非法!请确认是否为许可登陆卡！！';
      exit;
    end;
            //Edit2.Text:=copy(INit_Wright.BOSS,8,2);
            //管理员的卡和老板卡
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
      ReadCard_OK := false; //查询数据
    end;

    if not ReadCard_OK then
    begin
      Edit_ID.Text := '当前卡非法!请确认是否为许可登陆卡！！';
      BitBtn_ADD.Enabled := FALSE;
      exit;
    end
    else
    begin
      Edit_UserName.Text := Creat_USER.ID_INIT;
      Edit_ID.Text := '当前卡为许可登陆卡,可以继续权限设置操作！！';
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
