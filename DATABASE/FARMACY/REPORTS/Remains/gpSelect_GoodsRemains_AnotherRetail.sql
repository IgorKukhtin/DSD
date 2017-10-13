-- Function: gpSelect_GoodsRemains_AnotherRetail()
DROP FUNCTION IF EXISTS gpSelect_GoodsRemains_AnotherRetail (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsRemains_AnotherRetail(
    IN inSession          TVarChar    -- сессия пользователя
    )

RETURNS TABLE (ContainerId  Integer
             , ObjectName   TVarChar
             , UnitName     TVarChar
             , RetailName   TVarChar
             , GoodsId      Integer
             , GoodsCode    Integer
             , GoodsName    TVarChar
             , Amount       TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    
    SELECT Container.Id                AS ContainerId
         , Object_Object.ValueData     AS ObjectName
         , Object_Unit.ValueData       AS UnitName
         , Object_Retail.ValueData     AS RetailName
         , Object_Goods.Id             AS GoodsId
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName
         , Container.Amount            AS Amount 
    FROM Container 
         inner join Object  AS Object_Goods on Object_Goods .Id = Container .ObjectId
         -- связь с Юридические лица или Торговая сеть или ...
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                              ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
         LEFT JOIN Object  AS Object_Object ON Object_Object.Id = ObjectLink_Goods_Object.ChildObjectId

           LEFT JOIN Object  AS Object_Unit ON Object_Unit.Id = Container.WhereObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

    WHERE Container.DescId = 1
      and Container.Amount <> 0
      and Object_Retail.Id <> Object_Object.Id
      
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsRemains_AnotherRetail (inSession := '3')
