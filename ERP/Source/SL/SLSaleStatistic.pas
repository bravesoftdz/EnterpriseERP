unit SLSaleStatistic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, GEdit,
  DBCtrls, Menus, WNADOCQuery,TypInfo, CheckLst;

type
  TSLSaleStatisticForm = class(TWSVoucherBrowseForm)
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
    AccountListQryDSDesigner4: TBCDField;
    AccountListQryDSDesigner5: TBCDField;
    AccountListQryDSDesigner7: TStringField;
    ListClientSaleAct: TAction;
    ListClientSale: TMenuItem;
    ListGoodsSaleAct: TAction;
    ListGoodsSale: TMenuItem;
    ShowExpenseCkBx: TCheckBox;
    ShowClientCostCkBx: TCheckBox;
    EmployeeCostCkBx: TCheckBox;
    GoodsStockCkBx: TCheckBox;
    ToolButton1: TToolButton;
    AccountListQryDSDesigner9: TBCDField;
    AccountListQryDSDesigner8: TDateTimeField;
    AccountListQryDSDesigner6: TBCDField;
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
    WhereStr,SelectStr :string;
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  SLSaleStatisticForm: TSLSaleStatisticForm;

implementation

uses CommonDM,QLDBFlt,WSSecurity,QLRptBld,SLRpCheckReckoning,WSUtils;
//CommonDM, QLDBFlt, QLRptBld, SLRpCheckReckoning;
{$R *.dfm}

function TSLSaleStatisticForm.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TSLSaleStatisticForm.UpdateDBGrid;
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

procedure TSLSaleStatisticForm.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

procedure TSLSaleStatisticForm.DBGridDblClick(Sender: TObject);
begin
// inherited;
end;


procedure TSLSaleStatisticForm.Button3Click(Sender: TObject);
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

procedure TSLSaleStatisticForm.FormShow(Sender: TObject);
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
      +' c.name  [�ͻ�����],                   '
      +' d.name  [������] ,                    '
      +' b.ClearDate [��������] ,              '
      +' b.memo  [��ע],                       '
      +' e.name [��Ʒ����],                    '
      +' a.GoodsSpec [����ͺ�],               '
      +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
      +' f.name     [��װ��λ],                '
      +' a.PriceBase [���۵���],               '
      +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���۽��],                  '
      +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
      +' g.name [��׼��λ],                    '
      +' a.PriceGoal [��׼����],                '
      +' a.PriceCost [�ɱ�����],               '
      +' a.PriceCost [���ӷ���],             '
      +' a.PriceCost  [������],               '
      +' a.PriceCost  [�ۿ۷������],               '
      +' h.name [��Ʒ���],                    '
      +' i.name [��������],                    '
      +' L.name [��������],                    '
      +' a.memo [��ע]                         '
      +' into #ExpenseList '
      +' from SLSaleDetail a                   '
      +' left outer join SLSaleMaster     b on b.ID=a.MasterID      '
      +' left outer join DAClient         c on c.ID=b.ClientID      '
      +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
      +' left outer join DAGoods          e on e.ID=a.GoodsID       '
      +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
      +' left outer join MSUnit           g on g.ID=e.UnitID    '
      +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
      +' left outer join DAArea           i on i.ID=c.AreaID        '
      +' left outer join MSDepartment     l on l.ID=d.DepartmentID        '
      +' where b.RecordState<>'+ Quotedstr('ɾ��')
      +' and isnull(a.GoodsID,0)<>0 '
      +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [������]=null,[�ۿ۷������]=null,[���ӷ���]=null ';
  ADOQuery.ExecSQL;

  {ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [��׼����]=[���۽��]/[��׼����]'
      +' where [��׼����]<>0 and [��׼����] is not null ';
  ADOQuery.ExecSQL;   }

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
      +' and Isnull(a.SundryFee,0)<>0 '
      +' and isnull(a.ClientID,0)<>0 ' ;  //���븽�ӷ��ü�¼
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
      +' and isnull(a.ClientID,0)<>0 ' ;  //���븽�ӷ��ü�¼
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

