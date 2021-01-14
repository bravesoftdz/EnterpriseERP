unit FNBrClearSL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin, ADODB, Menus;

type
  TFNBrClearSLForm = class(TWSVoucherBrowseForm)
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    adsSLBrClearBill: TADODataSet;
    adsSLBrClearBillid: TAutoIncField;
    adsSLBrClearBillDSDesigner: TDateTimeField;
    adsSLBrClearBillDSDesigner2: TStringField;
    adsSLBrClearBillDSDesigner3: TStringField;
    adsSLBrClearBillDSDesigner8: TStringField;
    adsSLBrClearBillDSDesigner9: TStringField;
    adsSLBrClearBillDSDesigner10: TStringField;
    adsSLBrClearBillDSDesigner4: TStringField;
    adsSLBrClearBillDSDesigner7: TStringField;
    adsSLBrClearBillDSDesigner5: TBCDField;
    adsSLBrClearBillClientID: TIntegerField;
    adsSLBrClearBillEmployeeID: TIntegerField;
    adsSLBrClearBillDSDesigner12: TStringField;
    adsSLBrClearBillDSDesigner6: TBCDField;
    adsSLBrClearBillRecordState: TStringField;
    WakeTimer: TTimer;
    AdsTimer: TADODataSet;
    StringField1: TStringField;
    DateTimeField1: TDateTimeField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    BCDField1: TBCDField;
    BCDField2: TBCDField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    AutoIncField1: TAutoIncField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    StringField9: TStringField;
    ToolButton14: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddNewActionExecute(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
    procedure WakeTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  FNBrClearSLForm: TFNBrClearSLForm;

implementation

uses CommonDM,FNEdClearSL,VoucherQuery,FNEdClearSLFRG,WSSecurity;

{$R *.dfm}

function TFNBrClearSLForm.CreateEditForm: TWSEditForm;
begin
  if Guarder.ForeignCurrencyFlag='��' then
     Result := TFNEdClearSLFRGForm.Create(Self)
    else Result := TFNEdClearSLForm.Create(Self);
//  Result := TFNEdClearSLForm.Create(Self);
end;

procedure TFNBrClearSLForm.FormCreate(Sender: TObject);
begin
  inherited;
  adsSLBrClearBill.Close;
  adsSLBrClearBill.Open;
  WakeTimer.Enabled :=true;
end;

procedure TFNBrClearSLForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  adsSLBrClearBill.close;
end;

procedure TFNBrClearSLForm.AddNewActionExecute(Sender: TObject);
begin
  inherited;
  adsSLBrClearBill.Requery();
end;

procedure TFNBrClearSLForm.EditActionExecute(Sender: TObject);
begin
  inherited;
  adsSLBrClearBill.Requery();
end;



procedure TFNBrClearSLForm.WakeTimerTimer(Sender: TObject);
var datestr,datestr1 :string;
begin
  inherited;
  DateStr :=Datetostr(Date);
  DateStr1 :=Datetostr(Date+15);
  WakeTimer.Enabled :=false;
  ShowQueryForm('�����µ���Ӧ�տ�����......','����Ӧ�տ�����',
    ' select * from ( select '
    +' a.Code as [���], a.Date [����], a.BillMode [ҵ�����],  '
    +' isnull(a.ClearDate,a.Date) [��������], a.Apportion [��̯Ҫ��], '
    +' a.Deliver [�ͻ�Ҫ��], a.Memo [��ע],b.name as [�ͻ�����] '
    +' ,c.name as [������], A.SundryFee*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1)  as [���ӷ���] , '
    +' ttl.Amount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [���] , '
    +' ttl.Discount*Isnull(a.ModeDC,1)*Isnull(a.ModeC,1) as [�ۿ۽��], '
    +' a.Recordstate as [ƾ��״̬]       '
    +' from SLSaleMaster a               '
    +' left outer join  DAClient b on b. ID=a.ClientID '
    +' left outer join  MSEmployee  c on c.id=a. EmployeeID '
    +' left outer join                                       '
    +' (select masterID, (sum(isnull(Amount,0))+Sum(Isnull(TaxAmount,0))+ '
    +' Sum(Isnull(SundryFee,0))) as Amount ,sum(isnull(Discount,0)) as '
    +' Discount from SLSaleDetail group by masterId  ) as ttl '
    +' on ttl.masterID=a.id '
    +' WHERE  A.RECORDSTATE<>'+Quotedstr('ɾ��')
    +' and a.BillMode not like ' + Quotedstr('%�ֿ�%')
    +' ) as a '
    +'where a.[��������]>= '
    +Quotedstr(Datestr) +' and a.[��������]<='+ Quotedstr(Datestr1)
    +' order by a.[����] DESC ' );
end;

end.
