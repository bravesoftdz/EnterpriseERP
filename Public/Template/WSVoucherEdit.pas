{******************************************
ģ�飺���ݱ༭����
�������ڣ�2002��11��7��
���ߣ�Qiuliang
�����ߣ�����ƽ
******************************************}

unit WSVoucherEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ExtCtrls, DBCtrls, StdCtrls, Mask, Grids, DBGrids,
  QLDBGrid, ActnList, ToolWin, ComCtrls, ADODB, QLRptBld, QLDBFlt, Menus,
  QRExtra, QuickRpt, WSEdit, QLDBLkp;

type
  {1 TWSVoucherEditForm ������ҵ�񵥾ݱ༭����Ļ����� }
  {{
  }
  TWSVoucherEditForm = class(TWSEditForm)
    A1: TMenuItem;
    A2: TMenuItem;
    A3: TMenuItem;
    ActionList: TActionList;
    C1: TMenuItem;
    CloseAction: TAction;
    D1: TMenuItem;
    D2: TMenuItem;
    DateDBEdit: TDBEdit;
    DBGrid: TQLDBGrid;
    DeleteAction: TAction;
    DeleteDetailAction: TAction;
    DetailDataSource: TDataSource;
    EditMenuItem: TMenuItem;
    F1: TMenuItem;
    FileMenuItem: TMenuItem;
    FiltrateAction: TAction;
    FindAction: TAction;
    ImportAction: TAction;
    L1: TMenuItem;
    MainMenu: TMainMenu;
    MasterDataSource: TDataSource;
    N1: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    NewAction: TAction;
    NewDetailAction: TAction;
    NextAction: TAction;
    O1: TMenuItem;
    P1: TMenuItem;
    P2: TMenuItem;
    PageOptionsAction: TAction;
    PrintAction: TAction;
    PrintPreviewAction: TAction;
    PriorAction: TAction;
    RemarkDBEdit: TDBEdit;
    RemarkLabel: TLabel;
    S1: TMenuItem;
    SaveAction: TAction;
    SaveAsAction: TAction;
    SendAsMailAction: TAction;
    SubmitAction: TAction;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TopPanel: TPanel;
    U1: TMenuItem;
    V1: TMenuItem;
    ViewMenuItem: TMenuItem;
    VocherNoDBEdit: TDBEdit;
    VoucherDateLabel: TLabel;
    VoucherNoLabel: TLabel;
    StatusBar1: TStatusBar;
    GoodsLookup: TQLDBLookupComboBox;
    DetailsPopupMenu: TPopupMenu;
    AddNewDetailItem: TMenuItem;
    DeleteDetailItem: TMenuItem;
    WriteOffAction: TAction;
    VourcherExportAction: TAction;
    VourcherExportBttn: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    procedure CloseActionExecute(Sender: TObject);
    procedure DeleteActionExecute(Sender: TObject);
    procedure DeleteDetailActionExecute(Sender: TObject);
    procedure DeleteDetailActionUpdate(Sender: TObject);
    procedure FiltrateActionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NewActionExecute(Sender: TObject);
    procedure NewDetailActionExecute(Sender: TObject);
    procedure NextActionExecute(Sender: TObject);
    procedure PrintActionExecute(Sender: TObject);
    procedure PrintPreviewActionExecute(Sender: TObject);
    procedure PriorActionExecute(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure SendAsMailActionExecute(Sender: TObject);
    procedure SubmitActionExecute(Sender: TObject);
    procedure GoodsLookupButtonClick(Sender: TObject;
      Button: TLookupWindowBtn);
    procedure SaveAsActionExecute(Sender: TObject);
    procedure GoodsLookupCloseUp(Sender: TObject);
    procedure ImportActionExecute(Sender: TObject);
    procedure DBGridEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WriteOffActionExecute(Sender: TObject);
    procedure PageOptionsActionExecute(Sender: TObject);
    procedure VourcherExportActionExecute(Sender: TObject);
  private
    FFilterDialog: TQLDBFilterDialog;
    FOldDetailDataSetOnNewRecord: TDataSetNotifyEvent;
    FOldMasterDataSetAfterPost: TDataSetNotifyEvent; //����ƽ 2002-11-07

    FVoucherTableName: string;
    function CreateQRBuilder: TQRBuilder;
    procedure DetailDataSetNewRecord(DataSet: TDataSet);
    procedure MasterDataSetAfterPost(DataSet: TDataSet);//����ƽ 2002-11-07
    function GetNextVoucherID: Integer;
    function GetPriorVoucherID: Integer;
    function GetMailBody: string;
    procedure UpdateGrid;
  protected
    function CreateReport: TQuickRep; virtual;
    function GetDetailDataSet: TADODataSet; virtual;
    function GetMasterDataSet: TADODataSet; virtual;
    function GetModified: Boolean; virtual;
    {1 ���ص��ݵ� ID �ֶζ��� }
    {{
    GetVoucherIDField �� VoucherIDField ���� read ��ʵ�֡�

    ���Ը��� GetVoucherIDField �����ز�ͬ�� ID �ֶΡ�Ĭ������£��÷�������
    MasterDataSet �ĵ� 0 ���ֶΡ�
    }
    function GetVoucherIDField: TField; virtual;
    procedure InitReport(Report: TQuickRep); virtual;
    {1 ʵ��ȡ���������ĵĹ��� }
    {{
    ���� InternalCancel ������ʵ��ȡ���Ե�ǰ���������ĸ��ġ�

    Ҫȡ����������� Cancel ����Ҫֱ�ӵ��� InternalCancel ������Cancel
    ���������InternalCancel ��ʵ��������ȡ�����ܡ�
    }
    procedure InternalCancel; virtual;
    {1 ʵ�ֱ��浥�ݵĹ��� }
    {{
    ���� InternalSave ������ʵ�ֱ��湦�ܡ�

    Save ����������һ�����񣬲��ڸ������е��� InternalSave
    ���������ݡ�InternalSave �����е����и��Ķ�����Ϊһ�������ύ��ع���

    Ҫ������������ Save ����Ҫֱ�ӵ��� InternalSave ������Save
    ���������InternalSave ��ʵ�������ı��湦�ܡ�
    }
    procedure InternalSave; virtual;
    procedure Print(Preview: Boolean); virtual;
    function PromptSave: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Cancel;
    function Connection: TADOConnection;
    procedure Delete;
    function Edit(const Params: Variant): Boolean; override;
    function Enter: Boolean; override;
    {{
    ���� New ����һ���µ�ҵ�񵥾�
    }
    procedure New; virtual;
    procedure Open(VoucherID: Integer); virtual;
    procedure Save;
    property DetailDataSet: TADODataSet read GetDetailDataSet;
    property MasterDataSet: TADODataSet read GetMasterDataSet;
    {1 �жϵ�ǰ�����Ƿ��ѱ����� }
    property Modified: Boolean read GetModified;
    {1 ��õ�ǰ���ݵ� ID �ֶζ��� }
    {{
    �� VoucherIDField ��������ȡ��ǰ���ݵ� ID �ֶζ��󡣸�����ֻ����
    }
    property VoucherIDField: TField read GetVoucherIDField;
    {1 ָ�����������ݿ��еı��� }
    {{
    ���� VoucherTableName
    ������ָ����ǰ���༭�ĵ��������ݿ��еı�����ע�⣬�ñ��������� Master
    ��׺����ɹ������������ݿ����� SLOrderMaster, SLOrderDetail����
    VoucherTableName ӦΪ SLOrder��
    }
    property VoucherTableName: string read FVoucherTableName write
      FVoucherTableName;
  end;

implementation

uses WSVoucherRpt, WSConsts, ADOInt, CommonDM, QRExport,
  WSUtils, TypInfo, ShellAPI ,WSSecurity,VoucherImport,
  Registry;
//WSVoucherImport
{$R *.dfm}

{ TWSVoucherEditForm }

{1  }
{{
}
{1 ָ�����������ݿ��еı��� }
{{
}
{
****************************** TWSVoucherEditForm ******************************
}

constructor TWSVoucherEditForm.Create(AOwner: TComponent);
var
  Field: TField;
  GoodNameDataSet: TDataSet;
begin
  inherited;
  if Guarder.GoodsCodeToGoodsName<>'��' then   exit;

  GoodNameDataSet := TDataSet(FindComponent('GoodName'));
  if GoodNameDataSet <> nil then
  begin
    Field := TStringField.Create(Self);
    Field.FieldName := 'GoodsCode';
    Field.Lookup := True;
    Field.LookupDataSet := GoodNameDataSet;
    Field.KeyFields := 'GoodsID';
    Field.LookupKeyFields := 'ID';
    Field.LookupResultField := 'Code';
    Field.DataSet := DetailDataSet;
    Field.Size := 20;
    with DBGrid.Columns.Add do
    begin
      FieldName := 'GoodsCode';
      Title.Caption := '��Ʒ����';
      Title.Alignment := taCenter;
      Index := 0;
    end;


  end;

end;

procedure TWSVoucherEditForm.Cancel;
begin
  InternalCancel;
end;

procedure TWSVoucherEditForm.CloseActionExecute(Sender: TObject);
begin
  inherited;
  Close;
end;

function TWSVoucherEditForm.Connection: TADOConnection;
begin
  Result := MasterDataSet.Connection;
end;

function TWSVoucherEditForm.CreateQRBuilder: TQRBuilder;
var
  I: Integer;
begin
  Result := TQLDBGridReportBuilder.Create(Self);
  with TQLDBGridReportBuilder(Result) do
  begin
    DBGrid := Self.DBGrid;
    AutoWidth := True;
    Report := CreateReport;
    AutoOrientation := False;
    with Self.DBGrid do
      for I := 0 to Columns.Count - 1 do
      begin
        case Columns[I].Footer.ValueType of
          fvtSum: SummaryFields.Add(Format('%s=SUM([%s])', [Columns[I].FieldName, Columns[I].FieldName]));
          fvtCount: SummaryFields.Add(Format('%s=COUNT([%s])', [Columns[I].FieldName, Columns[I].FieldName]));
        end;
      end;
  end;
end;

function TWSVoucherEditForm.CreateReport: TQuickRep;
begin
  Result := TVoucherReport.Create(Self);
  TVoucherReport(Result).SetMasterDataSet(MasterDataSet);
end;

procedure TWSVoucherEditForm.Delete;
begin
//  with DetailDataSet do
//  begin
//    DisableControls;
//    try
//      First;
//      while not Eof do Delete;
//    finally
//      EnableControls;
//    end;
//  end;

  with MasterDataSet do
  begin
    if State = dsInsert then Cancel
    else begin
      Edit;
      FieldByName('RecordState').AsString := 'ɾ��';
      Post;
      Save;
    end;
  end;
  Close;
//  MasterDataSet.Delete;
end;

procedure TWSVoucherEditForm.DeleteActionExecute(Sender: TObject);
begin
  if MasterDataSet.FieldByName('RecordState').AsString ='�ύ'
    then begin
      showmessage('�����Ѿ��ύ,����ɾ��!');
      Exit;
    end;
  if Application.MessageBox(PChar(SConfirmDeleteVoucher), PChar(Caption), MB_ICONQUESTION or MB_YESNO) = IDYES then
  begin
    Delete;
    Close;
  end;
end;

procedure TWSVoucherEditForm.DeleteDetailActionExecute(Sender: TObject);
begin
  inherited;
  DetailDataSet.Delete;
end;

procedure TWSVoucherEditForm.DeleteDetailActionUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not DetailDataSet.IsEmpty;
end;

procedure TWSVoucherEditForm.DetailDataSetNewRecord(DataSet: TDataSet);
begin
  if not VoucherIDField.IsNull then
    DataSet.FieldByName('MasterID').Value := VoucherIDField.Value;
end;

procedure TWSVoucherEditForm.MasterDataSetAfterPost(DataSet: TDataSet);
//����ƽ 2002-11-07
var
  ID: Integer;
  Bm, OldIndexFieldNames: string;
begin
  ID := DataSet.FieldByName('ID').AsInteger;
  with DetailDataSet do
  begin
    if State in dsEditModes then Post;
    DisableControls;
    try
      Bm := Bookmark;
      OldIndexFieldNames := IndexFieldNames;
      IndexFieldNames := '';
      First;
      while not Eof do
      begin
        if FieldByName('MasterID').IsNull then
        begin
          Edit;
          FieldByName('MasterID').AsInteger := ID;
          Post;
        end;
        Next;
      end;
      IndexFieldNames := OldIndexFieldNames;
      Bookmark := Bm;
    finally
      EnableControls;
    end;
  end;
end;

function TWSVoucherEditForm.Edit(const Params: Variant): Boolean;
begin
  Open(Params);
  Result := ShowModal = mrOK;
end;

function TWSVoucherEditForm.Enter: Boolean;
begin
  New;
  Result := ShowModal = mrOK;
end;

procedure TWSVoucherEditForm.FiltrateActionExecute(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  if not Assigned(FFilterDialog) then
  begin
    FFilterDialog := TQLDBFilterDialog.Create(Self);
    FFilterDialog.DataSet := DetailDataSet;
    if FFilterDialog.DataSet <> nil then
      with FFilterDialog.DataSet do
        for I := 0 to DBGrid.Columns.Count - 1 do
          if DBGrid.Columns[I].Visible then S := S + DBGrid.Columns[I].Field.FieldName + ';';
    FFilterDialog.FilterFields := S;
  end;
  FFilterDialog.Execute;
end;

procedure TWSVoucherEditForm.FormCloseQuery(Sender: TObject; var CanClose:
  Boolean);
begin
  inherited;
  CanClose := PromptSave;
end;

function TWSVoucherEditForm.GetDetailDataSet: TADODataSet;
begin
  Result := TADODataSet(DetailDataSource.DataSet);
end;

function TWSVoucherEditForm.GetMasterDataSet: TADODataSet;
begin
  Result := TADODataSet(MasterDataSource.DataSet);
end;

function TWSVoucherEditForm.GetModified: Boolean;
begin
  Result := (Assigned(MasterDataSet) and (MasterDataSet.State in dsEditModes)) or
    (Assigned(DetailDataSet) and (DetailDataSet.State in dsEditModes));
  if not Result and Assigned(DetailDataSet) then
    with DetailDataSet.Recordset do
    begin
      Filter := AdFilterPendingRecords;
      try
        Result := RecordCount > 0;
      finally
        Filter := AdFilterNone;
      end;
    end;
end;

function TWSVoucherEditForm.GetNextVoucherID: Integer;
begin
  with TADOCommand.Create(nil) do
  try
    Connection := Self.Connection;
    CommandText := Format('SELECT :VoucherID = MIN(%s) FROM %sMaster WHERE %0:s > %2:d AND RecordState <> ''ɾ��''',
      [VoucherIDField.FieldName, VoucherTableName, VoucherIDField.AsInteger]);
    with Parameters[0] do
    begin
      Direction := pdOutput;
      DataType := ftInteger;
    end;
 //   showmessage(CommandText);
    Execute;
    if VarIsNull(Parameters[0].Value) then Result := -1
    else Result := Parameters[0].Value;
  finally
    Free;
  end;
end;

function TWSVoucherEditForm.GetPriorVoucherID: Integer;
begin
  with TADOCommand.Create(nil) do
  try
    Connection := Self.Connection;
    CommandText := Format('SELECT :VoucherID = MAX(%s) FROM %sMaster WHERE %0:s < %2:d AND RecordState <> ''ɾ��''',
      [VoucherIDField.FieldName, VoucherTableName, VoucherIDField.AsInteger]);
    with Parameters[0] do
    begin
      Direction := pdOutput;
      DataType := ftInteger;
    end;
 //   showmessage(CommandText);
    Execute;
    if VarIsNull(Parameters[0].Value) then Result := -1
    else Result := Parameters[0].Value;
  finally
    Free;
  end;
end;

function TWSVoucherEditForm.GetVoucherIDField: TField;
begin
  Result := MasterDataSet.Fields[0];
end;

procedure TWSVoucherEditForm.InitReport(Report: TQuickRep);
begin
  with TRegistry.Create do
  try
    OpenKey('Software\soft.NET\NiceERP\' + ClassName + '\PageOptions', True);
    Report.ReportTitle := ReadString('Title');
  finally
    Free;
  end;
  if Report.ReportTitle = '' then
    Report.ReportTitle := Self.Caption;
end;

procedure TWSVoucherEditForm.InternalCancel;
begin
  if Assigned(MasterDataSet) then
    with MasterDataSet do if State in dsEditModes then Cancel;
  if Assigned(DetailDataSet) then
    with DetailDataSet do CancelBatch;
end;

procedure TWSVoucherEditForm.InternalSave;
begin
  if Assigned(MasterDataSet) then
    with MasterDataSet do if State in dsEditModes then Post;
  if Assigned(DetailDataSet) then
    with DetailDataSet do UpdateBatch;
end;

procedure TWSVoucherEditForm.New;
begin
  with MasterDataSet do
  begin
    Close;
    Parameters.ParamByName(VoucherIDField.FieldName).Value := Null;
    Open;
    Append;
    FieldByName('Code').AsString := GetMaxCode('Code', VoucherTableName + 'Master', number);
  end;
  with DetailDataSet do
  begin
    Close;
    Parameters.ParamByName(VoucherIDField.FieldName).Value := Null;
    Open;
  end;
  //����ƽ 2002-11-07
  FOldMasterDataSetAfterPost:=MasterDataSet.AfterPost;
  MasterDataSet.AfterPost:=MasterDataSetAfterPost;
  UpdateGrid;
end;

procedure TWSVoucherEditForm.NewActionExecute(Sender: TObject);
begin
  inherited;
  if not PromptSave then Exit;
  New;
end;

procedure TWSVoucherEditForm.NewDetailActionExecute(Sender: TObject);
begin
  inherited;
  DetailDataSet.Append;
end;

procedure TWSVoucherEditForm.NextActionExecute(Sender: TObject);
var
  VoucherID: Integer;
begin
  inherited;
  if not PromptSave then Exit;
  Cancel;
  VoucherID := GetNextVoucherID;
  if VoucherID < 0 then Close
  else Open(VoucherID);
end;

procedure TWSVoucherEditForm.Open(VoucherID: Integer);
begin
  with MasterDataSet do
  begin
    Close;
    Parameters.ParamByName(VoucherIDField.FieldName).Value := VoucherID;
    Open;
  end;
  with DetailDataSet do
  begin
    Close;
    Parameters.ParamByName(VoucherIDField.FieldName).Value := VoucherID;
    Open;
    FOldDetailDataSetOnNewRecord := DetailDataSet.OnNewRecord;
    DetailDataSet.OnNewRecord := DetailDataSetNewRecord;
  end;
  UpdateGrid;
end;

procedure TWSVoucherEditForm.Print(Preview: Boolean);
begin
  with CreateQRBuilder do
  try
    Active := True;
    InitReport(TQuickRep(Report));
    Report.PrevFormStyle := fsStayOnTop;
    Report.PreviewInitialState := wsMaximized;
    if Preview then Report.Preview
    else Report.Print;
  finally
    Free;
  end;
end;

procedure TWSVoucherEditForm.PrintActionExecute(Sender: TObject);
begin
  inherited;
  Print(False);
end;

procedure TWSVoucherEditForm.PrintPreviewActionExecute(Sender: TObject);
begin
  inherited;
  Print(True);
end;

procedure TWSVoucherEditForm.PriorActionExecute(Sender: TObject);
var
  VoucherID: Integer;
begin
  inherited;
  if not PromptSave then Exit;
  Cancel;
  VoucherID := GetPriorVoucherID;
  if VoucherID < 0 then Close
  else Open(VoucherID);
end;

function TWSVoucherEditForm.PromptSave: Boolean;
begin
  Result := True;
  if Modified then
    case Application.MessageBox(PChar(SConfirmSaveVoucher), PChar(Caption),
      MB_ICONQUESTION or MB_YESNOCANCEL) of
      IDYES: Save;
      IDCANCEL: Result := False;
    end;
end;

procedure TWSVoucherEditForm.Save;
var
  InParentTrans: Boolean;
begin
  if (MasterDataSet.FieldByName('RecordState').AsString  = '�ύ') or
      (MasterDataSet.FieldByName('RecordState').AsString  = 'ע��') or
       (MasterDataSet.FieldByName('RecordState').AsString  = '����')  then
     raise Exception.Create('�����ύ�󣬲������޸�,��������,���ú��ֳ���!');
  InParentTrans := Connection.InTransaction;
  if not InParentTrans then Connection.BeginTrans;
  try
    InternalSave;
    if not InParentTrans then Connection.CommitTrans;
  except
    if not InParentTrans then Connection.RollbackTrans;
    raise;
  end;
end;

procedure TWSVoucherEditForm.SaveActionExecute(Sender: TObject);
begin
  inherited;
  Save;
end;

function TWSVoucherEditForm.GetMailBody: string;
var
  I,J: Integer;
  DF, DH, DR,TempStr,TempStr1: string;
  DS: TDataSource;
  Field: TField;
begin
  TempStr  :='          ';
  TempStr1 :='          ';
  with TopPanel do
    for I := 0 to ControlCount - 1 do
    begin
      if IsPublishedProp(Controls[I], 'DataField') then
      begin
        DF := GetStrProp(Controls[I], 'DataField');
        DS := TDataSource(GetObjectProp(Controls[I], 'DataSource'));
        if (DS <> nil) and (DS.DataSet <> nil) then
        begin
          Field := DS.DataSet.FindField(DF);
          if Field <> nil then
            Result := Result + '%0D%0A' + Field.DisplayLabel + ': ' + Field.DisplayText;
        end;
      end;
    end;
  for I := 0 to DBGrid.Columns.Count - 1 do
  begin
    j:=Length(trim(DBGrid.Columns[I].Title.Caption));
    if DH = '' then
      if j<10 then DH :=trim(DBGrid.Columns[I].Title.Caption)+copy(Tempstr1,j,10-j)
        else DH :=DBGrid.Columns[I].Title.Caption
    else
      if j<10 then DH := DH + '%09%09' + trim(DBGrid.Columns[I].Title.Caption)+copy(Tempstr1,j,10-j)
        else DH := DH + '%09%09' + DBGrid.Columns[I].Title.Caption;
  end;
  Result := Result + '%0D%0A%0D%0A' + DH;
  DetailDataSet.First;
  while not DetailDataSet.Eof do
  begin
    for I := 0 to DBGrid.Columns.Count-1  do
    begin
      j:=Length(trim(DBGrid.Columns[I].Field.DisplayText));
      if DR = '' then
      if j<10 then  DR :=trim(DBGrid.Columns[I].Field.DisplayText)+copy(Tempstr,J,10-J)
          else DR :=trim(DBGrid.Columns[I].Field.DisplayText)
      else
      if j<10 then  DR :=DR + '%09%09' +TRIM(DBGrid.Columns[I].Field.DisplayText)+copy(Tempstr,J,10-J)
          else DR :=DR + '%09%09' +DBGrid.Columns[I].Field.DisplayText;
    end;
    Result := Result + '%0D%0A' + DR;
    DetailDataSet.Next;
    DR := '';
  end;
//  with CreateQRBuilder do
//  try
//    Active := True;
//    InitReport(TQuickRep(Report));
//    FileName := GetTempFileName('WSVoucherMail');
//    ShowMessage(FileName);
//    Report.ExportToFilter(TQRCommaSeparatedFilter.Create(FileName));
//    AssignFile(F, FileName);
//    Reset(F);
//    FS := TFileStream.Create(FileName, fmOpenRead);
//    try
//      SetLength(Result, FS.Size + 1);
//      FS.Read(Result, FS.Size);
//    finally
//      FS.Free;
//    end;
//    ShowMessage(Result);
//  finally
//    Free;
//  end;
end;


procedure TWSVoucherEditForm.SendAsMailActionExecute(Sender: TObject);
begin
  inherited;
  ShellExecute(HWND_DESKTOP, 'OPEN', PChar('mailto:?subject='+caption+' -- ' +VocherNoDBEdit.Text + '&body=' + GetMailBody), nil, nil, SW_SHOW);
//  ShowMessage(GetMailBody);
end;

procedure TWSVoucherEditForm.SubmitActionExecute(Sender: TObject);
begin
  inherited;
  if (MasterDataSet.FieldByName('RecordState').AsString  = '�ύ') or
      (MasterDataSet.FieldByName('RecordState').AsString  = 'ע��') or
       (MasterDataSet.FieldByName('RecordState').AsString  = '����')  then
  begin
    showmessage('�����Ѿ��ύ,�����ظ�!') ;
    exit;
  end;
  if Modified and (Application.MessageBox('�ύ֮ǰ���ȱ��棬�Ƿ��������棿',
    PChar(Caption), MB_ICONQUESTION or MB_YESNO) = IDNO) then Exit;
  with MasterDataSet do
  begin
    Edit;
    FieldByName('RecordState').AsString := '�ύ';
    Post;
  end;
  Save;
end;

procedure TWSVoucherEditForm.UpdateGrid;
var  I: Integer;
begin
  with DBGrid do
  begin
    FooterRowCount := 0;
    Columns[0].Footer.ValueType := fvtStaticText;
    Columns[0].Footer.Value := '�ϼ�:';
    Columns[0].Footer.Alignment := taCenter;
    for I := 0 to Columns.Count -  1 do
      if Columns[I].Field is TNumericField then
      if Pos('Price',Columns[I].FieldName)<=0 then
        Columns[I].Footer.ValueType := fvtSum;
    {GoodsLookup.DataSource := DataSource;
    for I := 0 to Columns.Count - 1 do
    begin
      if Pos('GOOD', UpperCase(Columns[I].FieldName)) > 0 then
      begin
        GoodsLookup.DataField := Columns[I].FieldName;
        Columns[I].ControlType := ctCustomControl;
        Columns[I].CustomControl := GoodsLookup;
        Break;
      end;
    end;  }
    FooterRowCount := 1;
  end;
end;

procedure TWSVoucherEditForm.GoodsLookupButtonClick(Sender: TObject;
  Button: TLookupWindowBtn);
var
  F: TField;
begin
  inherited;
  with TQLDBLookupComboBox(Sender) do
  begin
    F := DataSource.DataSet.FieldByName(DataField);
    if F.Lookup then F := F.DataSet.FieldByName(F.KeyFields);
    case Button of
      lbNew:;
      lbEdit:;
      lbSetNull:
        begin
          F.DataSet.Edit;
          F.Clear;
          CloseUp(False);
        end;
    end;
  end;
end;

procedure TWSVoucherEditForm.SaveAsActionExecute(Sender: TObject);
var
  TempDS: TADODataSet;
  OldID, I: Integer;
  Field: TField;
begin
  inherited;
  OldID := VoucherIDField.AsInteger;
  if not PromptSave then Exit;
  DetailDataSet.DisableControls;
  try
    New;
    TempDS := TADODataSet.Create(Self);
    try
      TempDS.Connection := Connection;
      TempDS.CommandText := Format('SELECT * FROM %sMaster WHERE ID = %d',
        [VoucherTableName, OldID]);
      TempDS.Open;
      for I := 0 to MasterDataSet.FieldCount - 1 do
      begin
        Field := MasterDataSet.Fields[I];
        if  not (Field.Lookup or Field.Calculated or Field.ReadOnly)  and
          (Field <> VoucherIDField) and not SameText(Field.FieldName, 'Code') and
          not SameText(Field.FieldName, 'RecordState') and
          not SameText(Field.FieldName, 'CreateDate') and
          not SameText(Field.FieldName, 'CreateUserID') then
          Field.Value := TempDS.FieldByName(Field.FieldName).Value;
      end;
      TempDS.Close;
      TempDS.CommandText := Format('SELECT * FROM %sDetail WHERE MasterID = %d',
        [VoucherTableName, OldID]);
      TempDS.Open;
      while not TempDS.Eof do
      begin
        DetailDataSet.Append;
        for I := 0 to DetailDataSet.FieldCount - 1 do
        begin
          Field := DetailDataSet.Fields[I];
          if not (Field.Lookup or Field.Calculated or Field.ReadOnly) and
            not SameText(Field.FieldName, 'MasterID') then
            Field.Value := TempDS.FieldByName(Field.FieldName).Value;
        end;
        DetailDataSet.Post;
        TempDS.Next;
      end;
    finally
      TempDS.Free;
    end;
  finally
    DetailDataSet.EnableControls;
  end;
end;

//type TQLDBGridCracker = class(TQLDBGrid);

procedure TWSVoucherEditForm.GoodsLookupCloseUp(Sender: TObject);
begin
  inherited;
//  if DetailDataSet.State in dsEditModes then
end;

procedure TWSVoucherEditForm.ImportActionExecute(Sender: TObject);
var
  ID, I: Integer;
  Field: TField;
begin
  inherited;
//  FindShowForm(TWSVoucherImportForm,'');
//  ShowImportForm('','','');
//  Exit;
  with TVoucherImportForm.Create(Application) do
  try
    if ShowModal = mrOK then
    begin
      ID := adsMaster.FieldByName('ID').AsInteger;
      adsMaster.First;
      while not adsMaster.Eof do
      begin
        if adsMaster.FieldByName('ID').AsInteger = ID then
        begin
          DetailDataSet.Append;
          for I := 0 to adsMaster.FieldCount - 1 do
          begin
            Field := DetailDataSet.FindField(adsMaster.Fields[I].FieldName);
            if (Field <> nil) and not SameText(Field.FieldName, 'ID') then
              Field.Value := adsMaster.Fields[I].Value;
          end;
//          DetailDataSet.FieldByName(')
        end;
        adsMaster.Next;
      end;
    end;
  finally
    Free;
  end;
//  showmessage(' - '+STNameD+' - '+STID);

//  VoucherImport.TVoucherImportForm.c.free;
end;

procedure TWSVoucherEditForm.DBGridEnter(Sender: TObject);
var  I: Integer;
begin
  inherited;
//  if not DBGrid.Enabled then exit;
//  with DBGrid do
//  begin
//    if Columns.Count<=1 then exit;
//    FooterRowCount := 0;
//    Columns[0].Footer.ValueType := fvtStaticText;
//    Columns[0].Footer.Value := '�ϼ�:';
//    Columns[0].Footer.Alignment := taCenter;
//    for I := 0 to Columns.Count -  1 do
//      if Columns[I].Field is TNumericField then
//      if Pos('Price',Columns[I].FieldName)<=0 then
//        Columns[I].Footer.ValueType := fvtSum;
//    FooterRowCount := 1;
//  end;
end;

procedure TWSVoucherEditForm.FormActivate(Sender: TObject);
var  I: Integer;
  GoodsDataSet: TDataSet;
  GoodsDataSource: TDataSource;
//var  I: Integer;
begin
  if Guarder.GoodsCodeToGoodsName='��' then
  begin
    with DBGrid do
    begin
      GoodsLookup.DataSource := DataSource;
      for I := 0 to Columns.Count - 1 do
      begin
        if SameText(Columns[I].FieldName, 'GoodsCode') then
        begin
          GoodsDataSet := TDataSet(Self.FindComponent('GoodName'));
          if GoodsDataSet <> nil then
          begin
            GoodsDataSource := TDataSource.Create(Self);
            GoodsDataSource.DataSet := GoodsDataSet;
            GoodsLookup.ListSource := GoodsDataSource;
          end;
          GoodsLookup.DataField := 'GoodsID';
          GoodsLookup.ListField := 'Code;Name';
          GoodsLookup.KeyField := 'ID';
          GoodsLookup.DropDownWidth :=300;
          Columns[I].ControlType := ctCustomControl;
          Columns[I].CustomControl := GoodsLookup;
          Break;
        end;
      end;
    end;
  end  else
  begin
    with DBGrid do
    begin
      GoodsLookup.DataSource := DataSource;
      for I := 0 to Columns.Count - 1 do
      begin
        if Pos('GOOD', UpperCase(Columns[I].FieldName)) > 0 then
        begin
          GoodsLookup.DataField := Columns[I].FieldName;
          Columns[I].ControlType := ctCustomControl;
          Columns[I].CustomControl := GoodsLookup;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TWSVoucherEditForm.WriteOffActionExecute(Sender: TObject);
begin
  inherited;
  if Modified and (Application.MessageBox('�Ƿ�ע����ƾ����',
    PChar(Caption), MB_ICONQUESTION or MB_YESNO) = IDNO) then Exit;
  with MasterDataSet do
  begin
    Edit;
    FieldByName('RecordState').AsString := 'ע��';
    Post;
  end;
  Save;
end;

procedure TWSVoucherEditForm.PageOptionsActionExecute(Sender: TObject);
var
  Title: string;
begin
  inherited;
  with TRegistry.Create do
  try
    OpenKey('Software\soft.NET\NiceERP\' + ClassName + '\PageOptions', True);
    Title := ReadString('Title');
    if InputQuery('ҳ������', '����', Title) then
      WriteString('Title', Title);
  finally
    Free;
  end;
end;

procedure TWSVoucherEditForm.VourcherExportActionExecute(Sender: TObject);
begin
  inherited;
  { DONE -cUI : ��ӵ��� DBGrid �����ݵĴ���}
  ExportDBGridToExcel(DBGrid, GetKeyState(VK_SHIFT) and $80000 = $80000,
    Caption, Hint, DBGrid.Hint);

end;

end.

