-- Function: gpSelect_MovementItem_GoodsInventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsInventory (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsInventory(
    IN inStartDate        TDateTime,  -- Дата начала периода
    IN inEndDate          TDateTime,  -- Дата окончания периода
    IN inGoodsId     Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               InvNumber TVarChar,
               OperDate TDateTime,
               StatusCode Integer,
               StatusName TVarChar,
               UnitCode Integer,
               UnitName TVarChar,
               Remains_Amount TFloat,
               Amount TFloat,
               Saldo TFloat,
               IsErased boolean
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;

  vbUnitId Integer;
  vbOperDate TDateTime;
  vbIsFullInvent Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpInventory AS (SELECT
                                 Movement.Id                                          AS Id
                               , Movement.InvNumber                                   AS InvNumber
                               , DATE_TRUNC ('DAY', Movement.OperDate)                AS OperDate
                               , Object_Status.ObjectCode                             AS StatusCode
                               , Object_Status.ValueData                              AS StatusName
                               , Object_Unit.Id                                       AS UnitID
                               , Object_Unit.ObjectCode                               AS UnitCode
                               , Object_Unit.ValueData                                AS UnitName
                               , MovementItem.ObjectId                                AS GuudsID
                               , MovementItem.Amount                                  AS Amount
                               , MovementItem.IsErased                                AS IsErased
                          FROM MovementItem

                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                  AND Movement.DescId = zc_Movement_Inventory()
                                                  AND Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                                  AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'

                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                               LEFT JOIN Object AS Object_Unit
                                                ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                          WHERE MovementItem.ObjectId = inGoodsId),
         tmpList AS (SELECT DISTINCT
                            tmpInventory.Id
                          , tmpInventory.OperDate
                          , tmpInventory.UnitID
                          , tmpInventory.GuudsID
                     FROM tmpInventory),
         tmpRemans AS (
                                SELECT
                                       T0.OperDate
                                     , T0.WhereObjectId
                                     , SUM (T0.Amount) :: TFloat AS Amount
                                FROM(
                                        -- остатки
                                        SELECT
                                             Container.Id
                                           , tmpList.OperDate
                                           , Container.WhereObjectId
                                           , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                                        FROM tmpList
                                             INNER JOIN Container ON Container.ObjectId = tmpList.GuudsID
                                                                 AND Container.WhereObjectId = tmpList.UnitID
                                                                 AND Container.DescID = zc_Container_Count()

                                             LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                                  AND MovementItemContainer.Operdate >= tmpList.OperDate + INTERVAL '1 DAY'
                                        GROUP BY Container.Id
                                               , tmpList.OperDate
                                               , Container.WhereObjectId
                                        HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                                        UNION ALL
                                        -- надо минуснуть то что в проводках (тогда получим расчетный остаток, при этом фактический - это тот что вводит пользователь)
                                        SELECT
                                             Container.Id
                                           , tmpList.OperDate
                                           , Container.WhereObjectId
                                           , -1 * SUM (MovementItemContainer.Amount) AS Amount
                                        FROM tmpList
                                             INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = tmpList.Id
                                                                             AND MovementItemContainer.DescID = zc_MIContainer_Count()
                                             INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                                 AND Container.WhereObjectId = tmpList.UnitID
                                                                 AND Container.ObjectId = tmpList.GuudsID
                                        GROUP BY Container.Id
                                               , tmpList.OperDate
                                               , Container.WhereObjectId
                                    ) as T0
                                GROUP BY T0.OperDate
                                       , T0.WhereObjectId
                                HAVING SUM (T0.Amount) <> 0)

    SELECT
             tmpInventory.Id                                          AS Id
           , tmpInventory.InvNumber                                   AS InvNumber
           , tmpInventory.OperDate::TDateTime                         AS OperDate
           , tmpInventory.StatusCode                                  AS StatusCode
           , tmpInventory.StatusName                                  AS StatusName
           , tmpInventory.UnitCode                                    AS UnitCode
           , tmpInventory.UnitName                                    AS UnitName
           , tmpRemans.Amount                                         AS Remains_Amount
           , tmpInventory.Amount                                      AS Amount
           , (tmpInventory.Amount  - COALESCE(tmpRemans.Amount, 0))::TFloat AS Saldo
           , tmpInventory.IsErased                                    AS IsErased
    FROM tmpInventory
         LEFT OUTER JOIN tmpRemans ON tmpRemans.OperDate = tmpInventory.OperDate
                                  AND tmpRemans.WhereObjectId = tmpInventory.UnitID
    ORDER BY tmpInventory.OperDate;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_GoodsInventory (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Шаблий О.В.
 09.04.19                                                                     *
*/

-- тест
--
SELECT * FROM gpSelect_MovementItem_GoodsInventory (inStartDate := ('01.10.2015')::TDateTime , inEndDate := ('26.11.2016')::TDateTime , inGoodsId:= 21310, inSession:= '3')

