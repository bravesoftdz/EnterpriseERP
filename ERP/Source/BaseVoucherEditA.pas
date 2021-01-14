unit BaseVoucherEditA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherEditSY, Menus, ActnList, DB, QLDBLkp, ComCtrls, StdCtrls,
  Mask, DBCtrls, ExtCtrls, ToolWin, Grids, DBGrids, QLDBGrid, QuickRpt,
  WSVoucherEdit;

type
  TBaseVoucherEditAForm = class(TWSVoucherEditSYForm)
    CheckAction: TAction;
    RedWordAction: TAction;
    C2: TMenuItem;
    R1: TMenuItem;
    N7: TMenuItem;
    ActualStock: TAction;
    A4: TMenuItem;
    StockChange: TAction;
    PCOrderTrail: TAction;
    SLOrderTrail: TAction;
    SLsaleLeger: TAction;
    SLClearLeger: TAction;
    SLActualPrice: TAction;
    SLCredit: TAction;
    SalePrice: TAction;
    SLContractPrice: TAction;
    PCPurchaseLeger: TAction;
    PCClearLeger: TAction;
    PCActualPrice: TAction;
    PCCredit: TAction;
    PurchasePrice: TAction;
    PCContractPrice: TAction;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    SubmitCNLAction: TAction;
    N30: TMenuItem;
    StockConsign: TAction;
    CashBalance: TAction;
    N32: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    CashFlow: TAction;
    EmployeeLend: TAction;
    N36: TMenuItem;
    N37: TMenuItem;
    ReceiptPayable: TAction;
    N38: TMenuItem;
    FNExpenseReport: TAction;
    N39: TMenuItem;
    N40: TMenuItem;
    N13: TMenuItem;
    N31: TMenuItem;
    YDPurchasePlan: TAction;
    N48: TMenuItem;
    procedure SLActualPriceExecute(Sender: TObject);
    procedure RedWordActionExecute(Sender: TObject);
    procedure CheckActionExecute(Sender: TObject);
    procedure SLOrderTrailExecute(Sender: TObject);
    procedure StockChangeExecute(Sender: TObject);
    procedure SLsaleLegerExecute(Sender: TObject);
    procedure SLClearLegerExecute(Sender: TObject);
    procedure SLCreditExecute(Sender: TObject);
    procedure PCCreditExecute(Sender: TObject);
    procedure SalePriceExecute(Sender: TObject);
    procedure PurchasePriceExecute(Sender: TObject);
    procedure SLContractPriceExecute(Sender: TObject);
    procedure PCContractPriceExecute(Sender: TObject);
    procedure PCOrderTrailExecute(Sender: TObject);
    procedure PCActualPriceExecute(Sender: TObject);
    procedure PCClearLegerExecute(Sender: TObject);
    procedure CashBalanceExecute(Sender: TObject);
    procedure PCPurchaseLegerExecute(Sender: TObject);
    procedure ActualStockExecute(Sender: TObject);
    procedure ReceiptPayableExecute(Sender: TObject);
    procedure EmployeeLendExecute(Sender: TObject);
    procedure StockConsignExecute(Sender: TObject);
    procedure UpdateDBGrid;
    procedure FormShow(Sender: TObject);
    procedure YDPurchasePlanExecute(Sender: TObject);
  private
    { Private declarations }
  protected
    function CreateReport: TQuickRep; override;
  public
    { Public declarations }
  end;

implementation

uses VoucherQuery, BaseVoucherRpt;

{$R *.dfm}

procedure TBaseVoucherEditAForm.SLActualPriceExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SLActualPrice.Caption,SLActualPrice.Hint,' select a.Code as [���],a.Date as [����], '
        +' a.BillMode [ҵ�����],                     '
        +' a.Deliver [������ʽ], c.name as [�ͻ�����] ,'
        +' E.name as [��Ʒ����],f.name as [��װ��λ],'
        +' b.Quantity as [��Ʒ����],g.name as  [��׼��λ],'
        +' b.PriceBase as [����],                          '
        +' d.name as [������]                              '
        +' from SLSaleDetail  b                           '
        +' left outer join SLSaleMaster a on  a.id=b.masterID '
        +' left outer join  DAClient c     on c. ID=a.ClientID '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID     '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID   '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID   '
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' order by a.Date Desc ');
end;

procedure TBaseVoucherEditAForm.RedWordActionExecute(Sender: TObject);
var
  Field: TField;
