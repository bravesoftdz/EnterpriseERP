QL Library
==========

��ӭʹ�� QL Library������ʹ�������κ����ʻ�������������ϵ:

Author: Qiuliang
EMail: qiuliang@china.com
QQ: 43645896
Web: http://developer.nicesoft.net

���ĵ�������������:

��װ˵��
QLDBGrid ˵��
QLDBLookupComboBox ˵��
QLDBReportBuilder ˵��
QLDBFilterDialog ˵��


��װ˵��
========

ʹ�á�File\Open...' �˵���� Lib Ŀ¼�µ������ QLL60.dpk (Delphi 6) �� QLL70.dpk (Delphi 7)���ڰ����������ڵ����Compile����ť���������Ȼ������Install����ť��ע���������


QLDBGrid
========

����
----

QLDBGrid ��һ����ǿ�͵� DBGrid ������̳��Ա�׼ DBGrid�������������ǿ��ʵ�õĹ��ܣ������������Ƕ���ⲿ����ȵȡ�

����
----

* �й�����ƾ֤ʽ�Ľ����ʾ������ʾλ֮��ķָ�����ɫ�����ж��壬�����ڱ���������ʾ��...��ǧ��ʮ���Ƿ֡������� 
* ֧�ֶ��ַ�ʽ�ĺϼ��С�֧�ֺϼơ�ƽ�����������ı��ȷ�ʽ�ĺϼ��С��й�����ƾ֤ʽ�Ľ����ʾ�ںϼ�����ͬ�����á��ϼ��е���ɫ�����ж��壡���� 
* ���� Grid �ĸ�����Ƕ������ؼ�������Ĭ�ϱ༭����������ڲ������ֶε�����Ƕ�� DBCheckBox����һֻ��������ֶε�����Ƕ�� DBEdit������ 
* ֧�ֽ���ʽ������ɫ��ʾ�������к�ż���пɶ��岻ͬ����ɫ 
* ����Ӧ��ȡ�Grid �еĸ��еĿ���� Grid ��ȵĸı�����е�����ȣ�ʹ��ʼ��������� Grid �ͻ����� 
* �س���ת��Ϊ�Ʊ�����ɽ��س��������Ʊ��������ʹ�û��ûس���ʱ�Զ�ת����һ�л��У��������ݸ����ٷ��� 
* ��� TQLQRDBGridBuilder �Զ����� QuickReport ����ʡȥ�ֹ�����������鷳������ 
* ��� TQLDBLookupComboBox ʵ���������ݰ�ƴ������ң���ͬ�ٴ� E2 �е�Ʒ�����뷽ʽ�����������ڴ����Ĳ�ƷĿ¼�����ز��һ�ǿ���û���������Ĳ�Ʒ���룡���� 
* �̳��Ա�׼�� TDBGrid��ʹ�� TDBGrid �������࿪�������г����ʵ��ƽ������

��Ҫ����
--------

property AlternateColor: TColor;

    ���� AlternateColor ��ָ�� Grid ż���еı�����ɫ��
    ��� Color ���Կɴﵽ�����к�ż����ʹ�ò�ͬ������ɫ��ʾ��Ч����

property CurrencyView: TCurrencyView;

    ���� CurrencyView ��ָ����ʹ�ò�����ʾ��ʽʱ����͵��ֶ��� Grid �е���ʾ��ʽ��CurrencyView ֵ��һ�� TCurrencyView �������� CurrencyView ��������ָ��������λ��ǧ��λ�ķָ�����ɫ��ÿλ�Ŀ�ȡ��Ƿ���ʾ�������е���ۡ�
    ���� OptionsEx ������ dgCurrencyView ���������ֶε� currency ����Ϊ Ture�����ֶξͻᰴ����ʽ��ʾ�ˡ�

property FooterColor: TColor;

    ʹ�� FooterColor ����ȡ�����ĺϼ��еı�����ɫ��

property FooterFont: TFont;

    FooterFont ����ָ��һ�� TFont ���󣬾����ϼ��е���ʾ����

property FooterRowCount: Integer;

    ���� FooterRowCount ��ָ���ϼ��е��������������ö���ϼ��У�����Ϊ 0 ��ʾ�޺ϼ��С�(��ǰ�汾ֻ֧����� 1 ���ϼ���)


