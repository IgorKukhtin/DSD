-- Function: gpUpdate_Movement_ProductionUnion_Etiketka()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Etiketka (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Etiketka(
    IN inId                    Integer   , -- Ключ объекта <Документ>
    IN inisEtiketka            Boolean   , --
   OUT outEtiketka             Boolean   , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

     -- определили признак
     outEtiketka := not inisEtiketka;

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Etiketka(), inId, outEtiketka);


     IF vbUserId = 9457
     THEN
           RAISE EXCEPTION 'Тест. Ок.'; 
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.24          *
*/

-- тест
--  