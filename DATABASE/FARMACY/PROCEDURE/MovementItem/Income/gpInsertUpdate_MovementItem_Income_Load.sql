DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, TDateTime, 
           Boolean,
           TVarChar,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, TDateTime, 
           Boolean,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TVarChar,
           Boolean,
           TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TFloat, 
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TFloat, 
           TVarChar,
           TVarChar,
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TFloat, 
           TVarChar,
           TVarChar,
           TVarChar,
           TVarChar,
           TVarChar,
           TDateTime, 
           TDateTime, 
           Boolean,
           TVarChar);
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_Load(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    
    IN inCommonCode          Integer   , -- ID внешний (например Морион)
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , -- ID товара
    IN inGoodsName           TVarChar  , -- Наименование товара
    IN inAmount              TFloat    , -- Количество 
    IN inPrice               TFloat    , -- Цена Отпускная (для аптеки это закупочная) 
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inPartitionGoods      TVarChar  , -- Номер серии   
    IN inPaymentDate         TDateTime , -- Дата оплаты
    IN inPriceWithVAT        Boolean   , -- Признак: цена включает НДС или не вкл.НДС
    IN inVAT                 TFloat    , -- Процент НДС
    IN inUnitName            TVarChar  , 
    IN inMakerName           TVarChar  , -- Наименование производителя
    IN inFEA                 TVarChar  , -- УК ВЭД
    IN inMeasure             TVarChar  , -- Ед. измерения
    IN inSertificatNumber    TVarChar  , -- Номер регистрации
    IN inSertificatStart     TDateTime , -- Дата начала регистрации
    IN inSertificatEnd       TDateTime , -- Дата окончания регистрации
    
    IN inisLastRecord        Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbPartnerGoodsId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbNDSKindId Integer;
   DECLARE vbContractId Integer;
BEGIN
	
     -- определяется <Пользователь>
     vbUserId := lpGetUserBySession (inSession);


         -- Ищем подразделение и Договор. Два в одном
         SELECT tmp.ContractId, tmp.UnitId
                INTO vbContractId, vbUnitId
         FROM (WITH tmpList AS (SELECT Object_ImportExportLink_View.ValueId                                       AS ContractId -- здесь Договор
                                     , Object_ImportExportLink_View.MainId                                        AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink_View.StringKey)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 3)) AS StringKey3
                                FROM Object_Contract_View
                                     INNER JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.ValueId = Object_Contract_View.Id
                                WHERE Object_Contract_View.JuridicalId = inJuridicalId
                               )
               -- почти результат
               SELECT tmpList.ContractId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> '')
              ) AS tmp;


     -- если не нашли - Ищем подразделение по Юрлицу, а вот Договор - будет потом...
     IF COALESCE (vbUnitId, 0) = 0
     THEN

         SELECT tmp.UnitId
                INTO vbUnitId
         FROM (WITH tmpList AS (SELECT Object_ImportExportLink_View.ValueId                                       AS JuridicalId -- здесь Юр.Лицо
                                     , Object_ImportExportLink_View.MainId                                        AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink_View.StringKey)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink_View.StringKey, '%', 3)) AS StringKey3
                                FROM Object_ImportExportLink_View
                                WHERE Object_ImportExportLink_View.ValueId = inJuridicalId
                               )
               -- почти результат
               SELECT tmpList.JuridicalId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = '')
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> '')
              ) AS tmp;

    END IF;


    -- Если не нашли, то сразу ругнемся. !!!Подразделение должно быть!!!
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION 'Для значения <%> по Юр.лицу <%> не найдено Подразделение.', inUnitName, lfGet_Object_ValueData (inJuridicalId);
    END IF;


     -- !!!только НЕ так определяется <Торговая сеть>!!!
     -- vbObjectId:= lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- !!!только так - определяется <Торговая сеть>!!!
     vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  );
    -- Если не нашли, то сразу ругнемся.
    IF COALESCE (vbObjectId, 0) = 0
    THEN
        RAISE EXCEPTION 'У подразделения <%> не установлено значение <Торговая сеть>.', lfGet_Object_ValueData (vbUnitId);
    END IF;


     -- Ищем документ по дате, номеру, юр лицу
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId)
       SELECT Movement.Id, Movement.StatusId
              INTO vbMovementId, vbStatusId
       FROM tmpStatus
            JOIN Movement ON Movement.OperDate = inOperDate 
                         AND Movement.DescId = zc_Movement_Income() 
                         AND Movement.StatusId = tmpStatus.StatusId
                         AND Movement.InvNumber = inInvNumber
            JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                   AND MovementLinkObject_From.ObjectId = inJuridicalId
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();


     -- Аж вот тут мы будем менять, если документа нет или НДС определен точно
     IF COALESCE (vbMovementId, 0) = 0
     THEN
       -- продолжаем искать договор      
       IF COALESCE(vbContractId, 0) = 0 THEN
        -- А вот тут попытка угадать договор.
          -- Если даты не равны, то ищем любой договор с отсрочкой платежа
          IF inPaymentDate is null or inPaymentDate > (inOperDate + interval '1 day') THEN
             SELECT MAX(Id) INTO vbContractId 
     	       FROM Object_Contract_View 
              WHERE Object_Contract_View.JuridicalId = inJuridicalId AND COALESCE(Deferment, 0) <> 0;
          ELSE
          -- иначе любой договор без отсрочки платежа
             SELECT MAX(Id) INTO vbContractId 
               FROM Object_Contract_View 
              WHERE Object_Contract_View.JuridicalId = inJuridicalId AND COALESCE(Deferment, 0) = 0;
          END IF;	     	

          -- Ищем хоть какой-нить договор
          IF COALESCE(vbContractId, 0) = 0 THEN 
             SELECT MAX(Id) INTO vbContractId 
               FROM Object_Contract_View 
              WHERE Object_Contract_View.JuridicalId = inJuridicalId;
          END IF;
       END IF;
       --Если дата оплаты пустая - то вытягиваем её из договора
       IF inPaymentDate is Null or inPaymentDate = '19000101'::TDateTime
       THEN
           SELECT
               inOperDate::Date + COALESCE(Deferment, 0)::Integer
           INTO
               inPaymentDate
           FROM
               Object_Contract_View
           WHERE
               Object_Contract_View.Id = vbContractId;
       END IF;
       IF inPaymentDate IS NULL
       THEN
           inPaymentDate := inOperDate;
       END IF;
       -- определяем НДС
       SELECT Id INTO vbNDSKindId 
         FROM Object_NDSKind_View
         WHERE NDS = inVAT;
      
       IF COALESCE(vbNDSKindId, 0) = 0 THEN 

       END IF;

       vbMovementId := lpInsertUpdate_Movement_Income(vbMovementId, inInvNumber, inOperDate, inPriceWithVAT, 
                                                      inJuridicalId, vbUnitId, vbNDSKindId
                                                     ,inContractId := vbContractId 
                                                     ,inPaymentDate := inPaymentDate
                                                     ,inJuridicalId := (Select ObjectLink.ChildObjectId 
                                                                        from ObjectLink 
                                                                        Where ObjectLink.ObjectId = vbUnitId
                                                                          AND ObjectLink.DescId = zc_ObjectLink_Unit_Juridical())
                                                     ,inUserId := vbUserId);
     END IF;



  -- Ищем товар 
      SELECT Goods_Juridical.Id INTO vbPartnerGoodsId
        FROM Object_Goods_View AS Goods_Juridical

       WHERE Goods_Juridical.ObjectId = inJuridicalId AND Goods_Juridical.GoodsCode = inGoodsCode;
  
    --Если вдруг такого нет, то мы его ОБЯЗАТЕЛЬНО добавляем. БЕЗ проверки на уникальность
     IF COALESCE(vbPartnerGoodsId, 0) = 0 THEN
        vbPartnerGoodsId := lpInsertUpdate_Object_Goods(0, inGoodsCode, inGoodsName, NULL, NULL, NULL, inJuridicalId, vbUserId, NULL, inMakerName, false);    
     END IF;
 
  -- Ищем товар для накладной. 
      SELECT Goods_Retail.GoodsId, Object_Goods_View.NDSKindId INTO vbGoodsId, vbNDSKindId
        FROM Object_LinkGoods_View AS Goods_Juridical
        LEFT JOIN Object_LinkGoods_View AS Goods_Retail ON Goods_Retail.GoodsMainId = Goods_Juridical.GoodsMainId
                                                  AND Goods_Retail.ObjectId = vbObjectId
        LEFT JOIN Object_Goods_View ON Goods_Retail.GoodsId = Object_Goods_View.Id                                          

       WHERE Goods_Juridical.GoodsId = vbPartnerGoodsId;

  -- Ищем товар в документе. Пока ключи: код поставщика, документ, цена, партия, срок годности. 
     SELECT MovementItem.Id INTO vbMovementItemId
       FROM MovementItem_Income_View AS MovementItem
        
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.PartnerGoodsId = vbPartnerGoodsId
        AND MovementItem.Price = inPrice--MovementItem.Price
        AND MovementItem.PartionGoods = inPartitionGoods
        AND MovementItem.ExpirationDate = inExpirationDate;
  
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem_Income (vbMovementItemId, vbMovementId, vbGoodsId, inAmount, inPrice, inFEA, inMeasure, vbUserId);

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), vbMovementItemId, vbPartnerGoodsId);

     -- Срок годности заодно влепим
     IF NOT (inExpirationDate IS NULL) THEN 
        -- сохранили свойство <Срок годности>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), vbMovementItemId, inExpirationDate);
     END IF;

     -- Ну и серию, если есть 
     IF COALESCE(inPartitionGoods, '') <> '' THEN 
        -- сохранили свойство <Серия>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), vbMovementItemId, inPartitionGoods);
     END IF;
     
    -- Если есть то рег номер
     IF COALESCE(inSertificatNumber, '') <> '' THEN 
        -- сохранили свойство <Номер регистрации>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_SertificatNumber(), vbMovementItemId, inSertificatNumber);
     END IF;
    -- Если есть до дату начала регистрации
     IF inSertificatStart is not null THEN 
        -- сохранили свойство <Дата начала регистрации>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatStart(), vbMovementItemId, inSertificatStart);
     END IF;
    -- Если есть до дату окончания регистрации
     IF inSertificatEnd is not null THEN 
        -- сохранили свойство <Дата окончания регистрации>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatEnd(), vbMovementItemId, inSertificatEnd);
     END IF;

     IF inisLastRecord THEN
        -- пересчитали Итоговые суммы
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 01.10.15                                                                      * inSertificatNumber, inSertificatStart, inSertificatEnd
 14.01.15                        *   
 08.01.15                        *   
 29.12.14                        *   
 26.12.14                        *   
 25.12.14                        *   
 02.12.14                        *   
*/
