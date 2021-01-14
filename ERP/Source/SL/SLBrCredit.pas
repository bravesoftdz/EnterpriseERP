unit SLBrCredit;
{******************************************
��Ŀ��
ģ�飺�ͻ�������
���ڣ�2002��11��12��
���ߣ��ز�ΰ
���£�
******************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSStandardBrowse, DB, ActnList, Grids, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin, CommonDM, ADODB, WSEdit, Menus;

type
  TSLCreditBrowseForm = class(TWSStandardBrowseForm)
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    adsCredit: TADODataSet;
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
    adsCreditClientName: TStringField;
    adsCreditPeriodName: TStringField;
    adsCreditMemo: TStringField;
    adsCreditClientID: TIntegerField;
    adsCreditQuotaAmountMin: TIntegerField;
    ToolButton5: TToolButton;
  private
    { Private declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  public
    { Public declarations }
  end;

var
  SLCreditBrowseForm: TSLCreditBrowseForm;

implementation

uses SLEdCredit;

{$R *.dfm}
function TSLCreditBrowseForm.CreateEditForm: TWSEditForm;
begin
  Result := TSLCreditEditForm.Create(Application);
end;

end.
