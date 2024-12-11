-- Function: gpSelect_Object_UnitPeresort()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitPeresort (Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_UnitPeresort (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitPeresort(
    IN inIsShowAll           Boolean,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsByGoodsKindId Integer
             , GoodsId  Integer
             , GoodsCode Integer
             , GoodsName  TVarChar
             , GoodsKindId  Integer
             , GoodsKindName TVarChar
             , GoodsGroupName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsIncomeId  Integer
             , GoodsIncomeCode Integer
             , GoodsIncomeName  TVarChar
             , MeasureIncomeName TVarChar
             , GoodsKindIncomeId   Integer
             , GoodsKindIncomeName TVarChar  
             , UnitName TVarChar
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
   tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.*
                                , Object_GoodsIncome.Id               AS GoodsIncomeId
                                , Object_GoodsIncome.ObjectCode       AS GoodsIncomeCode
                                , Object_GoodsIncome.ValueData        AS GoodsIncomeName
                                , Object_MeasureIncome.ValueData      AS MeasureIncomeName
                                , Object_GoodsKindIncome.Id           AS GoodsKindIncomeId
                                , Object_GoodsKindIncome.ValueData    AS GoodsKindIncomeName
                           FROM Object_GoodsByGoodsKind_View
                               LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsIncome
                                                    ON ObjectLink_GoodsByGoodsKind_GoodsIncome.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                   AND ObjectLink_GoodsByGoodsKind_GoodsIncome.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsIncome()
                               LEFT JOIN Object AS Object_GoodsIncome ON Object_GoodsIncome.Id = ObjectLink_GoodsByGoodsKind_GoodsIncome.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_GoodsIncome_Measure
                                                    ON ObjectLink_GoodsIncome_Measure.ObjectId = Object_GoodsIncome.Id
                                                   AND ObjectLink_GoodsIncome_Measure.DescId = zc_ObjectLink_Goods_Measure()
                               LEFT JOIN Object AS Object_MeasureIncome ON Object_MeasureIncome.Id = ObjectLink_GoodsIncome_Measure.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindIncome
                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKindIncome.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKindIncome.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome()
                               LEFT JOIN Object AS Object_GoodsKindIncome ON Object_GoodsKindIncome.Id = ObjectLink_GoodsByGoodsKind_GoodsKindIncome.ChildObjectId
                           WHERE Object_GoodsByGoodsKind_View.isErased = FALSE
                           )

     , tmpUnitPeresort AS (SELECT Object_UnitPeresort.Id
                                , Object_UnitPeresort.isErased
                                , ObjectLink_UnitPeresort_GoodsByGoodsKind.ChildObjectId AS GoodsByGoodsKindId
                                , ObjectLink_UnitPeresort_Unit.ChildObjectId             AS UnitId
                           FROM Object AS Object_UnitPeresort
                                LEFT JOIN ObjectLink AS ObjectLink_UnitPeresort_GoodsByGoodsKind
                                                     ON ObjectLink_UnitPeresort_GoodsByGoodsKind.ObjectId = Object_UnitPeresort.Id
                                                    AND ObjectLink_UnitPeresort_GoodsByGoodsKind.DescId = zc_ObjectLink_UnitPeresort_GoodsByGoodsKind()

                                LEFT JOIN ObjectLink AS ObjectLink_UnitPeresort_Unit
                                                     ON ObjectLink_UnitPeresort_Unit.ObjectId = Object_UnitPeresort.Id
                                                    AND ObjectLink_UnitPeresort_Unit.DescId = zc_ObjectLink_UnitPeresort_Unit()

                           WHERE Object_UnitPeresort.DescId = zc_Object_UnitPeresort()
                             AND (Object_UnitPeresort.isErased = FALSE OR inIsShowAll = TRUE)
                           
                           )

     SELECT Object_GoodsByGoodsKind.Id  AS GoodsByGoodsKindId
          , Object_GoodsByGoodsKind.GoodsId
          , Object_GoodsByGoodsKind.GoodsCode
          , Object_GoodsByGoodsKind.GoodsName
          , Object_GoodsByGoodsKind.GoodsKindId
          , Object_GoodsByGoodsKind.GoodsKindName

          , Object_GoodsGroup.ValueData                 AS GoodsGroupName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

          , Object_GoodsByGoodsKind.GoodsIncomeId
          , Object_GoodsByGoodsKind.GoodsIncomeCode
          , Object_GoodsByGoodsKind.GoodsIncomeName
          , Object_GoodsByGoodsKind.MeasureIncomeName
          , Object_GoodsByGoodsKind.GoodsKindIncomeId
          , Object_GoodsByGoodsKind.GoodsKindIncomeName   

          , STRING_AGG (DISTINCT Object_Unit.ValueData, ';') ::TVarChar AS UnitName

      FROM tmpGoodsByGoodsKind AS Object_GoodsByGoodsKind
           LEFT JOIN tmpUnitPeresort AS Object_UnitPeresort ON Object_UnitPeresort.GoodsByGoodsKindId = Object_GoodsByGoodsKind.Id
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Object_UnitPeresort.UnitId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_GoodsByGoodsKind.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()


     WHERE Object_UnitPeresort.Id IS NOT NULL 
        OR Object_GoodsByGoodsKind.GoodsIncomeId IS NOT NULL
        OR Object_GoodsByGoodsKind.GoodsKindIncomeId IS NOT NULL
        OR inIsShowAll = TRUE
     GROUP BY Object_GoodsByGoodsKind.Id 
          , Object_GoodsByGoodsKind.GoodsId
          , Object_GoodsByGoodsKind.GoodsCode
          , Object_GoodsByGoodsKind.GoodsName
          , Object_GoodsByGoodsKind.GoodsKindId
          , Object_GoodsByGoodsKind.GoodsKindName
          , Object_GoodsGroup.ValueData
          , ObjectString_Goods_GoodsGroupFull.ValueData
          , Object_GoodsByGoodsKind.GoodsIncomeId
          , Object_GoodsByGoodsKind.GoodsIncomeCode
          , Object_GoodsByGoodsKind.GoodsIncomeName
          , Object_GoodsByGoodsKind.MeasureIncomeName
          , Object_GoodsByGoodsKind.GoodsKindIncomeId
          , Object_GoodsByGoodsKind.GoodsKindIncomeName              
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
--select * from gpSelect_Object_UnitPeresort(inIsShowAll := true , inisErased:= False, inSession := '5');