property OptionsEx: TQLDBGridOptionsEx;

    ���� OptionsEx ��������������ԡ�OptionsEx ����������ֵ�� 
	ֵ 			���� 
	dgCurrencyView 		ʹ�ò���ʽ��ʾ����͵��ֶ� 
	dgAutoWidth 		�Զ��������еĿ�ȣ�ʹ֮���Ǹպ����������ͻ�����������ˮƽ������
	dgEnterToTab 		�ڱ༭ʱ�Զ��� Enter ��ת���� Tab �����Ա�ʹ�û��س�ʱת����һ���ɱ༭�� 
	dgAllowDelete 		����ɾ���û�ʹ�� Ctrl+Del ɾ����ǰ�� 
	dgAllowInsert 		�������û������µ��� 
	dgControlArrowKeys 	����Ƕ��Ŀؼ����䷽������� Grid �������Ա��ڰ��·����ʱ�ܹ��ƶ���ǰ�л���

property OnDrawFooterCell: TDrawFooterCellEvent;

    ��д OnDrawFooterCell �¼�����������Զ���ϼ��еĻ滭��ʹ�� Canvas ���Եķ������л滭��


ʹ�� QLDBGrid
-------------

���� QLDBGrid �̳��� DBGrid�����������漰�����������ܣ�����ȫ������������ʹ�� DBGrid һ��ʹ������Ҳ��ȫ���Խ��ɹ����е� DBGrid �� QLDBGrid �滻��

������ƾ֤��ʽ��ʾ�����
------------------------
���ȣ���˫����������ʾ�� DataSet, ���ֶα༭��ѡ�н�����ֶε��ֶβ������Ա༭���н��� currency ��������Ϊ True��
Ȼ�󣬽� QLDBGrid �� OptionsEx.dgCurrencyView ����Ϊ True ���ɡ���ʱ�� DataSet.Active ������Ϊ True�����ɿ���Ч����

��ʾ�ϼ���
----------
�������� FooterRowCount ����Ϊ 1�����ţ�˫�� QLDBGrid�����б༭���м�����Ҫ��ʾ���У�Ȼ��ѡ����Ҫ��ʾ�ϼ������У������Ա༭�����ҵ����� Footer���������� ValueType ����Ϊ��Ҫ�ĺϼ������ͼ��ɡ�

Ƕ���ⲿ���
------------
1. �� Form �Ϸ��ý�ҪǶ���������������̳��� TWinControl
2. ���ֶα༭���м��뽫Ҫ��ʾ�����������ֶ�
3. ˫�� QLDBGrid �����б༭����������������Ҫ��ʾ���ֶ�
4. ���б༭����ѡ��ҪǶ���ⲿ������У����� ControlType �� ctDefault ��Ϊ ctCustomControl�������� CustomControl ���ԣ�ʹָ֮�� Form ���õ���ҪǶ��������
5. ��ɡ�


QLDBLookupComboBox 
==================

����
----

QLDBLookupComboBox ��һ����ǿ�͵� DBLookupComboBox ��������ڱ�׼�� DBLookupComboBox ������һЩ�������û������������ݵ����ԡ����Ĵ󲿷����Ժͷ�������׼ DBLookupComboBox �����ͬ�������Щ���Ժͷ������ﲻ�ټ���˵������Ҫ�Ļ���ο� Delphi �����ĵ���

���� 
----

�������б���е����ݿɰ�ƴ�����ԭ�ģ�������ʽ�����ң����� 
�������б����������ʾ��Ӧ�Ĳ�����ť������ʾ�½����޸ġ��ÿհ�ť����Ե�ǰ��¼�ṩ���������� 
������ȫ���� TDBLookupComboBox  

��Ҫ����
--------

property SearchMode: TSearchMode read FSearchMode write SetSearchMode;

    ָ������ģʽ����ȡ����ֵ��
    
    smLocate    ʹ�ö�λ��ʽ����
    smFilter    ʹ�ù��˷�ʽ����

property SearchType: TSearchType read FSearchType write FSearchType;

    ֵʱ�������ͣ���ȡ����ֵ��
    
    stAuto    �Զ�������������
    smNormal  ʹ���� ListFieldIndex ����ָ�����ֶβ���
    smPYM     ʹ���� ListFieldIndex ����ָ�����ֶε�ֵ��ƴ�������
    smWBM     ʹ���� ListFieldIndex ����ָ�����ֶε�ֵ����������

property VisibleButtons: TLookupWindowBtns read FVisibleButtons write 
            SetVisibleButtons default [lbNew, lbEdit, lbSetNull];

    ������Щ��Ŧ��������������


property OnButtonClick: TLookupWindowBtnClick read FOnButtonClick write 
            FOnButtonClick;

