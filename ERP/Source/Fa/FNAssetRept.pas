unit FNAssetRept;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSVoucherBrowse, DB, ActnList, Grids,WSEdit, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin,DateUtils, ADODB, StdCtrls, Buttons, Menus;

type
  TFNAssetReptFrom = class(TWSVoucherBrowseForm)
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
    Panel2: TPanel;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    ADOQuery: TADOQuery;
    adsMasterID: TAutoIncField;
    adsMasterDSDesigner: TStringField;
    adsMasterDSDesigner2: TStringField;
    adsMasterDSDesigner3: TStringField;
    adsMasterDSDesigner4: TStringField;
    adsMasterDSDesigner5: TStringField;
    adsMasterDSDesigner6: TBCDField;
    adsMasterDSDesigner7: TBCDField;
    adsMasterDSDesigner8: TBCDField;
    adsMasterDSDesigner9: TBCDField;
    adsMasterDSDesigner10: TBCDField;
    ToolButton1: TToolButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure UpdateDBGrid;
    procedure DBGridDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridTitleClick(Column: TColumn);

  private
    { Private declarations }
  public
     DateStr:string;
    { Public declarations }
  protected
    function CreateEditForm: TWSEditForm; override;
  end;

var
  FNAssetReptFrom: TFNAssetReptFrom;

implementation

uses CommonDM ;

{$R *.dfm}

function TFNAssetReptFrom.CreateEditForm: TWSEditForm;
begin
//  Result := TSLEdClearBillAForm.Create(Self);
end;


procedure TFNAssetReptFrom.BitBtn1Click(Sender: TObject);
var year,month,day :word;
begin
  DecodeDate(DateTimePicker1.Date,year, month, day);
  DateStr :=Datetostr(DateTimePicker1.Date);
  adsMaster.Close;
  adsMaster.CommandText :=' select b.ID, b.Code [�ʲ����], '
    +' b.brief [�ʲ�����], c.name as [��������], '
    +' d.name  [�����ʲ�],a.GoodsSpec [����ͺ�],   '
    +' a.Amount [ԭֵ],a.GoalQuantity [Ԥ�Ʋ�ֵ],     '
    +' a.SundryFee [�۾���],e.DepAmount [�۾ɽ��],   '
    +' (a.Amount-e.DepAmount) as  [�ʲ���ֵ]          '
    +' from FAAssetAddDetail a                        '
    +' left outer join FAAssetAddMaster b on b.ID=a.MasterID  '
    +' left outer join MSDepartment c on c.ID=b.ClientID      '
    +' left outer join DAGoods d on d.ID=a.GoodsID  '
    +' left outer join                                        '
    +' ( select GoodsID,PackUnitID,sum(isnull(Amount,0)) as DepAmount  '
    +' from FADepreciationDetail a                                     '
    +' left outer join FADepreciationMaster b on b.ID=a.MasterID       '
    +' where b.Recordstate<>'+Quotedstr('ɾ��')
    +' group by GoodsID,PackUnitID )   e on e.PackUnitID=b.ID  '
    +' where a.GoodsID<>0 and b.Recordstate<>'+Quotedstr('ɾ��');
  adsMaster.Open;
  UpdateDBGrid;
end;

procedure TFNAssetReptFrom.FormCreate(Sender: TObject);
begin
  inherited;
  DateTimePicker1.Date :=date;
end;


procedure TFNAssetReptFrom.DBGridCellClick(Column: TColumn);
begin
//  UpdateDBGrid;
end;

procedure TFNAssetReptFrom.UpdateDBGrid;
var  I: Integer;
begin
  with DBGrid do
  begin
    FooterRowCount := 0;
    Columns[0].Footer.ValueType := fvtStaticText;
    Columns[0].Footer.Value := '�ϼ�:';
    Columns[0].Footer.Alignment := taCenter;
    Columns[0].Title.Alignment:= taCenter;
//    Columns[0].Width :=150;
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

procedure TFNAssetReptFrom.DBGridDblClick(Sender: TObject);
var E:string;
begin
  {if adsMaster.IsEmpty then exit;
  if adsMaster.FieldByName('Balance').AsFloat >0 then
    E :='1' else E :='-1'    ;
   FNReceiptPayLegerForm.ShowForm(adsMaster.FieldByName('client').AsString,
      '�ʲ���ϸ��--', adsMaster.FieldByName('clientId').AsString,Datestr,E);
                      }
end;

procedure TFNAssetReptFrom.FormShow(Sender: TObject);
begin
  inherited;
  
  BitBtn1Click(sender);
end;

procedure TFNAssetReptFrom.DBGridTitleClick(Column: TColumn);
begin
  inherited;
  UpdateDBGrid;
end;

end.
