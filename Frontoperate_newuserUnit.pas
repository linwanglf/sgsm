unit Frontoperate_newuserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB,
  SPComm, DateUtils;
type
  Tfrm_Frontoperate_newuser = class(TForm)
    comReader: TComm;
    ADOQuery_newmenber: TADOQuery;
    DataSource_Newmenber: TDataSource;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    DataSource2: TDataSource;
    ADOQuery2: TADOQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Bit_Close: TBitBtn;
    Panel4: TPanel;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    ComboBox_Menbertype: TComboBox;
    Edit_IDNo: TEdit;
    Bit_Query: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Edit_ID: TEdit;
    Edit_PrintNO: TEdit;
    Edit_Username: TEdit;
    Comb_Month: TComboBox;
    Comb_Day: TComboBox;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_Prepassword: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_Mobile: TEdit;
    rgSexOrg: TRadioGroup;
    DataSource3: TDataSource;
    ADOQuery_renewmenberrecord: TADOQuery;
    DBGrid2: TDBGrid;
    Image1: TImage;
    Panel_Message: TPanel;
    Label20: TLabel;
    Label21: TLabel;
    Bit_Add: TBitBtn;
    Label22: TLabel;
    Label23: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormCreate(Sender: TObject);
    procedure Bit_QueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bit_AddClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Edit_SaveMoneyKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_PrintNOKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_MobileKeyPress(Sender: TObject; var Key: Char);
    procedure Comb_MonthKeyPress(Sender: TObject; var Key: Char);
    procedure Comb_DayKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_CertifyKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure Initmenberlevel;
    procedure Initmenbertype;
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure CheckCMD();
    procedure InitDataBase;
    function Query_Menbertype(S1: string): string;
    function Querylevel_LevNO(S1: string): string;
    procedure CreatUserNO(StrID: string);
    function CountUserNO: string;
    function OnlyCheck(StrID: string): boolean;
    procedure Query_MenberLevInfor(StrLevNum: string);
    procedure Getmenberinfo(S1, S2: string);
    procedure Mobile_Onlycheck(StrMobile: string);
    procedure Edit_Certify_Onlycheck(StrMobile: string);
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_newuser: Tfrm_Frontoperate_newuser;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  orderLst, recDataLst, recData_fromICLst: Tstrings;
  Check_OK: BOOLEAN;
  buffer: array[0..2048] of byte;
implementation

uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit, ICFunctionUnit, Frontoperate_EBincvalueUnit;

{$R *.dfm}
//初始化用户类型

procedure Tfrm_Frontoperate_newuser.Initmenberlevel;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select distinct [LevName] from [TLevel]';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_menberlevel.Items.Clear;
    while not Eof do begin
      Comb_menberlevel.Items.Add(FieldByName('LevName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

//初始化帐户类型

procedure Tfrm_Frontoperate_newuser.Initmenbertype;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
begin

 // ADOQTemp:=TADOQuery.Create(nil);
 // strSQL:= 'select distinct [MemtypeName] from [TMemtype]';
 // with ADOQTemp do begin
  //  Connection := DataModule_3F.ADOConnection_Main;
  //  SQL.Clear;
  //  SQL.Add(strSQL);
  //  Active:=True;
  //  ComboBox_Menbertype.Items.Clear;
  //  while not Eof do begin
  //    ComboBox_Menbertype.Items.Add(FieldByName('MemtypeName').AsString);
  //    Next;
  //    end;
  //  end;
 // FreeAndNil(ADOQTemp);

  ComboBox_Menbertype.Items.Clear;
   //Edit1.Text:= LOAD_USER.ID_type;
   //Edit2.Text:= copy(INit_Wright.BOSS,8,2);
  if (LOAD_USER.ID_type = copy(INit_Wright.Produecer_3F, 8, 2)) then //3F权限
  begin
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.Produecer_3F, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.BOSS, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.QUERY, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.SETTING, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));
  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.BOSS, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.BOSS, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.QUERY, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.SETTING, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));

  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.MANEGER, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.User, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.MANEGER, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.RECV_CASE, 1, 6));
    ComboBox_Menbertype.Items.Add(copy(INit_Wright.OPERN, 1, 6));

  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.QUERY, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Clear;
  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.SETTING, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Clear;
  end
  else if (LOAD_USER.ID_type = copy(INit_Wright.OPERN, 8, 2)) then
  begin
    ComboBox_Menbertype.Items.Clear;
  end;
