unit DABillType;
{******************************************
��Ŀ��
ģ�飺��������
���ڣ�2002��11��11��
���ߣ��ز�ΰ
���£�
******************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSStandardEdit, StdCtrls, Grids, DBGrids, QLDBGrid,CommonDM, DB,
  ADODB;

type
  TDABillTypeForm = class(TWSStandardEditForm)
    qdgDABillType: TQLDBGrid;
    dsDABillType: TDataSource;
    btnAdd: TButton;
    btnDelete: TButton;
    procedure FormCreate(Sender: TObject);
    procedure qdgPermissionClassExit(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DABillTypeDlg: Boolean;

implementation

{$R *.dfm}
function DABillTypeDlg: Boolean;
begin
  Result := False;
  with TDABillTypeForm.Create(Application) do
  try
    if ShowModal = mrOK then
    begin
      Result := True;
    end;
  finally
    Free;
  end;
end;

procedure TDABillTypeForm.FormCreate(Sender: TObject);
begin
  inherited;
  CommonData.adsDABillType.Active:=True;
end;

procedure TDABillTypeForm.qdgPermissionClassExit(Sender: TObject);
begin
  inherited;
  with CommonData.adsDABillType do
  begin
    edit;
    post;
  end;
end;

procedure TDABillTypeForm.btnAddClick(Sender: TObject);
begin
  inherited;
  CommonData.adsDABillType.Append;
  qdgDABillType.SetFocus;
end;

procedure TDABillTypeForm.btnDeleteClick(Sender: TObject);
begin
  inherited;
  if MessageBox(handle,'ȷʵҪɾ��������','ɾ��ȷ��',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=ID_YES then
  begin
    if CommonData.adsDABillType.RecordCount>0 then
      CommonData.adsDABillType.Delete
    else
      showmessage('û�����ݿ�ɾ��...');
  end;
end;

end.
