unit STNewStockRep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, GEdit,
  DBCtrls, Menus, WNADOCQuery,TypInfo, CheckLst;

type
  TSTNewStockRepForm = class(TWSVoucherBrowseForm)
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
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ListGoodsDetailAct: TAction;
    ListGoodsDetail: TMenuItem;
    VipsetPanel: TPanel;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Button5: TButton;
    Button6: TButton;
    ToolButton1: TToolButton;
    GoodsFlowListAct: TAction;
    AccountListQry: TADOQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    AccountListQryDSDesigner: TDateTimeField;
    AccountListQryDSDesigner2: TStringField;
    AccountListQryDSDesigner3: TStringField;
    AccountListQryDSDesigner4: TStringField;
    AccountListQryDSDesigner5: TStringField;
    AccountListQryDSDesigner6: TStringField;
    AccountListQryDSDesigner7: TStringField;
    AccountListQryDSDesigner8: TStringField;
    AccountListQryDSDesigner9: TStringField;
    AccountListQryDSDesigner10: TBCDField;
    AccountListQryDSDesigner11: TBCDField;
    AccountListQryDSDesigner12: TBCDField;
    AccountListQryDSDesigner13: TStringField;
    AccountListQryDSDesigner14: TBCDField;
    AccountListQryDSDesigner15: TBCDField;
    AccountListQryDSDesigner16: TBCDField;
    AccountListQryDSDesigner17: TBCDField;
    AccountListQryDSDesigner18: TBCDField;
    AccountListQryDSDesigner19: TStringField;
    AccountListQryDSDesigner20: TBCDField;
    AccountListQryDSDesigner21: TBCDField;
    AccountListQryDSDesigner22: TBCDField;
    AccountListQryDSDesigner23: TBCDField;
    AccountListQryDSDesigner24: TBCDField;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    DeadStockAct: TAction;
    TheWareHouseGoodsAct: TAction;
    heWareHouseGoodsAct1: TMenuItem;
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
    procedure ExpSttcCheckListBoxClickCheck(Sender: TObject);
    procedure ListGoodsDetailActExecute(Sender: TObject);
    procedure GoodsFlowListActExecute(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DateTimePicker1CloseUp(Sender: TObject);
    procedure DateTimePicker2CloseUp(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure adsMasterAfterOpen(DataSet: TDataSet);
    procedure DeadStockActExecute(Sender: TObject);
    procedure TheWareHouseGoodsActExecute(Sender: TObject);

  private
    { Private declarations }
    WhereStr,SelectStr :string;
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  STNewStockRepForm: TSTNewStockRepForm;

implementation

uses CommonDM,QLDBFlt,QLRptBld,SLRpCheckReckoning;

{$R *.dfm}

function TSTNewStockRepForm.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TSTNewStockRepForm.UpdateDBGrid;
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
      Columns[i].Width :=120;
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
        if (Pos('����',Columns[I].FieldName)<=0)   then
           Columns[I].Footer.ValueType := fvtSum;
      end;
    end;
    FooterRowCount := 1;
  end;
end;

procedure TSTNewStockRepForm.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

procedure TSTNewStockRepForm.DBGridDblClick(Sender: TObject);
begin
// inherited;
end;


procedure TSTNewStockRepForm.Button3Click(Sender: TObject);
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

procedure TSTNewStockRepForm.FormShow(Sender: TObject);
var I :integer;
begin
  inherited;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList')
        +' )) DROP TABLE #ExpenseList ' ;
  ADOQuery.ExecSQL;

//���۳���
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����׼����],  '
    +' a.PriceGoal [����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����], '
    +' f.name     [����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����װ����],     '
    +' a.PriceBase [����װ����]  ,             '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����׼����],  '
    +' a.PriceGoal [�����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [������], '
    +' f.name     [�����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����װ����],     '
    +' a.PriceBase [�����װ����]                '
    +' into #ExpenseList '
    +' from SLGoodsOutDetail a                   '
    +' left outer join SLGoodsOutMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//���۳���
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #ExpenseList set [����׼����]=0 , '
    +' [����׼����]=0 , [�����]=0, '
    +' [����װ��λ]=Null ,                '
    +' [����װ����]=0, [����װ����]=0       '  ;
  ADOQuery.ExecSQL;

  //�ɹ����--
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [����׼����], [����׼����],[�����],[����װ��λ],    '
    +' [����װ����], [����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����׼����],            '
    +' a.PriceGoal [����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����],                  '
    +' f.name     [����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����װ����],     '
    +' a.PriceBase [����װ����]                '
    +' from PCGoodsInDetail a                   '
    +' left outer join PCGoodsInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//�ɹ����--

