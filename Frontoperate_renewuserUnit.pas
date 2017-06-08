unit Frontoperate_renewuserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DB, ADODB, SPComm;

type
  Tfrm_Frontoperate_renewuser = class(TForm)
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    DataSource_renewmenber: TDataSource;
    ADOQuery_renewmenber: TADOQuery;
    comReader: TComm;
    DataSource1: TDataSource;
    ADOQuery_renewmenberrecord: TADOQuery;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    Label8: TLabel;
    Label16: TLabel;
    Edit_newID: TEdit;
    Bitn_ReadNewID: TBitBtn;
    Edit_Prepasswordnew: TEdit;
    Edit_PrintNONew: TEdit;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label5: TLabel;
    Edit_Certify: TEdit;
    Edit_SaveMoney: TEdit;
    Edit_PrintNO: TEdit;
    Edit_ID: TEdit;
    Edit_Username: TEdit;
    rgSexOrg: TRadioGroup;
    Edit_Mobile: TEdit;
    Comb_menberlevel: TComboBox;
    Edit_HaveMoney: TEdit;
    Edit_UserNo: TEdit;
    Edit_Prepassword: TEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Comb_querytype: TComboBox;
    Edit_querycontent: TEdit;
    Bit_Query: TBitBtn;
    Bit_Close: TBitBtn;
    Image1: TImage;
    Bit_Update: TBitBtn;
    procedure comReaderReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bitn_ReadNewIDClick(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Bit_UpdateClick(Sender: TObject);
    procedure Bit_QueryClick(Sender: TObject);
  private
    { Private declarations }
    function exchData(orderStr: string): string;
    procedure sendData();
    procedure checkOper();
    procedure InitDataBase;
    procedure Saveinto3F_Menberrenewuser;
    procedure Getmenberinfo(S1, S2: string);
  public
    { Public declarations }
  end;

var
  frm_Frontoperate_renewuser: Tfrm_Frontoperate_renewuser;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  orderLst, recDataLst: Tstrings;
  buffer: array[0..2048] of byte;
implementation
uses ICDataModule, ICtest_Main, ICCommunalVarUnit, ICmain, ICEventTypeUnit;
{$R *.dfm}


procedure Tfrm_Frontoperate_renewuser.InitDataBase;
var
  strSQL: string;
begin
  with ADOQuery_renewmenber do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_Menber]';
    SQL.Add(strSQL);
    Active := True;
  end;


  with ADOQuery_renewmenberrecord do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select * from [3F_Menberrenewuser]';
    SQL.Add(strSQL);
    Active := True;
  end;

end;


//ת�ҷ������ݸ�ʽ

function Tfrm_Frontoperate_renewuser.exchData(orderStr: string): string;
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

procedure Tfrm_Frontoperate_renewuser.sendData();
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

procedure Tfrm_Frontoperate_renewuser.checkOper();
var
  i: integer;
  tmpStr: string;
