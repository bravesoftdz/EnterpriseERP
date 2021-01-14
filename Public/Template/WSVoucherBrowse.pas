unit WSVoucherBrowse;

{$I DEFINE.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, DB, ActnList, ComCtrls, ToolWin, Grids,
  DBGrids, QLDBGrid, WSEdit, WSVoucherEdit, WSBrowse, ExtCtrls, Menus;

type
  TWSVoucherBrowseForm = class (TWSBrowseForm)
    procedure FormShow(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
    procedure AddNewActionExecute(Sender: TObject);
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

implementation

{$R *.dfm}

{ TWSVoucherBrowseForm }

{
***************************** TWSVoucherBrowseForm *****************************
}
function TWSVoucherBrowseForm.CreateEditForm: TWSEditForm;
begin
  Result := TWSVoucherEditForm.Create(Self);
end;

procedure TWSVoucherBrowseForm.FormShow(Sender: TObject);
var  I: Integer;
begin
  inherited;
  with DBGrid do
  begin
    FooterRowCount := 0;
    Columns[0].Footer.ValueType := fvtStaticText;
    Columns[0].Footer.Value := '�ϼ�:';
    Columns[0].Footer.Alignment := taCenter;
    Columns[0].Title.Alignment:= taCenter;
    for I := 1 to Columns.Count - 1 do
      if Columns[I].Field is TNumericField then
      if (Pos('Price',Columns[I].FieldName)<=0)
          and (Pos('����',Columns[I].FieldName)<=0)  then
        Columns[I].Footer.ValueType := fvtSum;
    FooterRowCount := 1;
  end;
end;

procedure TWSVoucherBrowseForm.EditActionExecute(Sender: TObject);
begin
{$IFDEF TRIAL}
  if DataSet.RecordCount > 119 then
  begin
    MessageDlg('����Ʒδ����Ȩ�����ݿⲻ�ܱ������ļ�¼����鿴���ڡ�', mtError, [mbOK], 0);
    Abort;
  end;
{$ENDIF}
  inherited;
end;

procedure TWSVoucherBrowseForm.AddNewActionExecute(Sender: TObject);
begin
{$IFDEF TRIAL}
  if DataSet.RecordCount > 119 then
  begin
    MessageDlg('����Ʒδ����Ȩ�����ݿⲻ�ܱ������ļ�¼����鿴���ڡ�', mtError, [mbOK], 0);
    Abort;
  end;
{$ENDIF}
  inherited;
end;

end.