procedure TSLSaleStatisticForm.Button1Click(Sender: TObject);
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

procedure TSLSaleStatisticForm.FormActivate(Sender: TObject);
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

procedure TSLSaleStatisticForm.Button2Click(Sender: TObject);
var I :integer;
    SelectStr1,ExpenseStr,ClientCostStr:String;
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

  if  (pos('�ͻ�����',SelectStr1)>0) or (pos('������',SelectStr1)>0) or (pos('��������',SelectStr1)>0)
  then  begin
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
          +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList0')
          +' )) DROP TABLE #ExpenseList0 ' ;
    ADOQuery.ExecSQL;
    //������ϸ��ˮ����------
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' select *,  '
    +' [������] [����ë��] ,'
    +' [��Ʒ����] [��������] ,'
    +' [������] [���ý��] ,'
    +' [������] [�ͻ��ɱ�], '
    +' [������] [�ͻ����ý��], '
    +' [������] [����Ԥ�����] '
    +' into #ExpenseList0  from #ExpenseList  ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text :=' Update #ExpenseList0 set [�ͻ����ý��]=0,'
      +' [����Ԥ�����]=0 ,[��������]=null ,[���ý��]=0 ,'
      +' [�ͻ��ɱ�]=0 ,'
      +' [����ë��]=Isnull([�ɱ�����],0)*Isnull([��׼����],0) ' ;
    ADOQuery.ExecSQL;

    //����Ԥ������ ==========
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' insert into  #ExpenseList0 ( '
      +' [�ͻ�����],[�ͻ����ý��] ) '
      +' select b.name [�ͻ�����], a.QuotaAmount [�ͻ����ý��] '
      +' from PCCredit a                  '
      +' left outer join DAClient b on b.ID=a.ClientID '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' and Isnull(a.QuotaAmount,0)<>0 ';
    ADOQuery.ExecSQL;

    if ShowExpenseCkBx.Checked then //����ȫ������
    begin
      ADOQuery.Close;
      ADOQuery.SQL.Text :=' insert into  #ExpenseList0 ( '
        +' [����],[���],[ҵ�����],[�ͻ�����],[������], '
        +' [��������], [��������],[���ý��] ) '
        +' select b.date [����],b.Code [���],b.BillMode [ҵ�����],'
        +' c.name [�ͻ�����],d.name [������], e.name  [��������] ,'
        +' f.name [��������],Isnull(Amount,0)  [���ý��]  '
        +' from FNExpenseDetail  a                  '
        +' left outer join FNExpenseMaster b on b.ID=a.MasterID '
        +' left outer join DAClient        c on c.ID=a.ClientID '
        +' left outer join MSEmployee      d on d.ID=b.EmployeeID  '
        +' left outer join MSDepartment    e on e.ID=d.DepartmentID  '
        +' left outer join DAExpenseClass    f on f.ID=a.ExpenseID  '
        +' where b.RecordState<>'+ Quotedstr('ɾ��')
        +' and Isnull(a.Amount,0)<>0 ';
      ADOQuery.ExecSQL;
    end;

    if ShowClientCostCkBx.Checked then //����ͻ��ɱ�
    begin
      ADOQuery.Close;
      ADOQuery.SQL.Text :=' insert into  #ExpenseList0 ( '
        +' [����],[���],[ҵ�����],[�ͻ�����],[������], '
        +' [��������], [��������],[�ͻ��ɱ�] ) '
        +' select b.date [����],b.Code [���],b.BillMode [ҵ�����],'
        +' c.name [�ͻ�����],d.name [������], e.name  [��������] ,'
        +' f.name [��������],Isnull(Amount,0) [�ͻ��ɱ�]  '
        +' from FNExpenseDetail  a                  '
        +' left outer join FNExpenseMaster b on b.ID=a.MasterID '
        +' left outer join DAClient        c on c.ID=a.ClientID '
        +' left outer join MSEmployee      d on d.ID=b.EmployeeID  '
        +' left outer join MSDepartment    e on e.ID=d.DepartmentID  '
        +' left outer join DAExpenseClass    f on f.ID=a.ExpenseID  '
        +' where b.RecordState<>'+ Quotedstr('ɾ��')
        +' and Isnull(a.Amount,0)<>0  and Isnull(a.ClientID,0)<>0  ';
      ADOQuery.ExecSQL;
    end;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' select ' + SelectStr1+ ExpSttcCheckListBox.hint
      +' , Sum(Isnull([����ë��],0)) [����ë��]  '
      +' , Sum(Isnull([���ý��],0)) [���ý��] '
      +' , Sum(Isnull([�ͻ��ɱ�],0)) [�ͻ��ɱ�] '
      +' , Sum(Isnull([�ͻ����ý��],0)) [Ӧ���ʿ����]  '
      +' , Sum(Isnull([�ͻ����ý��],0)) [�ͻ����ý��]  '
      +' , Sum(Isnull([�ͻ����ý��],0)) [����Ԥ�����]  '
      +' into #ExpenseListTtl from #ExpenseList0  '
      +WhereStr +' group by '+SelectStr1;
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [��׼����]=null, '
       +' [���۵���]=null,[�ɱ�����]=null ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [��׼����]= '
       +' [���۽��]/[��׼����] where Isnull([��׼����],0)<>0 ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [�ɱ�����]= '
       +' [����ë��]/[��׼����] where Isnull([��׼����],0) <>0 ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [����ë��]= '
       +' [���۽��]-[����ë��]';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [���۵���]= '
       +' [���۽��]/[��װ����] where isnull([��װ����],0) <>0 ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' update #ExpenseListTtl set [Ӧ���ʿ����]= '
      +' ( Isnull([���۽��],0)+Isnull([���ӷ���],0) -Isnull([������],0) - '
      +' Isnull([�ۿ۷������],0) ) ,'
      +' [����Ԥ�����]= (-Isnull([�ͻ����ý��],0) ) +'
      +' ( Isnull([���۽��],0)+Isnull([���ӷ���],0) -Isnull([������],0) - '
      +' Isnull([�ۿ۷������],0) ) ';
    ADOQuery.ExecSQL;

    if not ShowExpenseCkBx.Checked then
    begin
      ADOQuery.Close;
      ADOQuery.SQL.text :='ALTER TABLE #ExpenseListTtl DROP COLUMN [���ý��]';
      ADOQuery.ExecSQL ;
    end;
    if not ShowClientCostCkBx.Checked then
    begin
      ADOQuery.Close;
      ADOQuery.SQL.text :='ALTER TABLE #ExpenseListTtl DROP COLUMN [�ͻ��ɱ�]';
      ADOQuery.ExecSQL ;
    end;
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
       +' [���۽��]/[��׼����] where [��׼����]<>0 ';
    ADOQuery.ExecSQL;
    adsMaster.Close;
    adsMaster.CommandText:=' select *,(Isnull([���۽��],0)+Isnull([���ӷ���],0) '
      +' -Isnull([������],0) - '
      +' Isnull([�ۿ۷������],0) ) as [Ӧ���ʿ����] from #ExpenseListTtl ';
    adsMaster.open;
  end;

  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;
