{ �� DataModule ֻ���ڷ��ñ���Ŀ���õ������������ Lookup Ŀ�� DataSet �� ImageList,
�������ھֲ�ģ��������Ҫ�������� }

unit CommonDM;

interface

uses
  SysUtils, Classes, DB, ADODB, DBClient, Provider, Dialogs, QLDBFlt,
  ImgList, Controls;

type
  TCommonData = class(TDataModule)
    acnConnection: TADOConnection;
    ilVoucherSmall: TImageList;
    ilToolBtn: TImageList;
    aqrTemp: TADOQuery;
    adsTemp: TADODataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommonData: TCommonData;

implementation

{$R *.dfm}  

end.

