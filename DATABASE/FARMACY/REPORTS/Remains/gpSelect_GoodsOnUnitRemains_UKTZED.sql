-- Function: gpSelect_GoodsOnUnitRemains_Data

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_UKTZED (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_UKTZED(
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (ObjectCode Integer
             , GoodsName  TVarChar

             , Remains    TFloat
             , UKTZED     TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

-- raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
    SELECT Container.ObjectId
         , sum(Container.Amount)::TFloat    AS Amount
    FROM Container
    WHERE Container.DescId        = zc_Container_Count()
      AND Container.Amount        <> 0
      AND Container.WhereObjectId IN (SELECT tmp.Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp)
    GROUP BY Container.ObjectId;
                       
    ANALYSE tmpContainer;
    
    RETURN QUERY
    WITH
         tmpGoodsUKTZED AS (SELECT Object_Goods_Juridical.GoodsMainId
                                 , Object_Goods_Juridical.UKTZED
                                 , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Juridical.GoodsMainId
                                                ORDER BY COALESCE(Object_Goods_Juridical.AreaId, 0), Object_Goods_Juridical.JuridicalId) AS Ord
                            FROM Object_Goods_Juridical
                            WHERE COALESCE (Object_Goods_Juridical.UKTZED, '') <> ''
                              AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) >= 4
                              AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
                              AND Object_Goods_Juridical.GoodsMainId <> 0
                            )

    SELECT Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name AS GoodsName
         , tmpContainer.Amount
         , COALESCE(tmpGoodsUKTZED.UKTZED, CASE WHEN length(REPLACE(REPLACE(REPLACE(Object_Goods_Main.CodeUKTZED, ' ', ''), '.', ''), Chr(160), '')) >= 4
                                                 AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Main.CodeUKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
                                                THEN Object_Goods_Main.CodeUKTZED END)::TVarChar
         
    FROM tmpContainer

         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.ObjectId
         INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

         LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Main.Id
                                 AND tmpGoodsUKTZED.Ord = 1
                                 
   ORDER BY Object_Goods_Main.ObjectCode
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_Data (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.23                                                       *
*/

-- тест
--

SELECT * FROM gpSelect_GoodsOnUnitRemains_UKTZED ('3')