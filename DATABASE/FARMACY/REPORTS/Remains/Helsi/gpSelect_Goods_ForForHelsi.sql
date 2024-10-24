-- Function: gpSelect_Goods_ForForHelsi

DROP FUNCTION IF EXISTS gpSelect_Goods_ForForHelsi (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Goods_ForForHelsi(
    IN inSession TVarChar  -- сессия пользователя
)
RETURNS TABLE (Code       Integer
             , Name       TVarChar
             , Producer   TVarChar
             , Code1      Integer
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    WITH
     tmpUnit AS
              (SELECT
                     Object_Unit_View.ID
               FROM Object_Unit_View AS Object_Unit_View

                    INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit_View.Id
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                    INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                         AND ObjectLink_Juridical_Retail.ChildObjectId = 4

                    INNER JOIN ObjectString AS ObjectString_Unit_Address
                                            ON ObjectString_Unit_Address.ObjectId  = Object_Unit_View.Id
                                           AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

               WHERE Object_Unit_View.isErased = False
                 AND Object_Unit_View.Name NOT ILIKE '%закрыта%'
                 AND COALESCE (ObjectString_Unit_Address.ValueData, '') <> ''
                 AND Object_Unit_View.Id <> 11460971)
   , tmpContainer AS
                   (SELECT DISTINCT Container.ObjectId
                    FROM Container
                         INNER JOIN tmpUnit ON tmpUnit.Id = Container.WhereObjectId
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.Amount        > 0
                   )
   , tmpProducer AS (SELECT Object_Goods_Juridical.GoodsMainId
                          , Object_Goods_Juridical.MakerName
                          , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Juridical.GoodsMainId ORDER BY Object_Goods_Main.LastPrice DESC) AS Ord

                     FROM Object_Goods_Juridical
                          INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Juridical.GoodsMainId
                     WHERE COALESCE(Object_Goods_Juridical.MakerName, '') <> '')


    SELECT Object_Goods_Main.ObjectCode                                             AS Code
         , Object_Goods_Main.Name                                                   AS Name
         , tmpProducer.MakerName                                                    AS Producer
         , Object_Goods_Main.MorionCode                                             AS Code1

    FROM tmpContainer

         INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.ObjectId

         INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                     AND Object_Goods_Main.isNotUploadSites = False

         LEFT JOIN tmpProducer ON tmpProducer.GoodsMainId = Object_Goods_Retail.GoodsMainId
                              AND tmpProducer.Ord = 1

    ORDER BY Object_Goods_Main.ObjectCode;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Goods_ForForHelsi (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.10.19                                                        *
*/

-- тест
--
SELECT * FROM gpSelect_Goods_ForForHelsi (inSession:= '3');
