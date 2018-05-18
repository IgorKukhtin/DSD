-- Function: gpSelect_MovementItem_CheckDeferred()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckDeferred (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckDeferred(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount_remains TFloat
             , Amount TFloat
             , Price TFloat
             , Summ TFloat 
             , NDS TFloat
             , PriceSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             , List_UID TVarChar
             , isErased Boolean
             , Color_Calc Integer
             , Color_CalcError Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;   
    vbUnitId := CASE WHEN vbUserId = 3 THEN 0 ELSE vbUnitKey::Integer END;

    RETURN QUERY
        WITH 
           tmpMov AS (SELECT Movement.Id
                           , Movement.StatusId
                           , MovementLinkObject_Unit.ObjectId           AS UnitId
                           , MovementLinkObject_ConfirmedKind.ObjectId  AS ConfirmedKindId
                           , MovementString_CommentError.ValueData      AS CommentError
                      FROM MovementBoolean AS MovementBoolean_Deferred
                        INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                           AND Movement.DescId = zc_Movement_Check()
                                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                           -- AND Movement.OperDate > CURRENT_DATE - INTERVAL '31 DAY'
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                                                     -- AND MovementLinkObject_Unit.ObjectId = vbUnitId
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                     ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                        LEFT JOIN MovementString AS MovementString_CommentError
                                                 ON MovementString_CommentError.MovementId = Movement.Id
                                                AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                      WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                        AND MovementBoolean_Deferred.ValueData = TRUE
                     UNION
                      SELECT Movement.Id
                           , Movement.StatusId
                           , MovementLinkObject_Unit.ObjectId           AS UnitId
                           , MovementLinkObject_ConfirmedKind.ObjectId  AS ConfirmedKindId
                           , MovementString_CommentError.ValueData      AS CommentError
                      FROM MovementString AS MovementString_CommentError
                        INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                           AND Movement.DescId = zc_Movement_Check()
                                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                           -- AND Movement.OperDate > CURRENT_DATE - INTERVAL '31 DAY'
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                                                     -- AND MovementLinkObject_Unit.ObjectId = vbUnitId
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                     ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                      WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                        AND MovementString_CommentError.ValueData <> ''
                     )
      , tmpMI_all AS (SELECT MovementItem.*, tmpMov.StatusId, tmpMov.UnitId, tmpMov.ConfirmedKindId, tmpMov.CommentError
                      FROM tmpMov
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                     )
          , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.ObjectId AS GoodsId, SUM (tmpMI_all.Amount) AS Amount
                      FROM tmpMI_all
                      WHERE StatusId = zc_Enum_Status_UnComplete() AND (CommentError <> '' OR ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete())
                      GROUP BY tmpMI_all.UnitId, tmpMI_all.ObjectId
                     )
          , tmpRemains AS (SELECT tmpMI.GoodsId
                                , tmpMI.UnitId
                                , tmpMI.Amount           AS Amount_mi
                                , COALESCE (SUM (Container.Amount), 0) AS Amount_remains
                           FROM tmpMI
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.WhereObjectId = tmpMI.UnitId
                                                   AND Container.Amount <> 0
                           GROUP BY tmpMI.GoodsId
                                  , tmpMI.UnitId
                                  , tmpMI.Amount
                           HAVING COALESCE (SUM (Container.Amount), 0) < tmpMI.Amount
                          )
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
       -- Результат
       SELECT
             MovementItem.Id          AS Id,
             MovementItem.MovementId  AS MovementId 
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , tmpRemains.Amount_remains :: TFloat AS Amount_remains
           , MovementItem.Amount      AS Amount
           , MIFloat_Price.ValueData  AS Price
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , ObjectFloat_NDSKind_NDS.ValueData AS NDS
           , MIFloat_PriceSale.ValueData         AS PriceSale
           , MIFloat_ChangePercent.ValueData     AS ChangePercent
           , MIFloat_SummChangePercent.ValueData AS SummChangePercent
           , MIFloat_AmountOrder.ValueData       AS AmountOrder
           , MIString_UID.ValueData              AS List_UID
           , MovementItem.isErased

           , CASE WHEN MovementItem.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete() AND tmpRemains.GoodsId > 0 THEN 16440317 -- бледно крассный / розовый
                  -- WHEN tmpMov.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete() AND tmpRemains.GoodsId IS NULL THEN zc_Color_Yelow() -- желтый
                  ELSE zc_Color_White()
             END  AS Color_Calc

           , CASE WHEN tmpRemains.GoodsId > 0 THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END  AS Color_CalcError

       FROM tmpMI_all AS MovementItem
                                 
          LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                                      ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
          LEFT JOIN tmpMIFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
          LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
          LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
          LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                      ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                               ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
          
          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
          LEFT JOIN tmpMIString AS MIString_UID
                                       ON MIString_UID.MovementItemId = MovementItem.Id
                                      AND MIString_UID.DescId = zc_MIString_UID()

          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
                              AND tmpRemains.UnitId  = MovementItem.UnitId
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckDeferred (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А
 30.10.16         * add Color_Calc
 10.08.16                                                                     * MIString_UID.ValueData AS List_UID + оптимизация
 08.04.16         *
 03.07.15                                                                       * 
 25.05.15                         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred ('3')
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred ('3')
