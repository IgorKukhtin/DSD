-- Function: gpUpdate_Object_DocumentTaxKind_Code(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentTaxKind_Code (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentTaxKind_Params (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DocumentTaxKind_Params(
 INOUT inId             Integer,       -- Ключ объекта <>
    IN inCode           TVarChar,       -- свойство 
    IN inGoodsName      TVarChar,
    IN inMeasureName    TVarChar,
    IN inMeasureCode    TVarChar,
    In inPrice          TFloat,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_DocumentTaxKind_Code());


   -- сохранили свойство <Код причины>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Code(), inId, inCode);
   -- сохранили свойство < >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Goods(), inId, inGoodsName);
   -- сохранили свойство < >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Measure(), inId, inMeasureName);
   -- сохранили свойство < >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_MeasureCode(), inId, inMeasureCode);
   -- сохранили свойство < >
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DocumentTaxKind_Price(), inId, inPrice);
    
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.18         *
 29.11.18         *
*/

-- тест
-- 