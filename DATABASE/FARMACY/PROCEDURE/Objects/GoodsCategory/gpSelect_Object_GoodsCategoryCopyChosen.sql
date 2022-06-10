-- Function: gpSelect_Object_GoodsCategoryCopyChosen()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsCategoryCopyChosen (Boolean, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsCategoryCopyChosen(
    IN inisSelect                Boolean   ,    -- Выполнять
    IN inUnitFromId              Integer   ,    -- ссылка на подразделение
    IN inUnitToId                Integer   ,    -- ссылка на подразделение
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS VOID
  AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsCategory());
   vbUserId:= inSession;
   
   IF COALESCE (inisSelect, FALSE) = False
   THEN
     RETURN;
   END IF;
   
   IF NOT EXISTS(SELECT * 
                 FROM gpSelect_Object_GoodsCategory(inUnitCategoryId := 0 , inUnitId := inUnitFromId , inisUnitList := 'False' , inShowAll := 'False' , inisErased := 'True' ,  inSession := inSession))
   THEN
     RAISE EXCEPTION 'Ошибка. По подразделению <%> не найдена ассортиментная матрица.', lfGet_Object_ValueData (inUnitFromId);
   END IF;
   
   PERFORM gpSelect_Object_GoodsCategoryCopy(inUnitFromId := inUnitFromId
                                           , inUnitToId   := inUnitToId
                                           , inSession    := inSession);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%>', inSession, inisSelect, lfGet_Object_ValueData (inUnitFromId), lfGet_Object_ValueData (inUnitToId);
    END IF;
       
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.06.22                                                       *

*/

-- тест
-- select * from gpSelect_Object_GoodsCategoryCopyChosen(inisSelect := 'True' , inUnitFromId := 0 , inUnitToId := 9951517 ,  inSession := '3');
