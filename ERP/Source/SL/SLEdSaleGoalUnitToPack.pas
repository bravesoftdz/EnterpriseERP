unit SLEdSaleGoalUnitToPack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseVoucherEdit, Menus, ActnList, DB, ComCtrls, StdCtrls, Mask,
  DBCtrls, ExtCtrls, ToolWin, Grids, DBGrids, QLDBGrid, ADODB, GEdit,
  QLDBLkp, QuickRpt;

type
  TSLEdSaleGoalUnitToPackForm = class(TBaseVoucherEditForm)
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
    adsDetailGoodsName: TStringField;
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
    LookupGoodsSpec: TQLDBLookupComboBox;
    adsGoodsSpec: TADODataSet;
    dsGoodsSpec: TDataSource;
    adsMasterEmployee: TStringField;
    GoalUnit: TADODataSet;
    dsGoalUnit: TDataSource;
    adsDetailGoalUnit: TStringField;
    adsMasterModeDC: TIntegerField;
    adsMasterModeC: TIntegerField;
    adsMasterWarehouseID: TIntegerField;
    TempActualCost: TADODataSet;
    adsDetailPriceCost: TBCDField;
    adsDetailPackUnit: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
//    procedure adsDetailQuantityChange(Sender: TField);
    procedure adsDetailGoodsIDChange(Sender: TField);
    procedure SaveActionExecute(Sender: TObject);
    procedure ClientQLDBLookupEnter(Sender: TObject);
    procedure ClientQLDBLookupExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure adsDetailPriceBaseChange(Sender: TField);
    procedure adsDetailGoalQuantityChange(Sender: TField);
  private
    { Private declarations }
  protected
    function CreateReport: TQuickRep; override;
  public
     SLPubQuerrySql,SLPubQuerryCaption,NewOrEditFlag:string;
    { Public declarations }
    procedure Open(VoucherID: Integer); override;
    procedure New; override;

  end;

var
  SLEdSaleGoalUnitToPackForm: TSLEdSaleGoalUnitToPackForm;

implementation

uses CommonDM, WSUtils, WSSecurity, SLRpSale, BaseVoucherRpt;

{$R *.dfm}
procedure TSLEdSaleGoalUnitToPackForm.New;
begin
  inherited;
  adsMaster.FieldByName('Date').AsDateTime:=Date;
  adsMaster.FieldByName('Code').AsString:=GetMaxCode('Code','SLSaleMaster',number);
  adsMaster.FieldByName('CreateUserID').AsInteger :=Guarder.UserID;
  adsMaster.FieldByName('BIllMode').ReadOnly :=False;
  adsMaster.FieldByName('BillMode').AsString:='���ۿ���';
  adsMaster.FieldByName('ModeDC').AsInteger :=1;
  adsMaster.FieldByName('ModeC').AsInteger :=1;
  adsMaster.FieldByName('Deliver').AsString:='--';
  adsMaster.FieldByName('Apportion').AsString:='--';
  adsMaster.FieldByName('OriginTable').AsString:='SLSaleMaster';
  NewOrEditFlag :='����״̬';
end;

procedure TSLEdSaleGoalUnitToPackForm.Open(VoucherID: Integer);
begin
  inherited Open(VoucherID);
end;


procedure TSLEdSaleGoalUnitToPackForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  adsMaster.Close;
  adsDetail.Close;
  ClientName.Close;
  EmployeeName.Close;
  GoodName.Close;
  PackUnit.Close;
  adsGoodsSpec.Close;
end;

procedure TSLEdSaleGoalUnitToPackForm.FormCreate(Sender: TObject);
var GoodsSpecStr:string;
begin
  inherited;
  VoucherTableName := 'SLSale';
  ClientName.Open;
  EmployeeName.Open;
  GoodName.Open;
  PackUnit.Open;

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
  TempAds.CommandText :=' select Distinct brief from SLSaleMaster';
  TempAds.Open;
  TempAds.First;
  while not TempAds.Eof do
  begin
    BriefComboBox.Items.Add(TempAds.FieldByName('brief').AsString);
    TempAds.Next;
  end;
  if  TempAds.IsEmpty then  BriefComboBox.Items.Add('����');
  NewOrEditFlag :='�༭״̬';
end;

