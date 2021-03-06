unit YDBrProductFormula;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin, ADODB, WSEdit;

type
  TYDProductFormulaBrowseForm = class(TWSVoucherBrowseForm)
    adsYDProductFormula: TADODataSet;
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
    adsYDProductFormulaID: TAutoIncField;
    adsYDProductFormulaCreateDate: TDateTimeField;
    adsYDProductFormulaCreateUserID: TIntegerField;
    adsYDProductFormulaRecordState: TStringField;
    adsYDProductFormulaDate: TDateTimeField;
    adsYDProductFormulaCode: TStringField;
    adsYDProductFormulaFormulaClass: TStringField;
    adsYDProductFormulaBrief: TStringField;
    adsYDProductFormulaMemo: TMemoField;
    procedure AddNewActionExecute(Sender: TObject);
    procedure DeleteActionExecute(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
  private
    { Private declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  public
    { Public declarations }
  end;

var
  YDProductFormulaBrowseForm: TYDProductFormulaBrowseForm;

implementation

uses CommonDM, YDEdProductFormula;

{$R *.dfm}

function TYDProductFormulaBrowseForm.CreateEditForm: TWSEditForm;
begin
  Result := TYDProductFormulaEditForm.Create(Application);
end;

procedure TYDProductFormulaBrowseForm.AddNewActionExecute(Sender: TObject);
begin
  inherited;
  adsYDProductFormula.Requery();
end;

procedure TYDProductFormulaBrowseForm.DeleteActionExecute(Sender: TObject);
begin
  inherited;
  adsYDProductFormula.Requery();
end;

procedure TYDProductFormulaBrowseForm.EditActionExecute(Sender: TObject);
begin
  inherited;
  adsYDProductFormula.Requery();
end;

end.
 