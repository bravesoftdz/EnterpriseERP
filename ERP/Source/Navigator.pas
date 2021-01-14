unit Navigator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin, Isp3,
  ActnList, ImgList, shdocvw;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  TNavigatorForm = class(TForm)
    NavigatorImages: TImageList;
    NavigatorHotImages: TImageList;
    LinksImages: TImageList;
    LinksHotImages: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    BackBtn: TToolButton;
    ForwardBtn: TToolButton;
    StopBtn: TToolButton;
    RefreshBtn: TToolButton;
    Animate1: TAnimate;
    URLs: TComboBox;
    ActionListNet: TActionList;
    BackAction: TAction;
    ForwardAction: TAction;
    StopAction: TAction;
    RefreshAction: TAction;
    WebBrowser: TWebBrowser;
    ToolBar4: TToolBar;
    procedure Exit1Click(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure URLsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LinksClick(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure ForwardClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure URLsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure nStatusbarClick(Sender: TObject);
    procedure BackActionUpdate(Sender: TObject);
    procedure ForwardActionUpdate(Sender: TObject);
    procedure WebBrowserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowserDownloadBegin(Sender: TObject);
    procedure WebBrowserDownloadComplete(Sender: TObject);
    procedure nExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;
  public

  end;

var
  NavigatorForm: TNavigatorForm;
  cIntHomepage: string;

procedure NavigateExecute(PageName: string);

implementation

uses WSUtils, MAIN, WSSecurity;

{$R *.DFM}

procedure TNavigatorForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TNavigatorForm.FindAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  UpdateCombo := True;
  try
    WebBrowser.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
  except
    WebBrowser.Navigate(WideString(cIntHomepage), Flags, Flags, Flags, Flags);
  end;
end;

procedure TNavigatorForm.StopClick(Sender: TObject);
begin
  WebBrowser.Stop;
end;

procedure TNavigatorForm.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure TNavigatorForm.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

procedure TNavigatorForm.LinksClick(Sender: TObject);
begin
  if (Sender as TToolButton).Hint = '' then Exit;
  URLs.Text := (Sender as TToolButton).Hint;
  FindAddress;
end;

procedure TNavigatorForm.RefreshClick(Sender: TObject);
begin
  FindAddress;
end;

procedure TNavigatorForm.BackClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure TNavigatorForm.ForwardClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure TNavigatorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssAlt] then
    if (Key = VK_RIGHT) and ForwardBtn.Enabled then
      ForwardBtn.Click
    else if (Key = VK_LEFT) and BackBtn.Enabled then
      BackBtn.Click;
end;

procedure TNavigatorForm.nStatusbarClick(Sender: TObject);
begin
{  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    StatusBar1.Visible := Checked;
  end;}
end;

procedure TNavigatorForm.HomePageRequest(var Message: TMessage);
begin
  URLs.Text := cIntHomepage;
  FindAddress;
end;

procedure TNavigatorForm.FormDestroy(Sender: TObject);
begin
  HistoryList.Free;
end;

procedure TNavigatorForm.BackActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    BackAction.Enabled := HistoryIndex > 0
  else
    BackAction.Enabled := False;
end;

procedure TNavigatorForm.ForwardActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    ForwardAction.Enabled := HistoryIndex < HistoryList.Count - 1
  else
    ForwardAction.Enabled := False;
end;

procedure TNavigatorForm.WebBrowserDownloadBegin(Sender: TObject);
begin
  { Turn the stop button dark red }
  StopBtn.ImageIndex := 4;
  { Play the avi from the first frame indefinitely }
  Animate1.Active := True;
end;

procedure TNavigatorForm.WebBrowserDownloadComplete(Sender: TObject);
begin
  { Turn the stop button grey }
  StopBtn.ImageIndex := 2;
  { Stop the avi and show the first frame }
  Animate1.Active := False;
end;

procedure TNavigatorForm.nExitClick(Sender: TObject);
begin
  Close;
end;

procedure TNavigatorForm.FormShow(Sender: TObject);
begin
  cIntHomepage := ExtractFilePath(Application.ExeName) + 'Navigation\ϵͳ����.htm';
  HistoryIndex := -1;
  HistoryList := TStringList.Create;
  try
    Animate1.FileName := ExtractFilePath(Application.ExeName) + 'Navigation\cool.avi';
    PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);
  except
  end;
