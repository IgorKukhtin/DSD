-- Function: gpReport_GoodsPartionDate0()

DROP FUNCTION IF EXISTS gpReport_GoodsPartionDate0 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsPartionDate0 (
    IN inUnitId         Integer ,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitID Integer, UnitCode Integer, UnitName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               Amount TFloat, ExpirationDate TDateTime
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpMovement AS (SELECT Movement.Id
                               , MovementLinkObject_From.ObjectId         AS UnitID
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                              INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                            ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()

                              INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                        AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

                         WHERE Movement.DescId =  zc_Movement_Send()
                           AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()
                           AND MovementBoolean_Deferred.ValueData = True
                         )
       , tmpMovementItem AS (SELECT Movemen.UnitID
                                  , MIFloat_ContainerId.ValueData :: Integer           AS ContainerId
                                  , MovementItem.ObjectId
                                  , MovementItem.Amount
                                  , ContainerLinkObject.ObjectId                       AS PartionGoodsId
                             FROM tmpMovement AS Movemen

                                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movemen.Id
                                                        AND MovementItem.DescId = zc_MI_Child()
                                                        AND MovementItem.Amount > 0
                                                        AND MovementItem.isErased = False

                                  LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                              ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                 LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MIFloat_ContainerId.ValueData::Integer
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                            )

       , tmpPDContainer AS (SELECT Container.UnitID
                                 , Container.ObjectId
                                 , Container.Amount
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())   AS ExpirationDate
                            FROM tmpMovementItem AS Container

                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = Container.PartionGoodsId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()


                            )


    SELECT Object_Unit.ID                         AS UnitID
         , Object_Unit.ObjectCode                 AS UnitCode
         , Object_Unit.ValueData                  AS UnitName
         , Container.ObjectId                     AS GoodsId
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Container.Amount                       AS Amount
         , Container.ExpirationDate::TDateTime    AS ExpirationDate
    FROM tmpPDContainer AS Container

         LEFT JOIN Object AS Object_Unit
                          ON Object_Unit.Id = Container.UnitID

         LEFT JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Container.ObjectId
    ;

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
-- SELECT * FROM gpReport_GoodsPartionDate0(inUnitId :=  183292, inSession := '3')
-- SELECT * FROM gpReport_GoodsPartionDate0(inUnitId :=  0, inSession := '3')