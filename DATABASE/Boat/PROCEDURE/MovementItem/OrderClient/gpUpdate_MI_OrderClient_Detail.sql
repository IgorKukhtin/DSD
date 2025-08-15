-- Function: gpUpdate_MI_OrderClient_Detail()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderClient_Detail(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inObjectId            Integer   , -- Комплектующие / Работы/Услуги / Boat Structure
    IN inAmount              TFloat    , -- Количество для сборки Узла
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     --
     vbUserId := lpGetUserBySession (inSession);

      -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Detail(), inObjectId, NULL, inMovementId, inAmount, NULL, vbUserId);

 
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.25         * 
*/

-- тест
-- SELECT * FROM gpUpdate_MI_OrderClient_Detail (inId:= 0, inMovementId:= 10, inObjectId:= 1, inAmount:= 0, inSession:= '2')
