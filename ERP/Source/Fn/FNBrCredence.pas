unit FNBrCredence;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WSBrowse, Menus, DB, ActnList, Grids, DBGrids, QLDBGrid,
  ComCtrls, ExtCtrls, ToolWin, ADODB, WSEdit, WSStandardBrowse, StdCtrls;

type
  TFNCredenceBrowseForm = class(TWSStandardBrowseForm)
    adsCredence: TADODataSet;
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
    adsCredenceID: TAutoIncField;
    adsCredenceCreateDate: TDateTimeField;
    adsCredenceCreateUserID: TIntegerField;
    adsCredenceRecordState: TStringField;
    adsCredenceDSDesigner: TStringField;
    adsCredenceDSDesigner2: TDateTimeField;
    adsCredenceDSDesigner3: TStringField;
    adsCredenceDSDesigner4: TBCDField;
    adsCredenceDSDesigner5: TBCDField;
    adsCredenceDSDesigner6: TStringField;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    VourchTranIniADS: TADODataSet;
    VouchTranTemp: TADOQuery;
    TranVchPanel: TPanel;
    ToolButton16: TToolButton;
    procedure AddNewActionExecute(Sender: TObject);
    procedure EditActionExecute(Sender: TObject);
    procedure DeleteActionExecute(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure DoingCase;
    procedure DoingCase0;
    procedure DoingCase1;
    procedure DoingCase2;
    procedure DoingCase3;
    procedure DoingCase4;
    procedure DoingCase5;
    procedure DoingCase6;
    procedure DoingCase7;
    procedure DoingCase8;
    procedure DoingCase9;
    procedure DoingCaseA;
    procedure DoingCaseB;
    procedure DoingCaseC;
    procedure DoingCaseD;

    procedure ToolButton6Click(Sender: TObject);
  private
    NewVoucherCode,NewVoucherID :string;
    AmountA,AmountB :real;
    FEndDate: TDate;
  protected
    function CreateEditForm: TWSEditForm; override;
  public
    { Public declarations }
  end;

implementation

uses FNEdCredence, CommonDM,WSUtils,WSSecurity, FNVouchTranIni, DatePick;

{$R *.dfm}

{ TFNCredenceBrowseForm }

function TFNCredenceBrowseForm.CreateEditForm: TWSEditForm;
begin
  Result := TFNCredenceEditForm.Create(Application);
end;

procedure TFNCredenceBrowseForm.AddNewActionExecute(Sender: TObject);
begin
  inherited;
  adsCredence.Requery()  ;
end;

procedure TFNCredenceBrowseForm.EditActionExecute(Sender: TObject);
begin
  inherited;
  adsCredence.Requery()  ;

end;

procedure TFNCredenceBrowseForm.DeleteActionExecute(Sender: TObject);
begin
  inherited;
  adsCredence.Requery()  ;
end;

procedure TFNCredenceBrowseForm.ToolButton5Click(Sender: TObject);
begin
  FEndDate := Date;
  if PickDateDlg('ѡ���������:', FEndDate) then
  begin
    TranVchPanel.Visible :=True;
    TranVchPanel.Repaint;
    CommonData.acnConnection.Execute('EXECUTE sp_FNSyncAllSubject');
    VourchTranIniADS.Close;
    VourchTranIniADS.CommandText :='select top 13 * from FNVourchTranIni';
    VourchTranIniADS.Open;
    VourchTranIniADS.First;
    while not VourchTranIniADS.eof do
    begin
      DoingCase;
      VourchTranIniADS.Next;
    end;
    TranVchPanel.Visible :=False;
    adsCredence.Requery()  ;
  end;
end;

procedure TFNCredenceBrowseForm.DoingCase;
begin
  case VourchTranIniADS.FieldByName('VouchTranNo').AsInteger of
    0: DoingCase0;//ת�����ۿ���
    1: DoingCase1;// ת���ɹ�����
    2: DoingCase2; //ת���տ�����
    3: DoingCase3; //ת���������
    4: DoingCase4; //ת���տ�����
    5: DoingCase5; // ת����������
    6: DoingCase6; //���ñ���
    7: DoingCase7;// �ʽ����
    8: DoingCase8;// ��Ҷһ�
    9: DoingCase9;// �ɹ��ɱ�����
    10: DoingCaseA;// ���ϳɱ�����
    11:DoingCaseB;// �����ɱ�����
    12:DoingCaseC;// �ⷢ�ӹ��ɱ�����
    13:DoingCaseD;// ���۳ɱ�����
  end;
end;

procedure TFNCredenceBrowseForm.DoingCase0;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
//ת�����ۿ���
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from SLSaleMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')+' and '
    +'ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('SLSaleMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));
  VouchTranTemp.Open;
  if VouchTranTemp.IsEmpty then exit;

  VouchTranTemp.Close;  //����ת�����
  VouchTranTemp.SQL.Text :=' select sum(isnull(AmountA,0)) as AmountA  ,'
    +' sum(isnull(AmountB,0)) as AmountB  from ( select  '
    +' sum(isnull(a.Amount,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) as AmountA  ,    '
    +' sum(0.00)  as AmountB      '
    +' from SLSaleDetail a                                     '
    +' left outer join SLSaleMaster   b on a.MasterID=b.ID       '
    +' where b.RecordState<>'+Quotedstr('ɾ��')
    +' and b.RecordState<>'+ Quotedstr('����')
    +' and b.date<='
    +Quotedstr(DateToStr(FEndDate))+' and b.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('SLSaleMaster')+' )'
    +' union all '
    +' select '
    +' 0.00 as AmountA  ,    '
    +' sum(isnull(a.SundryFee,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) as AmountB      '
    +' from SLSaleMaster a                                     '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('SLSaleMaster')+' ) ) as a ' ;
  VouchTranTemp.Open;//����ת�����
  AmountA := VouchTranTemp.FieldByName('AmountA').AsFloat ;
  AmountB := VouchTranTemp.FieldByName('AmountB').AsFloat ;

  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('���ۿ����Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);
  VouchTranTemp.Close;  //�����ӱ�跽���---
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select  MasterID ,GoodsID, sum(isnull(PriceBase,0)) as PriceBase ,'
    +' GoalUnitID,OriginTable,memo  from ( '
    +' select '+NewVoucherID+' as MasterID ,'
    +' e.ID as GoodsID, '
    +' (sum(isnull(a.Amount,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) )                  '
    +' as PriceBase, b.ID  as GoalUnitID,               '
    +Quotedstr('SLSaleMaster')+' as OriginTable , ( '
    +Quotedstr('���۵���:')+' +b.code) as Memo '
    +' from SLSaleDetail  a                                     '
    +' left outer join SLSaleMaster b on b.ID=a.MasterID       '
    +' left outer join DaClient c on c.ID=b.ClientID           '
    +' left outer join DASubject d on d.ID=c.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAClient')+ ' and        '
    +'   e.RelativeID=b.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where b.RecordState<>'+Quotedstr('ɾ��')
    +' and b.RecordState<>'+ Quotedstr('����')
    +' and b.date<='
    +Quotedstr(DateToStr(FEndDate))+' and b.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('SLSaleMaster')+' )'
    +' group by b.ID,e.ID, b.Code  '
    +' union all '
    +' select '+NewVoucherID+' as MasterID ,'
    +' e.ID as GoodsID, '
    +' (sum(isnull(a.SundryFee,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)))        '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('SLSaleMaster')+' as OriginTable , ( '
    +Quotedstr('���۵���:')+' +a.code) as Memo '
    +' from SLSaleMaster  a                                     '
    +' left outer join DaClient c on c.ID=a.ClientID           '
    +' left outer join DASubject d on d.ID=c.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAClient')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('SLSaleMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ) as a '
    +' Group by a.MasterID , a.GoodsID, a.GoalUnitID,a.OriginTable,a.memo ';
//  Memo1.Text := VouchTranTemp.SQL.Text;
  VouchTranTemp.ExecSQL; //�����ӱ�跽���---

  if AmountA<>0 then
  begin
    VouchTranTemp.Close;  //�����ӱ�������====
    VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
      +' MasterID,GoodsID, PriceCost,GoodsSpec )'
      +' Values ( '+NewVoucherID+'   ,'
      + Inttostr(VourchTranIniADS.FieldByName('AccountFID').AsInteger)
      +' , ' + Floattostr(AmountA)+' , '
      +Quotedstr('��������')+' ) ';
    VouchTranTemp.ExecSQL; //�����ӱ������� ====
  end;
  if AmountB<>0 then
  begin
    VouchTranTemp.Close;  //�����ӱ�������****
    VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
      +' MasterID,GoodsID, PriceCost,GoodsSpec,Memo)'
      +' Values ( '+NewVoucherID + ' ,'
      + Inttostr(VourchTranIniADS.FieldByName('AccountGID').AsInteger)
      + ' , '   + Floattostr(AmountB)+' , '
      +Quotedstr('���ܸ��ӷ���')+' , '
      +Quotedstr('���ӷ���')+' ) ';
    VouchTranTemp.ExecSQL; //�����ӱ�������****
  end;
end;

procedure TFNCredenceBrowseForm.DoingCase1;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// ת���ɹ�����
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from PCPurchaseMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')+' and '
    +'ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('PCPurchaseMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));

  VouchTranTemp.Open;
  if VouchTranTemp.IsEmpty then exit;

  VouchTranTemp.Close;  //����ת�����
  VouchTranTemp.SQL.Text :=' select sum(isnull(AmountA,0)) as AmountA  ,'
    +' sum(isnull(AmountB,0)) as AmountB  from ( select  '
    +' sum(isnull(a.Amount,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) as AmountA  ,    '
    +' sum(0.00)  as AmountB      '
    +' from PCPurchaseDetail a                                     '
    +' left outer join PCPurchaseMaster   b on a.MasterID=b.ID       '
    +' where b.RecordState<>'+Quotedstr('ɾ��')
    +' and b.RecordState<>'+ Quotedstr('����')
    +' and b.date<='
    +Quotedstr(DateToStr(FEndDate))+' and b.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('PCPurchaseMaster')+' )'
    +' union all '
    +' select '
    +' 0.00 as AmountA  ,    '
    +' sum(isnull(a.SundryFee,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) as AmountB      '
    +' from PCPurchaseMaster a                                     '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('PCPurchaseMaster')+' ) ) as a ' ;
  VouchTranTemp.Open;//����ת�����
  AmountA := VouchTranTemp.FieldByName('AmountA').AsFloat ;
  AmountB := VouchTranTemp.FieldByName('AmountB').AsFloat ;

  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('�ɹ������Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);
  VouchTranTemp.Close;  //�����ӱ�������---
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec )'
    +' select  MasterID ,GoodsID, sum(isnull(PriceBase,0)) as PriceBase ,'
    +' GoalUnitID,OriginTable,memo  from ( '

    +' select '+NewVoucherID+' as MasterID ,'
    +' e.ID as GoodsID, '
    +' (sum(isnull(a.Amount,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) )                  '
    +' as PriceBase, b.ID  as GoalUnitID,               '
    +Quotedstr('PCPurchaseMaster')+' as OriginTable , ( '
    +Quotedstr('�ɹ�����:')+' +b.code) as Memo '
    +' from PCPurchaseDetail  a                                     '
    +' left outer join PCPurchaseMaster b on b.ID=a.MasterID       '
    +' left outer join DaClient c on c.ID=b.ClientID           '
    +' left outer join DASubject d on d.ID=c.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAClient')+ ' and        '
    +'   e.RelativeID=b.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where b.RecordState<>'+Quotedstr('ɾ��')
    +' and b.RecordState<>'+ Quotedstr('����')
    +' and b.date<='
    +Quotedstr(DateToStr(FEndDate))+' and b.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('PCPurchaseMaster')+' )'
    +' group by b.ID,e.ID, b.Code  '

    +' union all '
    +' select '+NewVoucherID+' as MasterID ,'
    +' e.ID as GoodsID, '
    +' (sum(isnull(a.SundryFee,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)))        '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('PCPurchaseMaster')+' as OriginTable , ( '
    +Quotedstr('�ɹ�����:')+' +a.code) as Memo '
    +' from PCPurchaseMaster  a                                     '
    +' left outer join DaClient c on c.ID=a.ClientID           '
    +' left outer join DASubject d on d.ID=c.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAClient')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('PCPurchaseMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ) as a '
    +' Group by a.MasterID , a.GoodsID, a.GoalUnitID,a.OriginTable,a.memo ';
//  Memo1.Text := VouchTranTemp.SQL.Text;
  VouchTranTemp.ExecSQL; //�����ӱ�������---

  if AmountA<>0 then
  begin
    VouchTranTemp.Close;  //�����ӱ�跽���====
    VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
      +' MasterID,GoodsID, PriceBase,GoodsSpec )'
      +' Values ( '+NewVoucherID+'   ,'
      + Inttostr(VourchTranIniADS.FieldByName('AccountFID').AsInteger)
      +' , ' + Floattostr(AmountA)+' , '
      +Quotedstr('���ܲɹ�')+' ) ';
    VouchTranTemp.ExecSQL; //�����ӱ�跽��� ====
  end;
  if AmountB<>0 then
  begin
    VouchTranTemp.Close;  //�����ӱ�跽���****
    VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
      +' MasterID,GoodsID, PriceBase,GoodsSpec,Memo )'
      +' Values ( '+NewVoucherID + ' ,'
      + Inttostr(VourchTranIniADS.FieldByName('AccountGID').AsInteger)
      + ' , '   + Floattostr(AmountB)+' , '
      +Quotedstr('���ܸ��ӷ���')+' , '
      +Quotedstr('���ӷ���')+' ) ';
    VouchTranTemp.ExecSQL; //�����ӱ�跽���****
  end;
end;

procedure TFNCredenceBrowseForm.DoingCase2;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// ת���տ����
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNClearSLMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')
    +' and ( isnull(AmountD,0)+isnull(AmountRed,0) )<>0 and  '
    +' ID not in ( select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('FNClearSLMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));

  VouchTranTemp.Open;

  if VouchTranTemp.IsEmpty then exit;
  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('�տ�����Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ

  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);

  VouchTranTemp.Close;  //�����ӱ�跽���---���տ��ʻ���
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('FNClearSLMaster')+' as OriginTable , ( '
    +Quotedstr('�տ����:')+' +a.code) as Memo '
    +' from FNClearSLMaster a                                     '
    +' left outer join FNAccounts  b on b.ID=a.AccountsID       '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('FNAccounts')+ ' and        '
    +'   e.RelativeID=a.AccountsID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountD,0)<>0 and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearSLMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�跽���---

  VouchTranTemp.Close;  //�����ӱ�跽���===(�ۿ۳���)
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec,Memo )'
    +' select '+NewVoucherID+' as MasterID , '
    + Inttostr(VourchTranIniADS.FieldByName('AccountFID').AsInteger)
    + 'as GoodsID, '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('FNClearSLMaster_1')+' as OriginTable , ( '
    +Quotedstr('�տ����:')+' +a.code) as GoodsSpec, '
    +Quotedstr('�ۿ۳���')+' as Memo '
    +' from FNClearSLMaster a                                     '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountRed,0)<>0 and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearSLMaster_1')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearSLMaster')+' )'
    +' group by a.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�跽���===

  VouchTranTemp.Close;  //�����ӱ�������===��Ӧ���ʿ
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    + ' e.ID as GoodsID, '
    +' ( sum(isnull(a.AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))    +        '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) )           '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNClearSLMaster_2')+' as OriginTable , ( '
    +Quotedstr('�տ����:')+' +a.code) as Memo '
    +' from FNClearSLMaster a                   '
    +' left outer join DaClient c on c.ID=a.ClientID           '
    +' left outer join DASubject d on d.ID=c.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAClient')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and (isnull(a.AmountD,0)+isnull(a.AmountRed,0))<>0 and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearSLMaster_2')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearSLMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������===