end;

procedure TSLSaleStatisticForm.N1Click(Sender: TObject);
begin
  ExpSttcCheckListBox.Sorted :=not ExpSttcCheckListBox.Sorted;
end;

procedure TSLSaleStatisticForm.N2Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=not ExpSttcCheckListBox.Checked[I];
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSLSaleStatisticForm.N3Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=True;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSLSaleStatisticForm.N4Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=False;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSLSaleStatisticForm.adsMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  adsMaster.IndexFieldNames := '';
end;

procedure TSLSaleStatisticForm.DateTimePicker2Exit(Sender: TObject);
begin
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker1.Date :=DateTimePicker2.Date;
end;

procedure TSLSaleStatisticForm.DateTimePicker1Exit(Sender: TObject);
begin
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker2.Date :=DateTimePicker1.Date;
end;

procedure TSLSaleStatisticForm.Button4Click(Sender: TObject);
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

procedure TSLSaleStatisticForm.Button6Click(Sender: TObject);
begin
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  VipsetPanel.Visible :=False;
end;

procedure TSLSaleStatisticForm.Button5Click(Sender: TObject);
begin
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
    +' ([����],[���],[ҵ�����],[�ͻ�����],[���۽��],[������],[�ۿ۷������] )'
    +' select '+Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')+' , '
    +' [�ͻ�����], sum(isnull([���۽��],0)) [���۽��] , '
    +' sum(isnull([������],0)) [������] , '
    +' sum(isnull([�ۿ۷������],0)) [�ۿ۷������]  '
    +' from #ExpenseList '
    +' where [����] <'+Quotedstr(Datetostr(DateTimePicker1.Date))
    +' Group by [�ͻ�����]' ;
  ADOQuery.ExecSQL ;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into  #ExpenseList0 '
    +' ( [�ͻ�����],[����],[���],[ҵ�����] )'
    +' select Distinct [�ͻ�����],  '
    + Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')
    +' from #ExpenseList '
    +' where [�ͻ�����] not in ( select distinct [�ͻ�����] from #ExpenseList0  '
    +' where [ҵ�����]='+ Quotedstr('�ڳ���ת')+' ) '    ;
  ADOQuery.ExecSQL ;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into  #ExpenseList0 '
    +' ([����],[���],[ҵ�����],[�ͻ�����],[���۽��] )'
    +' select '+Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')+' , '
    +' [�ͻ�����],sum(0.00) [���۽��] '
    +' from #ExpenseList '
    +' where [�ͻ�����] not in ( select [�ͻ�����] from #ExpenseList0 where '
    +' [����]< '+Quotedstr(Datetostr(DateTimePicker1.Date)) + ' )'
    +' group by [�ͻ�����] ';
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

