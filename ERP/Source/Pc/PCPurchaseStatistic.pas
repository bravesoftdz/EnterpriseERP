unit PCPurchaseStatistic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, GEdit,
  DBCtrls, Menus, WNADOCQuery,TypInfo, CheckLst;

type
  TPCPurchaseStatisticForm = class(TWSVoucherBrowseForm)
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
    ClientAccountLiast: TToolButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    AccountListQry: TADOQuery;
    AccountListQryDSDesigner: TDateTimeField;
    AccountListQryDSDesigner2: TStringField;
    AccountListQryDSDesigner3: TStringField;
    AccountListQryDSDesigner6: TBCDField;
    AccountListQryDSDesigner7: TStringField;
    AccountListQryDSDesigner4: TBCDField;
    AccountListQryDSDesigner5: TBCDField;
    ListClientSaleAct: TAction;
    ListClientSale: TMenuItem;
    ListGoodsSaleAct: TAction;
    ListGoodsSale: TMenuItem;
    ToolButton1: TToolButton;
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
    procedure ClientAccountLiastClick(Sender: TObject);
    procedure ListClientSaleActExecute(Sender: TObject);
    procedure ListGoodsSaleActExecute(Sender: TObject);
    procedure adsMasterAfterOpen(DataSet: TDataSet);

  private
    { Private declarations }
    WhereStr,SelectStr:string;
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  PCPurchaseStatisticForm: TPCPurchaseStatisticForm;

implementation

uses CommonDM,QLDBFlt,WSSecurity,PCRpCheckReckoning,QLRptBld;

{$R *.dfm}

function TPCPurchaseStatisticForm.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TPCPurchaseStatisticForm.UpdateDBGrid;
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

procedure TPCPurchaseStatisticForm.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

procedure TPCPurchaseStatisticForm.DBGridDblClick(Sender: TObject);
begin
// inherited;
end;


procedure TPCPurchaseStatisticForm.Button3Click(Sender: TObject);
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

procedure TPCPurchaseStatisticForm.FormShow(Sender: TObject);
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
      +' b.Brief [ժҪ],                       '
      +' c.name  [��������],                   '
      +' d.name  [������] ,                    '
      +' b.ClearDate [��������] ,              '
      +' b.memo  [��ע],                       '
      +' e.name [��Ʒ����],                    '
      +' a.GoodsSpec [����ͺ�],               '
      +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
      +' f.name     [��װ��λ],                '
      +' a.PriceBase [�ɹ�����],               '
      +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�ɹ����],                  '
      +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
      +' g.name [��׼��λ],                    '
      +' a.PriceCost [��׼����],                '
//      +' a.PriceCost [�ɱ�����],               '
      +' a.PriceCost [���ӷ���],             '
      +' a.PriceCost  [������],               '
      +' a.PriceCost  [�ۿ۷������],               '
      +' h.name [��Ʒ���],                    '
      +' i.name [��������],                    '
      +' L.name [��������],                    '
      +' a.memo [��ע]                         '
      +' into #ExpenseList '
      +' from PCPurchaseDetail a                   '
      +' left outer join PCPurchaseMaster     b on b.ID=a.MasterID      '
      +' left outer join DAClient         c on c.ID=b.ClientID      '
      +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
      +' left outer join DAGoods          e on e.ID=a.GoodsID       '
      +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
      +' left outer join MSUnit           g on g.ID=e.UnitID    '
      +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
      +' left outer join DAArea           i on i.ID=c.AreaID        '
      +' left outer join MSDepartment     l on l.ID=d.DepartmentID        '
      +' where b.RecordState<>'+ Quotedstr('ɾ��')
      +' and isnull(a.GoodsID,0) <>0 '
      +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [������]=null ,[�ۿ۷������]=null ,[���ӷ���]=null,[��׼����]=null ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [��׼����]=[�ɹ����]/[��׼����] '
      +' where [��׼����]<>0 and [��׼����] is not null ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into #ExpenseList ( [����], '
      +' [���], [ҵ�����],[ժҪ],[��������],[������], '
      +' [��ע],[���ӷ���])                 '
      +' select a.Date [����],a.Code [���],            '
      +' a.BillMode [ҵ�����],a.Brief [ժҪ],          '
      +' b.name  [��������],c.name  [������] ,          '
      +' a.memo  [��ע],a.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)  [���ӷ���] '
      +' from PCPurchaseMaster a  '
      +' left outer join DAClient         b on b.ID=a.ClientID      '
      +' left outer join MSEmployee       c on c.ID=a.EmployeeID    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' and isnull(a.SundryFee,0) <>0 '
      +' and isnull(a.ClientID,0) <>0  ';  //���븽�ӷ��ü�¼
  ADOQuery.ExecSQL;


  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into #ExpenseList ( [����], '
      +' [���], [ҵ�����],[ժҪ],[��������],[������], '
      +' [��ע],[������],[�ۿ۷������] )                 '
      +' select a.Date [����],a.Code [���],            '
      +' a.BillMode [ҵ�����],a.Brief [ժҪ],          '
      +' b.name  [��������],c.name  [������] ,          '
      +' a.memo  [��ע],a.AmountC [������],           '
      +' a.AmountRed [�ۿ۷������] from FNClearPCMaster a  '
      +' left outer join DAClient         b on b.ID=a.ClientID      '
      +' left outer join MSEmployee       c on c.ID=a.EmployeeID    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' and isnull(a.ClientID,0) <>0   ';  //��������¼
  ADOQuery.ExecSQL;

  if Guarder.UserName<>'ϵͳ����Ա' then
  begin
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' delete from #ExpenseList '
        +' where [��������] not in ( select b.name  '
        +' from MSRolePermissions a '
        +' left outer join MSPermission b on b.ID=a.PermissionID '
        +' where b.PermissionClass='+Quotedstr('X-�鿴����')
        +' and a.RoleID= '+ inttostr(Guarder.UserID)+' ) ';
    ADOQuery.ExecSQL;
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' delete from #ExpenseList '
        +' where [������] not in ( select b.name  '
        +' from MSRolePermissions a '
        +' left outer join MSPermission b on b.ID=a.PermissionID '
        +' where b.PermissionClass='+Quotedstr('Y-�鿴ҵ��')
        +' and a.RoleID= '+ inttostr(Guarder.UserID)+' ) ';
    ADOQuery.ExecSQL;
  end;


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

