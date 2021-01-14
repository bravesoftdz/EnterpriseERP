unit FNReceiptPayLeger;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, Menus;

type
  TFNReceiptPayLegerForm = class(TWSVoucherBrowseForm)
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
    ADOQuery: TADOQuery;
    adsMasterDSDesigner: TDateTimeField;
    adsMasterDSDesigner2: TStringField;
    adsMasterDSDesigner3: TStringField;
    adsMasterDSDesigner4: TStringField;
    adsMasterDSDesigner5: TStringField;
    adsMasterDSDesigner6: TBCDField;
    adsMasterDSDesigner7: TBCDField;
    adsMasterDSDesigner8: TBCDField;
    adsMasterDSDesigner9: TStringField;
    adsMasterDSDesigner10: TStringField;
    adsMasterDSDesigner11: TStringField;
    adsMasterDSDesigner12: TStringField;
    ToolButton1: TToolButton;
    procedure DBGridCellClick(Column: TColumn);
    procedure DBGridDblClick(Sender: TObject);
    procedure UpdateDBGrid;
    procedure ShowForm(const FCaption,TbCaption,ClientID,DateF,E:string);
    procedure DBGridTitleClick(Column: TColumn);

  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  FNReceiptPayLegerForm: TFNReceiptPayLegerForm;


implementation

uses CommonDM ;


{$R *.dfm}

function TFNReceiptPayLegerForm.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TFNReceiptPayLegerForm.DBGridCellClick(Column: TColumn);
begin
//  inherited;
//  UpdateDBGrid;
end;

procedure TFNReceiptPayLegerForm.DBGridDblClick(Sender: TObject);
begin
//  inherited;
//  UpdateDBGrid;
end;

procedure TFNReceiptPayLegerForm.UpdateDBGrid;
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

procedure TFNReceiptPayLegerForm.ShowForm(const FCaption,TbCaption,ClientID,DateF,E :string);
var Str1:string;
begin
  with TFNReceiptPayLegerForm.Create(APPLICATION)   do
  begin
    if E='1' then
    begin
      str1 :='select Date as [����], Code as [���], '
        +' BillMode as [ҵ�����],Client as [�ͻ�/��������] ,    '
        +' Accounts AS [�ʻ�����],AmountD  as [����/�ۿ�/����], '
        +' AmountC as  [�տ���] , AmountD-AmountC as [Ӧ���ʿ��] , ';
      DBGrid.Columns[5].Title.Caption :='�տ���'  ;
      DBGrid.Columns[6].Title.Caption :='����/�ۿ�/����'  ;
      DBGrid.Columns[7].Title.Caption :='Ӧ���ʿ��'  ;
    end else
    begin
       str1 :='select Date as [����], Code as [���], '
        +' BillMode as [ҵ�����],Client as [�ͻ�/��������] ,    '
        +' Accounts AS [�ʻ�����],AmountD  as [����/�ۿ�/����], '
        +' AmountC as  [�տ���] , AmountC-AmountD as [Ӧ���ʿ��] , ' ;
      DBGrid.Columns[5].Title.Caption :='�ɹ�/�ۿ�/����'  ;
      DBGrid.Columns[6].Title.Caption :='������'  ;
      DBGrid.Columns[7].Title.Caption :='Ӧ���ʿ��'  ;
    end;

    adsMaster.Close;
    adsMaster.CommandText :=str1 +' Employee as [������] ,Brief  as [ҵ��ժҪ],                     '
        +' Memo  as [��ע] ,RecordState as [ƾ��״̬]                      '
        +' from                                                            '
        +'  ( select f.id,  f.ClientID, f.EmployeeID,                      '
        +' f.Date , f.Code , f.BillMode ,                                  '
        +' C.name as Client , FA.NAME AS Accounts,                         '
        +' f.AmountRed*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)*(-1)  as AmountD,                                              '
        +' f.AmountD*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)  as AmountC,          '
        +' E.name as Employee ,f.Brief  , F.Memo  ,                        '
        +' F.RecordState                                                   '
        +' from FNClearSLMaster F                                          '
        +' LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID              '
        +' LEFT Outer join  DAClient C on C.ID=F.ClientID                  '
        +' LEFT Outer join   FNAccounts  FA  on FA.ID=F.AccountsID         '
        +' UNION ALL                                                           '
        +' select f.id,  f.ClientID, f.EmployeeID,                         '
        +' f.Date , f.Code , f.BillMode ,                                  '
        +' C.name as Client , FA.NAME AS Accounts,                         '
        +' f.AmountC*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)   as AmountD,         '
        +' f.AmountRed*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)*(-1) as AmountC,                                               '
        +' E.name as Employee ,f.Brief  , F.Memo  ,                        '
        +' F.RecordState                                                   '
        +' from FNClearPCMaster F                                          '
        +' LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID              '
        +' LEFT Outer join  DAClient C on C.ID=F.ClientID                  '
        +' LEFT Outer join   FNAccounts  FA  on FA.ID=F.AccountsID         '
        +' UNION ALL                                                           '
        +' select f.id,  f.ClientID, f.EmployeeID,                         '
        +' f.Date , f.Code , f.BillMode ,                                  '
        +' C.name as Client , '+Quotedstr('- -')+'   as accounts, '
        +' sd.AmountD*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1)  as AmountD , 0.00 as AmountC, '
        +' E.name as Employee ,f.Brief  , F.Memo  , '
        +' F.RecordState                             '
        +' from SLSaleMaster F                        '
        +' LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID '
        +' LEFT Outer join  DAClient C on C.ID=F.ClientID     '
        +' LEFT Outer join                                    '
        +'  ( select MasterID,(Sum(ISnull(Amount,0) )-        '
        +' Sum(ISnull(discount,0) )+                          '
        +' Sum(ISnull(taxAmount,0) )+Sum(ISnull(Sundryfee,0) ) )  '
        +' as AmountD  from SLSaleDetail group by MasterID ) as   '
        +' sd on SD.masterID=F.id                                 '
        +' UNION ALL                                                  '
        +' select f.id,  f.ClientID, f.EmployeeID,                '
        +' f.Date , f.Code , f.BillMode ,                         '
        +'  C.name as Client , '+Quotedstr('- -')+'  as accounts,  0.00  as AmountD , '
        +'  sd.AmountC*Isnull(f.ModeDC,1)*Isnull(f.ModeC,1) as AmountC,                    '
        +'  E.name as Employee ,f.Brief  , F.Memo  ,                   '
        +'  F.RecordState                                              '
        +'  from PCPurchaseMaster F                                    '
        +'  LEFT Outer join  MSEmployee E on E.ID=F.EmployeeID         '
        +'  LEFT Outer join  DAClient C on C.ID=F.ClientID             '
        +'  LEFT Outer join                                            '
        +'  ( select MasterID,(Sum(ISnull(Amount,0) )-                 '
        +'  Sum(ISnull(discount,0) )+                                  '
        +'  Sum(ISnull(taxAmount,0) )+Sum(ISnull(Sundryfee,0) ) )      '
        +'  as AmountC  from PCPurchaseDetail group by MasterID ) as   '
        +'  sd on SD.masterID=F.id                                     '
        +'  ) as a  where a.RecordState<>'+QuotedStr('ɾ��')
        +' and  a.ClientID='+Quotedstr(ClientID)+' and date <= '
        + Quotedstr(DateF) +' Order By Date Desc ' ;
    adsMaster.Open;
    caption :=TbCaption+FCaption;
    TabSheet1.Caption :=TbCaption+FCaption;
    ShowModal;
  end;
end;

procedure TFNReceiptPayLegerForm.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

end.
