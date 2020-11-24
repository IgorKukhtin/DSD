-- Function: gpInsertUpdate_Object_ProdModel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdModel(
 INOUT ioId       Integer   ,    -- ключ объекта <Модели>
    IN inCode     Integer   ,    -- Код объекта 
    IN inName     TVarChar  ,    -- Название объекта 
    IN inLength   TFloat    ,
    IN inBeam     TFloat    ,
    IN inHeight   TFloat    ,
    IN inWeight   TFloat    ,
    IN inFuel     TFloat    ,
    IN inSpeed    TFloat    ,
    IN inSeating  TFloat    ,
    IN inComment  TVarChar  ,
    IN inBrandId  Integer   ,
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdModel());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProdModel()); 

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdModel(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdModel(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdModel_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Length(), ioId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Beam(), ioId, inBeam);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Height(), ioId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Weight(), ioId, inWeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Fuel(), ioId, inFuel);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Speed(), ioId, inSpeed);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Seating(), ioId, inSeating);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdModel_Brand(), ioId, inBrandId);


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.11.20         * add inBrandId
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdModel()
