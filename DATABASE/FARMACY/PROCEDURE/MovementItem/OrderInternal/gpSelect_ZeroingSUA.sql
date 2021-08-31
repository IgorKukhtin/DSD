-- Function: gpSelect_ZeroingSUA()

DROP FUNCTION IF EXISTS gpSelect_ZeroingSUA (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ZeroingSUA(
    IN inMovementId    Integer ,   -- Заказ из которого вызвали
    IN inUnitId        Integer ,   -- Подрозделение когда без заказа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , NeedReorder Boolean
             , Amount TFloat, Price TFloat, Summa TFloat
             , Remains TFloat
             , MCS TFloat
             , MCS_isClose Boolean
             , Amount_Layout TFloat
             , Amount_OrderInternal TFloat
             , Amount_Income TFloat
             , Amount_Send TFloat
             , Amount_OrderExternal TFloat
             , Amount_Reserve TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
  IF COALESCE (inMovementId, 0) <> 0 
  THEN
    SELECT MovementLinkObject.ObjectId INTO inUnitId
    FROM MovementLinkObject
    WHERE MovementLinkObject.MovementId = inMovementId
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();  
  END IF;

  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , Movement.OperDate
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                            INNER JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId = Movement.Id
                                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()                                                   
                       WHERE MovementDate_Insert.ValueData BETWEEN CURRENT_DATE - ((date_part('isodow', CURRENT_DATE) - 1)||' day')::INTERVAL AND CURRENT_DATE
                         AND Movement.DescId = zc_Movement_Send()
                         AND MovementString_Comment.ValueData = 'Товар по СУА')
     , tmpMI AS (SELECT Movement.ID                                                                    AS ID
                      , Movement.InvNumber
                      , Movement.OperDate
                      , MovementLinkObject_To.ObjectId                                                 AS UnitId
                      , MILinkObject_CommentSend.ObjectId                                              AS CommentSendID
                      , MovementItem.ObjectId                                                          AS GoodsID
                      , MovementItem.Id                                                                AS MovementItemId
                      , MovementItem.Amount                                                            AS Amount
                      , COALESCE(MIFloat_PriceFrom.ValueData,0)                                        AS Price
                 FROM tmpMovement AS Movement
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                      LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                       ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                      LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                        ON MIFloat_PriceFrom.MovementItemId = MovementItem.ID
                                                       AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                 WHERE (COALESCE (MovementLinkObject_To.ObjectId , 0) = inUnitId OR inUnitId = 0)
                   AND COALESCE (MILinkObject_CommentSend.ObjectId , 0) <> 0
                 )
     , tmpProtocolAll AS (SELECT MovementItem.MovementItemId
                               , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                          FROM tmpMI AS MovementItem

                               INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                              AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                          )
     , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)
     , tmpZeroingSUA AS (SELECT tmpMI.UnitID
                              , tmpMI.GoodsID
                              , SUM(COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) - tmpMI.Amount)::TFloat           AS Amount
                              , ROUND(SUM(ROUND(tmpMI.Price * (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) -
                                                         tmpMI.Amount), 2))/ 
                                      SUM(COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) - tmpMI.Amount), 2)::TFloat AS Price
                              , SUM(ROUND(tmpMI.Price * (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) -
                                                         tmpMI.Amount), 2))::TFloat                                   AS Summa
                         FROM tmpMI
                              LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.MovementItemId
                         WHERE (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) - tmpMI.Amount) > 0
                         GROUP BY tmpMI.UnitID, tmpMI.GoodsID) 
                         
      , MovementItemSaved AS (SELECT T1.Id,
                                     T1.Amount,
                                     T1.ObjectId
                              FROM (SELECT MovementItem.Id,
                                           MovementItem.Amount,
                                           MovementItem.ObjectId,
                                           ROW_NUMBER() OVER(PARTITION BY MovementItem.ObjectId Order By MovementItem.Id) as Ord
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.isErased = FALSE
                                   ) AS T1
                              WHERE T1.Ord = 1
                             )
      , Income AS (SELECT MovementItem_Income.ObjectId     AS GoodsId
                        , MovementLinkObject_To.ObjectId   AS UnitId
                        , SUM (MovementItem_Income.Amount) AS Amount_Income
                   FROM Movement AS Movement_Income
                        INNER JOIN MovementItem AS MovementItem_Income
                                                ON Movement_Income.Id = MovementItem_Income.MovementId
                                               AND MovementItem_Income.DescId = zc_MI_Master()
                                               AND MovementItem_Income.isErased = FALSE
                        INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                      ON Movement_Income.Id = MovementLinkObject_To.MovementId
                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                     AND MovementLinkObject_To.ObjectId IN (SELECT DISTINCT tmpZeroingSUA.UnitId FROM tmpZeroingSUA)
                        INNER JOIN MovementDate AS MovementDate_Branch
                                                ON MovementDate_Branch.MovementId = Movement_Income.Id
                                               AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                               -- AND MovementDate_Branch.ValueData >= CURRENT_DATE
                                               AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '7 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
                WHERE Movement_Income.DescId = zc_Movement_Income()
                  AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                GROUP BY MovementItem_Income.ObjectId
                       , MovementLinkObject_To.ObjectId
                HAVING SUM (MovementItem_Income.Amount) > 0
             )
      , tmpMI_Send AS (SELECT MovementItem.ObjectId          AS GoodsId
                            , MovementLinkObject_To.ObjectId AS UnitId
                            , SUM (MovementItem.Amount)      AS Amount
                       FROM Movement
                              INNER JOIN MovementItem AS MovementItem
                                                      ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                           AND MovementLinkObject_To.ObjectId IN (SELECT DISTINCT tmpZeroingSUA.UnitId FROM tmpZeroingSUA)
                              -- закомментил - пусть будут все перемещения, не только Авто
                              /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                         ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                        AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                        AND MovementBoolean_isAuto.ValueData  = TRUE*/
                              /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                        ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                       AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                       WHERE Movement.DescId = zc_Movement_Send()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            --AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                            -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                            AND Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                       GROUP BY MovementItem.ObjectId
                              , MovementLinkObject_To.ObjectId
                      )
      , tmpMI_OrderExternal AS (SELECT MI_OrderExternal.ObjectId                AS GoodsId
                                     , MovementLinkObject_Unit.ObjectId         AS UnitId
                                     , SUM (MI_OrderExternal.Amount) ::TFloat   AS Amount
                                FROM Movement AS Movement_OrderExternal
                                     INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                ON MovementBoolean_Deferred.MovementId = Movement_OrderExternal.Id
                                                               AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                               AND MovementBoolean_Deferred.ValueData = TRUE
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT tmpZeroingSUA.UnitId FROM tmpZeroingSUA)
                                     INNER JOIN MovementItem AS MI_OrderExternal
                                                             ON MI_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                            AND MI_OrderExternal.DescId = zc_MI_Master()
                                                            AND MI_OrderExternal.isErased = FALSE
 
                                WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                                  AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                                GROUP BY MI_OrderExternal.ObjectId
                                       , MovementLinkObject_Unit.ObjectId
                                HAVING SUM (MI_OrderExternal.Amount) <> 0
                               )

      -- выбираем отложенные Чеки (как в кассе колонка VIP)
      , tmpMovementChek AS (SELECT Movement.Id
                                 , MovementLinkObject_Unit.ObjectId    AS UnitId
                           FROM MovementBoolean AS MovementBoolean_Deferred
                                INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                   AND Movement.DescId = zc_Movement_Check()
                                                   AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT tmpZeroingSUA.UnitId FROM tmpZeroingSUA)
                           WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                             AND MovementBoolean_Deferred.ValueData = TRUE
                          UNION
                           SELECT Movement.Id
                                , MovementLinkObject_Unit.ObjectId    AS UnitId
                           FROM MovementString AS MovementString_CommentError
                                INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                   AND Movement.DescId = zc_Movement_Check()
                                                   AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                             AND MovementLinkObject_Unit.ObjectId IN (SELECT DISTINCT tmpZeroingSUA.UnitId FROM tmpZeroingSUA)
                           WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                             AND MovementString_CommentError.ValueData <> ''
                           )
      , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                            , tmpMovementChek.UnitId            AS UnitId
                            , SUM (MovementItem.Amount)::TFloat AS Amount
                      FROM tmpMovementChek
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                                     ON MovementBoolean_NotMCS.MovementId = tmpMovementChek.Id
                                                    AND MovementBoolean_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                      WHERE COALESCE (MovementBoolean_NotMCS.ValueData, False) = False
                      GROUP BY MovementItem.ObjectId, tmpMovementChek.UnitId
                      )
      , tmpRemains AS (SELECT tmpZeroingSUA.UnitId
                            , tmpZeroingSUA.GoodsId
                            , SUM (COALESCE (Container.Amount, 0)) AS Amount
                       FROM tmpZeroingSUA
                            LEFT JOIN Container ON Container.WhereObjectId = tmpZeroingSUA.UnitId
                                               AND Container.ObjectId = tmpZeroingSUA.GoodsId
                                               AND Container.DescId = zc_Container_Count()
                                               AND Container.Amount <> 0
                       GROUP BY tmpZeroingSUA.UnitId
                              , tmpZeroingSUA.GoodsId
                       )
        -- Выкладка       
      , tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                    , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                               FROM Movement
                                    LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                              ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                             AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                               WHERE Movement.DescId = zc_Movement_Layout()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              )
      , tmpLayout AS (SELECT Movement.ID                        AS Id
                            , MovementItem.ObjectId              AS GoodsId
                            , MovementItem.Amount                AS Amount
                            , Movement.isPharmacyItem            AS isPharmacyItem
                       FROM tmpLayoutMovement AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                                                   AND MovementItem.Amount > 0
                                                   AND MovementItem.ObjectId IN (SELECT DISTINCT tmpZeroingSUA.GoodsId FROM tmpZeroingSUA)
                      )
      , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                               , MovementItem.ObjectId              AS UnitId
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
      , tmpLayoutAll AS (SELECT tmpLayout.GoodsId                  AS GoodsId
                              , tmpZeroingSUA.UnitId               AS UnitId
                              , MAX(tmpLayout.Amount)::TFloat      AS Amount
                         FROM tmpLayout
                         
                              INNER JOIN tmpZeroingSUA ON tmpZeroingSUA.GoodsId = tmpLayout.GoodsId
                                 
                              LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                      ON Unit_PharmacyItem.ObjectId  = tmpZeroingSUA.UnitId
                                                     AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                       
                              LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                     AND tmpLayoutUnit.UnitId = tmpZeroingSUA.UnitId

                              LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                       
                         WHERE (tmpLayoutUnit.UnitId = tmpZeroingSUA.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                           AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                         GROUP BY tmpLayout.GoodsId
                                , tmpZeroingSUA.UnitId
                         )
                  -- НТЗ
      , tmpPrice AS (SELECT ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                          , Price_Goods.ChildObjectId               AS GoodsId
                          , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                          , MCS_Value.ValueData                     AS MCSValue
                          , COALESCE(MCS_isClose.ValueData, False)  AS MCS_isClose
                      FROM tmpZeroingSUA
                      
                           INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                 ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                AND ObjectLink_Price_Unit.ChildObjectId = tmpZeroingSUA.UnitId 
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                AND Price_Goods.ChildObjectId = tmpZeroingSUA.GoodsId
                                            
                           LEFT JOIN ObjectBoolean AS MCS_isClose
                                                   ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()

                     )


  SELECT tmpZeroingSUA.UnitId
       , Object_Unit.ObjectCode                                                           AS GoodsCode
       , Object_Unit.ValueData                                                            AS GoodsName
       , tmpZeroingSUA.GoodsID
       , Object_Goods.ObjectCode                                                          AS GoodsCode
       , Object_Goods.ValueData                                                           AS GoodsName
       , COALESCE(Container.Amount, 0) +
         COALESCE(MovementItemSaved.Amount, 0) +
         COALESCE(Income.Amount_Income, 0) +
         COALESCE(tmpMI_Send.Amount, 0) +
         COALESCE(tmpMI_OrderExternal.Amount, 0) -
         COALESCE(tmpReserve.Amount, 0) < tmpZeroingSUA.Amount                            AS NeedReorder
       , tmpZeroingSUA.Amount
       , tmpZeroingSUA.Price
       , tmpZeroingSUA.Summa
       , Container.Amount::TFloat                                                         AS Remains
       , tmpPrice.MCSValue                                                                AS MCS
       , tmpPrice.MCS_isClose                                                             AS MCS_isClose
       , tmpLayoutAll.Amount::TFloat                                                      AS Amount_Layout
       , MovementItemSaved.Amount::TFloat                                                 AS Amount_OrderInternal 
       , Income.Amount_Income::TFloat                                                     AS Amount_Income
       , tmpMI_Send.Amount::TFloat                                                        AS Amount_Send
       , tmpMI_OrderExternal.Amount::TFloat                                               AS Amount_OrderExternal
       , tmpReserve.Amount::TFloat                                                        AS Amount_Reserve
  FROM tmpZeroingSUA

       INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = tmpZeroingSUA.GoodsId
                                   AND Object_Goods_View.IsClose = FALSE

       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpZeroingSUA.UnitID
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpZeroingSUA.GoodsID

       LEFT JOIN tmpRemains AS Container
                            ON Container.UnitId  = tmpZeroingSUA.UnitId
                           AND Container.GoodsId = tmpZeroingSUA.GoodsID

       LEFT OUTER JOIN MovementItemSaved ON MovementItemSaved.ObjectId = tmpZeroingSUA.GoodsId

       LEFT OUTER JOIN Income ON Income.GoodsId = tmpZeroingSUA.GoodsId
                             AND Income.UnitId  = tmpZeroingSUA.UnitId

       LEFT OUTER JOIN tmpMI_Send ON tmpMI_Send.GoodsId = tmpZeroingSUA.GoodsId
                                 AND tmpMI_Send.UnitId  = tmpZeroingSUA.UnitId

       LEFT OUTER JOIN tmpMI_OrderExternal ON tmpMI_OrderExternal.GoodsId = tmpZeroingSUA.GoodsId
                                          AND tmpMI_OrderExternal.UnitId  = tmpZeroingSUA.UnitId

       LEFT OUTER JOIN tmpLayoutAll ON tmpLayoutAll.GoodsId = tmpZeroingSUA.GoodsId
                                   AND tmpLayoutAll.UnitId  = tmpZeroingSUA.UnitId

       -- кол-во отложенные чеки
       LEFT JOIN tmpReserve ON tmpReserve.GoodsId = tmpZeroingSUA.GoodsId
                           AND tmpReserve.UnitId  = tmpZeroingSUA.UnitId
                           
       LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpZeroingSUA.GoodsId
                         AND tmpPrice.UnitId  = tmpZeroingSUA.UnitId

  ORDER BY tmpZeroingSUA.GoodsID;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ZeroingSUA (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.09.20                                                       *
*/

-- тест
--

select * from gpSelect_ZeroingSUA(inMovementId := 0, inUnitId := 0 /*183289*/ ,  inSession := '3');