begin
  inherited;
  with MasterDataSet do
  begin
    Edit;
    Field := FindField('ModeC');
    if Field <> nil then
      if Field.AsInteger=-1 then exit
      else  Field.AsInteger :=-1;
    Field := FindField('BillMode');
    if Field <> nil then
    begin
      Field.ReadOnly :=False;
      Field.AsString := Field.AsString + '[����]';
      Field.ReadOnly :=True;
    end;
  end;
end;

procedure TBaseVoucherEditAForm.CheckActionExecute(Sender: TObject);
begin
  inherited;
  with MasterDataSet do
  begin
    Edit;
    FieldByName('RecordState').AsString := '����';
    ShowMessage('�����Ѿ����ˣ���δ�ύ֮ǰ�Կ��޸�');
  end;
end;

procedure TBaseVoucherEditAForm.SLOrderTrailExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SLOrderTrail.Caption,SLOrderTrail.Hint,' select * from ( '
        +' select a.Code as [���],a.Date [����],                 '
        +' a.BillMode [ҵ�����],                               '
        +' a.ClearDate [��������],                              '
        +' a.Deliver [������ʽ], c.name as [�ͻ�����] ,         '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],           '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [����], '
        +' g.name as  [��׼��λ],      '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��׼����], '
        +' b.PriceBase as [����],                               '
        +' b.Amount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��Ʒ���] ,            '
        +' b.TaxAmount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [˰��] ,             '
        +' b.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [���ӷ���],          '
        +' b.Discount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [�ۿ۽��],           '
        +' d.name as [������],                                  '
        +' a.RecordState as [ƾ��״̬]                          '
        +' from SLOrderDetail  b                                '
        +' left outer join SLOrderMaster a on  a.id=b.masterID    '
        +' left outer join  DAClient c     on c. ID=a.ClientID   '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID    '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID'
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' and b.GoodsID<>0 and b.GoalQuantity<>0'
        +' UNION ALL  '
        +' select a.Code as [���],a.Date [����],                   '
        +' a.BillMode [ҵ�����],                               '
        +' a.ClearDate [��������],                              '
        +' a.Deliver [������ʽ], c.name as [�ͻ�����] ,         '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],           '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [����],'
        +' g.name as  [��׼��λ],      '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [��׼����], '
        +' b.PriceBase as [����],                               '
        +' b.Amount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��Ʒ���] ,            '
        +' b.TaxAmount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [˰��] ,             '
        +' b.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [���ӷ���],          '
        +' b.Discount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [�ۿ۽��],           '
        +' d.name as [������],                                  '
        +' a.RecordState as [ƾ��״̬]                          '
        +' from SLsaleDetail  b                                '
        +' left outer join SLsaleMaster a on  a.id=b.masterID    '
        +' left outer join  DAClient c     on c. ID=a.ClientID   '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID    '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID'
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' and b.GoodsID<>0 and b.GoalQuantity<>0'
        +' and a.ClientID in (select Distinct ClientID from SLOrderMaster) '
        +' ) as a  order by [����] DESC');

end;

procedure TBaseVoucherEditAForm.StockChangeExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(StockChange.Caption,StockChange.Hint,
        ' select a.Code as [���],a.Date [����],           '
        +' a.BillMode [ҵ�����],                           '
        +' w.name as [�ֿ�����] ,                           '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],       '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [����],      '
        +' g.name as  [��׼��λ],                            '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [��׼����],     '
        +' a.Deliver [���/������ʽ], c.name as [�����/������] ,  '
        +' d.name as [������],                                     '
        +' a.RecordState as [ƾ��״̬]                             '
        +' from SLGoodsOutDetail  b                                '
        +' left outer join SLGoodsOutMaster a on  a.id=b.masterID  '
        +' left outer join  DAClient c     on c. ID=a.ClientID     '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID    '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID        '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID      '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID      '
        +' left outer join  STWarehouse w   on w.id=a.WarehouseID  '
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' UNION ALL '
        +' select a.Code as [���],a.Date [����],                  '
        +' a.BillMode [ҵ�����],                                  '
        +' w.name as [�ֿ�����] ,                                  '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],              '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [����],                  '
        +' g.name as  [��׼��λ],                                  '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��׼����],          '
        +' a.Deliver [���/������ʽ], c.name as [�����/������] ,  '
        +' d.name as [������],                                     '
        +' a.RecordState as [ƾ��״̬]                             '
        +' from PCGoodsInDetail  b                                 '
        +' left outer join PCGoodsInMaster a on  a.id=b.masterID   '
        +' left outer join  DAClient c     on c. ID=a.ClientID     '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID    '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID        '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID      '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID      '
        +' left outer join  STWarehouse w   on w.id=a.WarehouseID  '
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')+' '  );
end;

