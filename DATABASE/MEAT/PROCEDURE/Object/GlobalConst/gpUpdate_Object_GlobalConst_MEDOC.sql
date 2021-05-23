DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst_MEDOC (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst_MEDOC(
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили <Дату разнесения выписок>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_GlobalConst_ActualBankStatement(), zc_Enum_GlobalConst_MedocTaxDate(), CURRENT_DATE);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (zc_Enum_GlobalConst_MedocTaxDate(), vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.06.15                         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Car()