procedure TSLSaleStatisticForm.ExpSttcCheckListBoxClickCheck(
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

procedure TSLSaleStatisticForm.ClientAccountLiastClick(Sender: TObject);
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
  I :=0;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select distinct [�ͻ�����] from #ExpenseList ' + WhereStr;
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
	+' [���۽��] [Float] NULL ,      '
	+' [�ؿ���] [Float] NULL ,      '
	+' [�ۿ۷������] [Float] NULL ,      '
	+' [Ӧ���ʿ����] [Float] NULL ,        '
	+' [��������] [datetime] NULL ,              '
	+' [��ע] [varchar] (30)  NULL     '
	+' )  ';
    ADOQuery2.ExecSQL;
//    ADOQuery2.Close;
//    ADOQuery2.SQL.Text :=' Truncate TABLE #ClientAccountList ';
//    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '
      +' [����],[���],[ҵ�����],[���۽��],[�ؿ���],'
      +' [�ۿ۷������],[��������] )'
      +' select [����],[���],[ҵ�����],'
      +' sum(isnull([���۽��],0)) as [���۽��] , '
      +' sum(isnull([������],0)) as [�ؿ���] , '
      +' sum(isnull([�ۿ۷������],0)) as [�ۿ۷������] , '
      +' [��������]  '
      +' from #ExpenseList '
      +' where [�ͻ�����]='+Quotedstr(ADOQuery.FieldByName('�ͻ�����').AsString)
      +' Group by [����],[���],[ҵ�����],[��������] '
      +' order by [����]';
    ADOQuery2.ExecSQL;

    {    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '
      +'        [����],[���],[ҵ�����],[�ؿ���] )'
      +' select [����],[���],[ҵ�����],'
      +' sum(isnull([�ۿ۷������],0)) as  [�ؿ���] '
      +' from #ExpenseList '
      +' where [�ͻ�����]='+Quotedstr(ADOQuery.FieldByName('�ͻ�����').AsString)
      +' and isnull([�ۿ۷������],0)<>0  '
      +' Group by [����],[���],[ҵ�����] '
      +' order by [����]';
    ADOQuery2.ExecSQL;   }


    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' select * from  #ClientAccountList order by [����],[ID]';
    ADOQuery2.open;
    ADOQuery2.First;
    BalanceF := 0;
    BalanceF := BalanceF+ ADOQuery2.FieldByName('���۽��').AsFloat-
         ADOQuery2.FieldByName('�ؿ���').AsFloat-
         ADOQuery2.FieldByName('�ۿ۷������').AsFloat ;

    ADOQuery2.Edit;
    ADOQuery2.FieldByName('���۽��').AsFloat :=0;
    ADOQuery2.FieldByName('�ؿ���').AsFloat :=0;
    ADOQuery2.FieldByName('�ۿ۷������').AsFloat :=0;

    while not ADOQuery2.Eof do
    begin
      BalanceF := BalanceF+ ADOQuery2.FieldByName('���۽��').AsFloat-
         ADOQuery2.FieldByName('�ؿ���').AsFloat-
         ADOQuery2.FieldByName('�ۿ۷������').AsFloat ;
      ADOQuery2.Edit;
      ADOQuery2.FieldByName('Ӧ���ʿ����').AsFloat :=BalanceF;
      ADOQuery2.Next;
    end;
    AccountListQry.Close;
    AccountListQry.SQL.Text :=' select [����],[���],[ҵ�����],[���۽��], '
      +'  [�ؿ���],[�ۿ۷������],[Ӧ���ʿ����],[��������] [Ԥ��������],[��ע] '
      +' from  #ClientAccountList order by [ID] ';
    AccountListQry.open;
    DataSource1.DataSet := AccountListQry;
    DBGrid1.DataSource :=  DataSource1;
    if Guarder.ExportCashACReckoningFlag='��' then
    begin
      ExportDBGridToExcel(DBGrid1, GetKeyState(VK_SHIFT) and $80000 = $80000,
        '�ͻ����ʵ�','�����ڼ䣺'+DateToStr(DateTimePicker1.Date) + '��' +
        DateToStr(DateTimePicker2.Date),
        '�ͻ����ƣ�'+ADOQuery.FieldByName('�ͻ�����').AsString);
    end;
    if (Guarder.PrintCashACReckoningFlag='��') and (Guarder.ExportCashACReckoningFlag<>'��') then
    begin
      with TQLDBGridReportBuilder.Create(Self) do
      try
        DBGrid := DBGrid1;
        AutoWidth := True;
        Report := TSLCheckReckoningReport.Create(Self);
        TSLCheckReckoningReport(Report).qrdbtClientName.DataSet := ADOQuery;
        TSLCheckReckoningReport(Report).qrlCheckCourse.Caption :=
          '�����ڼ�: ' + DateToStr(DateTimePicker1.Date) + ' ~ ' +
          DateToStr(DateTimePicker2.Date);
        SummaryFields.Add('���۽��=SUM([���۽��])');
        SummaryFields.Add('�ؿ���=SUM([�ؿ���])');
        SummaryFields.Add('�ۿ۷������=SUM([�ۿ۷������])');
        SummaryFields.Add('Ӧ���ʿ����='+floattostr(BalanceF));
        AutoOrientation := False;
        Active := True;
      if I<1 then Report.PreviewModal
        else  Report.Print;
      finally
        Free;
      end;
    end;
    ADOQuery.Next;
    I :=I+1;
  end;
end;

procedure TSLSaleStatisticForm.ListClientSaleActExecute(Sender: TObject);
var I:Integer;
  Goods :string;
begin
  for I:=0 to adsMaster.FieldCount-1 do
  begin
    if Pos('�ͻ�����',adsMaster.Fields[I].FieldName)>0 then
    begin
      Goods := adsMaster.FieldByName('�ͻ�����').AsString;
      if Trim(Goods)='' then Exit;
      adsMaster.Close;
      adsMaster.CommandText :='select * from #ExpenseList  where  [�ͻ�����]='+Quotedstr(Goods);
      adsMaster.Open;
      UpdateDBGrid;
      Exit;
    end;
  end;
end;

procedure TSLSaleStatisticForm.ListGoodsSaleActExecute(Sender: TObject);
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

procedure TSLSaleStatisticForm.adsMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  RefreshAvailableFields;
end;

end.