procedure TBaseVoucherEditAForm.SLsaleLegerExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SLsaleLeger.Caption,SLsaleLeger.Hint,
        ' select a.Code as [���],a.Date as [����],    '
        +' a.BillMode [ҵ�����],                      '
        +' a.ClearDate [��������],                              '
        +' a.Deliver [������ʽ], c.name as [�ͻ�����] ,         '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],           '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [����],'
        +' g.name as  [��׼��λ],      '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��׼����], '
        +' b.PriceBase as [����],                               '
        +' b.Amount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��Ʒ���] ,            '
        +' b.TaxAmount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [˰��] ,             '
        +' b.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [���ӷ���],          '
        +' b.Discount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [�ۿ۽��],           '
        +' d.name as [������],                                  '
        +' a.RecordState as [ƾ��״̬]                          '
        +' from SLsaleDetail  b                                '
        +' left outer join SLsaleMaster a on  a.id=b.masterID    '
        +' left outer join  DAClient c     on c. ID=a.ClientID   '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID    '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID'
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��') +' and b.goodsID<>0'
        +' order by [����] DESC');
end;

procedure TBaseVoucherEditAForm.SLClearLegerExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SLClearLeger.Caption,SLClearLeger.Hint,
        ' select Date as [����], Code as [���],'
        +' BillMode as [ҵ�����],Client as [�ͻ�/��������] ,'
        +' Accounts AS [�ʻ�����],AmountD  as [�տ���],'
        +' AmountC as  [����/�ۿ�/����], AmountC-AmountD as [Ӧ���ʿ��] ,'
        +' Employee as [������] ,Brief  as [ҵ��ժҪ],                   '
        +' Memo  as [��ע] ,RecordState as [ƾ��״̬]                    '
        +' from                                                          '
        +' (select f.id,  f.ClientID, f.EmployeeID,                      '
        +' f.Date , f.Code , f.BillMode ,                                '
        +' C.name as Client , FA.NAME AS Accounts,                       '
        +' f.AmountD  as AmountD,                                        '
        +' f. AmountRed*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)*(-1)  as AmountC,                    '
        +' E.name as Employee ,f.Brief  , F.Memo  ,                      '
        +' F.RecordState                                                 '
        +' from FNClearSLMaster F                                        '
        +' LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID            '
        +' LEFT Outer join  DAClient C on C.ID=F.ClientID                '
        +' LEFT Outer join   FNAccounts  FA  on FA.ID=F.AccountsID  '
        +' where F.RecordState<>'+Quotedstr('ɾ��')
        +' UNION ALL    '
        +' select f.id,  f.ClientID, f.EmployeeID,                  '
        +' f.Date , f.Code , f.BillMode ,                            '
        +' C.name as Client , '+Quotedstr('_ _')+ ' as accounts, 0  as AmountD ,                                           '
        +' sd.AmountC*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)  as AmountC,                  '
        +' E.name as Employee ,f.Brief  , F.Memo  ,                  '
        +' F.RecordState                                             '
        +' from SLSaleMaster F                                       '
        +' LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID        '
        +' LEFT Outer join  DAClient C on C.ID=F.ClientID            '
        +' LEFT Outer join  '
        +' ( select MasterID,(Sum(ISnull(Amount,0) )- '
        +' Sum(ISnull(discount,0) )+ '
        +' Sum(ISnull(taxAmount,0) )+Sum(ISnull(Sundryfee,0) ) ) '
        +' as AmountC  from SLSaleDetail group by MasterID ) as '
        +' sd on SD.masterID=F.id '
        +' where F.RecordState<>'+Quotedstr('ɾ��')
        +' ) as SLclear Order By Date Desc  ' );
end;

procedure TBaseVoucherEditAForm.SLCreditExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SLCredit.Caption,SLCredit.Hint,
        ' select Date as [����], Code as [���],  '
        +' c.name as [�ͻ�����], CreditClass as [���õȼ�],'
        +' QuotaAmount as [���ö��], QuotaAmountMax as [�����], '
        +' QuotaAmountMin as [��Ͷ��], StartDate as [��Ч����], '
        +' ExpireDate as [��ֹ����], a.Memo as  [��ע] '
        +' from SLCredit a  '
        +' LEFT Outer join  DAClient C on C.ID=a.ClientID '
        +' where a.RecordState<>'+Quotedstr('ɾ��')  );
end;

