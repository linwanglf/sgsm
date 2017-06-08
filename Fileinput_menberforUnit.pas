unit Fileinput_menberforUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, ExtCtrls, Buttons, DB, ADODB;

type
  Tfrm_Fileinput_menberfor = class(TForm)
    pgcMenberfor: TPageControl;
    tbsConfig: TTabSheet;
    tbsLowLevel: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    Bit_Add: TBitBtn;
    Bit_Update: TBitBtn;
    Bit_Delete: TBitBtn;
    Bit_Close: TBitBtn;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel4: TPanel;
    Bit_Add_Give: TBitBtn;
    Bit_Update_Give: TBitBtn;
    Bit_Delete_Give: TBitBtn;
    Bit_Close_Give: TBitBtn;
    Label3: TLabel;
    Label24: TLabel;
    Edit_core: TEdit;
    Label23: TLabel;
    Edit_levelname: TEdit;
    Label22: TLabel;
    Edit_level: TEdit;
    DataSource_SetmenberGive: TDataSource;
    ADOQuery_SetmenberGive: TADOQuery;
    Memo_instruction: TMemo;
    Label1: TLabel;
    Edit_GiveNO: TEdit;
    Edit_Giveuplimit: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Edit_Givelowlimit: TEdit;
    Memo_Giveinstruction: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    Edit_Givevalue: TEdit;
    ADOQuery_Setmenberfor: TADOQuery;
    DataSource_Setmenberfor: TDataSource;
    DBGrid1: TDBGrid;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    DBGrid_Festpack: TDBGrid;
    Panel6: TPanel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Bit_Add_Festpack: TBitBtn;
    Bit_Update_Festpack: TBitBtn;
    Bit__Del_Festpack: TBitBtn;
    Bit_Close_Festpack: TBitBtn;
    Edit_FestName: TEdit;
    Edit_FestNo: TEdit;
    Memo_Remark: TMemo;
    Label11: TLabel;
    rg_IsUse: TRadioGroup;
    Label12: TLabel;
    Edit_cUserNo: TEdit;
    DataSource_Festpack: TDataSource;
    ADOQuery_Festpack: TADOQuery;
    procedure Bit_AddClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Bit_UpdateClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Bit_DeleteClick(Sender: TObject);
    procedure Bit_Close_GiveClick(Sender: TObject);
    procedure Bit_Add_GiveClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure Bit_Update_GiveClick(Sender: TObject);
    procedure Bit_Delete_GiveClick(Sender: TObject);
    procedure Bit_Add_FestpackClick(Sender: TObject);
    procedure DBGrid_FestpackDblClick(Sender: TObject);
    procedure Bit_Update_FestpackClick(Sender: TObject);
    procedure Bit__Del_FestpackClick(Sender: TObject);
    procedure Bit_Close_FestpackClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitDataBase;
    function GetmenberGivelimitvaluecomfir(vlowlimit: string): string;
  public
    { Public declarations }
  end;

var
  frm_Fileinput_menberfor: Tfrm_Fileinput_menberfor;

implementation

uses ICDataModule, ICCommunalVarUnit, ICmain, ICEventTypeUnit;
{$R *.dfm}

//���Ӽ�¼

procedure Tfrm_Fileinput_menberfor.Bit_AddClick(Sender: TObject);


var
  strcore, strlevel, strlevelname, strMemo_instruction, strOperator: string;
