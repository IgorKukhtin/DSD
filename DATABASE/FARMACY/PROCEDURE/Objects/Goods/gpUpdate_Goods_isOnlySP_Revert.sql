-- Function: gpUpdate_Goods_isOnlySP_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isOnlySP_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isOnlySP_Revert(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inisOnlySP                Boolean  ,    -- Только для СП "Доступные лики"
    IN inSession                 TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  
                  WHERE UserId = vbUserId AND RoleId in (11041603, zc_Enum_Role_Admin())) 
   THEN
       RAISE EXCEPTION 'Ошибка. У васнет правв изменять признак Только для СП "Доступні ліки".';
   END IF;
   
   
   -- сохранили свойство <Перечень аналогов товара>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_OnlySP(), inGoodsMainId, NOT inisOnlySP);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isOnlySP = NOT inisOnlySP
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inOnlySP', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.03.21                                                       *  

*/

-- тест
--select * from gpUpdate_Goods_isOnlySP_Revert(inGoodsMainId := 39513 , inisOnlySP := '',  inSession := '3');