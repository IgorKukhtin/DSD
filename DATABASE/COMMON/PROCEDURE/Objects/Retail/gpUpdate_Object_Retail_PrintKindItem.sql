-- Function: gpUpdate_Object_Retail_PrintKindItem()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_PrintKindItem (Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_PrintKindItem(
 INOUT ioId                  Integer   ,  -- ключ объекта <Торговая сеть> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_PrintKindItem());

    -- сохранили <Объект>
   ioId := lpInsertUpdate_Object_Retail_PrintKindItem (ioId	      := ioId
                                                     , inisMovement   := inisMovement
                                                     , inisAccount    := inisAccount
                                                     , inisTransport  := inisTransport
                                                     , inisQuality    := inisQuality
                                                     , inisPack       := inisPack
                                                     , inisSpec       := inisSpec
                                                     , inisTax        := inisTax
                                                     , inUserId       := vbUserId
                                                      );

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Retail_PrintKindItem(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')