procedure TBaseVoucherEditAForm.PCCreditExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(PCCredit.Caption,PCCredit.Hint,
        ' select Date as [����], Code as [���],  '
        +' c.name as [��������], CreditClass as [���õȼ�],'
        +' QuotaAmount as [���ö��], QuotaAmountMax as [�����], '
        +' QuotaAmountMin as [��Ͷ��], StartDate as [��Ч����], '
        +' ExpireDate as [��ֹ����], a.Memo as  [��ע] '
        +' from PCCredit a  '
        +' LEFT Outer join  DAClient C on C.ID=a.ClientID '
        +' where a.RecordState<>'+Quotedstr('ɾ��')  );
end;

procedure TBaseVoucherEditAForm.SalePriceExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SalePrice.Caption,SalePrice.Hint,' select'
        +' Date as [����], a.Code as [���], '
        +' PriceClass AS [�۸����],b.name as [��Ʒ����], '
        +' c.name as [��װ��λ], PriceBase as [�����ۼ�],  '
        +' PriceMax as [����޼�], PriceMin as [����޼�], '
        +' StartDate as [��Ч����], '
        +' ExpireDate as [��ֹ����], '
        +' a.Memo as [��ע]  from SLSalePrice  a '
        +' left Outer Join DAGoods  b on b.ID=a.GoodsID '
        +' left Outer Join MSUnit  c  on c.ID=a.PackUnitID '
        +' where a.RecordState<>'+Quotedstr('ɾ��') );
end;

procedure TBaseVoucherEditAForm.PurchasePriceExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(PurchasePrice.Caption,PurchasePrice.Hint,' select'
        +' Date as [����], a.Code as [���], '
        +' PriceClass AS [�۸����],b.name as [��Ʒ����], '
        +' c.name as [��װ��λ], PriceBase as [�����ۼ�],  '
        +' PriceMax as [����޼�], PriceMin as [����޼�], '
        +' StartDate as [��Ч����], '
        +' ExpireDate as [��ֹ����], '
        +' a.Memo as [��ע]  from PCPurchasePrice  a '
        +' left Outer Join DAGoods  b on b.ID=a.GoodsID '
        +' left Outer Join MSUnit  c  on c.ID=a.PackUnitID '
        +' where a.RecordState<>'+Quotedstr('ɾ��') );
end;

procedure TBaseVoucherEditAForm.SLContractPriceExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SLContractPrice.Caption,SLContractPrice.Hint,' select'
        +' Date [����], b.Code [���], ContractClass [��ͬ�۸����],'
        +' c.name [�ͻ�����] ,e.name [��Ʒ����],                     '
        +' a.Spec [����ͺ�], d.name [��װ��λ],               '
        +' a.Quantity [������Χ����], a.QuantityE  [������Χ����],   '
        +' a.PriceClear [����۸�],                                  '
        +' a.PriceMin [��ͼ۸�],                                    '
        +' a.PriceMax [��߼۸�],                                    '
        +' b.StartDate [��Ч����], b.ExpireDate [��ֹ����], b.Memo [��ע]'
        +' from SLContractPriceDetail  a                                 '
        +' left Outer Join SLContractPriceMaster b   on b.ID=a.MasterID  '
        +' left Outer Join daclient   c   on c.ID=b.ClientID             '
        +' left Outer Join MSUnit  d   on d.ID=a.PackUnitID              '
        +' left Outer Join DAGoods  e   on e.ID=a.GoodsID                '
        +' where a.GoodsID<>0 and b.RecordState<>'+Quotedstr('ɾ��') );
end;

procedure TBaseVoucherEditAForm.PCContractPriceExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(PCContractPrice.Caption,PCContractPrice.Hint,' select'
        +' Date [����], b.Code [���], ContractClass [��ͬ�۸����],'
        +' c.name [�ͻ�����] ,e.name [��Ʒ����],                     '
        +' a.Spec [����ͺ�], d.name [��װ��λ],               '
        +' a.Quantity [������Χ����], a.QuantityE  [������Χ����],   '
        +' a.PriceClear [����۸�],                                  '
        +' a.PriceMin [��ͼ۸�],                                    '
        +' a.PriceMax [��߼۸�],                                    '
        +' b.StartDate [��Ч����], b.ExpireDate [��ֹ����], b.Memo [��ע]'
        +' from PCContractPriceDetail  a                                 '
        +' left Outer Join PCContractPriceMaster b   on b.ID=a.MasterID  '
        +' left Outer Join daclient   c   on c.ID=b.ClientID             '
        +' left Outer Join MSUnit  d   on d.ID=a.PackUnitID              '
        +' left Outer Join DAGoods  e   on e.ID=a.GoodsID                '
        +' where a.GoodsID<>0 and b.RecordState<>'+Quotedstr('ɾ��') );
end;

