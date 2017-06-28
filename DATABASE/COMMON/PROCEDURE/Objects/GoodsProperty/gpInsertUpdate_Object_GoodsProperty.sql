-- Function: gpInsertUpdate_Object_GoodsProperty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsProperty (Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsProperty(
 INOUT ioId                  Integer   ,   	-- ключ объекта <Классификатор свойств товаров> 
    IN inCode                Integer   ,    -- Код объекта <Классификатор свойств товаров> 
    IN inName                TVarChar  ,    -- Название объекта <Классификатор свойств товаров> 
    IN inStartPosInt         TFloat    ,    -- Целая часть веса в штрих коде(начальная позиция)
    IN inEndPosInt           TFloat    ,    -- Целая часть веса в штрих коде(последняя позиция)
    IN inStartPosFrac        TFloat    ,    -- Дробная часть веса в штрих коде(начальная позиция)
    IN inEndPosFrac          TFloat    ,    -- Дробная часть веса в штрих коде(последняя позиция)
    IN inStartPosIdent       TFloat    ,    -- Идентификатор товара(начальная позиция)
    IN inEndPosIdent         TFloat    ,    -- Идентификатор товара(последняя позиция)
--    In inTaxDoc              TFloat    ,    -- % отклонения для вложения
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbCode Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsProperty());

   -- !!! Если код не установлен, определяем его каи последний+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_GoodsProperty());
   
   -- проверка прав уникальности для свойства <Наименование Классификатора>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsProperty(), inName);
   -- проверка прав уникальности для свойства <Код Классификатора>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsProperty(), vbCode);

   -- сохранили <Объект>  
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsProperty(), inCode, inName);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_StartPosInt(), ioId, inStartPosInt);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_EndPosInt(), ioId, inEndPosInt);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_StartPosFrac(), ioId, inStartPosFrac);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_EndPosFrac(), ioId, inEndPosFrac);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_StartPosIdent(), ioId, inStartPosIdent);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_EndPosIdent(), ioId, inEndPosIdent);
   -- сохранили свойство <>
   --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_TaxDoc(), ioId, inTaxDoc);

   -- обновили
   PERFORM lpUpdate_Object_GoodsPropertyValue_BarCodeShort (ioId, 0, vbUserId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsProperty (Integer, Integer, TVarChar, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.06.17         * del TaxDoc
 22.06.17         * add TaxDoc
 24,09,15         *
 26.05.15         * add Float
 12.02.15                                        *
 12.06.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsProperty()
