{ �� DataModule ֻ���ڷ��ñ���Ŀ���õ������������ Lookup Ŀ�� DataSet �� ImageList,
�������ھֲ�ģ��������Ҫ�������� }

unit CommonDM;

interface

uses
  SysUtils, Classes, DB, ADODB, DBClient, Provider, Dialogs, QLDBFlt,
  ImgList, Controls, Forms;
                                      
type
  TCommonData = class(TDataModule)
    acnConnection: TADOConnection;
    ilVoucherSmall: TImageList;
    ilToolBtn: TImageList;
    adsDAGoods: TADODataSet;
    adsDASalesClient: TADODataSet;
    adsDAArea: TADODataSet;
    adsDAPurchaseClient: TADODataSet;
    adsMSEmployee: TADODataSet;
    adsMSDepartment: TADODataSet;
    adsMSCurrency: TADODataSet;
    adsMSPosition: TADODataSet;
    adsSTWarehouse: TADODataSet;
    adsDABillType: TADODataSet;
    adsDAClient: TADODataSet;
    adsBaseUnits: TADODataSet;
    adsMSUnit: TADODataSet;
    ADOQuery: TADOQuery;
    adsDASubject: TADODataSet;
    adsDASubjectID: TIntegerField;
    adsDASubjectSubCode: TStringField;
    adsDASubjectSubTypeID: TIntegerField;
    adsDASubjectName: TStringField;
    adsDASubjectDebitCredit: TStringField;
    procedure acnConnectionBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommonData: TCommonData;

implementation

{$R *.dfm}  

procedure TCommonData.acnConnectionBeforeConnect(Sender: TObject);
var
  FileName: string;
begin
  // ȡ���������ļ�
  FileName := ChangeFileExt(ExtractFileName(Application.ExeName), '.UDL');
  if FileExists(FileName) then
    acnConnection.ConnectionString := 'FILE NAME=' + FileName
    else
      acnConnection.ConnectionString := 'FILE NAME=Soft.UDL';
//  showmessage( acnConnection.ConnectionString);
end;

procedure TCommonData.DataModuleCreate(Sender: TObject);
var StrDir :string;
begin
  if 1=2 then
  begin
    StrDir := GetCurrentDir;
//    Memo1.Text :=  '���ڰ�װ���ݿ⣬��Ⱥ�......';
//    Memo1.Repaint;
    if not DirectoryExists(StrDir+'\data') then
      if not CreateDir(StrDir+'\data') then
      raise Exception.Create('���ܴ������ݿ��ļ�Ŀ¼');
    ADOQuery.Close;
    ADOQuery.SQL.Text :=' RESTORE DATABASE  Soft '
      +'FROM DISK ='+Quotedstr(StrDir+'\Soft.bak')+' WITH  replace , '
      +' MOVE '+Quotedstr('Soft_Data')+' TO '
      + Quotedstr(StrDir+'\data\Soft.mdf ')
      +' , MOVE '+Quotedstr('Soft_Log')+' TO '
      + Quotedstr(StrDir+'\data\Soft_log.ldf');
    ADOQuery.ExecSQL;
  end; 
//  showmessage( '���ݿⰲװ���!');//
end;

initialization
  CurrencyString := '';

end.