procedure TBaseVoucherEditAForm.PCOrderTrailExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(PCOrderTrail.Caption,PCOrderTrail.Hint,' select * from ( '
        +' select a.Code as [���],a.Date [����],                 '
        +' a.BillMode [ҵ�����],                               '
        +' a.ClearDate [��������],                              '
        +' a.Deliver [������ʽ], c.name as [��������] ,         '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],           '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [����], '
        +' g.name as  [��׼��λ],      '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��׼����], '
        +' b.PriceBase as [����],                               '
        +' b.Amount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��Ʒ���] ,            '
        +' b.TaxAmount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [˰��] ,             '
        +' b.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [���ӷ���],          '
        +' b.Discount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [�ۿ۽��],           '
        +' d.name as [������],                                  '
        +' a.RecordState as [ƾ��״̬]                          '
        +' from PCOrderDetail  b                                '
        +' left outer join PCOrderMaster a on  a.id=b.masterID    '
        +' left outer join  DAClient c     on c. ID=a.ClientID   '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID    '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID'
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' and b.GoodsID<>0 and b.GoalQuantity<>0'
        +' UNION ALL  '
        +' select a.Code as [���],a.Date [����],                   '
        +' a.BillMode [ҵ�����],                               '
        +' a.ClearDate [��������],                              '
        +' a.Deliver [������ʽ], c.name as [��������] ,         '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],           '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [����],'
        +' g.name as  [��׼��λ],      '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [��׼����], '
        +' b.PriceBase as [����],                               '
        +' b.Amount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��Ʒ���] ,            '
        +' b.TaxAmount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [˰��] ,             '
        +' b.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [���ӷ���],          '
        +' b.Discount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as [�ۿ۽��],           '
        +' d.name as [������],                                  '
        +' a.RecordState as [ƾ��״̬]                          '
        +' from PCPurchaseDetail  b                                '
        +' left outer join PCPurchaseMaster a on  a.id=b.masterID    '
        +' left outer join  DAClient c     on c. ID=a.ClientID   '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID    '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID'
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' and b.GoodsID<>0 and b.GoalQuantity<>0'
        +' and a.ClientID in (select Distinct ClientID from PCOrderMaster) '
        +' ) as a order by [����] DESC');
end;

procedure TBaseVoucherEditAForm.PCActualPriceExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(PCActualPrice.Caption,PCActualPrice.Hint,' select a.Code as [���],a.Date as [����], '
        +' a.BillMode [ҵ�����],                     '
        +' a.Deliver [������ʽ], c.name as [�ͻ�����] ,'
        +' E.name as [��Ʒ����],f.name as [��װ��λ],'
        +' b.Quantity as [��Ʒ����],g.name as  [��׼��λ],'
        +' b.PriceBase as [����],                          '
        +' d.name as [������]                              '
        +' from PCPurchaseDetail  b                           '
        +' left outer join PCPurchaseMaster a on  a.id=b.masterID '
        +' left outer join  DAClient c     on c. ID=a.ClientID '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID     '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID   '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID   '
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' order by a.Date Desc ');
end;

procedure TBaseVoucherEditAForm.PCClearLegerExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(PCClearLeger.Caption,PCClearLeger.Hint,
        ' select Date as [����], Code as [���],'
        +' BillMode as [ҵ�����],Client as [�ͻ�/��������] ,'
        +' Accounts AS [�ʻ�����],AmountC  as [������], '
        +' AmountD as  [�ɹ�/�ۿ�/����], AmountD-Amountc as [Ӧ���ʿ��] ,'
        +' Employee as [������] ,Brief  as [ҵ��ժҪ],                   '
        +' Memo  as [��ע] ,RecordState as [ƾ��״̬]                    '
        +' from                                                          '
        +' (select f.id,  f.ClientID, f.EmployeeID,                      '
        +' f.Date , f.Code , f.BillMode ,                                '
        +' C.name as Client , FA.NAME AS Accounts,                       '
        +' f.AmountC  as AmountC,                                        '
        +' f. AmountRed*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)*(-1)  as AmountD,                    '
        +' E.name as Employee ,f.Brief  , F.Memo  ,                      '
        +' F.RecordState                                                 '
        +' from FNClearPCMaster F                                        '
        +' LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID            '
        +' LEFT Outer join  DAClient C on C.ID=F.ClientID                '
        +' LEFT Outer join   FNAccounts  FA  on FA.ID=F.AccountsID  '
        +' where F.RecordState<>'+Quotedstr('ɾ��')
        +' UNION ALL    '
        +' select f.id,  f.ClientID, f.EmployeeID,                  '
        +' f.Date , f.Code , f.BillMode ,                            '
        +' C.name as Client , '+Quotedstr('_ _')+ ' as accounts, 0  as AmountC ,                                           '
        +' sd.AmountC*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)  as AmountD,                  '
        +' E.name as Employee ,f.Brief  , F.Memo  ,                  '
        +' F.RecordState                                             '
        +' from PCPurchaseMaster F                                       '
        +' LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID        '
        +' LEFT Outer join  DAClient C on C.ID=F.ClientID            '
        +' LEFT Outer join  '
        +' ( select MasterID,(Sum(ISnull(Amount,0) )- '
        +' Sum(ISnull(discount,0) )+ '
        +' Sum(ISnull(taxAmount,0) )+Sum(ISnull(Sundryfee,0) ) ) '
        +' as AmountC  from PCPurchaseDetail group by MasterID ) as '
        +' sd on SD.masterID=F.id '
        +' where F.RecordState<>'+Quotedstr('ɾ��')
        +' ) as PCclear Order By Date Desc  ' );