end;

procedure TFNCredenceBrowseForm.DoingCase3;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// ת���������
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNClearPCMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')
    +' and ( isnull(AmountC,0)+isnull(AmountRed,0) )<>0 and  '
    +' ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('FNClearPCMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));

  VouchTranTemp.Open;

  if VouchTranTemp.IsEmpty then exit;
  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('��������Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ

  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);

  VouchTranTemp.Close;  //�����ӱ�������---�������ʻ���
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNClearPCMaster')+' as OriginTable , ( '
    +Quotedstr('�������:')+' +a.code) as Memo '
    +' from FNClearPCMaster a                                     '
    +' left outer join FNAccounts  b on b.ID=a.AccountsID       '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('FNAccounts')+ ' and        '
    +'   e.RelativeID=a.AccountsID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountC,0)<>0 and   a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearPCMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������---

  VouchTranTemp.Close;  //�����ӱ�������===(�ۿ۳���)
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec,Memo )'
    +' select '+NewVoucherID+' as MasterID , '
    + Inttostr(VourchTranIniADS.FieldByName('AccountFID').AsInteger)
    + 'as GoodsID, '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNClearPCMaster_1')+' as OriginTable , ( '
    +Quotedstr('�������:')+' +a.code) as GoodsSpec, '
    +Quotedstr('�ۿ۳���')+' as Memo '
    +' from FNClearPCMaster a                                     '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountRed,0) <>0 and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearPCMaster_1')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearPCMaster')+' )'
    +' group by a.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������===

  VouchTranTemp.Close;  //�����ӱ�跽���===��Ӧ���ʿ
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    + ' e.ID as GoodsID, '
    +' ( sum(isnull(a.AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))    +        '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) )           '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('FNClearPCMaster_2')+' as OriginTable , ( '
    +Quotedstr('�������:')+' +a.code) as Memo '
    +' from FNClearPCMaster a                   '
    +' left outer join DaClient c on c.ID=a.ClientID           '
    +' left outer join DASubject d on d.ID=c.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAClient')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and (isnull(a.AmountC,0)+isnull(a.AmountRed,0)<>0 ) and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearPCMaster_2')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNClearPCMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�跽���===
