-- Function: gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer, Integer, TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Reason(
 INOUT ioId	             Integer,       -- ключ объекта <>
    IN inCode                Integer,       -- Код объекта <>
    IN inName                TVarChar,      -- Название объекта <>
    IN inShort               TVarChar,      -- Сокращенное название
    IN inReturnKindId        Integer,       -- Тип возврата
    IN inReturnDescKindId    Integer,       -- причина возврата
    IN inPeriodDays          TFloat,        -- Период в дн. от "Срок годности"
    IN inPeriodTax           TFloat,        -- Период в % от "Срок годности"
    IN inisReturnIn          Boolean,       -- по умолчанию для возвр. от покуп
    IN inisSendOnPrice       Boolean,       -- по умолчанию для возвр. с филиала
    IN inComment             TVarChar,      -- примечание
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Reason());

   -- проверка
   IF COALESCE (inisReturnIn,False) = TRUE AND COALESCE (inisSendOnPrice,False) = TRUE
   THEN
       RAISE EXCEPTION 'Ошибка.Значение по умолчанию может быть выбрано только одно.';
   END IF;
   
   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_Reason());
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Reason(), inCode);

   -- проверка прав уникальности для свойства элемента  <Наименование> + <Тип возврата> + <Причина Возврата>
   IF EXISTS (SELECT 1
              FROM Object
                   INNER JOIN ObjectLink AS ObjectLink_ReturnKind
                                         ON ObjectLink_ReturnKind.ObjectId = Object.Id 
                                        AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
                                        AND ObjectLink_ReturnKind.ChildObjectId = inReturnKindId
                   INNER JOIN ObjectLink AS ObjectLink_ReturnDescKind
                                        ON ObjectLink_ReturnDescKind.ObjectId = Object.Id 
                                       AND ObjectLink_ReturnDescKind.DescId = zc_ObjectLink_Reason_ReturnDescKind()
                                       AND ObjectLink_ReturnDescKind.ChildObjectId = inReturnDescKindId
              WHERE Object.Id <> ioId
                AND TRIM (Object.ValueData) = TRIM (inName))
   THEN
       RAISE EXCEPTION 'Ошибка.Причина не уникальна.';
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Reason(), inCode, inName);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Reason_ReturnKind(), ioId, inReturnKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Reason_ReturnDescKind(), ioId, inReturnDescKindId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Reason_ReturnIn(), ioId, inisReturnIn);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Reason_SendOnPrice(), ioId, inisSendOnPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Reason_Short(), ioId, inShort);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Reason_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Reason_PeriodDays(), ioId, inPeriodDays);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Reason_PeriodTax(), ioId, inPeriodTax);   
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.23         * 
 01.07.21         *
 17.06.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Reason ()
                            