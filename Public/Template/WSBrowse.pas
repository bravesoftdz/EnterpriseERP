{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
unit Name: WSBrowse
  Author: Qiuliang
  Purpose:
  History:
  2002 - 10 - 28 Created
  Description:
һ������������������:
  1. �̳� TWSBrowseForm ������ Form
  2. �ڸ� Form �Ϸ���������� DataSet��ͨ���ֶα༭��������ʹ�õ��ֶΡ���дÿ
    ���ֶε� DisplayLabel(���ı���)���ԣ���������Ҫ�� DBGrid ����ʾ�������ֶε�
    Visible ��Ϊ False(��Ҫ)
  3. ��Ҫ������ٸ� DataSet ���� PageControl �ϴ�������ҳ������ÿһ�� TabSheet
    ��Tag ���Ը�Ψһֵ, ����DataSet �� Tag �������Ӧ����������ת��ĳһ TabSheet
    ʱ DBGrid �о���ʾ����ͬ Tag �� DataSet;
  4. �������´���:
    //��������:
    protected
      function CreateEditForm: TWSEditForm; override;

    //����ʵ�岿��:
    function TWSBrowseDemoForm.CreateEditForm: TWSEditForm;
    begin
      // ���ݲ�ͬҳ�����༭��ͬ�Ĵ���
      case PageControl.ActivePageIndex of
        0: Result := TWSEditDemoForm.Create(Application);
        1: Result := TWSEditDemoForm.Create(Application);
      end;
    end;

  5. //������������༭����(��ѡ)
      //����������:
    protected
      function GetEditParams: Variant; override; //����ȡ�ò�������

    function TWSBrowseDemoForm.GetEditParams: Variant;
    begin
      Result := VarArrayOf([DataSet.Fields[0].Value,
        DataSet.Fields[1].Value,
        DataSet.Fields[2].Value,
        DataSet.Fields[3].Value]);
    end;

    //�ڱ༭����:
    function TWSEditDemoForm.Edit(const Params: Variant): Boolean;
    begin
      Panel1.Caption := Format('Params = %s', [VarToStr(Params[0])]) + '+' +
      Format('+%s', [VarToStr(Params[1])]) + '+' +
      Format('+%s', [VarToStr(Params[2])]) + '+' +
      Format('+%s', [VarToStr(Params[3])]);
      Result := ShowModal = mrOK;
    end;

�����������ݱ༭����:
  1. �̳� TWSEditForm ����һ���µ� Form
  2. ������������ؼ�������
  3. �������´���:
    //��������:
    public
      function Enter: Boolean; override;
      function Edit(const Params: Variant): Boolean; override;

    //����ʵ�岿��:
    function TWSEditDemoForm.Edit(const Params: Variant): Boolean;
    begin
      Panel1.Caption := Format('Params = %s', [VarToStr(Params)]);
      //��ʼ������
      Result := ShowModal = mrOK;
    end;

    function TWSEditDemoForm.Enter: Boolean;
    begin
      Result := ShowModal = mrOK;
    end;

����˵��:
  ����TWSEditDemoForm,TWSBrowseDemoFormΪʵ���´����Ĵ�������;
  ���ϴ����Ǽ̳к�������д�Ĵ���(���Ҹ�ʽҲ���ܱ�)!
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}

unit WSBrowse;

interface

{$I DEFINE.INC}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ActnList, Grids, DBGrids, ExtCtrls, ComCtrls, TypInfo, QLDBFlt,
  QuickRpt, QRExtra, QLRptBld, StdCtrls, Buttons, WSEdit, QLDBGrid,
  ImgList, ToolWin, WSCstFrm, ADODB, Menus, QLDBCstVw;