procedure TPCPurchaseStatisticForm.Button1Click(Sender: TObject);
begin
  Panel6.Visible :=True;
  Panel6.Repaint;
  Button1.Tag:=1 ;
  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseList'+WhereStr
  +' order by [����],[���]' ;
//  showmessage(adsMaster.CommandText);
  adsMaster.open;
  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='';
end;

procedure TPCPurchaseStatisticForm.FormActivate(Sender: TObject);
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

procedure TPCPurchaseStatisticForm.Button2Click(Sender: TObject);
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
  if  pos('��������',SelectStr1)>0 then
  begin
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
          +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList0')
          +' )) DROP TABLE #ExpenseList0 ' ;
    ADOQuery.ExecSQL;
    //������ϸ��ˮ����------
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' select *,  '
      +' [������] [�������ý��],'
      +' [������] [����Ԥ�����] '
      +' into #ExpenseList0  from #ExpenseList  ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text :=' Update #ExpenseList0 set [�������ý��]=0,'
      +' [����Ԥ�����]=0 ' ;
    ADOQuery.ExecSQL;

    //����Ԥ������ ==========
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' insert into  #ExpenseList0 ( '
      +' [��Ʒ����],[�������ý��] ) '
      +' select b.name [��Ʒ����], a.QuotaAmount [�������ý��] '
      +' from PCCredit a                  '
      +' left outer join DAClient b on b.ID=a.ClientID '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' and Isnull(a.QuotaAmount,0)<>0 ';
    ADOQuery.ExecSQL;
    ADOQuery.Close;
    ADOQuery.SQL.Text:=' select ' + SelectStr1+ ExpSttcCheckListBox.hint
      +' , Sum(Isnull([�������ý��],0)) [Ӧ���ʿ����]  '
      +' , Sum(Isnull([�������ý��],0)) [�������ý��]  '
      +' , Sum(Isnull([�������ý��],0)) [����Ԥ�����]  '
      +' into #ExpenseListTtl from #ExpenseList0  '
      +WhereStr +' group by '+SelectStr1;
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [��׼����]=null ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [��׼����]= '
       +' [�ɹ����]/[��׼����] where [��׼����]<>0 ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [Ӧ���ʿ����]= '
      +' ( Isnull([�ɹ����],0)+Isnull([���ӷ���],0) -Isnull([������],0) - '
      +' Isnull([�ۿ۷������],0) ) ,'
      +' [����Ԥ�����]= Isnull([�������ý��],0) -'
      +' ( Isnull([�ɹ����],0)+Isnull([���ӷ���],0) -Isnull([������],0) - '
      +' Isnull([�ۿ۷������],0) ) ';
    ADOQuery.ExecSQL;


    adsMaster.Close;
    adsMaster.CommandText:=' select * from #ExpenseListTtl ';
    adsMaster.open;
  end else
  begin
    ADOQuery.Close;
    ADOQuery.SQL.Text:=' select ' + SelectStr1+ ExpSttcCheckListBox.hint
      +' into #ExpenseListTtl from #ExpenseList  '
      +WhereStr +' group by '+SelectStr1;
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [��׼����]=null ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [��׼����]= '
       +' [�ɹ����]/[��׼����] where [��׼����]<>0 ';
    ADOQuery.ExecSQL;

    adsMaster.Close;
    adsMaster.CommandText:=' select *,(Isnull([�ɹ����],0)+Isnull([���ӷ���],0) '
      +' -Isnull([������],0) - '
      +' Isnull([�ۿ۷������],0) ) as [Ӧ���ʿ����] from #ExpenseListTtl ';
    adsMaster.open;
  end;


  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;

