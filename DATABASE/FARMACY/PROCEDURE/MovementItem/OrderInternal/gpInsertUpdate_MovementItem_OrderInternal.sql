-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountManual        TFloat    , -- Ручное количество Итого
    IN inPrice               TFloat    ,
    IN inComment             TVarChar  ,
    IN inPartnerGoodsCode    TVarChar  ,
    IN inPartnerGoodsName    TVarChar  ,
    IN inJuridicalName       TVarChar  ,
    IN inContractName        TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE(ioId Integer, ioPrice TFloat, ioPartnerGoodsCode TVarChar, ioPartnerGoodsName TVarChar
            , ioJuridicalName TVarChar, ioContractName TVarChar
            , outSumm TFloat, outCalcAmount TFloat, outSummAll TFloat, outAmountAll TFloat, outCalcAmountAll TFloat
) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbAmount TFloat;   
   DECLARE vbSumm TFloat;   
   DECLARE vbCalcAmount TFloat;   
   DECLARE vbSummAll TFloat;   
   DECLARE vbAmountAll TFloat;   
   DECLARE vbCalcAmountAll TFloat;   
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
            , MinPrice.ContractName   
        INTO inPrice
            , inPartnerGoodsCode
            , inPartnerGoodsName
            , inJuridicalName
            , inContractName 
        FROM (
                SELECT *, MIN(DDD.Id) OVER(PARTITION BY MovementItemId) AS MinId 
                FROM(
                        SELECT *, MIN(SuperFinalPrice) OVER(PARTITION BY MovementItemId) AS MinSuperFinalPrice
                        FROM _tmpMI
                    ) AS DDD
                WHERE DDD.SuperFinalPrice = DDD.MinSuperFinalPrice
             ) AS MinPrice
        WHERE MinPrice.Id = MinPrice.MinId;
    END IF;
  
    inPrice := COALESCE(inPrice, 0);
    --проверить что у нас на самом деле меняется
    SELECT MinimumLot INTO vbMinimumLot
    FROM Object_Goods_View WHERE Id = inGoodsId;
    
    SELECT
        (CEIL((Amount + COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1)),
        COALESCE(MIFloat_AmountManual.ValueData,(CEIL((Amount + COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1)))::TFloat
    INTO
        vbCalcAmount,
        vbCalcAmountAll
    FROM
        MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                          ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
    WHERE
        Id = inId;
    
    IF (coalesce(vbCalcAmount,0) <> coalesce(inAmountManual,0)) or (COALESCE(vbCalcAmountAll,0) <> COALESCE(inAmountManual,0))
    THEN
        vbId := lpInsertUpdate_MovementItem_OrderInternal(inId, inMovementId, inGoodsId, inAmount, inAmountManual, inPrice, vbUserId);
    ELSE
        vbId := lpInsertUpdate_MovementItem_OrderInternal(inId, inMovementId, inGoodsId, inAmount, NULL, inPrice, vbUserId);
    END IF;    

          -- сохранили свойство <Примечание>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbId, inComment);
     
    

    vbCalcAmount := CEIL(inAmount / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1);     
    vbSumm := vbCalcAmount * inPrice;
    SELECT
        (CEIL(inAmount / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1))::TFloat
       ,(CEIL(inAmount / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1) * inPrice)::TFloat
       ,inAmount + COALESCE(MIFloat_AmountSecond.ValueData,0)
       ,COALESCE(MIFloat_AmountManual.ValueData,(CEIL((inAmount + COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1)))::TFloat
       ,COALESCE(MIFloat_AmountManual.ValueData,(CEIL((inAmount + COALESCE(MIFloat_AmountSecond.ValueData,0)) / COALESCE(vbMinimumLot, 1)) * COALESCE(vbMinimumLot, 1))) * inPrice::TFloat
    INTO
        vbCalcAmount
       ,vbSumm
       ,vbAmountAll
       ,vbCalcAmountAll
       ,vbSummAll
    FROM
        MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountSecond
                                          ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_AmountManual
                                          ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
    WHERE
        Id = vbId;
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
           , vbCalcAmount
           , vbSummAll
           , vbAmountAll
           , vbCalcAmountAll;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.02.15                         *
 23.10.14                         *
 03.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
