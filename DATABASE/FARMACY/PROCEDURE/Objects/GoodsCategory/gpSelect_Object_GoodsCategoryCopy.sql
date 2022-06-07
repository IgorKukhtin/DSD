-- Function: gpSelect_Object_GoodsCategoryCopy()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsCategoryCopy (Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsCategoryCopy(
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
   

    PERFORM gpInsertUpdate_Object_GoodsCategoryCopy(inId              := T1.Id
                                                  , inGoodsId         := T1.GoodsId 
                                                  , inUnitCategoryId  := T1.UnitCategoryId
                                                  , inUnitId          := T1.UnitId
                                                  , inValue           := T1.Value
                                                  , inisErased        := T1.isErased 
                                                  , inSession         := '3') 
                                                    
    FROM (
      WITH tmpGoodsCategoryFrom AS (SELECT * 
                                    FROM gpSelect_Object_GoodsCategory(inUnitCategoryId := 0 , inUnitId := inUnitFromId , inisUnitList := 'False' , inShowAll := 'False' , inisErased := 'True' ,  inSession := inSession))
         , tmpGoodsCategoryTo AS (SELECT * 
                                  FROM gpSelect_Object_GoodsCategory(inUnitCategoryId := 0 , inUnitId := inUnitToId , inisUnitList := 'False' , inShowAll := 'False' , inisErased := 'True' ,  inSession := inSession))
                                  
      SELECT COALESCE (tmpGoodsCategoryTo.Id, 0)              AS Id
           , COALESCE (tmpGoodsCategoryFrom.GoodsId, 
                       tmpGoodsCategoryTo.GoodsId)            AS GoodsId
           , COALESCE (tmpGoodsCategoryTo.UnitCategoryId, 0)  AS UnitCategoryId
           , inUnitToId                                       AS UnitId
           , COALESCE (tmpGoodsCategoryFrom.Value, 0)         AS Value
           , COALESCE (tmpGoodsCategoryFrom.isErased , True)  AS isErased 
      FROM tmpGoodsCategoryFrom
      
           FULL JOIN tmpGoodsCategoryTo ON  tmpGoodsCategoryTo.GoodsId = tmpGoodsCategoryFrom.GoodsId
           
      WHERE COALESCE(tmpGoodsCategoryFrom.Value, 0) <> COALESCE(tmpGoodsCategoryTo.Value, 0)
         OR tmpGoodsCategoryFrom.isErased is Null and COALESCE(tmpGoodsCategoryTo.isErased, True) = False) AS T1;
         
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.06.22                                                       *

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_GoodsCategoryCopy (5120968, 8393158, '3')                                     