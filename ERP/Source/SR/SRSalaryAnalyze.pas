unit SRSalaryAnalyze;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, Menus;

type
  TSRSalaryAnalyzeForm = class(TWSVoucherBrowseForm)
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
    adsMasterDSDesigner: TStringField;
    adsMasterDSDesigner2: TDateTimeField;
    adsMasterDSDesigner3: TStringField;
    adsMasterDSDesigner4: TStringField;
    adsMasterDSDesigner5: TBCDField;
    adsMasterDSDesigner6: TBCDField;
    adsMasterDSDesigner7: TBCDField;
    adsMasterDSDesigner8: TBCDField;
    adsMasterDSDesigner9: TBCDField;
    adsMasterDSDesigner10: TBCDField;
    adsMasterDSDesigner11: TBCDField;
    adsMasterDSDesigner12: TBCDField;
    adsMasterDSDesigner13: TBCDField;
    ADOQuery: TADOQuery;
    Panel2: TPanel;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure DBGridDblClick(Sender: TObject);
    procedure UpdateDBGrid;

  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  SRSalaryAnalyzeForm: TSRSalaryAnalyzeForm;

implementation

uses CommonDM ;

{$R *.dfm}

function TSRSalaryAnalyzeForm.CreateEditForm: TWSEditForm;
begin
//  Result :=;
end;



procedure TSRSalaryAnalyzeForm.FormCreate(Sender: TObject);
begin
  inherited;
  ADOQuery.Close;
  ADOQuery.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#TempSalary')
        +' )) DROP TABLE #TempSalary ' ;
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :='CREATE TABLE #TempSalary ( '
    +' [ID] [int] IDENTITY (1, 1) NOT NULL ,[�����ڼ�] [varchar] (30) , '
    +' [��н����] [datetime] NULL ,[��������] [varchar] (30)  ,         '
    +' [Ա������] [varchar] (30) , [ʵ����������] [float] NULL ,     '
    +' [���乤��] [float] NULL ,[�����Ӱ�] [float] NULL ,         '
    +' [�Ƽ�����] [float] NULL ,[��ʱ����] [float] NULL ,         '
    +' [Ӧ�����ʺϼ�] [float] NULL ,[�۳���Ŀ] [float] NULL ,        '
    +' [��������˰] [float] NULL , [ʵ������] [float] NULL  )    ';
  ADOQuery.ExecSQL;
  ADOQuery.Close;
  ADOQuery.SQL.Text :='insert into #TempSalary ( [�����ڼ�],'
    +' [��н����] ,[��������] ,  [Ա������] , [ʵ����������],  '
    +' [���乤��]  ,[�����Ӱ�] ,[�Ƽ�����] ,[��ʱ����] ,       '
    +' [Ӧ�����ʺϼ�],[�۳���Ŀ],  [��������˰]  , [ʵ������] )'
    +' select b.brief as [�����ڼ�],b.clearDate as [��н����] , '
    +' d.name as [��������], c.name  as [Ա������],             '
    +' sum(isnull(a.SundryFee,0)) as [ʵ����������], '
    +' sum(isnull(a.PriceBase,0)) as [���乤��],'
    +' sum(isnull(a.GoalQuantity,0)) as [�����Ӱ�], '
    +' sum(isnull(a.QuantityPcs,0))  as [�Ƽ�����] ,'
    +' sum(isnull(a.TimeAmount,0))   as [��ʱ����], '
    +' sum(isnull(a.SalaryAmount,0)) as [Ӧ�����ʺϼ�],'
    +' sum(isnull(a.Discount,0))     as [�۳���Ŀ], '
    +' sum(isnull(a.TaxAmount,0))    as [��������˰],  '
    +' sum(isnull(a.Payable,0))  as [ʵ������]   '
    +' from  SRBaseSalaryDetail a                                  '
    +' left outer join SRBaseSalaryMaster b on b.ID=a.MasterID     '
    +' left outer join MSEmployee c on c.ID=a.GoalUnitID           '
    +' left outer join MSDepartment d on d.ID=c.DepartmentID     '
    +' where b.recordstate<>'+Quotedstr('ɾ��')
    +' group by b.brief,b.clearDate,d.name,c.name';
  ADOQuery.ExecSQL;
  adsMaster.Close;
  adsMaster.CommandText :=' select'
        +'[�����ڼ�], [��н����] ,[��������] ,  [Ա������] , '
        +' [ʵ����������],[���乤��],[�����Ӱ�],[�Ƽ�����], '
        +' [��ʱ����],[Ӧ�����ʺϼ�],[�۳���Ŀ],'
        +'  [��������˰]  ,[ʵ������] '
        +' from #TempSalary '
        +' order by [��н����],[�����ڼ�],[��������],[Ա������] DESC';
  adsMaster.Open;
  UpdateDBGrid;
end;

procedure TSRSalaryAnalyzeForm.DBGridCellClick(Column: TColumn);
begin
  UpdateDBGrid;
end;

procedure TSRSalaryAnalyzeForm.DBGridDblClick(Sender: TObject);
begin
  UpdateDBGrid;
end;

procedure TSRSalaryAnalyzeForm.UpdateDBGrid;
var  I: Integer;
begin
  with DBGrid do
  begin
    FooterRowCount := 0;
    Columns[0].Footer.ValueType := fvtStaticText;
    Columns[0].Footer.Value := '�ϼ�:';
    Columns[0].Footer.Alignment := taCenter;
    Columns[0].Title.Alignment:= taCenter;
    for I := 1 to Columns.Count - 1 do
    begin
      Columns[i].Width :=90;
      if Pos('��',Columns[I].FieldName)>0 then Columns[i].Width :=70;
      if Pos('��',Columns[I].FieldName)>0 then Columns[i].Width :=70;
      Columns[i].Title.Alignment:= taCenter;
      if Columns[I].Field is TNumericField then
      if Pos('Price',Columns[I].FieldName)<=0 then
        Columns[I].Footer.ValueType := fvtSum;
    end;
    FooterRowCount := 1;
  end;
end;


end.
