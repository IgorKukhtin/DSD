 -- Function: gpInsertUpdate_Object_Language()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Language(
   INOUT ioId                       Integer,     -- ид
      IN incode                     Integer,     -- код 
      IN inName                     TVarChar,    -- наименование 
      IN inComment                  TVarChar,    -- Примечание
      IN inValue1                   TVarChar, 
      IN inValue2                   TVarChar, 
      IN inValue3                   TVarChar, 
      IN inValue4                   TVarChar, 
      IN inValue5                   TVarChar, 
      IN inValue6                   TVarChar, 
      IN inValue7                   TVarChar, 
      IN inValue8                   TVarChar, 
      IN inValue9                   TVarChar, 
      IN inValue10                  TVarChar, 
      IN inValue11                  TVarChar, 
      IN inValue12                  TVarChar, 
      IN inValue13                  TVarChar, 
      IN inValue14                  TVarChar,
      IN inValue15                  TVarChar,
      IN inValue16                  TVarChar,
      IN inValue17                  TVarChar,
      IN inSession                  TVarChar     -- Пользователь
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Language());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Language()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Language(), inName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Language(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Language(), vbCode_calc, inName);
   
   -- сохранили св-во <Примечание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Comment(), ioId, inComment);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value1(), ioId, inValue1);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value2(), ioId, inValue2);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value3(), ioId, inValue3);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value4(), ioId, inValue4);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value5(), ioId, inValue5);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value6(), ioId, inValue6);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value7(), ioId, inValue7);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value8(), ioId, inValue8);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value9(), ioId, inValue9);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value10(), ioId, inValue10);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value11(), ioId, inValue11);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value12(), ioId, inValue12);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value13(), ioId, inValue13);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value14(), ioId, inValue14);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value15(), ioId, inValue15);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value16(), ioId, inValue16);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value17(), ioId, inValue17);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.19         *
 10.10.18         *
 23.10.17         *
*/

-- тест
-- 