end;

procedure NavigateExecute(PageName: string);
var
  Url: string;
  I: integer;
  Flags: OLEVariant;
begin
  FindShowForm(TNavigatorForm, '');
  if PageName = 'ϵͳά��' then Url := 'ϵͳά��'//'erp_1'
  else if PageName = '��������' then Url := '��������'//'erp_1'
  else if PageName = '�칫����' then Url := '�칫����'//'erp_1'
  else if PageName = '���۹���' then Url := '���۹���'//'erp_2'
  else if PageName = '��������' then Url := '��������'//'erp_3'
  else if PageName = '�ɹ�����' then Url := '�ɹ�����'//'erp_4'
  else if PageName = '������' then Url := '������'//'erp_5'
  else if PageName = '�������' then Url := '�������'//'erp_6'
  else if PageName = '���ʿ���' then Url := '���ʹ���'//'erp_7'
  else if PageName = '�ʲ�����' then Url := '�ʲ�����'//'erp_8'
  else if PageName = '��Ŀ����' then Url := '��Ŀ����'//'erp_1'
  else Url := 'ϵͳ����';

  for I := 0 to Screen.FormCount - 1 do
  begin
    if Screen.Forms[I].Caption = '����' then
    begin
      (Screen.Forms[I] as TNavigatorForm).SetFocus;
      (Screen.Forms[I] as TNavigatorForm).URLs.Text := WideString(ExtractFilePath(Application.ExeName)) + 'Navigation\' + Url + '.htm';
      Flags := 0;
      (Screen.Forms[I] as TNavigatorForm).UpdateCombo := True;
      try
        if Url <> '' then
          (Screen.Forms[I] as TNavigatorForm).WebBrowser.Navigate(WideString((Screen.Forms[I] as TNavigatorForm).Urls.Text), Flags, Flags, Flags, Flags)
        else
          (Screen.Forms[I] as TNavigatorForm).WebBrowser.Navigate(WideString(ExtractFilePath(Application.ExeName)) + 'Navigation\ϵͳ����.htm', Flags, Flags, Flags, Flags);
      except
      end;
    end;
  end;
end;

procedure TNavigatorForm.WebBrowserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  NewIndex: Integer;
  Cmd: string;
begin
  try
    if LowerCase(Copy(URL, 1, 8)) = 'command:' then
    begin
      Cmd := LowerCase(Copy(URL, 9, MaxInt));