end;


procedure Tfrm_Frontoperate_newuser.FormCreate(Sender: TObject);
begin

  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;

end;

procedure Tfrm_Frontoperate_newuser.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_newmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TMemberInfo]';
    SQL.Add(strSQL);
    Active := True;
  end;

end;


//转找发送数据格式

function Tfrm_Frontoperate_newuser.exchData(orderStr: string): string;
var
  ii, jj: integer;
  TmpStr: string;
  reTmpStr: string;
begin
  if (length(orderStr) = 0) then
  begin
    MessageBox(handle, '传入参数不能为空!', '错误', MB_ICONERROR + MB_OK);
    result := '';
    exit;
  end;
  if (length(orderStr) mod 2) <> 0 then
  begin
    MessageBox(handle, '传入参数错误!', '错误', MB_ICONERROR + MB_OK);
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

//发送数据过程

procedure Tfrm_Frontoperate_newuser.sendData();
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

//检查返回的数据

procedure Tfrm_Frontoperate_newuser.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    0: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                      //  memComSet.Lines.Add('读卡器连结失败');
                      //  memComSet.Lines.Add('');
            exit;
          end;
              //  memComSet.Lines.Add('读卡器连结成功');
              //  memComSet.Lines.Add('');
      end;
    1: begin
             //   memLowRe.Lines.Add('命令: 寻卡');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                //    memLowRe.Lines.Add('结果: 寻卡失败')
        else begin
                  //  memLowRe.Lines.Add('结果: 寻卡成功');
          if copy(recDataLst.Strings[0], 5, 2) = '04' then
                   //     memLowRe.Lines.Add('该卡片为Mifare one')
          else
                   //     memLowRe.Lines.Add('该卡片为其它类型');
        end;
              //  memLowRe.Lines.Add('');
      end;
    2: begin
                //memLowRe.Lines.Add('命令: 防冲突');
                //  AND (copy(recDataLst.Strings[0],23,2)='4A')
        if (copy(recDataLst.Strings[0], 9, 2) = 'A1') and (copy(recDataLst.Strings[0], 23, 2) = '4A') then
        begin
          Edit_IDNo.Text := copy(recDataLst.Strings[0], 13, 8); //截取卡ID
          Edit_ID.Text := copy(recDataLst.Strings[0], 13, 8);
                   // memLowRe.Lines.Add('结果: 防冲突失败')
        end
        else begin
                  //  memLowRe.Lines.Add('结果: 防冲突成功');
          tmpStr := recDataLst.Strings[0];
          tmpStr := copy(tmpStr, 5, length(tmpStr) - 4);

          Edit_IDNo.Text := '读卡失败，请确认此卡的真假！'; //截取卡ID
                   // memLowRe.Lines.Add('序号: '+tmpStr);
        end;
                 // memLowRe.Lines.Add('');

      end;
  end;

end;

//读取ID卡号

