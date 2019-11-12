-- Function: gpReport_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpReport_OrderInternalPromo (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderInternalPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalPromo(
    IN inMovementId    Integer   ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, CodeStr_partner TVarChar, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Price TFloat
             , Amount TFloat, Summ TFloat
             , Amount_Sale TFloat, Amount_Remains TFloat
             , Amount_Master TFloat
             , inReportText TVarChar
             , isManual TVarChar
             , JuridicalName TVarChar
             , ContractName TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
    DECLARE vbAreaId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderInternalPromo());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверяем регион пользователя
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession::TVarChar));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession::TVarChar));
    END IF;
    
        -- Результат
        RETURN QUERY

        WITH 
        tmpMI_Master AS (SELECT MovementItem.Id                   AS Id
                              , MovementItem.ObjectId             AS GoodsId
                              , Object_Goods.ObjectCode           AS GoodsCode
                              , Object_Goods.ValueData            AS GoodsName
                              , MovementItem.Amount      ::TFloat AS Amount
                              , MIFloat_Price.ValueData  ::TFloat AS Price
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
                             , COALESCE (MIFloat_AmountManual.ValueData,MovementItem.Amount,0) AS Amount
                             , COALESCE (MIFloat_AmountManual.ValueData,0)           :: TFloat AS AmountManual
                             , MIFloat_AmountOut.ValueData      AS AmountOut
                             , MIFloat_Remains.ValueData        AS Remains
                             , Count (*) OVER (PARTITION BY MovementItem.ParentId) AS Count_calc
                             , ObjectLink_Unit_Area.ChildObjectId AS AreaId
                        FROM MovementItem
                             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountOut
                                                         ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                             LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                                         ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                                         ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                  ON ObjectLink_Unit_Area.ObjectId = MovementItem.ObjectId 
                                                 AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()

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

      -- нужно найти код товара поставщика - берем из прайсов
      , tmpGoodsParam AS (SELECT tmpMI_Master.*
                                , COALESCE (LoadPriceListItem.GoodsCode , PriceList_GoodsLink.GoodsCode) AS GoodsCode_str  -- код поставщика
                                --, PriceList_GoodsLink.GoodsId AS GoodsId_jur  -- товар поставщика
                                --, Object_LinkGoods_View.GoodsMainId           -- главный товар
                           FROM tmpMI_Master 
                                JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = tmpMI_Master.GoodsId 
                                LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                                                ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                               AND PriceList_GoodsLink.ObjectId = tmpMI_Master.JuridicalId
                                INNER JOIN LoadPriceList ON LoadPriceList.JuridicalId = tmpMI_Master.JuridicalId
                                                        AND LoadPriceList.ContractId  = COALESCE (tmpMI_Master.ContractId, 0)
                                                        AND (   (COALESCE (LoadPriceList.AreaId, 0) = vbAreaId AND COALESCE (vbAreaId,0)<>0)
                                                             OR (COALESCE (vbAreaId,0)=0 AND COALESCE (LoadPriceList.AreaId, 0) = zc_Area_basis())
                                                             OR COALESCE (LoadPriceList.AreaId, 0) =0
                                                             )
                                inner JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                                                            AND LoadPriceListItem.GoodsId = Object_LinkGoods_View.GoodsMainId
                          )

     SELECT tmpMI_Master.GoodsId
          , tmpMI_Master.GoodsCode
          --, COALESCE (tmpGoodsParam.CodeStr, tmpGoodsParam_basis.CodeStr, tmpGoodsParam_0.CodeStr):: TVarChar  AS CodeStr_partner-- CASE WHEN COALESCE (tmpGoodsParam.CodeStr,'') <> '' THEN tmpGoodsParam.CodeStr ELSE COALESCE (tmpGoodsParam_basis.CodeStr,'') END :: TVarChar  AS CodeStr_partner --
          , tmpGoodsParam.GoodsCode_str :: TVarChar
          , tmpMI_Master.GoodsName
          , Object_GoodsGroup.Id             AS GoodsGroupId
          , Object_GoodsGroup.ValueData      AS GoodsGroupName
          , Object_NDSKind.Id                AS NDSKindId
          , Object_NDSKind.ValueData         AS NDSKindName
          , tmpMI_Child.UnitId
          , tmpMI_Child.UnitCode
          , (tmpMI_Child.UnitName ||' ('|| Object_Juridical.ValueData||', '|| ObjectHistory_JuridicalDetails_View.OKPO ||')' ):: TVarChar AS UnitName
          , tmpMI_Master.Price
          , tmpMI_Child.Amount                        :: TFloat AS Amount
          , (tmpMI_Child.Amount * tmpMI_Master.Price) :: TFloat AS Summ

          , tmpMI_Child.AmountOut            AS Amount_Sale
          , tmpMI_Child.Remains              AS Amount_Remains
          , (tmpMI_Master.Amount  / CASE WHEN COALESCE (tmpMI_Child.Count_calc, 0) <> 0 THEN tmpMI_Child.Count_calc ELSE 1 END ):: TFloat AS Amount_Master
          , CASE WHEN tmpPartner.JuridicalId IS NOT NULL THEN 'ДА' ELSE 'НЕТ' END :: TVarChar AS inReportText
          , CASE WHEN COALESCE (tmpMI_Child.AmountManual,0) <> 0 THEN 'ДА' ELSE 'НЕТ' END :: TVarChar AS isManual
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

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = tmpMI_Child.UnitId
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id
          
          LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpMI_Master.GoodsId
                                 AND tmpGoodsParam.JuridicalId = tmpMI_Master.JuridicalId
                                 AND tmpGoodsParam.ContractId = tmpMI_Master.ContractId
                                 
         /* LEFT JOIN tmpGoodsParam AS tmpGoodsParam_0
                                  ON tmpGoodsParam_0.GoodsMainId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                 AND tmpGoodsParam_0.JuridicalId = tmpMI_Master.JuridicalId
                                 AND COALESCE (tmpGoodsParam_0.AreaId,0) = 0
          LEFT JOIN tmpGoodsParam AS tmpGoodsParam_basis
                                  ON tmpGoodsParam_basis.GoodsMainId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                 AND tmpGoodsParam_basis.JuridicalId = tmpMI_Master.JuridicalId
                                 AND COALESCE (tmpGoodsParam_basis.AreaId,0) = zc_Area_Basis()      */                                          
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
--select * from gpReport_OrderInternalPromo(inMovementId := 16413930 ,  inSession := '3')