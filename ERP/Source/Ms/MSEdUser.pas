unit MSEdUser;
{******************************************
��Ŀ��
ģ�飺�û��༭
���ڣ�2002��11��1��
���ߣ��ز�ΰ
���£�
******************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSStandardEdit, StdCtrls, ExtCtrls,CommonDm, DB, ADODB,WSUtils,MSEdUserAddTerm,
  DBCtrls;

type
  TMSEdUserForm = class(TWSStandardEditForm)
    edtName: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtPasswordAgain: TLabeledEdit;
    btnAdd: TButton;
    lbTerm: TListBox;
    Label1: TLabel;
    btnDelete: TButton;
    adsUser: TADODataSet;
    dsUser: TDataSource;
    adrUser: TADOQuery;
    dsEmployee: TDataSource;
    dblcEmployee: TDBLookupComboBox;
    Label2: TLabel;
    adsEmployee: TADODataSet;
    adsEmployeeID: TAutoIncField;
    adsEmployeeCreateDate: TDateTimeField;
    adsEmployeeCreateUserID: TIntegerField;
    adsEmployeeRecordState: TStringField;
    adsEmployeeName: TStringField;
    adsEmployeeCode: TStringField;
    adsEmployeeGender: TStringField;
    adsEmployeeDepartmentID: TIntegerField;
    adsEmployeePositionClassID: TIntegerField;
    adsEmployeePostionID: TIntegerField;
    procedure OKButtonClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure adsEmployeeBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
  private
    nOptionType: integer; //�������ͣ�0:���� 1:�༭��
    vID:string;
    { Private declarations }
  public
    { Public declarations }
    function Enter: Boolean; override;
    function Edit(const Params: Variant): Boolean; override;
  end;

var
  MSEdUserForm: TMSEdUserForm;

implementation

{$R *.dfm}

function TMSEdUserForm.Edit(const Params: Variant): Boolean;
begin
  vID := Format('%s', [VarToStr(Params)]);
  nOptionType:=1;
  edtPassword.Enabled := False;
  edtPasswordAgain.Enabled := edtPassword.Enabled;
  with adrUser do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from MSRole where id='''+vID+'''');
    Open;
    edtName.Text := FieldByName('name').AsString;
    Close;
    SQL.Clear;
    SQL.Add('select name from MSRole where ID in (select UserTermId from MSUserTeamUsers where UserId='+vId+') and RecordState<>''ɾ��''');
    Open;
    First;
    while not eof do
    begin
      lbTerm.Items.Add(FieldByName('Name').AsString);
      Next;
    end;
  end;
//  dblcEmployee.Text := 'aaa';
//  adrUser.Open;
  Result := ShowModal = mrOK;
end;

function TMSEdUserForm.Enter: Boolean;
begin
  nOptionType := 0;
  Result := ShowModal = mrOK;
end;

procedure TMSEdUserForm.OKButtonClick(Sender: TObject);
var
  nID,i:Integer;
begin
  inherited;
  if edtName.Text='' then
  begin
    MessageBox(Handle,'���Ʋ���Ϊ�գ����������룡','����',MB_OK+MB_ICONERROR+MB_DEFBUTTON1);
    edtPassword.SetFocus;
    exit;
  end;
  if edtPassword.Text<>edtPasswordAgain.Text then
  begin
    MessageBox(Handle,'�����������벻һ�£����������룡','����',MB_OK+MB_ICONERROR+MB_DEFBUTTON1);
    edtPassword.SetFocus;
    exit;
  end;
  case nOptionType of
    0:  //  ���ӣ�
    begin
      with adsUser do
      begin
        CommandText := 'select * from MSRole where (name='''+edtName.Text+''') and (IsUserTerm=0) and (RecordState<>''ɾ��'')';
        open;
        if not IsEmpty then
        begin
          ShowMessage('���ݿ����Ѿ�����ͬ���Ƶ��û��������ٴ����룡');
          edtName.SetFocus;
          Close;
          exit;
        end;
      end;
      with adrUser do
      begin
        Close;
        SQL.Clear;
//        SQL.Add('delete MSRole where (name='''+edtName.Text+''')');
        SQL.Add('insert into MSRole(createUserID,name,IsUserTerm,Memo) values(1,'''
            +edtName.Text+''',0,''��������'')');
        ExecSQL;
        Close;
        SQL.Clear;
        SQL.Text :='select id from MSRole where name='''+edtName.Text+''' and IsUserTerm=0 and RecordState<>''ɾ��''';
        Open;
        nId :=adrUser.FieldValues['id'];
        Close;
        SQL.Clear;
        SQL.Add('insert into MSUser(RoleID,CreateUserID,EmployeeID,PassWord,IsUsed) values('
            +IntToStr(nID)+',0,'+adsEmployee.FieldByName('ID').AsString+','+IntToStr(GetPassword(edtPassword.Text))+',''1'')');
        ExecSQL;
        Close;
        if lbTerm.Items.Count>0 then
        begin
          SQL.Clear;
          for i := 0 to lbTerm.Items.Count-1 do
          begin
            with adsUser do
            begin
              Close;
              CommandText := 'select ID from MSRole where name='''
                  +lbTerm.Items.Strings[i]+''' and IsUserTerm=1 and RecordState<>''ɾ��''';
              Open;
            end;
            SQL.Add('insert into MSUserTeamUsers(UserTermID,UserID) Values('+adsUser.FieldByName('ID').AsString+','+IntToStr(nID)+')');
          end;
          ExecSQL;
        end;
      end;
    end;
    1:  // �༭��
    begin
      with adrUser do
      begin
        Close;
        SQL.Clear;
        SQL.Add('update MSRole set createUserID=1,name='''+edtName.Text+''',IsUserTerm=0,Memo=''��������'' where id='''+vID+'''');
        ExecSQL;
        Close;
        SQL.Clear;
        SQL.Text :='select id from MSRole where name='''+edtName.Text+''' and IsUserTerm=0';
        Open;
        nId :=adrUser.FieldValues['id'];
        Close;
        SQL.Clear;
//        SQL.Add('update MSUser set PassWord='+IntToStr(GetPassword(edtPassword.Text))+',IsUsed=''1'' where RoleID='+IntToStr(nID));
        SQL.Add('update MSUser set EmployeeID='+adsEmployee.FieldByName('ID').AsString+',IsUsed=''1'' where RoleID='+IntToStr(nID));
        ExecSQL;
        SQL.Clear;
        SQL.Add('delete MSUserTeamUsers where UserID='+vID);
        if lbTerm.Items.Count>0 then
        begin
          for i := 0 to lbTerm.Items.Count-1 do
          begin
            with adsUser do
            begin
              Close;
              CommandText := 'select ID from MSRole where name='''
                  +lbTerm.Items.Strings[i]+''' and IsUserTerm=1 and RecordState<>''ɾ��''';
              Open;
            end;
            SQL.Add('insert into MSUserTeamUsers(UserTermID,UserID) Values('+adsUser.FieldByName('ID').AsString+','+vID+')');
          end;
        end;
        ExecSQL;
      end;
    end;
  end;
  ModalResult := mrOK;
end;

procedure TMSEdUserForm.btnAddClick(Sender: TObject);
var
  lTerm : TStringList;
begin
  inherited;
  lTerm:=TStringList.Create();
  lTerm.AddStrings(lbTerm.Items);
  lTerm:=UserAddTerm(lTerm,vID);
  if lTerm <> nil then
  begin
    lbTerm.Clear;
    lbTerm.Items.AddStrings(lTerm);
  end;
end;

procedure TMSEdUserForm.btnDeleteClick(Sender: TObject);
var
  nIndex: integer;
begin
  inherited;
  if lbTerm.Items.Count=0 then
  begin
    showmessage('û�����ɾ.');
    exit;
  end;
  nIndex := lbTerm.ItemIndex;
  if nIndex<0 then
  begin
    lbTerm.Selected[0]:=True;
    exit;
  end
  else
  begin
    lbTerm.DeleteSelected;
    nIndex := nIndex - 1;
    if nIndex <0 then nIndex := 0;
  end;
  if lbTerm.Items.Count<=0 then exit;
  lbTerm.Selected[nIndex] := True;
end;

procedure TMSEdUserForm.adsEmployeeBeforeOpen(DataSet: TDataSet);
begin
  inherited;
//  showmessage(adsEmployee.CommandText);
end;

procedure TMSEdUserForm.FormShow(Sender: TObject);
begin
  inherited;
  adsEmployee.Close;
  adsEmployee.CommandText := 'SELECT * FROM MSEmployee WHERE RecordState<>'
    +Quotedstr('ɾ��')
    + ' AND NOT ID IN (SELECT EmployeeID FROM MSUser WHERE '
    +' RecordState<>'+Quotedstr('ɾ��')+' )';
  adsEmployee.Open;
end;

end.
