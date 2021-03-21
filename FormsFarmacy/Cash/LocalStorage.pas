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
      AddIntField(LocalDataBaseHead,  'ID');//id чека
      AddStrField(LocalDataBaseHead,  'UID',50);//uid чека
      AddDateField(LocalDataBaseHead, 'DATE'); //дата/Время чека
      AddIntField(LocalDataBaseHead,  'PAIDTYPE'); //тип оплаты
      AddStrField(LocalDataBaseHead,  'CASH',20); //серийник аппарата
      AddIntField(LocalDataBaseHead,  'MANAGER'); //Id Менеджера (VIP)
      AddStrField(LocalDataBaseHead,  'BAYER',254); //Покупатель (VIP)
      AddBoolField(LocalDataBaseHead, 'SAVE'); //Покупатель (VIP)
      AddBoolField(LocalDataBaseHead, 'COMPL'); //Покупатель (VIP)
      AddBoolField(LocalDataBaseHead, 'NEEDCOMPL'); //нужно провести документ
      AddBoolField(LocalDataBaseHead, 'NOTMCS'); //Не участвует в расчете НТЗ
      AddStrField(LocalDataBaseHead,  'FISCID',50); //Номер фискального чека
      //***20.07.16
      AddIntField(LocalDataBaseHead,  'DISCOUNTID');    //Id Проекта дисконтных карт
      AddStrField(LocalDataBaseHead,  'DISCOUNTN',254); //Название Проекта дисконтных карт
      AddStrField(LocalDataBaseHead,  'DISCOUNT',50);   //№ Дисконтной карты
      //***16.08.16
      AddStrField(LocalDataBaseHead,  'BAYERPHONE',50); //Контактный телефон (Покупателя) - BayerPhone
      AddStrField(LocalDataBaseHead,  'CONFIRMED',50);  //Статус заказа (Состояние VIP-чека) - ConfirmedKind
      AddStrField(LocalDataBaseHead,  'NUMORDER',50);   //Номер заказа (с сайта) - InvNumberOrder
      AddStrField(LocalDataBaseHead,  'CONFIRMEDC',50); //Статус заказа (Состояние VIP-чека) - ConfirmedKindClient
      //***24.01.17
      AddStrField(LocalDataBaseHead,  'USERSESION',50); //Для сервиса - реальная сесия при продаже
      //***08.04.17
      AddIntField(LocalDataBaseHead,  'PMEDICALID');    //Id Медицинское учреждение(Соц. проект)
      AddStrField(LocalDataBaseHead,  'PMEDICALN',254); //Название Медицинское учреждение(Соц. проект)
      AddStrField(LocalDataBaseHead,  'AMBULANCE',50);  //№ амбулатории (Соц. проект)
      AddStrField(LocalDataBaseHead,  'MEDICSP',254);   //ФИО врача (Соц. проект)
      AddStrField(LocalDataBaseHead,  'INVNUMSP',50);   //номер рецепта (Соц. проект)
      AddDateField(LocalDataBaseHead, 'OPERDATESP');   //дата рецепта (Соц. проект)
      //***15.06.17
      AddIntField(LocalDataBaseHead,  'SPKINDID');     //Id Вид СП
      //***02.02.18
      AddIntField(LocalDataBaseHead,  'PROMOCODE');  //Id промокода
      //***28.06.18
      AddIntField(LocalDataBaseHead,  'MANUALDISC');  //Ручная скидка
      //***02.10.18
      AddFloatField(LocalDataBaseHead,  'SUMMPAYADD');  //Доплата по чеку
      //***14.01.19
      AddIntField(LocalDataBaseHead,  'MEMBERSPID');  //ФИО пациента
      //***14.01.19
      AddBoolField(LocalDataBaseHead,  'SITEDISC');  //Дисконт через сайт
      //***20.02.19
      AddIntField(LocalDataBaseHead,  'BANKPOS');  //Банк POS терминала
      //***25.02.19
      AddIntField(LocalDataBaseHead,  'JACKCHECK');  //Галка
      //***02.04.19
      AddBoolField(LocalDataBaseHead,  'ROUNDDOWN');  //Округление в низ
      //***13.05.19
      AddIntField(LocalDataBaseHead,  'PDKINDID');    //Тип срок/не срок
      AddStrField(LocalDataBaseHead,  'CONFCODESP', 10); //Код подтверждения рецепта
      //***07.11.19
      AddIntField(LocalDataBaseHead,  'LOYALTYID');    //Программа лояльности
      //***08.01.20
      AddIntField(LocalDataBaseHead,  'LOYALTYSM');    //Программа лояльности накопительная
      AddFloatField(LocalDataBaseHead,'LOYALSMSUM');   //Сумма скидки по Программа лояльности накопительная
      //***11.10.20
      AddStrField(LocalDataBaseHead,  'MEDICFS', 100); //ФИО врача (на продажу)
      AddStrField(LocalDataBaseHead,  'BUYERFS', 100); //ФИО покупателя (на продажу)
      AddStrField(LocalDataBaseHead,  'BUYERFSP', 100); //Телефон покупателя (на продажу)
      AddStrField(LocalDataBaseHead,  'DISTPROMO', 254); //Раздача акционных материалов
      //***05.03.21
      AddIntField(LocalDataBaseHead,  'MEDICKID');     //ФИО врача (МИС «Каштан»)
      AddIntField(LocalDataBaseHead,  'MEMBERKID');    //ФИО пациента (МИС «Каштан»)
      //***10.03.21
      AddBoolField(LocalDataBaseHead, 'ISCORRMARK');   //Корректировка суммы маркетинг в ЗП по подразделению

      LocalDataBaseHead.CreateTable;
    end
    // !!!добавляем НОВЫЕ поля
    else
      with LocalDataBaseHead do
      begin
        LFieldDefs := TVKDBFFieldDefs.Create(Owner);
        Open;

        if FindField('DISCOUNTID') = nil then AddIntField(LFieldDefs, 'DISCOUNTID');
        if FindField('DISCOUNTN') = nil then AddStrField(LFieldDefs, 'DISCOUNTN', 254);
        if FindField('DISCOUNT') = nil then AddStrField(LFieldDefs, 'DISCOUNT', 50);
        //***16.08.16
        if FindField('BAYERPHONE') = nil then AddStrField(LFieldDefs, 'BAYERPHONE', 50);
        //***16.08.16
        if FindField('CONFIRMED') = nil then AddStrField(LFieldDefs, 'CONFIRMED', 50);
        //***16.08.16
        if FindField('NUMORDER') = nil then AddStrField(LFieldDefs, 'NUMORDER', 50);
        //***25.08.16
        if FindField('CONFIRMEDC') = nil then AddStrField(LFieldDefs, 'CONFIRMEDC', 50);
        //***24.01.17
        if FindField('USERSESION') = nil then AddStrField(LFieldDefs, 'USERSESION', 50);
        //***08.04.17
        if FindField('PMEDICALID') = nil then AddIntField(LFieldDefs, 'PMEDICALID');
        if FindField('PMEDICALN') = nil then AddStrField(LFieldDefs, 'PMEDICALN', 254);
        if FindField('AMBULANCE') = nil then AddStrField(LFieldDefs, 'AMBULANCE', 55);
        if FindField('MEDICSP') = nil then AddStrField(LFieldDefs, 'MEDICSP', 254);
        if FindField('INVNUMSP') = nil then AddStrField(LFieldDefs, 'INVNUMSP', 55);
        if FindField('OPERDATESP') = nil then AddDateField(LFieldDefs, 'OPERDATESP');
        //***15.06.17
        if FindField('SPKINDID') = nil then AddIntField(LFieldDefs, 'SPKINDID');
        //***02.02.18
        if FindField('PROMOCODE') = nil then AddIntField(LFieldDefs, 'PROMOCODE');
        //***28.06.18
        if FindField('MANUALDISC') = nil then AddIntField(LFieldDefs, 'MANUALDISC');
        //***02.10.18
        if FindField('SUMMPAYADD') = nil then AddFloatField(LFieldDefs,  'SUMMPAYADD');
        //***14.01.19
        if FindField('MEMBERSPID') = nil then AddIntField(LFieldDefs,  'MEMBERSPID');
        //***28.01.19
        if FindField('SITEDISC') = nil then AddBoolField(LFieldDefs,  'SITEDISC');
        //***20.02.19
        if FindField('BANKPOS') = nil then AddIntField(LFieldDefs,  'BANKPOS');
        //***25.02.19
        if FindField('JACKCHECK') = nil then AddIntField(LFieldDefs,  'JACKCHECK');
        //***02.04.19
        if FindField('ROUNDDOWN') = nil then AddBoolField(LFieldDefs,  'ROUNDDOWN');
        //***13.05.19
        if FindField('PDKINDID') = nil then AddIntField(LFieldDefs,  'PDKINDID'); //Тип срок/не срок
        if FindField('CONFCODESP') = nil then AddStrField(LFieldDefs, 'CONFCODESP', 55);
        //***07.11.19
        if FindField('LOYALTYID') = nil then AddIntField(LFieldDefs,  'LOYALTYID');  //Программа лояльности
        //***08.01.20
        if FindField('LOYALTYSM') = nil then AddIntField(LFieldDefs,  'LOYALTYSM');  //Программа лояльности накопительная
        if FindField('LOYALSMSUM') = nil then AddFloatField(LFieldDefs,  'LOYALSMSUM');
        //***11.10.20
        if FindField('MEDICFS') = nil then AddStrField(LFieldDefs, 'MEDICFS', 100);
        if FindField('BUYERFS') = nil then AddStrField(LFieldDefs, 'BUYERFS', 100);
        if FindField('BUYERFSP') = nil then AddStrField(LFieldDefs, 'BUYERFSP', 100);
        //***04.12.20
        if FindField('DISTPROMO') = nil then AddStrField(LFieldDefs, 'DISTPROMO', 254);
        //***05.03.21
        if FindField('MEDICKID') = nil then AddIntField(LFieldDefs,    'MEDICKID');      //ФИО врача (МИС «Каштан»)
        if FindField('MEMBERKID') = nil then AddIntField(LFieldDefs,   'MEMBERKID');    //ФИО пациента (МИС «Каштан»)
        //***10.03.21
        if FindField('ISCORRMARK') = nil then AddBoolField(LFieldDefs, 'ISCORRMARK');    //Корректировка суммы маркетинг в ЗП по подразделению

        if LFieldDefs.Count <> 0 then
          AddFields(LFieldDefs, 1000);

        Close;
      end;// !!!добавляем НОВЫЕ поля

    //проверка структуры
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
        (FindField('CONFCODESP') = nil) or
        //***07.11.19
        (FindField('LOYALTYID') = nil) or
        //***08.01.20
        (FindField('LOYALTYSM') = nil) or
        (FindField('LOYALSMSUM') = nil) or
        //***11.10.20
        (FindField('MEDICFS') = nil) or
        (FindField('BUYERFS') = nil) or
        (FindField('BUYERFSP') = nil) or
        (FindField('DISTPROMO') = nil) or
        //***05.03.21
        (FindField('MEDICKID') = nil) or
        (FindField('MEMBERKID') = nil) or
        //***10.03.21
        (FindField('ISCORRMARK') = nil));

      Close;

      if not Result then
        MessageDlg('Неверная структура файла локального хранилища (' + DBFFileName + ')',
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
      AddIntField(LocalDataBaseBody,   'ID'); //id записи
      AddStrField(LocalDataBaseBody,   'CH_UID', 50); //uid чека
      AddIntField(LocalDataBaseBody,   'GOODSID'); //ид товара
      AddIntField(LocalDataBaseBody,   'GOODSCODE'); //Код товара
      AddStrField(LocalDataBaseBody,   'GOODSNAME', 254); //наименование товара
      AddFloatField(LocalDataBaseBody, 'NDS'); //НДС товара
      AddFloatField(LocalDataBaseBody, 'AMOUNT'); //Кол-во
      AddFloatField(LocalDataBaseBody, 'PRICE'); //Цена, с 20.07.16 если есть скидка по Проекту дисконта, здесь будет цена с учетом скидки
      //***20.07.16
      AddFloatField(LocalDataBaseBody, 'PRICESALE'); //Цена без скидки
      AddFloatField(LocalDataBaseBody, 'CHPERCENT'); //% Скидки
      AddFloatField(LocalDataBaseBody, 'SUMMCH');    //Сумма Скидки
      //***19.08.16
      AddFloatField(LocalDataBaseBody, 'AMOUNTORD'); //Кол-во заявка
      //***10.08.16
      AddStrField(LocalDataBaseBody,   'LIST_UID', 50); //UID строки продажи
      //***03.06.19
      AddIntField(LocalDataBaseBody,   'PDKINDID');    //Тип срок/не срок
      //***24.06.19
      AddFloatField(LocalDataBaseBody, 'PRICEPD');    //Отпускная цена согласно партии
      //***15.04.20
      AddIntField(LocalDataBaseBody,   'NDSKINDID'); //Ставка НДС
      //***19.06.20
      AddIntField(LocalDataBaseBody,   'DISCEXTID'); //Дисконтная программы
      //***19.06.20
      AddIntField(LocalDataBaseBody,   'DIVPARTID'); //Разделение партий в кассе для продажи
      //***02.10.20
      AddBoolField(LocalDataBaseBody,  'ISPRESENT'); //Подарок

      LocalDataBaseBody.CreateTable;
    end
    // !!!добавляем НОВЫЕ поля
    else
      with LocalDataBaseBody do
      begin
        LFieldDefs := TVKDBFFieldDefs.Create(Owner);
        Open;

        if FindField('PRICESALE') = nil then AddFloatField(LFieldDefs, 'PRICESALE');
        if FindField('CHPERCENT') = nil then AddFloatField(LFieldDefs, 'CHPERCENT');
        if FindField('SUMMCH') = nil then AddFloatField(LFieldDefs, 'SUMMCH');
        //***19.08.16
        if FindField('AMOUNTORD') = nil then AddFloatField(LFieldDefs, 'AMOUNTORD');
        //***10.08.16
        if FindField('LIST_UID') = nil then AddStrField(LFieldDefs, 'LIST_UID', 50);
        //***03.06.19
        if FindField('PDKINDID') = nil then AddIntField(LFieldDefs, 'PDKINDID');
        //***24.06.19
        if FindField('PRICEPD') = nil then AddFloatField(LFieldDefs, 'PRICEPD');
        //***15.04.20
        if FindField('NDSKINDID') = nil then AddIntField(LFieldDefs, 'NDSKINDID');
        //***19.06.20
        if FindField('DISCEXTID') = nil then AddIntField(LFieldDefs, 'DISCEXTID');
        //***16.08.20
        if FindField('DIVPARTID') = nil then AddIntField(LFieldDefs, 'DIVPARTID');
        //***02.10.20
        if FindField('ISPRESENT') = nil then AddBoolField(LFieldDefs, 'ISPRESENT');

        if LFieldDefs.Count <> 0 then
          AddFields(LFieldDefs, 1000);

        Close;
      end; // !!!добавляем НОВЫЕ поля

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
        (FindField('PDKINDID') = nil) or
        (FindField('PRICEPD') = nil) or
        //***10.08.16
        (FindField('LIST_UID') = nil) or
        //***15.04.20
        (FindField('NDSKINDID') = nil) or
        //***19.06.20
        (FindField('DISCEXTID') = nil) or
        //***16.08.20
        (FindField('DIVPARTID') = nil) or
        //***02.10.20
        (FindField('ISPRESENT') = nil));

      Close;

      if not Result then
        MessageDlg('Неверная структура файла локального хранилища (' + DBFFileName + ')',
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
      AddIntField(LocalDataBaseDiff,   'ID'); //id записи
      AddIntField(LocalDataBaseDiff,   'GOODSCODE'); //Код товара
      AddStrField(LocalDataBaseDiff,   'GOODSNAME',254); //наименование товара
      AddFloatField(LocalDataBaseDiff, 'PRICE'); //Цена
      AddFloatField(LocalDataBaseDiff, 'REMAINS'); // Остатки
      AddFloatField(LocalDataBaseDiff, 'MCSVALUE'); //
      AddFloatField(LocalDataBaseDiff, 'RESERVED'); //
      AddDateField(LocalDataBaseDiff,  'MEXPDATE'); //срок годности
      AddIntField(LocalDataBaseDiff,   'PDKINDID'); //Тип срок/не срок
      AddStrField(LocalDataBaseDiff,   'PDKINDNAME',100); //наименование типа срок/не срок
      AddBoolField(LocalDataBaseDiff,  'NEWROW'); //
      AddIntField(LocalDataBaseDiff,   'ACCOMID'); //
      AddStrField(LocalDataBaseDiff,   'ACCOMNAME',20); //наименование расположения
      AddFloatField(LocalDataBaseDiff, 'AMOUNTMON'); //Месяцев срока
      AddFloatField(LocalDataBaseDiff, 'PRICEPD'); //Отпускная цена согласно партии
      AddIntField(LocalDataBaseDiff,   'COLORCALC'); //цвет
      AddFloatField(LocalDataBaseDiff, 'DEFERENDS'); //В отложенных перемещениях
      AddFloatField(LocalDataBaseDiff, 'REMAINSSUN'); //Остатки SUN
      AddFloatField(LocalDataBaseDiff, 'NDS'); //НДС
      AddIntField(LocalDataBaseDiff,   'NDSKINDID'); //Ставка НДС
      AddIntField(LocalDataBaseDiff,   'DISCEXTID'); //Дисконтная программы
      AddStrField(LocalDataBaseDiff,   'DISCEXTNAM',100); //наименование дисконтной программы
      AddIntField(LocalDataBaseDiff,   'GOODSDIID'); //Дисконтная программы товара
      AddStrField(LocalDataBaseDiff,   'GOODSDINAM',100); //наименование дисконтной программы товара
      AddStrField(LocalDataBaseDiff,   'UKTZED',20); //Код UKTZED
      AddIntField(LocalDataBaseDiff,   'GOODSPSID'); //Парный товар СП
      AddIntField(LocalDataBaseDiff,   'DIVPARTID'); //Тип срок/не срок
      AddStrField(LocalDataBaseDiff,   'DIVPARTNAM',100); //наименование типа срок/не срок
      AddBoolField(LocalDataBaseDiff,  'BANFISCAL'); // Запрет фискальной продажи
      AddBoolField(LocalDataBaseDiff,  'GOODSPROJ'); // Товар только для проекта (дисконтные карты)
      AddIntField(LocalDataBaseDiff,   'GOODSPMID'); //Парный товпр СП главный
      AddFloatField(LocalDataBaseDiff, 'GOODSDIMP'); //Максимальная цена по дисконтной программе

      LocalDataBaseDiff.CreateTable;
    end;

    // Проверка структуры
    with LocalDataBaseDiff do
    begin
      Open;

      Result := not ((FindField('ID') = nil) or
        (FindField('GOODSCODE') = nil) or
        (FindField('GOODSNAME') = nil) or
        (FindField('PRICE') = nil) or
        (FindField('NDS') = nil) or
        (FindField('REMAINS') = nil) or
        (FindField('MCSVALUE') = nil) or
        (FindField('RESERVED') = nil) or
        (FindField('NEWROW') = nil) or
        (FindField('ACCOMID') = nil) or
        (FindField('ACCOMNAME') = nil) or
        (FindField('MEXPDATE') = nil) or
        (FindField('PDKINDID') = nil) or
        (FindField('PDKINDNAME') = nil) or
        (FindField('COLORCALC') = nil) or
        (FindField('DEFERENDS') = nil) or
        (FindField('REMAINSSUN') = nil) or
        (FindField('NDS') = nil) or
        (FindField('NDSKINDID') = nil) or
        (FindField('DISCEXTNAM') = nil) or
        (FindField('GOODSDIID') = nil) or
        (FindField('GOODSDINAM') = nil) or
        (FindField('UKTZED') = nil) or
        (FindField('GOODSPSID') = nil) or
        (FindField('DIVPARTNAM') = nil) or
        (FindField('BANFISCAL') = nil) or
        (FindField('GOODSPROJ') = nil) or
        (FindField('GOODSPMID') = nil) or
        (FindField('GOODSDIMP') = nil));

      Close;

      if not Result then
        MessageDlg('Неверная структура файла локального хранилища (' + DBFFileName + ')',
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