���û����������б���еİ�Ŧʱ�ᴥ�����¼������� Index ָ����ǰ�û�����İ�ť���ͣ�������ֵ��

lbNew      �û�������½���ť
lbEdit     �������Ǳ༭��ť
lbSetNull  ���������ÿհ�ť


QLDBGridReportBuilder
=====================

����
----

QLDBGridReportBuilder �ܸ��� DBGrid �Զ����� QuickReport �������ڿ˷����û��ֶ���������ķ�����ͬʱ�ֱ����˶��ֶ��������������Ե�֧�֡�


ʹ�� QLDBGridReportBuilder
--------------------------

1���� Delphi���½�һ������
2���� Form1 �Ϸ���һ�� ADOTable���������������ԣ�
	ConnectionString = "FILE NAME=C:\Program Files\Common 
		Files\System\OLE DB\Data Links\DBDEMOS.udl"
	TableName = "Customer"
	Active = True
3������һ�� DataSource ����� Form1 �ϣ������� DataSet ����ָ�� ADOTable1
4������һ�� DBGrid ����� Form1 �ϣ��������� DataSource ָ�� DataSource1�����ǣ�DBGrid �н���ʾ ADOTable1 ������
5���� Nicesoft.Net ����������һ�� QLDBGridReportBuilder ����� Form1�������� DBGrid ����ָ�� DBGrid1
6���� QLDBGridReportBuilder1 �� Active ������Ϊ True

��ʱ��һ�Ŵ�ӡ DBGrid �ı���ͱ������ˣ�����Խ���Ԥ�����ӡ���������Զ����ɵı�����û�б����ҳüҳ�ŵ�������Ҫ�ֶ����õ����ݣ��𼱣�����ͽ�������ֶ��趨ҳüҳ�ŵ����ݡ�

7���� QLDBGridReportBuilder1 �� Active ������Ϊ False����ʱ�ղ����ɵı����� Free
8������һ�� QuickRep ����� Form1 �ϣ������������ҳü��ҳ�š����������
9���� QLDBGridReportBuilder1 �� Report ����ָ��ղŷ��õı������ QuickRep1
10���� QLDBGridReportBuilder1 �� Active ������Ϊ True

���ˣ�һ�Ű������û��ֶ����ú� QLDBGridReportBuilder �Զ����ɵı���ͱ������ˡ���Ҫ�������ɵı��������ڽ� QLDBGridReportBuilder1 �� Active ������Ϊ False ֮ǰ���� Report ������Ϊ nil�����򵱽� QLDBGridReportBuilder1 �� Active ������Ϊ False�����ɵı���Ҳ���� Free��

����˵��
--------

AutoWidth: Boolean		�Զ����ݱ���Ŀ�ȵ���ÿ�п�ȣ�ʹ֮������
				������
HasColLines: Boolean		���ɵı����и����Ƿ������߷ָ�
HasRowLines: Boolean		���ɵı����и���֮���Ƿ������߷ָ�
PrintFields: string		���ӡ���ֶΣ����ֶ�֮���÷ֺ�(;)�ָ�
SummaryFields: TStrings		����ϼ��ֶΡ��� 		
				SummaryFields.Add('Cost=SUM(Cost)') ��
				ʾ���ֶ� Cost �ĺϼ�λ������ʾ 
				SUM(Cost) ��ֵ
AutoOrientation			�Զ���������ֵֽ�ŷ����Ծ��������ɸ����
				�С�����ѽ� AutoWidth ��Ϊ True�������Խ�
				��������


Tips
----

������ʱ���ɱ�������������´��룺

  with TQLDBGridReportBuilder.Create(Self) do
  try
    DBGrid := DBGrid1;
    Report := TMyReportClass.Create(Self); 
    HasColLines := True;
    HasRowLines := True;
    AutoWidth := True;
    Active := True;
    Report.Preview;
    Active := False;
  finally
    Free;
  end;



QLDBFilterDialog
================

QLDBFilterDialog ��һ�����ݼ�ɸѡ�Ի������ܸ����û������ɸѡ���������� DataSet ����ɸѡ��Ҳ�ܸ���ɸѡ�������� SQL �� WHERE �Ӿ䡣 

˵����
---------

property DataSet: TDataSet		��ɸѡ�� DataSet;
property FilterFields: string		�������ɸѡ���ֶΣ�ֻ��֮���÷ֺ�(;)�ָ�
property Title: string			ɸѡ�Ի���ı���
function Execute: Boolean;		����ɸѡ�Ի����������ֵΪ True�����ʾ�û�ִ��ɸѡ