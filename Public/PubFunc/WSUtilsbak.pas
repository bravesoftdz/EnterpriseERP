
unit WSUtils;

interface

uses Windows, Messages, SysUtils, Classes, Controls, Forms, DBGrids, ComCtrls,
  DB, winsock, Dialogs, ADODB;

type
  TFlag = (Mouth, NotMouth, Number, Letter, AscII);

function GetMaxCode(Field: string; Table: string; Value: TFlag): string;
{ DONE -o ����ƽ -cCode :�����Ʊ���,���������ֱ���Number(����)/Letter(��ĸ)/Ascii(����+��ĸ) }
function Coding(value: widestring; flag: tflag): string;
function GetPassword(AStrPass: string): integer; // ����ת������
function GetHostIP: string; //ȡ�ñ�����IP��ַ����
function GetComputerNameX: string; //ȡ�ü���������ƺ���
function FindShowForm(FormClass: TFormClass; const Caption: string): TForm;
function ColumnByFieldName(Grid: TDBGrid; const FieldName: string): TColumn;

{ ���� DataSet �ṩ�����ݽ������ͽṹ��DataSet ������� ID, Name, UpID �����ֶ�
  ÿ�� TreeNode �� Data ���Դ洢�����ֶ� ID ��ֵ }

  //ע��:SourceDataSet�в����мȲ��Ǹ��ڵ���û�и��ڵ�ļ�¼,�������˳��ù���.
//  ����� 2002.10.31
procedure BuildTreeFromDataSet(TreeItem: ttreenodes; SourceDataSet: TDataset);

//��TreeItem�в���ID����UPID�Ľڵ�,����ֵnilΪû�ҵ�,
//  ����� 2002.10.31
function FindNode(TreeItem: TTreeNodes; UpId: integer): TTreeNode;

//�洢Tree״̬����
function SaveState(Tree: TTreeView): Tstrings;


//����Tree״̬����
procedure LoadState(tree: TTreeView; List: Tstrings);

{ �ùرպ��ٴ� DataSet �ķ�����ˢ�� DataSet�����ڴ򿪺󷵻ص���ǰ״̬(��¼λ��) }
procedure RefreshDataSet(DataSet: TDataSet);
procedure ExportDBGridToExcel(Grid: TDBGrid; DisableScreenUpdating: Boolean;
  ReportCaption, ReportMemo, ReportTtl :string);
function GetTempFileName(const FileName: string): string;
function GetCompanyName(): string;

procedure RunReportExplorer;

{ ��ӡ����ReportName �ƶ�Ҫ��ӡ�ı�������  Screen Printer }   
procedure PrintReport(const ReportName, Params, DeviceType: string);

function NumberToHZ(Value: Extended; Style: Integer): string;

var
  PeriodID: integer; //�����ڼ�ID
  CompanyName: string; //��˾����

implementation

uses ComObj, ActiveX, CommonDM, MSOption;

function GetCompanyName(): string;
var
  adoTemp: TADOQuery;
  c: string;
begin
  Screen.Cursor := CrHourglass;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  with adoTemp do
  begin
    close;
    sql.Text := 'Select top 1 * from MSCompanyUser where RecordState<>' + QuotedStr('ɾ��');
    open;
    if RecordCount = 0 then
    begin
      //��˾����
      Application.CreateForm(TMSOptionForm, MSOptionForm);
      MSOptionForm.ShowModal;
      adoTemp.Requery();
    end;
    if RecordCount = 0 then
      result := ''
    else
      result := adoTemp.FieldByName('Name').AsString;
  end;
  Screen.Cursor := CrDefault;
end;

function FindForm(FormClass: TFormClass): TForm;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Screen.FormCount - 1 do begin
    if Screen.Forms[I] is FormClass then begin
      Result := Screen.Forms[I];
      Break;
    end;
  end;
end;