begin
  case curOperNo of
    0: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                      //  memComSet.Lines.Add('����������ʧ��');
                      //  memComSet.Lines.Add('');
            exit;
          end;
              //  memComSet.Lines.Add('����������ɹ�');
              //  memComSet.Lines.Add('');
      end;
    1: begin
             //   memLowRe.Lines.Add('����: Ѱ��');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                //    memLowRe.Lines.Add('���: Ѱ��ʧ��')
        else begin
                  //  memLowRe.Lines.Add('���: Ѱ���ɹ�');
          if copy(recDataLst.Strings[0], 5, 2) = '04' then
                   //     memLowRe.Lines.Add('�ÿ�ƬΪMifare one')
          else
                   //     memLowRe.Lines.Add('�ÿ�ƬΪ��������');
        end;
              //  memLowRe.Lines.Add('');
      end;
    2: begin
                //memLowRe.Lines.Add('����: ����ͻ');
                //  AND (copy(recDataLst.Strings[0],23,2)='4A')
        if (copy(recDataLst.Strings[0], 9, 2) = 'A8') and (copy(recDataLst.Strings[0], 23, 2) = '4A') then
        begin
          tmpStr := copy(recDataLst.Strings[0], 13, 8);
          Edit_newID.Text := tmpStr;
                 //   Getmenberinfo(tmpStr);
          Edit_PrintNONew.Enabled := True;
          Edit_Prepasswordnew.Enabled := True;
          Bit_Update.Enabled := True; //������º�ļ�¼
                   // memLowRe.Lines.Add('���: ����ͻʧ��')
        end
        else begin
                  //  memLowRe.Lines.Add('���: ����ͻ�ɹ�');
          tmpStr := recDataLst.Strings[0];
          tmpStr := copy(tmpStr, 5, length(tmpStr) - 4);
                   // memLowRe.Lines.Add('���: '+tmpStr);
        end;
                 // memLowRe.Lines.Add('');

      end;
    3: begin
               // memLowRe.Lines.Add('����: ѡ��');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                  //  memLowRe.Lines.Add('���: ѡ��ʧ��')
        else
                   // memLowRe.Lines.Add('���: ѡ��ɹ�');
             //   memLowRe.Lines.Add('');
      end;
    4: begin
               // memLowRe.Lines.Add('����: ��ֹ');
        if copy(recDataLst.Strings[0], 3, 2) <> '00' then
                 //   memLowRe.Lines.Add('���: ��ֹʧ��')
        else
                  //  memLowRe.Lines.Add('���: ��ֹ�ɹ�');
                //memLowRe.Lines.Add('');
      end;
    5: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��������ʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '�������سɹ�', '�ɹ�', MB_OK);
      end;
    6: begin
        for i := 0 to 3 do
        begin
          if copy(recDataLst.Strings[i + 4], 3, 2) <> '00' then
          begin
                      //  gbRWSector.Caption:=cbRWSec.Text+'��ȡʧ��';
            exit;
          end;
        end;
             //   edtBlock0.Text:=copy(recDataLst.Strings[4],5,32);
             //   edtBlock1.Text:=copy(recDataLst.Strings[5],5,32);
            //    edtBlock2.Text:=copy(recDataLst.Strings[6],5,32);
             //   edtBlock3.Text:=copy(recDataLst.Strings[7],5,32);
             //   gbRWSector.Caption:=cbRWSec.Text+'��ȡ�ɹ�';
      end;
    7: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                  //      gbRWSector.Caption:=cbRWSec.Text+'д��ʧ��';
            exit;
          end;
               // gbRWSector.Caption:=cbRWSec.Text+'д��ɹ�';
      end;
    8: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
                   //     MessageBox(handle,'��ֵ��ʼ��ʧ��','ʧ��',MB_OK);
            exit;
          end;
        MessageBox(handle, '��ֵ��ʼ���ɹ�', '�ɹ�', MB_OK);
      end;
    9: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��ֵ��ȡʧ��', 'ʧ��', MB_OK);
            exit;
          end;
               // edtCurValue.Text:=copy(recDataLst.Strings[4],5,8);
        MessageBox(handle, '��ֵ��ȡ�ɹ�', '�ɹ�', MB_OK);
      end;
    10: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��ֵ��ֵʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '��ֵ��ֵ�ɹ�', '�ɹ�', MB_OK);
      end;
    11: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '��ֵ��ֵʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '��ֵ��ֵ�ɹ�', '�ɹ�', MB_OK);
      end;
    12: begin
        for i := 0 to recDataLst.Count - 1 do
          if copy(recDataLst.Strings[i], 3, 2) <> '00' then
          begin
            MessageBox(handle, '�����޸�ʧ��', 'ʧ��', MB_OK);
            exit;
          end;
        MessageBox(handle, '�����޸ĳɹ�', '�ɹ�', MB_OK);
      end;
  end;
end;

procedure Tfrm_Frontoperate_renewuser.comReaderReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  ii: integer;
  recStr: string;
  tmpStr: string;