procedure TSLEdSaleGoalUnitToPackForm.adsDetailGoodsIDChange(Sender: TField);
var SGoodsID,SUnitID,SClientID:integer;
begin
  inherited;
  if (adsDetail.fieldbyname('GoodsID').IsNull) or (adsDetail.fieldbyname('GoodsID').AsInteger=0)
     then  SGoodsID :=0 else  SGoodsID :=adsDetail.fieldbyname('GoodsID').AsInteger;
  if (adsMaster.fieldbyname('ClientID').IsNull) or (adsMaster.fieldbyname('ClientID').AsInteger=0)
     then  SClientID :=0 else  SClientID :=adsMaster.fieldbyname('ClientID').AsInteger;

  TempAds.Close;   //ȡ��ǰ�ͻ��ĺ�ͬ�ۼۺͱ�׼��λ
  TempAds.CommandText :='select GoalUnitID UnitID,PriceClear PriceSales '
      +' from SLContractpriceDetail a '
      +' Left Outer Join SLContractpriceMaster b on b.ID=A.masterID '
      +' where a.PriceClear<>0 and b.RecordState<>'+QuotedStr('ɾ��')
      +' and  b.RecordState<>'+QuotedStr('ע��')
      +' and b.ClientID= '+ Inttostr(SClientID)
      +' and  GoodsID= '+ Inttostr(SGoodsID)   ;
  TempAds.Open;
  if  TempAds.IsEmpty then
  begin
    TempAds.Close;   //ȡ��׼��λ�ͻ�������
    TempAds.CommandText :='select UnitID,PriceSales from DAGoods where Id='
        + Inttostr(SGoodsID);
    TempAds.Open;
  end;
  TempActualCost.Close;
  TempActualCost.CommandText :=' select CostPrice from #TpCostPrice'
    +' where GoodsID= '+ Inttostr(SGoodsID) ;
  TempActualCost.Open;

  adsDetail.FieldByName('GoalUnitID').ReadOnly :=False;
  if  (TempAds.FieldByName('UnitID').IsNull) or (TempAds.FieldByName('UnitID').AsInteger=0) then
     adsDetail.FieldByName('GoalUnitID').AsInteger :=1
  else
     adsDetail.FieldByName('GoalUnitID').AsInteger :=TempAds.FieldByName('UnitID').AsInteger;

  adsDetail.FieldByName('PriceBase').ReadOnly :=False;
  adsDetail.FieldByName('PriceBase').AsFloat := TempAds.FieldByName('PriceSales').AsFloat  ;
  if not TempActualCost.FieldByName('CostPrice').IsNull then
    adsDetail.FieldByName('PriceCost').AsFloat := TempActualCost.FieldByName('CostPrice').AsFloat  ;
  if adsDetail.FieldByName('PriceBase').IsNull then adsDetail.FieldByName('PriceBase').AsFloat :=0;
  if  TempAds.FieldByName('UnitID').IsNull then SunitID :=1
    else SunitID :=TempAds.FieldByName('UnitID').AsInteger;

 {select ID, Name, ExchangeRate, GoalUnitID, IsGoalUnit
from    MSUnit      where RecordState<>'ɾ��' }

  PackUnit.Close;    //ȡ����Ʒ��������װ��λ
  PackUnit.CommandText :='select a.AddUnitID ID, b.name, a.AddUnitRate '
    +' ExchangeRate,b.GoalUnitID,b.IsGoalUnit '
    +' from DAGoods a '
    +' Left outer join MSUnit b on a.AddUnitID=b.ID'
    +' where a.ID= '+ Inttostr(SGoodsID)+' and '
    +' a.RecordState<>'+Quotedstr('ɾ��')+' and  '
    +' a.AddUnitID is not null and a.AddUnitID<>0 and'
    +' a.AddUnitRate <>0 and '
    +' a.RecordState<>'+Quotedstr('ע��');
  PackUnit.Open;
  showmessage(Inttostr(SGoodsID)+' -- '+PackUnit.FieldByName('ID').AsString);

  adsDetail.FieldByName('PackUnitID').ReadOnly :=False;
  if not (PackUnit.FieldByName('ID').IsNull)  then
     adsDetail.FieldByName('PackUnitID').AsInteger :=PackUnit.FieldByName('ID').AsInteger
  else  adsDetail.FieldByName('PackUnitID').AsInteger :=adsDetail.FieldByName('GoalUnitID').AsInteger;

  adsDetail.FieldByName('PackUnitID').ReadOnly :=True;
end;