//  Memo1.Text :=   VouchTranTemp.SQL.Text;
end;

procedure TFNCredenceBrowseForm.DoingCase4;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// ת���տ�����
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCashInMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')
    +' and ( isnull(AmountD,0)+isnull(AmountRed,0) )<>0 and  '
    +' ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('FNCashInMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));

  VouchTranTemp.Open;

  if VouchTranTemp.IsEmpty then exit;
  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('�տ������Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ

  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);

  VouchTranTemp.Close;  //�����ӱ�跽���---���տ��ʻ���
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashInMaster')+' as OriginTable , ( '
    +Quotedstr('�տ�����:')+' +a.code) as Memo '
    +' from FNCashInMaster a                                     '
    +' left outer join FNAccounts  b on b.ID=a.AccountsID       '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('FNAccounts')+ ' and        '
    +'   e.RelativeID=a.AccountsID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountD,0)<>0 and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashInMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�跽���---

  VouchTranTemp.Close;  //�����ӱ�跽���===(�ۿ۳���)
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec,Memo )'
    +' select '+NewVoucherID+' as MasterID , '
    + Inttostr(VourchTranIniADS.FieldByName('AccountFID').AsInteger)
    + 'as GoodsID, '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashInMaster_1')+' as OriginTable , ( '
    +Quotedstr('�տ�����:')+' +a.code) as GoodsSpec, '
    +Quotedstr('�ۿ۳���')+' as Memo '
    +' from FNCashInMaster a                                     '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountRed,0)<>0 and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashInMaster_1')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashInMaster')+' )'
    +' group by a.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�跽���===

  VouchTranTemp.Close;  //�����ӱ�������===������Ӧ�տ
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    + ' e.ID as GoodsID, '
    +' ( sum(isnull(a.AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))    +        '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) )           '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashInMaster_2')+' as OriginTable , ( '
    +Quotedstr('�տ�����:')+' +a.code) as Memo '
    +' from FNCashInMaster a                   '
    +' left outer join MSEmployee c on c.ID=a.ClientID           '
    +' left outer join MSDepartment I on I.ID=C.DepartmentID       '
    +' left outer join DASubject d on d.ID=I.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('MSEmployee')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and (isnull(a.AmountD,0)+isnull(a.AmountRed,0))<>0 and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashInMaster_2')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashInMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������===