//�������==
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [����׼����], [����׼����],[�����],[����װ��λ],    '
    +' [����װ����], [����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����׼����],  '
    +' a.PriceGoal [����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����],                  '
    +' f.name     [����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����װ����],     '
    +' a.PriceBase [����װ����]                '
    +' from YDGoodsInDetail a                   '
    +' left outer join YDGoodsInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//�������==

//��������==
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����׼����], [�����׼����],[������],[�����װ��λ],    '
    +' [�����װ����], [�����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����׼����],            '
    +' a.PriceGoal [�����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [������],                  '
    +' f.name     [�����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����װ����],     '
    +' a.PriceBase [�����װ����]                '
    +' from YDGoodsOutDetail a                   '
    +' left outer join YDGoodsOutMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//��������==

//��Ŀ����==
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����׼����], [�����׼����],[������],[�����װ��λ],    '
    +' [�����װ����], [�����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����׼����],            '
    +' a.PriceGoal [�����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [������],                  '
    +' f.name     [�����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����װ����],     '
    +' a.PriceBase [�����װ����]                '
    +' from EGGoodsOutDetail a                   '
    +' left outer join EGGoodsOutMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//��Ŀ����==

//����������
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����׼����], [�����׼����],[������],[�����װ��λ],    '
    +' [�����װ����], [�����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����׼����],            '
    +' a.PriceGoal [�����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [������],                  '
    +' f.name     [�����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����װ����],     '
    +' a.PriceBase [�����װ����]                '
    +' from STGoodsOutInDetail a                   '
    +' left outer join STGoodsOutInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.ClientID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and  isnull(b.ClientID,0)<>0  and isnull(a.GoodsID,0)<>0 '
    +' order by  b.date ,b.code,a.ID ';

  ADOQuery.ExecSQL;
//����������


//���������
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [����׼����], [����׼����],[�����],[����װ��λ],    '
    +' [����װ����], [����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����׼����],            '
    +' a.PriceGoal [����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����],                  '
    +' f.name     [����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����װ����],     '
    +' a.PriceBase [����װ����]                '
    +' from STGoodsOutInDetail a                   '
    +' left outer join STGoodsOutInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and  isnull(b.WareHouseID,0)<>0  and isnull(a.GoodsID,0)<>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//���������

//��ӯ���
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [����׼����], [����׼����],[�����],[����װ��λ],    '
    +' [����װ����], [����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����׼����],            '
    +' a.PriceGoal [����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����],                  '
    +' f.name     [����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [����װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from STGoodsCountOffDetail a                   '
    +' left outer join STGoodsCountOffMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0)<>0 and BillMode='+Quotedstr('�����ӯ')
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//��ӯ���

//�̿�����
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����׼����], [�����׼����],[������],[�����װ��λ],    '
    +' [�����װ����], [�����װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����׼����],            '
    +' a.PriceGoal [�����׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [������],                  '
    +' f.name     [�����װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [�����װ����],     '
    +' a.PriceBase [�����װ����]                '
    +' from STGoodsCountOffDetail a                   '
    +' left outer join STGoodsCountOffMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=E.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0)<>0 and BillMode<>'+Quotedstr('�����ӯ')
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//�̿�����

{  //����Ԥ������
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #ExpenseList ( '
    +' [��Ʒ���], [��Ʒ����],[�����������] ) '
    +' select h.name [��Ʒ���], a.name [��Ʒ����],  '
    +' a.StockMin [�����������] '
    +' from DAGoods  a                   '
    +' left outer join DAGoodsClass  h on h.ID=a.GoodsClassID  '
    +' where a.RecordState<>'+ Quotedstr('ɾ��');
  ADOQuery.ExecSQL;   }



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

