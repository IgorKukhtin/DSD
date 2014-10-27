-- Function: gpUpdate_Object_Juridical_Params()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_Params(
 INOUT ioId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inJuridicalGroupId    Integer   ,    -- Группы юридических лиц
    IN inRetailId            Integer   ,    -- Торговая сеть
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции
    IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_Params());

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceList(), ioId, inPriceListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceListPromo(), ioId, inPriceListPromoId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_StartPromo(), ioId, inStartPromo);
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_EndPromo(), ioId, inEndPromo);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Juridical_Params  (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.14                                        * add inJuridicalGroupId
 25.05.14                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Juridical_Params()