procedure TSLEdSaleGoalUnitToPackForm.adsDetailPriceBaseChange(Sender: TField);
begin
  inherited;
  adsDetail.FieldByName('Amount').ReadOnly :=False;
  adsDetail.FieldByName('Amount').AsFloat :=
       adsDetail.fieldbyname('GoalQuantity').asfloat
         *adsDetail.fieldbyname('PriceBase').AsFloat;
  adsDetail.FieldByName('Amount').ReadOnly :=True;
end;

procedure TSLEdSaleGoalUnitToPackForm.SaveActionExecute(Sender: TObject);
var adoTemp: TADOQuery;
    code:string;
    MasterID:Integer;
begin
  inherited;
  if (adsMaster.fieldbyname('ID').AsInteger=0) or
         (adsMaster.fieldbyname('ID').IsNull)  then exit;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  with adoTemp do
  begin
    //--------------�жϽ�Ҫ����ļ�¼�Ƿ��Ѿ�������SLGoodsOutMaster,�����ھͲ���
    Close;
    sql.Text :=' select  b.ID from SLSaleDetail a '
        +' left outer join SLSaleMaster b on a.MasterID=b.ID '
        +' where isnull(a.goodsId,0)<>0   '
        +' and isnull(a.GoalQuantity,0)<>0 '
        +' and b.id=' + adsMaster.fieldbyname('ID').AsString
        +' and b.RecordState<>' + QuotedStr('ɾ��')
        +' and b.ID not in '
        +' (select top 1 OriginID from SLGoodsOutMaster where '
        +' OriginTable='+ QuotedStr('SLSaleMaster')
        +' and OriginID='+adsMaster.fieldbyname('ID').AsString+'  )';
    open;
    if  not adoTemp.IsEmpty then //�ж����,��ʼ����
    begin
        code :=GetMaxCode('Code','SLGoodsOutMaster',number);
        close;
        sql.Text := 'insert into SLGoodsOutMaster ( CreateUserID,'
            +' Date, Code, ClientID, EmployeeID, BillMode,  '
            +' ModeDC,ModeC, Brief, ClearDate, SundryFee, Apportion,  '
            +' Deliver, Memo, BillAffix ,OriginID, OriginTable ) '
            +' select CreateUserID,Date, '+ QuotedStr(code)+ ' ,'
            +' ClientID, EmployeeID,BillMode ,'
            +' ModeDC,ModeC, '+QuotedStr('���ۿ����Զ��ύ') +' ,'
            +' ClearDate, SundryFee, Apportion, '
            +' Deliver, Memo, BillAffix, ID, '+QuotedStr('SLSaleMaster')
            +' from SLSaleMaster '
            +' where id=' +adsMaster.fieldbyname('ID').AsString
            +' and RecordState<>'+QuotedStr('ɾ��')
            +' and ID not in '
            +' (select top 1 OriginID from SLGoodsOutMaster where '
            +' OriginTable='+ QuotedStr('SLSaleMaster')
            +' and OriginID='+adsMaster.fieldbyname('ID').AsString+'  )';
        ExecSQL; //������������¼���
        close;
        sql.Text := 'select top 1 ID from SLGoodsOutMaster  where '
            +' OriginTable='+ QuotedStr('SLSaleMaster')
            +' and OriginID='+adsMaster.fieldbyname('ID').AsString;
        open;
        if adoTemp.IsEmpty then MasterID :=0
            else MasterID :=adoTemp.FieldByName('ID').AsInteger;
        sql.Text := 'insert into SLGoodsOutDetail ( '
              +' MasterID, GoodsID, GoodsSpec,    '
              +' Quantity, QuantityPcs, PackUnitID, PriceBase, '
              +' Amount, Discount, TaxAmount, SundryFee,     '
              +' GoalUnitID, GoalQuantity, Memo )   '
              +' select '+ Inttostr(MasterID) + ' , a.GoodsID, a.GoodsSpec, '
              +' a.Quantity, a.QuantityPcs, a.PackUnitID, 0.00,  '
              +' 0.00, 0.00, 0.00, 0.00, '
              +' a.GoalUnitID, a.GoalQuantity, a.Memo  '
              +' from  SLSaleDetail a '
              +' left outer join SLSalemaster b on a.MasterID=b.ID'
              +' where isnull(a.GoodsID,0)<>0 '
              +' and isnull(a.GoalQuantity,0)<>0 '
              +' and a.MasterID='+ adsMaster.fieldbyname('ID').AsString
              +' and b.RecordState<>'+QuotedStr('ɾ��');
        ExecSQL;//��������ӱ��¼���
        close;
        Sql.Text :=' update SLGoodsOutDetail set '
            +' SLGoodsOutDetail.PriceBase=#TpCostPrice.Costprice '
            +' from SLGoodsOutDetail left outer join  #TpCostPrice '
            +' on #TpCostPrice.goodsid=SLGoodsOutDetail.goodsid '
            +' where MasterID='+ Inttostr(MasterID);
        Execsql;

        close;
        Sql.Text :=' update SLGoodsOutDetail set '
            +' SLGoodsOutDetail.PriceBase=SLGoodsOutDetail.PriceBase* '
            +' MsUnit.ExchangeRate '
            +' from SLGoodsOutDetail left outer join  MsUnit '
            +' on MsUnit.ID=SLGoodsOutDetail.PackunitID'
            +' where MasterID='+ Inttostr(MasterID);
        Execsql;

        close;
        Sql.Text :=' update  SLGoodsOutDetail set Amount=Quantity*PriceBase '
             +' where MasterID= '+ Inttostr(MasterID);
        ExecSQL;
        //�������۲�Ʒ����ʱ�ɱ��������
    end;
    //--------------�жϽ�Ҫ����ļ�¼�Ƿ��Ѿ�������SLGoodsOutMaster,�����ھͲ���
   {
    //=======�жϽ�Ҫ����ļ�¼�Ƿ��Ѿ�������FNClearSLMaster,�����ھͲ���
    Close;
    sql.Text :=' select b.ID from SLSaleDetail a '
        +' Left Outer join SLSaleMaster b on a.MasterID=b.ID '
        +' where ABS(isnull(a.amount,0))+ABS(isnull(a.Discount,0))'
        +' +ABS(isnull(a.TaxAmount,0)) + ABS(isnull(a.SundryFee,0))<>0 '
        + ' and b.ID='+adsMaster.fieldbyname('ID').AsString
        +' and b.RecordState<>' + QuotedStr('ɾ��')+' and  b.ID not in '
        +' (select top 1 OriginID from FNClearSLMaster where '
        +' OriginTable='+ QuotedStr('SLSaleMaster')
        +' and OriginID='+adsMaster.fieldbyname('ID').AsString+'  )';
    open;
    if  not adoTemp.IsEmpty then //�ж����,��ʼ����
    begin
        code :=GetMaxCode('Code','FNClearSLMaster',number);
        if adsMaster.FieldByName('ModeC').AsInteger=-1 then BillMode :='���۽���[����]'
            else BillMode :='���۽���' ;
        close;
        sql.Text := 'insert into FNClearSLMaster ( CreateUserID,'
            +' Date, Code, BillMode, ModeDC,ModeC, Brief, '
            +' ClientID, EmployeeID,  '
            +' ClearDate, AccountsID, AmountD, AmountC,'
            +' Memo, BillAffix, OriginID, OriginTable ) '
            +' select a.CreateUserID , '
            +' a.Date, '+QuotedStr(Code)+ ' , '
            + QuotedStr(BillMode) +' , a.ModeDC,a.ModeC, '
            + QuotedStr('���ۿ����Զ��ύ����') +' ,'
            +' a.ClientID, a.EmployeeID, '
            +' a.ClearDate, 0,0, 0, '
            +' a.Memo, a.BillAffix, a.ID,'+QuotedStr('SLSaleMaster')
            +' from SLSaleMaster a left outer join   '
            +' (select MasterID,sum(isnull(amount,0))-    '
            +' -sum(isnull(Discount,0))+sum(isnull(TaxAmount,0)) '
            +' +sum(isnull(SundryFee,0)) as amount '
            +' from  SLSaleDetail                   '
            +' group by  MasterId) as b on a.ID=b.MasterID '
            +' where a.RecordState<>'+QuotedStr('ɾ��')+ ' and '
            +' a.id=' +adsMaster.fieldbyname('ID').AsString
            +' and a.Id not in '
            +' (select top 1 OriginID from FNClearSLMaster where '
            +' OriginTable='+ QuotedStr('SLSaleMaster')
            +' and OriginID='+adsMaster.fieldbyname('ID').AsString+'  )';
        ExecSQL; //FNClearSLMaster �����¼���
        close;
        sql.Text := 'select top 1 ID from FNClearSLMaster  where '
            +' OriginTable='+ QuotedStr('SLSaleMaster')
            +' and OriginID='+adsMaster.fieldbyname('ID').AsString;
        open;
        if adoTemp.IsEmpty then MasterID :=0
            else MasterID :=adoTemp.FieldByName('ID').AsInteger;
        sql.Text := 'insert into FNClearSLDetail ( MasterID, '
              +' OriginID, OriginTable ,Amount )    '
              +' select '+ Inttostr(MasterID) + ' , a.ID,  '
              +' a.OriginTable, b.Amount as Amount  '
              +' from SLSaleMaster a left outer join   '
              +' (select MasterID,sum(isnull(amount,0))-    '
              +' -sum(isnull(Discount,0))+sum(isnull(TaxAmount,0)) '
              +' +sum(isnull(SundryFee,0)) as amount '
              +' from  SLSaleDetail                   '
              +' group by  MasterId) as b on a.ID=b.MasterID '
              +' where a.RecordState<>'+QuotedStr('ɾ��')
              +' and a.ID='+ adsMaster.fieldbyname('ID').AsString;
        ExecSQL;//�����ӱ��¼
    end;
    //=======�жϽ�Ҫ����ļ�¼�Ƿ��Ѿ�������FNClearSLMaster,�����ھͲ���
    }
  end;