end;

procedure TBaseVoucherEditAForm.CashBalanceExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(CashBalance.Caption,CashBalance.Hint,
        ' select  '
        +' a.AccountsID as [�ʻ����],b.name as [�ʻ�����] , '
        +' sum(isnull(AmountD,0)) as  [������], '
        +' sum(isnull(AmountC,0)) as  [֧�����],            '
        +' sum(isnull(AmountD,0))- sum(isnull(AmountC,0)) as [���/���]  '
        +' from                                               '
        +' (select Date,a.code,billmode,brief,b.name as Client,a.RecordState,AccountsID,  AmountD, AmountC  '
        +' from FNclearslMaster a left outer join  daclient b on b.id=a.clientid                            '
        +' UNION ALL                                                                                            '
        +' select Date,a.code,billmode,brief,b.name as Client,a.RecordState,AccountsID,  AmountD, AmountC   '
        +' from FNclearPCMaster a left outer join  daclient b on b.id=a.clientid                            '
        +' UNION ALL                                                                                            '
        +' select Date,a.code,billmode,brief,b.name as Client,a.RecordState,AccountsID,  AmountD, AmountC   '
        +' from FNcashinMaster a left outer join  MSEmployee b on b.id=a.clientid                           '
        +' UNION ALL                                                                                            '
        +' select Date,a.code,billmode,brief,b.name as Client,a.RecordState,AccountsID,  AmountD, AmountC   '
        +' from FNcashoutMaster a left outer join  MSEmployee b on b.id=a.clientid                          '
        +' UNION ALL                                                                                            '
        +' select Date,a.code,billmode,brief,b.name as Client,a.RecordState,AccountsID,  0.00, AmountC      '
        +' from FNExpenseMaster a left outer join  MSEmployee b on b.id=a.clientid                          '
        +' UNION ALL                                                                                            '
        +' select Date,a.code,billmode,brief,b.name as Client,a.RecordState,AccountsID,  AmountD, AmountC   '
        +' from FNCashoutInMaster a left outer join  FNAccounts b on b.id=a.clientid     '  //�����ʻ���¼
        +' UNION ALL                                                                                            '
        +' select Date,a.code,billmode,brief,b.name as Client,a.RecordState,clientid,  AmountC, AmountD   '
        +' from FNCashoutInMaster a left outer join  FNAccounts b on b.id=a.AccountsID ) '  //�����ʻ���¼
        +' as a left outer join FNAccounts b on b.ID=a.AccountsID                                           '
        +' where a.RecordState<>'+Quotedstr('ɾ��')+'  and b.AccountType not like '+Quotedstr('%ҵ���ʽ�%')
        +' and a.AccountsID<>0 group by a.AccountsID,b.name' );
end;

procedure TBaseVoucherEditAForm.PCPurchaseLegerExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(SLsaleLeger.Caption,SLsaleLeger.Hint,
        ' select a.Code as [���],a.Date as [����],    '
        +' a.BillMode [ҵ�����],                      '
        +' a.ClearDate [��������],                              '
        +' a.Deliver [������ʽ], c.name as [��������] ,         '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],           '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [����],'
        +' g.name as  [��׼��λ],      '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��׼����], '
        +' b.PriceBase as [����],                               '
        +' b.Amount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [��Ʒ���] ,            '
        +' b.TaxAmount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [˰��] ,             '
        +' b.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [���ӷ���],          '
        +' b.Discount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [�ۿ۽��],           '
        +' d.name as [������],                                  '
        +' a.RecordState as [ƾ��״̬]                          '
        +' from PCPurchaseDetail  b                                '
        +' left outer join PCPurchaseMaster a on  a.id=b.masterID    '
        +' left outer join  DAClient c     on c. ID=a.ClientID   '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID    '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID'
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
        +' order by [����] DESC');