end;

procedure TPCPurchaseStatisticForm.N1Click(Sender: TObject);
begin
  ExpSttcCheckListBox.Sorted :=not ExpSttcCheckListBox.Sorted;
end;

procedure TPCPurchaseStatisticForm.N2Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=not ExpSttcCheckListBox.Checked[I];
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TPCPurchaseStatisticForm.N3Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=True;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TPCPurchaseStatisticForm.N4Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=False;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TPCPurchaseStatisticForm.adsMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  adsMaster.IndexFieldNames := '';
end;

procedure TPCPurchaseStatisticForm.DateTimePicker2Exit(Sender: TObject);
begin
  inherited;
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker1.Date :=DateTimePicker2.Date;
end;

procedure TPCPurchaseStatisticForm.DateTimePicker1Exit(Sender: TObject);
begin
  inherited;
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker2.Date :=DateTimePicker1.Date;
end;

procedure TPCPurchaseStatisticForm.Button4Click(Sender: TObject);
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

procedure TPCPurchaseStatisticForm.Button6Click(Sender: TObject);
begin
  inherited;
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  VipsetPanel.Visible :=False;
end;

procedure TPCPurchaseStatisticForm.Button5Click(Sender: TObject);
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
    +' ([����],[���],[ҵ�����],[��������],[�ɹ����],[������],[�ۿ۷������] )'
    +' select '+Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , ' +Quotedstr('�ڳ���ת')+' as [ҵ�����],'
    +' [��������],sum(isnull([�ɹ����],0)), '
    +' sum(isnull([������],0)) ,sum(isnull([�ۿ۷������],0)) '
    +' from #ExpenseList '
    +' where [����] <'+Quotedstr(Datetostr(DateTimePicker1.Date))
    +' Group by [����],[ҵ�����],[��������]';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into  #ExpenseList0 '
    +' ( [��������],[����],[���],[ҵ�����] )'
    +' select Distinct [��������],  '
    + Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')
    +' from #ExpenseList '
    +' where [��������] not in ( select distinct [��������] from #ExpenseList0  '
    +' where [ҵ�����]='+ Quotedstr('�ڳ���ת')+' ) ' ;
  ADOQuery.ExecSQL ;



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

