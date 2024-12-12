-- Function: gpSelect_Object_UnitPeresort_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitPeresort_Unit (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitPeresort_Unit(
    IN inGoodsByGoodsKindId  Integer,
    IN inisErased            Boolean,  
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , GoodsByGoodsKindId  Integer
             , UnitId     Integer
             , UnitCode   Integer
             , UnitName   TVarChar 
             , isErased   Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
   WITH 
   tmpUnitPeresort AS (SELECT Object_UnitPeresort.Id
                            , Object_UnitPeresort.isErased
                            , ObjectLink_UnitPeresort_GoodsByGoodsKind.ChildObjectId AS GoodsByGoodsKindId
                            , ObjectLink_UnitPeresort_Unit.ChildObjectId             AS UnitId
                       FROM Object AS Object_UnitPeresort
                            INNER JOIN ObjectLink AS ObjectLink_UnitPeresort_GoodsByGoodsKind
                                                  ON ObjectLink_UnitPeresort_GoodsByGoodsKind.ObjectId = Object_UnitPeresort.Id
                                                 AND ObjectLink_UnitPeresort_GoodsByGoodsKind.DescId = zc_ObjectLink_UnitPeresort_GoodsByGoodsKind()
                                                 AND (ObjectLink_UnitPeresort_GoodsByGoodsKind.ChildObjectId = inGoodsByGoodsKindId OR inGoodsByGoodsKindId = 0)

                            LEFT JOIN ObjectLink AS ObjectLink_UnitPeresort_Unit
                                                 ON ObjectLink_UnitPeresort_Unit.ObjectId = Object_UnitPeresort.Id
                                                AND ObjectLink_UnitPeresort_Unit.DescId = zc_ObjectLink_UnitPeresort_Unit()

                       WHERE Object_UnitPeresort.DescId = zc_Object_UnitPeresort()
                         AND (Object_UnitPeresort.isErased = FALSE OR inisErased = TRUE)
                       )

     SELECT Object_UnitPeresort.Id
          , Object_UnitPeresort.GoodsByGoodsKindId
          , Object_Unit.Id                   AS UnitId
          , Object_Unit.ObjectCode           AS UnitCode      
          , Object_Unit.ValueData ::TVarChar AS UnitName
          , Object_UnitPeresort.isErased
      FROM tmpUnitPeresort AS Object_UnitPeresort
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Object_UnitPeresort.UnitId             
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.24         *
*/

-- тест
--select * from gpSelect_Object_UnitPeresort_Unit(inGoodsByGoodsKindId :=1 , inisErased:= False, inSession := '5');