end;

procedure TSLEdSaleGoalUnitToPackForm.ClientQLDBLookupEnter(Sender: TObject);
begin
  inherited;
  GEdit1.Enabled :=true;
  GEdit1.Text :='0';
  GEdit1.Enabled :=false;
end;

procedure TSLEdSaleGoalUnitToPackForm.ClientQLDBLookupExit(Sender: TObject);
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
    +' where b.RecordState<>'+Quotedstr('ɾ��')+' and b.ClientID='
    + adsMaster.fieldbyname('ClientID').AsString
    +' UNION ALL                                                   '
    +' select (isnull(a.amount,0)-isnull(a.Discount,0)+isnull(a.TaxAmount,0) '
    +' +isnull(a.SundryFee,0) )*Isnull(ModeDC,1)*Isnull(ModeC,1)*(-1) as amountD                 '
    +' from  PCPurchaseDetail a                                              '
    +' left outer join  PCPurchaseMaster b on b.ID=a.MasterID                '
    +' where b.RecordState<>'+Quotedstr('ɾ��')+' and b.ClientID='
    + adsMaster.fieldbyname('ClientID').AsString
    +' UNION ALL                                                             '
    +' select (Isnull(AmountD,0)+Isnull(AmountRed,0) )*Isnull(ModeDC,1)*Isnull(ModeC,1)*(-1)     '
    +' as AmountD                                                            '
    +' from FNClearSLMaster                                                  '
    +' where RecordState<>'+Quotedstr('ɾ��')+' and ClientID='
    + adsMaster.fieldbyname('ClientID').AsString
    +' UNION ALL                                                             '
    +' select (Isnull(AmountC,0)+Isnull(AmountRed,0) )*Isnull(ModeDC,1)*Isnull(ModeC,1)          '
    +' as AmountD                                                            '
    +' from FNClearPCMaster                                                  '
    +' where RecordState<>'+Quotedstr('ɾ��')+' and ClientID='
    + adsMaster.fieldbyname('ClientID').AsString +'  ) as a ';
    open;
    GEdit1.Enabled :=true;
    if  adoTemp.IsEmpty then     GEdit1.Text :='0'
      else   GEdit1.Text :=fieldbyname('Balance').asstring;
    GEdit1.Enabled :=False;
    close;
    sql.Text :=' select QuotaAmountMin from SLCredit where '
        +' RecordState<>'+ Quotedstr('ɾ��')
        +' and ClientID='+ adsMaster.fieldbyname('ClientID').AsString ;
    open;

    if (NewOrEditFlag='����״̬') and not (fieldbyname('QuotaAmountMin').IsNull) then
    begin
      adsMaster.Edit;
      adsMaster.fieldbyname('ClearDate').AsDateTime :=
          adsMaster.fieldbyname('Date').AsDateTime+ fieldbyname('QuotaAmountMin').AsInteger
    end;
  end;
