-- Function: gpUpdate_MI_Over_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_SummNalogRet  (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_SummNalogRet(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inSummNalog           TFloat    , 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRet(), inId, inSummNalog);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.01.18         *
*/

-- тест
-- 