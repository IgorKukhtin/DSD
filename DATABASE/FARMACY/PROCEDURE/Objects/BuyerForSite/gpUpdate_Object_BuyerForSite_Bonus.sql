-- Function: gpUpdate_Object_BuyerForSite_Bonus()

DROP FUNCTION IF EXISTS gpUpdate_Object_BuyerForSite_Bonus(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_BuyerForSite_Bonus(
    IN inId             Integer   ,     -- ключ объекта <Покупатель> 
    IN inBonus          TFloat    ,     -- Сумма бонуса
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
     RAISE EXCEPTION 'Не указано ID покупателя на сайте.';   
   END IF;
   
   IF NOT EXISTS(SELECT 1 FROM ObjectFloat 
                 WHERE ObjectFloat.DescId = zc_ObjectFloat_BuyerForSite_Bonus()
                   AND ObjectFloat.ObjectId = inId
                   AND COALESCE(ObjectFloat.ValueData, 0) = COALESCE(inBonus, 0))
   THEN
         
     -- сохранили Телефон
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BuyerForSite_Bonus(), inId, inBonus);

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