unit STStockStatistic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, GEdit,
  DBCtrls, Menus, WNADOCQuery,TypInfo, CheckLst;

type
  TSTStockStatisticForm = class(TWSVoucherBrowseForm)
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

  private
    { Private declarations }
    WhereStr,SelectStr :string;
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  STStockStatisticForm: TSTStockStatisticForm;

implementation

uses CommonDM,QLDBFlt;

{$R *.dfm}

function TSTStockStatisticForm.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TSTStockStatisticForm.UpdateDBGrid;
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

procedure TSTStockStatisticForm.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

procedure TSTStockStatisticForm.DBGridDblClick(Sender: TObject);
begin
// inherited;
end;


procedure TSTStockStatisticForm.Button3Click(Sender: TObject);
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

procedure TSTStockStatisticForm.FormShow(Sender: TObject);
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
      +' b.Code [���],                        '
      +' b.BillMode [ҵ�����],                '
      +' c.name  [�ֿ�����],                   '
      +' e.name [��Ʒ����],                    '
      +' a.GoodsSpec [����ͺ�],               '

      +' 0.00  [�ڳ���װ����],     '
      +' f.name     [�ڳ���װ��λ],                '
      +' 0.00 [�ڳ�����],               '
      +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�ڳ����],                  '
      +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�ڳ���׼����],            '
      +' g.name [�ڳ���׼��λ],                    '
      +' a.PriceCost [�ڳ���׼����],                '

      +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����װ����],     '
      +' f.name     [����װ��λ],                '
      +' a.PriceBase [��ⵥ��],               '
      +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����],                  '
      +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����׼����],            '
      +' g.name [����׼��λ],                    '
      +' a.PriceCost [����׼����],                '


      +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����װ����],     '
      +' f.name     [����װ��λ],                '
      +' a.PriceBase [��ⵥ��],               '
      +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����],                  '
      +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����׼����],            '
      +' g.name [����׼��λ],                    '
      +' a.PriceCost [����׼����],                '

      +' 0.00  [�ڳ���װ����],     '
      +' f.name     [�ڳ���װ��λ],                '
      +' 0.00 [�ڳ�����],               '
      +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�ڳ����],                  '
      +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�ڳ���׼����],            '
      +' g.name [�ڳ���׼��λ],                    '
      +' a.PriceCost [�ڳ���׼����],                '

      +' into #ExpenseList '
      +' from SLSaleDetail a                   '
      +' left outer join SLSaleMaster     b on b.ID=a.MasterID      '
      +' left outer join DAClient         c on c.ID=b.ClientID      '
      +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
      +' left outer join DAGoods          e on e.ID=a.GoodsID       '
      +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
      +' left outer join MSUnit           g on g.ID=a.GoalUnitID    '
      +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
      +' left outer join DAArea           i on c.ID=c.AreaID        '
      +' where b.RecordState<>'+ Quotedstr('ɾ��')
      +' and a.GoodsID is not null and a.GoodsID <>0 '
      +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [������]=null,[�ۿ۷������]=null,[���ӷ���]=null,[��׼����]=null ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [��׼����]=[���۽��]/[��׼����]'
      +' where [��׼����]<>0 and [��׼����] is not null ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into #ExpenseList ( [����], '
      +' [���], [ҵ�����],[ժҪ],[�ͻ�����],[������], '
      +' [��ע],[���ӷ���])                 '
      +' select a.Date [����],a.Code [���],            '
      +' a.BillMode [ҵ�����],a.Brief [ժҪ],          '
      +' b.name  [�ͻ�����], c.name  [������] ,          '
      +' a.memo  [��ע],a.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)  [���ӷ���] '
      +' from SLSaleMaster a  '
      +' left outer join DAClient         b on b.ID=a.ClientID      '
      +' left outer join MSEmployee       c on c.ID=a.EmployeeID    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' and a.SundryFee is not null and a.SundryFee<>0 '
      +' and a.ClientID is not null and a.ClientID<>0 ' ;  //���븽�ӷ��ü�¼
  ADOQuery.ExecSQL;


  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into #ExpenseList ( [����], '
      +' [���], [ҵ�����],[ժҪ],[�ͻ�����],[������], '
      +' [��ע],[������],[�ۿ۷������] )                 '
      +' select a.Date [����],a.Code [���],            '
      +' a.BillMode [ҵ�����],a.Brief [ժҪ],          '
      +' b.name  [�ͻ�����],c.name  [������] ,          '
      +' a.memo  [��ע],a.AmountD [������],           '
      +' a.AmountRed [�ۿ۷������] from FNClearSLMaster a  '
      +' left outer join DAClient         b on b.ID=a.ClientID      '
      +' left outer join MSEmployee       c on c.ID=a.EmployeeID    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' and a.ClientID is not null and a.ClientID<>0 ' ;   //��������¼
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

