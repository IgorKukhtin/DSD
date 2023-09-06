-- Function: gpSelect_GoodsOnUnitRemains_Data

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_Data (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_Data(
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (ObjectCode Integer
             , GoodsName  TVarChar
             , MakerName  TVarChar
             , BarCode    TVarChar
             , MorionCode TVarChar
             , BadmCode TVarChar
             , BadmName TVarChar

             , OptimaCode TVarChar
             , OptimaName TVarChar
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
    SELECT DISTINCT Container.ObjectId
    FROM Container
    WHERE Container.DescId        = zc_Container_Count()
      AND Container.Amount        <> 0
      AND Container.WhereObjectId IN (SELECT tmp.Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp);
                       
    ANALYSE tmpContainer;
    
-- raise notice 'Value 2: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE tmpMakerNameAll ON COMMIT DROP AS
                           (SELECT  Object_Goods_Juridical.GoodsMainId
                                   , replace(replace(replace(COALESCE(Object_Goods_Juridical.MakerName, ''),'"',''),'&','&amp;'),'''','') AS MakerName
                                   , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId ORDER BY Object_Goods_Juridical.JuridicalId) as ORD
                            FROM
                                Object_Goods_Juridical
                            WHERE COALESCE(Object_Goods_Juridical.MakerName, '') <> ''
                           );
                       
    ANALYSE tmpMakerNameAll;

-- raise notice 'Value 3: %', CLOCK_TIMESTAMP();


    RETURN QUERY
    WITH
         tmpMakerName AS (SELECT tmpMakerNameAll.GoodsMainId
                               , tmpMakerNameAll.MakerName
                          FROM tmpMakerNameAll
                          WHERE tmpMakerNameAll.ORD = 1)
       , tmpJuridicalAll AS (SELECT Object_Goods_Juridical.GoodsMainId
                                  , Object_Goods_Juridical.JuridicalID
                                  , Object_Goods_Juridical.Code
                                  , Object_Goods_Juridical.Name
                                  , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId, Object_Goods_Juridical.JuridicalID ORDER BY Object_Goods_Juridical.ID DESC) as ORD
                             FROM  Object_Goods_Juridical
                             WHERE COALESCE( Object_Goods_Juridical.Code, '') <> ''
                             )
       , tmpJuridical AS (SELECT tmpJuridicalAll.GoodsMainId
                               , tmpJuridicalAll.Code
                               , tmpJuridicalAll.Name
                               , tmpJuridicalAll.JuridicalID
                          FROM tmpJuridicalAll
                          WHERE tmpJuridicalAll.ORD = 1)
        -- Штрих-коды производителя
       , tmpGoodsBarCode AS (SELECT Object_Goods_BarCode.GoodsMainId
                                  , string_agg(replace(replace(replace(COALESCE(Object_Goods_BarCode.BarCode, ''), '"', ''),'&','&amp;'),'''',''), ',' ORDER BY Object_Goods_BarCode.GoodsMainId, Object_Goods_BarCode.Id desc) AS BarCode
                             FROM Object_Goods_BarCode
                             GROUP BY Object_Goods_BarCode.GoodsMainId
                             )

    SELECT Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name AS GoodsName
         , tmpMakerName.MakerName::TVarChar
         , tmpGoodsBarCode.BarCode::TVarChar
         , Object_Goods_Main.MorionCode::TVarChar
         
         , tmpJuridicalBadm.Code
         , tmpJuridicalBadm.Name

         , tmpJuridicalOptima.Code
         , tmpJuridicalOptima.Name

    FROM tmpContainer

         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.ObjectId
         INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

         LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id

         LEFT JOIN tmpMakerName ON tmpMakerName.GoodsMainId = Object_Goods_Main.Id
         
         LEFT JOIN tmpJuridical AS tmpJuridicalBadm ON tmpJuridicalBadm.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                   AND tmpJuridicalBadm.JuridicalID = 59610 

         LEFT JOIN tmpJuridical AS tmpJuridicalOptima ON tmpJuridicalOptima.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                     AND tmpJuridicalOptima.JuridicalID = 59611  
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_Data (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.19                                                       *
*/

-- тест
--

SELECT * FROM gpSelect_GoodsOnUnitRemains_Data ('3')