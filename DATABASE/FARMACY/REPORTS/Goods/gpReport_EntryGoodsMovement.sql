 -- Function: gpReport_EntryGoodsMovement()

DROP FUNCTION IF EXISTS gpReport_EntryGoodsMovement (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_EntryGoodsMovement(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inGoodsId          Integer  ,  -- Товар
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (ID  Integer
             , InvNumber  TVarChar
             , OperDate TDateTime
             , StatusName TVarChar
             , DescId Integer
             , MovementName TVarChar
             , UnitName TVarChar
             , Amount TFloat
             , isErased boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
     -- Выкладки
     WITH tmpLayoutMovement AS (SELECT Movement.Id                                                   AS Id
                                     , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE)      AS isPharmacyItem
                                     , COALESCE(MovementBoolean_NotMoveRemainder6.ValueData, FALSE) AS isNotMoveRemainder6
                                FROM Movement
                                     LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                               ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                              AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_NotMoveRemainder6
                                                               ON MovementBoolean_NotMoveRemainder6.MovementId = Movement.Id
                                                              AND MovementBoolean_NotMoveRemainder6.DescId = zc_MovementBoolean_NotMoveRemainder6()
                                WHERE Movement.DescId = zc_Movement_Layout()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               )
        , tmpLayout AS (SELECT Movement.ID                        AS Id
                             , MovementItem.ObjectId              AS GoodsId
                             , MovementItem.Amount                AS Amount
                             , Movement.isPharmacyItem            AS isPharmacyItem
                             , Movement.isNotMoveRemainder6       AS isNotMoveRemainder6
                             , MovementItem.Id                    AS MovementItemId 
                        FROM tmpLayoutMovement AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    AND MovementItem.Amount > 0
                                                    AND MovementItem.ObjectId = inGoodsId
                       )
        , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                 , MovementItem.ObjectId              AS UnitId
                                 , MovementItem.Amount                AS Amount
                            FROM tmpLayoutMovement AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        AND MovementItem.Amount > 0
                           )
                               
        , tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                      , count(*)                          AS CountUnit
                                 FROM tmpLayoutUnit
                                 GROUP BY tmpLayoutUnit.ID
                                 )
        , tmpLayoutAll AS (SELECT tmpLayout.GoodsId                             AS GoodsId
                                , inUnitId                                      AS UnitId
                                , tmpLayout.Amount                              AS Amount
                                , tmpLayout.isNotMoveRemainder6                 AS isNotMoveRemainder6
                                , tmpLayout.ID                                  AS MovementId
                                , tmpLayout.MovementItemId                      AS MovementItemId
                           FROM tmpLayout 

                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = inUnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                                LEFT JOIN Object AS Object_Unit
                                                 ON Object_Unit.Id        = tmpLayoutUnit.UnitId
                                                AND Object_Unit.DescId    = zc_Object_Unit()

                           WHERE (tmpLayoutUnit.UnitId = inUnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (Object_Unit.ValueData NOT ILIKE 'Апт. пункт %' OR tmpLayout.isPharmacyItem = True)
                           )

    SELECT Movement.ID
         , Movement.InvNumber
         , Movement.OperDate
         , (Object_Status.ValueData||CASE WHEN COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                                               AND Movement.DescId not in (zc_Movement_Check()) THEN ' Отложен' ELSE '' END)::TVarChar
         , Movement.DescId
         , MovementDesc.ItemName
         , Object_Unit.ValueData
         , MovementItem.Amount
         , MovementItem.IsErased
    FROM MovementItem

         INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
  --                          AND Movement.DescId not in (zc_Movement_Reprice())
                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         INNER JOIN MovementDesc ON MovementDesc.id = Movement.DescId
         INNER JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId in (zc_MovementLinkObject_Unit(), zc_MovementLinkObject_From() , zc_MovementLinkObject_To())
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

    WHERE MovementItem.ObjectId IN
          (SELECT Object_Goods_Retail.ID FROM Object_Goods_Retail WHERE Object_Goods_Retail.GoodsMainId =
            (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = inGoodsId))
      AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
    UNION ALL
    SELECT Movement.ID
         , Movement.InvNumber
         , Movement.OperDate
         , Object_Status.ValueData
         , Movement.DescId
         , MovementDesc.ItemName
         , Object_Unit.ValueData
         , MovementItem.Amount
         , MovementItem.IsErased
    FROM tmpLayoutAll
    
         LEFT JOIN MovementItem ON MovementItem.ID = tmpLayoutAll.MovementItemId
    
         INNER JOIN Movement ON Movement.ID = tmpLayoutAll.MovementId
                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         INNER JOIN MovementDesc ON MovementDesc.id = Movement.DescId
         INNER JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpLayoutAll.UnitId

    ORDER BY 3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.20                                                       *
*/

-- тест
-- select * from gpReport_EntryGoodsMovement(inStartDate := ('01.01.2016')::TDateTime , inEndDate := ('30.04.2021')::TDateTime , inUnitId := 1529734 , inGoodsId := 1267302 ,  inSession := '3');

select * from gpReport_EntryGoodsMovement(inStartDate := ('01.11.2018')::TDateTime , inEndDate := ('31.08.2023')::TDateTime , inUnitId := 10779386 , inGoodsId := 1578553 ,  inSession := '3');