procedure TSTNewStockRepForm.Button1Click(Sender: TObject);
begin
  Panel6.Visible :=True;
  Panel6.Repaint;
  Button1.Tag:=1 ;
  adsMaster.Close;
  adsMaster.CommandText:=' select *,(Isnull([����׼����],0)-Isnull([�����׼����],0)) [����׼����], '
    +'(Isnull([�����],0)-Isnull([������],0)) [�����] '
    +' from #ExpenseList'+WhereStr
    +' order by [����], [���]' ;
//  showmessage(adsMaster.CommandText);
  adsMaster.open;
  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='';
end;

procedure TSTNewStockRepForm.FormActivate(Sender: TObject);
begin
  inherited;
{ ADOQuery.Close;
  ADOQuery.SQL.Text :='select max(����) MDate  from #ExpenseList ';
  ADOQuery.Open;

  if ADOQuery.FieldByName('MDate').IsNull then WhereStr :=Datetostr(date)
    else WhereStr :=Trim(ADOQuery.fieldbyname('MDate').AsString);
  Memo1.ReadOnly :=False;
  Memo1.Clear;
  Memo1.Text :=' ���� ����'+ Quotedstr(WhereStr);
  Memo1.ReadOnly :=True;
  WhereStr :=' where [����]='+Quotedstr(WhereStr);
  WhereStr := ' where 1=1 ';            }
  ExpSttcCheckListBox.Checked[6] :=True;
  SelectStr :=','+Trim(ExpSttcCheckListBox.Items[6]);
  Button2Click(sender);
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#StockListTtl')
        +' )) DROP TABLE #StockListTtl ' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select * into #StockListTtl from #ExpenseListTtl ';
  ADOQuery.ExecSQL;

end;

procedure TSTNewStockRepForm.Button2Click(Sender: TObject);
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

  if  pos('��Ʒ����',SelectStr1)>0 then
  begin
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
          +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList0')
          +' )) DROP TABLE #ExpenseList0 ' ;
    ADOQuery.ExecSQL;
    //������ϸ��ˮ����------
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' select *,  '
      +' (Isnull([����׼����],0)-Isnull([�����׼����],0)) [����׼����],'
      +' (Isnull([�����],0)-Isnull([������],0)) [�����],'
      +' [������] [�����������],[������] [Ԥ������]'
      +' into #ExpenseList0  from #ExpenseList  ';
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text :=' Update #ExpenseList0 set [�����������]=0,'
      +' [Ԥ������]=0 ' ;
    ADOQuery.ExecSQL;

    //����Ԥ������ ==========
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' insert into  #ExpenseList0 ( [ҵ�����],'
      +' [��Ʒ���], [��Ʒ����],[��׼��λ],[�����������] ) '
      +' select '+Quotedstr('Ԥ������')+' [ҵ�����] ,'
      +' h.name [��Ʒ���], a.name [��Ʒ����], s.name [��׼��λ], '
      +' a.StockMin [�����������] '
      +' from DAGoods  a                   '
      +' left outer join DAGoodsClass  h on h.ID=a.GoodsClassID  '
      +' left outer join MSUnit        S on S.ID=a.UnitID  '
      +' where a.RecordState<>'+ Quotedstr('ɾ��')
      +' and Isnull(a.StockMin,0)<>0 ';
    ADOQuery.ExecSQL;

    //������ܼ�¼ *****
    ADOQuery.Close;
    ADOQuery.SQL.Text:=' select ' + SelectStr1+ ExpSttcCheckListBox.hint
      +' , Sum(Isnull([����׼����],0)) [����׼����],'
      +' Sum(Isnull([�����],0)) [�����],'
      +' Sum(isnull([�����������],0)) [�����������] ,'
      +' Sum(isnull([Ԥ������],0)) [Ԥ������]'
      +' into #ExpenseListTtl from #ExpenseList0  '
      +WhereStr +' group by '+SelectStr1 ;
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text:=' Update #ExpenseListTtl set [Ԥ������]='
      +' Isnull([����׼����],0)-Isnull([�����������],0)' ;
    ADOQuery.ExecSQL;
  end else
  begin
    ADOQuery.Close;
    ADOQuery.SQL.Text:=' select ' + SelectStr1+ ExpSttcCheckListBox.hint
      +' into #ExpenseListTtl from #ExpenseList  '
      +WhereStr +' group by '+SelectStr1;
    ADOQuery.ExecSQL;
  end;

  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseListTtl ';
  adsMaster.open;

  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;