label ExitSub;
begin
  strcore := Edit_core.Text;
  strlevel := Edit_level.Text;
  strlevelname := Edit_levelname.Text;
  strOperator := G_User.UserNO;
  strMemo_instruction := Memo_instruction.Text;


  if Edit_level.Text = '' then
    ShowMessage('�ȼ����ܿ�')
  else if Edit_levelname.Text = '' then
    ShowMessage('�ȼ����Ʋ��ܿ�')
  else if Edit_core.Text = '' then
    ShowMessage('���ֲ��ܿ�')

  else begin
    with ADOQuery_Setmenberfor do begin
      if (Locate('�ȼ����', strlevel, [])) then begin
        if (MessageDlg('�Ѿ�����  ' + strlevel + '  Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else if (Locate('�ȼ�����', strlevelname, [])) then begin
        if (MessageDlg('�Ѿ�����  ' + strlevelname + '  Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else
        Append;
      FieldByName('LevNo').AsString := strlevel;
      FieldByName('LevName').AsString := strlevelname;
      FieldByName('Score').AsString := strcore;
      FieldByName('cUserNo').AsString := strOperator;
      FieldByName('Remark').AsString := strMemo_instruction;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
    ExitSub:

    Edit_core.Text := '';
    Edit_level.Text := '';
    Edit_levelname.Text := '';
    Memo_instruction.Text := '';
  end;
end;

//˫����¼��������²���

procedure Tfrm_Fileinput_menberfor.DBGrid1DblClick(Sender: TObject);
begin
  Edit_core.Text := DBGrid1.DataSource.DataSet.FieldByName('Score').AsString;
  Edit_level.Text := DBGrid1.DataSource.DataSet.FieldByName('LevNo').AsString;
  Edit_levelname.Text := DBGrid1.DataSource.DataSet.FieldByName('LevName').AsString;
  Memo_instruction.Text := DBGrid1.DataSource.DataSet.FieldByName('Remark').AsString;
  Bit_Update.Enabled := True;
end;

//��Ա�ȼ��ײ͸��²���

procedure Tfrm_Fileinput_menberfor.Bit_UpdateClick(Sender: TObject);
var
  strcore, strlevel, strlevelname, strMemo_instruction, strOperator: string;
begin
  if ((Length(strlevel) > 0) and (Length(strlevelname) > 0) and (Length(strcore) > 0)) then begin
      // ShowMessage('�ȼ����Ʋ��ܿ�');
    Exit;
  end;
  strcore := Edit_core.Text;
  strlevel := Edit_level.Text;
  strlevelname := Edit_levelname.Text;
  strOperator := G_User.UserNO;
  strMemo_instruction := Memo_instruction.Text;

  with ADOQuery_Setmenberfor do begin
    if (not Locate('LevNo', strlevel, [])) then
      Exit;
    Edit;
    FieldByName('LevNo').AsString := strlevel;
    FieldByName('LevName').AsString := strlevelname;
    FieldByName('Score').AsString := strcore;
    FieldByName('cUserNo').AsString := strOperator;
    FieldByName('Remark').AsString := strMemo_instruction;
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;

  Edit_core.Text := '';
  Edit_level.Text := '';
  Edit_levelname.Text := '';
  Memo_instruction.Text := '';
  Bit_Update.Enabled := False;
end;


procedure Tfrm_Fileinput_menberfor.FormCreate(Sender: TObject);
begin
  EventObj := EventUnitObj.Create;
  EventObj.LoadEventIni;
 // InitStringGrid;
 // InitWorkParam;                          //��ʼ��PLC�¼��������
  InitDataBase; //��ʾ���ͺ�
 // InitEdit;                               //���Edit��
 // InitDuanXH;                             //��ʼ���ͺ�Combox_Type_JH
 // PageControl_Set.ActivePageIndex:=0;

 // InitUser;
end;

procedure Tfrm_Fileinput_menberfor.InitDataBase;
var
  strSQL: string;
begin
    //��Ա�ȼ��ײ�
  with ADOQuery_Setmenberfor do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [TLevel]';
    SQL.Add(strSQL);
    Active := True;
  end;
    //�����ײ�
  with ADOQuery_SetmenberGive do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_MenberGivecore]';
    SQL.Add(strSQL);
    Active := True;
  end;
      //�����ײ�
  with ADOQuery_Festpack do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [FestPack]';
    SQL.Add(strSQL);
    Active := True;
  end;
end;


procedure Tfrm_Fileinput_menberfor.Bit_CloseClick(Sender: TObject);
begin
  frm_Fileinput_menberfor.Close;
end;

procedure Tfrm_Fileinput_menberfor.Bit_DeleteClick(Sender: TObject);
var
  strTemp: string;
begin
  strTemp := ADOQuery_Setmenberfor.FieldByName('LevNo').AsString;
  if (MessageDlg('ȷʵҪɾ�� �ȼ����Ϊ' + strTemp + ' ����ؼ�¼��?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    DBGrid1.DataSource.DataSet.Delete;
end;



procedure Tfrm_Fileinput_menberfor.Bit_Close_GiveClick(Sender: TObject);
begin
  Close;
end;


//��ֵ�����ײ�������¼

procedure Tfrm_Fileinput_menberfor.Bit_Add_GiveClick(Sender: TObject);

var
  strcore, strlevel, strlevelname, strMemo_instruction, strOperator, struplimit, strlowlimit: string;
label ExitSub;
begin
  strcore := Edit_Givevalue.Text;
  strlevel := Edit_GiveNO.Text;
  struplimit := Edit_Giveuplimit.Text;
  strlowlimit := Edit_Givelowlimit.Text;
  strOperator := G_User.UserNO;
  strMemo_instruction := Memo_Giveinstruction.Text;


  if Edit_GiveNO.Text = '' then
    ShowMessage('�ײͱ�Ų��ܿ�')
  else if Edit_Giveuplimit.Text = '' then
    ShowMessage('�ͷ�����ֵ���ܿ�')
  else if Edit_Givelowlimit.Text = '' then
    ShowMessage('�ͷ�����ֵ���ܿ�')
  else if Edit_Givelowlimit.Text < Edit_Givelowlimit.Text then
    ShowMessage('�ͷ�����ֵ����С������ֵ')

  else if GetmenberGivelimitvaluecomfir(strlowlimit) = '2' then
    ShowMessage('���������ֵ�ѱ���������������������ֵ')

  else if Edit_Givevalue.Text = '' then
    ShowMessage('�ͷֲ��ܿ�')
  else begin
    with ADOQuery_SetmenberGive do begin
      if (Locate('�ײͱ��', strlevel, [])) then begin
        if (MessageDlg('�Ѿ�����  ' + strlevel + '  Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else
        Append;
      FieldByName('�ײͱ��').AsString := strlevel;
      FieldByName('�ͷֳ�ֵ����').AsString := struplimit;
      FieldByName('�ͷֳ�ֵ����').AsString := strlowlimit;
      FieldByName('�ͻ���ֵ').AsString := strcore;
      FieldByName('����Ա').AsString := strOperator;
      FieldByName('��ע').AsString := strMemo_instruction;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
    ExitSub:

    Edit_GiveNO.Text := '';
    Edit_Giveuplimit.Text := '';
    Edit_Givelowlimit.Text := '';
    Edit_Givevalue.Text := '';
    Memo_Giveinstruction.Text := '';
  end;
end;

//�ж����ޡ�����ֵ�Ƿ����ص��ķ�Χ

function Tfrm_Fileinput_menberfor.GetmenberGivelimitvaluecomfir(vlowlimit: string): string;
var
  ADOQ: TADOQuery;
  strSQL: string;
  rtn: string;
begin
  rtn := '0';
  strSQL := 'select * from 3F_MenberGivecore where ([�ͷֳ�ֵ����]>''' + vlowlimit + ''') and ([�ͷֳ�ֵ����]<''' + vlowlimit + ''')';
  ADOQ := TADOQuery.Create(nil);

  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (RecordCount > 0) then
      rtn := '2';
    Close;
  end;
  FreeAndNil(ADOQ);

  Result := rtn;
end;

//���ּ�¼��˫������

procedure Tfrm_Fileinput_menberfor.DBGrid2DblClick(Sender: TObject);
begin
  Edit_GiveNO.Text := DBGrid2.DataSource.DataSet.FieldByName('�ײͱ��').AsString;
  Edit_Giveuplimit.Text := DBGrid2.DataSource.DataSet.FieldByName('�ͷֳ�ֵ����').AsString;
  Edit_Givelowlimit.Text := DBGrid2.DataSource.DataSet.FieldByName('�ͷֳ�ֵ����').AsString;
  Edit_Givevalue.Text := DBGrid2.DataSource.DataSet.FieldByName('�ͻ���ֵ').AsString;
  Memo_Giveinstruction.Text := DBGrid2.DataSource.DataSet.FieldByName('��ע').AsString;

  Bit_Update_Give.Enabled := True;
end;

//�����ײͼ�¼�޸�

procedure Tfrm_Fileinput_menberfor.Bit_Update_GiveClick(Sender: TObject);
var
  strcore, strlevel, strlevelname, strMemo_instruction, strOperator, struplimit, strlowlimit: string;
begin
  if ((Length(strlevel) > 0) and (Length(strlevelname) > 0) and (Length(strcore) > 0)) then begin
      // ShowMessage('�ȼ����Ʋ��ܿ�');
    Exit;
  end;
  strcore := Edit_Givevalue.Text;
  strlevel := Edit_GiveNO.Text;
  struplimit := Edit_Giveuplimit.Text;
  strlowlimit := Edit_Givelowlimit.Text;
  strOperator := G_User.UserNO;
  strMemo_instruction := Memo_Giveinstruction.Text;
  with ADOQuery_SetmenberGive do begin
    if (not Locate('�ײͱ��', strlevel, [])) then
      Exit;
    Edit;
    FieldByName('�ײͱ��').AsString := strlevel;
    FieldByName('�ͷֳ�ֵ����').AsString := struplimit;
    FieldByName('�ͷֳ�ֵ����').AsString := strlowlimit;
    FieldByName('�ͻ���ֵ').AsString := strcore;
    FieldByName('����Ա').AsString := strOperator;
    FieldByName('��ע').AsString := strMemo_instruction;
    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
  end;

  Edit_GiveNO.Text := '';
  Edit_Giveuplimit.Text := '';
  Edit_Givelowlimit.Text := '';
  Edit_Givevalue.Text := '';
  Memo_Giveinstruction.Text := '';
  Bit_Update_Give.Enabled := False;
end;

procedure Tfrm_Fileinput_menberfor.Bit_Delete_GiveClick(Sender: TObject);
var
  strTemp: string;
begin
  strTemp := ADOQuery_SetmenberGive.FieldByName('�ײͱ��').AsString;
  if (MessageDlg('ȷʵҪɾ�� �ײͱ��Ϊ' + strTemp + ' ����ؼ�¼��?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    DBGrid2.DataSource.DataSet.Delete;
end;



//���ӽ��ջ�ײ�

procedure Tfrm_Fileinput_menberfor.Bit_Add_FestpackClick(Sender: TObject);
var
  strcore, strlevel, strlevelname, strMemo_instruction, strOperator: string;
  strIsUse: Boolean;
label ExitSub;
begin
  strcore := Edit_FestNo.Text;
  strlevel := Edit_FestName.Text;
//  strlevelname:=Edit_cUserNo.Text;
  strOperator := G_User.UserNO;
  strMemo_instruction := Memo_Remark.Text;

  if rg_IsUse.ItemIndex = 0 then
    strIsUse := true
  else
    strIsUse := false;

  if Edit_FestNo.Text = '' then
  begin
    ShowMessage('�ײͱ�Ų��ܿ�');
    exit;
  end
  else if Edit_FestName.Text = '' then
  begin
    ShowMessage('�ײ����Ʋ��ܿ�');
    exit;
  end
  else begin
    with ADOQuery_Festpack do begin
      if (Locate('FestNo', strcore, [])) then begin
        if (MessageDlg('�Ѿ�����  ' + strcore + '  Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else if (Locate('FestName', strlevel, [])) then begin
        if (MessageDlg('�Ѿ�����  ' + strlevel + '  Ҫ������', mtInformation, [mbYes, mbNo], 0) = mrYes) then
          Edit
        else
          goto ExitSub;
      end
      else
        Append;
      FieldByName('FestNo').AsString := strcore;
      FieldByName('FestName').AsString := strlevel;
      FieldByName('IsUse').AsBoolean := strIsUse;
      FieldByName('cUserNo').AsString := strOperator;
      FieldByName('Remark').AsString := strMemo_instruction;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
    ExitSub:
    Edit_FestNo.Text := '';
    Edit_FestName.Text := '';
    Memo_Remark.Text := '';
  end;

end;

procedure Tfrm_Fileinput_menberfor.DBGrid_FestpackDblClick(
  Sender: TObject);
begin
  Edit_FestNo.Text := DBGrid_Festpack.DataSource.DataSet.FieldByName('FestNo').AsString;
  Edit_FestName.Text := DBGrid_Festpack.DataSource.DataSet.FieldByName('FestName').AsString;
  Edit_cUserNo.Text := DBGrid_Festpack.DataSource.DataSet.FieldByName('cUserNo').AsString;

  if DBGrid_Festpack.DataSource.DataSet.FieldByName('IsUse').AsBoolean = true then
    rg_IsUse.ItemIndex := 0
  else
    rg_IsUse.ItemIndex := 1;

  Memo_Remark.Text := DBGrid_Festpack.DataSource.DataSet.FieldByName('Remark').AsString;

  Bit_Update_Festpack.Enabled := True;
end;

procedure Tfrm_Fileinput_menberfor.Bit_Update_FestpackClick(
  Sender: TObject);

var strcore, strlevel, strlevelname, strMemo_instruction, strOperator: string;
  strIsUse: Boolean;
begin

  strcore := Edit_FestNo.Text;
  strlevel := Edit_FestName.Text;
//  strlevelname:=Edit_cUserNo.Text;
  strOperator := G_User.UserNO;
  strMemo_instruction := Memo_Remark.Text;

  if rg_IsUse.ItemIndex = 0 then
    strIsUse := true
  else
    strIsUse := false;

  if Edit_FestNo.Text = '' then
  begin
    ShowMessage('�ײͱ�Ų��ܿ�');
    exit;
  end
  else if Edit_FestName.Text = '' then
  begin
    ShowMessage('�ײ����Ʋ��ܿ�');
    exit;
  end
  else begin
    with ADOQuery_Festpack do begin
      if (not Locate('FestNo', strcore, [])) then begin
        exit;
      end
      else
        Edit;
      FieldByName('FestNo').AsString := strcore;
      FieldByName('FestName').AsString := strlevel;
      FieldByName('IsUse').AsBoolean := strIsUse;
      FieldByName('cUserNo').AsString := strOperator;
      FieldByName('Remark').AsString := strMemo_instruction;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;
    Edit_FestNo.Text := '';
    Edit_FestName.Text := '';
    Memo_Remark.Text := '';
    Edit_cUserNo.Text := '';
    Bit_Update_Festpack.Enabled := false;

  end;
end;

procedure Tfrm_Fileinput_menberfor.Bit__Del_FestpackClick(Sender: TObject);
var
  strTemp: string;
begin
  strTemp := ADOQuery_Festpack.FieldByName('FestNo').AsString;
  if (MessageDlg('ȷʵҪɾ�� ����Ϊ' + strTemp + ' ����ؼ�¼��?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    DBGrid_Festpack.DataSource.DataSet.Delete;
end;

procedure Tfrm_Fileinput_menberfor.Bit_Close_FestpackClick(
  Sender: TObject);
begin
  close;
end;

end.