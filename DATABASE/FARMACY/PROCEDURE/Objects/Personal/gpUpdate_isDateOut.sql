-- Function: gpUpdate_isDateOut ()


DROP FUNCTION IF EXISTS gpUpdate_isDateOut (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_isDateOut(
    IN inId                  Integer   , -- ключ объекта <Сотрудники>
 INOUT ioDateOut             TDateTime , -- Дата увольнения
 INOUT ioisDateOut           Boolean   , -- уволен
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

    -- проверка
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Элемент справочника не записан.';
     END IF;

   -- определили признак
   ioisDateOut:= NOT ioisDateOut;

   -- сохранили свойство <Дата увольнения>
   IF ioisDateOut = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), inId, COALESCE(ioDateOut,CURRENT_DATE));
       ioDateOut:=CURRENT_DATE;
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), inId, zc_DateEnd());
       ioDateOut:=zc_DateEnd();
   END IF;
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   
 05.02.16         * 
*/

-- тест
-- SELECT * FROM gpUpdate_isDateOut (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')