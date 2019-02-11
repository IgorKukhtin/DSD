-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpGet_DefaultReportParams (TVarChar);
DROP FUNCTION IF EXISTS gpGet_DefaultReportParams (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_DefaultReportParams(
    IN inReportName       TVarChar ,  -- Название отчета
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (StartDate TDateTime, EndDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , UnitGroupId Integer, UnitGroupName TVarChar
             , GoodsGroupId_gp Integer, GoodsGroupName_gp TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , UnitId_To Integer, UnitName_To TVarChar
              )
AS
$BODY$
DECLARE
  vbUserId Integer;
    DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession(inSession);

     -- Результат
     RETURN QUERY  
           SELECT DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 DAY') :: TDateTime   AS StartDate
                , (CURRENT_DATE - INTERVAL '1 DAY')  :: TDateTime  AS EndDate
                , Object_Unit.Id                 AS UnitId
                , Object_Unit.ValueData          AS UnitName

                , Object_UnitGroup.Id            AS UnitGroupId
                , Object_UnitGroup.ValueData     AS UnitGroupName     

                , Object_GoodsGroupGP.Id         AS GoodsGroupId_gp
                , Object_GoodsGroupGP.ValueData  AS GoodsGroupName_gp

                , Object_GoodsGroup.Id           AS GoodsGroupId
                , Object_GoodsGroup.ValueData    AS GoodsGroupname

                , 0                              AS UnitId_To
                , '' ::TVarChar                  AS UnitName_To

           FROM Object AS Object_Unit
                LEFT JOIN Object AS Object_UnitGroup ON Object_UnitGroup.Id = 8460        -- группа складов Возвраты общие
                LEFT JOIN Object AS Object_GoodsGroupGP ON Object_GoodsGroupGP.Id = 1832  -- группа товаров ГП
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = 1979      -- группа товаров Тушенка
           WHERE Object_Unit.Id = 8459                                                    -- Склад Реализации
              AND inReportName NOT IN ('Report_Goods_byMovementReal', 'Report_ReceiptSaleAnalyzeReal')

        UNION
           SELECT DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 DAY') :: TDateTime   AS StartDate
                , (CURRENT_DATE - INTERVAL '1 DAY')  :: TDateTime  AS EndDate
                , 0                              AS UnitId
                , '' ::TVarChar                  AS UnitName

                , 0                              AS UnitGroupId
                , '' ::TVarChar                  AS UnitGroupName     

                , Object_GoodsGroupGP.Id         AS GoodsGroupId_gp
                , Object_GoodsGroupGP.ValueData  AS GoodsGroupName_gp

                , Object_GoodsGroup.Id           AS GoodsGroupId
                , Object_GoodsGroup.ValueData    AS GoodsGroupname

                , 0                              AS UnitId_To
                , '' ::TVarChar                  AS UnitName_To

           FROM Object AS Object_GoodsGroupGP 
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = 1979      -- группа товаров Тушенка
           WHERE Object_GoodsGroupGP.Id = 1832                                            -- группа товаров ГП
            AND inReportName = 'Report_Goods_byMovementReal'
        UNION
           SELECT DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 DAY') :: TDateTime   AS StartDate
                , (CURRENT_DATE - INTERVAL '1 DAY')  :: TDateTime  AS EndDate
                , 0                              AS UnitId
                , '' ::TVarChar                  AS UnitName

                , 0                              AS UnitGroupId
                , '' ::TVarChar                  AS UnitGroupName     

                , 0                              AS GoodsGroupId_gp
                , '' ::TVarChar                  AS GoodsGroupName_gp

                , 0                              AS GoodsGroupId
                , '' ::TVarChar                  AS GoodsGroupname

                , 0                              AS UnitId_To
                , '' ::TVarChar                  AS UnitName_To

           WHERE inReportName = 'Report_ReceiptSaleAnalyzeReal'
    ;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.19         *
 04.12.16         *  
*/

-- тест
-- SELECT * FROM gpGet_DefaultReportParams (inReportName:= '', inSession:= '5');
-- select * from gpGet_DefaultReportParams(inReportName := 'Report_Goods_byMovementReal' ,  inSession := '5');