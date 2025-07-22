-- Function: gpSelect_Scale_Gofro()

DROP FUNCTION IF EXISTS gpSelect_Scale_Gofrot (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Gofro (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Gofro(
    IN inBranchCode       Integer,      --
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (GuideId         Integer
             , GuideCode       Integer
             , GuideName       TVarChar
             , MeasureId       Integer
             , MeasureName     TVarChar
             , isErased        Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT DISTINCT
              Object_Goods.Id             AS GoodsId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , Object_Measure.Id           AS MeasureId
            , Object_Measure.ValueData    AS MeasureName
            , Object_Goods.isErased
       FROM Object AS Object_Goods

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object  AS Object_Measure   ON Object_Measure.Id   = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

       WHERE Object_Goods.DescId   = zc_Object_Goods()
         AND Object_Goods.isErased = FALSE
         AND (Object_Goods.ValueData ILIKE '%гофро%'
           OR Object_Goods.ValueData ILIKE '%Ящик%'
           OR Object_Goods.ValueData ILIKE '%Поддон%'
             )
         AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные  + Оборотная тара
                                                     , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                      )

       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.25                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Scale_Gofro (inBranchCode:= 1, inSession:=zfCalc_UserAdmin())
