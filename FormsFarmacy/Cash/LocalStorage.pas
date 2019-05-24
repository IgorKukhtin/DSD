unit LocalStorage;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, Vcl.Dialogs,
  IniUtils, VKDBFDataSet, LocalWorkUnit;

function InitLocalDataBaseHead(Owner: TPersistent; LocalDataBaseHead: TVKSmartDBF): Boolean;
function InitLocalDataBaseBody(Owner: TPersistent; LocalDataBaseBody: TVKSmartDBF): Boolean;
function InitLocalDataBaseDiff(Owner: TPersistent; LocalDataBaseDiff: TVKSmartDBF): Boolean;

implementation

procedure InitLocalTable(DS: TVKSmartDBF; AFileName: string);
begin
  DS.DBFFileName := AnsiString(AFileName);
  DS.OEM := False;
  DS.AccessMode.OpenReadWrite := True;
end;

function InitLocalDataBaseHead(Owner: TPersistent; LocalDataBaseHead: TVKSmartDBF): Boolean;
var
  LFieldDefs: TVKDBFFieldDefs;
begin
  InitLocalTable(LocalDataBaseHead, iniLocalDataBaseHead);

  try
    if not FileExists(iniLocalDataBaseHead) then
    begin
      AddIntField(LocalDataBaseHead,  'ID');//id ����
      AddStrField(LocalDataBaseHead,  'UID',50);//uid ����
      AddDateField(LocalDataBaseHead, 'DATE'); //����/����� ����
      AddIntField(LocalDataBaseHead,  'PAIDTYPE'); //��� ������
      AddStrField(LocalDataBaseHead,  'CASH',20); //�������� ��������
      AddIntField(LocalDataBaseHead,  'MANAGER'); //Id ��������� (VIP)
      AddStrField(LocalDataBaseHead,  'BAYER',254); //���������� (VIP)
      AddBoolField(LocalDataBaseHead, 'SAVE'); //���������� (VIP)
      AddBoolField(LocalDataBaseHead, 'COMPL'); //���������� (VIP)
      AddBoolField(LocalDataBaseHead, 'NEEDCOMPL'); //����� �������� ��������
      AddBoolField(LocalDataBaseHead, 'NOTMCS'); //�� ��������� � ������� ���
      AddStrField(LocalDataBaseHead,  'FISCID',50); //����� ����������� ����
      //***20.07.16
      AddIntField(LocalDataBaseHead,  'DISCOUNTID');    //Id ������� ���������� ����
      AddStrField(LocalDataBaseHead,  'DISCOUNTN',254); //�������� ������� ���������� ����
      AddStrField(LocalDataBaseHead,  'DISCOUNT',50);   //� ���������� �����
      //***16.08.16
      AddStrField(LocalDataBaseHead,  'BAYERPHONE',50); //���������� ������� (����������) - BayerPhone
      AddStrField(LocalDataBaseHead,  'CONFIRMED',50);  //������ ������ (��������� VIP-����) - ConfirmedKind
      AddStrField(LocalDataBaseHead,  'NUMORDER',50);   //����� ������ (� �����) - InvNumberOrder
      AddStrField(LocalDataBaseHead,  'CONFIRMEDC',50); //������ ������ (��������� VIP-����) - ConfirmedKindClient
      //***24.01.17
      AddStrField(LocalDataBaseHead,  'USERSESION',50); //��� ������� - �������� ����� ��� �������
      //***08.04.17
      AddIntField(LocalDataBaseHead,  'PMEDICALID');    //Id ����������� ����������(���. ������)
      AddStrField(LocalDataBaseHead,  'PMEDICALN',254); //�������� ����������� ����������(���. ������)
      AddStrField(LocalDataBaseHead,  'AMBULANCE',50);  //� ����������� (���. ������)
      AddStrField(LocalDataBaseHead,  'MEDICSP',254);   //��� ����� (���. ������)
      AddStrField(LocalDataBaseHead,  'INVNUMSP',50);   //����� ������� (���. ������)
      AddDateField(LocalDataBaseHead, 'OPERDATESP');   //���� ������� (���. ������)
      //***15.06.17
      AddIntField(LocalDataBaseHead,  'SPKINDID');     //Id ��� ��
      //***02.02.18
      AddIntField(LocalDataBaseHead,  'PROMOCODE');  //Id ���������
      //***28.06.18
      AddIntField(LocalDataBaseHead,  'MANUALDISC');  //������ ������
      //***02.10.18
      AddFloatField(LocalDataBaseHead,  'SUMMPAYADD');  //������� �� ����
      //***14.01.19
      AddIntField(LocalDataBaseHead,  'MEMBERSPID');  //��� ��������
      //***14.01.19
      AddBoolField(LocalDataBaseHead,  'SITEDISC');  //������� ����� ����
      //***20.02.19
      AddIntField(LocalDataBaseHead,  'BANKPOS');  //���� POS ���������
      //***25.02.19
      AddIntField(LocalDataBaseHead,  'JACKCHECK');  //�����
      //***02.04.19
      AddBoolField(LocalDataBaseHead,  'ROUNDDOWN');  //���������� � ���
      //***13.05.19
      AddIntField(LocalDataBaseHead,  'PDKINDID');    //��� ����/�� ����
      AddStrField(LocalDataBaseHead,  'CONFCODESP', 10); //��� ������������� �������

      LocalDataBaseHead.CreateTable;
    end
    // !!!��������� ����� ����
    else
      with LocalDataBaseHead do
      begin
        LFieldDefs := TVKDBFFieldDefs.Create(Owner);
        Open;

        if FindField('DISCOUNTID') = nil then
          AddIntField(LFieldDefs, 'DISCOUNTID');
        if FindField('DISCOUNTN') = nil then
          AddStrField(LFieldDefs, 'DISCOUNTN', 254);
        if FindField('DISCOUNT') = nil then
          AddStrField(LFieldDefs, 'DISCOUNT', 50);
        //***16.08.16
        if FindField('BAYERPHONE') = nil then
          AddStrField(LFieldDefs, 'BAYERPHONE', 50);
        //***16.08.16
        if FindField('CONFIRMED') = nil then
          AddStrField(LFieldDefs, 'CONFIRMED', 50);
        //***16.08.16
        if FindField('NUMORDER') = nil then
          AddStrField(LFieldDefs, 'NUMORDER', 50);
        //***25.08.16
        if FindField('CONFIRMEDC') = nil then
          AddStrField(LFieldDefs, 'CONFIRMEDC', 50);
        //***24.01.17
        if FindField('USERSESION') = nil then
          AddStrField(LFieldDefs, 'USERSESION', 50);
        //***08.04.17
        if FindField('PMEDICALID') = nil then
          AddIntField(LFieldDefs, 'PMEDICALID');
        if FindField('PMEDICALN') = nil then
          AddStrField(LFieldDefs, 'PMEDICALN', 254);
        if FindField('AMBULANCE') = nil then
          AddStrField(LFieldDefs, 'AMBULANCE', 55);
        if FindField('MEDICSP') = nil then
          AddStrField(LFieldDefs, 'MEDICSP', 254);
        if FindField('INVNUMSP') = nil then
          AddStrField(LFieldDefs, 'INVNUMSP', 55);
        if FindField('OPERDATESP') = nil then
          AddDateField(LFieldDefs, 'OPERDATESP');
        //***15.06.17
        if FindField('SPKINDID') = nil then
          AddIntField(LFieldDefs, 'SPKINDID');
        //***02.02.18
        if FindField('PROMOCODE') = nil then
          AddIntField(LFieldDefs, 'PROMOCODE');
        //***28.06.18
        if FindField('MANUALDISC') = nil then
          AddIntField(LFieldDefs, 'MANUALDISC');
        //***02.10.18
        if FindField('SUMMPAYADD') = nil then
          AddFloatField(LFieldDefs,  'SUMMPAYADD');
        //***14.01.19
        if FindField('MEMBERSPID') = nil then
          AddIntField(LFieldDefs,  'MEMBERSPID');
        //***28.01.19
        if FindField('SITEDISC') = nil then
          AddBoolField(LFieldDefs,  'SITEDISC');
        //***20.02.19
        if FindField('BANKPOS') = nil then
          AddIntField(LFieldDefs,  'BANKPOS');
        //***25.02.19
        if FindField('JACKCHECK') = nil then
          AddIntField(LFieldDefs,  'JACKCHECK');
        //***02.04.19
        if FindField('ROUNDDOWN') = nil then
          AddBoolField(LFieldDefs,  'ROUNDDOWN');
        //***13.05.19
        if FindField('PDKINDID') = nil then
          AddIntField(LFieldDefs,  'PDKINDID'); //��� ����/�� ����
        if FindField('CONFCODESP') = nil then
          AddStrField(LFieldDefs, 'CONFCODESP', 55);

        if LFieldDefs.Count <> 0 then
          AddFields(LFieldDefs, 1000);

        Close;
      end;// !!!��������� ����� ����

    //�������� ���������
    with LocalDataBaseHead do
    begin
      Open;

      Result := not ((FindField('ID') = nil) or
        (FindField('UID') = nil) or
        (FindField('DATE') = nil) or
        (FindField('PAIDTYPE') = nil) or
        (FindField('CASH') = nil) or
        (FindField('MANAGER') = nil) or
        (FindField('BAYER') = nil) or
        (FindField('COMPL') = nil) or
        (FindField('SAVE') = nil) or
        (FindField('NEEDCOMPL') = nil) or
        (FindField('NOTMCS') = nil) or
        (FindField('FISCID') = nil) or
        //***20.07.16
        (FindField('DISCOUNTID') = nil) or
        (FindField('DISCOUNTN') = nil) or
        (FindField('DISCOUNT') = nil) or
        //***16.08.16
        (FindField('BAYERPHONE') = nil) or
        (FindField('CONFIRMED') = nil) or
        (FindField('NUMORDER') = nil) or
        (FindField('CONFIRMEDC') = nil) or
        //***24.01.17
        (FindField('USERSESION') = nil) or
        //***08.04.17
        (FindField('PMEDICALID') = nil) or
        (FindField('PMEDICALN') = nil) or
        (FindField('AMBULANCE') = nil) or
        (FindField('MEDICSP') = nil) or
        (FindField('INVNUMSP') = nil) or
        (FindField('OPERDATESP') = nil) or
        //***15.06.17
        (FindField('SPKINDID') = nil) or
        //***02.02.18
        (FindField('PROMOCODE') = nil) or
        //***28.06.18
        (FindField('MANUALDISC') = nil) or
        //***02.10.18
        (FindField('SUMMPAYADD') = nil) or
        //***14.01.19
        (FindField('MEMBERSPID') = nil) or
        //***14.01.19
        (FindField('SITEDISC') = nil) or
        //***20.02.19
        (FindField('BANKPOS') = nil) or
        //***25.02.19
        (FindField('JACKCHECK') = nil) or
        //***02.04.19
        (FindField('ROUNDDOWN') = nil) or
        //***13.05.19
        (FindField('PDKINDID') = nil) or
        (FindField('CONFCODESP') = nil));

      Close;

      if not Result then
        MessageDlg('�������� ��������� ����� ���������� ��������� (' + DBFFileName + ')',
          mtError, [mbOk], 0);
    end;
  except
    on E: Exception do
    begin
      Result := False;
      Application.OnException(Application.MainForm, E);
    end;
  end;