end;

procedure TSLEdSaleGoalUnitToPackForm.FormActivate(Sender: TObject);
var  adoTemp: TADOQuery;
begin
  inherited;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  adoTemp.Close;
  adoTemp.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#TpCostPrice')
        +' )) DROP TABLE #TpCostPrice ' ;
  adoTemp.ExecSQL;
  
  adoTemp.Close;
  adoTemp.SQL.Text :=' create table #TpCostPrice ('
      +'	ID [int] IDENTITY (1, 1) NOT NULL ,'
      +'	GoodsID [int] NULL ,               '
      +'	GoalQuantity [float] NULL ,   '
      +'	CostPrice [float] NULL ,           '
      +'	Amount [float] NULL)   '   ;
  adoTemp.ExecSQL;
  with adoTemp do
  begin
    close;     //�������۲�Ʒ����ʱ�ɱ�����
    Sql.Text :=' truncate Table #TpCostPrice'  ;
    ExecSQL;
    close;
    Sql.Text :=' insert into  #TpCostPrice ('
      +' 	GoodsID, GoalQuantity,Amount )'
      +' select goodsid,sum(isnull(Quantity,0)),sum(isnull(Amount,0)) '
      +' from (   '
      +' select GoodsID,Quantity*Isnull(ModeDC,1)*Isnull(ModeC,1) as Quantity,Amount*Isnull(ModeDC,1)*Isnull(ModeC,1) '
      +'  as Amount,recordstate  from PCgoodsIndetail a  '
      +' left outer join PCgoodsInMaster b on b.id=a.MasterID WHERE Amount<>0'
      +' UNION ALL                                                 '
      +' select GoodsID,Quantity*Isnull(ModeDC,1)*Isnull(ModeC,1) as Quantity,Amount*Isnull(ModeDC,1)*Isnull(ModeC,1)'
      +'  as Amount,recordstate from YDgoodsIndetail a                                  '
      +' left outer join YDgoodsInMaster b on b.id=a.MasterID Where Amount<>0'
      +' UNION ALL                                                                          '
      +' select GoodsID,Quantity*Isnull(ModeDC,1)*Isnull(ModeC,1) as Quantity,Amount*Isnull(ModeDC,1)*Isnull(ModeC,1)           '
      +'  as Amount,recordstate  from YDgoodsIndetail a                                 '
      +' left outer join STgoodsCountOffMaster b on b.id=a.MasterID Where Amount<>0'
      +' and BillMode like '+Quotedstr('%�����ӯ%' )+ ' ) as a  '
      +' where RecordState<>'+QuotedStr('ɾ��')
      +' group by GoodsID  ' ;
    ExecSQL;
    close;
    Sql.Text :=' Update  #TpCostPrice  set CostPrice=abs(Amount/ '
        +' GoalQuantity) where GoalQuantity<>0';
    ExecSQL;
    close;
    Sql.Text :=' insert into  #TpCostPrice (GoodsID, CostPrice )'
        +' select ID,abs(PricePurchase) from DAgoods where ID not in '
        +' (select distinct GoodsID from #TpCostPrice)' ;
    ExecSQL;
  end;
  ClientQLDBLookup.SetFocus;
