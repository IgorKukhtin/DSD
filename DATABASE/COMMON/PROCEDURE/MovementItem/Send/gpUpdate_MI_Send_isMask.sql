-- Function: gpUpdate_MI_Send_isMask()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_isMask (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_isMask(
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());


      -- Проверка - что б не копировали два раза
      IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION 'Ошибка.В документе уже есть данные.';
      END IF;

      -- Результат
       CREATE TEMP TABLE tmpMI (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, PartionGoodsDate TDateTime, PartionGoods TVarChar, PartNumber TVarChar) ON COMMIT DROP;


      INSERT INTO tmpMI  (MovementItemId, GoodsId, GoodsKindId, AmountPartner, PartionGoodsDate, PartionGoods, PartNumber)

         WITH
          tmp AS (SELECT MAX (MovementItem.Id)                         AS MovementItemId
                       , MovementItem.ObjectId                         AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                       , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                       , COALESCE (MIString_PartNumber.ValueData, '')             AS PartNumber
                  FROM MovementItem
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                  ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                 AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                       LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                    ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                   AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                       LEFT JOIN MovementItemString AS MIString_PartNumber
                                                    ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                  WHERE MovementItem.MovementId =  inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  GROUP BY MovementItem.ObjectId
                         , MILinkObject_GoodsKind.ObjectId
                         , MIDate_PartionGoods.ValueData
                         , MIString_PartionGoods.ValueData
                         , COALESCE (MIString_PartNumber.ValueData, '')
                 )

        SELECT COALESCE (tmp.MovementItemId, 0)              AS MovementItemId
             , Object_Goods.Id                               AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , COALESCE (MovementItem.Amount, 0)             AS AmountPartner
             , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
             , COALESCE (MIString_PartionGoods.ValueData, MIString_PartionGoodsCalc.ValueData, '') AS PartionGoods
             , COALESCE (MIString_PartNumber.ValueData,'')   AS PartNumber
       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                        AND MIFloat_AmountPartner.ValueData <> 0
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                        AND MIString_PartionGoods.ValueData <> ''
            LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                         ON MIString_PartionGoodsCalc.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            LEFT JOIN tmp ON tmp.GoodsId          = MovementItem.ObjectId
                         AND tmp.GoodsKindId      = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                         AND tmp.PartionGoodsDate = COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                         AND tmp.PartionGoods     = COALESCE (MIString_PartionGoods.ValueData, '')
                         AND tmp.PartNumber       = COALESCE (MIString_PartNumber.ValueData, '')

      WHERE MovementItem.MovementId = inMovementMaskId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = FALSE;


     -- cохраняем
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := tmpMI.MovementItemId
                                             , inMovementId          := inMovementId
                                             , inGoodsId             := tmpMI.GoodsId
                                             , inAmount              := tmpMI.AmountPartner
                                             , inPartionGoodsDate    := tmpMI.PartionGoodsDate
                                             , inCount               := CAST (0 AS TFloat)
                                             , inHeadCount           := CAST (0 AS TFloat)
                                             , ioPartionGoods        := tmpMI.PartionGoods 
                                             , ioPartNumber          := tmpMI.PartNumber
                                             , inGoodsKindId         := tmpMI.GoodsKindId
                                             , inGoodsKindCompleteId := 0
                                             , inAssetId             := 0
                                             , inAssetId_two         := 0
                                             , inUnitId              := 0
                                             , inStorageId           := 0
                                             , inPartionModelId      := 0
                                             , inPartionGoodsId      := 0
                                             , inUserId              := vbUserId
                                              )
     FROM tmpMI                                      
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.22         *
*/

-- тест
--