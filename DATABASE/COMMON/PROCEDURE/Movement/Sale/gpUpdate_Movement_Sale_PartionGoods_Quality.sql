-- Function: gpUpdate_Movement_Sale_PartionGoods_Quality()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_PartionGoods_Quality (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_PartionGoods_Quality(
    IN inMovementId        Integer  , -- ключ Документа
    IN inPartionGoods_Q    TDateTime,
    IN inSession           TVarChar    -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF vbUserId <> 5 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Нет Прав.';
     END IF;

     -- сохранили
     PERFORM lpInsert_MovementItemProtocol (tmpMI.Id, vbUserId, FALSE)
     FROM (SELECT tmpMI.Id AS Id
                , lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q_1(), tmpMI.Id, DATE_TRUNC ('DAY', inPartionGoods_Q) - (tmpMI.DaysQ :: TVarChar || ' DAY') :: INTERVAL)
           FROM (WITH tmpMI AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId           AS GoodsId
                                     , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                                FROM MovementItem
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                     LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q
                                                                ON MIDate_PartionGoods_q.MovementItemId = MovementItem.Id
                                                               AND MIDate_PartionGoods_q.DescId         = zc_MIDate_PartionGoods_q_1()
                                                               AND MIDate_PartionGoods_q.ValueData      > zc_DateStart()
              
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                                  --
                                  AND MIDate_PartionGoods_q.MovementItemId IS NULL
                                  --
                                  AND Object_Goods.ObjectCode NOT IN (2036 -- Ковбаса З ЯЛОВИЧИНИ Фітнес вар в/ґ 400 г/шт ТМ Фітнес
                                                                    , 2031 -- Ковбаса ОЛІВ`Є вар 1 ґ 400 г/шт ТМ Наші Ковбаси
                                                                    , 2023 -- МОЛОЧНА п/а (шкiльна) В/Г 0,400
                                                                    , 2281 -- Ковбаса ЛIКАРСЬКА вар п/а в/ґ 400 г/шт (шкiльна) ТМ Алан
                                                                    , 2093 -- КОВБАСА ДИТЯЧА ВАР. В/Г 0,400
                                                                     )
                               )
                     , tmpMI_DaysQ AS (SELECT tmpMI.Id
                                              -- Уменьшение на N дней от даты покупателя в качественном
                                            , ObjectFloat_DaysQ.ValueData AS DaysQ
                                       FROM tmpMI
                                            INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpMI.GoodsId
                                                                                   AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMI.GoodsKindId
                                                                                   
                                            LEFT JOIN ObjectFloat AS ObjectFloat_DaysQ
                                                                  ON ObjectFloat_DaysQ.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                                 AND ObjectFloat_DaysQ.DescId = zc_ObjectFloat_GoodsByGoodsKind_DaysQ()
                                      )
                 -- Результат
                 SELECT tmpMI.Id
                      , COALESCE (tmpMI_DaysQ.DaysQ, 0) :: Integer AS DaysQ
                 FROM tmpMI
                      LEFT JOIN tmpMI_DaysQ ON tmpMI_DaysQ.Id = tmpMI.Id
                ) AS tmpMI
          ) AS tmpMI
         ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.25                                        *
*/

-- тест
--