end;

procedure TSLEdSaleGoalUnitToPackForm.FormDeactivate(Sender: TObject);
var  adoTemp: TADOQuery;
begin
  inherited;
  adoTemp := TADOQuery.Create(nil);
  adoTemp.Connection := CommonData.acnConnection;
  adoTemp.Close;
  adoTemp.SQL.Text :=' IF EXISTS(  SELECT * FROM tempdb..sysobjects '
        +' WHERE ID = OBJECT_ID('+Quotedstr('tempdb..#TpCostPrice')
        +' )) DROP TABLE #TpCostPrice ' ;
  adoTemp.ExecSQL;


end;


function TSLEdSaleGoalUnitToPackForm.CreateReport: TQuickRep;
begin
  Result := TSLSaleVoucherReport.Create(Self);
  TBaseVoucherReport(Result).SetMasterDataSet(MasterDataSet);
end;

procedure TSLEdSaleGoalUnitToPackForm.adsDetailGoalQuantityChange(
  Sender: TField);
var   ExChRate :real;
begin
  inherited;
  if PackUnit.fieldbyname('ExchangeRate').IsNull then ExChRate :=1
     else ExChRate :=PackUnit.fieldbyname('ExchangeRate').AsFloat;

  adsDetail.FieldByName('Quantity').ReadOnly :=False;
  adsDetail.FieldByName('Quantity').AsFloat :=
       adsDetail.fieldbyname('GoalQuantity').AsFloat/ExChRate;
  adsDetail.FieldByName('Quantity').ReadOnly :=True;

  adsDetail.FieldByName('Amount').ReadOnly :=False;
  adsDetail.FieldByName('Amount').AsFloat :=
       adsDetail.fieldbyname('GoalQuantity').asfloat
         *adsDetail.fieldbyname('PriceBase').AsFloat;
  adsDetail.FieldByName('Amount').ReadOnly :=True;
end;

end.
