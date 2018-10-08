-- Function: gpInsertUpdate_MI_ProductionSeparate_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_Calculated (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionSeparate_Calculated(
    IN inId                  Integer   , --
 INOUT ioIsCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionSeparate_Calculated());

   -- переопределили
   ioIsCalculated := NOT ioIsCalculated;
   
   -- сохранили свойство <Сумма рассчитывается по остатку (да/нет)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, ioIsCalculated);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.18         *
*/

-- тест
   