-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    ,
    IN inPartnerGoodsCode    TVarChar  ,
    IN inPartnerGoodsName    TVarChar  ,
    IN inJuridicalName       TVarChar  ,
    IN inContractName        TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE(ioId Integer, ioPrice TFloat, ioPartnerGoodsCode TVarChar, ioPartnerGoodsName TVarChar
            , ioJuridicalName TVarChar, ioContractName TVarChar
            , outSumm TFloat, outCalcAmount TFloat
) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbSumm TFloat;   
   DECLARE vbCalcAmount TFloat;   
   DECLARE vbMinimumLot TFloat;   

BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   IF inJuridicalName = '' THEN 

      PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, inGoodsId, vbUserId);

       SELECT MinPrice.Price
            , MinPrice.GoodsCode
            , MinPrice.GoodsName
            , MinPrice.JuridicalName
            , MinPrice.ContractName   INTO inPrice, inPartnerGoodsCode, inPartnerGoodsName, inJuridicalName, inContractName 

       FROM 
                                      (SELECT *, MIN(DDD.Id) OVER(PARTITION BY MovementItemId) AS MinId FROM
                                           (SELECT *
                                                , MIN(SuperFinalPrice) OVER(PARTITION BY MovementItemId) AS MinSuperFinalPrice
                                            FROM _tmpMI) AS DDD
                                       WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice) AS MinPrice
                                  WHERE MinPrice.Id = MinPrice.MinId;

    END IF;
  
     inPrice := COALESCE(inPrice, 0);
     vbId := lpInsertUpdate_MovementItem_OrderInternal(inId, inMovementId, inGoodsId, inAmount, inPrice, vbUserId);
     
     SELECT MinimumLot INTO vbMinimumLot
       FROM Object_Goods_View WHERE Id = inGoodsId;

     vbCalcAmount := CEIL(inAmount / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1);     
     vbSumm := vbCalcAmount * inPrice;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      RETURN 
        QUERY
      SELECT vbId
           , inPrice
           , inPartnerGoodsCode
           , inPartnerGoodsName
           , inJuridicalName
           , inContractName
           , vbSumm
           , vbCalcAmount;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.10.14                         *
 03.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