end;

procedure TFNCredenceBrowseForm.DoingCase5;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// ת����������
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCashOutMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')
    +' and ( isnull(AmountC,0)+isnull(AmountRed,0) )<>0 and  '
    +' ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('FNCashOutMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));

  VouchTranTemp.Open;

  if VouchTranTemp.IsEmpty then exit;
  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('���������Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ

  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);

  VouchTranTemp.Close;  //�����ӱ�������---�������ʻ���
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashOutMaster')+' as OriginTable , ( '
    +Quotedstr('��������:')+' +a.code) as Memo '
    +' from FNCashOutMaster a                                     '
    +' left outer join FNAccounts  b on b.ID=a.AccountsID       '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('FNAccounts')+ ' and        '
    +'   e.RelativeID=a.AccountsID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountC,0)<>0  and    a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������---

  VouchTranTemp.Close;  //�����ӱ�������===(�ۿ۳���)
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec,Memo )'
    +' select '+NewVoucherID+' as MasterID , '
    + Inttostr(VourchTranIniADS.FieldByName('AccountFID').AsInteger)
    + 'as GoodsID, '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashOutMaster_1')+' as OriginTable , ( '
    +Quotedstr('��������:')+' +a.code) as GoodsSpec, '
    +Quotedstr('�ۿ۳���')+' as Memo '
    +' from FNCashOutMaster a                                     '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountRed,0)<>0 and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutMaster_1')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutMaster')+' )'
    +' group by a.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������===

  VouchTranTemp.Close;  //�����ӱ�跽���===������Ӧ�տ
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, Pricebase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    + ' e.ID as GoodsID, '
    +' ( sum(isnull(a.AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))    +        '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) )           '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashOutMaster_2')+' as OriginTable , ( '
    +Quotedstr('��������:')+' +a.code) as Memo '
    +' from FNCashOutMaster a                   '
    +' left outer join MSEmployee c on c.ID=a.ClientID           '
    +' left outer join MSDepartment I on I.ID=C.DepartmentID       '
    +' left outer join DASubject d on d.ID=I.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('MSEmployee')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4) '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and (isnull(a.AmountC,0)+isnull(a.AmountRed,0) )<>0 and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutMaster_2')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������===
