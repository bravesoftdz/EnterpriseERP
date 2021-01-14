unit MSBrPostionClass;
{******************************************
��Ŀ��
ģ�飺ְλ��� ����
���ڣ�2002��11��8��
���ߣ��ز�ΰ
���£�
******************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSTreeView, DB, ActnList, ToolWin, ComCtrls, ADODB,WSEdit, Menus;

type
  TMSPostionClassBrowseForm= class(TWSTreeViewForm)
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    tblMSPostioClass: TADOTable;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  public
    { Public declarations }
  end;

var
  MSPostionClassBrowseForm: TMSPostionClassBrowseForm;

implementation

uses CommonDM,MSEdPostionClass;

{$R *.dfm}
function TMSPostionClassBrowseForm.CreateEditForm: TWSEditForm;
begin
  Result := TMSPostionClassEditForm.Create(Application);
end;

procedure TMSPostionClassBrowseForm.FormCreate(Sender: TObject);
var
  aqrTemp: TADOQuery;
begin
  aqrTemp := TADOQuery.Create(nil);
  with aqrTemp do
  begin
    Connection := CommonData.acnConnection;
    Close;
    sql.Text := ' select top 1 * from MSPostionClass where '
      +' RecordState<>' +QuotedStr('ɾ��');
    open;
    if aqrTemp.IsEmpty then
    begin
      aqrTemp.Close;
      aqrTemp.sql.Text := ' Insert Into MSPostionClass (code,CreateUserID,'
      +' Upid , Name) '
        +' Values ( 0,1,-1,'+QuotedStr('ְ����')+' )';
      aqrTemp.ExecSQL;
    end;
  end;
  inherited;

end;

end.
