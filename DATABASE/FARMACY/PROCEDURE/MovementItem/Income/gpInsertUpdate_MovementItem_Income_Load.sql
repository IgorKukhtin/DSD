DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_Load 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, TDateTime, 
           Boolean,
           TVarChar,
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
    IN inPayDate             TDateTime , -- Дата оплаты
    IN inNDSinPrice          Boolean   ,
    IN inUnitName            TVarChar   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbGoodsId Integer;
BEGIN



/*	

  IF COALESCE(inPrice, 0) = 0 THEN 
     RETURN;
  END IF;

  DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
    (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId AND COALESCE(ContractId, 0) = inContractId
                                    AND OperDate < CURRENT_DATE);

  DELETE FROM LoadPriceList WHERE Id IN
    (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId AND COALESCE(ContractId, 0) = inContractId
                                    AND OperDate < CURRENT_DATE);
   
  SELECT Id INTO vbLoadPriceListId 
    FROM LoadPriceList
   WHERE JuridicalId = inJuridicalId AND OperDate = Current_Date AND COALESCE(ContractId, 0) = inContractId;

  IF COALESCE(vbLoadPriceListId, 0) = 0 THEN
     INSERT INTO LoadPriceList (JuridicalId, ContractId, OperDate, NDSinPrice)
             VALUES(inJuridicalId, inContractId, Current_Date, inNDSinPrice);
  END IF;

  SELECT Id INTO vbLoadPriceListItemsId 
    FROM LoadPriceListItem 
   WHERE LoadPriceListId = vbLoadPriceListId AND GoodsCode = inGoodsCode;

   -- Ищем по общему коду 
   IF (COALESCE(vbGoodsId, 0) = 0) AND (inCommonCode > 0) THEN
      SELECT GoodsMainId INTO vbGoodsId
        FROM Object_LinkGoods_View 
       WHERE ObjectId = zc_Enum_GlobalConst_Marion() AND GoodsCodeInt = inCommonCode;
   END IF;
   
   -- Ищем по штрих-коду 
   IF (COALESCE(vbGoodsId, 0) = 0) AND (inBarCode <> '') THEN
      SELECT GoodsMainId INTO vbGoodsId
        FROM Object_LinkGoods_View 
       WHERE ObjectId = zc_Enum_GlobalConst_BarCode() AND GoodsName = inBarCode;
   END IF;

   -- Ищем по коду и inJuridicalId
   IF (COALESCE(vbGoodsId, 0) = 0) THEN
      SELECT GoodsMainId INTO vbGoodsId
        FROM Object_LinkGoods_View 
       WHERE ObjectId = inJuridicalId AND GoodsCode = inGoodsCode;
   END IF;

   IF COALESCE(vbLoadPriceListItemsId, 0) = 0 THEN
      INSERT INTO LoadPriceListItem (LoadPriceListId, CommonCode, BarCode, GoodsCode, GoodsName, GoodsNDS, GoodsId, Price, ExpirationDate, PackCount, ProducerName)
             VALUES(vbLoadPriceListId, inCommonCode, inBarCode, inGoodsCode, inGoodsName, inGoodsNDS, vbGoodsId, inPrice, inExpirationDate, inPackCount, inProducerName);
   ELSE
      UPDATE LoadPriceListItem 
         SET GoodsName = inGoodsName, CommonCode = inCommonCode, BarCode = inBarCode, GoodsNDS = inGoodsNDS, GoodsId = vbGoodsId, 
             Price = inPrice, ExpirationDate = inExpirationDate, PackCount = inPackCount, ProducerName = inProducerName
       WHERE Id = vbLoadPriceListItemsId;
   END IF;
*/
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.12.14                        *   
*/
