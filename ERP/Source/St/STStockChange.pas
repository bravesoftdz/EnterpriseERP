unit STStockChange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, GEdit,
  DBCtrls, Menus, WNADOCQuery,TypInfo, CheckLst;

type
  TSTStockChangeFrom = class(TWSVoucherBrowseForm)
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
    VipsetPanel: TPanel;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Button5: TButton;
    Button6: TButton;
    ListGoodsDetailAct: TAction;
    ListGoodsDetail: TMenuItem;
    ListGoodsClassAct: TAction;
    ListGoodsClass: TMenuItem;
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
    procedure ExpSttcCheckListBoxClickCheck(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure IniStockChange;
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker2Change(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ListGoodsDetailActExecute(Sender: TObject);
    procedure ListGoodsClassActExecute(Sender: TObject);
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
  STStockChangeFrom: TSTStockChangeFrom;

implementation

uses CommonDM,QLDBFlt;

{$R *.dfm}

function TSTStockChangeFrom.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TSTStockChangeFrom.UpdateDBGrid;
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

procedure TSTStockChangeFrom.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

procedure TSTStockChangeFrom.DBGridDblClick(Sender: TObject);
begin
// inherited;
end;


procedure TSTStockChangeFrom.Button3Click(Sender: TObject);
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

procedure TSTStockChangeFrom.FormShow(Sender: TObject);
var I :integer;
begin
  inherited;
//��Ҫ������ˮ��¼��
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#InOutlist')
        +' )) DROP TABLE #InOutlist ' ;
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
    +' a.GoalUnitID [�����־] ,'
    +' b.Memo [��ע] , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],  '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���], '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]               '
    +' into #InOutlist '
    +' from SLGoodsOutDetail a                   '
    +' left outer join SLGoodsOutMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//���۳���
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update  #InOutlist set [�����־]=-1 ';
  ADOQuery.ExecSQL;

//�ɹ����--
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' 1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from PCGoodsInDetail a                   '
    +' left outer join PCGoodsInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//�ɹ����--

//�������==
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' 1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],  '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from YDGoodsInDetail a                   '
    +' left outer join YDGoodsInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//�������==

//��������==
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' -1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from YDGoodsOutDetail a                   '
    +' left outer join YDGoodsOutMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//��������==

//��Ŀ����==
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' -1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from EGGoodsOutDetail a                   '
    +' left outer join EGGoodsOutMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0) <>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//��Ŀ����==

//����������
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' -1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from STGoodsOutInDetail a                   '
    +' left outer join STGoodsOutInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.ClientID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and  isnull(b.ClientID,0)<>0  and isnull(a.GoodsID,0)<>0 '
    +' order by  b.date ,b.code,a.ID ';

  ADOQuery.ExecSQL;
//����������


//���������
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' 1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from STGoodsOutInDetail a                   '
    +' left outer join STGoodsOutInMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and  isnull(b.WareHouseID,0)<>0  and isnull(a.GoodsID,0)<>0 '
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//���������

//��ӯ���
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' 1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from STGoodsCountOffDetail a                   '
    +' left outer join STGoodsCountOffMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0)<>0 and BillMode='+Quotedstr('�����ӯ')
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//��ӯ���

//�̿�����
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' insert into  #InOutlist ( '
    +' [����], [���],[ҵ�����],[������] , [�ֿ�����], '
    +' [��Ʒ���], [��Ʒ����],[����ͺ�],[��׼��λ],'
    +' [�����־] , [��ע] , '
    +' [��׼����], [��׼����],[���],[��װ��λ],    '
    +' [��װ����], [��װ����]  )'
    +' select b.Date [����], '
    +' b.Code [���],                        '
    +' b.BillMode [ҵ�����],                '
    +' d.name  [������] ,                    '
    +' c.name [�ֿ�����],                    '
    +' h.name [��Ʒ���],                    '
    +' e.name [��Ʒ����],                    '
    +' a.GoodsSpec [����ͺ�],               '
    +' g.name [��׼��λ],                    '
    +' -1, b.Memo , '
    +' a.GoalQuantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��׼����],            '
    +' a.PriceGoal [��׼����],                '
    +' a.Amount*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [���],                  '
    +' f.name     [��װ��λ],                '
    +' a.Quantity*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1) [��װ����],     '
    +' a.PriceBase [��װ����]                '
    +' from STGoodsCountOffDetail a                   '
    +' left outer join STGoodsCountOffMaster     b on b.ID=a.MasterID      '
    +' left outer join STWarehouse         c on c.ID=b.WareHouseID      '
    +' left outer join MSEmployee       d on d.ID=b.EmployeeID    '
    +' left outer join DAGoods          e on e.ID=a.GoodsID       '
    +' left outer join MSUnit           f on f.ID=a.PackUnitID    '
    +' left outer join MSUnit           g on g.ID=e.UnitID    '
    +' left outer join DAGoodsClass     h on h.ID=e.GoodsClassID  '
    +' where b.RecordState<>'+ Quotedstr('ɾ��')
    +' and isnull(a.GoodsID,0)<>0 and BillMode<>'+Quotedstr('�����ӯ')
    +' order by  b.date ,b.code,a.ID ';
  ADOQuery.ExecSQL;
//�̿�����

  IniStockChange; //������ʼ���䶯��ϸ���ݱ�


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

procedure TSTStockChangeFrom.Button1Click(Sender: TObject);
begin
  Panel6.Visible :=True;
  Panel6.Repaint;
  Button1.Tag:=1 ;
  adsMaster.Close;
  adsMaster.CommandText:=' select *  '
    +' from #ExpenseList'+WhereStr
    +' order by [����], [���]' ;
//  showmessage(adsMaster.CommandText);
  adsMaster.open;
  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='';
end;

procedure TSTStockChangeFrom.FormActivate(Sender: TObject);
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
end;

procedure TSTStockChangeFrom.Button2Click(Sender: TObject);
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
  ADOQuery.SQL.Text:=' Update #ExpenseListTtl set '
    +' 	[�ڳ���׼����]	 =	[�ڳ����]	   /	[�ڳ���׼����]		 '
    +' where Isnull([�ڳ���׼����],0)<>0 ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Update #ExpenseListTtl set '
    +' 	[��ⵥ��]	 =	[�����]	   /	[����׼����]		 '
    +' where Isnull([����׼����],0)<>0 ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Update #ExpenseListTtl set '
    +' 	[����װ����]	 =	[�����]	   /	[����װ����]		 '
    +' where Isnull([����װ����],0)<>0 ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Update #ExpenseListTtl set '
    +' 	[���ⵥ��]	 =	[������]	   /	[�����׼����]		 '
    +' where Isnull([�����׼����],0)<>0 ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Update #ExpenseListTtl set '
    +' 	[�����װ����]	 =	[������]	   /	[�����װ����]		 '
    +' where Isnull([�����װ����],0)<>0 ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text:=' Update #ExpenseListTtl set '
    +' 	[��ĩ��׼����]	 =	[��ĩ���]	   /	[��ĩ��׼����]		 '
    +' where Isnull([��ĩ��׼����],0)<>0 ';
  ADOQuery.ExecSQL;

  adsMaster.Close;
  adsMaster.CommandText:=' select * from #ExpenseListTtl ';
  adsMaster.open;

  Panel6.Visible :=False;
  UpdateDBGrid;
  DBGrid.hint :='������Ŀ:'+SelectStr1;
end;

procedure TSTStockChangeFrom.N1Click(Sender: TObject);
begin
  ExpSttcCheckListBox.Sorted :=not ExpSttcCheckListBox.Sorted;
end;

procedure TSTStockChangeFrom.N2Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=not ExpSttcCheckListBox.Checked[I];
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTStockChangeFrom.N3Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=True;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTStockChangeFrom.N4Click(Sender: TObject);
var I:integer;
begin
  for I := 0 to ExpSttcCheckListBox.Items.Count - 1 do
  begin
    ExpSttcCheckListBox.Checked[I] :=False;
    ExpSttcCheckListBox.ItemIndex := I;
    ExpSttcCheckListBox.OnClickCheck(ExpSttcCheckListBox);
  end;
end;

procedure TSTStockChangeFrom.adsMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  adsMaster.IndexFieldNames := '';
end;

procedure TSTStockChangeFrom.ExpSttcCheckListBoxClickCheck(
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

procedure TSTStockChangeFrom.Button4Click(Sender: TObject);
begin
  inherited;
  Panel2.Enabled :=False;
  DBGrid.Enabled :=False;
  VipsetPanel.Visible :=True;
  VipsetPanel.Repaint;
end;

procedure TSTStockChangeFrom.IniStockChange;
begin
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#ExpenseList')
        +' )) DROP TABLE #ExpenseList ' ;
  ADOQuery.ExecSQL;
//�����ڳ����
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' select top 1 [����],[���],[ҵ�����], '
    +' [������] ,[�ֿ�����],[��Ʒ���],[��Ʒ����],'
    +' [����ͺ�],[��׼��λ],[��ע] , '
    +' 	[��׼����]	[�ڳ���׼����]	,	 '
    +' 	[��׼����]	[�ڳ���׼����]	,	 '
    +' 	[��׼����]	[�ڳ����]	,	 '
    +' 	[��׼����]	[����׼����]	,	 '
    +' 	[��׼����]	[��ⵥ��]	,	 '
    +' 	[��׼����]	[�����]	,	 '
    +' 	[��׼��λ]	[����װ��λ]	,	 '
    +' 	[��׼����]	[����װ����]	,	 '
    +' 	[��׼����]	[����װ����]	,	 '
    +' 	[��׼����]	[�����׼����]	,	 '
    +' 	[��׼����]	[���ⵥ��]	,	 '
    +' 	[��׼����]	[������]	,	 '
    +' 	[��׼��λ]	[�����װ��λ]	,	 '
    +' 	[��׼����]	[�����װ����]	,	 '
    +' 	[��׼����]	[�����װ����]	,	 '
    +' 	[��׼����]	[��ĩ��׼����]	,	 '
    +' 	[��׼����]	[��ĩ��׼����]	,	 '
    +' 	[��׼����]	[��ĩ���]	         '
    +' into #ExpenseList '
    +' from #InOutlist                    ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Truncate Table #ExpenseList ';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert Into  #ExpenseList ( '
    +' [����],[���],[ҵ�����], '
    +' [������] ,[�ֿ�����],[��Ʒ���],[��Ʒ����],'
    +' [����ͺ�],[��׼��λ],[��ע] , '
    +' [�ڳ���׼����],[�ڳ���׼����],[�ڳ����]	)   '
    +' select '+Quotedstr(DateTostr(DateTimePicker1.Date-1))
    +' [����], '+Quotedstr('----')+' [���], '+Quotedstr('�ڳ����')
    +' [ҵ�����],'+Quotedstr('----')+' [������] ,'
    +  Quotedstr('--------')+' [�ֿ�����], [��Ʒ���], '
    +' [��Ʒ����],'+Quotedstr('----')+' [����ͺ�],               '
    +' [��׼��λ], ' + Quotedstr('���')+' [��ע] , '
    +' sum(Isnull([��׼����],0)*Isnull([�����־],1)) [�ڳ���׼����] ,  '
    +' sum(Isnull([��׼����],0)) [�ڳ���׼����],                '
    +' sum(Isnull([���],0)*Isnull([�����־],1)) [�ڳ����]  '
    +' from #InOutlist       '
    +' where [����]<='+ Quotedstr(DateTostr(DateTimePicker1.Date-1))
    +' group by  [��Ʒ���],[��Ʒ����],[��׼��λ]' ;
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update #ExpenseList set '
    +' [�ڳ���׼����]= [�ڳ����]/[�ڳ���׼����]  '
    +' where Isnull([�ڳ���׼����],0)<>0 ' ;
  ADOQuery.ExecSQL;

//�������
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into #ExpenseList ( '
    +' [����], [���], [ҵ�����],'
    +' [������],[�ֿ�����],[��Ʒ���],[��Ʒ����], '
    +' [����ͺ�],[��׼��λ],[��ע] , '
    +' [����׼����],[��ⵥ��], [�����], '
    +' [����װ��λ],[����װ����],[����װ����] )'
    +' select '
    +' [����], [���], [ҵ�����],'
    +' [������],[�ֿ�����],[��Ʒ���],[��Ʒ����], '
    +' [����ͺ�],[��׼��λ],[��ע] , '
    +' [��׼����],[��׼����], [���], '
    +' [��װ��λ],[��װ����],[��װ����] '
    +' from #InOutlist                   '
    +' where [����]>'+ Quotedstr(DateTostr(DateTimePicker1.Date-1))
    +' and [����]<='+ Quotedstr(DateTostr(DateTimePicker2.Date))
    +' and [�����־]=1';
  ADOQuery.ExecSQL;

//���ڳ���
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Insert into #ExpenseList ( '
    +' [����], [���], [ҵ�����],'
    +' [������],[�ֿ�����],[��Ʒ���],[��Ʒ����], '
    +' [����ͺ�],[��׼��λ],[��ע] , '
    +' [�����׼����],[���ⵥ��], [������], '
    +' [�����װ��λ],[�����װ����],[�����װ����] )'
    +' select '
    +' [����], [���], [ҵ�����],'
    +' [������],[�ֿ�����],[��Ʒ���],[��Ʒ����], '
    +' [����ͺ�],[��׼��λ],[��ע] , '
    +' [��׼����],[��׼����], [���], '
    +' [��װ��λ],[��װ����],[��װ����] '
    +' from #InOutlist                   '
    +' where [����]>'+ Quotedstr(DateTostr(DateTimePicker1.Date-1))
    +' and [����]<='+ Quotedstr(DateTostr(DateTimePicker2.Date))
    +' and [�����־]=-1';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update #ExpenseList set '
    +' [��ĩ��׼����]=Isnull([�ڳ���׼����],0)+Isnull([����׼����],0)-'
    +' isnull([�����׼����],0)  , '
    +' [��ĩ���]=isnull([�ڳ����],0)+isnull([�����],0)-isnull([������],0)';
  ADOQuery.ExecSQL;

  ADOQuery.Close;
  ADOQuery.SQL.Text :=' Update #ExpenseList set '
    +' [��ĩ��׼����]= [��ĩ���]/[��ĩ��׼����]  '
    +' where Isnull([��ĩ��׼����],0)<>0 ' ;
  ADOQuery.ExecSQL;


  //
end;

procedure TSTStockChangeFrom.Button6Click(Sender: TObject);
begin
  VipsetPanel.Visible :=False;
  Panel2.Enabled :=not VipsetPanel.Visible;
  DBGrid.Enabled :=not VipsetPanel.Visible;
end;

procedure TSTStockChangeFrom.FormCreate(Sender: TObject);
var year,month,day:word;
begin
  inherited;
  DecodeDate(date,year,month,day)  ;
  DateTimePicker1.Date :=Encodedate(year,month,1);
  DateTimePicker2.Date :=date;
end;

procedure TSTStockChangeFrom.DateTimePicker2Change(Sender: TObject);
begin
  if DateTimePicker2.Date<=DateTimePicker1.Date then  DateTimePicker1.Date :=DateTimePicker2.Date;
end;

procedure TSTStockChangeFrom.DateTimePicker1Change(Sender: TObject);
begin
  if DateTimePicker1.Date>DateTimePicker2.Date then  DateTimePicker2.Date :=DateTimePicker1.Date;
end;

procedure TSTStockChangeFrom.Button5Click(Sender: TObject);
begin
  IniStockChange;
  VipsetPanel.Visible :=False;
  Panel2.Enabled :=True;
  DBGrid.Enabled :=True;
  if Button1.Tag=1 then Button1Click(sender)
    else Button2Click(Sender);

end;

procedure TSTStockChangeFrom.ListGoodsDetailActExecute(Sender: TObject);
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

procedure TSTStockChangeFrom.ListGoodsClassActExecute(Sender: TObject);
var I:Integer;
  Goods :string;
begin
  for I:=0 to adsMaster.FieldCount-1 do
  begin
    if Pos('��Ʒ���',adsMaster.Fields[I].FieldName)>0 then
    begin
      Goods := adsMaster.FieldByName('��Ʒ���').AsString;
      if Trim(Goods)='' then Exit;
      adsMaster.Close;
      adsMaster.CommandText :='select * from #ExpenseList  where  [��Ʒ���]='+Quotedstr(Goods);
      adsMaster.Open;
      UpdateDBGrid;
      Exit;
    end;
  end;
end;

procedure TSTStockChangeFrom.adsMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  RefreshAvailableFields;
end;

end.
