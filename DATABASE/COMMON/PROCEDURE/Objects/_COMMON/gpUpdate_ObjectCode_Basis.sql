-- Function: gpUpdate_ObjectCode_Basis()

DROP FUNCTION IF EXISTS gpUpdate_ObjectCode_Basis (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ObjectCode_Basis(
    IN inId                  Integer   , -- Ключ объекта <товар>
 INOUT ioBasisCode           Integer    , -- код Алан
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

     -- проверка
     IF COALESCE ((SELECT ObjectFloat.ValueData ::Integer FROM ObjectFloat WHERE ObjectFloat.ObjectId = inId AND ObjectFloat.DescId = zc_ObjectFloat_ObjectCode_Basis()), 0) = COALESCE (ioBasisCode, 0)
     THEN
         RETURN;
     END IF;


     IF vbUserId = 343013 -- Нагорная Я.Г.
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение BasisCode с <%> на <%>'
          , (SELECT ObjectFloat.ValueData ::Integer FROM ObjectFloat WHERE ObjectFloat.ObjectId = inId AND ObjectFloat.DescId = zc_ObjectFloat_ObjectCode_Basis())
          , ioBasisCode
           ;
     END IF;

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectCode_Basis());
     --vbUserId:= lpGetUserBySession (inSession);

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ObjectCode_Basis(), inId, ioBasisCode);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.22         *
*/


-- тест
--