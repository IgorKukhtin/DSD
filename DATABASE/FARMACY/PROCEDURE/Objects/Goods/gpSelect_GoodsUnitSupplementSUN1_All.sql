-- Function: gpSelect_GoodsUnitSupplementSUN1_All()

DROP FUNCTION IF EXISTS gpSelect_GoodsUnitSupplementSUN1_All(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsUnitSupplementSUN1_All(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,  
               UnitId Integer, UnitCode Integer, UnitName TVarChar,  
               ParentName TVarChar, isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY 
   WITH tmpUnitSupplementSUN1Out AS (SELECT Object_Goods_Blob.Id
                                          , Object_Goods_Blob.UnitSupplementSUN1Out
                                     FROM Object_Goods_Blob  
                                     WHERE COALESCE (Object_Goods_Blob.UnitSupplementSUN1Out, '') <> '')
      
       SELECT 
             Object_Goods_Retail.Id
           , Object_Goods_Main.ObjectCode
           , Object_Goods_Main.Name
           , Object_Unit_View.Id
           , Object_Unit_View.Code
           , Object_Unit_View.Name
           , Object_Unit_View.ParentName
           , Object_Unit_View.isErased
       FROM Object_Unit_View
       
            INNER JOIN tmpUnitSupplementSUN1Out ON ','||COALESCE(tmpUnitSupplementSUN1Out.UnitSupplementSUN1Out, '')||',' ILIKE '%,'||Object_Unit_View.Id::TBlob||',%'
            
            INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = tmpUnitSupplementSUN1Out.Id
            
            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = tmpUnitSupplementSUN1Out.Id
                                          AND Object_Goods_Retail.RetailId = 4
       
       WHERE Object_Unit_View.iserased = False 
         AND COALESCE (Object_Unit_View.ParentId, 0) <> 377612
         AND Object_Unit_View.Id <> 389328
         AND Object_Unit_View.Name NOT ILIKE 'Зачинена%'
         AND COALESCE (Object_Unit_View.ParentId, 0) IN 
             (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0) 
       ORDER BY Object_Goods_Retail.Id, Object_Unit_View.Name
      ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.06.22                                                       * 

*/

-- тест
-- 

select * from gpSelect_GoodsUnitSupplementSUN1_All(inSession := '3');