end;

function InitLocalDataBaseBody(Owner: TPersistent; LocalDataBaseBody: TVKSmartDBF): Boolean;
var
  LFieldDefs: TVKDBFFieldDefs;
begin
  InitLocalTable(LocalDataBaseBody, iniLocalDataBaseBody);

  try
    if (not FileExists(iniLocalDataBaseBody)) then
    begin
      AddIntField(LocalDataBaseBody,   'ID'); //id ������
      AddStrField(LocalDataBaseBody,   'CH_UID', 50); //uid ����
      AddIntField(LocalDataBaseBody,   'GOODSID'); //�� ������
      AddIntField(LocalDataBaseBody,   'GOODSCODE'); //��� ������
      AddStrField(LocalDataBaseBody,   'GOODSNAME', 254); //������������ ������
      AddFloatField(LocalDataBaseBody, 'NDS'); //��� ������
      AddFloatField(LocalDataBaseBody, 'AMOUNT'); //���-��
      AddFloatField(LocalDataBaseBody, 'PRICE'); //����, � 20.07.16 ���� ���� ������ �� ������� ��������, ����� ����� ���� � ������ ������
      //***20.07.16
      AddFloatField(LocalDataBaseBody, 'PRICESALE'); //���� ��� ������
      AddFloatField(LocalDataBaseBody, 'CHPERCENT'); //% ������
      AddFloatField(LocalDataBaseBody, 'SUMMCH');    //����� ������
      //***19.08.16
      AddFloatField(LocalDataBaseBody, 'AMOUNTORD'); //���-�� ������
      //***10.08.16
      AddStrField(LocalDataBaseBody,   'LIST_UID', 50); //UID ������ �������

      LocalDataBaseBody.CreateTable;
    end
    // !!!��������� ����� ����
    else
      with LocalDataBaseBody do
      begin
        LFieldDefs := TVKDBFFieldDefs.Create(Owner);
        Open;

        if FindField('PRICESALE') = nil then
          AddFloatField(LFieldDefs, 'PRICESALE');
        if FindField('CHPERCENT') = nil then
          AddFloatField(LFieldDefs, 'CHPERCENT');
        if FindField('SUMMCH') = nil then
          AddFloatField(LFieldDefs, 'SUMMCH');
        //***19.08.16
        if FindField('AMOUNTORD') = nil then
          AddFloatField(LFieldDefs, 'AMOUNTORD');
        //***10.08.16
        if FindField('LIST_UID') = nil then
          AddStrField(LFieldDefs, 'LIST_UID', 50);

        if LFieldDefs.Count <> 0 then
          AddFields(LFieldDefs, 1000);

        Close;
      end; // !!!��������� ����� ����

    with LocalDataBaseBody do
    begin
      Open;

      Result := not ((FindField('ID') = nil) or
        (FindField('CH_UID') = nil) or
        (FindField('GOODSID') = nil) or
        (FindField('GOODSCODE') = nil) or
        (FindField('GOODSNAME') = nil) or
        (FindField('NDS') = nil) or
        (FindField('AMOUNT') = nil) or
        (FindField('PRICE') = nil) or
        //***20.07.16
        (FindField('PRICESALE') = nil) or
        (FindField('CHPERCENT') = nil) or
        (FindField('SUMMCH') = nil) or
        //***19.08.16
        (FindField('AMOUNTORD') = nil) or
        //***10.08.16
        (FindField('LIST_UID') = nil));

      Close;

      if not Result then
        MessageDlg('�������� ��������� ����� ���������� ��������� (' + DBFFileName + ')',
          mtError, [mbOk], 0);
    end;
  except
    on E: Exception do
    begin
      Result := False;
      Application.OnException(Application.MainForm, E);
    end;
  end;
