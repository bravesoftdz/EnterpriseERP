unit SLBrGoodsOutB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin, ADODB, Menus;

type
  TSLBrGoodsOutBForm = class(TWSVoucherBrowseForm)
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
    adsSalesMaster: TADODataSet;
    PopupMenu1: TPopupMenu;
    adsSalesMasterDSDesigner: TStringField;
    adsSalesMasterDSDesigner2: TDateTimeField;
    adsSalesMasterDSDesigner3: TStringField;
    adsSalesMasterDSDesigner4: TDateTimeField;
    adsSalesMasterDSDesigner5: TStringField;
    adsSalesMasterDSDesigner6: TStringField;
    adsSalesMasterDSDesigner7: TStringField;
    adsSalesMasterDSDesigner8: TStringField;
    adsSalesMasterDSDesigner9: TStringField;
    adsSalesMasterDSDesigner10: TBCDField;
    adsSalesMasterID: TAutoIncField;
    adsSalesMasterClientID: TIntegerField;
    adsSalesMasterEmployeeID: TIntegerField;
    adsSalesMasterDSDesigner11: TStringField;
    adsSalesMasterRecordState: TStringField;
    ToolButton14: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddNewActionExecute(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  SLBrGoodsOutBForm: TSLBrGoodsOutBForm;

implementation

uses CommonDM,WSSecurity,SLEdGoodsOutB,SLEdGoodsOutBGTP;

{$R *.dfm}

function TSLBrGoodsOutBForm.CreateEditForm: TWSEditForm;
begin
  if Guarder.PackToGoalUnit='��' then
    Result := TSLEdGoodsOutBForm.Create(Self)
  else Result := TSLEdGoodsOutBGTPForm.Create(Self);
end;

procedure TSLBrGoodsOutBForm.FormCreate(Sender: TObject);
begin
  inherited;
  adsSalesMaster.Open;
end;

procedure TSLBrGoodsOutBForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  adsSalesMaster.Close;
end;

procedure TSLBrGoodsOutBForm.AddNewActionExecute(Sender: TObject);
begin
  inherited;
  adsSalesMaster.Requery();
end;

procedure TSLBrGoodsOutBForm.EditActionExecute(Sender: TObject);
begin
  inherited;
  adsSalesMaster.Requery();
end;

end.