//      if (Guarder.UserName = 'ϵͳ����Ա') then
//      else if not (Guarder.HasRight(Cmd)) then
//      begin
//        showmessage('��û�д˹���Ȩ��,�޷�ʹ�ô˹���!����ϵͳ����Ա��ϵ!');
//        exit;
//      end;

      with MainForm do
      begin
        if Cmd = '�ͻ�����' then DAClientAction.Execute
        else if Cmd = '��Ʒ����' then DASLSaleGift.Execute
        else if Cmd = '�ͻ�����' then SLCreditAction.Execute
        else if Cmd = '���ۺ�ͬ' then SLContractAction.Execute
        else if Cmd = '����ͳ��' then SLSaleStatistic.Execute
        else if Cmd = '���۷���Ԥ��' then SLSaleForecast.Execute
  //      else if Cmd = '��������' then SLSaleFruitListAction.Execute
        else if Cmd = '��Ʒ����' then DAGoodsAction.Execute
        else if Cmd = '��Ʒ�ۼ�' then SLSalePrice.Execute
        else if Cmd = '���۶���' then SLOrderAction.Execute
        else if Cmd = '���ۿ���' then SLSaleAction.Execute
        else if Cmd = '���۽���' then FNClearSLAction.Execute
  //      else if Cmd = '���۳���' then SLGoodsOutAction.Execute
  //      else if Cmd = '�����˻�' then SLSaleBackAction.Execute
  //      else if Cmd = '�˻����' then  SLGoodsOutBAction.Execute
        else if Cmd = '�����ۿ�' then  DASLDiscount.Execute
        else if Cmd = '�ͻ��Ǽ�' then
        else if Cmd = 'װ������' then
        else if Cmd = '�ۺ����' then
        else if Cmd = '���۵�֤���' then
        else if Cmd = '���۵�֤����' then
        else if Cmd = '�ͻ�����' then

        else if Cmd = '��������' then DApROVIDERAction.Execute
        else if Cmd = '��Ʒ����' then PCPurchsePrice.Execute
        else if Cmd = '�ɹ�����' then PCCreditAction.Execute
        else if Cmd = '�ɹ�����' then FNClearPCAction.Execute
        else if Cmd = '�ɹ���ͬ' then PCContractAction.Execute
        else if Cmd = '�ɹ�����' then PCOrderAction.Execute
        else if Cmd = '�ɹ�����' then PCPurchaseAction.Execute
        else if Cmd = '�ɹ����' then PCGoodsInAction.Execute
  //      else if Cmd = '�˻�����' then PCGoodsInBack.Execute
  //      else if Cmd = '�ɹ��˻�' then PCPurchaseBack.Execute
        else if Cmd = '��������' then FNExpense.Execute
        else if Cmd = '�ɹ�ͳ��' then PCpurchaseStatistic.Execute
        else if Cmd = '�ɹ�����Ԥ��' then PCPurchaseForecast.Execute
        else if Cmd = '�ɹ�����' then  PCPurchaseFruitAction.Execute


        else if Cmd = '��ϵ��' then OALinkMenIDCard.Execute
        else if Cmd = '������־' then OABrJobRecordsAction.Execute
        else if Cmd = '֪ʶ����' then OABrJobRecordsMng.Execute
        else if Cmd = '��˾����' then OACompanyNews.Execute
        else if Cmd = '�ʼ��շ�' then OAEMail.Execute
        else if Cmd = '��������' then OABrJobArrangeAction.Execute
        else if Cmd = '�ͻ���ϵ' then OAClientkRelation.Execute
        else if Cmd = '���̹�ϵ' then OAClientcRelation.Execute


        else if Cmd = '�ʽ��ʻ�' then DAFNAccounts.Execute
        else if Cmd = '������λ' then MSUnitsAction.Execute
        else if Cmd = '��������' then DAMSCurrency.Execute
        else if Cmd = '��ƿ�Ŀ' then DAFNAccountCode.Execute
        else if Cmd = '�����ڼ�' then MSPeriodAction.Execute
        else if Cmd = '���㷽ʽ' then DAFNClearMode.Execute
        else if Cmd = '��������' then DAFNExpense.Execute
        else if Cmd = '�ʽ����' then FNCashOutIn.Execute
        else if Cmd = '�ֽ�����' then FNCashFlow.Execute
        else if Cmd = '�ʽ��ʱ�' then FNActuialCash.Execute
        else if Cmd = '�տ�����' then FNCashIn.Execute
        else if Cmd = '��������' then FNCashOut.Execute
        else if Cmd = '�����տ�' then FNClearSLaction.Execute
        else if Cmd = '���㸶��' then FNClearPCAction.Execute

        else if Cmd = 'Ӧ��Ӧ��' then FNReceiptPayable.Execute
        else if Cmd = '����Ӧ�տ�' then FNReceiptPayableE.Execute
        else if Cmd = '��Ӫ����' then FNRunExpense.Execute
  //      else if Cmd = 'Ӫҵ����' then FNProfitLoss.Execute
        else if Cmd = '�ʲ���ծ' then FNBalanceSheet.Execute
        else if Cmd = '���÷���' then FNRunExpense.Execute
  //      else if Cmd = '�������' then FNAccountAgeAction.Execute




        else if Cmd = '�ֿ�����' then DASTWarehouse.Execute
        else if Cmd = '����̵�' then STGoodsCountOff.Execute
        else if Cmd = '����ƾ��' then STYDGoodsOut.Execute
        else if Cmd = '���ƾ��' then STYDGoodsIn.Execute
        else if Cmd = '������' then STPCGoodsInCostAct.Execute
        else if Cmd = '��ǰ���' then STStockStatisticsAct.Execute
        else if Cmd = '���䶯' then STStockChange.Execute
        else if Cmd = '������' then STGoodsOutIn.Execute
