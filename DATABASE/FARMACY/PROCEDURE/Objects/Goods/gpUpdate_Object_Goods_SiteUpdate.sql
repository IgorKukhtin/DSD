-- Function: gpUpdate_Object_Goods_SiteUpdate()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_SiteUpdate(Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_SiteUpdate(
    IN inId                   Integer   ,   -- ключ объекта <Товар>
    IN inisNameUkr            Boolean  ,    -- 
    IN inisMakerName          Boolean  ,    -- 
    IN inisMakerNameUkr       Boolean  ,    -- 
    IN inSession              TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  
                  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin())) 
      AND vbUserId <> 9383066 
   THEN
       RAISE EXCEPTION 'Ошибка. У васнет правв выполнения этой операции.';
   END IF;

   UPDATE Object_Goods_Main SET isNameUkrSite      = inisNameUkr
                              , isMakerNameSite    = inisMakerName
                              , isMakerNameUkrSite = inisMakerNameUkr
   WHERE Object_Goods_Main.Id = inId;  

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.05.20                                                       *  

*/

-- тест
--
select * from gpUpdate_Object_Goods_SiteUpdate(inId := 18177 , inisNameUkr := 'False' , inisMakerName := 'False' , inisMakerNameUkr := 'False' ,  inSession := '3');