end;

procedure TFNCredenceBrowseForm.DoingCase6;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// ת�����ñ���
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNExpenseMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')
    +' and ( isnull(AmountC,0)+isnull(AmountRed,0) )<>0 and  '
    +' ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('FNExpenseMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));
  VouchTranTemp.Open;

  if VouchTranTemp.IsEmpty then exit;
  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('���ñ����Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ

  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);

  VouchTranTemp.Close;  //�����ӱ�跽���===�����ÿ�Ŀ��
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, Pricebase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    + ' e.ID as GoodsID, '
    +' sum(isnull(a.Amount,0)*Isnull(b.ModeDC,1)*Isnull(b.ModeC,1))          '
    +' as PriceBase, b.ID  as GoalUnitID,               '
    +Quotedstr('FNExpenseMaster')+' as OriginTable , ( '
    +Quotedstr('���ñ���:')+' +b.code) as Memo '
    +' from  FNExpenseDetail a                   '
    +' left outer join FNExpenseMaster b on b.ID=a.MasterID                 '
    +' left outer join DAExpenseClass c on c.ID=a.ExpenseID      '
    +' left outer join DASubject d on d.ID=c.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAExpenseClass')+ ' and        '
    +'   e.RelativeID=a.ExpenseID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where b.RecordState<>'+Quotedstr('ɾ��')
    +' and b.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.Amount,0) <>0 and b.date<='
    +Quotedstr(DateToStr(FEndDate))+' and b.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNExpenseMaster')+' )'
    +' group by b.ID,e.ID, b.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�跽���===

  VouchTranTemp.Close;  //�����ӱ�������===(�ۿ۳���)
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec,Memo )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountRed,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNExpenseMaster_1')+' as OriginTable , ( '
    +Quotedstr('���ñ���:')+' +a.code) as GoodsSpec, '
    +Quotedstr('�ۿ۳���')+' as Memo '
    +' from FNExpenseMaster a  '
    +' left outer join MSEmployee s on s.ID=a.ClientID     '
    +' left outer join MSDepartment  b on b.ID=s.DepartMentID '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('MSEmployee')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountRed,0)<>0 and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNExpenseMaster_1')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNExpenseMaster')+' )'
    +' group by e.ID, a.ID,a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������===

  VouchTranTemp.Close;  //�����ӱ�������---�������ʻ���
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountC,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNExpenseMaster_2')+' as OriginTable , ( '
    +Quotedstr('���ñ���:')+' +a.code) as Memo '
    +' from FNExpenseMaster a                                     '
    +' left outer join FNAccounts  b on b.ID=a.AccountsID       '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('FNAccounts')+ ' and        '
    +'   e.RelativeID=a.AccountsID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountC,0)<>0  and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNExpenseMaster_2')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNExpenseMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';