procedure TPCPurchaseStatisticForm.ExpSttcCheckListBoxClickCheck(
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

procedure TPCPurchaseStatisticForm.ClientAccountLiastClick(
  Sender: TObject);
var BalanceF:real;
    I:Integer;
begin
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select * from #ExpenseList where [ҵ�����]='+Quotedstr('�ڳ���ת');
  ADOQuery.Open;
  if ADOQuery.IsEmpty then
  begin
    ShowMessage('���ڡ��߼�..�����ö������ڣ���ȷ��������ִ�д˹���!');
//    Button4.OnClick(sneder);
    Exit;
  end;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select distinct [��������] from #ExpenseList ' + WhereStr;
  ADOQuery.Open;
  ADOQuery.First;
  while not ADOQuery.Eof do
  begin
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
          +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ClientAccountList')
          +' )) DROP TABLE #ClientAccountList' ;
    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' CREATE TABLE #ClientAccountList ( '
	+' [ID] [int] IDENTITY (1, 1) NOT NULL , '
	+' [����] [datetime] NULL ,              '
	+' [���] [varchar] (20)  NULL ,         '
	+' [ҵ�����] [varchar] (16) NULL ,      '
	+' [�ɹ����] [Float] NULL ,      '
	+' [������] [Float] NULL ,      '
	+' [���] [Float] NULL ,        '
	+' [��ע] [varchar] (30)  NULL     '
	+' )  ';
    ADOQuery2.ExecSQL;
//    ADOQuery2.Close;
//    ADOQuery2.SQL.Text :=' Truncate TABLE #ClientAccountList ';
//    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '
      +'        [����],[���],[ҵ�����],[�ɹ����],[������] )'
      +' select [����],[���],[ҵ�����],'
      +' sum(isnull([�ɹ����],0)) as [�ɹ����] , '
      +' sum(isnull([������],0)) as [������] '
      +' from #ExpenseList '
      +' where [��������]='+Quotedstr(ADOQuery.FieldByName('��������').AsString)
      +' Group by [����],[���],[ҵ�����] '
      +' order by [����]';
    ADOQuery2.ExecSQL;

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '
      +'        [����],[���],[ҵ�����],[������] )'
      +' select [����],[���],[ҵ�����],'
      +' sum(isnull([�ۿ۷������],0)) as  [������] '
      +' from #ExpenseList '
      +' where [��������]='+Quotedstr(ADOQuery.FieldByName('��������').AsString)
      +' and isnull([�ۿ۷������],0)<>0  '
      +' Group by [����],[���],[ҵ�����] '
      +' order by [����]';
    ADOQuery2.ExecSQL;

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' select * from  #ClientAccountList order by [����],[ID]';
    ADOQuery2.open;
    BalanceF := 0;
    BalanceF := BalanceF+ ADOQuery2.FieldByName('�ɹ����').AsFloat-
         ADOQuery2.FieldByName('������').AsFloat;
    ADOQuery2.Edit;
    ADOQuery2.FieldByName('�ɹ����').AsFloat :=0;
    ADOQuery2.FieldByName('������').AsFloat :=0;
    while not ADOQuery2.Eof do
    begin
      BalanceF := BalanceF+ ADOQuery2.FieldByName('�ɹ����').AsFloat-
         ADOQuery2.FieldByName('������').AsFloat;
      ADOQuery2.Edit;
      ADOQuery2.FieldByName('���').AsFloat :=BalanceF;
      ADOQuery2.Next;
    end;
    AccountListQry.Close;
    AccountListQry.SQL.Text :=' select [����],[���],[ҵ�����],[�ɹ����], '
      +'  [������],[���],[��ע] '
      +' from  #ClientAccountList order by [ID] ';
    AccountListQry.open;
    DataSource1.DataSet := AccountListQry;
    DBGrid1.DataSource :=  DataSource1;



//    DBGrid1.Visible :=True;
//    ShowMessage('��鿴--'+ADOQuery.FieldByName('��������').AsString+' --���ʽ��!');
    //�ڴ�ѭ����ӡ���ʵ��������ɺ���Խ� DBGrid1��DataSource1ɾ��
    with TQLDBGridReportBuilder.Create(Self) do
    try
      DBGrid := DBGrid1;
      AutoWidth := True;
      Report := TPCCheckReckoningReport.Create(Self);
      TPCCheckReckoningReport(Report).qrdbtClientName.DataSet := ADOQuery;
      TPCCheckReckoningReport(Report).qrlCheckCourse.Caption :=
        '�����ڼ�: ' + DateToStr(DateTimePicker1.Date) + ' ~ ' +
        DateToStr(DateTimePicker2.Date);
      SummaryFields.Add('�ɹ����=SUM([�ɹ����])');
      SummaryFields.Add('������=SUM([������])');
      SummaryFields.Add('���='+floattostr(BalanceF));
      AutoOrientation := False;
      Active := True;
  //    InitReport(TQuickRep(Report));
    if I<1 then
      Report.PreviewModal
      else Report.Print;
  //    if Preview then Report.PreviewModal
  //    else begin
  //      if ShowSetupDialog then Report.PrinterSetup;
  //      Report.Print;
  //    end;
    finally
      Free;
    end;

    I :=I+1;
    ADOQuery.Next;
//    DBGrid1.Visible :=False;
  end;

end;

procedure TPCPurchaseStatisticForm.ListClientSaleActExecute(
  Sender: TObject);
var I:Integer;
  Goods :string;
begin
  for I:=0 to adsMaster.FieldCount-1 do
  begin
    if Pos('��������',adsMaster.Fields[I].FieldName)>0 then
    begin
      Goods := adsMaster.FieldByName('��������').AsString;
      if Trim(Goods)='' then Exit;
      adsMaster.Close;
      adsMaster.CommandText :='select * from #ExpenseList  where  [��������]='+Quotedstr(Goods);
      adsMaster.Open;
      UpdateDBGrid;
      Exit;
    end;
  end;
end;

procedure TPCPurchaseStatisticForm.ListGoodsSaleActExecute(
  Sender: TObject);
var I:Integer;
  Goods :string;
begin
  for I:=0 to adsMaster.FieldCount-1 do
  begin
    if Pos('��Ʒ����',adsMaster.Fields[I].FieldName)>0 then
    begin
      Goods := adsMaster.FieldByName('��Ʒ����').AsString;
      if Trim(Goods)='' then Exit;
      adsMaster.Close;
      adsMaster.CommandText :='select * from #ExpenseList  where  [��Ʒ����]='+Quotedstr(Goods);
      adsMaster.Open;
      UpdateDBGrid;
      Exit;
    end;
  end;
end;

procedure TPCPurchaseStatisticForm.adsMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  RefreshAvailableFields;
end;

end.
