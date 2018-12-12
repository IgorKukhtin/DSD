 -- Function: gpUpdate_Object_Goods_Asset()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Asset (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Asset(
    IN inId                  Integer,    --
    IN inAssetId             Integer,    --
    IN inSession             TVarChar
)

RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Asset(), inId, inAssetId);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
END;
$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.12.18         *
*/
