-- Function: gpInsertUpdate_MovementItem_Income_Load ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load (Integer, Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TDateTime
                                                               , Boolean, TFloat, TVarChar, TVarChar, TVarChar,TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load (Integer, Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TDateTime
                                                               , Boolean, TFloat, TVarChar, TVarChar, TVarChar,TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TVarChar);
                                                               
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_Load(
    IN inJuridicalId_from    Integer   , -- Юридические лица - Поставщик
    IN inJuridicalId_to      Integer   , -- Юридические лица - "Наше"
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

   DECLARE vbAreaId_find Integer;
BEGIN
     -- определяется <Пользователь>
     vbUserId := lpGetUserBySession (inSession);

     --Выбираем договора
     CREATE TEMP TABLE _tmpContract (ContractId Integer, Deferment Integer) ON COMMIT DROP;
          INSERT INTO _tmpContract (ContractId, Deferment)
               SELECT ObjectLink_Contract_Juridical.ObjectId     AS ContractId
                    , ObjectFloat_Deferment.ValueData ::Integer  AS Deferment
               FROM ObjectLink AS ObjectLink_Contract_Juridical
                  LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                        ON ObjectFloat_Deferment.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                       AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
              WHERE ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                AND ObjectLink_Contract_Juridical.ChildObjectId = inJuridicalId_from;

         -- Ищем подразделение и Договор. Два в одном
         SELECT tmp.ContractId, tmp.UnitId
                INTO vbContractId, vbUnitId
         FROM (WITH tmpList AS (SELECT ObjectLink_ObjectChild.ChildObjectId            AS ContractId -- здесь Договор
                                     , ObjectLink_ObjectMain.ChildObjectId                                   AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink.ValueData)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 3)) AS StringKey3
                                FROM _tmpContract
                                     INNER JOIN ObjectLink AS ObjectLink_ObjectChild
                                             ON ObjectLink_ObjectChild.ChildObjectId =  _tmpContract.ContractId               --ObjectLink_ObjectChild.ObjectId = Object_ImportExportLink.Id
                                            AND ObjectLink_ObjectChild.DescId = zc_ObjectLink_ImportExportLink_ObjectChild()

                                     LEFT JOIN Object AS Object_ImportExportLink
                                            ON Object_ImportExportLink.Id = ObjectLink_ObjectChild.ObjectId
                                           AND Object_ImportExportLink.DescId = zc_Object_ImportExportLink()

                                     LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                                            ON ObjectLink_ObjectMain.ObjectId = ObjectLink_ObjectChild.ObjectId
                                           AND ObjectLink_ObjectMain.DescId = zc_ObjectLink_ImportExportLink_ObjectMain()

                                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                            ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_ObjectMain.ChildObjectId -- Object_ImportExportLink_View.MainId
                                           AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                                WHERE (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId_to OR COALESCE (inJuridicalId_to, 0) = 0)
                               )
               -- почти результат
               SELECT tmpList.ContractId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = ''
                      )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> ''
                     )
              ) AS tmp;


     -- если не нашли - Ищем подразделение по Юрлицу, а вот Договор - будет потом...
     IF COALESCE (vbUnitId, 0) = 0
     THEN

         SELECT tmp.UnitId
                INTO vbUnitId
         FROM (WITH tmpList AS (SELECT ObjectLink_ObjectChild.ChildObjectId AS JuridicalId
                                     , ObjectLink_ObjectMain.ChildObjectId  AS UnitId
                                     , LOWER (TRIM (Object_ImportExportLink.ValueData)) :: TVarChar          AS StringKey
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 1)) AS StringKey1
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 2)) AS StringKey2
                                     , LOWER (zfCalc_Word_Split (Object_ImportExportLink.ValueData, '%', 3)) AS StringKey3
                                FROM Object AS Object_ImportExportLink
                                    INNER JOIN ObjectLink AS ObjectLink_ObjectChild
                                            ON ObjectLink_ObjectChild.ObjectId = Object_ImportExportLink.Id
                                           AND ObjectLink_ObjectChild.DescId = zc_ObjectLink_ImportExportLink_ObjectChild()
                                           AND ObjectLink_ObjectChild.ChildObjectId = inJuridicalId_from
 
                                    LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                                           ON ObjectLink_ObjectMain.ObjectId = Object_ImportExportLink.Id
                                          AND ObjectLink_ObjectMain.DescId = zc_ObjectLink_ImportExportLink_ObjectMain()
       
                                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                           ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_ObjectMain.ChildObjectId -- Object_ImportExportLink_View.MainId
                                          AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                                WHERE Object_ImportExportLink.DescId = zc_Object_ImportExportLink()
                                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId_to OR COALESCE (inJuridicalId_to, 0) = 0)
                               )
               -- почти результат
               SELECT tmpList.JuridicalId, tmpList.UnitId
               FROM tmpList
               WHERE (LOWER (inUnitName) = StringKey AND StringKey  <> '' AND StringKey1 = '' AND StringKey2 = '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%' AND StringKey1 <> '' AND StringKey2 = '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 = ''
                     )
                  OR (LOWER (inUnitName) LIKE '%' || StringKey1 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey2 || '%'
                  AND LOWER (inUnitName) LIKE '%' || StringKey3 || '%' AND StringKey1 <> '' AND StringKey2 <> '' AND StringKey3 <> ''
                     )
              ) AS tmp;

    END IF;


    -- Если не нашли, то сразу ругнемся. !!!Подразделение должно быть!!!
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION 'Для значения "%" по Юр.лицу "%" не найдено Подразделение.', inUnitName, lfGet_Object_ValueData (inJuridicalId_to);
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
        RAISE EXCEPTION 'У подразделения "%" не установлено значение "Торговая сеть".', lfGet_Object_ValueData (vbUnitId);
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
                                   AND MovementLinkObject_From.ObjectId = inJuridicalId_from
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();


    -- Если Проведен, то сразу ругнемся.
    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
        RAISE EXCEPTION 'Документ уже Проведен № "%" от "%" Поставщик = "%" Аптека = "%".', inInvNumber, DATE (inOperDate), lfGet_Object_ValueData (inJuridicalId_from), lfGet_Object_ValueData (vbUnitId);
    END IF;

     -- Аж вот тут мы будем менять, если документа нет или НДС определен точно
     IF COALESCE (vbMovementId, 0) = 0
     THEN
       -- продолжаем искать договор      
       IF COALESCE(vbContractId, 0) = 0 THEN
        -- А вот тут попытка угадать договор.
          -- Если даты не равны, то ищем любой договор с отсрочкой платежа
          IF inPaymentDate is null or inPaymentDate > (inOperDate + interval '1 day') THEN
             SELECT MAX(_tmpContract.ContractId) INTO vbContractId 
     	     FROM _tmpContract 
             WHERE COALESCE(_tmpContract.Deferment, 0) <> 0;
          ELSE
          -- иначе любой договор без отсрочки платежа
             SELECT MAX(_tmpContract.ContractId) INTO vbContractId 
             FROM _tmpContract 
             WHERE COALESCE(_tmpContract.Deferment, 0) = 0;
          END IF;	     	

          -- Ищем хоть какой-нить договор
          IF COALESCE(vbContractId, 0) = 0 THEN 
             SELECT MAX(_tmpContract.ContractId)  INTO vbContractId 
             FROM _tmpContract;
          END IF;

       END IF;

       --Если дата оплаты пустая - то вытягиваем её из договора
       IF inPaymentDate is Null or inPaymentDate = '19000101'::TDateTime
       THEN
           SELECT inOperDate::Date + COALESCE(_tmpContract.Deferment, 0)::Integer
          INTO inPaymentDate
           FROM _tmpContract
           WHERE _tmpContract.ContractId = vbContractId;
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
       

       -- меняем договор - отсрочка/факт - если больше 4 ДНЕЙ
       IF (vbContractId IN (183275)  -- Бадм Факт
        OR inJuridicalId_from = 59610 -- БаДМ
          )
          AND inOperDate + INTERVAL '4 DAY' < inPaymentDate
       THEN vbContractId:= 183257; -- Бадм отсрочка
       END IF;
       -- меняем договор - отсрочка/факт - если больше 4 ДНЕЙ
       IF (vbContractId IN (183338, 9035881) -- Оптима Факт + Оптима Предоплата
        OR inJuridicalId_from = 59611 -- СП "Оптима-Фарм, ЛТД"
          )
          AND inOperDate + INTERVAL '4 DAY' < inPaymentDate
          AND vbContractId <> 14589420 -- Исключили Оптима Никополь Отсрочка
       THEN vbContractId:= 183358; -- Оптима отсрочка
       END IF;


       vbMovementId := lpInsertUpdate_Movement_Income (ioId           := vbMovementId
                                                     , inInvNumber    := inInvNumber
                                                     , inOperDate     := inOperDate
                                                     , inPriceWithVAT := inPriceWithVAT
                                                     , inFromId       := inJuridicalId_from
                                                     , inToId         := vbUnitId
                                                     , inNDSKindId    := vbNDSKindId
                                                     , inContractId   := vbContractId 
                                                     , inPaymentDate  := inPaymentDate
                                                     , inJuridicalId  := inJuridicalId_to
                                                     , inisDifferent  := False
                                                     , inComment      := '' 
                                                     , inisUseNDSKind := vbNDSKindId = zc_Enum_NDSKind_Special_0()
                                                     , inUserId       := vbUserId);
     END IF;


    -- определяется AreaId - для поиска товара только для Региона
    vbAreaId_find:= CASE WHEN EXISTS (SELECT 1
                                 FROM ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                      INNER JOIN Object AS Object_JuridicalArea ON Object_JuridicalArea.Id       = ObjectLink_JuridicalArea_Juridical.ObjectId
                                                                               AND Object_JuridicalArea.isErased = FALSE
                                      INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                            ON ObjectLink_JuridicalArea_Area.ObjectId      = Object_JuridicalArea.Id 
                                                           AND ObjectLink_JuridicalArea_Area.DescId        = zc_ObjectLink_JuridicalArea_Area()
                                                           AND ObjectLink_JuridicalArea_Area.ChildObjectId = (SELECT ObjectLink_Unit_Area.ChildObjectId
                                                                                                              FROM ObjectLink AS ObjectLink_Unit_Area
                                                                                                              WHERE ObjectLink_Unit_Area.ObjectId = vbUnitId
                                                                                                                AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
                                                                                                             )
                                      -- Уникальный код поставщика ТОЛЬКО для Региона
                                      INNER JOIN ObjectBoolean AS ObjectBoolean_JuridicalArea_GoodsCode
                                                               ON ObjectBoolean_JuridicalArea_GoodsCode.ObjectId  = Object_JuridicalArea.Id 
                                                              AND ObjectBoolean_JuridicalArea_GoodsCode.DescId    = zc_ObjectBoolean_JuridicalArea_GoodsCode()
                                                              AND ObjectBoolean_JuridicalArea_GoodsCode.ValueData = TRUE
                                 WHERE ObjectLink_JuridicalArea_Juridical.ChildObjectId = inJuridicalId_from
                                   AND ObjectLink_JuridicalArea_Juridical.DescId        = zc_ObjectLink_JuridicalArea_Juridical()
                                ) 
                    THEN -- нужный Регион
                         (SELECT ObjectLink_Unit_Area.ChildObjectId
                          FROM ObjectLink AS ObjectLink_Unit_Area
                          WHERE ObjectLink_Unit_Area.ObjectId = vbUnitId
                            AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
                         )
                    ELSE 0
               END;


      -- Ищем товар поставщика
      SELECT ObjectLink_Goods_Object.ObjectId INTO vbPartnerGoodsId
      FROM ObjectLink AS ObjectLink_Goods_Object
           INNER JOIN ObjectString ON ObjectString.ObjectId  = ObjectLink_Goods_Object.ObjectId
                                  AND ObjectString.DescId    = zc_ObjectString_Goods_Code()
                                  AND ObjectString.ValueData = inGoodsCode
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                ON ObjectLink_Goods_Area.ObjectId = ObjectString.ObjectId
                               AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()

      WHERE ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
        AND ObjectLink_Goods_Object.ChildObjectId = inJuridicalId_from
        AND (-- если Регион соответсвует
             COALESCE (ObjectLink_Goods_Area.ChildObjectId, 0) = vbAreaId_find
             -- или Это регион zc_Area_Basis - тогда ищем в регионе "пусто"
          OR (vbAreaId_find = zc_Area_Basis() AND ObjectLink_Goods_Area.ChildObjectId IS NULL)
             -- или Это регион "пусто" - тогда ищем в регионе zc_Area_Basis
          OR (vbAreaId_find = 0 AND ObjectLink_Goods_Area.ChildObjectId = zc_Area_Basis())
            )
        ;
  
     -- Если вдруг такого нет, то мы его ОБЯЗАТЕЛЬНО добавляем. БЕЗ проверки на уникальность
     IF COALESCE(vbPartnerGoodsId, 0) = 0 THEN
        --
        vbPartnerGoodsId := lpInsertUpdate_Object_Goods (0, inGoodsCode, inGoodsName, NULL, NULL, NULL, inJuridicalId_from, vbUserId, NULL, inMakerName, FALSE);
        -- еще и Регион
        IF vbAreaId_find > 0
        THEN
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Area(), vbPartnerGoodsId, vbAreaId_find);
        END IF;
     END IF;
 
      -- Ищем товар для накладной. 
      SELECT Goods_Retail.GoodsId, ObjectLink_Goods_NDSKind.ChildObjectId  -- Object_Goods_View.NDSKindId 
             INTO vbGoodsId, vbNDSKindId
      FROM Object_LinkGoods_View AS Goods_Juridical
        LEFT JOIN Object_LinkGoods_View AS Goods_Retail
                                        ON Goods_Retail.GoodsMainId = Goods_Juridical.GoodsMainId
                                       AND Goods_Retail.ObjectId = vbObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Goods_Retail.GoodsId
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()                                        
      WHERE Goods_Juridical.GoodsId = vbPartnerGoodsId;

       
      -- выбираем элементы документа
       CREATE TEMP TABLE _tmpMI (Id Integer, PartnerGoodsId Integer, Price TFloat, PartionGoods TVarChar, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO _tmpMI (Id, PartnerGoodsId, Price, PartionGoods, ExpirationDate)
                         SELECT MovementItem.Id
                              , MILinkObject_Goods.ObjectId AS PartnerGoodsId
                              , MIFloat_Price.ValueData     AS Price
                              , COALESCE(MIString_PartionGoods.ValueData, '')              AS PartionGoods
                              , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) AS ExpirationDate
                         FROM MovementItem
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                     ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                    AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemString AS MIString_PartionGoods
                                     ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()  
                              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                     ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                    AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()                                         
                         WHERE MovementItem.MovementId = vbMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased = FALSE;
    -- Если элементов документа > 1
    IF EXISTS (SELECT 1
               FROM _tmpMI
               GROUP BY _tmpMI.PartnerGoodsId
                      , _tmpMI.Price
                      , _tmpMI.PartionGoods
                      , _tmpMI.ExpirationDate
               HAVING COUNT (*) > 1
              )
    THEN
        RAISE EXCEPTION 'Дублируется товар в документе № "%" от "%" Поставщик = "%" Аптека = "%".', inInvNumber, DATE (inOperDate), lfGet_Object_ValueData (inJuridicalId_from), lfGet_Object_ValueData (vbUnitId);
    END IF;

     -- Ищем элемент документа. Пока ключи: код поставщика, документ, цена, партия, срок годности. 
     vbMovementItemId:= (SELECT _tmpMI.Id
                         FROM _tmpMI
                         WHERE _tmpMI.PartnerGoodsId = vbPartnerGoodsId
                           AND _tmpMI.Price          = inPrice -- MovementItem.Price
                           AND _tmpMI.PartionGoods   = inPartitionGoods
                           AND _tmpMI.ExpirationDate = COALESCE (inExpirationDate, zc_DateStart())
                         );
  
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem_Income (vbMovementItemId, vbMovementId, vbGoodsId, inGoodsName, inAmount, inPrice, inFEA, inMeasure, vbUserId);

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), vbMovementItemId, vbPartnerGoodsId);

     -- Срок годности заодно влепим
     IF inExpirationDate IS NOT NULL AND inExpirationDate <> '01.01.1900' THEN
        -- сохранили свойство <Срок годности>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), vbMovementItemId, inExpirationDate);
     END IF;

     -- Ну и серию, если есть 
     IF inPartitionGoods <> '' THEN 
        -- сохранили свойство <Серия>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), vbMovementItemId, inPartitionGoods);
     END IF;
     
    -- Если есть то рег номер
     IF inSertificatNumber <> '' THEN 
        -- сохранили свойство <Номер регистрации>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_SertificatNumber(), vbMovementItemId, inSertificatNumber);
     END IF;
    -- Если есть до дату начала регистрации
     IF inSertificatStart IS NOT NULL AND inSertificatStart <> '01.01.1900' THEN 
        -- сохранили свойство <Дата начала регистрации>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatStart(), vbMovementItemId, inSertificatStart);
     END IF;
    -- Если есть до дату окончания регистрации
     IF inSertificatEnd IS NOT NULL AND inSertificatEnd <> '01.01.1900' THEN
        -- сохранили свойство <Дата окончания регистрации>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SertificatEnd(), vbMovementItemId, inSertificatEnd);
     END IF;
     
     IF inisLastRecord THEN
        -- пересчитали Итоговые суммы
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
     END IF;

     IF vbIsInsert = TRUE
     THEN
         -- сохранили ВСЕГДА
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbMovementItemId, CURRENT_TIMESTAMP);
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbMovementItemId, vbUserId);
    END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
 15.07.20                                                                                     * Исключил замену прайса для Оптима Никополь Отсрочка
 14.04.20                                                                                     * UseNDSKind
 11.05.18                                                                                     * 
 21.12.17         * del inCodeUKTZED
 11.12.17         * inCodeUKTZED
 15.02.17         * уходим от вьюх
 01.10.15                                                                      * inSertificatNumber, inSertificatStart, inSertificatEnd
 14.01.15                        *   
 08.01.15                        *   
 29.12.14                        *   
 26.12.14                        *   
 25.12.14                        *   
 02.12.14                        *   
*/
--select * from gpInsertUpdate_MovementItem_Income_MMOLoad(inOKPOFrom := '36852896', inOKPOTo := '2591702304' , inInvNumber := '6612083' , inOperDate := ('15.02.2017')::TDateTime , inInvTaxNumber := '6612083' , inPaymentDate := ('27.02.2017')::TDateTime , inPriceWithVAT := 'False' , inSyncCode := 1 , inRemark := 'ЧП "Шапира И. А.", г.Днепропетровск, пр.Правды, 6' , inGoodsCode := '28036' , inGoodsName := 'Ліпримар табл. в/о 20мг №30' , inMakerCode := '292' , inMakerName := 'Пфайзер' , inCommonCode := 155344 , inVAT := 7 , inPartitionGoods := 'R71613' , inExpirationDate := ('01.05.2019')::TDateTime , inAmount := 10 , inPrice := 523.57 , inFea := '3004900000' , inMeasure := 'пак' , inSertificatNumber := 'UA/2377/01/01' , inSertificatStart := ('27.06.2014')::TDateTime , inSertificatEnd := ('27.06.2019')::TDateTime , inisLastRecord := 'True' ,  inSession := '1871720');