//  Memo1.Text := VouchTranTemp.SQL.Text ;

  VouchTranTemp.ExecSQL; //�����ӱ�������---


end;

procedure TFNCredenceBrowseForm.DoingCase7;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// ת���ʽ����
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCashOutInMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')+' and '
    +' ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('FNCashOutInMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));

  VouchTranTemp.Open;

  if VouchTranTemp.IsEmpty then exit;
  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('�ʽ�����Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ

  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);

  VouchTranTemp.Close;  //�����ӱ�������---�������ʻ���
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceCost,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceCost, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashOutInMaster')+' as OriginTable , ( '
    +Quotedstr('�ʽ����:')+' +a.code) as Memo '
    +' from FNCashOutInMaster a                                     '
    +' left outer join FNAccounts  b on b.ID=a.ClientID       '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('FNAccounts')+ ' and        '
    +'   e.RelativeID=a.ClientID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountD,0)<>0  and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutInMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�������---����

  VouchTranTemp.Close;  //�����ӱ�跽���===����
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID , '
    +' e.ID as GoodsID, '
    +' sum(isnull(a.AmountD,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))            '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('FNCashOutInMaster_1')+' as OriginTable , ( '
    +Quotedstr('�ʽ����:')+' +a.code) as Memo '
    +' from FNCashOutInMaster a                                     '
    +' left outer join FNAccounts  b on b.ID=a.AccountsID       '
    +' left outer join DASubject d on d.ID=b.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('FNAccounts')+ ' and        '
    +'   e.RelativeID=a.AccountsID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and isnull(a.AmountD,0)<>0  and  a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutInMaster_1')+' )'
    +' and a.ID in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('FNCashOutInMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
