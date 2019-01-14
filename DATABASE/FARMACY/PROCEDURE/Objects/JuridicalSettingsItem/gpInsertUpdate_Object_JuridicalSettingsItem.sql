-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettingsItem (Integer, Integer, TFloat, TFloat, TVarchar);
                        gpinsertupdate_object_juridicalsettingstem
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalSettingsItem(
 INOUT ioId                      Integer ,   -- ключ объекта <>
    IN inJuridicalSettingsId     Integer ,
    IN inBonus                   TFloat  ,
    IN inPriceLimit              TFloat  ,
    IN inSession                 TVarChar    -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalSettingsItem(), 0, '');
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettingsItem_JuridicalSettings(), ioId, inJuridicalSettingsId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettingsItem_Bonus(), ioId, inBonus);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettingsItem_PriceLimit(), ioId, inPriceLimit);
     
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.19         * 
*/

-- тест                          