begin
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for ii := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[ii]), 2);
  end;
  //  memComSeRe.Lines.Add('<<== '+recStr);
  recDataLst.Add(recStr);
  if curOrderNo < orderLst.Count then
    sendData()
  else begin
    checkOper();
       // memComSeRe.Lines.Append('');
  end;
end;

procedure Tfrm_Frontoperate_renewuser.FormShow(Sender: TObject);
begin
     //   Initmenberlevel;
     //EventObj:=EventUnitObj.Create;
     //EventObj.LoadEventIni;
 // InitStringGrid;
 // InitWorkParam;                          //��ʼ��PLC�¼��������
  InitDataBase; //��ʾ���ͺ�
 // InitEdit;                               //���Edit��
 // InitDuanXH;                             //��ʼ���ͺ�Combox_Type_JH
 // PageControl_Set.ActivePageIndex:=0;
 // InitUser;
  comReader.StartComm();
  orderLst := TStringList.Create;
  recDataLst := tStringList.Create;
end;

procedure Tfrm_Frontoperate_renewuser.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  orderLst.Free();
  recDataLst.Free();
  comReader.StopComm();
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;

end;
//��ѯ�¿���ID

procedure Tfrm_Frontoperate_renewuser.Bitn_ReadNewIDClick(Sender: TObject);
begin
  orderLst.Clear();
  recDataLst.Clear();
  curOrderNo := 0;
  curOperNo := 2;
    //orderLst.Add('0103');
    //orderLst.Add('020B0F');
  orderLst.Add('AA8A5F5FA801004A');
  sendData();
end;

  //���ݲ�ѯѡ��Ĳ�ͬ��ѯ��ʽ����ѯ������Ϣ��Ϊ����������׼��S1��ѯ���ͣ�S2Ϊ��ѯ����

procedure Tfrm_Frontoperate_renewuser.Getmenberinfo(S1, S2: string);
var
  ADOQ: TADOQuery;
  strSQL: string;
  strsexOrg: string;