//  Memo1.Text :=   VouchTranTemp.SQL.Text ;
  VouchTranTemp.ExecSQL; //�����ӱ�跽���===����
end;

procedure TFNCredenceBrowseForm.DoingCase8;
begin
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
// exit;
//ת���ɹ��ɱ�
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from STGoodsOutCostMaster '
    +' where RecordState<>'+Quotedstr('ɾ��')
    +' and RecordState<>'+ Quotedstr('����')
    +' and BillMode='+ Quotedstr('�ɹ��ɱ�����')+ ' and '
    +' ID not in (select GoalUnitID from FNCredDetail where '
    +' OriginTable=' +Quotedstr('STGoodsOutCostMaster')
    +' ) and  Date<=' +Quotedstr(DateToStr(FEndDate));
  VouchTranTemp.Open;
  if VouchTranTemp.IsEmpty then exit;

  VouchTranTemp.Close;  //����ת�����
  VouchTranTemp.SQL.Text :=' select '
    +' sum(isnull(b.Amount,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) as AmountA  ,    '
    +' sum(isnull(b.SundryFee,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) as AmountA1      '
    +' from STGoodsOutCostMaster a                             '
    +' left outer join STGoodsOutCostDetail b on b.MasterID=a.ID       '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and BillMode='+ Quotedstr('�ɹ��ɱ�����')
    +' and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('STGoodsOutCostMaster')+' )' ;
  VouchTranTemp.Open;//����ת�����
  AmountA := VouchTranTemp.FieldByName('AmountA').AsFloat+
     VouchTranTemp.FieldByName('AmountA1').AsFloat;
  VouchTranTemp.Close;  //����ת�����
  VouchTranTemp.SQL.Text :=' select '
    +' sum(isnull(a.IndirectFee,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)) as AmountB     '
    +' from STGoodsOutCostMaster a                             '
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and BillMode='+ Quotedstr('�ɹ��ɱ�����')
    +' and isnull(a.IndirectFee,0)<>0 and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('STGoodsOutCostMaster')+' )' ;
  VouchTranTemp.Open;//����ת�����
  AmountB := VouchTranTemp.FieldByName('AmountB').AsFloat ;

  NewVoucherCode :=GetMaxCode('Code','FNCredMaster',number);
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' Insert into FNCredMaster ( '
    +' CreateUserID,Code,Date,BillMode,ModeDC,ModeC,Brief,Memo)'
    +' Values ( '+Inttostr(Guarder.UserID)+' , '+ Quotedstr(NewVoucherCode)
    +' , '+Quotedstr(DateToStr(FEndDate))+' , '+ Quotedstr('�Զ�ת��')
    +' , 1, 1 ,'+ Quotedstr('�Զ�ת��')+' , '+ Quotedstr('�ɹ��ɱ������Զ�ת��ƾ֤')
    +' ) ';
  VouchTranTemp.ExecSQL;  //����ƾ֤ͷ
  VouchTranTemp.Close;
  VouchTranTemp.SQL.Text :=' select ID from FNCredMaster where Code='
    +Quotedstr(NewVoucherCode);
  VouchTranTemp.Open;
  NewVoucherID :=Inttostr(VouchTranTemp.fieldbyname('ID').AsInteger);
  VouchTranTemp.Close;  //�����ӱ�跽���---
  VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
    +' MasterID,GoodsID, PriceBase,GoalUnitID, OriginTable,GoodsSpec )'
    +' select '+NewVoucherID+' as MasterID ,'
    +' e.ID as GoodsID, '
    +' (sum(isnull(b.Amount,0)*Isnull(ModeDC,1)*Isnull(ModeC,1))                   '
    +' +sum(isnull(b.SundryFee,0)*Isnull(ModeDC,1)*Isnull(ModeC,1)))               '
    +' as PriceBase, a.ID  as GoalUnitID,               '
    +Quotedstr('STGoodsOutCostMaster')+' as OriginTable , ( '
    +Quotedstr('�ɹ��ɱ�����:')+' +a.code) as Memo '
    +' from STGoodsOutCostMaster a                                     '
    +' left outer join STGoodsOutCostDetail b on b.MasterID=a.ID       '
    +' left outer join DaGoods c on c.ID=b.GoodsID           '
    +' left outer join DaGoodsClass  I on I.ID=C.GoodsClassID           '
    +' left outer join DASubject d on d.ID=I.GeneralACID       '
    +' Left outer join DASubject e on                          '
    +'   e.RelativeTable='+Quotedstr('DAGoods')+ ' and        '
    +'   e.RelativeID=b.GoodsID and substring(d.subCode,1,4)='
    +'   substring(e.subCode,1,4)'
    +' where a.RecordState<>'+Quotedstr('ɾ��')
    +' and a.RecordState<>'+ Quotedstr('����')
    +' and BillMode='+ Quotedstr('�ɹ��ɱ�����')
    +' and (isnull(b.Amount,0)+isnull(b.SundryFee,0) )<>0 and a.date<='
    +Quotedstr(DateToStr(FEndDate))+' and a.ID not in '
    +' ( select GoalUnitID from FNCredDetail where OriginTable='
    +Quotedstr('STGoodsOutCostMaster')+' )'
    +' group by a.ID,e.ID, a.Code  ';
  VouchTranTemp.ExecSQL; //�����ӱ�跽���---

  if AmountA<>0 then
  begin
    VouchTranTemp.Close;  //�����ӱ�������====
    VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
      +' MasterID,GoodsID, PriceCost,GoodsSpec )'
      +' Values ( '+NewVoucherID+'   ,'
      + Inttostr(VourchTranIniADS.FieldByName('AccountFID').AsInteger)
      +' , ' + Floattostr(AmountA-AmountB)+' , '
      +Quotedstr('�ɹ��ɱ�����')+' ) ';
    VouchTranTemp.ExecSQL; //�����ӱ������� ====
  end;
  if AmountB<>0 then
  begin
    VouchTranTemp.Close;  //�����ӱ�������****
    VouchTranTemp.SQL.Text :=' Insert Into FNCredDetail ( '
      +' MasterID,GoodsID, PriceCost,GoodsSpec,Memo)'
      +' Values ( '+NewVoucherID + ' ,'
      + Inttostr(VourchTranIniADS.FieldByName('AccountGID').AsInteger)
      + ' , '   + Floattostr(AmountB)+' , '
      +Quotedstr('��ӷ���')+' , '
      +Quotedstr('��ӷ��÷�̯')+' ) ';
    VouchTranTemp.ExecSQL; //�����ӱ�������****
  end;
