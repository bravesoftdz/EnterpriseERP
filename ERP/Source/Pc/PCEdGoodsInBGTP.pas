unit PCEdGoodsInBGTP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseVoucherEdit, Menus, ActnList, DB, ComCtrls, StdCtrls, Mask,
  DBCtrls, ExtCtrls, ToolWin, Grids, DBGrids, QLDBGrid, ADODB, GEdit,
  QLDBLkp;

type
  TPCEdGoodsInBGTPForm = class(TBaseVoucherEditForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ClientName: TADODataSet;
    EmployeeName: TADODataSet;
    GoodName: TADODataSet;
    Label5: TLabel;
    PackUnit: TADODataSet;
    dsPackUnit: TDataSource;
    DSClientName: TDataSource;
    DSEmployeeName: TDataSource;
    ClientQLDBLookup: TQLDBLookupComboBox;
    LookupEmployee: TQLDBLookupComboBox;
    Label6: TLabel;
    Label7: TLabel;
    LookupPackUint: TQLDBLookupComboBox;
    TempAds: TADODataSet;
    adsMaster: TADODataSet;
    adsDetail: TADODataSet;
    adsDetailID: TAutoIncField;
    adsDetailMasterID: TIntegerField;
    adsDetailGoodsID: TIntegerField;
    adsDetailQuantity: TBCDField;
    adsDetailQuantityPcs: TBCDField;
    adsDetailPackUnitID: TIntegerField;
    adsDetailPriceBase: TBCDField;
    adsDetailAmount: TBCDField;
    adsDetailDiscount: TBCDField;
    adsDetailGoalQuantity: TBCDField;
    adsDetailSundryFee: TBCDField;
    adsDetailGoalUnitID: TIntegerField;
    adsMasterID: TAutoIncField;
    adsMasterCreateDate: TDateTimeField;
    adsMasterCreateUserID: TIntegerField;
    adsMasterRecordState: TStringField;
    adsMasterDate: TDateTimeField;
    adsMasterCode: TStringField;
    adsMasterClientID: TIntegerField;
    adsMasterBillMode: TStringField;
    adsMasterPeriodID: TIntegerField;
    adsMasterClearDate: TDateTimeField;
    adsMasterMemo: TStringField;
    adsMasterSundryFee: TBCDField;
    Label8: TLabel;
    adsMasterClientName: TStringField;
    adsDetailPackUnit: TStringField;
    DiscountMode: TAction;
    adsMasterEmployeeID: TIntegerField;
    adsMasterApportion: TStringField;
    adsMasterDeliver: TStringField;
    adsMasterOriginID: TIntegerField;
    adsMasterOriginTable: TStringField;
    adsMasterBillAffix: TBytesField;
    adsDetailMemo: TStringField;
    adsMasterBrief: TStringField;
    BriefComboBox: TDBComboBox;
    Label9: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label10: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label4: TLabel;
    DBEdit5: TDBEdit;
    GEdit1: TGEdit;
    adsDetailTaxAmount: TBCDField;
    adsDetailGoodsSpec: TStringField;
    adsGoodsSpec: TADODataSet;
    dsGoodsSpec: TDataSource;
    adsMasterEmployee: TStringField;
    GoalUnit: TADODataSet;
    dsGoalUnit: TDataSource;
    adsDetailGoalUnit: TStringField;
    StockQuerry: TAction;
    adsMasterWarehouseID: TIntegerField;
    adsWarehouse: TADODataSet;
    dsWarehouse: TDataSource;
    LookupWarehouse: TQLDBLookupComboBox;
    adsMasterModeDC: TIntegerField;
    adsMasterModeC: TIntegerField;
    adsDetailGoodsName: TStringField;
    TpPackUnit: TADOQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure adsDetailGoodsIDChange(Sender: TField);
    procedure adsDetailPackUnitIDChange(Sender: TField);
    procedure adsDetailPriceBaseChange(Sender: TField);
    procedure adsDetailGoalQuantityChange(Sender: TField);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open(VoucherID: Integer); override;
    procedure New; override;
  end;

var
  PCEdGoodsInBGTPForm: TPCEdGoodsInBGTPForm;

implementation

uses CommonDM, WSUtils, WSSecurity;
{$R *.dfm}
procedure TPCEdGoodsInBGTPForm.New;
begin
  inherited;
  adsMaster.FieldByName('Date').AsDateTime :=date;
  adsMaster.FieldByName('Code').AsString:=GetMaxCode('Code','PCGoodsInMaster',number);
  adsMaster.FieldByName('CreateUserID').AsInteger :=Guarder.UserID;
//  adsMaster.FieldByName('BillMode').ReadOnly :=False;
  adsMaster.FieldByName('BillMode').AsString:='�˻�����';
//  adsMaster.FieldByName('BillMode').ReadOnly :=True;
  adsMaster.FieldByName('ModeDC').AsInteger:=-1;
  adsMaster.FieldByName('ModeC').AsInteger:=1;
  adsMaster.FieldByName('OriginTable').AsString :='PCGoodsInMaster';
  adsMaster.FieldByName('Deliver').AsString:='--';
  adsMaster.FieldByName('Apportion').AsString:='--';
end;

procedure TPCEdGoodsInBGTPForm.Open(VoucherID: Integer);
begin
  inherited Open(VoucherID);
end;


procedure TPCEdGoodsInBGTPForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  adsMaster.Close;
  adsDetail.Close;
  ClientName.Close;
  EmployeeName.Close;
  GoodName.Close;
  PackUnit.Close;
  adsWarehouse.Close;
  adsGoodsSpec.Close;
end;

procedure TPCEdGoodsInBGTPForm.FormCreate(Sender: TObject);
var GoodsSpecStr:string;
begin
  inherited;
  VoucherTableName := 'PCGoodsIn';
  ClientName.Open;
  EmployeeName.Open;
  GoodName.Open;
  PackUnit.Open;
  adsWarehouse.Open;
  TempAds.close;
  TempAds.CommandText :='select distinct levelcode from DAAttribute'
      +' where name like'+Quotedstr('%��Ʒ%')+' and upid=-1';
  TempAds.open;
  TempAds.First;
  GoodsSpecStr :=' where (1<>1 ';
  while not TempAds.Eof do
  begin
    GoodsSpecStr :=GoodsSpecStr+' or Levelcode like '+Quotedstr('%'+
        Trim(TempAds.fieldbyname('Levelcode').AsString)+'%') ;
    TempAds.Next;
  end;
  GoodsSpecStr :=' select * from DAAttribute '+ GoodsSpecStr
      +' ) and (upid<>-1 and Recordstate<>'+Quotedstr('ɾ��')+')';
  adsGoodsSpec.Close;
  adsGoodsSpec.CommandText :=GoodsSpecStr;
  adsGoodsSpec.Open;
  TempAds.Close;
  TempAds.CommandText :=' select Distinct brief from PCGoodsInMaster';
  TempAds.Open;
  TempAds.First;
  while not TempAds.Eof do
  begin
    BriefComboBox.Items.Add(TempAds.FieldByName('brief').AsString);
    TempAds.Next;
  end;
  if  TempAds.IsEmpty then  BriefComboBox.Items.Add('�˻�');
end;

procedure TPCEdGoodsInBGTPForm.FormShow(Sender: TObject);
var  adoTemp: TADOQuery;
begin
  inherited;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  adoTemp.Close;
  adoTemp.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#TempPackUnit3')
        +' )) DROP TABLE #TempPackUnit3 ' ;
  adoTemp.ExecSQL;
  adoTemp.Close;
  adoTemp.SQL.Text :=' create table #TempPackUnit3 ('
      +'	PID [int] IDENTITY (1, 1) NOT NULL ,'
      +'	ID [int] NULL ,'
      +'	[CreateDate] [datetime] NULL ,       '
      +'	[CreateUserID] [int] NULL ,          '
      +'	[RecordState] [varchar] (12)  NULL , '
      +'	[Name] [varchar] (20)   NULL ,'
      +'	[ExchangeRate] [decimal](9, 4) NULL ,'
      +'	[GoalUnitID] [int] NULL ,            '
      +'	[IsGoalUnit] [bit] NOT NULL    )     ';
  adoTemp.ExecSQL;
  ClientQLDBLookup.SetFocus;
end;

procedure TPCEdGoodsInBGTPForm.adsDetailGoodsIDChange(Sender: TField);
var SGoodsID,SUnitID,IsInGoods:integer;
begin
  inherited;
  if (adsDetail.fieldbyname('GoodsID').IsNull) or (adsDetail.fieldbyname('GoodsID').AsInteger=0)
     then  SGoodsID :=1 else  SGoodsID :=adsDetail.fieldbyname('GoodsID').AsInteger;
  TempAds.Close;   //ȡ��׼��λ�ͻ�������
  TempAds.CommandText :='select UnitID,PriceSales,PricePurchase  from DAGoods where Id='
      + Inttostr(SGoodsID);
  TempAds.Open;
  if  TempAds.FieldByName('UnitID').IsNull then SunitID :=1
    else SunitID :=TempAds.FieldByName('UnitID').AsInteger;

//  adsDetail.FieldByName('GoalUnitID').ReadOnly :=False;
  adsDetail.FieldByName('GoalUnitID').AsInteger :=SunitID;
//  adsDetail.FieldByName('GoalUnitID').ReadOnly :=True;

//  adsDetail.FieldByName('PriceBase').ReadOnly :=False;
  if adsDetail.FieldByName('PriceBase').AsFloat=0 then
     adsDetail.FieldByName('PriceBase').AsFloat := TempAds.FieldByName('PricePurchase').AsFloat  ;
  if adsDetail.FieldByName('PriceBase').IsNull then adsDetail.FieldByName('PriceBase').AsFloat :=0;

  IsInGoods :=0;
  TpPackUnit.Close;
  TpPackUnit.SQL.Text :='Truncate Table #TempPackUnit3 ';
  TpPackUnit.ExecSQL;
  TpPackUnit.Close;
  TpPackUnit.SQL.Text :=' select a.AddUnitID ID, b.name,a.AddUnitRate '
    +' ExchangeRate,a.UnitID GoalUnitID,b.IsGoalUnit '
    +' from DAGoods a    '
    +' left outer join MSUnit b on b.ID=a.AddUnitID    '
    +' where a.AddUnitID is not null and AddUnitID<>0 and a.AddUnitRate '
    +' is not null and a.AddUnitRate<>0 and a.ID= '+inttostr(SGoodsID) ;
  TpPackUnit.Open;
  if not TpPackUnit.IsEmpty then
  begin
    IsInGoods :=1;
    TpPackUnit.Close;   //����Ʒ���ϱ��ĵ�λ�����ʲ���  #TempPackUnit3
    TpPackUnit.SQL.Text :=' insert into #TempPackUnit3 '
      +' (ID, Name, ExchangeRate, GoalUnitID, IsGoalUnit )'
      +'select a.AddUnitID ID, b.name,a.AddUnitRate '
      +' ExchangeRate,a.UnitID GoalUnitID,b.IsGoalUnit '
      +' from DAGoods a    '
      +' left outer join MSUnit b on b.ID=a.AddUnitID    '
      +' where a.AddUnitID is not null and AddUnitID<>0 and a.AddUnitRate '
      +' is not null and a.AddUnitRate<>0 and a.ID= '+inttostr(SGoodsID) ;
    TpPackUnit.ExecSQL;
  end;
  TpPackUnit.Close;    //����λ���ϱ��Ļ����ʲ���  #TempPackUnit3
  TpPackUnit.SQL.Text :=' insert into #TempPackUnit3 '
      +' (ID, Name, ExchangeRate, GoalUnitID, IsGoalUnit )  '
      +' select ID, Name, ExchangeRate, GoalUnitID, IsGoalUnit '
      +' from MSUnit where RecordState<>'+QuotedStr('ɾ��')
      +' Order by GoalUnitID,IsGoalUnit desc ';
  TpPackUnit.ExecSQL;
  PackUnit.Close;  //��ʾ��λ�б��뻻����
  PackUnit.CommandText :=' select PID, ID, Name, ExchangeRate, GoalUnitID, IsGoalUnit '
      +' from #TempPackUnit3 Order by PID';
  PackUnit.Open;
  if IsInGoods=0 then
  begin
   PackUnit.Locate('ID',Inttostr(SunitID),[]);
   if not PackUnit.Eof then PackUnit.Next;
  end else   PackUnit.First;
  adsDetail.FieldByName('PackUnitID').AsInteger :=PackUnit.FieldByName('ID').AsInteger;
end;


procedure TPCEdGoodsInBGTPForm.adsDetailPackUnitIDChange(Sender: TField);
var ExChRate :real;
begin
  PackUnit.Locate('ID', adsDetail.fieldbyname('PackUnitID').AsString, []);
  if PackUnit.fieldbyname('ExchangeRate').IsNull then ExChRate :=1
     else ExChRate :=PackUnit.fieldbyname('ExchangeRate').AsFloat ;
//  adsDetail.FieldByName('Quantity').ReadOnly :=False;
  adsDetail.FieldByName('Quantity').AsFloat :=
       adsDetail.fieldbyname('GoalQuantity').AsFloat/ExChRate;
//  adsDetail.FieldByName('Quantity').ReadOnly :=True;
end;

procedure TPCEdGoodsInBGTPForm.adsDetailPriceBaseChange(Sender: TField);
begin
  inherited;
//  adsDetail.FieldByName('Amount').ReadOnly :=False;
  adsDetail.FieldByName('Amount').AsFloat :=
       adsDetail.fieldbyname('GoalQuantity').asfloat
         *adsDetail.fieldbyname('PriceBase').AsFloat;
//  adsDetail.FieldByName('Amount').ReadOnly :=True;
end;


procedure TPCEdGoodsInBGTPForm.adsDetailGoalQuantityChange(Sender: TField);
var   ExChRate :real;
begin
  PackUnit.Locate('ID', adsDetail.fieldbyname('PackUnitID').AsString, []);
  if PackUnit.fieldbyname('ExchangeRate').IsNull then ExChRate :=1
     else ExChRate :=PackUnit.fieldbyname('ExchangeRate').AsFloat;
//  adsDetail.FieldByName('Quantity').ReadOnly :=False;
  adsDetail.FieldByName('Quantity').AsFloat :=
       adsDetail.fieldbyname('GoalQuantity').AsFloat/ExChRate;
//  adsDetail.FieldByName('Quantity').ReadOnly :=True;

//  adsDetail.FieldByName('Amount').ReadOnly :=False;
  adsDetail.FieldByName('Amount').AsFloat :=
       adsDetail.fieldbyname('GoalQuantity').asfloat
         *adsDetail.fieldbyname('PriceBase').AsFloat;
//  adsDetail.FieldByName('Amount').ReadOnly :=True;
end;

end.