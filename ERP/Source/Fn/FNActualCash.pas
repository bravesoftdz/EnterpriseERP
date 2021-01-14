unit FNActualCash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, GEdit,
  DBCtrls, Menus, WNADOCQuery,TypInfo, CheckLst;

type
  TFNActualCashFrom = class(TWSVoucherBrowseForm)
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
    ListClientSaleAct: TAction;
    ListClientSale: TMenuItem;
    ListGoodsSaleAct: TAction;
    ListGoodsSale: TMenuItem;
    ShowExpenseCkBx: TCheckBox;
    ShowClientCostCkBx: TCheckBox;
    EmployeeCostCkBx: TCheckBox;
    GoodsStockCkBx: TCheckBox;
    ToolButton1: TToolButton;
    AccountListQryDSDesigner: TDateTimeField;
    AccountListQryDSDesigner2: TStringField;
    AccountListQryDSDesigner3: TStringField;
    AccountListQryDSDesigner4: TBCDField;
    AccountListQryDSDesigner7: TBCDField;
    AccountListQryDSDesigner10: TBCDField;
    AccountListQryDSDesigner13: TStringField;
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
  FNActualCashFrom: TFNActualCashFrom;

implementation

uses CommonDM,QLDBFlt,WSSecurity,QLRptBld,SLRpCheckReckoning,WSUtils;
//CommonDM, QLDBFlt, QLRptBld, SLRpCheckReckoning;
{$R *.dfm}

function TFNActualCashFrom.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TFNActualCashFrom.UpdateDBGrid;
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
      if (Pos('Price',Columns[I].FieldName)<=0)
          and (Pos('����',Columns[I].FieldName)<=0)  then
           Columns[I].Footer.ValueType := fvtSum;
      end;
    end;
    FooterRowCount := 1;
  end;
end;

procedure TFNActualCashFrom.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

procedure TFNActualCashFrom.DBGridDblClick(Sender: TObject);
begin
// inherited;
end;


procedure TFNActualCashFrom.Button3Click(Sender: TObject);
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