type
  TWSBrowseForm = class(TWSCustomForm)
    ActionList: TActionList;
    AddNewAction: TAction;
    DataSource: TDataSource;
    DeleteAction: TAction;
    EditAction: TAction;
    ExportAction: TAction;
    FiltrateAction: TAction;
    PageControl: TPageControl;
    PrintAction: TAction;
    PrintPreviewAction: TAction;
    TabSheet1: TTabSheet;
    RefreshAction: TAction;
    DBGrid: TQLDBGrid;
    ToolBar: TToolBar;
    ExitAction: TAction;
    Panel1: TPanel;
    WsBrowsePop: TPopupMenu;
    wsbrowsepopnRename: TMenuItem;
    wsbrowsepopDelete: TMenuItem;
    CustomizeViewAction: TAction;
    ShowChartAction: TAction;
    procedure DBGridTitleClick(Column: TColumn);
    procedure DeleteActionExecute(Sender: TObject);
    procedure DeleteActionUpdate(Sender: TObject);
    procedure EditActionUpdate(Sender: TObject);
    procedure ExportActionExecute(Sender: TObject);
    procedure FiltrateActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrintActionExecute(Sender: TObject);
    procedure PrintPreviewActionExecute(Sender: TObject);
    procedure TabSheetShow(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RefreshActionExecute(Sender: TObject);
    procedure AddNewActionExecute(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure wsbrowsepopnRenameClick(Sender: TObject);
    procedure wsbrowsepopDeleteClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CustomizeViewActionExecute(Sender: TObject);
    procedure ShowChartActionExecute(Sender: TObject);
  private
    FAllowSort: Boolean;
    FFilterDialogList: TList;
    FAvailableFields: string;
    function CreateQRBuilder: TQRBuilder;
    function ExecuteFilterDialog(ADataSet: TDataSet): Boolean;
    function GetDataSet: TDataSet;
    function GetNextTag: Integer;
  protected
    {{
    �ڴ�ӡ DBGrid ֮ǰ����� CreateReport
    ������һ������֮����ڸñ���Ļ�������� DBGrid �����ݡ�

    Ĭ������»ᴴ��һ�� TQuickRep ��ı�������� override
    �÷������������ʵı���
    }
    function CreateReport: TQuickRep; virtual;
    {{
    �ڴ����˱������ڱ�������� DBGrid
    ������֮���ڴ�ӡ���֮ǰ����ø÷��������������һ�����Ʊ��������ϸ�ڡ�
    }
    procedure InitReport(Report: TQuickRep); virtual;
    function CreateEditForm: TWSEditForm; virtual;
    function GetEditParams: Variant; virtual;
    procedure RefreshAvailableFields;
  public
    procedure Print(Preview: Boolean = False; ShowSetupDialog: Boolean = False);
    {{
    ���� RefreshDataSet ������ˢ�µ�ǰ��ʾ�� DataSet��
    }
    procedure RefreshDataSet;
    {{
    ʹ�� AllowSort �������Ƿ��������û�������� DBGrid �ı�����ʱ�Զ���
    DataSet ��������
    }
    property AllowSort: Boolean read FAllowSort write FAllowSort;
    {{
    �� DataSet ��ȡ�õ�ǰ����ʾ�����ݼ�
    }
    property DataSet: TDataSet read GetDataSet;
  end;

implementation

uses CommonDM, WSUtils, WSSecurity, Clipbrd, WSCustomRpt, WSChart;

{$R *.dfm}

{
****************************** TBrowseForm ******************************
}

function TWSBrowseForm.CreateQRBuilder: TQRBuilder;
begin
  Result := TQLDBGridReportBuilder.Create(Self);
  with TQLDBGridReportBuilder(Result) do
  begin
    DBGrid := Self.DBGrid;
    AutoWidth := True;
    Report := CreateReport;
    AutoOrientation := False;
    Report.ReportTitle := Self.Caption;
  end;
end;

function TWSBrowseForm.CreateReport: TQuickRep;
begin
  Result := TWSCustomReport.Create(Self);
  Result.PreviewInitialState := wsMaximized;
end;

procedure TWSBrowseForm.DBGridTitleClick(Column: TColumn);
const
  IndexFieldNamesProp = 'IndexFieldNames';
var
  SortStr, OldSortStr: string;
begin
  if FAllowSort and (Column.Field <> nil) and IsPublishedProp(Column.Field.DataSet, IndexFieldNamesProp) then
    with Column do
    begin
      if Field.Lookup then SortStr := Field.KeyFields // Lookup �ֶθ�����ؼ��ֶ�����
      else if Field.Calculated then
        // �����ֶβ�������
      else SortStr := Field.FieldName;
      OldSortStr := GetStrProp(Field.DataSet, IndexFieldNamesProp);
      if SortStr = OldSortStr then SortStr := SortStr + ' DESC';
      SetStrProp(Field.DataSet, IndexFieldNamesProp, SortStr);
    end;
end;

procedure TWSBrowseForm.DeleteActionExecute(Sender: TObject);
begin
  { DONE : ���ɾ����ǰѡ��ƾ���Ĵ��� }
  if DataSet.FieldByName('RecordState').AsString ='�ύ'
    then    showmessage('�����Ѿ��ύ,����ɾ��!')
  else
  begin
    if MessageBox(Handle, '�����Ҫɾ����ǰ��¼��',
      '��ȷ��', MB_YESNO + MB_ICONQUESTION) = IDYES then
    begin
      with DataSet do
      begin
        Edit;
        FieldByName('RecordState').AsString := 'ɾ��';
        Post;
      end;
      RefreshDataSet;
    end;
  end;

end;

procedure TWSBrowseForm.DeleteActionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not DataSet.IsEmpty;
end;

procedure TWSBrowseForm.EditActionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not DataSet.IsEmpty;
end;

function TWSBrowseForm.ExecuteFilterDialog(ADataSet: TDataSet): Boolean;

  function GetFilterFields: string;
  var
    I: Integer;
  begin
    with ADataSet do
      for I := 0 to FieldCount - 1 do
          if Fields[I].Visible then Result := Result + Fields[I].FieldName + ';';
  end;

type
  TDataSetClass = class of TDataSet;
var
  I: Integer;
  Field: TField;
  FilterDialog, NewFilterDialog: TQLDBFilterDialog;
  FilterDataSet: TDataSet;
  S :string;

begin
  FilterDialog := nil;
  for I := 0 to FFilterDialogList.Count - 1 do
  begin
    if TQLDBFilterDialog(FFilterDialogList[I]).DataSet = ADataSet then
    begin
      FilterDialog := FFilterDialogList[I];
      Break;
    end;
  end;

  if FilterDialog = nil then
  begin
    FilterDialog := TQLDBFilterDialog.Create(Self);
    FilterDialog.DataSet := ADataSet;
    FilterDialog.FilterFields := GetFilterFields;
    FFilterDialogList.Add(FilterDialog);
  end
  else begin
    NewFilterDialog := TQLDBFilterDialog.Create(Self);
    NewFilterDialog.FilterStrings.Assign(FilterDialog.FilterStrings);
//    FilterDialog.DataSet := ADataSet;
    FilterDialog := NewFilterDialog;
    FilterDialog.FilterFields := GetFilterFields;
    FFilterDialogList.Add(FilterDialog);
  end;
  FilterDataSet := TDataSetClass(ADataSet.ClassType).Create(Self);
  FilterDataSet.Tag := GetNextTag;
  FilterDataSet.Name := 'FilterDataSet' + IntToStr(FilterDataSet.Tag);
  if FilterDataSet is TCustomADODataSet then
  begin
    TCustomADODataSet(FilterDataSet).Connection := TCustomADODataSet(ADataSet).Connection;
    if FilterDataSet is TADODataSet then
    begin
      TADODataSet(FilterDataSet).CommandText := TADODataSet(ADataSet).CommandText;
      TADODataSet(FilterDataSet).Parameters.Assign(TADODataSet(ADataSet).Parameters);
    end
    else if FilterDataSet is TADOQuery then
    begin
      TADOQuery(FilterDataSet).SQL.Assign(TADOQuery(ADataSet).SQL);
      TADOQuery(FilterDataSet).Parameters.Assign(TADOQuery(ADataSet).Parameters);
    end
    else if FilterDataSet is TADOTable then
      TADOTable(FilterDataSet).TableName := TADOTable(ADataSet).TableName
    else if FilterDataSet is TADOStoredProc then
      TADOStoredProc(FilterDataSet).ProcedureName := TADOStoredProc(ADataSet).ProcedureName;
  end;
  FilterDataSet.Open;
  for I := 0 to FilterDataSet.FieldCount - 1 do
  begin
    with FilterDataSet.Fields[I] do
    begin
      Field := ADataSet.FindField(FieldName);
      Visible := (Field <> nil) and Field.Visible;
      if Field <> nil then
      begin
        DisplayLabel := ADataSet.FieldByName(FieldName).DisplayLabel;
        if IsPublishedProp(FilterDataSet.Fields[I], 'currency') and
          (GetOrdProp(ADataSet.FieldByName(FieldName), 'currency') <> 0) then
          SetOrdProp(FilterDataSet.Fields[I], 'currency', 1);

        if IsPublishedProp(FilterDataSet.Fields[I], 'DisplayFormat') then
          SetStrProp(FilterDataSet.Fields[I], 'DisplayFormat',
            GetStrProp(ADataSet.FieldByName(FieldName), 'DisplayFormat'));
      end;
    end;
  end;
  FilterDialog.DataSet := FilterDataSet;

  Result := FilterDialog.Execute;
  if Result then
  begin
    with TTabSheet.Create(Self) do
    begin
      PageControl := Self.PageControl;
      Tag := FilterDataSet.Tag;
      Caption := '��ѯ ' + IntToStr(Tag);
      S := Caption;
      if InputQuery('��ѯ', '��ѯ�������:', S) then
        Caption := S;
    end;
    PageControl.ActivePageIndex := PageControl.PageCount - 1;
    PageControl.OnChange(PageControl);
  end
  else begin
    FilterDialog.DataSet := nil;
    FilterDataSet.Free;
  end;
  hint :=s;
end;

procedure TWSBrowseForm.ExportActionExecute(Sender: TObject);
begin
  { DONE -cUI : ��ӵ��� DBGrid �����ݵĴ���}
  ExportDBGridToExcel(DBGrid, GetKeyState(VK_SHIFT) and $80000 = $80000,
    Caption, Hint, DBGrid.Hint);
end;

procedure TWSBrowseForm.FiltrateActionExecute(Sender: TObject);
begin
  ExecuteFilterDialog(DataSet);
end;

procedure TWSBrowseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FormStyle = fsMDIChild then Action := caFree;
end;

procedure TWSBrowseForm.FormCreate(Sender: TObject);
begin
  FAllowSort := True;
  FFilterDialogList := TList.Create;
end;

procedure TWSBrowseForm.FormDestroy(Sender: TObject);
begin
  FFilterDialogList.Free;
end;

function TWSBrowseForm.GetDataSet: TDataSet;
begin
  Result := DataSource.DataSet;
end;

procedure TWSBrowseForm.InitReport(Report: TQuickRep);
begin
end;

procedure TWSBrowseForm.Print(Preview: Boolean = False; ShowSetupDialog: Boolean = False);
begin
  with CreateQRBuilder do
  try
    Active := True;
    InitReport(TQuickRep(Report));
    if Preview then Report.PreviewModal
    else begin
      if ShowSetupDialog then Report.PrinterSetup;
      Report.Print;
    end;
  finally
    Free;
  end;
end;

procedure TWSBrowseForm.PrintActionExecute(Sender: TObject);
begin
  Print(False, False);
end;

procedure TWSBrowseForm.PrintPreviewActionExecute(Sender: TObject);
begin
  Print(True);
end;

procedure TWSBrowseForm.RefreshDataSet;
begin
  WSUtils.RefreshDataSet(DataSet);
end;

procedure TWSBrowseForm.TabSheetShow(Sender: TObject);
var
  I, DSTag: Integer;
  TabSheet: TTabSheet;
begin
  TabSheet := PageControl.ActivePage;
  if TabSheet <> nil then
  begin
    DSTag := TabSheet.Tag;
    for I := 0 to ComponentCount - 1 do
      if (Components[I].Tag = DSTag) and (Components[I] is TDataSet) then
      begin
        if not TDataSet(Components[I]).Active then
        begin
          TDataSet(Components[I]).Open;
          RefreshAvailableFields;
        end;
        DataSource.DataSet := TDataSet(Components[I]);
        Break;
      end;
  end;
end;

procedure TWSBrowseForm.FormShow(Sender: TObject);
begin
  PageControl.OnChange(PageControl);
end;

procedure TWSBrowseForm.RefreshActionExecute(Sender: TObject);
begin
  RefreshDataSet;
end;

function TWSBrowseForm.CreateEditForm: TWSEditForm;
begin
  raise Exception.Create('No edit form');
end;

procedure TWSBrowseForm.AddNewActionExecute(Sender: TObject);
begin
  with CreateEditForm do
  try
    if Enter then RefreshDataSet;
  finally
    Free;
  end;
end;

procedure TWSBrowseForm.EditActionExecute(Sender: TObject);
begin
  with CreateEditForm do
  try
    if Edit(GetEditParams) then RefreshDataSet;
  finally
    Free;
  end;
end;

function TWSBrowseForm.GetEditParams: Variant;
begin
  if DataSet.FindField('ID')<> nil   then
      Result := DataSet.fieldbyname('ID').Value
  else Result := DataSet.Fields[0].Value;
end;

procedure TWSBrowseForm.ExitActionExecute(Sender: TObject);
begin
  Close;
end;

procedure TWSBrowseForm.DBGridDblClick(Sender: TObject);
begin
  inherited;
  EditAction.Execute;
end;

function TWSBrowseForm.GetNextTag: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to PageControl.PageCount - 1 do
    if PageControl.Pages[I].Tag >= Result then Result := PageControl.Pages[I].Tag + 1;
end;

procedure TWSBrowseForm.wsbrowsepopnRenameClick(Sender: TObject);
var s :string;
begin
  inherited;
  if PageControl.ActivePageIndex =0 then exit;
  InputQuery(PageControl.ActivePage.Caption, PageControl.ActivePage.Caption+'  ��Ϊ:     ', S);
  if s<>'' then  PageControl.ActivePage.Caption :=s;
end;

procedure TWSBrowseForm.wsbrowsepopDeleteClick(Sender: TObject);
begin
  inherited;
  if PageControl.ActivePageIndex =0 then exit;
//  FilterDataSet.Tag := PageControl.ActivePageIndex;
//  FilterDataSet.Destroy;
  PageControl.ActivePage.Visible :=False;
end;

procedure TWSBrowseForm.DBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if ([ssCtrl] = Shift) and (Key = Ord('C')) and (DBGrid.SelectedField <> nil) then
    Clipboard.AsText := DBGrid.SelectedField.DisplayText;
end;

procedure TWSBrowseForm.CustomizeViewActionExecute(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  if FAvailableFields = '' then  RefreshAvailableFields;
  with TQLDBCustomViewDialog.Create(Self) do
  try
    DataSet := Self.DataSet;
    AvailableFields := FAvailableFields;
    if Execute then
    for I := 0 to DBGrid.Columns.Count - 1 do
      if DBGrid.Columns[I].Field <> nil then
        DBGrid.Columns[I].Visible := DBGrid.Columns[I].Field.Visible;
  finally
    Free;
  end;
end;

procedure TWSBrowseForm.RefreshAvailableFields;
var
  I: Integer;
begin
  FAvailableFields := '';
  if DataSet <> nil then
    with DataSet do
      for I := 0 to FieldCount - 1 do
          if Fields[I].Visible then
            FAvailableFields := FAvailableFields + Fields[I].FieldName + ';';
end;

procedure TWSBrowseForm.ShowChartActionExecute(Sender: TObject);
begin
  inherited;
  ExportDBGridToExcel(DBGrid, GetKeyState(VK_SHIFT) and $80000 = $80000,
    Caption, Hint, DBGrid.Hint, True);
end;

end.

