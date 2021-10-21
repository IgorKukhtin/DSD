-- Function: gpUpdate_Object_Juridical_Params()

--DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_Params (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_Params(
 INOUT ioId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inJuridicalGroupId    Integer   ,    -- Группы юридических лиц
    IN inRetailId            Integer   ,    -- Торговая сеть    
    IN inRetailReportId      Integer   ,    -- Торговая сеть(отчет)
    IN inSummOrderMin        TFloat    ,    -- Минимальный заказ с суммой >= 
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
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_RetailReport(), ioId, inRetailReportId);


   -- если меняестся парам. SummOrderMin проверка прав
   IF COALESCE ((SELECT ObjectFloat_SummOrderMin.ValueData
                 FROM ObjectFloat AS ObjectFloat_SummOrderMin
                 WHERE ObjectFloat_SummOrderMin.ObjectId = ioId
                   AND ObjectFloat_SummOrderMin.DescId = zc_ObjectFloat_Juridical_SummOrderMin()),0) <> inSummOrderMin
   THEN
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_SummOrderMin());

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_SummOrderMin(), ioId, inSummOrderMin);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_Juridical_Params  (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.21         * inSummOrderMin
 22.06.15                                        * all
 20.11.14         *
 07.11.14         * RetailReport изменено
 27.10.14                                        * add inJuridicalGroupId
 25.05.14                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Juridical_Params()
