-- Function: gpUpdate_Object_Goods_SiteUpdate_One()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_SiteUpdate_One(Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_SiteUpdate_One(
    IN inId                   Integer   ,   -- ключ объекта <Товар>
    IN inisNewData            Boolean  ,    -- 
    IN inFieldUpdate          Integer  ,    -- 
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
   
   UPDATE Object_Goods_Main SET isNameUkrSite      = CASE WHEN inFieldUpdate = 1 THEN NOT inisNewData ELSE isNameUkrSite END
                              , isMakerNameSite    = CASE WHEN inFieldUpdate = 2 THEN NOT inisNewData ELSE isMakerNameSite END
                              , isMakerNameUkrSite = CASE WHEN inFieldUpdate = 3 THEN NOT inisNewData ELSE isMakerNameUkrSite END
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
select * from gpUpdate_Object_Goods_SiteUpdate_One(inId := 18177 , inisNewData := 'True' , inFieldUpdate := 1,  inSession := '3');