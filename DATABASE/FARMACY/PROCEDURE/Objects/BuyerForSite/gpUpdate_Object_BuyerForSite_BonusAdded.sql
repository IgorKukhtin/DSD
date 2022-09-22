-- Function: gpUpdate_Object_BuyerForSite_BonusAdded()

DROP FUNCTION IF EXISTS gpUpdate_Object_BuyerForSite_BonusAdded(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_BuyerForSite_BonusAdded(
    IN inId             Integer   ,     -- ключ объекта <Покупатель> 
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_BuyerForSite());
      vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE(inId, 0) = 0
   THEN
     RETURN;   
   END IF;
         
   IF EXISTS(SELECT 1 FROM ObjectFloat 
             WHERE ObjectFloat.DescId = zc_ObjectFloat_BuyerForSite_BonusAdd()
               AND ObjectFloat.ObjectId = inId
               AND COALESCE(ObjectFloat.ValueData, 0) <> 0)
   THEN
         
     -- сохранили 
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BuyerForSite_Bonus(), inId, 
               (SELECT SUM( COALESCE(ObjectFloat.ValueData, 0)) FROM ObjectFloat 
                WHERE ObjectFloat.DescId IN (zc_ObjectFloat_BuyerForSite_BonusAdd(), zc_ObjectFloat_BuyerForSite_Bonus())
                  AND ObjectFloat.ObjectId = inId));

     -- сохранили 
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BuyerForSite_BonusAdded(), inId, 
               (SELECT SUM( COALESCE(ObjectFloat.ValueData, 0)) FROM ObjectFloat 
                WHERE ObjectFloat.DescId IN (zc_ObjectFloat_BuyerForSite_BonusAdd(), zc_ObjectFloat_BuyerForSite_BonusAdded())
                  AND ObjectFloat.ObjectId = inId));

     -- сохранили 
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BuyerForSite_BonusAdd(), inId, 0);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   END IF;
      
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.09.22                                                       *
*/

-- тест  