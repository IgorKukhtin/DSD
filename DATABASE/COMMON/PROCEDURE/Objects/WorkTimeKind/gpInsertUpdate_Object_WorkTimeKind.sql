-- Function: gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_WorkTimeKind (Integer, Integer, TVarChar, TVarChar, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_WorkTimeKind (Integer, Integer, TVarChar, TVarChar, Tfloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_WorkTimeKind(
 INOUT ioId            Integer   ,    -- ключ объекта <>
    IN inCode          Integer   ,    -- Код
    IN inName          TVarChar  ,    -- наименование
    IN inShortName     TVarChar  ,    -- Короткое наименование
    IN inTax           Tfloat    ,    -- % изменения рабочих часов
    IN inPairDayId     Integer   ,    -- Вид смены
    IN inSession       TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbIsUpdate Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_WorkTimeKind());
   vbUserId:= lpGetUserBySession (inSession);


   -- Если код не установлен, определяем его как последний + 1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_WorkTimeKind());
   
   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_WorkTimeKind(), vbCode, TRIM (inName));
   
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_WorkTimeKind_ShortName(), ioId, inShortName);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_WorkTimeKind_Tax(), ioId, inTax);

   -- сохранили связь с <вид смены>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_WorkTimeKind_PairDay(), ioId, inPairDayId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, vbIsUpdate);

END;$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
 05.12.17         *
*/

-- тест