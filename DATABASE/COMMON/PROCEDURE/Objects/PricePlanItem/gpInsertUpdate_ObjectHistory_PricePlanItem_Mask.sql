-- Function: gpInsertUpdate_ObjectHistory_PricePlanItem_Mask (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PricePlanItem_Mask (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PricePlanItem_Mask(
    IN inOperDate           TDateTime,
    IN inPriceListId        Integer  , -- прайс лист
    IN inPriceListId_mask   Integer  , -- прайс лист
    IN inSession         TVarChar -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PricePlanItem());


    -- Проверка
    IF COALESCE(inPriceListId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не выбран Прайс-лист.';
    END IF;

    -- Проверка
    IF COALESCE(inPriceListId_mask, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не выбран Прайс-лист для копирования.';
    END IF;

    --
    PERFORM lpInsertUpdate_ObjectHistory_PricePlanItem (ioId          := COALESCE (tmp.Id,0) ::Integer
                                                      , inPriceListId := inPriceListId
                                                      , inGoodsId     := tmp.GoodsId
                                                      , inGoodsKindId := tmp.GoodsKindId
                                                      , inOperDate    := inOperDate
                                                      , inValue       := tmp.ValuePrice
                                                      , inUserId      := vbUserId
                                                       )
    FROM (WITH
          tmp AS (SELECT tmp.Id, tmp.GoodsId, tmp.GoodsKindId , tmp.ValuePrice  
                  FROM lfSelect_ObjectHistory_PricePlanItem (inPriceListId , inOperDate) AS tmp
                  ) 
        , tmpMask AS (SELECT tmp.GoodsId, tmp.GoodsKindId , tmp.ValuePrice 
                      FROM lfSelect_ObjectHistory_PricePlanItem (inPriceListId_mask, inOperDate) AS tmp
                      --WHERE COALESCE (tmp.GoodsKindId,0) <> 8347  --tmp.GoodsId = 9915765                  
                      )
        --
        SELECT tmpPricePlanItem.Id
             , COALESCE (tmpPricePlanItem.GoodsId, tmpPricePlanItem_mask.GoodsId) AS GoodsId
             , COALESCE (tmpPricePlanItem.GoodsKindId, tmpPricePlanItem_mask.GoodsKindId) AS GoodsKindId
             , COALESCE (tmpPricePlanItem.ValuePrice, tmpPricePlanItem_mask.ValuePrice) AS ValuePrice
        FROM tmp AS tmpPricePlanItem
                 FULL JOIN tmpMask AS tmpPricePlanItem_mask 
                                   ON tmpPricePlanItem_mask.GoodsId = tmpPricePlanItem.GoodsId
                                  AND COALESCE (tmpPricePlanItem_mask.GoodsKindId,0) = COALESCE (tmpPricePlanItem.GoodsKindId,0)
        
        WHERE tmpPricePlanItem_mask.GoodsId IS NOT NULL
        ) AS tmp   
    ;
           
   if vbUserId = 9457 then RAISE EXCEPTION 'Тест.Ок.'; end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.26         *
*/

-- тест
