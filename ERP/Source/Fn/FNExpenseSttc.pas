unit FNExpenseSttc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, GEdit,
  DBCtrls, Menus, WNADOCQuery,TypInfo, CheckLst;

type
  TFNExpenseSttcForm = class(TWSVoucherBrowseForm)
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    adsMaster: TADODataSet;
    Panel2: TPanel;
    ADOQuery: TADOQuery;
    ADOQuery2: TADOQuery;
    Panel3: TPanel;
    Panel5: TPanel;
    Button3: TButton;
    TempAds: TADODataSet;
    StringField1: TStringField;
    StringField2: TStringField;
    BCDField1: TBCDField;
    BCDField2: TBCDField;
    BCDField3: TBCDField;
    BCDField4: TBCDField;
    BCDField5: TBCDField;
    BCDField6: TBCDField;
    BCDField7: TBCDField;
    BCDField8: TBCDField;
    IntegerField1: TIntegerField;
    WNADOCQuery1: TWNADOCQuery;
    Button1: TButton;
    Panel4: TPanel;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    Button2: TButton;
    Panel6: TPanel;
    Button4: TButton;
    ExpSttcGroupBox: TGroupBox;
    ExpSttcCheckListBox: TCheckListBox;
    ExpSttcCkBxPopMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    VipsetPanel: TPanel;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Button5: TButton;
    Button6: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ToolButton1: TToolButton;
    Button7: TButton;
    PeriodRadioGroup: TRadioGroup;
    PeriodMonthRadioButton: TRadioButton;
    PeriodDaysRadioButton: TRadioButton;
    PeriodMonthComboBox: TComboBox;
    PeriodDaysComboBox: TComboBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure UpdateDBGrid;
    procedure DBGridTitleClick(Column: TColumn);
    procedure DBGridDblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure adsMasterBeforeOpen(DataSet: TDataSet);
    procedure DateTimePicker2Exit(Sender: TObject);
    procedure DateTimePicker1Exit(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ExpSttcCheckListBoxClickCheck(Sender: TObject);
    procedure adsMasterAfterOpen(DataSet: TDataSet);
    procedure Button7Click(Sender: TObject);
    procedure PeriodMonthRadioButtonClick(Sender: TObject);
    procedure PeriodDataUpdate;


  private
    { Private declarations }
    WhereStr,SelectStr :string;
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  FNExpenseSttcForm: TFNExpenseSttcForm;

implementation

uses CommonDM,QLDBFlt;

{$R *.dfm}

function TFNExpenseSttcForm.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TFNExpenseSttcForm.UpdateDBGrid;
var I: Integer;
begin
  with DBGrid do
  begin
    FooterRowCount := 0;
    Columns[0].Footer.ValueType := fvtStaticText;
    Columns[0].Footer.Value := '�ϼ�:';
    Columns[0].Footer.Alignment := taCenter;
    Columns[0].Title.Alignment:= taCenter;
    for I := 0 to Columns.Count - 1 do
    begin
      Columns[i].Width :=90;
      if Pos('��',Columns[I].FieldName)>0 then Columns[i].Width :=70;
      if Pos('��',Columns[I].FieldName)>0 then Columns[i].Width :=70;
      Columns[i].Title.Alignment:= taCenter;
      if Columns[I].Field is TNumericField then
      begin
        if (not CheckBox1.Checked) and (Pos('����',Columns[I].FieldName)>0 )
             then Columns[I].Visible :=False;
        if (not CheckBox2.Checked) and  (Pos('����',Columns[I].FieldName)>0 )
             then Columns[I].Visible :=False;
        if (not CheckBox3.Checked) and  (Pos('���',Columns[I].FieldName)>0 )
             then Columns[I].Visible :=False;
        SetStrProp(Fields[I], 'DisplayFormat','#,#.00') ;
        if Pos('Price',Columns[I].FieldName)<=0 then
           Columns[I].Footer.ValueType := fvtSum;
      end;
    end;
    FooterRowCount := 1;
  end;
end;

procedure TFNExpenseSttcForm.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

procedure TFNExpenseSttcForm.DBGridDblClick(Sender: TObject);
begin
// inherited;
end;


procedure TFNExpenseSttcForm.Button3Click(Sender: TObject);
begin
  inherited;
  WNADOCQuery1.TabName :='TempExpenseList';
  WNADOCQuery1.ConnectionString :=CommonData.acnConnection.ConnectionString;
  WNADOCQuery1.Execute(False);
  if  trim(WNADOCQuery1.QueryTerm)<>'' then
      WhereStr :=' where ' +  trim(WNADOCQuery1.QueryTerm)
      else WhereStr :=' Where 1=1 ' ;
  Memo1.ReadOnly :=False;
  Memo1.Clear;
  if ( copy(trim(WNADOCQuery1.QueryTerm),1,3) ='not' ) or
    ( copy(trim(WNADOCQuery1.QueryTerm),1,3) ='NOT' )then
     Memo1.Text :='ȫ������������: '
     +Copy(trim(WNADOCQuery1.ShowTerm.Text),5,length(trim(WNADOCQuery1.ShowTerm.Text))-4 )
     else Memo1.Text :=Copy(trim(WNADOCQuery1.ShowTerm.Text),5,length(trim(WNADOCQuery1.ShowTerm.Text))-4);
  if WhereStr =' Where 1=1 ' then
    begin
      Memo1.Clear;
      Memo1.Text :='����������!';
    end;
  Memo1.ReadOnly :=True;
  ToolBar.Hint :=' ̨������: '+Memo1.Text;
  if Button1.Tag=1 then Button1Click(sender)
    else Button2Click(sender);
end;

procedure TFNExpenseSttcForm.FormShow(Sender: TObject);
var I :integer;
begin
  inherited;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList')
        +' )) DROP TABLE #ExpenseList ' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select b.Date [����], '
     +' b.Code [���],   '
     +' b.BillMode [ҵ�����],  '
     +' b.Brief [ժҪ], '
     +' ex.name [��������],'
     +' isnull(a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1),0) [���ý��], '
     +' c.name [�ܿ���] ,   '
     +' d.name [������] , '
     +' f.name  [�ͻ�����],  '
     +' g.name  [�ʲ�����], '
     +' h.name  [��Ŀ����], '
     +' i.name  [��������], '
     +' j.name  [��������], '
     +' k.name  [�ʲ����], '
     +' l.name  [��Ŀ���], '
     +' e.name [�����ʻ�],  '
     +' a.BillCode [Ʊ�ݺ���],'
     +' isnull(a.AmountB,0) [�ο�����], '
     +' b.Memo [ҵ��ע],'
     +' a.Memo  [��ע]'
     +' into #ExpenseList from FNExpenseDetail a '
     +' left outer join FNExpenseMaster b on b.ID=a.MasterID '
     +' left outer join DAExpenseClass       ex on ex.ID=a.ExpenseID '
     +' left outer join MSEmployee      c on c.ID=b.ClientID   '
     +' left outer join MSEmployee      d on d.ID=b.EmployeeID  '
     +' left outer join FNAccounts      e on e.ID=b.AccountsID  '
     +' left outer join DAClient        f on f.ID=a.ClientID       '
     +' left outer join DAGoods         g on g.ID=a.GoodsID        '
     +' left outer join DAProject       h on h.ID=a.ProjectID      '
     +' left outer join MSDepartment    i on i.ID=d.DepartmentID   '
     +' left outer join DAArea          j on j.ID=f.AreaID         '
     +' left outer join DAGoodsClass    k on k.ID=g.GoodsClassID   '
     +' left outer join DAProjectClass  l on l.ID=h.ProjectClassID '
     +' where b.RecordState<>'+ Quotedstr('ɾ��')
     +' and a.ExpenseID<>0 and a.ExpenseID is not null ' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' if exists (select * from dbo.sysobjects where '
      +' id = object_id '
      +' (' +Quotedstr('[dbo].[TempExpenseList]')+') and OBJECTPROPERTY(id,'
      +Quotedstr('IsUserTable')+' ) = 1) drop table [dbo].[TempExpenseList] ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select top 1 * into TempExpenseList from #ExpenseList' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select top 1 * from TempExpenseList' ;
  ADOQuery.open;
  ExpSttcCheckListBox.Columns :=4;
  ExpSttcCheckListBox.Items.Clear;
  ExpSttcCheckListBox.Hint :='';
  WNADOCQuery1.Field.Clear;
  for I := 0 to ADOQuery.Fields.Count - 1 do
  begin
    if not (ADOQuery.Fields[i] is TNumericField)  then
       ExpSttcCheckListBox.Items.Add(Trim(ADOQuery.Fields[i].FieldName))
     else
       ExpSttcCheckListBox.Hint :=ExpSttcCheckListBox.Hint
         +', sum(isnull('+Trim(ADOQuery.Fields[i].FieldName)+',0)) as ['
         +Trim(ADOQuery.Fields[i].FieldName)+'] ';
     WNADOCQuery1.Field.Add(Trim(ADOQuery.Fields[i].FieldName));
  end;
  WhereStr :=' where  1=1 ';
  Memo1.Text :='����������!';
  SelectStr :='';
end;

procedure TFNExpenseSttcForm.Button1Click(Sender: TObject);
begin
  Panel6.Visible :=True;
  Panel6.Repaint;
  Button1.Tag:=1 ;
  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseList'+WhereStr ;
//  showmessage(adsMaster.CommandText);
  adsMaster.open;
  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='';
end;

procedure TFNExpenseSttcForm.FormActivate(Sender: TObject);
begin
  inherited;
  ADOQuery.Close;
  ADOQuery.SQL.Text :='select max(����) MDate  from #ExpenseList ';
  ADOQuery.Open;
  if ADOQuery.FieldByName('MDate').IsNull then WhereStr :=Datetostr(date)
    else WhereStr :=Trim(ADOQuery.fieldbyname('MDate').AsString);
  Memo1.ReadOnly :=False;
  Memo1.Clear;
  Memo1.Text :=' ���� ����'+ Quotedstr(WhereStr);
  Memo1.ReadOnly :=True;
  WhereStr :=' where [����]='+Quotedstr(WhereStr);    
  Button1Click(sender);
end;

procedure TFNExpenseSttcForm.Button2Click(Sender: TObject);
var I :integer;
    SelectStr1 :string;
begin
  inherited;
  Panel6.Visible :=True;
  Panel6.Repaint;
  Button1.Tag:=0;
  if Trim(SelectStr) ='' then
    begin
      ExpSttcCheckListBox.Checked[1] :=true;
      ExpSttcCheckListBox.ItemIndex := 1;
      ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
    end;
  SelectStr1 :=Trim(SelectStr);
  while Pos(',', SelectStr1)=1 do  SelectStr1[Pos(',', SelectStr1)] :=' ';

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseListTtl')
        +' )) DROP TABLE #ExpenseListTtl ' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text:=' select ' + SelectStr1+ ExpSttcCheckListBox.hint
    +',sum(0.00) [ƽ���ο�����] into #ExpenseListTtl from #ExpenseList  '
    +WhereStr +' group by '+SelectStr1;
  ADOQuery.ExecSQL;

  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseListTtl ';
  adsMaster.open;

  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;
end;

procedure TFNExpenseSttcForm.N1Click(Sender: TObject);
begin
  ExpSttcCheckListBox.Sorted :=not ExpSttcCheckListBox.Sorted;
end;

procedure TFNExpenseSttcForm.N2Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=not ExpSttcCheckListBox.Checked[I];
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TFNExpenseSttcForm.N3Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=True;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TFNExpenseSttcForm.N4Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=False;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TFNExpenseSttcForm.adsMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  adsMaster.IndexFieldNames := '';
end;

procedure TFNExpenseSttcForm.DateTimePicker2Exit(Sender: TObject);
begin
  inherited;
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker1.Date :=DateTimePicker2.Date;
end;

procedure TFNExpenseSttcForm.DateTimePicker1Exit(Sender: TObject);
begin
  inherited;
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker2.Date :=DateTimePicker1.Date;
end;

procedure TFNExpenseSttcForm.Button4Click(Sender: TObject);
var year,month,day:word;
begin
  inherited;
  Panel2.Enabled :=False;
  DBGrid.Enabled :=False;
  VipsetPanel.Visible :=True;
  VipsetPanel.Repaint;
//  DateTimePicker1.Date :=date;
//  DateTimePicker2.Date :=EndoftheMonth(date);
  DecodeDate(date,year,month,day)  ;
  DateTimePicker1.Date :=Encodedate(year,month,1);
  DateTimePicker2.Date :=date;
end;

procedure TFNExpenseSttcForm.Button6Click(Sender: TObject);
begin
  inherited;
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  VipsetPanel.Visible :=False;
end;

procedure TFNExpenseSttcForm.Button5Click(Sender: TObject);
begin
  inherited;
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  VipsetPanel.Visible :=False;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList0')
        +' )) DROP TABLE #ExpenseList0' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select * into #ExpenseList0 from #ExpenseList'
    +' where [����] >='+Quotedstr(Datetostr(DateTimePicker1.Date))
    +' and [����] <='+Quotedstr(Datetostr(DateTimePicker2.Date));
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into  #ExpenseList0 '
    +' ([����],[ҵ�����],[��������],[���ý��],[�ο�����] )'
    +' select '+Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('�ڳ���ת')+' as [ҵ�����],'
    +' [��������],sum(isnull([���ý��],0)), '
    +' sum(isnull([�ο�����],0)) from #ExpenseList '
    +' where [����] <'+Quotedstr(Datetostr(DateTimePicker1.Date))
    +' Group by [����],[ҵ�����],[��������]';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
    +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList')
    +' )) DROP TABLE #ExpenseList' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select * into #ExpenseList from #ExpenseList0'
    +' where [����] is not null '
    +' order by [����]  ' ;
  ADOQuery.ExecSQL;
  if Button1.Tag=1 then Button1Click(sender);
  if Button1.Tag=0 then Button2Click(sender);
  if Button1.Tag=2 then Button7Click(sender);
end;

procedure TFNExpenseSttcForm.ExpSttcCheckListBoxClickCheck(
  Sender: TObject);
var CheckStr :string;
begin
  CheckStr :=','+Trim(ExpSttcCheckListBox.Items[ExpSttcCheckListBox.ItemIndex]);
  if (ExpSttcCheckListBox.Checked[ExpSttcCheckListBox.ItemIndex]) and
     (pos(CheckStr,SelectStr)<=0) then  SelectStr :=Trim(SelectStr)+Trim(CheckStr);

  if (not ExpSttcCheckListBox.Checked[ExpSttcCheckListBox.ItemIndex]) and
     (pos(CheckStr,SelectStr)>0) then
     SelectStr :=StringReplace(SelectStr,CheckStr,'',[rfReplaceAll, rfIgnoreCase]);
end;

procedure TFNExpenseSttcForm.adsMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  RefreshAvailableFields;
end;

procedure TFNExpenseSttcForm.Button7Click(Sender: TObject);
var I :integer;
    SelectStr1 :string;
begin
  inherited;
  PeriodDataUpdate;
//  showmessage(Button7.Hint)  ;
  Panel6.Visible :=True;
  Panel6.Repaint;
  Button1.Tag:=2;
  if Trim(SelectStr) ='' then
    begin
      ExpSttcCheckListBox.Checked[4] :=true;
      ExpSttcCheckListBox.ItemIndex := 4;
      ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
    end;
  SelectStr1 :=Trim(SelectStr);
  while Pos(',', SelectStr1)=1 do  SelectStr1[Pos(',', SelectStr1)] :=' ';

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseListTtl')
        +' )) DROP TABLE #ExpenseListTtl ' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text:=' select ' + SelectStr1+ Button7.hint
    +'  into #ExpenseListTtl from #ExpenseList0 '
    +WhereStr +' group by '+SelectStr1;
  ADOQuery.ExecSQL;

  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseListTtl ';
  adsMaster.open;

  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;
end;

procedure TFNExpenseSttcForm.PeriodMonthRadioButtonClick(Sender: TObject);
begin
  inherited;
  PeriodMonthComboBox.Enabled :=PeriodMonthRadioButton.Checked;
  PeriodDaysComboBox.Enabled  :=not PeriodMonthRadioButton.Checked;
end;

procedure TFNExpenseSttcForm.PeriodDataUpdate;
var I :integer;
    SelectStr1,StrDate1,StrDate2,StrDate3,StrDate4,StrDate5,StrDate6,
    StrFeildName0,StrFeildName1,StrFeildName2,StrFeildName3,StrFeildName4,
    StrFeildName5,StrFeildName6 :string;
    year,month,day :word;
begin
  inherited;
  if PeriodMonthRadioButton.Checked then
  begin
    I:=strtoint(PeriodMonthComboBox.Text);
    DecodeDate(Date,year, month, day);
    EnCodeDate(year,month,1);
    StrDate1 :=Datetostr(EnCodeDate(year,month,1));
    StrFeildName1 :='['+Inttostr(year)+'��'+Inttostr(month)+'��]';
    month :=month-I;
    if month<0 then
    begin
      month :=12+month;
      year :=year-1;
    end;

    StrDate2 :=Datetostr(EnCodeDate(year,month,1));
    StrFeildName2 :='['+Inttostr(year)+'��'+Inttostr(month)+'��]';
    month :=month-I;
    if month<0 then
    begin
      month :=12+month;
      year :=year-1;
    end;

    StrDate3 :=Datetostr(EnCodeDate(year,month,1));
    StrFeildName3 :='['+Inttostr(year)+'��'+Inttostr(month)+'��]';
    month :=month-I;
    if month<0 then
    begin
      month :=12+month;
      year :=year-1;
    end;

    StrDate4 :=Datetostr(EnCodeDate(year,month,1));
    StrFeildName4 :='['+Inttostr(year)+'��'+Inttostr(month)+'��]';
    month :=month-I;
    if month<0 then
    begin
      month :=12+month;
      year :=year-1;
    end;

    StrDate5 :=Datetostr(EnCodeDate(year,month,1));
    StrFeildName5 :='['+Inttostr(year)+'��'+Inttostr(month)+'��]';
    month :=month-I;
    if month<0 then
    begin
      month :=12+month;
      year :=year-1;
    end;

    StrDate6 :=Datetostr(EnCodeDate(year,month,1));
    StrFeildName6 :='['+Inttostr(year)+'��'+Inttostr(month)+'��]';
    month :=month-I;
    if month<0 then
    begin
      month :=12+month;
      year :=year-1;
    end;
    StrFeildName0 :='[����Ԥ��]';
  end else
  begin
    I:=strtoint(PeriodDaysComboBox.Text);
    StrDate1 :=Datetostr(Date-I);
    StrFeildName1 :='[С�ڵ���'+Inttostr(I*1)+'��]';

    StrDate2 :=Datetostr(Date-I*2);
    StrFeildName2 :='[����'+Inttostr(I*1)+'��'+Inttostr(I*2)+'��]';

    StrDate3 :=Datetostr(Date-I*3);
    StrFeildName3 :='[����'+Inttostr(I*2)+'��'+Inttostr(I*3)+'��]';

    StrDate4 :=Datetostr(Date-I*4);
    StrFeildName4 :='[����'+Inttostr(I*3)+'��'+Inttostr(I*4)+'��]';

    StrDate5 :=Datetostr(Date-I*5);
    StrFeildName5 :='[����'+Inttostr(I*4)+'��'+Inttostr(I*5)+'��]';

    StrDate6 :=Datetostr(Date-I*6);
    StrFeildName6 :='[����'+Inttostr(I*5)+'��]';
    StrFeildName0 :='[����Ԥ��]';
  end;

  Panel6.Visible :=True;
  Panel6.Repaint;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList0')
        +' )) DROP TABLE #ExpenseList0 ' ;
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select *  '
     +' ,[���ý��] as '+StrFeildName6
     +' ,[���ý��] as '+StrFeildName5
     +' ,[���ý��] as '+StrFeildName4
     +' ,[���ý��] as '+StrFeildName3
     +' ,[���ý��] as '+StrFeildName2
     +' ,[���ý��] as '+StrFeildName1
     +' ,[���ý��] as [���úϼ�] '
     +' ,[���ý��] as '+StrFeildName0
     +' into #ExpenseList0 from #ExpenseList '
     +' where 1=2 ' ;
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN [�ο�����] Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN [���ý��] Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN [���úϼ�] Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN '+StrFeildName6+' Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN '+StrFeildName5+' Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN '+StrFeildName4+' Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN '+StrFeildName3+' Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN '+StrFeildName2+' Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN '+StrFeildName1+' Float NULL  ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' ALTER TABLE #ExpenseList0 ALTER COLUMN '+StrFeildName0+' Float NULL  ';
  ADOQuery.ExecSQL;

  { ADOQuery.Close;
  ADOQuery.SQL.Text:=' Truncate Table #ExpenseList0 ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text:=' ALTER TABLE ABC3 DROP COLUMN [���ý��] ';
  ADOQuery.ExecSQL;}

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Insert into #ExpenseList0 ( '
    +' [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],                 '
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],           '
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע]               '
    +' , '+StrFeildName1
    +' ) select [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],'
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],'
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע],[���ý��]'
    +' from #ExpenseList  '
    +' where [����]>='+Quotedstr(StrDate1);
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Insert into #ExpenseList0 ( '
    +' [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],                 '
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],           '
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע]               '
    +' , '+StrFeildName2
    +' ) select [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],'
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],'
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע],[���ý��]'
    +' from #ExpenseList  '
    +' where [����]>='+Quotedstr(StrDate2)
    +' and  [����]<'+Quotedstr(StrDate1);
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Insert into #ExpenseList0 ( '
    +' [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],                 '
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],           '
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע]               '
    +' , '+StrFeildName3
    +' ) select [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],'
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],'
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע],[���ý��]'
    +' from #ExpenseList  '
    +' where [����]>='+Quotedstr(StrDate3)
    +' and  [����]<'+Quotedstr(StrDate2);
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Insert into #ExpenseList0 ( '
    +' [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],                 '
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],           '
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע]               '
    +' , '+StrFeildName4
    +' ) select [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],'
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],'
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע],[���ý��]'
    +' from #ExpenseList  '
    +' where [����]>='+Quotedstr(StrDate4)
    +' and  [����]<'+Quotedstr(StrDate3);
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Insert into #ExpenseList0 ( '
    +' [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],                 '
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],           '
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע]               '
    +' , '+StrFeildName5
    +' ) select [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],'
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],'
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע],[���ý��]'
    +' from #ExpenseList  '
    +' where [����]>='+Quotedstr(StrDate5)
    +' and  [����]<'+Quotedstr(StrDate4);
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Insert into #ExpenseList0 ( '
    +' [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],                 '
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],           '
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע]               '
    +' , '+StrFeildName6
    +' ) select [����],[���],[ҵ�����],[ժҪ],[��������],[�ܿ���],'
    +' [������],[�ͻ�����],[�ʲ�����],[��Ŀ����],[��������],[��������],'
    +' [�ʲ����],[��Ŀ���],[�����ʻ�],[Ʊ�ݺ���],[ҵ��ע],[��ע],[���ý��]'
    +' from #ExpenseList  '
    +' where [����]<'+Quotedstr(StrDate5);
//    +' and  [����]<'+Quotedstr(StrDate5);
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Update #ExpenseList0 set [���úϼ�]=( '
    +' Isnull('+StrFeildName6+',0) + '
    +' Isnull('+StrFeildName5+',0) + '
    +' Isnull('+StrFeildName4+',0) + '
    +' Isnull('+StrFeildName3+',0) + '
    +' Isnull('+StrFeildName2+',0) + '
    +' Isnull('+StrFeildName1+',0) ) '  ;
  ADOQuery.ExecSQL;
  Button7.Hint :='';
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull('+StrFeildName6+',0)) as '+StrFeildName6;
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull('+StrFeildName5+',0)) as '+StrFeildName5;
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull('+StrFeildName4+',0)) as '+StrFeildName4;
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull('+StrFeildName3+',0)) as '+StrFeildName3;
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull('+StrFeildName2+',0)) as '+StrFeildName2;
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull('+StrFeildName1+',0)) as '+StrFeildName1;
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull('+StrFeildName0+',0)) as '+StrFeildName0;
  Button7.Hint :=Button7.Hint+', '+'Sum(Isnull([���úϼ�],0)) as [���úϼ�]';
end;

end.