end;

procedure TSTNewStockRepForm.N1Click(Sender: TObject);
begin
  ExpSttcCheckListBox.Sorted :=not ExpSttcCheckListBox.Sorted;
end;

procedure TSTNewStockRepForm.N2Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=not ExpSttcCheckListBox.Checked[I];
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTNewStockRepForm.N3Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=True;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTNewStockRepForm.N4Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=False;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTNewStockRepForm.adsMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  adsMaster.IndexFieldNames := '';
end;

procedure TSTNewStockRepForm.ExpSttcCheckListBoxClickCheck(
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

procedure TSTNewStockRepForm.ListGoodsDetailActExecute(Sender: TObject);
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

procedure TSTNewStockRepForm.GoodsFlowListActExecute(Sender: TObject);
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
	+' [���] [Float] NULL ,        '
	+' [��ע] [varchar] (30)  NULL     '
	+' )  ';
    ADOQuery2.ExecSQL;
//    ADOQuery2.Close;
//    ADOQuery2.SQL.Text :=' Truncate TABLE #ClientAccountList ';
//    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '
      +'        [����],[���],[ҵ�����],[���۽��],[�ؿ���] )'
      +' select [����],[���],[ҵ�����],'
      +' sum(isnull([���۽��],0)) as [���۽��] , '
      +' sum(isnull([������],0)) as [�ؿ���] '
      +' from #ExpenseList '
      +' where [�ͻ�����]='+Quotedstr(ADOQuery.FieldByName('�ͻ�����').AsString)
      +' Group by [����],[���],[ҵ�����] '
      +' order by [����]';
    ADOQuery2.ExecSQL;

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '
      +'        [����],[���],[ҵ�����],[�ؿ���] )'
      +' select [����],[���],[ҵ�����],'
      +' sum(isnull([�ۿ۷������],0)) as  [�ؿ���] '
      +' from #ExpenseList '
      +' where [�ͻ�����]='+Quotedstr(ADOQuery.FieldByName('�ͻ�����').AsString)
      +' and isnull([�ۿ۷������],0)<>0  '
      +' Group by [����],[���],[ҵ�����] '
      +' order by [����]';
    ADOQuery2.ExecSQL;

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' select * from  #ClientAccountList order by [����],[ID]';
    ADOQuery2.open;
    ADOQuery2.First;
    BalanceF := 0;
    BalanceF := BalanceF+ ADOQuery2.FieldByName('���۽��').AsFloat-
         ADOQuery2.FieldByName('�ؿ���').AsFloat;
    ADOQuery2.Edit;
    ADOQuery2.FieldByName('���۽��').AsFloat :=0;
    ADOQuery2.FieldByName('�ؿ���').AsFloat :=0;
    while not ADOQuery2.Eof do
    begin
      BalanceF := BalanceF+ ADOQuery2.FieldByName('���۽��').AsFloat-
         ADOQuery2.FieldByName('�ؿ���').AsFloat;
      ADOQuery2.Edit;
      ADOQuery2.FieldByName('���').AsFloat :=BalanceF;
      ADOQuery2.Next;
    end;
    AccountListQry.Close;
    AccountListQry.SQL.Text :=' select [����],[���],[ҵ�����],[���۽��], '
      +'  [�ؿ���],[���],[��ע] '
      +' from  #ClientAccountList order by [ID] ';
    AccountListQry.open;

//    tfloatfield.ADOQuery2.
    DataSource1.DataSet := AccountListQry;
    DBGrid1.DataSource :=  DataSource1;
//    DBGrid1.Visible :=True;
//    ShowMessage('��鿴--'+ADOQuery.FieldByName('�ͻ�����').AsString+' --���ʽ��!');
    //�ڴ�ѭ����ӡ���ʵ��������ɺ���Խ� DBGrid1��DataSource1ɾ��
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
      SummaryFields.Add('���='+floattostr(BalanceF));
      AutoOrientation := False;
      Active := True;

  //    InitReport(TQuickRep(Report));
    if I<1 then
      Report.PreviewModal
      else  Report.Print;
  //    if Preview then Report.PreviewModal
  //    else begin
  //      if ShowSetupDialog then Report.PrinterSetup;
  //      Report.Print;
  //    end;
    finally
      Free;
    end;
    ADOQuery.Next;
    I :=I+1;
//    DBGrid1.Visible :=False;
  end;
end;

procedure TSTNewStockRepForm.Button4Click(Sender: TObject);
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

procedure TSTNewStockRepForm.DateTimePicker1CloseUp(Sender: TObject);
begin
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker2.Date :=DateTimePicker1.Date;
end;

procedure TSTNewStockRepForm.DateTimePicker2CloseUp(Sender: TObject);
begin
  if DateTimePicker1.Date>DateTimePicker2.Date then
    DateTimePicker1.Date :=DateTimePicker2.Date;
end;

procedure TSTNewStockRepForm.Button6Click(Sender: TObject);
begin
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  VipsetPanel.Visible :=False;
end;

procedure TSTNewStockRepForm.Button5Click(Sender: TObject);
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
    +' [����], [���],[ҵ�����],[�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����׼����], [�����׼����],[������],[�����װ��λ],    '
    +' [�����װ����], [�����װ����], '
    +' [����׼����], [����׼����],[�����],[����װ��λ],    '
    +' [����װ����], [����װ����] ) '
    +' select '+Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')+' , '
    +Quotedstr('----')+' [�ֿ�����], [��Ʒ���] ,[��Ʒ����], '
    +Quotedstr('----') +' [��Ʒ���], [��׼��λ] , '
    +' sum(isnull([�����׼����],0)) [�����׼����] , '
    +' sum(0.00) [�����׼����] , '
    +' sum(isnull([������],0)) [������] , '
    +' [��׼��λ] [�����װ��λ] , '
    +' sum(isnull([�����׼����],0)) [�����װ����] , '
    +' sum(0.00) [�����װ����]  , '
    +' sum(isnull([����׼����],0)) [����׼����] , '
    +' sum(0.00) [����׼����]  ,'
    +' sum(isnull([�����],0)) [�����] , '
    +' [��׼��λ] [����װ��λ] , '
    +' sum(isnull([����׼����],0)) [����װ����] , '
    +' sum(0.00)  [����װ����]   '
    +' from #ExpenseList '
    +' where [����] <'+Quotedstr(Datetostr(DateTimePicker1.Date))
    +' Group by [��Ʒ����], [��Ʒ���],[��׼��λ]' ;
  ADOQuery.ExecSQL ;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into  #ExpenseList0 '
    +' ( [��Ʒ����],[����],[���],[ҵ�����],[��Ʒ���] )'
    +' select Distinct [��Ʒ����],  '
    + Quotedstr(Datetostr(DateTimePicker1.Date-1))
    +' as [����],'+Quotedstr('----')+' , '+Quotedstr('�ڳ���ת')
    +' , [��Ʒ���]'
    +' from #ExpenseList '
    +' where [��Ʒ����] not in ( select distinct [��Ʒ����] from #ExpenseList0  '
    +' where [ҵ�����]='+ Quotedstr('�ڳ���ת')+' ) '    ;
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

procedure TSTNewStockRepForm.ToolButton1Click(Sender: TObject);
var BalanceAmount,BalanceQuantity:real;
    I:Integer;
    FieldStr :string;
begin
//  Exit;
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
  ADOQuery.SQL.Text :=' select distinct [��Ʒ����] from #ExpenseList ' + WhereStr;
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
    ADOQuery2.SQL.Text :=' select *  into  #ClientAccountList  '
      +' from #ExpenseList where 1=2 '   ;
    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' select * from  #ClientAccountList ';
    ADOQuery2.open;
    FieldStr :='';
    for I:=0 to ADOQuery2.FieldCount-1 do
    begin
      FieldStr :=Trim(FieldStr)+','+Trim(ADOQuery2.Fields[I].FieldName);
    end;
    FieldStr :=Copy(Trim(FieldStr),2,length(Trim(FieldStr))-1);

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Truncate Table #ClientAccountList ';
    ADOQuery2.ExecSQL;

    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' ALTER TABLE  #ClientAccountList ADD [ID] '
      +' [int] IDENTITY (1, 1) NOT NULL , '
      +' [�������] float NULL ,[��浥��] float NULL,[�����] float NULL ';
    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' Insert Into #ClientAccountList ( '+ FieldStr
      +' ) select '+  FieldStr +' from #ExpenseList where [��Ʒ����]='
      +Quotedstr(Trim(ADOQuery.fieldbyname('��Ʒ����').AsString))
      +' order by [����]';
    ADOQuery2.ExecSQL;
    ADOQuery2.Close;
    ADOQuery2.SQL.Text :=' select * from  #ClientAccountList order by [����],[ID]';
    ADOQuery2.open;
    BalanceQuantity :=0;
    BalanceAmount :=0;
    while not ADOQuery2.Eof do
    begin
      BalanceQuantity :=BalanceQuantity
        +ADOQuery2.FieldByName('����׼����').AsFloat-ADOQuery2.FieldByName('�����׼����').AsFloat ;
      BalanceAmount :=BalanceAmount
        +ADOQuery2.FieldByName('�����').AsFloat-ADOQuery2.FieldByName('������').AsFloat ;
      ADOQuery2.Edit;
      ADOQuery2.FieldByName('�������').AsFloat :=BalanceQuantity;
      ADOQuery2.FieldByName('�����').AsFloat :=BalanceAmount;
//      ADOQuery2.Edit;
      ADOQuery2.FieldByName('��浥��').AsFloat :=
      ADOQuery2.FieldByName('�����').AsFloat/ADOQuery2.FieldByName('�������').AsFloat;
      ADOQuery2.Next;

    end;
    AccountListQry.Close;
    AccountListQry.SQL.Text :=' Alter Table #ClientAccountList DROP COLUMN  [ID] ';
    AccountListQry.ExecSQL;

//    AccountListQry.Close;
//    AccountListQry.SQL.Text :=' select *   '
//      +' from  #ClientAccountList order by [����] ';
//    AccountListQry.open;
//    DataSource1.DataSet := AccountListQry;
//    DBGrid1.DataSource :=  DataSource1;
//    DBGrid1.Visible :=True;
//    ShowMessage('��鿴--'+ADOQuery.FieldByName('��Ʒ����').AsString+' --������ˮ���!');
    adsMaster.Close;
    adsMaster.CommandText :='select * from #ClientAccountList';
    adsMaster.Open;
    UpdateDBGrid;
    DBGrid.hint :='��ǰ��Ʒ:'+Trim(ADOQuery.fieldbyname('��Ʒ����').AsString)+'��ϸ��';

    //�ڴ�ѭ����ӡ���ʵ��������ɺ���Խ� DBGrid1��DataSource1ɾ��
    {
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
      SummaryFields.Add('���='+floattostr(BalanceF));
      AutoOrientation := False;
      Active := True;
    if I<1 then  Report.PreviewModal
      else  Report.Print;
    finally
      Free;
    end;           }
    ADOQuery.Next;
    I :=I+1;
//    DBGrid1.Visible :=False;
  end;

end;

procedure TSTNewStockRepForm.adsMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  RefreshAvailableFields;
end;

procedure TSTNewStockRepForm.DeadStockActExecute(Sender: TObject);
var RateStr:string;
  RateStrF :Integer;
begin
  RateStr :='30';
  if InputQuery('��������', '��������������:', RateStr) then
    while not TryStrToint(RateStr,RateStrF) do
     if not InputQuery('��������', '������������:', RateStr) then exit;
  if RateStrF=0 then exit;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
      +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#DeadStockList')
      +' )) DROP TABLE #DeadStockList' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select [��Ʒ����],'
    +' [����׼����] [�������],[�����] ,'
    +' [����׼����] ['+inttostr(RateStrF*1)+'���������],'
    +' [�����] ['+inttostr(RateStrF*1)+'����ͽ��],'
    +' [����׼����] ['+inttostr(RateStrF*2)+'���������],'
    +' [�����] ['+inttostr(RateStrF*2)+'����ͽ��],'
    +' [����׼����] ['+inttostr(RateStrF*3)+'���������],'
    +' [�����] ['+inttostr(RateStrF*3)+'����ͽ��],'
    +' [����׼����] ['+inttostr(RateStrF*4)+'���������],'
    +' [�����] ['+inttostr(RateStrF*4)+'����ͽ��],'
    +' [����׼����] ['+inttostr(RateStrF*5)+'���������],'
    +' [�����] ['+inttostr(RateStrF*5)+'����ͽ��],'
    +' [����׼����] ['+inttostr(RateStrF*6)+'���������],'
    +' [�����] ['+inttostr(RateStrF*6)+'����ͽ��] '
    +' into #DeadStockList from #StockListTtl '
    +' where Isnull([����׼����],0)+Isnull([�����],0)<>0 ' ;
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' update #DeadStockList set '
    +' ['+inttostr(RateStrF*1)+'���������]=Null,'
    +' ['+inttostr(RateStrF*1)+'����ͽ��]=Null,'
    +' ['+inttostr(RateStrF*2)+'���������]=Null,'
    +' ['+inttostr(RateStrF*2)+'����ͽ��]=Null,'
    +' ['+inttostr(RateStrF*3)+'���������]=Null,'
    +' ['+inttostr(RateStrF*3)+'����ͽ��]=Null,'
    +' ['+inttostr(RateStrF*4)+'���������]=Null,'
    +' ['+inttostr(RateStrF*4)+'����ͽ��]=Null,'
    +' ['+inttostr(RateStrF*5)+'���������]=Null,'
    +' ['+inttostr(RateStrF*5)+'����ͽ��]=Null,'
    +' ['+inttostr(RateStrF*6)+'���������]=Null,'
    +' ['+inttostr(RateStrF*6)+'����ͽ��]=Null '  ;
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' update #DeadStockList set '
    +' #DeadStockList.['+inttostr(RateStrF*1)+'���������]= '
    +' #StockListTtl.[����׼����] , '
    +' #DeadStockList.['+inttostr(RateStrF*1)+'����ͽ��]= '
    +' #StockListTtl.[�����]       '
    +' from #DeadStockList '
    +' left outer join #StockListTtl on '
    +' #StockListTtl.[��Ʒ����]= #DeadStockList.[��Ʒ����] '
    +' where #DeadStockList.[��Ʒ����] not in (select [��Ʒ����] '
    +' from #ExpenseList where [����]>='
    +Quotedstr(datetostr(date-RateStrF*1))
    +' and [ҵ�����]<>'+Quotedstr('Ԥ������')+'  )';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' update #DeadStockList set '
    +' #DeadStockList.['+inttostr(RateStrF*2)+'���������]= '
    +' #StockListTtl.[����׼����] , '
    +' #DeadStockList.['+inttostr(RateStrF*2)+'����ͽ��]= '
    +' #StockListTtl.[�����]       '
    +' from #DeadStockList '
    +' left outer join #StockListTtl on '
    +' #StockListTtl.[��Ʒ����]= #DeadStockList.[��Ʒ����] '
    +' where #DeadStockList.[��Ʒ����] not in (select [��Ʒ����] '
    +' from #ExpenseList where [����]>='
    +Quotedstr(datetostr(date-RateStrF*2))
    +' and [ҵ�����]<>'+Quotedstr('Ԥ������')+'  )';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' update #DeadStockList set '
    +' #DeadStockList.['+inttostr(RateStrF*3)+'���������]= '
    +' #StockListTtl.[����׼����] , '
    +' #DeadStockList.['+inttostr(RateStrF*3)+'����ͽ��]= '
    +' #StockListTtl.[�����]       '
    +' from #DeadStockList '
    +' left outer join #StockListTtl on '
    +' #StockListTtl.[��Ʒ����]= #DeadStockList.[��Ʒ����] '
    +' where #DeadStockList.[��Ʒ����] not in (select [��Ʒ����] '
    +' from #ExpenseList where [����]>='
    +Quotedstr(datetostr(date-RateStrF*3))
    +' and [ҵ�����]<>'+Quotedstr('Ԥ������')+'  )';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' update #DeadStockList set '
    +' #DeadStockList.['+inttostr(RateStrF*4)+'���������]= '
    +' #StockListTtl.[����׼����] , '
    +' #DeadStockList.['+inttostr(RateStrF*4)+'����ͽ��]= '
    +' #StockListTtl.[�����]       '
    +' from #DeadStockList '
    +' left outer join #StockListTtl on '
    +' #StockListTtl.[��Ʒ����]= #DeadStockList.[��Ʒ����] '
    +' where #DeadStockList.[��Ʒ����] not in (select [��Ʒ����] '
    +' from #ExpenseList where [����]>='
    +Quotedstr(datetostr(date-RateStrF*4))
    +' and [ҵ�����]<>'+Quotedstr('Ԥ������')+'  )';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' update #DeadStockList set '
    +' #DeadStockList.['+inttostr(RateStrF*5)+'���������]= '
    +' #StockListTtl.[����׼����] , '
    +' #DeadStockList.['+inttostr(RateStrF*5)+'����ͽ��]= '
    +' #StockListTtl.[�����]       '
    +' from #DeadStockList '
    +' left outer join #StockListTtl on '
    +' #StockListTtl.[��Ʒ����]= #DeadStockList.[��Ʒ����] '
    +' where #DeadStockList.[��Ʒ����] not in (select [��Ʒ����] '
    +' from #ExpenseList where [����]>='
    +Quotedstr(datetostr(date-RateStrF*5))
    +' and [ҵ�����]<>'+Quotedstr('Ԥ������')+'  )';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' update #DeadStockList set '
    +' #DeadStockList.['+inttostr(RateStrF*6)+'���������]= '
    +' #StockListTtl.[����׼����] , '
    +' #DeadStockList.['+inttostr(RateStrF*6)+'����ͽ��]= '
    +' #StockListTtl.[�����]       '
    +' from #DeadStockList '
    +' left outer join #StockListTtl on '
    +' #StockListTtl.[��Ʒ����]= #DeadStockList.[��Ʒ����] '
    +' where #DeadStockList.[��Ʒ����] not in (select [��Ʒ����] '
    +' from #ExpenseList where [����]>='
    +Quotedstr(datetostr(date-RateStrF*6))
    +' and [ҵ�����]<>'+Quotedstr('Ԥ������')+'  )';
  ADOQuery.ExecSQL;

  adsMaster.Close;
  adsMaster.CommandText :=' select * from #DeadStockList';
  adsMaster.Open;
  UpdateDBGrid;
  DBGrid.hint :='��������Ʒ����' ;
end;

procedure TSTNewStockRepForm.TheWareHouseGoodsActExecute(Sender: TObject);
var I:Integer;
begin
  for I:=0 to adsMaster.FieldCount-1 do
  begin
    if Pos('�ֿ�����',adsMaster.Fields[I].FieldName)>0 then
    begin
      WhereStr :=' Where [�ֿ�����]= '+Quotedstr(adsMaster.fieldbyname('�ֿ�����').AsString);
      if Button1.Tag=1 then Button1Click(sender)
        else Button2Click(sender);
      Memo1.Clear;
      Memo1.Text :='��ǰ������[�ֿ�����]='+Quotedstr(adsMaster.fieldbyname('�ֿ�����').AsString);
    end;
  end;
end;

end.