function InternalFindShowForm(FormClass: TFormClass;
  const Caption: string; Restore: Boolean): TForm;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Screen.FormCount - 1 do begin
    if Screen.Forms[I].ClassNameIs(FormClass.ClassName) then
      if (Caption = '') or (Caption = Screen.Forms[I].Caption) then begin
        Result := Screen.Forms[I];
        Break;
      end;
  end;
  if Result = nil then begin
    Application.CreateForm(FormClass, Result);
    if Caption <> '' then Result.Caption := Caption;
  end;
  with Result do begin
    if Restore and (WindowState = wsMinimized) then WindowState := wsNormal;
    Show;
  end;
end;

function FindShowForm(FormClass: TFormClass; const Caption: string): TForm;
begin
  Result := InternalFindShowForm(FormClass, Caption, True);
end;

function ColumnByFieldName(Grid: TDBGrid; const FieldName: string): TColumn;
var
  I: Integer;
begin
  for I := 0 to Grid.Columns.Count - 1 do
    if CompareText(Grid.Columns[I].FieldName, FieldName) = 0 then
    begin
      Result := Grid.Columns[I];
      Exit;
    end;
  Result := nil;
end;


procedure BuildTreeFromDataSet(TreeItem: ttreenodes; SourceDataSet: TDataset);
var
  i, Number: integer;
  temptree, Temptree2: ttreenode;
begin
  Number := SourceDataSet.Recordcount;

  while (not SourceDataSet.IsEmpty)
    and
    (treeitem.Count < SourceDataSet.RecordCount)
    and (Number > 0) do
  begin
    SourceDataSet.First;
    for i := 1 to SourceDataSet.RecordCount do
    begin
      if FindNode(treeitem, SourceDataSet.fieldbyname('ID').AsInteger) = nil //�Ƿ��Ѿ���ӵ�Treeview
        then begin
        if (SourceDataSet.fieldbyname('UpID').AsInteger = -1)
          then begin
          temptree2 := treeitem.Add(nil, SourceDataSet.fieldbyname('Name').AsString);
          temptree2.data := pointer(SourceDataSet.fieldbyname('ID').asinteger);

        end
        else begin
          temptree := FindNode(treeitem, SourceDataSet.fieldbyname('UpID').AsInteger);
          if temptree <> nil //�ҵ����ڵ�
            then begin
            temptree2 := treeitem.AddChild(Temptree, SourceDataSet.fieldbyname('Name').AsString);
            temptree2.data := pointer(SourceDataSet.fieldbyname('ID').asinteger);
          end;
        end;

      end;
      Sourcedataset.Next;
    end;
    number := number - 1;
  end;

end;


function FindNode(TreeItem: TTreeNodes; UpId: integer): TTreeNode;
var
  i: integer;
begin
  result := nil;

  for i := 0 to treeitem.Count - 1 do
  begin
    if integer(treeitem.Item[i].Data) = Upid
      then result := treeitem.item[i]
  end;

end;


function SaveState(Tree: TTreeView): Tstrings;
var
  tempList: Tstrings;
  i: integer;
begin
  templist := TStringList.Create;
  templist.Clear;
  for i := 0 to tree.Items.Count - 1 do
  begin
    if tree.Items.Item[i].Selected
      then templist.Add(inttostr(i));
  end;
  result := templist;

end;

procedure LoadState(tree: TTreeView; List: Tstrings);
var
  i: integer;
begin
  for i := 0 to list.Count - 1 do
  begin
    if strtoint(list.Strings[i]) <= (tree.Items.Count - 1)
      then tree.Items.Item[strtoint(list.strings[i])].Selected := true;

  end;
end;


function GetPassword(AStrPass: string): integer;
{*******************************************************
����:����ת������
�汾: V1.0
����:2002-11-01
����: ����ƽ
����:
TODO:����ת������
*******************************************************}
var
  Temp: pchar;
  c: char;
  i, long, Pass: integer;