end;

procedure TBaseVoucherEditAForm.ActualStockExecute(Sender: TObject);
var year,month,day :word;
    datestr :string;
begin
  inherited;
  DecodeDate(Date,year, month, day);
  datestr:=datetoSTR(Date);
  ShowQueryForm(ActualStock.Caption,ActualStock.Hint, 'select '
        +' w.name as [�ֿ�����] ,                           '
        +' E.name as [��Ʒ����],f.name as [��װ��λ],       '
        +' sum(isnull(b.Quantity,0))  as [����],            '
        +' g.name as  [��׼��λ],                           '
        +' sum(isnull(b.GoalQuantity,0))  as [��׼����]     '

        +' FROM ('
        +' select b.recordstate,b.date ,b.warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity*(-1) as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity*(-1) AS GoalQuantity, '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount*(-1) as Amount from  SLGoodsOutDetail a    '
        +' left outer join SLGoodsOutMaster b on b.ID=a.MasterID   '  //���۳����
        +' UNION ALL '
        +' select b.recordstate,b.date ,b.warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity AS GoalQuantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount AS Amount from  PCGoodsInDetail a  '
        +' left outer join PCGoodsInMaster b on b.ID=a.MasterID   '   //�ɹ�����
        +' UNION ALL '
        +' select b.recordstate,b.date ,b.warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity*(-1) as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity*(-1) AS GoalQuantity,  '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount*(-1) AS Amount from  YDGoodsOutDetail a  '
        +' left outer join YDGoodsOutMaster b on b.ID=a.MasterID   ' //�������ϱ�
        +' UNION ALL '
        +' select b.recordstate,b.date ,b.warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity AS GoalQuantity,     '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount AS Amount from  YDGoodsInDetail a    '
        +' left outer join YDGoodsInMaster b on b.ID=a.MasterID   '  //��������
        +' UNION ALL '
        +' select b.recordstate,b.date ,b.ClientID as warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity*(-1) as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity*(-1) AS GoalQuantity,     '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount*(-1) AS Amount from  STGoodsOutInDetail a   '
        +' left outer join STGoodsOutInMaster b on b.ID=a.MasterID   ' //���䶯�� (�����ֿ�)
        +' UNION ALL '
        +' select b.recordstate,b.date ,warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity AS GoalQuantity,      '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount AS Amount from  STGoodsOutInDetail a  '
        +' left outer join STGoodsOutInMaster b on b.ID=a.MasterID   ' //���䶯�� ������ֿ⣩
        //
        +' UNION ALL '
        +' select b.recordstate,b.date ,b.ClientID as warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity*(-1) as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity*(-1) AS GoalQuantity,     '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount*(-1) AS Amount from  STGoodsCountOffDetail a   '
        +' left outer join STGoodsCountOffMaster b on b.ID=a.MasterID   '
        +' where b.BillMode<>'+Quotedstr('�����ӯ') //����̵�� (�̿�\������Ĳֿ�)
        +' UNION ALL '
        +' select b.recordstate,b.date ,warehouseID,GoodsID,PackunitID,'
        +' GoalUnitID, Isnull(ModeDC,1)*Isnull(ModeC,1)*Quantity as Quantity,   '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*GoalQuantity AS GoalQuantity,      '
        +' Isnull(ModeDC,1)*Isnull(ModeC,1)*Amount AS Amount from  STGoodsCountOffDetail a  '
        +' left outer join STGoodsCountOffMaster b on b.ID=a.MasterID   '
        +' where b.BillMode='+Quotedstr('�����ӯ')  //����̵�� ����ӯ����ֿ⣩
        +'   ) as b '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID       '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID     '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID     '
        +' left outer join  STWarehouse w   on w.id=b.WarehouseID '
        +' WHERE b.DATE<='+Quotedstr(datestr)+' and b.recordstate<>'+Quotedstr('ɾ��')
        +' group by  w.name , E.name ,f.name ,g.name  ');
end;

procedure TBaseVoucherEditAForm.ReceiptPayableExecute(Sender: TObject);
begin
  inherited;
//
end;

