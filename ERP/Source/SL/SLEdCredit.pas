unit SLEdCredit;
{******************************************
��Ŀ��
ģ�飺�ͻ����ñ༭
���ڣ�2002��11��12 
���ߣ��ز�ΰ
���£�
******************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSStandardEdit, StdCtrls, ExtCtrls, ComCtrls, DB, ADODB, CommonDM,
  DBCtrls, Mask;

type
  TSLCreditEditForm = class(TWSStandardEditForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    adrDiscount: TADOQuery;
    dbcbClient: TDBLookupComboBox;
    dsClient: TDataSource;
    dsPeriod: TDataSource;
    adsPeriod: TADODataSet;
    edtCode: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    edtCreditClass: TDBEdit;
    edtQuotaAmount: TDBEdit;
    Label8: TLabel;
    edtDiscountRateMax: TDBEdit;
    Label9: TLabel;
    Label10: TLabel;
    edtDiscountRateMin: TDBEdit;
    dtpStartDate: TDBEdit;
    dtpExpireDate: TDBEdit;
    memMeno: TDBMemo;
    adsCredit: TADODataSet;
    dsCredit: TDataSource;
    dbcbPeriod: TDBLookupComboBox;
    adsPeriodID: TAutoIncField;
    adsPeriodCreateDate: TDateTimeField;
    adsPeriodCreateUserID: TIntegerField;
    adsPeriodRecordState: TStringField;
    adsPeriodName: TStringField;
    adsPeriodStartDate: TDateTimeField;
    adsPeriodCloseDate: TDateTimeField;
    adsPeriodIsClosed: TStringField;
    adsPeriodLastCloseDate: TDateTimeField;
    adsPeriodCheckFlag: TIntegerField;
    adsPeriodEmployeID: TIntegerField;
    adsCreditID: TAutoIncField;
    adsCreditCreateDate: TDateTimeField;
    adsCreditCreateUserID: TIntegerField;
    adsCreditRecordState: TStringField;
    adsCreditDate: TDateTimeField;
    adsCreditCode: TStringField;
    adsCreditCreditClass: TStringField;
    adsCreditQuotaAmount: TBCDField;
    adsCreditQuotaAmountMax: TBCDField;
    adsCreditStartDate: TDateTimeField;
    adsCreditExpireDate: TDateTimeField;
    adsCreditPeriodID: TIntegerField;
    DBEdit1: TDBEdit;
    Label11: TLabel;
    adsCreditMemo: TStringField;
    adsCreditClientID: TIntegerField;
    adsCreditQuotaAmountMin: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    nOptionType: integer; //�������ͣ�0:���� 1:�༭��
    vID:string;
    { Private declarations }
  public
    { Public declarations }
    function Enter: Boolean; override;
    function Edit(const Params: Variant): Boolean; override;
  end;

var
  SLCreditEditForm: TSLCreditEditForm;

implementation

{$R *.dfm}
function TSLCreditEditForm.Edit(const Params: Variant): Boolean;
begin
  vID := Format('%s', [VarToStr(Params)]);
  nOptionType:=1;
  adsPeriod.Active := True;
  with adsCredit do
  begin
    Active := True;
    Locate('id',vID,[]);
  end;
  Result := ShowModal = mrOK;
end;

function TSLCreditEditForm.Enter: Boolean;
begin
  nOptionType := 0;
  adsPeriod.Active := True;
  with adsCredit do
  begin
    Active := True;
    Append;

    FieldByName('Date').AsDateTime := Date;
    FieldByName('StartDate').AsDateTime := Date;
    FieldByName('ExpireDate').AsDateTime := Date;
  end;
  Result := ShowModal = mrOK;
end;

procedure TSLCreditEditForm.FormCreate(Sender: TObject);
begin
  inherited;
  CommonData.adsDAClient.Active := True;
end;

procedure TSLCreditEditForm.OKButtonClick(Sender: TObject);
begin
  inherited;
  with adsCredit do
  begin
    Edit;
    FieldByName('CreateUserID').AsInteger := 0;
    FieldByName('Date').AsDateTime := Date;
    Post;
  end;
  ModalResult := mrOK;
end;

end.