begin
  Pass := 0;
  long := Length(AStrPass);
  for i := 1 to Long do
  begin
    Temp := pchar(copy(AStrPass, i, 1));
    c := Temp^;
    if c in ['A'..'Z'] then
      c := chr(ord(c) + 32);
    Pass := Pass + (ord(c) xor long) + (ord(c) and long);
  end;
  Result := Pass;
end;

function GetComputerNameX: string;
{*******************************************************
����:ȡ�ü���������ƺ���
�汾: V1.0
����:2002-11-01
����: ����ƽ
����:
TODO:ȡ�ü���������ƺ���
*******************************************************}
var
  i: Cardinal;
  cBuff: PChar;
begin
  GetMem(cBuff, 128);
  i := 128;
  GetComputerName(cBuff, i);
  Result := StrPas(cBuff);
end;

////ȡ�ñ�����IP��ַ

function GetHostIP: string;
{*******************************************************
����:ȡ�ñ�����IP��ַ����
�汾: V1.0
����:2002-11-01
����: ����ƽ
����:
TODO:ȡ�ñ�����IP��ַ����
*******************************************************}
var
  ch: array[1..32] of Char;
  i: Integer;
  WSData: TWSAData;
  MyHost: PHostEnt;
  IP: string;
begin
  IP := '';
  if WSAstartup(2, wsdata) <> 0 then
    Result := '0.0.0.0';

  try
    if getHostName(@ch[1], 32) <> 0 then
      Result := '0.0.0.0';
  except
    Result := '0.0.0.0';
  end;

  MyHost := GetHostByName(@ch[1]);
  if MyHost <> nil then
  begin
    for i := 1 to 4 do
    begin
      IP := IP + inttostr(Ord(MyHost.h_addr^[i - 1]));
      if i < 4 then
        IP := IP + '.'
    end;
  end;
  Result := IP;
end;

procedure RefreshDataSet(DataSet: TDataSet);
var
  BM: TBookmark;
begin
  with DataSet do
  begin
    DisableControls;
    try
      if Active then BM := GetBookmark
      else BM := nil;
      try
        Close;
        Open;
        if (BM <> nil) and not (Bof and Eof) and BookmarkValid(BM) then
        try
          GotoBookmark(BM);
        except
        end;
      finally
        if BM <> nil then FreeBookmark(BM);
      end;
    finally
      EnableControls;
    end;
  end;
end;

procedure ExportDBGridToExcel(Grid: TDBGrid; DisableScreenUpdating: Boolean;
  ReportCaption,ReportMemo,ReportTtl :string);
const
  CLASS_ExcelApplication: TGUID = '{00024500-0000-0000-C000-000000000046}';

var
  ExcelApp: OleVariant;
  Unknown: IUnknown;
  Bm: TBookmarkStr;
  Col, Row: Integer;
  I: Integer;
begin
  if (Grid.DataSource <> nil) and (Grid.DataSource.DataSet <> nil) then
    with Grid.DataSource.DataSet do
    begin
      try
        if not Succeeded(GetActiveObject(CLASS_ExcelApplication, nil, Unknown)) then
          Unknown := CreateComObject(CLASS_ExcelApplication);
      except
        raise Exception.Create('�������� Microsoft Excel����ȷ�� Microsoft Excel ����ȷ��װ�ڱ�����');
      end;
      ExcelApp := Unknown as IDispatch;
      ExcelApp.Visible := True;
      ExcelApp.Workbooks.Add;
      if DisableScreenUpdating then
        ExcelApp.ScreenUpdating := False;
      DisableControls;
      try
        Bm := Bookmark;
        First;
        ExcelApp.Cells[1, 1] := ReportCaption;
        ExcelApp.Cells[2, 1] := ReportMemo;
        ExcelApp.Cells[3, 1] := ReportTtl;
        Row := 4;
        Col := 1;
        for I := 0 to Grid.Columns.Count - 1 do
        begin
          if Grid.Columns[I].Visible then
            ExcelApp.Cells[Row, Col] := Grid.Columns[I].Title.Caption;
          Inc(Col);
        end;
        Inc(Row);
        while not EOF do
        begin
          Col := 1;
          for I := 0 to Grid.Columns.Count - 1 do
          begin
            if Grid.Columns[I].Visible then
              ExcelApp.Cells[Row, Col] := Grid.Columns[I].Field.DisplayText;
            Inc(Col);
          end;
          Inc(Row);
          Next;
        end;
        Col := 1;
        for I := 0 to Grid.Columns.Count - 1 do
        begin
          if Grid.Columns[I].Visible then
            ExcelApp.Columns[Col].AutoFit; ;
          Inc(Col);
        end;
        Bookmark := Bm;
      finally
        EnableControls;
        if not ExcelApp.ScreenUpdating then
          ExcelApp.ScreenUpdating := True;
      end;
      ExcelApp.ActiveWorkbook.PrintPreview;
    end;
