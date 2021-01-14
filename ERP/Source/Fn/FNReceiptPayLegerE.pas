unit FNReceiptPayLegerE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, Menus;

type
  TFNReceiptPayLegerEForm = class(TWSVoucherBrowseForm)
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
    adsMasterDSDesigner6: TStringField;
    adsMasterDSDesigner7: TStringField;
    adsMasterDSDesigner8: TBCDField;
    adsMasterDSDesigner9: TBCDField;
    adsMasterDSDesigner10: TBCDField;
    adsMasterDSDesigner11: TBCDField;
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
  FNReceiptPayLegerEForm: TFNReceiptPayLegerEForm;


implementation

uses CommonDM ;


{$R *.dfm}

function TFNReceiptPayLegerEForm.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TFNReceiptPayLegerEForm.DBGridCellClick(Column: TColumn);
begin
//  inherited;
//  UpdateDBGrid;
end;

procedure TFNReceiptPayLegerEForm.DBGridDblClick(Sender: TObject);
begin
//  inherited;
//  UpdateDBGrid;
end;

procedure TFNReceiptPayLegerEForm.UpdateDBGrid;
var  I: Integer;
begin
  with DBGrid do
  begin
    FooterRowCount := 0;
    Columns[0].Footer.ValueType := fvtStaticText;
    Columns[0].Footer.Value := '�ϼ�:';
    Columns[0].Footer.Alignment := taCenter;
    Columns[0].Title.Alignment:= taCenter;
//    Columns[0].Width :=130;
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

procedure TFNReceiptPayLegerEForm.ShowForm(const FCaption,TbCaption,ClientID,DateF,E :string);
var Str1:string;
begin
  with TFNReceiptPayLegerEForm.Create(APPLICATION)   do
  begin
    adsMaster.Close;
    adsMaster.CommandText :=' select date as [����],a.code as [���], '
        +' BillMode as [ҵ�����], Brief as [ҵ��ժҪ],  '
        +' c.name as [�����/������], d.name as [������], '
        +' b.name as [�ʻ�����], AmountD as [�ܿ���],    '
        +' AmountC as [������] , AmountRed as [���ʽ��], '
        +' Isnull(AmountD,0)-Isnull(AmountC,0)-Isnull(AmountRed,0)  as [���/���],       '
        +' Memo  as [��ע]  from (   '
        +' select date,code,Recordstate,                    '
        +' BillMode,Brief,ClientID, EmployeeID ,ClearDate , '
        +' AccountsID ,  0.00 as AmountD, Isnull(AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) '
        +' as AmountC ,Isnull(AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) as AmountRed, Memo '
        +' from FNCashInMaster                                        '
        +' UNION ALL                                                      '
        +' select date,code,Recordstate,                              '
        +' BillMode,Brief,ClientID, EmployeeID ,ClearDate ,           '
        +' AccountsID ,Isnull(AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) as AmountD, 0.00 as AmountC , '
        +' AmountRed*Isnull(ModeDC,1)*Isnull(ModeC,1)*(-1) as AmountRed  ,Memo                     '
        +' from FNCashOutMaster                                         '
        +' UNION ALL                                                        '
        +' select date,code,Recordstate,                                '
        +' BillMode,Brief,ClientID, EmployeeID ,ClearDate ,             '
        +' AccountsID , 0.00   as AmountD, 0.00 as AmountC ,            '
        +' Isnull(AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1) as AmountRed  ,Memo                   '
        +' from FNExpenseMaster  ) as a                                 '
        +' left Outer join FNAccounts b on b.Id=a.AccountsID            '
        +' left Outer join MSEmployee c  on c.Id=a.ClientID             '
        +' left Outer join MSEmployee d  on d.Id=a.EmployeeID           '
        +' where a.RecordState<>'+QuotedStr('ɾ��')
        +' and  a.ClientID='+Quotedstr(ClientID)+' and date <= '
        + Quotedstr(DateF) +' Order By Date Desc ' ;
    adsMaster.Open;
    caption :=TbCaption+FCaption;
    TabSheet1.Caption :=TbCaption+FCaption;
    ShowModal;
  end;
end;

procedure TFNReceiptPayLegerEForm.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

end.