procedure TSTStockStatisticForm.Button1Click(Sender: TObject);
begin
  Panel6.Visible :=True;
  Panel6.Repaint;
  Button1.Tag:=1 ;
  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseList'+WhereStr
      +' order by [����], [���]' ;
//  showmessage(adsMaster.CommandText);
  adsMaster.open;
  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='';
end;

procedure TSTStockStatisticForm.FormActivate(Sender: TObject);
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

procedure TSTStockStatisticForm.Button2Click(Sender: TObject);
var I :integer;
    SelectStr1:String;
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
    +' into #ExpenseListTtl from #ExpenseList  '
    +WhereStr +' group by '+SelectStr1;
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' update #ExpenseListTtl set [��׼����]= '
     +' [���۽��]/[��׼����] where [��׼����]<>0 ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' update #ExpenseListTtl set [���۵���]= '
     +' [���۽��]/[��װ����] where [��װ����]<>0 ';
  ADOQuery.ExecSQL;

  adsMaster.Close;
  adsMaster.CommandText:=' select *,([���۽��]+[���ӷ���]-[������]- '
     +' [�ۿ۷������]) as [Ӧ���ʿ����] from #ExpenseListTtl ';
  adsMaster.open;


  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;
end;

procedure TSTStockStatisticForm.N1Click(Sender: TObject);
begin
  ExpSttcCheckListBox.Sorted :=not ExpSttcCheckListBox.Sorted;
end;

procedure TSTStockStatisticForm.N2Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=not ExpSttcCheckListBox.Checked[I];
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTStockStatisticForm.N3Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=True;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTStockStatisticForm.N4Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=False;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTStockStatisticForm.adsMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  adsMaster.IndexFieldNames := '';
end;

procedure TSTStockStatisticForm.DateTimePicker2Exit(Sender: TObject);
begin
  inherited;
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker1.Date :=DateTimePicker2.Date;
end;

procedure TSTStockStatisticForm.DateTimePicker1Exit(Sender: TObject);
begin
  inherited;
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker2.Date :=DateTimePicker1.Date;
end;

procedure TSTStockStatisticForm.Button4Click(Sender: TObject);
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

procedure TSTStockStatisticForm.Button6Click(Sender: TObject);
begin
  inherited;
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  VipsetPanel.Visible :=False;
end;

procedure TSTStockStatisticForm.Button5Click(Sender: TObject);
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
    +' ([����],[ҵ�����],[�ͻ�����],[���۽��],[������],[�ۿ۷������] )'
    +' select '+Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('�ڳ���ת')+' as [ҵ�����],'
    +' [�ͻ�����],sum(isnull([���۽��],0)), '
    +' sum(isnull([������],0)) ,sum(isnull([�ۿ۷������],0)) '
    +' from #ExpenseList '
    +' where [����] <'+Quotedstr(Datetostr(DateTimePicker1.Date))
    +' Group by [����],[ҵ�����],[�ͻ�����]';
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
  if Button1.Tag=1 then Button1Click(sender)
    else Button2Click(sender);
end;

procedure TSTStockStatisticForm.ExpSttcCheckListBoxClickCheck(
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

end.
