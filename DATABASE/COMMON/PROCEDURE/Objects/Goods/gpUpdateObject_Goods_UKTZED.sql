-- Function: gpUpdateObject_Goods_UKTZED()

DROP FUNCTION IF EXISTS gpUpdateObject_Goods_UKTZED (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateObject_Goods_UKTZED (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Goods_UKTZED(
    IN inId                  Integer   , -- Ключ объекта <товар>
    IN inUKTZED              TVarChar  , -- код товара по УКТ ЗЕД
    IN inTaxImport           TVarChar  , -- признак импортированного товара
    IN inDKPP                TVarChar  , -- Послуги згідно з ДКПП
    IN inTaxAction           TVarChar  , -- Код виду діяльності сільск-господар товаровиробника 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectString_Goods_UKTZED());
     vbUserId := inSession;

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_UKTZED(), inId, inUKTZED);
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_TaxImport(), inId, inTaxImport);
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_DKPP(), inId, inDKPP);
     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_TaxAction(), inId, inTaxAction);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.03.17         *
 06.01.17         *
*/


-- тест
-- SELECT * FROM gpUpdateObject_Goods_UKTZED (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')
