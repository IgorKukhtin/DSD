 -- Function: gpReport_GoodsRemainsUKTZED()

DROP FUNCTION IF EXISTS gpReport_GoodsRemainsUKTZED (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsRemainsUKTZED(
    IN inRemainsDate      TDateTime,  -- Дата остатка
    IN inUnitId           Integer  ,  -- Подразделение
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalId  Integer, JuridicalName  TVarChar
             , UnitId Integer, UnitName TVarChar

             , GoodsCode Integer, GoodsName TVarChar, NDS TFloat
             , Amount TFloat, Price TFloat, Summa TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
        WITH   
        
           tmpDPContainer AS (SELECT ContainerLinkObject_DivisionParties.Containerid
                              FROM ObjectBoolean AS ObjectBoolean_BanFiscalSale
                              
                                   LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                 ON ContainerLinkObject_DivisionParties.ObjectId = ObjectBoolean_BanFiscalSale.ObjectId
                                                                AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                                
                              WHERE ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()),
           tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                       FROM ObjectLink AS ObjectLink_Unit_Juridical

                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                 AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                                                  
                       WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                         AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                         AND (ObjectLink_Unit_Juridical.ObjectId = inUnitId OR inUnitId = 0)),
           tmpContainer AS (SELECT Container.Id  
                                 , Container.ObjectID          AS GoodsId
                                 , Container.WhereObjectId     AS UnitId
                                 , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                            FROM tmpDPContainer

                                 INNER JOIN Container ON Container.ID = tmpDPContainer.Containerid

                                 INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId

                                 LEFT JOIN MovementItemContainer AS MIContainer 
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.OperDate >= inRemainsDate
                            WHERE Container.DescId = zc_Container_count()
                            GROUP BY Container.Id  
                                   , Container.Amount 
                                   , Container.ObjectId
                                   , Container.WhereObjectId 
                            HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0),
           tmpData AS (SELECT Container.GoodsId
                            , Container.UnitId
                            , Sum(Container.Amount)       AS Amount
                         FROM tmpContainer AS Container
                         GROUP BY Container.GoodsId
                                , Container.UnitId
                         ), 
           tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                            THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                            ELSE ROUND (Price_Value.ValueData, 2)
                                       END :: TFloat                           AS Price
                                     , Price_Goods.ChildObjectId               AS GoodsId
                                     , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                               FROM tmpData
                               
                                   INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                         ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                        AND ObjectLink_Price_Unit.ChildObjectId = tmpData.UnitId
                                                         
                                   INNER JOIN ObjectLink AS Price_Goods
                                                         ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                        AND Price_Goods.ChildObjectId = tmpData.GoodsId
                                                        
                                   LEFT JOIN ObjectFloat AS Price_Value
                                                         ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                        AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                   -- Фикс цена для всей Сети
                                   LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                          ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                         AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                           ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                          AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                               )


        -- Результат
        SELECT Object_Juridical.Id                                   AS JuridicalId
             , Object_Juridical.ValueData                            AS JuridicalName
             , Object_Unit.Id                                        AS UnitId
             , Object_Unit.ValueData                                 AS UnitName
             , Object_Goods_Main.ObjectCode                          AS GoodsCode
             , Object_Goods_Main.Name                                AS GoodsName
             
             , ObjectFloat_NDSKind_NDS.ValueData                     AS NDS
             , tmpData.Amount ::TFloat                               AS Amount
             , tmpObject_Price.Price::TFloat                         AS Price
             , Round(tmpData.Amount * tmpObject_Price.Price, 2)::TFloat AS Summa
             
        FROM tmpData

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = tmpData.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpData.GoodsId
             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                  
             LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = tmpData.UnitId
                                      AND tmpObject_Price.GoodsId = tmpData.GoodsId  
             
        ORDER BY Object_Juridical.ValueData
               , Object_Unit.ValueData

         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 02.02.21                                                                     *
*/

-- тест
--
-- 
select * from gpReport_GoodsRemainsUKTZED(inRemainsDate := ('01.01.2021')::TDateTime, inUnitId := 183292 , inJuridicalId := 0 ,  inSession := '3');