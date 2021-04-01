-- Function: gpReport_GoodsPartionDate5()

DROP FUNCTION IF EXISTS gpReport_GoodsPartionDate5 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsPartionDate5 (
    IN inUnitId         Integer ,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitID Integer, UnitCode Integer, UnitName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, PartionDateKindName TVarChar,
               Amount TFloat, ExpirationDate TDateTime, TransferDate TDateTime,
               Sales TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;

   DECLARE vbDate0     TDateTime;

   DECLARE vbMonth_0   TFloat;
   DECLARE vbIsMonth_0 Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    -- получаем значения из справочника
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_0, vbIsMonth_0
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0();

    -- даты + 6 месяцев, + 1 месяц
    vbDate0   := CURRENT_DATE + CASE WHEN vbIsMonth_0 = TRUE THEN vbMonth_0 ||' MONTH'  ELSE vbMonth_0 ||' DAY' END :: INTERVAL;

    RETURN QUERY
    WITH tmpContainer AS (SELECT Container.Id
                               , Container.WhereObjectId
                               , Container.ObjectId
                               , Container.Amount
                               , ContainerLinkObject.ObjectId                       AS PartionGoodsId
                          FROM Container

                               LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                            AND Container.Amount <> 0
                         )
       , tmpPDContainer AS (SELECT Container.Id
                                 , Container.WhereObjectId
                                 , Container.ObjectId
                                 , Container.Amount
                                 , zc_Enum_PartionDateKind_Cat_5()                                AS PartionDateKindId
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())   AS ExpirationDate
                                 , ObjectDate_Cat_5.ValueData                                     AS TransferDate
                            FROM tmpContainer AS Container

                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = Container.PartionGoodsId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                 LEFT JOIN ObjectDate AS ObjectDate_Cat_5
                                                      ON ObjectDate_Cat_5.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_Cat_5.DescId = zc_ObjectDate_PartionGoods_Cat_5()

                            WHERE ObjectDate_ExpirationDate.ValueData <= vbDate0
                              AND COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE

                            )
       , tmpMovementItem AS (SELECT MovementItemContainer.ContainerId            AS ContainerId
                                  , SUM(- MovementItemContainer.Amount)          AS Amount
                             FROM MovementItemContainer

                                  INNER JOIN tmpPDContainer ON tmpPDContainer.ID = MovementItemContainer.ContainerId

                                  INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId

                                  INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.ParentId
                                                                   AND MovementItemLinkObject.DescId    = zc_MILinkObject_PartionDateKind()
                                                                   AND MovementItemLinkObject.ObjectId  = zc_Enum_PartionDateKind_Cat_5()


                             WHERE MovementItemContainer.MovementDescId = zc_Movement_Check()
                             GROUP BY MovementItemContainer.ContainerId)


    SELECT Object_Unit.ID                         AS UnitID
         , Object_Unit.ObjectCode                 AS UnitCode
         , Object_Unit.ValueData                  AS UnitName
         , Container.ObjectId                     AS GoodsId
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_PartionDateKind.ValueData       AS PartionDateKindName
         , Container.Amount                       AS Amount
         , Container.ExpirationDate::TDateTime    AS ExpirationDate
         , Container.TransferDate::TDateTime      AS TransferDate    
         , MovementItem.Amount::TFloat            AS Sales
    FROM tmpPDContainer AS Container

         LEFT JOIN Object AS Object_Unit
                          ON Object_Unit.Id = Container.WhereObjectId

         LEFT JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Container.ObjectId

         LEFT JOIN Object AS Object_PartionDateKind
                          ON Object_PartionDateKind.Id = Container.PartionDateKindId

         LEFT JOIN tmpMovementItem AS MovementItem
                          ON MovementItem.ContainerId = Container.Id;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpReport_GoodsPartionDate5(inUnitId :=  183292, inSession := '3')
-- 
SELECT * FROM gpReport_GoodsPartionDate5(inUnitId :=  0, inSession := '3')