unit STEdHouseInSL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseVoucherEdit, Menus, ActnList, DB, StdCtrls, Mask, DBCtrls,
  ExtCtrls, ComCtrls, ToolWin, Grids, DBGrids, QLDBGrid, ADODB, PkVoucher,
  Provider, QLDBLkp;

type
  TSTHouseInEditSLForm = class(TBaseVoucherEditForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    dblkConsignee: TDBLookupComboBox;
    dblkWarehouse: TDBLookupComboBox;
    dblkEmployee: TDBLookupComboBox;
    dblkOriginBillType: TDBLookupComboBox;
    dsSTWarehouse: TDataSource;
    dsMSEmployee: TDataSource;
    dsConsignee: TDataSource;
    adsConsignee: TADODataSet;
    dbcbHouseOut: TDBComboBox;
    adsSTHouseOutMaster: TADODataSet;
    adsSTHouseOutDetail: TADODataSet;
    adsSTHouseOutMasterID: TAutoIncField;
    adsSTHouseOutMasterCreateDate: TDateTimeField;
    adsSTHouseOutMasterCreateUserID: TIntegerField;
    adsSTHouseOutMasterRecordState: TStringField;
    adsSTHouseOutMasterDate: TDateTimeField;
    adsSTHouseOutMasterCode: TStringField;
    adsSTHouseOutMasterConsigneeID: TIntegerField;
    adsSTHouseOutMasterHouseOut: TStringField;
    adsSTHouseOutMasterEmployeeID: TIntegerField;
    adsSTHouseOutMasterOriginBillID: TIntegerField;
    adsSTHouseOutMasterOriginBillTypeID: TStringField;
    adsSTHouseOutMasterPeriodID: TIntegerField;
    adsSTHouseOutMasterWarehouseID: TIntegerField;
    adsSTHouseOutMasterMemo: TStringField;
    adsSTHouseOutDetailMasterID: TIntegerField;
    adsSTHouseOutDetailID: TAutoIncField;
    adsSTHouseOutDetailWarehouseID: TIntegerField;
    adsSTHouseOutDetailGoodsID: TIntegerField;
    adsSTHouseOutDetailSpec: TStringField;
    adsSTHouseOutDetailPackUnitID: TStringField;
    adsSTHouseOutDetailQuantity: TBCDField;
    adsSTHouseOutDetailCostAmount: TBCDField;
    adsSTHouseOutDetailGoalQuantity: TBCDField;
    adsSTHouseOutDetailGoodName: TStringField;
    adsSTHouseOutDetailPackUnitName: TStringField;
    adsSTHouseOutDetailSpecName: TStringField;
    adrQuery: TADOQuery;
    adsSTWarehouse2: TADODataSet;
    dsSTWarehouse2: TDataSource;
    adsSTHouseOutDetailWarehouseName: TStringField;
    adsSTHouseOutDetailGoalUnitID: TIntegerField;
    DataSource3: TDataSource;
    ADOTable4: TADOTable;
    ADOTable4ID: TAutoIncField;
    ADOTable4Name: TStringField;
    ADOTable4ExchangeRate: TStringField;
    ADOTable4GoalUnitID: TIntegerField;
    ADOTable4IsGoalUnit: TBooleanField;
    ADOTable4RecordState: TStringField;
    ADOTable3: TADOTable;
    ADOTable3ID: TAutoIncField;
    ADOTable3CreateDate: TDateTimeField;
    ADOTable3CreateUserID: TIntegerField;
    ADOTable3RecordState: TStringField;
    ADOTable3Name: TStringField;
    ADOTable3Code: TStringField;
    ADOTable3Spec: TStringField;
    ADOTable3BarCode: TStringField;
    ADOTable3GoodsClassID: TIntegerField;
    ADOTable3UnitID: TIntegerField;
    ADOTable3StockMax: TBCDField;
    ADOTable3StockMin: TBCDField;
    ADOTable3PricePurchase: TBCDField;
    ADOTable3PriceSales: TBCDField;
    ADOTable3GoodsPictrue2: TBlobField;
    procedure FormCreate(Sender: TObject);
    procedure ImportActionExecute(Sender: TObject);
    procedure adsSTHouseOutDetailGoodsIDChange(Sender: TField);
    procedure adsSTHouseOutDetailNewRecord(DataSet: TDataSet);
    procedure ADOTable3FilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure ADOTable4FilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open(VoucherID: Integer); override;
    procedure New; override;
  end;

var
  STHouseInEditSLForm: TSTHouseInEditSLForm;

implementation

uses WSUtils, CommonDM;

{$R *.dfm}

procedure TSTHouseInEditSLForm.New;
begin
  inherited;
  adsSTHouseOutMaster.FieldByName('HouseOut').AsString :='�˻����';
  adsSTHouseOutMaster.FieldByName('Code').AsString:=GetMaxCode('Code','STHouseInMaster',Number);
  adsSTHouseOutMaster.FieldByName('Date').AsString:=FormatDateTime('yyyy-mm-dd',date());
end;

procedure TSTHouseInEditSLForm.Open(VoucherID: Integer);
begin
  inherited Open(VoucherID);
end;

procedure TSTHouseInEditSLForm.FormCreate(Sender: TObject);
var
  adoTemp: TADOQuery;
begin
  inherited;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  {with adoTemp do
  begin
    close;
    sql.Text := 'select * from DABillType where  RecordState<>' + QuotedStr('ɾ��') +
       ' and BillFlagST=' + QuotedStr('1')+ ' AND Name LIKE '+QuotedStr('%�˻�%');
    open;
    dbcbHouseOut.Items.Clear;
    first;
    while not eof do
    begin
      dbcbHouseOut.Items.Add(FieldByName('Name').AsString);
      next;
    end;
//    dbcbHouseOut.ItemIndex :=1;
  end;     }

  VoucherTableName := 'STHouseIn';
  with adsConsignee do
  begin
    Close;
    Open;
    Filtered := False;
    Filter := 'RecordState<>' + QuotedStr('ɾ��');
    Filtered := True;
  end;
  with CommonData.adsSTWarehouse do
  begin
    Close;
    Open;
    Filtered := False;
    Filter := 'RecordState<>' + QuotedStr('ɾ��');
    Filtered := True;
  end;
  with CommonData.adsMSEmployee do
  begin
    Close;
    Open;
    Filtered := False;
    Filter := 'RecordState<>' + QuotedStr('ɾ��');
    Filtered := True;
  end;
  adsSTWarehouse2.Close;
  adsSTWarehouse2.Open;
  ADOTable3.Close;
  ADOTable3.Open;
  ADOTable4.Close;
  ADOTable4.Open;
end;

procedure TSTHouseInEditSLForm.ImportActionExecute(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TVoucherPickForm, VoucherPickForm);
  VoucherPickForm.ShowModal;
end;

procedure TSTHouseInEditSLForm.adsSTHouseOutDetailGoodsIDChange(
  Sender: TField);
begin
  inherited;
  adsSTHouseOutDetail.FieldValues['Spec']:=ADOTable3.FieldByName('spec').AsString;
end;

procedure TSTHouseInEditSLForm.adsSTHouseOutDetailNewRecord(
  DataSet: TDataSet);
begin
  inherited;
  try
    adsSTHouseOutDetail.FieldByName('WarehouseID').AsInteger := adsSTHouseOutMaster.FieldByName('WarehouseID').AsInteger;
  except
  end;
end;

procedure TSTHouseInEditSLForm.ADOTable3FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  inherited;
accept := not (dataset.FieldByName('RecordState').AsString = 'ɾ��');
end;

procedure TSTHouseInEditSLForm.ADOTable4FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  inherited;
accept := not (dataset.FieldByName('RecordState').AsString = 'ɾ��');
end;

end.

