unit PCEDPurchaseCloth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseVoucherEdit, Menus, ActnList, DB, ComCtrls, StdCtrls, Mask,
  DBCtrls, ExtCtrls, ToolWin, Grids, DBGrids, QLDBGrid, ADODB, GEdit,
  QLDBLkp, QuickRpt;

type
  TPCEDPurchaseClothForm = class(TBaseVoucherEditForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ClientName: TADODataSet;
    EmployeeName: TADODataSet;
    GoodName: TADODataSet;
    Label5: TLabel;
    GoodsSpecAds: TADODataSet;
    GoodsSpecDs: TDataSource;
    DSClientName: TDataSource;
    DSEmployeeName: TDataSource;
    ClientQLDBLookup: TQLDBLookupComboBox;
    LookupEmployee: TQLDBLookupComboBox;
    Label6: TLabel;
    Label7: TLabel;
    GoodsSpecLKUP: TQLDBLookupComboBox;
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
    Label10: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label4: TLabel;
    DBEdit5: TDBEdit;
    GEdit1: TGEdit;
    adsDetailTaxAmount: TBCDField;
    adsDetailGoodsSpec: TStringField;
    adsMasterEmployee: TStringField;
    GoalUnit: TADODataSet;
    dsGoalUnit: TDataSource;
    adsDetailGoalUnit: TStringField;
    adsMasterModeDC: TIntegerField;
    adsMasterModeC: TIntegerField;
    adsMasterWarehouseID: TIntegerField;
    TempActualCost: TADODataSet;
    adsDetailPriceCost: TBCDField;
    adsDetailGoodsName: TStringField;
    TpPackUnit: TADOQuery;
    NoCreditSale: TCheckBox;
    CapStyleAds: TADODataSet;
    CapStyleDs: TDataSource;
    ToolButton11: TToolButton;
    N33: TMenuItem;
    FilePrintAction: TAction;
    adsDetailPriceGoal: TBCDField;
    DBEdit6: TDBEdit;
    adsMasterCashDiscount: TBCDField;
    adsDetailCapStyle: TStringField;
    adsDetailSizeA: TIntegerField;
    adsDetailSizeB: TIntegerField;
    adsDetailSizeC: TIntegerField;
    adsDetailSizeD: TIntegerField;
    adsDetailSizeE: TIntegerField;
    adsDetailSizeF: TIntegerField;
    CapStyleLKup: TQLDBLookupComboBox;
    SameQuantityAct: TAction;
    N41: TMenuItem;
    QLDBLookupComboBox1: TQLDBLookupComboBox;
    WareHouseIDADS: TADODataSet;
    WareHouseIDDS: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure adsDetailGoodsIDChange(Sender: TField);
    procedure ClientQLDBLookupEnter(Sender: TObject);
    procedure ClientQLDBLookupExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure adsDetailGoalQuantityChange(Sender: TField);
    procedure FilePrintActionExecute(Sender: TObject);
    procedure adsDetailPackUnitIDChange(Sender: TField);
    procedure NoCreditSaleClick(Sender: TObject);
    procedure DBEdit6Enter(Sender: TObject);
    procedure adsDetailSizeAChange(Sender: TField);
    procedure SameQuantityActExecute(Sender: TObject);
    procedure adsDetailQuantityPcsChange(Sender: TField);
  private
    { Private declarations }
  protected
    function CreateReport: TQuickRep; override;
    procedure InternalSave; override;
  public
     SLPubQuerrySql,SLPubQuerryCaption,NewOrEditFlag:string;
    { Public declarations }
    procedure Open(VoucherID: Integer); override;
    procedure New; override;

  end;

var
  PCEDPurchaseClothForm: TPCEDPurchaseClothForm;

implementation
                          
uses CommonDM, WSUtils, WSSecurity, SLRpSale, BaseVoucherRpt,CRCtrls, Math, QLDBAgg;

{$R *.dfm}
procedure TPCEDPurchaseClothForm.New;
begin
  inherited;
  adsMaster.FieldByName('Date').AsDateTime:=Date;
  adsMaster.FieldByName('Code').AsString:=GetMaxCode('Code','PCPurchaseMaster',number);
  adsMaster.FieldByName('CreateUserID').AsInteger :=Guarder.UserID;
  if NoCreditSale.Checked then   adsMaster.FieldByName('BillMode').AsString:='现款采购'
    else   adsMaster.FieldByName('BillMode').AsString:='采购开单';
  adsMaster.FieldByName('ModeDC').AsInteger :=1;
  adsMaster.FieldByName('ModeC').AsInteger :=1;
  adsMaster.FieldByName('Deliver').AsString:='--';
  adsMaster.FieldByName('Apportion').AsString:='--';
  adsMaster.FieldByName('OriginTable').AsString:='PCPurchaseMaster';
  NewOrEditFlag :='新增状态';
end;

procedure TPCEDPurchaseClothForm.Open(VoucherID: Integer);
var
  SaveOnClick: TNotifyEvent;
begin
  inherited Open(VoucherID);
  SaveOnClick := NoCreditSale.OnClick;
  NoCreditSale.OnClick := nil;
  if Trim(adsMaster.FieldByName('BillMode').AsString)='现款采购'  then
     NoCreditSale.Checked :=True
    else NoCreditSale.Checked :=False;
  NoCreditSale.OnClick := SaveOnClick;
end;


procedure TPCEDPurchaseClothForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  adsMaster.Close;
  adsDetail.Close;
  ClientName.Close;
  EmployeeName.Close;
  GoodName.Close;
  GoodsSpecAds.Close;
  CapStyleAds.Close;
end;

procedure TPCEDPurchaseClothForm.FormCreate(Sender: TObject);
var GoodsSpecStr:string;
begin
  inherited;
  VoucherTableName := 'PCPurchase';
  ClientName.Open;
  EmployeeName.Open;
  GoodName.Open;
  CapStyleAds.Open;
  GoodsSpecAds.Open;
  WareHouseIDADS.Open;
end;

procedure TPCEDPurchaseClothForm.adsDetailGoodsIDChange(Sender: TField);
var SGoodsID,SUnitID,SClientID,IsInGoods:integer;
begin
  inherited;
  if (adsDetail.fieldbyname('GoodsID').IsNull) then exit;
  SGoodsID :=adsDetail.fieldbyname('GoodsID').AsInteger;
  if (adsMaster.fieldbyname('ClientID').IsNull)  then  SClientID :=0
    else  SClientID :=adsMaster.fieldbyname('ClientID').AsInteger;
  TempAds.Close;   //取当前客户当前商品的最新售价
  TempAds.CommandText :=' SELECT a.GoodsID, a.PriceGoal PricePurchase,'
      +' c.UnitID, a.GoodsSpec  '
      +' FROM PCPurchaseDetail a '
      +' left outer join PCPurchaseMaster b on b.ID=a.MasterID '
      +' left outer join DAGoods c      on c.ID=a.GoodsID '
      +' where b.Recordstate<>'+QuotedStr('删除')
      +' and b.ClientID='+ Inttostr(SClientID)
      +' and a.GoodsID='+Inttostr(SGoodsID)
      +' and Isnull(a.PriceGoal,0)<>0 '
      +' order by  b.Date,b.ID desc ';
  TempAds.Open;

  //如果当前客户当前商品没有单价，取当前商品资料的参考售价为最新售价
  //以后客户需要更多种类的单价，可以用CASE来处理
  if TempAds.IsEmpty then
  begin
    TempAds.Close;
    TempAds.CommandText :=' SELECT ID GoodsID, PricePurchase ,UnitID,Spec '
        +' GoodsSpec FROM DAGoods  '
        +' where Recordstate<>'+QuotedStr('删除')
        +' and Isnull(PriceSales,0)<>0 '
        +' and ID='+Inttostr(SGoodsID) ;
    TempAds.Open;
  end;

  if  TempAds.FieldByName('UnitID').IsNull then SunitID :=1
    else SunitID :=TempAds.FieldByName('UnitID').AsInteger;
  adsDetail.FieldByName('GoalUnitID').AsInteger :=SunitID;
  adsDetail.FieldByName('PackUnitID').AsInteger :=SunitID;
  adsDetail.FieldByName('PriceGoal').AsFloat := TempAds.FieldByName('PricePurchase').AsFloat  ;
  adsDetail.FieldByName('GoodsSpec').AsFloat := TempAds.FieldByName('GoodsSpec').AsFloat  ;
end;

procedure TPCEDPurchaseClothForm.ClientQLDBLookupEnter(Sender: TObject);
begin
  inherited;
  GEdit1.Enabled :=true;
  GEdit1.Text :='0';
  GEdit1.Enabled :=false;
end;

procedure TPCEDPurchaseClothForm.ClientQLDBLookupExit(Sender: TObject);
var  adoTemp: TADOQuery;
     FstDate:Tdatetime;
begin
  inherited;
  if   (adsMaster.fieldbyname('ClientID').IsNull) or
          (adsMaster.fieldbyname('ClientID').AsInteger=0)  then exit;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  with adoTemp do
  begin
    close;
    sql.Text :=' select sum(isnull(AmountD,0)) as Balance from '
    +' (  select (isnull(a.amount,0)-isnull(a.Discount,0)+isnull(a.TaxAmount,0) '
    +' +isnull(a.SundryFee,0) )*Isnull(ModeDC,1)*Isnull(ModeC,1) as amountD                         '
    +' from  SLSaleDetail a                                                     '
    +' left outer join  SLSaleMaster b on b.ID=a.MasterID                       '
    +' where b.RecordState<>'+Quotedstr('删除')+' and b.ClientID='
    + adsMaster.fieldbyname('ClientID').AsString
    +' UNION ALL                                                   '
    +' select (isnull(a.amount,0)-isnull(a.Discount,0)+isnull(a.TaxAmount,0) '
    +' +isnull(a.SundryFee,0) )*Isnull(ModeDC,1)*Isnull(ModeC,1)*(-1) as amountD                 '
    +' from  PCPurchaseDetail a                                              '
    +' left outer join  PCPurchaseMaster b on b.ID=a.MasterID                '
    +' where b.RecordState<>'+Quotedstr('删除')+' and b.ClientID='
    + adsMaster.fieldbyname('ClientID').AsString
    +' UNION ALL                                                             '
    +' select (Isnull(AmountD,0)+Isnull(AmountRed,0) )*Isnull(ModeDC,1)*Isnull(ModeC,1)*(-1)     '
    +' as AmountD                                                            '
    +' from FNClearSLMaster                                                  '
    +' where RecordState<>'+Quotedstr('删除')+' and ClientID='
    + adsMaster.fieldbyname('ClientID').AsString
    +' UNION ALL                                                             '
    +' select (Isnull(AmountC,0)+Isnull(AmountRed,0) )*Isnull(ModeDC,1)*Isnull(ModeC,1)          '
    +' as AmountD                                                            '
    +' from FNClearPCMaster                                                  '
    +' where RecordState<>'+Quotedstr('删除')+' and ClientID='
    + adsMaster.fieldbyname('ClientID').AsString +'  ) as a ';
    open;
    GEdit1.Enabled :=true;
    if  adoTemp.IsEmpty then     GEdit1.Text :='0'
      else   GEdit1.Text :=fieldbyname('Balance').asstring;
    GEdit1.Enabled :=False;
    close;
    sql.Text :=' select QuotaAmountMin from SLCredit where '
        +' RecordState<>'+ Quotedstr('删除')
        +' and ClientID='+ adsMaster.fieldbyname('ClientID').AsString ;
    open;

    if (NewOrEditFlag='新增状态') and not (fieldbyname('QuotaAmountMin').IsNull) then
    begin
      adsMaster.Edit;
      adsMaster.fieldbyname('ClearDate').AsDateTime :=
          adsMaster.fieldbyname('Date').AsDateTime+ fieldbyname('QuotaAmountMin').AsInteger
    end;
  end;
end;

procedure TPCEDPurchaseClothForm.FormActivate(Sender: TObject);
begin
  inherited;
  ClientQLDBLookup.SetFocus;
end;

function TPCEDPurchaseClothForm.CreateReport: TQuickRep;
begin
  Result := TSLSaleVoucherReport.Create(Self);
  TBaseVoucherReport(Result).SetMasterDataSet(MasterDataSet);
end;

procedure TPCEDPurchaseClothForm.adsDetailGoalQuantityChange(Sender: TField);
begin
  adsDetail.Edit;
  adsDetail.FieldByName('Amount').AsFloat :=
    adsDetail.fieldbyname('GoalQuantity').AsFloat*adsDetail.fieldbyname('PriceGoal').AsFloat;
  adsDetail.Edit;
  adsDetail.FieldByName('Quantity').AsFloat :=adsDetail.fieldbyname('GoalQuantity').AsFloat;
  adsDetail.Edit;
  adsDetail.FieldByName('PriceBase').AsFloat :=adsDetail.fieldbyname('PriceGoal').AsFloat;
end;

procedure TPCEDPurchaseClothForm.FilePrintActionExecute(Sender: TObject);

  function CurrencyUpperCaseHitch(Value: Currency): string;

    function OnesPlace(X: Double): Integer;
    begin
      Result := Trunc(X);
      Result := Result - Result div 10 * 10;
    end;

  var
    I, N: Integer;
    S: string;
  begin
    Result := '';
    Value := Round(Value * Power(10, 2)) / Power(10, 2);
    for I := 7 downto 0 do
    begin
      N := OnesPlace(Value / Power(10, I - 2));
      S := NumberToHZ(N, 1);
      if S = '' then S := '零';
      if Result = '' then Result := S
      else Result := Result + '     ' + S;
    end;
  end;

var
  ExePath: string;
  S1, S2, S3, S4, S5, S6, S7: string;
begin
  inherited;
  ExePath := ExtractFilePath(Application.ExeName);
  with DetailDataSet do
  begin
    First;
    while not Eof do
    begin
      S1 := S1 + #13#10 + FieldByName('GoodsName').DisplayText;
      S2 := S2 + #13#10 + FieldByName('GoodsSpec').DisplayText;
      S3 := S3 + #13#10 + FieldByName('GoalUnit').DisplayText;
      S4 := S4 + #13#10 + FieldByName('GoalQuantity').DisplayText;
      S5 := S5 + #13#10 + FieldByName('PriceGoal').DisplayText;
      S6 := S6 + #13#10 + FieldByName('Amount').DisplayText;
      S7 := S7 + #13#10 + FieldByName('Memo').DisplayText;
      Next;
    end;
  end;
  with TReportRuntime.Create(Self) do
  begin
    ReportFile := ExePath + 'Reports\Sale.ept';
    SetDataSet('Master', MasterDataSet);
    SetDataSet('Detail', DetailDataSet);
    SetVarValue('S1', S1);
    SetVarValue('S2', S2);
    SetVarValue('S3', S3);
    SetVarValue('S4', S4);
    SetVarValue('S5', S5);
    SetVarValue('S6', S6);
    SetVarValue('S7', S7);
    SetVarValue('QuantityTotal', CurrToStrF(DBGrid.AggregateList.Aggregates.FindAggregate(atSum, 'GoalQuantity').AggregateValue, ffFixed, 2));
    SetVarValue('AmountTotal', CurrToStrF(DBGrid.AggregateList.Aggregates.FindAggregate(atSum, 'Amount').AggregateValue, ffCurrency, 2));
    SetVarValue('AmountTotalHZ', CurrencyUpperCaseHitch(DBGrid.AggregateList.Aggregates.FindAggregate(atSum, 'Amount').AggregateValue));
    PrintPreview(True);
  end;
end;

procedure TPCEDPurchaseClothForm.adsDetailPackUnitIDChange(Sender: TField);
var ExChRate :real;
begin
end;

procedure TPCEDPurchaseClothForm.NoCreditSaleClick(Sender: TObject);
begin
  if NoCreditSale.Checked then
  begin
    adsMaster.Edit;
    if pos(Trim(NoCreditSale.Caption),Trim(adsMaster.FieldByName('Memo').AsString))<=0 then
      adsMaster.FieldByName('Memo').AsString :=
          Copy( Trim(NoCreditSale.Caption)+Trim(adsMaster.FieldByName('Memo').AsString),1,60);
    adsMaster.FieldByName('BillMode').AsString :='现款采购';
    RemarkDBEdit.ReadOnly :=True;
  end else
  begin
    adsMaster.Edit;
    if pos(Trim(NoCreditSale.Caption),Trim(adsMaster.FieldByName('Memo').AsString))>0 then
      adsMaster.FieldByName('Memo').AsString :=
        StringReplace( Trim(adsMaster.FieldByName('Memo').AsString) ,
          Trim(NoCreditSale.Caption),'',[rfReplaceAll, rfIgnoreCase]);
    adsMaster.FieldByName('BillMode').AsString :='采购开单';
    RemarkDBEdit.ReadOnly :=False;
  end;
  DBEdit6.ReadOnly :=not NoCreditSale.Checked;
  if DBEdit6.ReadOnly then
  begin
    adsMaster.Edit;
    adsMaster.FieldByName('CashDiscount').Value :=null;
  end;
end;

procedure TPCEDPurchaseClothForm.DBEdit6Enter(Sender: TObject);
begin
  DBEdit6.ReadOnly :=not NoCreditSale.Checked;
  if DBEdit6.ReadOnly then
  begin
    adsMaster.Edit;
    adsMaster.FieldByName('CashDiscount').Value :=null;
  end;
end;

procedure TPCEDPurchaseClothForm.InternalSave;
var adoTemp: TADOQuery;
    code,AccountIDStr,MasterIDStr,IDStr:string;
    MasterID:Integer;
begin
  inherited;
  if (adsMaster.fieldbyname('ID').AsInteger=0) or
         (adsMaster.fieldbyname('ID').IsNull)  then exit;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  with adoTemp do
  begin
    //--------------判断将要插入的记录是否已经正在于PCGoodsInMaster,不存在就插入
    Close;
    sql.Text :=' select  b.ID from PCPurchaseDetail a '
        +' left outer join PCPurchaseMaster b on a.MasterID=b.ID '
        +' where isnull(a.goodsId,0)<>0   '
        +' and isnull(a.GoalQuantity,0)<>0 '
        +' and b.id=' + adsMaster.fieldbyname('ID').AsString
        +' and b.RecordState<>' + QuotedStr('删除')
        +' and b.ID not in '
        +' (select top 1 OriginID from PCGoodsInMaster where '
        +' OriginTable='+ QuotedStr('PCPurchaseMaster')
        +' and OriginID='+adsMaster.fieldbyname('ID').AsString+'  )';
    open;
    if  not adoTemp.IsEmpty then //判断完毕,开始插入
    begin
        code :=GetMaxCode('Code','PCGoodsInMaster',number);
        close;
        sql.Text := 'insert into PCGoodsInMaster ( CreateUserID,'
            +' Date, Code, ClientID, EmployeeID, BillMode,  '
            +' ModeDC,ModeC, Brief, ClearDate, SundryFee, Apportion,  '
            +' Deliver, Memo, OriginID, OriginTable ) '
            +' select CreateUserID,Date, '+ QuotedStr(code)+ ' ,'
            +' ClientID, EmployeeID,BillMode ,'
            +' ModeDC,ModeC, '+QuotedStr('采购开单自动提交') +' ,'
            +' ClearDate, SundryFee, Apportion, '
            +' Deliver, '+ QuotedStr('采购单号:')
            +' +code, ID, '+QuotedStr('PCPurchaseMaster')
            +' from PCPurchaseMaster '
            +' where id=' +adsMaster.fieldbyname('ID').AsString
            +' and RecordState<>'+QuotedStr('删除')
            +' and ID not in '
            +' (select top 1 OriginID from PCGoodsInMaster where '
            +' OriginTable='+ QuotedStr('PCPurchaseMaster')
            +' and OriginID='+adsMaster.fieldbyname('ID').AsString+'  )';
        ExecSQL; //插入出库主表记录完毕
        close;
        sql.Text := 'select top 1 ID from PCGoodsInMaster  where '
            +' OriginTable='+ QuotedStr('PCPurchaseMaster')
            +' and OriginID='+adsMaster.fieldbyname('ID').AsString;
        open;
        if adoTemp.IsEmpty then MasterID :=0
            else MasterID :=adoTemp.FieldByName('ID').AsInteger;
        sql.Text := 'insert into PCGoodsInDetail ( '
              +' MasterID, GoodsID, GoodsSpec,    '
              +' Quantity, QuantityPcs, PackUnitID,  '
              +' GoalUnitID, GoalQuantity, Memo )   '
              +' select '+ Inttostr(MasterID) + ' , a.GoodsID, a.GoodsSpec, '
              +' a.Quantity, a.QuantityPcs, a.PackUnitID, '
              +' a.GoalUnitID, a.GoalQuantity, a.Memo  '
              +' from  PCPurchaseDetail a '
              +' left outer join PCPurchaseMaster b on a.MasterID=b.ID'
              +' where isnull(a.GoodsID,0)<>0 '
              +' and isnull(a.GoalQuantity,0)<>0 '
              +' and a.MasterID='+ adsMaster.fieldbyname('ID').AsString
              +' and b.RecordState<>'+QuotedStr('删除');
        ExecSQL;//插入出库子表记录完毕
    end;
  end;
//判断是否要插入销售结算表
  if ( adsMaster.FieldByName('BillMode').AsString ='现款采购' )  then
  begin
//    Exit;
    adoTemp.Close;
    adoTemp.SQL.Text :='select OriginID from FNClearPCMaster'
        +' where OriginTable='+Quotedstr('PCPurchaseMaster')
        +' and RecordState<>'+Quotedstr('删除')+' and OriginID='
        + adsMaster.fieldbyname('ID').AsString ;
    adoTemp.Open;
    if adoTemp.IsEmpty then
    begin
      adoTemp.Close;
      adoTemp.SQL.Text :=' select * from FNAccounts '
          +' where AccountType like '+Quotedstr('%现金%')
          +' and RecordState<>'+Quotedstr('删除') ;
      adoTemp.open;

      AccountIDStr :=adoTemp.fieldbyname('ID').AsString;
      if Trim(AccountIDStr)='' then AccountIDStr :='1';

      IDStr :=adsMaster.fieldbyname('ID').AsString;
      if Trim(IDStr)='' then IDStr :='0';
      adoTemp.Close;
      adoTemp.SQL.Text :=' Insert into FNClearPCMaster ('
          +' CreateUserID,Date,Code,BillMode,ModeDC,ModeC,'
          +' Brief, ClientID, EmployeeID,AccountsID, AmountD,   '
          +' AmountC,AmountRed,Memo, OriginID, OriginTable)     '
          +' select  CreateUserID, Date,                        '
          +Quotedstr(GetMaxCode('Code','FNClearPCMaster',number))+' , '
          +Quotedstr('现购结算')+' BillMode, ModeDC, ModeC, '
          +Quotedstr('现款采购')+' as Brief,         '
          +' ClientID, EmployeeID, '+ AccountIDStr+' as  AccountID , '
          +' 0.00 AmountD ,'
          +' (isnull(b.Amount,0)+isnull(a.SundryFee,0)-isnull(CashDiscount,0) )'
          +' as AmountC, '
          +' CashDiscount,   '
          +Quotedstr('现款采购')+' as Memo, a.ID, '
          +Quotedstr('PCPurchaseMaster')
          +' from PCPurchaseMaster a                                 '
          +' left outer join                                     '
          +' ( select MasterID,Sum(Isnull(Amount,0)) as Amount   '
          +' from PCPurchaseDetail                                   '
          +' Group by MasterID ) b on B.MasterID=a.ID            '
          +' where a.ID='+IDStr  ;
      adoTemp.ExecSQL;

      AccountIDStr := adsMaster.fieldbyname('ID').AsString;
      if Trim(AccountIDStr)='' then AccountIDStr :='0';

      adoTemp.Close;
      adoTemp.SQL.Text :=' select ID from FNClearPCMaster '
          +' where OriginID='+AccountIDStr+' and OriginTable='
          +Quotedstr('PCPurchaseMaster') ;
      adoTemp.Open; //选定新插入记录(FNClearPCMaster表)的ID号
      MasterIDStr :=adoTemp.fieldbyname('ID').AsString;
      if Trim(MasterIDStr)='' then MasterIDStr :='0';

      adoTemp.Close;
      adoTemp.SQL.Text :=' Insert into FNClearPCDetail ('
          +' MasterID,OriginID,Amount)'
          +' select  '+MasterIDStr +'as MasterID,'
          +' a.ID as OriginID, '
          +' (isnull(b.Amount,0)+isnull(a.SundryFee,0) ) as Amount '
          +' from PCPurchaseMaster a                                 '
          +' left outer join                                     '
          +' ( select MasterID,Sum(Isnull(Amount,0)) as Amount   '
          +' from PCPurchaseDetail                                   '
          +' Group by MasterID ) b on B.MasterID=a.ID            '
          +' where a.ID='+IDStr  ;
    adoTemp.ExecSQL;
    end;
  end;
end;

procedure TPCEDPurchaseClothForm.adsDetailSizeAChange(Sender: TField);
begin
  inherited;
  adsDetail.Edit;
  adsDetail.FieldByName('GoalQuantity').AsFloat :=adsDetail.fieldbyname('SizeA').AsFloat
    +adsDetail.fieldbyname('SizeB').AsFloat+adsDetail.fieldbyname('SizeC').AsFloat
    +adsDetail.fieldbyname('SizeD').AsFloat+adsDetail.fieldbyname('SizeE').AsFloat
//    +adsDetail.fieldbyname('SizeF').AsFloat;
    +adsDetail.fieldbyname('SizeF').AsFloat+adsDetail.fieldbyname('QuantityPcs').AsFloat  ;
end;

procedure TPCEDPurchaseClothForm.SameQuantityActExecute(Sender: TObject);
begin
  inherited;
  if adsDetail.fieldbyname('SizeA').AsFloat=0 then
  begin
    adsDetail.FieldByName('SizeA').AsFloat :=adsDetail.fieldbyname('SizeB').AsFloat;
    if adsDetail.fieldbyname('SizeA').AsFloat=0 then
      adsDetail.FieldByName('SizeA').AsFloat :=adsDetail.fieldbyname('SizeC').AsFloat;
    if adsDetail.fieldbyname('SizeA').AsFloat=0 then
      adsDetail.FieldByName('SizeA').AsFloat :=adsDetail.fieldbyname('SizeD').AsFloat;
    if adsDetail.fieldbyname('SizeA').AsFloat=0 then
      adsDetail.FieldByName('SizeA').AsFloat :=adsDetail.fieldbyname('SizeE').AsFloat;
    if adsDetail.fieldbyname('SizeA').AsFloat=0 then
      adsDetail.FieldByName('SizeA').AsFloat :=adsDetail.fieldbyname('SizeF').AsFloat;
  end;
  adsDetail.Edit;
  adsDetail.FieldByName('SizeB').AsFloat :=adsDetail.fieldbyname('SizeA').AsFloat;
  adsDetail.FieldByName('SizeC').AsFloat :=adsDetail.fieldbyname('SizeA').AsFloat;
  adsDetail.FieldByName('SizeD').AsFloat :=adsDetail.fieldbyname('SizeA').AsFloat;
  adsDetail.FieldByName('SizeE').AsFloat :=adsDetail.fieldbyname('SizeA').AsFloat;
  adsDetail.FieldByName('SizeF').AsFloat :=adsDetail.fieldbyname('SizeA').AsFloat;
//  adsDetail.FieldByName('QuantityPcs').AsFloat :=adsDetail.fieldbyname('SizeA').AsFloat；
end;

procedure TPCEDPurchaseClothForm.adsDetailQuantityPcsChange(Sender: TField);
begin
  EXIT;
  inherited;
  adsDetail.Edit;
  adsDetail.FieldByName('SizeA').AsFloat :=adsDetail.fieldbyname('QuantityPcs').AsFloat/6;
  adsDetail.FieldByName('SizeB').AsFloat :=adsDetail.fieldbyname('QuantityPcs').AsFloat/6;
  adsDetail.FieldByName('SizeC').AsFloat :=adsDetail.fieldbyname('QuantityPcs').AsFloat/6;
  adsDetail.FieldByName('SizeD').AsFloat :=adsDetail.fieldbyname('QuantityPcs').AsFloat/6;
  adsDetail.FieldByName('SizeE').AsFloat :=adsDetail.fieldbyname('QuantityPcs').AsFloat/6;
  adsDetail.FieldByName('SizeF').AsFloat :=adsDetail.fieldbyname('QuantityPcs').AsFloat/6;
end;

end.
