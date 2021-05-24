-- Function: gpSelect_Object_PartionRemains()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionRemains(TVarChar);
                        
CREATE OR REPLACE FUNCTION gpSelect_Object_PartionRemains(
    IN inSession     TVarChar       -- сессия пользователя
) 
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitName TVarChar
             , PartionGoodsId Integer, PartionGoodsName TVarChar
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   RETURN QUERY 
       SELECT 
             Object_PartionRemains.Id
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_PartionGoods.Id         AS PartionGoodsId
           , Object_PartionGoods.ValueData  AS PartionGoodsName
           , Object_PartionRemains.isErased
       FROM Object AS Object_PartionRemains
            LEFT JOIN ObjectLink AS ObjectLink_PartionGoods
                                 ON ObjectLink_PartionGoods.ObjectId = Object_PartionRemains.Id
                                AND ObjectLink_PartionGoods.DescId = zc_ObjectLink_PartionRemains_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = ObjectLink_PartionGoods.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_Unit 
                                 ON ObjectLink_Unit.ObjectId = Object_PartionRemains.Id 
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionRemains_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId 

       WHERE Object_PartionRemains.DescId = zc_Object_PartionRemains()
;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionRemains ('2')
