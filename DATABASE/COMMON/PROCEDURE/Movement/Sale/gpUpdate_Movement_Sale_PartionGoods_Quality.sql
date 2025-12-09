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
     IF vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Нет Прав.';
     END IF;

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q(), MovementItem.Id, DATE_TRUNC ('DAY', inPartionGoods_Q))
     FROM MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q
                                     ON MIDate_PartionGoods_q.MovementItemId = MovementItem.Id
                                    AND MIDate_PartionGoods_q.DescId         = zc_MIDate_PartionGoods_q()
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
                                         , 2093 -- КОВБАСА ДИТЯЧА ВАР. В/Г 0,400)
                                          )
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