procedure TFNActualCashFrom.FormShow(Sender: TObject);
var I :integer;
begin
  inherited;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList')
        +' )) DROP TABLE #ExpenseList ' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close; //�һ�����֧�����
  ADOQuery.SQL.Text :=' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [���뱾�ҽ��]  ,      '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [֧�����ҽ��]  ,      '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [�������]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' into #ExpenseList '
      +' from FNCashExchangeMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.ClientID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [���뱾�ҽ��]=Null,[�������]=Null';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //�һ�����������
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[���뱾�ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [���뱾�ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNCashExchangeMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //�տ����뱾��������
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[���뱾�ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [���뱾�ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNCashInMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //�����տ��������
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[���뱾�ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [���뱾�ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNClearSLMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //�����տ��������
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[���뱾�ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [���뱾�ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNClearEGMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //�������뱾��֧�����
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[֧�����ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [֧�����ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNCashoutMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //���㸶���֧�����
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[֧�����ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [֧�����ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNClearPCMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;


  ADOQuery.Close; //�������뱾��֧�����
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[֧�����ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [֧�����ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNExpenseMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //�ʽ��������֧�����
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[֧�����ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [֧�����ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNCashOutInMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.ClientID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' AND b.AccountType not like '+Quotedstr('%ҵ���ʽ�%')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close; //�ʽ��������������
  ADOQuery.SQL.Text :=' insert into #ExpenseList  ( '
      +'[����],[���],[ҵ�����],[ժҪ],[�ʻ�����],[��������], '
      +'[���뱾�ҽ��],[������],[��ע],[ƾ��״̬] ) '
      +' Select a.Date [����], '
      +' a.Code [���],                       '
      +' a.BillMode [ҵ�����],               '
      +' Brief [ժҪ],                        '
      +' b.name [�ʻ�����],                   '
      +' d.name [��������],                   '
      +' Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) [���뱾�ҽ��]  ,      '
      +' c.name [������],                                                      '
      +' a.memo [��ע]  ,                                                      '
      +' a.RecordState [ƾ��״̬]                                              '
      +' from FNCashOutInMaster a                                           '
      +' left outer join  FNAccounts b on b.id=a.AccountsID                    '
      +' left outer join  MSEmployee c on c.id=a.EmployeeID                    '
      +' left outer join  MSCurrency d on d.id=b.CurrencyID                    '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' AND b.AccountType not like '+Quotedstr('%ҵ���ʽ�%')
//      +' and d.IsLocation=1 '
      +' order by  a.Date ,a.Code,a.ID ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set '
      +' [�������]=(ISNull([���뱾�ҽ��],0)-ISNull([֧�����ҽ��],0)) ';
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

procedure TFNActualCashFrom.Button1Click(Sender: TObject);
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

procedure TFNActualCashFrom.FormActivate(Sender: TObject);
begin
  inherited;
  if Trim(SelectStr) ='' then
    begin
      ExpSttcCheckListBox.Checked[4] :=true;
      ExpSttcCheckListBox.ItemIndex := 4;
      ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
      ExpSttcCheckListBox.Checked[5] :=true;
      ExpSttcCheckListBox.ItemIndex := 5;
      ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
    end;
  Button2Click(sender);
end;

procedure TFNActualCashFrom.Button2Click(Sender: TObject);
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

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' select ' + SelectStr1+ ExpSttcCheckListBox.hint
    +' into #ExpenseListTtl from #ExpenseList  '
    +WhereStr +' group by '+SelectStr1;
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' update #ExpenseListTtl set [�������]= '
    +' Isnull([���뱾�ҽ��],0)-Isnull([֧�����ҽ��],0) ';
  ADOQuery.ExecSQL;

  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseListTtl';
  adsMaster.open;

  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;
end;

procedure TFNActualCashFrom.N1Click(Sender: TObject);
begin
  ExpSttcCheckListBox.Sorted :=not ExpSttcCheckListBox.Sorted;
end;

procedure TFNActualCashFrom.N2Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=not ExpSttcCheckListBox.Checked[I];
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TFNActualCashFrom.N3Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=True;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TFNActualCashFrom.N4Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=False;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TFNActualCashFrom.adsMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  adsMaster.IndexFieldNames := '';
end;

procedure TFNActualCashFrom.DateTimePicker2Exit(Sender: TObject);
begin
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker1.Date :=DateTimePicker2.Date;
end;

procedure TFNActualCashFrom.DateTimePicker1Exit(Sender: TObject);
begin
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker2.Date :=DateTimePicker1.Date;
end;

procedure TFNActualCashFrom.Button4Click(Sender: TObject);
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

procedure TFNActualCashFrom.Button6Click(Sender: TObject);
begin
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  VipsetPanel.Visible :=False;
end;

procedure TFNActualCashFrom.Button5Click(Sender: TObject);
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
  ADOQuery.SQL.Text :=' Insert into  #ExpenseList0 ( '
    +' [����],[���],[ҵ�����],[�ʻ�����],[��������], '
    +' [�������])'
    +' select '+Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')+' , '
    +' [�ʻ�����],[��������],'
    +' (sum(isnull([���뱾�ҽ��],0))-sum(isnull([���뱾�ҽ��],0)) ) [�������]  '
    +' from #ExpenseList '
    +' where [����] <'+Quotedstr(Datetostr(DateTimePicker1.Date))
    +' Group by [�ʻ�����],[��������] ' ;
  ADOQuery.ExecSQL ;       //���ڳ������ʻ�

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into  #ExpenseList0 '
    +' ([�ʻ�����],[��������] ,[����],[���],[ҵ�����] )'
    +' select a.name [�ʻ�����], b.Name [��������] , '
    + Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')
    +' from FNAccounts a '
    +' left outer join MSCurrency b on b.ID=a.CurrencyID '
    +' where a.Name not in ( select distinct [�ʻ�����] from #ExpenseList0  '
    +' where [ҵ�����]='+ Quotedstr('�ڳ���ת')+' ) '
    +' and a.Name in ( select distinct [�ʻ�����] from #ExpenseList ) ';
  ADOQuery.ExecSQL ;  //���ڳ������ʻ�

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

procedure TFNActualCashFrom.ExpSttcCheckListBoxClickCheck(
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

procedure TFNActualCashFrom.ClientAccountLiastClick(Sender: TObject);
var LocalCurrencyBalance,ForeignCurrencyBalance:real;
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
  ADOQuery.SQL.Text :=' select a.name [�ʻ�����],b.name �������� '
    +' from FNAccounts a '
    +' Left Outer join MSCurrency b on b.ID=a.CurrencyID '
    +' where a.name in (select [�ʻ�����] from #ExpenseList '
    + WhereStr +' ) ';
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
	+' [���뱾�ҽ��] [Float] NULL ,      '
	+' [֧�����ҽ��] [Float] NULL ,      '
	+' [�������] [Float] NULL ,      '
	+' [��ע] [varchar] (30)  NULL     '
	+' )  ';
    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
//    ADOQuery2.SQL.Text :=' select * from  #ClientAccountList ';
//     ADOQuery2.open;
    ADOQuery2.SQL.Text :=' Truncate TABLE #ClientAccountList ';
    ADOQuery2.ExecSQL;

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '
      +' [����],[���],[ҵ�����],[���뱾�ҽ��], '
      +' [֧�����ҽ��], [�������],[��ע] ) '
      +' select [����],[���],[ҵ�����],[���뱾�ҽ��], '
      +' [֧�����ҽ��], '
      +' [�������], [��ע]  '
      +' from #ExpenseList '
      +' where [�ʻ�����]='+Quotedstr(ADOQuery.FieldByName('�ʻ�����').AsString)
      +' order by [����],[���],[ҵ�����] ';
    ADOQuery2.ExecSQL;

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' select * from  #ClientAccountList order by [����],[ID]';
    ADOQuery2.open;
    ADOQuery2.First;
    LocalCurrencyBalance := 0;
    LocalCurrencyBalance := LocalCurrencyBalance+ ADOQuery2.FieldByName('���뱾�ҽ��').AsFloat-
         ADOQuery2.FieldByName('֧�����ҽ��').AsFloat;
    ADOQuery2.Edit;
    ADOQuery2.FieldByName('���뱾�ҽ��').Value :=Null ;
    ADOQuery2.FieldByName('֧�����ҽ��').Value :=Null ;
    while not ADOQuery2.Eof do
    begin
      ADOQuery2.Edit;
      ADOQuery2.FieldByName('�������').AsFloat :=LocalCurrencyBalance;
      ADOQuery2.Next;

      LocalCurrencyBalance := LocalCurrencyBalance+ ADOQuery2.FieldByName('���뱾�ҽ��').AsFloat-
         ADOQuery2.FieldByName('֧�����ҽ��').AsFloat;
    end;

    AccountListQry.Close;
    AccountListQry.SQL.Text :=' select  '
      +' [����],[���],[ҵ�����],[���뱾�ҽ��], '
      +' [֧�����ҽ��],[�������],[��ע]  '
      +' from  #ClientAccountList order by [ID] ';
    AccountListQry.open;

    DataSource1.DataSet := AccountListQry;
    DBGrid1.DataSource :=  DataSource1;
//    DBGrid1.Visible :=True;

    if Guarder.ExportCashACReckoningFlag='��' then
    begin
      ExportDBGridToExcel(DBGrid1, GetKeyState(VK_SHIFT) and $80000 = $80000,
        '�����ʻ����ʵ�','���֣�'+ADOQuery.FieldByName('��������').AsString
         , '�ʻ����ƣ�'+ADOQuery.FieldByName('�ʻ�����').AsString);
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
          '�����ڼ�: ' + DateToStr(DateTimePicker1.Date) + '��' +
          DateToStr(DateTimePicker2.Date);
        SummaryFields.Add('����������=SUM([����������])');
        SummaryFields.Add('����֧�����=SUM([����֧�����])');
        SummaryFields.Add('�������='+floattostr(LocalCurrencyBalance/2));
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

procedure TFNActualCashFrom.ListClientSaleActExecute(Sender: TObject);
var I:Integer;
  Goods :string;
begin
  for I:=0 to adsMaster.FieldCount-1 do
  begin
    if Pos('�ʻ�����',adsMaster.Fields[I].FieldName)>0 then
    begin
      Goods := adsMaster.FieldByName('�ʻ�����').AsString;
      if Trim(Goods)='' then Exit;
      adsMaster.Close;
      adsMaster.CommandText :='select * from #ExpenseList  where  [�ʻ�����]='+Quotedstr(Goods);
      adsMaster.Open;
      UpdateDBGrid;
      Exit;
    end;
  end;
end;

procedure TFNActualCashFrom.ListGoodsSaleActExecute(Sender: TObject);
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
      adsMaster.CommandText :='select * from #ExpenseList  where  [��������]='
        +Quotedstr(Goods)+' order by [����]';
      adsMaster.Open;
      UpdateDBGrid;
      Exit;
    end;
  end;
end;

procedure TFNActualCashFrom.adsMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  RefreshAvailableFields;
end;

end.
