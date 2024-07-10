-- Function: gpUpdate_MI_Income_isMask()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_isMask (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_isMask(
    IN inMovementId      Integer      , -- ключ Документа
    IN inMovementMaskId  Integer      , -- ключ Документа маски
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);
  
      -- Результат
       CREATE TEMP TABLE tmpMI (GoodsId Integer
                              , Amount TFloat, OperPriceList TFloat
                              , PartNumber TVarChar) ON COMMIT DROP;

      INSERT INTO tmpMI (GoodsId, Amount, OperPriceList, PartNumber)

         WITH
         --товары из тек. документа 
          tmpGoods AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                       FROM MovementItem 
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                      )
          --строки из документа маски
        , tmpGoods_mask AS (SELECT MovementItem.ObjectId           AS GoodsId
                                 , MIFloat_OperPriceList.ValueData AS OperPriceList
                                 , MIString_PartNumber.ValueData   AS PartNumber 
                                 , SUM (MovementItem.Amount)       AS Amount
                            FROM MovementItem

                                 LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                             ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                            AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber() 

                            WHERE MovementItem.MovementId = inMovementMaskId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ObjectId
                                   , MIFloat_OperPriceList.ValueData
                                   , MIString_PartNumber.ValueData 
                            )
                            
        SELECT tmp.GoodsId
             , tmp.Amount
             , tmp.OperPriceList  ::TFloat
             , tmp.PartNumber     ::TVarChar
        FROM tmpGoods_mask AS tmp
            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
        WHERE tmpGoods.GoodsId IS NULL;


     --cохраняем  строки только те товары, которых нет в тек. документе                
     PERFORM  lpInsertUpdate_MovementItem_Income (ioId            := 0             ::Integer
                                                , inMovementId    := inMovementId  ::Integer
                                                , inGoodsId       := tmpMI.GoodsId ::Integer
                                                , inAmount        := tmpMI.Amount  ::TFloat
                                                , inOperPriceList := COALESCE (tmpMI.OperPriceList,0) ::TFloat
                                                , inPartNumber    := COALESCE (tmpMI.PartNumber,'')   ::TVarChar
                                                , inComment       := ''            ::TVarChar
                                                , inPartionCellId := NULL            ::Integer
                                                , inUserId        := vbUserId      ::Integer
                                                 )

     FROM tmpMI;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.23         *
 02.06.22         *
*/

-- тест
--