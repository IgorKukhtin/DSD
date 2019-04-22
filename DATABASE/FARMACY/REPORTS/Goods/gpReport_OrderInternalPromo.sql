-- Function: gpReport_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpReport_OrderInternalPromo (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderInternalPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalPromo(
    IN inMovementId    Integer   ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Price TFloat
             , Amount_In TFloat, Amount_Out TFloat
             , Summ_In TFloat, Summ_Out TFloat
             , Amount TFloat, Summ TFloat
             , Amount_Sale TFloat, Amount_Remains TFloat
             , JuridicalName TVarChar
             , ContractName TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternalPromo());
    vbUserId:= lpGetUserBySession (inSession);

        -- Результат
        RETURN QUERY

        WITH 
        tmpMI_Master AS (SELECT MovementItem.Id                   AS Id
                              , MovementItem.ObjectId             AS GoodsId
                              , Object_Goods.ObjectCode           AS GoodsCode
                              , Object_Goods.ValueData            AS GoodsName
                              , MovementItem.Amount      ::TFloat AS Amount
                              , MIFloat_Price.ValueData  ::TFloat AS Price
                              , (COALESCE(MovementItem.Amount,0) * COALESCE(MIFloat_Price.ValueData,0)) ::TFloat AS Summ
                              , Object_Juridical.Id               AS JuridicalId
                              , Object_Juridical.ValueData        AS JuridicalName
                              , Object_Contract.Id                AS ContractId
                              , Object_Contract.ValueData         AS ContractName
                         FROM MovementItem
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId    
              
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
              
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                             ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId
              
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE 
                           AND MovementItem.Amount <> 0
                        )

      , tmpMI_Child AS (SELECT MovementItem.ParentId
                             , Object_Unit.Id                   AS UnitId
                             , Object_Unit.ObjectCode           AS UnitCode
                             , Object_Unit.ValueData            AS UnitName
                             , MovementItem.Amount              AS Amount
                             , MIFloat_AmountOut.ValueData      AS AmountOut
                             , MIFloat_Remains.ValueData        AS Remains
                        FROM MovementItem
                             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                                         ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Child()
                          AND MovementItem.isErased = FALSE 
                        )
 
      , tmpPartner AS (SELECT Movement.ParentId                        AS ParentId
                            , MovementLinkObject_Juridical.ObjectId    AS JuridicalId
                       FROM Movement 
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                       WHERE Movement.DescId = zc_Movement_OrderInternalPromoPartner()
                         AND Movement.ParentId = inMovementId
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                     )

      

     SELECT tmpMI_Master.GoodsId
          , tmpMI_Master.GoodsCode
          , tmpMI_Master.GoodsName
          , Object_GoodsGroup.Id             AS GoodsGroupId
          , Object_GoodsGroup.ValueData      AS GoodsGroupName
          , Object_NDSKind.Id                AS NDSKindId
          , Object_NDSKind.ValueData         AS NDSKindName
          , tmpMI_Child.UnitId
          , tmpMI_Child.UnitCode
          , tmpMI_Child.UnitName
          , tmpMI_Master.Price
          , CASE WHEN tmpPartner.JuridicalId IS NOT NULL THEN tmpMI_Child.Amount ELSE 0 END :: TFloat AS Amount_In
          , CASE WHEN tmpPartner.JuridicalId IS NOT NULL THEN 0 ELSE tmpMI_Child.Amount END :: TFloat AS Amount_Out
          , CASE WHEN tmpPartner.JuridicalId IS NOT NULL THEN tmpMI_Child.Amount * tmpMI_Master.Price ELSE 0 END   :: TFloat AS Summ_In
          , CASE WHEN tmpPartner.JuridicalId IS NOT NULL THEN 0 ELSE tmpMI_Child.Amount * tmpMI_Master.Price END   :: TFloat AS Summ_Out
          , tmpMI_Child.Amount    :: TFloat  AS Amount
          , (tmpMI_Child.Amount * tmpMI_Master.Price)  :: TFloat  AS Summ
          , tmpMI_Child.AmountOut            AS Amount_Sale
          , tmpMI_Child.Remains              AS Amount_Remains
          , tmpMI_Master.JuridicalName
          , tmpMI_Master.ContractName
     FROM tmpMI_Master 
          LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id

          LEFT JOIN tmpPartner ON tmpPartner.JuridicalId = tmpMI_Master.JuridicalId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI_Master.GoodsId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                               ON ObjectLink_Goods_NDSKind.ObjectId = tmpMI_Master.GoodsId
                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
          LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.04.19         *
*/

--select * from gpReport_OrderInternalPromo(inMovementId := 13840564, inSession := '3'::TVarChar);
