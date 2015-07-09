-- Function: gpInsertUpdate_Object_PaidType (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PaidType (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PaidType(
 INOUT ioId                       Integer   ,    -- ключ объекта < Тип оплаты >
    IN inPaidTypeCode             Integer   ,    -- Тип оплаты (0 нал, 1 карта)
    IN inPaidTypeName             TVarChar  ,    -- Название типа оплаты
    IN inSession                  TVarChar       -- сессия пользователя
)
AS
$BODY$
   DECLARE
     vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PaidType());
  vbUserId := inSession;

  -- проверили корректность кода типа оплаты
  IF not (inPaidTypeCode in (-10,0,1))
  THEN
    RAISE EXCEPTION 'Ошибка.Код типа оплаты <%> должен быть либо 0 либо 1.', inPaidType;
  END IF;
   
  -- Если такая запись есть - достаем её ключу код типа оплаты
  SELECT Object_PaidType_View.Id
    INTO ioId
  from Object_PaidType_View
  Where
    Object_PaidType_View.PaidTypeCode = inPaidTypeCode;
  -- сохранили/получили <Объект> по ИД
  ioId := lpInsertUpdate_Object (ioId, zc_Object_PaidType(), inPaidTypeCode, inPaidTypeName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PaidType (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PaidType(0,-10,'Тест','3')
-- SELECT * FROM lpdelete_object(402721,'3')