//        else if Cmd = '��������' then STGoodsOutIn.Execute

        else if Cmd = '�����嵥' then YDFormulaAction.Execute
  //      else if Cmd = '��������' then YDpowerAction.Execute
  //      else if Cmd = '����ƽ��' then YDForecastPL.Execute
        else if Cmd = '�����ƻ�' then YDPlanAction.Execute
        else if Cmd = '���ϼ���' then YDPurchasePlan.Execute
  //      else if Cmd = '��������' then YDPrepareAction.Execute
  //      else if Cmd = '����֪ͨ' then YDProductNotes.Execute
        else if Cmd = '��������' then STYDGoodsOut.Execute
        else if Cmd = '�������' then STYDGoodsIn.Execute
//        else if Cmd = '�ɱ�����' then YDGoodsCost.Execute

        else if Cmd = '�����ձ�' then YDDailyReportAct.Execute
        else if Cmd = '����ͳ��' then YDStatisticReport.Execute
        else if Cmd = '������' then YDStockInWorkAct.Execute
        else if Cmd = '���ϻ�ԭ' then YDBOMBackAction.Execute

        else if Cmd = '����ʱ��' then SRWorktimeAction.Execute
        else if Cmd = '��Ϣʱ��' then SRWorkScheduleAction.Execute
        else if Cmd = '�����Ű�' then SRWorkRestAction.Execute
        else if Cmd = '�Ƽ���Ŀ' then SRJobsAction.Execute
        else if Cmd = '�Ƽ�����' then SRJobsPrice.Execute
        else if Cmd = '�Ƽ�ͳ��' then SRWorkQuantity.Execute
        else if Cmd = '��ʱͳ��' then SRWorkTimeCnt.Execute
        else if Cmd = '���ʺ����' then SRBaseSalary.Execute
        else if Cmd = '����ͳ��' then
        else if Cmd = '���ʷ���' then SRSalaryAnalyze.Execute

        else if Cmd = '�ʲ��ƻ�' then
        else if Cmd = '�ʲ�����' then FAAssetAddAction.Execute
        else if Cmd = '�ʲ��۾�' then FADepreciation.Execute
        else if Cmd = '�ʲ�����' then FAAssetReduce.Execute
        else if Cmd = '�ʲ�ά��' then FAAssetReduce.Execute
        else if Cmd = 'ά�޼ƻ�' then FAAssetRePlan.Execute
        else if Cmd = '�ʲ��ܱ�' then FAAssetRept.Execute
        else if Cmd = '�ʲ��䶯' then FAAssetChange.Execute
        else if Cmd = '�ƻ�����' then FAAssetPlanRept.Execute

      end;
  //    ExecuteCommand(Cmd);
      Cancel := True;
    end;
  //����ƽ
    if LowerCase(Copy(URL, 1, 3)) = 'res' then
      exit;
    NewIndex := HistoryList.IndexOf(URL);
    if NewIndex = -1 then
    begin
      { Remove entries in HistoryList between last address and current address }
      if (HistoryIndex >= 0) and (HistoryIndex < HistoryList.Count - 1) then
        while HistoryList.Count > HistoryIndex do
          HistoryList.Delete(HistoryIndex);
      HistoryIndex := HistoryList.Add(URL);
    end
    else
      HistoryIndex := NewIndex;
    if UpdateCombo then
    begin
      UpdateCombo := False;
      NewIndex := URLs.Items.IndexOf(URL);
      if NewIndex = -1 then
        URLs.Items.Insert(0, URL)
      else
        URLs.Items.Move(NewIndex, 0);
    end;
    URLs.Text := URL;
    MainForm.StatusBar.SimpleText := URL;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      Cancel := True;
    end;
  end;
end;

procedure TNavigatorForm.FormActivate(Sender: TObject);
begin
  self.WindowState := wsMaximized;
end;

end.