end;

function InitLocalDataBaseDiff(Owner: TPersistent; LocalDataBaseDiff: TVKSmartDBF): Boolean;
begin
  InitLocalTable(LocalDataBaseDiff, iniLocalDataBaseDiff);

  try
    if (not FileExists(iniLocalDataBaseDiff)) then
    begin
      AddIntField(LocalDataBaseDiff,   'ID'); //id ������
      AddIntField(LocalDataBaseDiff,   'GOODSCODE'); //��� ������
      AddStrField(LocalDataBaseDiff,   'GOODSNAME',254); //������������ ������
      AddFloatField(LocalDataBaseDiff, 'PRICE'); //����
      AddFloatField(LocalDataBaseDiff, 'REMAINS'); // �������
      AddFloatField(LocalDataBaseDiff, 'MCSVALUE'); //
      AddFloatField(LocalDataBaseDiff, 'RESERVED'); //
      AddDateField(LocalDataBaseDiff,  'MEXPDATE'); //���� ��������
      AddIntField(LocalDataBaseDiff,   'PDKINDID'); //��� ����/�� ����
      AddStrField(LocalDataBaseDiff,   'PDKINDNAME',100); //������������ ���� ����/�� ����
      AddBoolField(LocalDataBaseDiff,  'NEWROW'); //
      AddIntField(LocalDataBaseDiff,   'ACCOMID'); //
      AddStrField(LocalDataBaseDiff,   'ACCOMNAME',20); //������������ ������������
      AddIntField(LocalDataBaseDiff,   'COLORCALC'); //����

      LocalDataBaseDiff.CreateTable;
    end;

    // �������� ���������
    with LocalDataBaseDiff do
    begin
      Open;

      Result := not ((FindField('ID') = nil) or
        (FindField('GOODSCODE') = nil) or
        (FindField('GOODSNAME') = nil) or
        (FindField('PRICE') = nil) or
        (FindField('REMAINS') = nil) or
        (FindField('MCSVALUE') = nil) or
        (FindField('RESERVED') = nil) or
        (FindField('NEWROW') = nil) or
        (FindField('ACCOMID') = nil) or
        (FindField('ACCOMNAME') = nil) or
        (FindField('MEXPDATE') = nil) or
        (FindField('PDKINDID') = nil) or
        (FindField('PDKINDNAME') = nil) or
        (FindField('COLORCALC') = nil));

      Close;

      if not Result then
        MessageDlg('�������� ��������� ����� ���������� ��������� (' + DBFFileName + ')',
          mtError, [mbOk], 0);
    end;
  except
    on E: Exception do
    begin
      Result := False;
      Application.OnException(Application.MainForm, E);
    end;
  end;
end;

end.
