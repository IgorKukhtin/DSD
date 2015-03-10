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

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_Load(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inInvNumber           TVarChar  , 
    IN inOperDate            TDateTime , -- Дата документа
    
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inAmount              TFloat    ,  
    IN inPrice               TFloat    ,  
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inPartitionGoods      TVarChar  ,   
    IN inPaymentDate         TDateTime , -- Дата оплаты
    IN inPriceWithVAT        Boolean   ,
    IN inVAT                 TFloat    ,
    IN inUnitName            TVarChar  ,
    IN inMakerName           TVarChar  ,
    IN inFEA                 TVarChar  , -- УК ВЭД
    IN inMeasure             TVarChar  , -- Ед. измерения
    IN inisLastRecord        Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

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
	
   vbUserId := inSession::Integer;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- Ищем документ по дате, номеру, юр лицу
      WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId)
   SELECT Id, Movement.StatusId INTO vbMovementId, vbStatusId
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
     IF (COALESCE(vbMovementId, 0) = 0) THEN
 
        -- Ищем подразделение и Договор. Два в одном
        SELECT MainId, ValueId INTO vbUnitId, vbContractId
          FROM Object_ImportExportLink_View
               LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = inJuridicalId
         WHERE ValueId = Object_Contract_View.Id  AND StringKey = inUnitName;

       IF COALESCE(vbUnitId, 0) = 0 THEN
          -- Ищем подразделение по Юрлицу.
          SELECT MainId INTO vbUnitId 
            FROM Object_ImportExportLink_View
           WHERE ValueId = inJuridicalId AND StringKey = inUnitName;
       END IF;

    -- Если не нашли, то сразу ругнемся. Подразделение должно быть!
       IF COALESCE(vbUnitId, 0) = 0 THEN
          RAISE EXCEPTION 'Не установлено Подразделение';
       END IF;
        

       IF COALESCE(vbContractId, 0) = 0 THEN
        -- А вот тут попытка угадать договор.
          -- Если даты не равны, то ищем любой договор с отсрочкой платежа
          IF inPaymentDate > (inOperDate + interval '1 day') THEN
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
 
       -- определяем НДС
       SELECT Id INTO vbNDSKindId 
         FROM Object_NDSKind_View
         WHERE NDS = inVAT;
      
       IF COALESCE(vbNDSKindId, 0) = 0 THEN 

       END IF;

       vbMovementId := lpInsertUpdate_Movement_Income(vbMovementId, inInvNumber, inOperDate, inPriceWithVAT, 
                                                      inJuridicalId, vbUnitId, vbNDSKindId, 
                                                      inContractId := vbContractId , inPaymentDate := inPaymentDate, inUserId := vbUserId);
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
        AND MovementItem.Price = MovementItem.Price
        AND MovementItem.PartionGoods = inPartitionGoods
        AND MovementItem.ExpirationDate = inExpirationDate;
  
     vbMovementItemId := lpInsertUpdate_MovementItem_Income(vbMovementItemId, vbMovementId, vbGoodsId, inAmount, inPrice, inFEA, inMeasure, vbUserId);
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
     

     IF inisLastRecord THEN
        -- пересчитали Итоговые суммы
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
     END IF;


     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.01.15                        *   
 08.01.15                        *   
 29.12.14                        *   
 26.12.14                        *   
 25.12.14                        *   
 02.12.14                        *   
*/