procedure Tfrm_Frontoperate_newuser.Bit_QueryClick(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
  orderLst.Add('AA8A5F5FA101004A');
  sendData();
end;
//接收串口返回的数据

procedure Tfrm_Frontoperate_newuser.comReaderReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
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
       // if (intTohex(ord(tmpStr[ii]),2)='4A') then
    if ii = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;
     // Edit1.Text:=recStr;
  recDataLst.Clear;
  recDataLst.Add(recStr);
    //接收---------------
     //if  (tmpStrend='END') then
  begin
    CheckCMD(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡
  end;

end;

//根据接收到的数据判断此卡是否为合法卡

procedure Tfrm_Frontoperate_newuser.CheckCMD();
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
   //首先截取接收的信息

  tmpStr := recDataLst.Strings[0];
  Edit1.Text := recDataLst.Strings[0];
  Receive_CMD_ID_Infor.ID_CheckNum := copy(tmpStr, 39, 4); //校验和

      // if (CheckSUMData(copy(tmpStr, 1, 38))=copy(tmpStr, 41, 2)+copy(tmpStr, 39, 2)) then//校验和
  begin
    CMD_CheckSum_OK := true;
    Receive_CMD_ID_Infor.CMD := copy(recDataLst.Strings[0], 1, 2); //帧头43
  end;

  if Receive_CMD_ID_Infor.CMD = CMD_COUMUNICATION.CMD_READ then
  begin

    Receive_CMD_ID_Infor.ID_INIT := copy(recDataLst.Strings[0], 3, 8); //卡片ID
    Receive_CMD_ID_Infor.ID_3F := copy(recDataLst.Strings[0], 11, 6); //卡厂ID
    Receive_CMD_ID_Infor.Password_3F := copy(recDataLst.Strings[0], 17, 6); //卡密
    Receive_CMD_ID_Infor.Password_USER := copy(recDataLst.Strings[0], 23, 6); //用户密码
    Receive_CMD_ID_Infor.ID_value := copy(recDataLst.Strings[0], 29, 8); //卡内数据
    Receive_CMD_ID_Infor.ID_type := copy(recDataLst.Strings[0], 37, 2); //卡功能
    Edit4.Text:= '--'+Receive_CMD_ID_Infor.ID_INIT;
    Edit3.Text:= Receive_CMD_ID_Infor.ID_type;
                 //1、判断是否曾经初始化过，如果是则，执行步骤2 ICFunction.
                // if ICFunction.CHECK_3F_ID(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.ID_3F,Receive_CMD_ID_Infor.Password_3F) then
    begin

                //2、如果确认完成了初始化，则进一步判断此卡是否属于此客户的
                //而Receive_CMD_ID_Infor.Password_USER=ICFunction.SUANFA_Password_USER(INit_3F.ID_3F,CUSTOMER_NO.Text);

                        //与老板初始化的场地密码比较 ，而且必须是用户卡才能充值 ,同时此卡必须在数据表中有记录
                        //20120923修改判断条件，改为直接与老板初始化设定的场地密码比较
                          //else if ICFunction.CHECK_Customer_ID_USERINIT(Receive_CMD_ID_Infor.ID_INIT,Receive_CMD_ID_Infor.Password_USER) and  (Receive_CMD_ID_Infor.ID_type=copy(INit_Wright.User,8,2))then

      if (Receive_CMD_ID_Infor.Password_USER = INit_Wright.BossPassword) and (Receive_CMD_ID_Infor.ID_type = copy(INit_Wright.RECV_CASE, 8, 2)) then //用收银卡作为会员卡

      begin

        if DataModule_3F.Query_User_INIT_OK(Receive_CMD_ID_Infor.ID_INIT) then //有记录
        begin

          if OnlyCheck(Receive_CMD_ID_Infor.ID_INIT) then
          begin
            Panel_Message.Caption := '此卡ID已经存在，请确认卡来源！'; //卡ID
          end
          else

          begin

            Edit_ID.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
            Edit_IDNo.Text := Receive_CMD_ID_Infor.ID_INIT; //卡ID
            //CreatUserNO(Receive_CMD_ID_Infor.ID_INIT); //生成印刷卡号
            //modified by linlf; it is no need to get the focus;
            //Edit_Username.SetFocus;
            Panel_Message.Caption := '此卡合法，请继续操作！'; //卡ID

          end;


        end
        else
        begin

          Edit_ID.Text := ''; //卡ID
          Edit_IDNo.Text := ''; //卡ID

          Panel_Message.Caption := '在此系统无记录，请确认是否已经完成场地初始化！'; //卡ID
          exit;

        end;


      end
      else
      begin
        Edit_ID.Text := ''; //卡ID
        Edit_IDNo.Text := ''; //卡ID
        Panel_Message.Caption := '此卡非法，请更换！'; //卡ID
        exit;
      end;

    end;
               //    else //卡认证为非法卡
                //   begin
                //          Edit14.Text:= '此卡非法，请通知您的老板！'; //卡ID
                 //         exit;
               //    end;

  end;

end;

procedure Tfrm_Frontoperate_newuser.CreatUserNO(StrID: string);
begin

  Edit_PrintNO.text := StrID + CountUserNO;
end;

function Tfrm_Frontoperate_newuser.CountUserNO: string;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] ';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    reTmpStr := TrimRight(ADOQTemp.Fields[0].AsString);

    if StrToInt(reTmpStr) < 10 then
      reTmpStr := '000' + reTmpStr
    else if (StrToInt(reTmpStr) < 100) and (StrToInt(reTmpStr) > 9) then
      reTmpStr := '00' + reTmpStr
    else if (StrToInt(reTmpStr) < 1000) and (StrToInt(reTmpStr) > 99) then
      reTmpStr := '0' + reTmpStr
    else if (StrToInt(reTmpStr) < 10000) and (StrToInt(reTmpStr) > 999) then
      reTmpStr := reTmpStr;
  end;
  FreeAndNil(ADOQTemp);
  Result := reTmpStr;
end;

function Tfrm_Frontoperate_newuser.OnlyCheck(StrID: string): boolean;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: boolean;
begin
  reTmpStr := false;


  ADOQTemp := TADOQuery.Create(nil);
  //strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''' + StrID + '''';
  strSQL := 'select Count([MemCardNo]) from [TMemberInfo] where IDCardNo=''11''';

  with ADOQTemp do
  begin
  {
    Connection := DataModule_3F.ADOConnection_main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;

    if StrToInt(TrimRight(ADOQTemp.Fields[0].AsString)) > 0 then
      reTmpStr := true;
   }
  end;

  
  FreeAndNil(ADOQTemp);

  Result := reTmpStr;

end;


procedure Tfrm_Frontoperate_newuser.FormShow(Sender: TObject);
begin
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
  InitDataBase; //显示出型号
  Initmenberlevel;
    //Initmenbertype;
  Check_OK := false;
end;

procedure Tfrm_Frontoperate_newuser.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin


  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  ICFunction.ClearIDinfor; //清除从ID读取的所有信息
  Check_OK := false;
    //清理表格
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;
end;


  //查询等级代码

function Tfrm_Frontoperate_newuser.Querylevel_LevNO(S1: string): string;
var
  strSQL: string;
  temp: string;
  temp_levelno: string;
begin

  with ADOQuery1 do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select LevNo from [TLevel] where  LevName=''' + S1 + '''';
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      temp_levelno := ADOQuery1.Fields[0].AsString;
    Close;
  end;
  result := temp_levelno;

end;

  //查询账户类型代码

function Tfrm_Frontoperate_newuser.Query_Menbertype(S1: string): string;
var
  strSQL: string;
  temp: string;
  temp_levelno: string;
begin
  with ADOQuery1 do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select MemtypeNo from [TMemtype] where  MemtypeName=''' + S1 + '''';
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      temp_levelno := ADOQuery1.Fields[0].AsString;
    Close;
  end;
  result := temp_levelno;

end;
//新建用户

procedure Tfrm_Frontoperate_newuser.Bit_AddClick(Sender: TObject);
var
  strMenbertype, strinputdatetime, strID, strPrintNO, strUsername, strMobile, strmenberlevel, strMonth, strDay, strOperator, strCertify, strPrepassword: string;
  i, j: integer;
  EditOKStr, pwdStr: string;
  strsexOrg: Boolean;
  strSaveMoney: Currency;
  Strtest: string;
label ExitSub;
begin
  //strMenbertype:=Query_Menbertype(TrimRight(ComboBox_Menbertype.Text));
  strMenbertype := 'A类帐户';
  //Strtest:='A类帐户';
 // strMenbertype:=Query_Menbertype(Strtest);
  strmenberlevel := Querylevel_LevNO(TrimRight(Comb_menberlevel.Text));

  strPrintNO := Edit_PrintNO.Text;
  strUsername := Edit_Username.Text;
  strMonth := Comb_Month.Text;
  strOperator := G_User.UserNO;
  strDay := Comb_Day.Text;

  strCertify := Edit_Certify.Text;
  strSaveMoney := StrToCurr(Edit_SaveMoney.Text);
  strPrepassword := Edit_Prepassword.Text;
  strMobile := Edit_Mobile.Text;

  strID := Edit_ID.Text;
  EditOKStr := 'ok';
  strinputdatetime := DateTimetostr((now())); //录入时间，读取系统时间
  if rgSexOrg.ItemIndex = 0 then
    strsexOrg := true
  else
    strsexOrg := false;


  if (Edit_ID.Text = '') then //卡ID
  begin
    ShowMessage('请确认是否已经成功刷卡');
    EditOKStr := 'NG';
    exit;
  end;
  if length(TrimRight(Edit_Certify.Text)) <> 18 then //卡ID
  begin
    ShowMessage('请确认身份证长度是否正确');
    EditOKStr := 'NG';
    exit;
  end;
  if length(TrimRight(Edit_Mobile.Text)) <> 11 then //卡ID
  begin
    ShowMessage('请确认手机号长度是否正确');
    EditOKStr := 'NG';
    exit;
  end;
  if (Edit_SaveMoney.Text = '') then //卡ID
  begin
    ShowMessage('请确认押金是否填写');
    EditOKStr := 'NG';
    exit;
  end;
  if length(TrimRight(Edit_Prepassword.Text)) <> 6 then //卡ID
  begin
    ShowMessage('请确认密码长度是否正确');
    EditOKStr := 'NG';
    exit;
  end;
  if (Comb_menberlevel.Text = '') then //卡ID
  begin
    ShowMessage('请确认是否选择了用户等级');
    EditOKStr := 'NG';
    exit;
  end;

  if EditOKStr = 'NG' then
    ShowMessage('信息不完整')
  else begin
    with ADOQuery_newmenber do begin
      if (Locate('IDCardNo', strID, [])) then begin
        if (MessageDlg('持卡号  ' + strID + '  的用户已经存在，要更新吗？', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else
        Append;
      FieldByName('MemCardNo').AsString := strPrintNO;
      FieldByName('MemType').AsString := strMenbertype;
      FieldByName('IDCardNo').AsString := strID;
      FieldByName('MemberName').AsString := strUsername;
      FieldByName('Sex').AsBoolean := strsexOrg;
      FieldByName('Birthday').AsString := strMonth + '-' + strDay;
      FieldByName('Mobile').AsString := strMobile;
      FieldByName('DocNumber').AsString := strCertify;
      FieldByName('Deposit').AsCurrency := strSaveMoney;
      FieldByName('LevNum').AsString := strmenberlevel;
      FieldByName('InfoKey').AsString := strPrepassword;
      FieldByName('OpenCardDT').AsString := strinputdatetime;
      FieldByName('EffectiveDT').AsString := copy(strinputdatetime, 1, 2) + IntToStr(StrToInt(copy(strinputdatetime, 3, 2)) + 10) + copy(strinputdatetime, 5, length(strinputdatetime) - 4);

      FieldByName('IsAble').AsString := '1'; //1代表“正常”
      FieldByName('TickAmount').AsString := '0';
      FieldByName('cUserNo').AsString := strOperator;

                  //FieldByName('OpenCardDT').AsString :=strinputdatetime;
                 // FieldByName('IsAble').AsString :='正常';
                  //FieldByName('TickAmount').AsString :='0';

      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;


    ExitSub:
    Edit_PrintNO.Text := '';
    Edit_Username.Text := '';
    Comb_Month.Text := '';
    Comb_Day.Text := '';
    Edit_Certify.Text := '';
               //Edit_SaveMoney.Text:='';
    Edit_Prepassword.Text := '';
               //Comb_menberlevel.Text:='';
    Edit_Mobile.Text := '';
    Edit_ID.Text := '';
  end;
end;

procedure Tfrm_Frontoperate_newuser.Bit_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_Frontoperate_newuser.Edit_SaveMoneyKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end

end;

procedure Tfrm_Frontoperate_newuser.Edit_PrintNOKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;


procedure Tfrm_Frontoperate_newuser.Comb_MonthKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;

procedure Tfrm_Frontoperate_newuser.Comb_DayKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end
end;

procedure Tfrm_Frontoperate_newuser.Edit_MobileKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
  begin
    key := #0;
  end;
  if (length(trimright(Edit_Mobile.Text)) = 11) and (key = #13) then
  begin
    Mobile_Onlycheck(trimright(Edit_Mobile.Text));
  end;
end;

procedure Tfrm_Frontoperate_newuser.Edit_CertifyKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
  end;
  if (length(trimright(Edit_Certify.Text)) = 18) and (key = #13) then
  begin
    Mobile_Onlycheck(trimright(Edit_Certify.Text));
  end;
end;

procedure Tfrm_Frontoperate_newuser.Mobile_Onlycheck(StrMobile: string);
begin
  Getmenberinfo('根据用户手机号', StrMobile);
end;

procedure Tfrm_Frontoperate_newuser.Edit_Certify_Onlycheck(StrMobile: string);
begin
  Getmenberinfo('根据用户身份证', StrMobile);
end;

procedure Tfrm_Frontoperate_newuser.Getmenberinfo(S1, S2: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
  strsexOrg: string;
begin

  if S1 = '根据用户手机号' then
    strSQL := 'select * from [TMemberInfo] where  [Mobile]=''' + S2 + ''''
  else if S1 = '根据用户身份证' then
    strSQL := 'select * from [TMemberInfo] where  [DocNumber]=''' + S2 + ''''
  else
  begin
    exit;
  end;
  ADOQTemp := TADOQuery.Create(nil);

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    while not Eof do
    begin
      Edit_PrintNO.text := FieldByName('MemCardNo').AsString;
      Edit_Username.text := FieldByName('MemberName').AsString;
      Edit_ID.text := FieldByName('IDCardNo').AsString;
      Edit_Prepassword.text := FieldByName('InfoKey').AsString;
      Edit_Mobile.text := FieldByName('Mobile').AsString;
      Edit_Certify.text := FieldByName('DocNumber').AsString;
      Edit_SaveMoney.text := FieldByName('Deposit').AsString;

      strsexOrg := FieldByName('Sex').AsString;
      if strsexOrg = '1' then
        rgSexOrg.ItemIndex := 0
      else
        rgSexOrg.ItemIndex := 1;

      Query_MenberLevInfor(TrimRight(FieldByName('LevNum').AsString));
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

 //查询等级资料

procedure Tfrm_Frontoperate_newuser.Query_MenberLevInfor(StrLevNum: string); //查询等级资料
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select LevName from [TLevel] where LevNo=''' + StrLevNum + '''';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Comb_menberlevel.text := FieldByName('LevName').AsString;
  end;
  FreeAndNil(ADOQTemp);
end;



end.
