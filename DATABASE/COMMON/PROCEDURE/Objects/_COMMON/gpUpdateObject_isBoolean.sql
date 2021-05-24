-- Function: gpUpdateObject_isBoolean()

DROP FUNCTION IF EXISTS gpUpdateObject_isBoolean (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_isBoolean(
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioParam               Boolean   , -- 
    IN inDesc                TVarChar  , -- 
    IN inSession             TVarChar  -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbDescId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession); 

     -- определили признак
     ioParam:= NOT ioParam;
     -- 
     vbDescId := (select Id from ObjectBooleanDesc where Code = inDesc);

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (vbDescId, inId, ioParam);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.11.15         *
*/


-- тест
--select * from gpUpdateObject_isBoolean(inId := 363541 , ioParam := 'False' , inDesc := 'zc_ObjectBoolean_ReceiptChild_WeightMain' ,  inSession := '5');
--select * from ObjectBooleanDesc where id =  zc_ObjectBoolean_ReceiptChild_TaxExit();



--select Id from ObjectBooleanDesc where Code = 'zc_ObjectBoolean_ReceiptChild_TaxExit'