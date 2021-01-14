unit SLEdContractPrice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseVoucherEdit, Menus, ActnList, DB, ComCtrls, StdCtrls, Mask,
  DBCtrls, ExtCtrls, ToolWin, Grids, DBGrids, QLDBGrid, ADODB, GEdit,
  QLDBLkp,QLDBFlt;

type
  TSLEdContractPriceForm = class(TBaseVoucherEditForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ClientName: TADODataSet;
    GoodName: TADODataSet;
    PackUnit: TADODataSet;
    dsPackUnit: TDataSource;
    DSClientName: TDataSource;
    ClientQLDBLookup: TQLDBLookupComboBox;
    TempAds: TADODataSet;
    adsMaster: TADODataSet;
    adsDetail: TADODataSet;
    Label8: TLabel;
    DiscountMode: TAction;
    BriefComboBox: TDBComboBox;
    Label9: TLabel;
    DBEdit1: TDBEdit;
    DBEdit5: TDBEdit;
    adsGoodsSpec: TADODataSet;
    dsGoodsSpec: TDataSource;
    GoalUnit: TADODataSet;
    dsGoalUnit: TDataSource;
    StockQuerry: TAction;
    adsMasterID: TAutoIncField;
    adsMasterCreateDate: TDateTimeField;
    adsMasterCreateUserID: TIntegerField;
    adsMasterRecordState: TStringField;
    adsMasterDate: TDateTimeField;
    adsMasterCode: TStringField;
    adsMasterContractClass: TStringField;
    adsMasterClientID: TIntegerField;
    adsMasterStartDate: TDateTimeField;
    adsMasterExpireDate: TDateTimeField;
    adsMasterMemo: TStringField;
    adsMasterclient: TStringField;
    adsDetailID: TAutoIncField;
    adsDetailMasterID: TIntegerField;
    adsDetailGoodsID: TIntegerField;
    adsDetailSpec: TStringField;
    adsDetailQuantity: TBCDField;
    adsDetailQuantityE: TBCDField;
    adsDetailPackUnitID: TIntegerField;
    adsDetailGoalUnitID: TIntegerField;
    adsDetailPriceClear: TBCDField;
    adsDetailPriceMax: TBCDField;
    adsDetailPriceMin: TBCDField;
    adsDetailpackunit: TStringField;
    adsDetailgoalunit: TStringField;
    adsDetailGoodsName: TStringField;
    PackUintFltAQ: TADODataSet;
    PackUintFltDS: TDataSource;
    adsDetailPriceGoal: TBCDField;
    GoodsIDSelectBtt: TButton;
    adsDetailMemo: TStringField;
    HoldOnPriceAction: TAction;
    N33: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure adsDetailGoodsIDChange(Sender: TField);
    procedure LookupPackUintEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LookupPackUintExit(Sender: TObject);
    procedure GoodsIDSelectBttClick(Sender: TObject);
    procedure HoldOnPriceActionExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open(VoucherID: Integer); override;
    procedure New; override;
  end;

var
  SLEdContractPriceForm: TSLEdContractPriceForm;

implementation

uses CommonDM, WSUtils, WSSecurity;
{$R *.dfm}
procedure TSLEdContractPriceForm.New;
begin
  inherited;
  adsMaster.FieldByName('Date').AsDateTime :=date;
  adsMaster.FieldByName('Code').AsString:=GetMaxCode('Code','SLContractPriceMaster ',number);
  adsMaster.FieldByName('CreateUserID').AsInteger :=Guarder.UserID;
end;

procedure TSLEdContractPriceForm.Open(VoucherID: Integer);
begin
  inherited Open(VoucherID);
end;


procedure TSLEdContractPriceForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  adsMaster.Close;
  adsDetail.Close;
  ClientName.Close;
  GoodName.Close;
  PackUnit.Close;
  adsGoodsSpec.Close;
end;

procedure TSLEdContractPriceForm.FormCreate(Sender: TObject);
begin
  inherited;
  VoucherTableName := 'SLContractPrice';
  ClientName.Open;
  GoodName.Open;
  PackUnit.Open;
  TempAds.Close;
  TempAds.CommandText :=' select Distinct ContractClass from SLContractPriceMaster ';
  TempAds.Open;
  if TempAds.IsEmpty then BriefComboBox.Items.Add('һ�����')
  else begin
    while not TempAds.Eof do
    begin
      BriefComboBox.Items.Add(TempAds.FieldByName('ContractClass').AsString);
      TempAds.Next;
    end;
  end;
end;

procedure TSLEdContractPriceForm.adsDetailGoodsIDChange(Sender: TField);
var SUnitID :integer;
begin
  inherited;
  if (adsDetail.fieldbyname('GoodsID').IsNull) or
     (adsDetail.fieldbyname('GoodsID').AsInteger=0) then exit;
  TempAds.Close;   //ȡ��׼��λ�ͻ�������
  TempAds.CommandText :='select UnitID,PriceSales from DAGoods where Id='
      + QuotedStr(adsDetail.fieldbyname('GoodsID').AsString);
  TempAds.Open;
  if TempAds.FieldByName('UnitID').IsNull then SUnitID :=1
    else SUnitID :=TempAds.FieldByName('UnitID').AsInteger;
  adsDetail.FieldByName('GoalUnitID').AsInteger :=SUnitID;
  adsDetail.FieldByName('PackUnitID').AsInteger :=SUnitID;
  adsDetail.FieldByName('PriceGoal').AsFloat :=TempAds.FieldByName('PriceSales').AsFloat;
  adsDetail.FieldByName('PriceClear').AsFloat :=TempAds.FieldByName('PriceSales').AsFloat;
end;

procedure TSLEdContractPriceForm.LookupPackUintEnter(Sender: TObject);
var GoodsIDstr :string;
begin
  GoodsIDstr :=adsDetail.fieldbyname('GoodsID').asstring;
  if Trim(GoodsIDstr)='' then  exit;
//  LookupPackUint.ListSource := PackUintFltDS;
  PackUintFltAQ.Close;
  PackUintFltAQ.CommandText :=' select ID, Name, ExchangeRate, GoalUnitID,'
      +' IsGoalUnit from MSUnit where RecordState<>'+Quotedstr('ɾ��')
      +' and  GoalUnitID in (select UnitID from DaGoods where ID='
      +GoodsIDstr +' ) order by GoalUnitID,ExchangeRate' ;
  PackUintFltAQ.Open;
end;

procedure TSLEdContractPriceForm.FormActivate(Sender: TObject);
begin
  inherited;
  ClientQLDBLookup.SetFocus;
end;

procedure TSLEdContractPriceForm.LookupPackUintExit(Sender: TObject);
begin
//  LookupPackUint.ListSource := dsPackUnit;
end;

procedure TSLEdContractPriceForm.GoodsIDSelectBttClick(Sender: TObject);
var
  FilterDialog: TQLDBFilterDialog;
  GoodsSelectADS :TADODataSet;
begin
  inherited;
  FilterDialog := TQLDBFilterDialog.Create(Self);
  GoodsSelectADS := TADODataSet.Create(nil);
  GoodsSelectADS.Connection := CommonData.acnConnection;
  try
//    GoodsIDSelectBtt.Enabled:=False;
    GoodsSelectADS.Close;
    GoodsSelectADS.CommandText :=
    ' SELECT a.ID, a.Name, b.name GoodsClass,a.UnitID GoalUnitID, ' +
    ' a.PriceSales FROM DAGoods a '+
    ' LEFT JOIN DAGoodsClass b on b.ID=a.GoodsClassID '+
    ' WHERE a.RecordState<>'+Quotedstr('ɾ��');
    GoodsSelectADS.Open;
    with GoodsSelectADS do
    begin
      Fields[1].DisplayLabel := '��Ʒ����';
      Fields[2].DisplayLabel := '��Ʒ���';
      Fields[3].DisplayLabel := '�ο��ۼ�';
    end;
    FilterDialog.DataSet := GoodsSelectADS;
    FilterDialog.FilterFields := 'Name; GoodsClass';
    if not FilterDialog.Execute then Exit;
    GoodsSelectADS.First;
    adsDetail.last;
    while not GoodsSelectADS.Eof do
    begin
      if adsDetail.Eof then adsDetail.append
        else  adsDetail.Edit;
      adsDetail.FieldByName('GoodsID').AsInteger    := GoodsSelectADS.fieldbyname('ID').AsInteger;
      adsDetail.FieldByName('GoalUnitID').AsInteger := GoodsSelectADS.fieldbyname('GoalUnitID').AsInteger;
//      adsDetail.FieldByName('PackUnitID').AsInteger := GoodsSelectADS.fieldbyname('GoalUnitID').AsInteger;
      adsDetail.FieldByName('PriceClear').AsFloat     := GoodsSelectADS.fieldbyname('PriceSales').AsFloat;
//      adsDetail.Post;
      GoodsSelectADS.Next;
      adsDetail.Next;
    end;
//    if not GoodsSelectADS.IsEmpty then  adsDetail.First;
  finally
    FilterDialog.Free;
  end;
end;

procedure TSLEdContractPriceForm.HoldOnPriceActionExecute(Sender: TObject);
var RateStr:string;
  RateStrF,I :Integer;
  BaseDiscount:real;
begin
  inherited;
  RateStr :='1';
  if InputQuery('��Ʒ��������', '��������������:', RateStr) then
    while not TryStrToInt(RateStr,RateStrF) do
     if not InputQuery('��Ʒ��������', '��������������:', RateStr) then exit;
  BaseDiscount := adsDetail.FieldByName('PriceGoal').AsFloat;
  if not adsDetail.Eof then  adsDetail.Next;
  for I:=1 to RateStrF do
  begin
    if adsDetail.Eof then Break;
    adsDetail.Edit;
    adsDetail.FieldByName('PriceGoal').AsFloat :=BaseDiscount;
    adsDetail.Next;
  end;
end;

end.
