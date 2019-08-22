-- Function: gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_WorkTimeKind(
 INOUT ioId             Integer   ,    -- ключ объекта <>
    IN inShortName      TVarChar  ,    -- Короткое наименование 	
    IN inPayrollTypeID  integer   ,    -- Типы расчета заработной платы
    IN inSession        TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_WorkTimeKind());
   vbUserId := inSession;

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_WorkTimeKind_ShortName(), ioId, inShortName);

   -- сохранили связь с <Типы расчета заработной платы>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_WorkTimeKind_PayrollType(), ioId, inPayrollTypeID);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.08.19                                                       *
 01.10.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_WorkTimeKind()
