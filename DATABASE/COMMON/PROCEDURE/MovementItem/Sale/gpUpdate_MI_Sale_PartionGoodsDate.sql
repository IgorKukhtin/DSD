-- Function: gpUpdate_MI_Sale_PartionGoodsDate()

DROP FUNCTION IF EXISTS gpUpdate_MI_Sale_PartionGoodsDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Sale_PartionGoodsDate(
    IN inId                      Integer   , -- Ключ объекта <>
    IN inPartionGoodsDate        TDateTime , --
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- сохранили свойство <Дата партии>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inId, inPartionGoodsDate);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.20         *
*/