//ת����ɺ󣬹ر�ת������
  VourchTranIniADS.Edit;
  VourchTranIniADS.FieldByName('Code').AsString :='��';
  VourchTranIniADS.Post;
end;

procedure TFNCredenceBrowseForm.DoingCase9;
begin
//��Ҷһ�
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
//
//ת����ɺ󣬹ر�ת������
  VourchTranIniADS.Edit;
  VourchTranIniADS.FieldByName('Code').AsString :='��';
  VourchTranIniADS.Post;

end;

procedure TFNCredenceBrowseForm.DoingCaseA;
begin
//���ϳɱ�����
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
//
//ת����ɺ󣬹ر�ת������
  VourchTranIniADS.Edit;
  VourchTranIniADS.FieldByName('Code').AsString :='��';
  VourchTranIniADS.Post;
end;

procedure TFNCredenceBrowseForm.DoingCaseB;
begin
//�ⷢ�ӹ�����
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
//
//ת����ɺ󣬹ر�ת������
  VourchTranIniADS.Edit;
  VourchTranIniADS.FieldByName('Code').AsString :='��';
  VourchTranIniADS.Post;
end;

procedure TFNCredenceBrowseForm.DoingCaseC;
begin
//�����ɱ�����

//ת����ɺ󣬹ر�ת������
  VourchTranIniADS.Edit;
  VourchTranIniADS.FieldByName('Code').AsString :='��';
  VourchTranIniADS.Post;
end;

procedure TFNCredenceBrowseForm.DoingCaseD;
begin
//���۳ɱ�����
  if VourchTranIniADS.FieldByName('Code').AsString<>'��' then Exit;
//
//ת����ɺ󣬹ر�ת������
  VourchTranIniADS.Edit;
  VourchTranIniADS.FieldByName('Code').AsString :='��';
  VourchTranIniADS.Post;
end;

procedure TFNCredenceBrowseForm.ToolButton6Click(Sender: TObject);
begin
  Application.CreateForm(TFNVouchTranIniForm, FNVouchTranIniForm);
  FNVouchTranIniForm.ShowModal;
  FNVouchTranIniForm.Free;
end;


end.