procedure TBaseVoucherEditAForm.EmployeeLendExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(EmployeeLend.Caption,EmployeeLend.Hint, 'select b.name '
      +' as [ְԱ����], '
      +' Sum(Isnull(a.AmountD,0))-sum(Isnull(a.AmountC,0)) as [����Ӧ�����]'
      +' from (                                                '
      +' select Code,date,ClientID, BillMode,0.00 as  AmountD,'
      +' AmountD+AmountRed as  AmountC,recordstate from FnCashinmaster'
      +' UNION ALL '
      +' select Code,date,ClientID, BillMode,AmountC+AmountRed  as'
      +' AmountD, 0.00 as  AmountC,recordstate from FnCashOutmaster'
      +' UNION ALL  '
      +' select Code,date,ClientID, BillMode,0.00  as  AmountD, '
      +' AmountRed as  AmountC,recordstate from FnExpensemaster ) as a '
      +' left outer join MsEmployee b on b.ID=A.ClientID  '
      +' where a.Recordstate<>'+QUOTEDSTR('ɾ��')
      +' Group by a.ClientID, b.name' );
end;

function TBaseVoucherEditAForm.CreateReport: TQuickRep;
begin
  Result := TBaseVoucherReport.Create(Self);
  TBaseVoucherReport(Result).SetMasterDataSet(MasterDataSet);
end;

procedure TBaseVoucherEditAForm.StockConsignExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(StockConsign.Caption,StockConsign.Hint, ' select Client as [�ͻ�����] , '
        +' Goods  as [�����Ʒ����],PackUnit as [��װ��λ], '
        +' sum(isnull(Quantity,0)) as [�������],                          '
        +' GoalUnit as  [��׼��λ],                         '
        +' sum(isnull(GoalQuantity,0))  as [����׼����],                 '
        +' Employee as [������]                             '
        +' from  (                                          '
        +' select c.name as Client ,                        '
        +' E.name as Goods,f.name as Packunit,              '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as Quantity,    '
        +' g.name as  GoalUnit,                             '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)*(-1) as GoalQuantity, '
        +' d.name as Employee                                    '
        +' from SLSaleClientDetail  b                            '
        +' left outer join SLSaleClientMaster a on  a.id=b.masterID '
        +' left outer join  DAClient c     on c. ID=a.ClientID      '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID     '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID         '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID       '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID       '
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')+' and Quantity<>0'
        +' UNION ALL                                                    '
        +' select c.name as Client ,                                '
        +' E.name as Goods,f.name as Packunit,                      '
        +' b.Quantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as Quantity,                 '
        +' g.name as  GoalUnit,                                     '
        +' b.GoalQuantity*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as GoalQuantity,         '
        +' d.name as Employee                                        '
        +' from SLGoodsOutDetail  b                                  '
        +' left outer join SLGoodsOutMaster a on  a.id=b.masterID    '
        +' left outer join  DAClient c     on c. ID=a.ClientID       '
        +' left outer join  MSEmployee  d  on d.id=a.EmployeeID      '
        +' left outer join  DAGoods   e   on e.id=b.GoodsID          '
        +' left outer join  MSunit   f   on f.id=b.PackUnitID        '
        +' left outer join  MSunit   g   on g.id=b.GoalUnitID        '
        +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��') +' and Quantity<>0'
        +' and a.ClientID in ( select distinct ClientID from '
        +' SLSaleClientMaster WHERE  RECORDSTATE<>'+Quotedstr('ɾ��')
        +' )  ) as a group by Client,Goods,PackUnit,GoalUnit,Employee ' );
end;

procedure TBaseVoucherEditAForm.UpdateDBGrid;
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

procedure TBaseVoucherEditAForm.FormShow(Sender: TObject);
begin
  inherited;
//  UpdateDBGrid;
end;

procedure TBaseVoucherEditAForm.YDPurchasePlanExecute(Sender: TObject);
begin
  inherited;
  ShowQueryForm(YDPurchasePlan.Caption,YDPurchasePlan.Hint,
    ' select  '
   +' b.CODE [�ɹ��ƻ����] ,b.date [��������], '
   +' b.ClearDate [��������],   '
   +' f.name [��Ʒ����],        '
   +' d.Name [��λ����],        '
   +' a.PriceBase [�ƻ�����],   '
   +' a.GoalQuantity [����],    '
   +' a.Amount [�ɱ����],      '
   +' a.Memo   [�����ƻ����],  '
   +' b.memo [��ע],            '
   +' b.Recordstate [�ɹ�״̬]  '
   +' from YDPurchasePlanDetail a  '
   +' left outer join  YDPurchasePlanMaster b on a.MasterID=b.ID '
   +' left outer join  MSEmployee c on b.EmployeeID =c.ID        '
   +' left outer join  MSUnit d on a.GoalUnitID=d.ID             '
   +' left outer join  MSEmployee e on b.ClientID =e.ID          '
   +' left outer join  DAGoods f on a.GoodsID =f.ID ' );

end;

end.