end;

function GetTempFileName(const FileName: string): string;
var
  Path: array[0..255] of Char;
  FName: array[0..MAX_PATH - 1] of Char;
begin
  SetLength(Result, MAX_Path);
  GetTempPath(256, Path);
  Windows.GetTempFileName(Path, PChar(FileName), 0, FName);
  Result := FName;
end;


//����������Ʊ���.֧�� 1.�޶��ַ�+���ַ�ʽ 2.�޶��ַ�+��ĸ��ʽ 3.�޶��ַ�+����+��ĸ.
//���������ֱ���Number(����)/Letter(��ĸ)/Ascii(����+��ĸ)
//����ƽ

function Coding(value: widestring; flag: tflag): string;
var
  temp: array[0..254] of widechar;
  i, k: integer;
begin
  if Trim(value) = '' then Value := '00000';
  value := uppercase(value);
  for i := 0 to 254 do temp[i] := widechar($D);
  k := 0;
  if flag = ascii then
  begin
    for i := 1 to length(value) do
      if (integer(value[i]) > 57) and (integer(value[i]) < 65) or (integer(value[i]) > 90)
        or (integer(value[i]) < 48) then
      begin
        temp[i] := value[i];
        value[i] := widestring('��')[1];
      end;
    k := 91;
  end;
  if flag = number then
  begin
    for i := 1 to length(value) do
      if (integer(value[i]) > 57) or (integer(value[i]) < 48) then
      begin
        temp[i] := value[i];
        value[i] := widestring('��')[1];
      end;
    k := 58;
  end;
  if flag = letter then
  begin
    for i := 1 to length(value) do
      if not (integer(value[i]) in [65..90]) then
      begin
        temp[i] := value[i];
        value[i] := widestring('��')[1];
      end;
    k := 91;
  end;
  value := stringreplace(value, '��', '', [rfreplaceall]);
  value[length(value)] := widechar(integer(value[length(value)]) + 1);
  if flag = number then
  begin
    for i := length(value) downto 2 do
      if integer(value[i]) = k then
      begin
        value[i - 1] := widechar(integer(value[i - 1]) + 1);
        value[i] := widechar('0');
      end;
  end;
  if flag = letter then
  begin
    for i := length(value) downto 2 do
      if integer(value[i]) = k then
      begin
        value[i - 1] := widechar(integer(value[i - 1]) + 1);
        value[i] := widechar('A');
      end;
  end;
  if flag = ascii then
  begin
    for i := length(value) downto 2 do
    begin
      if integer(value[i]) = k then
      begin
        value[i - 1] := widechar(integer(value[i - 1]) + 1);
        value[i] := widechar('0');
      end;
      if integer(value[i]) = 58 then
      begin
        value[i] := 'A';
      end;
    end;
  end;
  if integer(value[1]) = k then
  begin
    messageboxex(application.Handle, '���ݷ�Χ�����趨λ��,���֤����', '��ʾ',
      MB_ICONWARNING or MB_OK or MB_APPLMODAL, 936);
    result := '00000000001';
    exit;
  end;
  for i := 0 to 254 do
    if temp[i] <> widechar($D) then insert(temp[i], value, i);
  result := value;
