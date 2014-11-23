-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_Goods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods(
    IN inId          Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               MinimumLot TFloat, 
               isErased boolean
               ) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
       vbUserId := lpGetUserBySession (inSession);

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
  
   IF COALESCE (inId, 0) = 0
   THEN
       vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(GoodsCodeIntMax, 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
              
           , CAST (0 as Integer)    AS GoodsGroupId
           , CAST ('' as TVarChar)  AS GoodsGroupName  
           , COALESCE(ObjectMeasure.Id, 0)  AS MeasureId
           , COALESCE(ObjectMeasure.ValueData, ''::TVarChar)  AS MeasureName
           , COALESCE(ObjectNDSKind.Id, 0)  AS NDSKindId
           , COALESCE(ObjectNDSKind.ValueData, ''::TVarChar)  AS NDSKindName

           , 0::TFloat     AS MinimumLot

           , CAST (NULL AS Boolean) AS isErased

       FROM (SELECT MAX (Object_Goods.GoodsCodeInt) AS GoodsCodeIntMax

             FROM Object_Goods_View AS Object_Goods
            WHERE Object_Goods.ObjectId = vbObjectId) 
       AS Object_Goods
                LEFT JOIN Object AS ObjectMeasure ON ObjectMeasure.Id = lpGet_DefaultValue('TGoodsEditForm;zc_Object_Measure', vbUserId) :: Integer
                LEFT JOIN Object AS ObjectNDSKind ON ObjectNDSKind.Id = lpGet_DefaultValue('TGoodsEditForm;zc_Object_NDSKind', vbUserId) :: Integer
;
   ELSE
     RETURN QUERY 
     SELECT Object_Goods_View.Id             AS Id 
          , Object_Goods_View.GoodsCodeInt   AS Code
          , Object_Goods_View.GoodsName      AS Name
          
          , COALESCE(Object_Goods_View.GoodsGroupId, 0)   AS GoodsGroupId
          , Object_Goods_View.GoodsGroupName AS GoodsGroupName
   
          , Object_Goods_View.MeasureId      AS MeasureId
          , Object_Goods_View.MeasureName    AS MeasureName
   
          , Object_Goods_View.NDSKindId      AS NDSKindId
          , Object_Goods_View.NDSKindName    AS NDSKindName

          , Object_Goods_View.MinimumLot     AS MinimumLot

          , Object_Goods_View.isErased       AS isErased
          
     FROM Object_Goods_View
    WHERE Object_Goods_View.Id = inId;
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Goods(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.14                        *  Дефолты
 30.10.14                        *
 24.06.14         *
 20.06.13                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods('2')