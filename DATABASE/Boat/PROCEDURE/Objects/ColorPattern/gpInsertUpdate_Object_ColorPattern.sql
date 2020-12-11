-- Function: gpInsertUpdate_Object_ColorPattern()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ColorPattern(Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ColorPattern(
 INOUT ioId               Integer   ,    -- ключ объекта <Лодки>
    IN inCode             Integer   ,    -- Код объекта 
    IN inName             TVarChar  ,    -- Название объекта
    IN inModelId          Integer   ,
    IN inUserCode         TVarChar  ,    -- пользовательский код
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbModelName TVarChar;
   DECLARE vbModelCode TVarChar;
   DECLARE vbBrandName TVarChar;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_ColorPattern()); 

   SELECT Model.ValueData              AS ModelName
        , Model.ObjectCode :: TVarChar AS Code
        , Object_Brand.ValueData       AS BrandName
  INTO vbModelName, vbModelCode, vbBrandName
   FROM Object AS Model
        LEFT JOIN ObjectLink AS ObjectLink_Brand
                             ON ObjectLink_Brand.ObjectId = Model.Id
                            AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
        LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
   WHERE Model.DescId = zc_Object_ProdModel() AND Model.Id = inModelId;

   inUserCode := (CASE WHEN COALESCE (inUserCode,'') <>'' THEN inUserCode ELSE COALESCE (vbModelCode,'') END) :: TVarChar;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ColorPattern(), inCode, COALESCE (vbBrandName,'')||'-'||COALESCE (vbModelName,'')||'-'||COALESCE (inComment,'')||'-'||COALESCE (inUserCode,''));

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ColorPattern_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ColorPattern_Code(), ioId, COALESCE (inUserCode, vbModelCode,''));

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ColorPattern_Model(), ioId, inModelId);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (корр)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ColorPattern()
