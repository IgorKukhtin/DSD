-- Function: gpSelect_MovementItem_CheckVIP()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckVIP (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckVIP(
    IN inIsErased    Boolean ,
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
             , PartionDateKindId Integer
             , PartionDateKindName TVarChar
             , PartionDateDiscount TFloat
             , AmountMonth TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
        WITH
           tmpMovAll AS (SELECT Movement.Id
                              , Movement.StatusId
                         FROM Movement
                              INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                         ON Movement.Id = MovementBoolean_Deferred.MovementId
                                                        AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                                        AND MovementBoolean_Deferred.ValueData = TRUE
                         WHERE Movement.DescId = zc_Movement_Check() 
                           AND (zc_Enum_Status_UnComplete() = Movement.StatusId 
                                OR zc_Enum_Status_Erased() = Movement.StatusId and inIsErased = TRUE)
                    )
         , tmpMov AS (SELECT Movement.Id
                           , Movement.StatusId                AS StatusId
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                           , MovementLinkObject_ConfirmedKind.ObjectId  AS ConfirmedKindId
                           , MovementString_CommentError.ValueData      AS CommentError
                        FROM tmpMovAll AS Movement
  
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                       AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                       ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                      AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                          LEFT JOIN MovementString AS MovementString_CommentError
                                                   ON MovementString_CommentError.MovementId = Movement.Id
                                                  AND MovementString_CommentError.DescId = zc_MovementString_CommentError()

                     )
         , tmpMI_all AS (SELECT MovementItem.*, tmpMov.StatusId, tmpMov.UnitId, tmpMov.ConfirmedKindId, tmpMov.CommentError
                         FROM tmpMov
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND (MovementItem.isErased   = FALSE OR inIsErased = TRUE)
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
          , tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                          )
          , tmpGoods_NDS AS (SELECT ObjectLink_Goods_NDSKind.ObjectId
                                  , ObjectFloat_NDSKind_NDS.ValueData   AS NDS
                             FROM ObjectLink AS ObjectLink_Goods_NDSKind
                                  LEFT JOIN tmpOF_NDSKind_NDS AS ObjectFloat_NDSKind_NDS
                                                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                             WHERE ObjectLink_Goods_NDSKind.ObjectId in (SELECT DISTINCT tmpMI_all.ObjectId FROM tmpMI_all)
                               AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                          ) 
          , tmpMovSendPartion AS (SELECT
                                          Movement.Id                               AS Id
                                        , MovementFloat_ChangePercent.ValueData     AS ChangePercent
                                        , MovementFloat_ChangePercentMin.ValueData  AS ChangePercentMin
                                   FROM Movement

                                        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                        LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                                                ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                                               AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                   WHERE Movement.DescId = zc_Movement_SendPartionDate()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                     AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                   ORDER BY Movement.OperDate
                                   LIMIT 1
                                  )
           , tmpMovItemSendPartion AS (SELECT
                                              MovementItem.ObjectId    AS GoodsId
                                            , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                            , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin

                                       FROM MovementItem

                                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                                        ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_ChangePercentMin.DescId = zc_MIFloat_ChangePercentMin()

                                       WHERE MovementItem.MovementId = (select tmpMovSendPartion.Id from tmpMovSendPartion)
                                         AND MovementItem.DescId = zc_MI_Master()
                                         AND (MIFloat_ChangePercent.ValueData is not Null OR MIFloat_ChangePercentMin.ValueData is not Null)
                                       )
           , tmpPDChangePercent AS (SELECT Object_PartionDateKind.Id           AS Id,
                                           CASE Object_PartionDateKind.Id
                                                WHEN zc_Enum_PartionDateKind_0() THEN tmpMovSendPartion.ChangePercentMin
                                                WHEN zc_Enum_PartionDateKind_1() THEN tmpMovSendPartion.ChangePercentMin
                                                WHEN zc_Enum_PartionDateKind_6() THEN tmpMovSendPartion.ChangePercent END AS PartionDateDiscount
                                    FROM Object AS Object_PartionDateKind
                                         LEFT JOIN tmpMovSendPartion ON 1 = 1
                                    WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind()
                                    )

           , tmpPDChangePercentGoods AS (SELECT Object_PartionDateKind.Id           AS Id
                                              , tmpMovItemSendPartion.GoodsId
                                              , CASE Object_PartionDateKind.Id
                                                     WHEN zc_Enum_PartionDateKind_0() THEN tmpMovItemSendPartion.ChangePercentMin
                                                     WHEN zc_Enum_PartionDateKind_1() THEN tmpMovItemSendPartion.ChangePercentMin
                                                     WHEN zc_Enum_PartionDateKind_6() THEN tmpMovItemSendPartion.ChangePercent END AS PartionDateDiscount
                                         FROM Object AS Object_PartionDateKind
                                              LEFT JOIN tmpMovItemSendPartion ON 1 = 1
                                         WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind()
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
           , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                             , COALESCE (MB_RoundingDown.ValueData, False)
                             , COALESCE (MB_RoundingTo10.ValueData, False)
                             , COALESCE (MB_RoundingTo50.ValueData, False)) AS AmountSumm
           , Goods_NDS.NDS                       AS NDS
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
           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , COALESCE(tmpPDChangePercentGoods.PartionDateDiscount,
                      tmpPDChangePercent.PartionDateDiscount)::TFloat            AS PartionDateDiscount
           , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFLoat AS AmountMonth

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

          LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                    ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                   AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
          LEFT JOIN MovementBoolean AS MB_RoundingDown
                                    ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                   AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
          LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                    ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                   AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

          LEFT JOIN tmpGoods_NDS AS Goods_NDS
                                 ON Goods_NDS.ObjectId = Object_Goods.Id

          LEFT JOIN tmpMIString AS MIString_UID
                                       ON MIString_UID.MovementItemId = MovementItem.Id
                                      AND MIString_UID.DescId = zc_MIString_UID()

          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
                              AND tmpRemains.UnitId  = MovementItem.UnitId
          --Типы срок/не срок
          LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                           ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                          AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
          LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
          LEFT JOIN tmpPDChangePercent ON tmpPDChangePercent.Id = NULLIF (MI_PartionDateKind.ObjectId, 0)
          LEFT JOIN tmpPDChangePercentGoods ON tmpPDChangePercentGoods.Id = NULLIF (MI_PartionDateKind.ObjectId, 0)
                                           AND tmpPDChangePercentGoods.GoodsId = MovementItem.ObjectId
          LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                               AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckVIP (Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 26.05.19                                                                                   *

*/

-- тест
-- 
SELECT * FROM gpSelect_MovementItem_CheckVIP (False, '3')
