-- Function: lpInsertUpdate_Object_Juridicall_PrintKindItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Juridical_PrintKindItem(
 INOUT ioId                  Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inUserId              Integer       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbId_calc Integer;   
BEGIN
   
   vbId_calc := lpInsertFind_Object_PrintKindItem(inisMovement, inisAccount, inisTransport, inisQuality, inisPack, inisSpec, inisTax );
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_PrintKindItem(), ioId, vbId_calc);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.15         * 
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Juridical_PrintKindItem(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')