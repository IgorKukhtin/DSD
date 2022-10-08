-- Function: gpUpdate_Goods_isStealthBonuses()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isStealthBonuses(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isStealthBonuses(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inisStealthBonuses        Boolean  ,    -- Стелс для бонусов мобильного приложения
    IN inSession                 TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;
   
   vbUserId := lpGetUserBySession (inSession);
   
/*   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) 
   THEN
       RAISE EXCEPTION 'Ошибка. У васнет правв изменять признак "Стелс для бонусов мобильного приложения".';
   END IF;      */

   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_StealthBonuses(), inGoodsMainId, NOT inisStealthBonuses);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isStealthBonuses = NOT inisStealthBonuses
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isStealthBonuses', text_var1::TVarChar, vbUserId);
   END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.20                                                       *  

*/

-- тест
--select * from gpUpdate_Goods_isStealthBonuses(inGoodsMainId := 39513 , inisStealthBonuses := '',  inSession := '3');