begin
  if S1 = '�����û����' then
    strSQL := 'select ӡˢ����,�û����,�û�����,�Ա�����,����֤��,�û�����,Ԥ������,��Ѻ��,�ֻ�����,��ID,�˻���� from 3F_Menber where [�û����]=''' + S2 + ''''
  else if S1 = '�����û��ֻ���' then
    strSQL := 'select ӡˢ����,�û����,�û�����,�Ա�����,����֤��,�û�����,Ԥ������,��Ѻ��,�ֻ�����,��ID,�˻���� from 3F_Menber where [�ֻ�����]=''' + S2 + ''''
  else if S1 = '�����û�����֤' then
    strSQL := 'select ӡˢ����,�û����,�û�����,�Ա�����,����֤��,�û�����,Ԥ������,��Ѻ��,�ֻ�����,��ID,�˻���� from 3F_Menber where [����֤��]=''' + S2 + ''''
  else
    exit;

  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    if (not eof) then begin
      Edit_PrintNO.Text := ADOQ.Fields[0].AsString; //ӡˢ����
      Edit_UserNo.Text := ADOQ.Fields[1].AsString; //�û����
      Edit_Username.Text := ADOQ.Fields[2].AsString; // �û�����
      strsexOrg := ADOQ.Fields[3].AsString; //�Ա�����
      if strsexOrg = '��' then
        rgSexOrg.ItemIndex := 0
      else
        rgSexOrg.ItemIndex := 1;

      Edit_Certify.Text := ADOQ.Fields[4].AsString; //����֤��
      Comb_menberlevel.Text := ADOQ.Fields[5].AsString; //�û�����
      Edit_Prepassword.Text := ADOQ.Fields[6].AsString; //Ԥ������
      Edit_SaveMoney.Text := ADOQ.Fields[7].AsString; //��Ѻ��
      Edit_Mobile.Text := ADOQ.Fields[8].AsString; //�ֻ�����
      Edit_ID.Text := ADOQ.Fields[9].AsString; //ԭ��ID
      Edit_HaveMoney.Text := ADOQ.Fields[10].AsString; //�˻����
      Bitn_ReadNewID.Enabled := True; //�������ж�������
      Close;
    end
    else
      ShowMessage('�޴��û�');
  end;

  FreeAndNil(ADOQ);

 // Result:=strRet;
end;


procedure Tfrm_Frontoperate_renewuser.Bit_CloseClick(Sender: TObject);
begin
  Close;
end;


//���ݻ�õ��¿�ID��ǰ���ѯ�ĸ�����Ϣ������ϵͳ�����IDֵ

procedure Tfrm_Frontoperate_renewuser.Bit_UpdateClick(Sender: TObject);
var
  strPrintNONew, strNewID, strlevel, strPrepasswordnew: string;
begin
  strlevel := Edit_UserNo.Text; //�û����
  strNewID := Edit_newID.Text; //�¿�ID
  strPrepasswordnew := Edit_Prepasswordnew.Text; //�¿�Ԥ������

  if Edit_PrintNONew.Text = '' then
    ShowMessage('�ͻ�����ȷ�������������������')
  else begin
    strPrintNONew := Edit_PrintNONew.Text; //�¿�ӡˢ����

    with ADOQuery_renewmenber do begin
      if (not Locate('�û����', strlevel, [])) then
        Exit;
      Edit;
      FieldByName('��ID').AsString := strNewID;
      FieldByName('��״̬').AsString := '����';
      FieldByName('ӡˢ����').AsString := strPrintNONew;
      if Edit_Prepasswordnew.Text <> '' then
        FieldByName('Ԥ������').AsString := Edit_Prepasswordnew.Text;
      try
        Post;
      except
        on e: Exception do ShowMessage(e.Message);
      end;
    end;


    Saveinto3F_Menberrenewuser; //���ñ��油����¼
    Bit_Update.Enabled := False;
    Edit_PrintNONew.Enabled := False;
    Edit_Prepasswordnew.Enabled := False;
  end;
end;

//����������¼д�� 3F_Menberrenewuser

procedure Tfrm_Frontoperate_renewuser.Saveinto3F_Menberrenewuser;

var
  strUserNo, strOldID, strNewID, strOperator, strinputdatetime: string;
  i: integer;
 // label ExitSub;
begin

  strUserNo := Edit_UserNo.Text; //�û����
  strNewID := Edit_newID.Text; //�¿�ID
  strOldID := Edit_ID.Text; //�ɿ�ID
  strOperator := G_User.UserNO; //����Ա
  strinputdatetime := DateTimetostr((now())); //¼��ʱ�䣬��ȡϵͳʱ��

  with ADOQuery_renewmenberrecord do begin
    Append;
    FieldByName('�û����').AsString := strUserNo;
    FieldByName('����Ա').AsString := strOperator;
    FieldByName('ԭ��ID').AsString := strOldID;
    FieldByName('�ֿ�ID').AsString := strNewID;
    FieldByName('����ʱ��').AsString := strinputdatetime;
        //  FieldByName('��������').AsString :=FloatToStr(1+StrToFloat(FieldByName('��������').AsString));;

    try
      Post;
    except
      on e: Exception do ShowMessage(e.Message);
    end;
    //     ExitSub:
   //��������
    for i := 0 to ComponentCount - 1 do
    begin
      if components[i] is TEdit then
      begin
        (components[i] as TEdit).Clear;
      end
    end;
  end;
end;






//��ѯ������Ա�Ļ�������

procedure Tfrm_Frontoperate_renewuser.Bit_QueryClick(Sender: TObject);
var
  strquerycontent, strquerytype: string;

begin
  strquerytype := Comb_querytype.Text;
  strquerycontent := Edit_querycontent.Text;
  if Comb_querytype.Text = '' then
    ShowMessage('δѡ���ѯ��ʽ����ѡ��')
  else if Edit_querycontent.Text = '' then
    ShowMessage('δ��д��ѯ�����ݣ����ѯ��ʽ����')
  else
    Getmenberinfo(strquerytype, strquerycontent); //��ѯ��������

end;

end.