end;

function GetMaxCode(Field: string; Table: string; Value: TFlag): string;
var
  adoTemp: TADOQuery;
  c: string;
begin
  Screen.Cursor := CrHourglass;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  with adoTemp do
  begin
    close;
    //sql.Text := 'Select Max(' + Field + ') as ' + Field + ' from ' + Table;
    sql.Text := 'Select ' + Field + ' as ' + Field + ' from ' + Table + ' where ID=(Select Max(ID) from ' + Table + ')';
    open;
    if RecordCount = 0 then
      c := ''
    else
      c := fieldbyname(Field).AsString;
  end;
  result := coding(c, Value);
  Screen.Cursor := CrDefault;
end;

var
  ReportsDLLHandle: THandle;

function ReportsLibHandle: THandle;
var
  InitLibrary: procedure(App: TApplication); stdcall;
begin
  if ReportsDLLHandle = 0 then
  begin
    ReportsDLLHandle := LoadLibrary('Reports.DLL');
    if ReportsDLLHandle = 0 then
      raise Exception.Create('�Ҳ�������̬���ӿ� Reports.DLL');
    @InitLibrary := GetProcAddress(ReportsDLLHandle, 'InitLibrary');
    InitLibrary(Application);
  end;
  Result := ReportsDLLHandle;
end;

procedure RunReportExplorer;
var
  RunExplorer: procedure; stdcall;
begin
  @RunExplorer := GetProcAddress(ReportsLibHandle, 'RunReportExplorer');
  RunExplorer;
end;

procedure PrintReport(const ReportName, Params, DeviceType: string);
var
  PReport: procedure (const ReportName, Params, ADeviceType: string); stdcall;
begin
  @PReport := GetProcAddress(ReportsLibHandle, 'PrintReport');
  PReport(ReportName, Params, DeviceType);
end;

function NumberToHZ(Value: Extended; Style: Integer): string;
const
  HZNumbers: array[0..1, 0..9] of string =
    (('��', 'һ', '��', '��', '��', '��', '��', '��', '��', '��'),
    ('��', 'Ҽ', '��', '��', '��', '��', '½', '��', '��', '��'));
  HZNumberUnits: array[0..1, 0..12] of string =
    (('', 'ʮ', '��', 'Ǫ', '��', 'ʰ', '��', 'Ǫ', '��', 'ʰ', '��', 'Ǫ', '��'),
    ('', 'ʰ', '��', 'Ǫ', '��', 'ʰ', '��', 'Ǫ', '��', 'ʰ', '��', 'Ǫ', '��'));
var
  Temp: string;
  I, Len: Integer;
  ZeroFlag, Empty: Boolean;
begin
  Result := '';
  ZeroFlag := False;
  Empty := True;
  Temp := IntToStr(Trunc(Value));
  Len := Length(Temp);
  for I :=  1 to Len do
  begin
    if Temp[I] <> '0' then
    begin
      if ZeroFlag then Result := Result + HZNumbers[Style, 0];
      Result := Result + HZNumbers[Style, StrToInt(Temp[I])] + HZNumberUnits[Style, Len - I];
      if (Len - I) mod 4 <> 0 then Empty := False;
    end
    else if (Len - I) mod 4 = 0 then
    begin
      if not Empty or ((Len - I) = 0) then Result := Result + HZNumberUnits[Style, Len - I];
      Empty := True;
    end;
    ZeroFlag := Temp[I] = '0';
  end;
  Temp := FormatFloat('0.##########', Frac(Value));
  if Length(Temp) > 2 then Result := Result + '��';
  for I := 3 to Length(Temp) do
    Result := Result + HZNumbers[Style, StrToInt(Temp[I])];
end;

end.

