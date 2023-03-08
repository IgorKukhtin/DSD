-- Function: gpSelect_MovementItem_Income_CreatePretension()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_CreatePretension (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_CreatePretension (
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer /*IdBarCode TVarChar,*/
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsCode TVarChar, PartnerGoodsName TVarChar
             , RetailName TVarChar
             , AreaName TVarChar
             , AmountIncome TFloat
             , Price TFloat
             , PriceWithVAT TFloat
             , MarginPercent TFloat
             , Summ TFloat
             , SalePrice TFloat
             , SaleSumm TFloat
             , SamplePrice TFloat
             , SampleSumm TFloat
             , JuridicalPrice TFloat
             , JuridicalPriceWithVAT TFloat
             , isErased Boolean
             , ExpirationDate TDateTime
             , ExpirationDatePG TDateTime
             , PartionGoods TVarChar
             , MakerName TVarChar
             , FEA TVarChar
             , Measure TVarChar
             , GoodsGroupName TVarChar
             , ConditionsKeepName TVarChar
             , DublePriceColour Integer
             , SertificatNumber TVarChar
             , SertificatStart TDateTime
             , SertificatEnd TDateTime
             , WarningColor Integer
             , AVGIncomePrice TFloat
             , AVGIncomePriceWarning Boolean
             , AmountManual TFloat
             , AmountDiff TFloat
             , Amount TFloat
             , ReasonDifferencesId Integer
             , ReasonDifferencesName TVarChar
             , OrderAmount TFloat
             , OrderPrice TFloat
             , OrderSumm TFloat
             , PersentDiff Tfloat
             , isAmountDiff Boolean
             , isSummDiff Boolean
             , isTop  Boolean
             , isSP Boolean
             , PercentMarkupSP TFloat
             , PriceOptSP TFloat
             , PercentMarkup TFloat
             , Fix_Price TFloat
             , Color_calc Integer

             , Goods_isTop Boolean
             , Goods_PercentMarkup  TFloat
             , Goods_Price TFloat
             , Color_ExpirationDate  Integer
             , Color_ExpirationDatePh  Integer

             , PrintCount TFloat
             , isPrint  Boolean

             , InsertName TVarChar, InsertDate TDateTime
             , Color_AmountManual Integer
             , AccommodationId Integer, AccommodationName TVarChar
             
             , PromoBonus  TFloat
             , MarginPercentUnit  TFloat
             , isLearnWeek Boolean

             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbAVGDateStart TDateTime;
  DECLARE vbAVGDateEnd TDateTime;
  DECLARE vbVAT TFloat;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbOrderId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUpperLimitPromoBonus TFloat;
  DECLARE vbLowerLimitPromoBonus TFloat;
  DECLARE vbMinPercentPromoBonus TFloat;
  DECLARE vbMarginCategoryId Integer;
  DECLARE vbMovPromoBonus Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    SELECT MovementBoolean_PriceWithVAT.ValueData  AS PriceWithVAT
         , ObjectFloat_NDSKind_NDS.ValueData       AS NDS
         , Movement_Income.OperDate
         , Movement_Income.OperDate - INTERVAL '30 day'
         , MovementLinkObject_To.ObjectId          AS ToId
         , MLM_Order.MovementChildId               AS OrderId
    INTO
        vbPriceWithVAT
      , vbVAT
      , vbAVGDateEnd
      , vbAVGDateStart
      , vbUnitId
      , vbOrderId
    FROM Movement AS Movement_Income
        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                     ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

        LEFT JOIN MovementLinkMovement AS MLM_Order
                                       ON MLM_Order.MovementId = Movement_Income.Id
                                      AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
        LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MLM_Order.MovementChildId

    WHERE Movement_Income.Id = inMovementId
      AND Movement_Income.DescId = zc_Movement_Income();

     -- определяем Категорию расчета
     SELECT Object_MarginCategoryLink.MarginCategoryId  INTO vbMarginCategoryId
       FROM Object_MarginCategoryLink_View AS Object_MarginCategoryLink
            INNER JOIN Movement ON Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income()
            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                         AND MovementLinkObject_From.ObjectId = Object_MarginCategoryLink.JuridicalId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
       WHERE MovementLinkObject_To.ObjectId = Object_MarginCategoryLink.UnitId OR COALESCE (Object_MarginCategoryLink.UnitId, 0) = 0
         AND Object_MarginCategoryLink.isErased = False;

    vbMovPromoBonus := (WITH  tmpMovPromoBonus AS 
                              (SELECT Movement.id AS ID FROM Movement
                               WHERE Movement.OperDate <= CURRENT_DATE
                                 AND Movement.DescId = zc_Movement_PromoBonus()
                                 AND Movement.StatusId = zc_Enum_Status_Complete())
    							 
                        SELECT MAX(tmpMovPromoBonus.ID) AS ID FROM tmpMovPromoBonus);

     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                      UNION ALL
                     SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                    )
 ,  tmpMI AS (SELECT MovementItem.Id
                   , MovementItem.ObjectId              AS GoodsId
                   , MIString_GoodsName.ValueData       AS GoodsName
                   , MILinkObject_Goods.ObjectId        AS PartnerGoodsId
                   , MovementItem.Amount                AS Amount
                   , MIFloat_Price.ValueData            AS Price
                   , CASE WHEN vbPriceWithVAT THEN  MIFloat_Price.ValueData
                                              ELSE (MIFloat_Price.ValueData * (1 + vbVAT/100))::TFloat
                     END AS PriceWithVAT

                   , COALESCE(MIFloat_PriceSale.ValueData,0)::TFloat        AS PriceSale
                   , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
                   , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))::TFloat AS SummSale

                   , COALESCE(MIFloat_PriceSample.ValueData,0)                    ::TFloat     AS PriceSample
                   , (((COALESCE (MovementItem.Amount, 0)) * COALESCE(MIFloat_PriceSample.ValueData,0))::NUMERIC (16, 2))::TFloat AS SummSample

                   , COALESCE(MIFloat_JuridicalPrice.ValueData,0)               ::TFloat     AS JuridicalPrice
                   , COALESCE(MIFloat_JuridicalPriceWithVAT.ValueData,0)        ::TFloat     AS JuridicalPriceWithVAT

                   , MovementItem.isErased
                   , COALESCE(MIFloat_AmountManual.ValueData, 0)  ::TFloat AS AmountManual

                   , COALESCE (MIDate_ExpirationDate.ValueData, NULL) :: TDateTime AS ExpirationDate
                   , COALESCE(MIString_PartionGoods.ValueData, '')    :: TVarChar  AS PartionGoods
                   , MIString_FEA.ValueData              AS FEA
                   , MIString_Measure.ValueData          AS Measure
                   , MIString_SertificatNumber.ValueData AS SertificatNumber
                   , MIDate_SertificatStart.ValueData    AS SertificatStart
                   , MIDate_SertificatEnd.ValueData      AS SertificatEnd
                   , COALESCE (MIFloat_PrintCount.ValueData, 0)   ::TFloat      AS PrintCount
                   , COALESCE (MIBoolean_Print.ValueData, TRUE)   ::Boolean     AS isPrint
                   , MILinkObject_ReasonDifferences.ObjectId                    AS ReasonDifferencesId

                   , Object_Insert.ValueData        AS InsertName
                   , MIDate_Insert.ValueData        AS InsertDate

              FROM tmpIsErased
                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                        AND MovementItem.isErased   = tmpIsErased.isErased
                                        AND MovementItem.DescId     = zc_MI_Master()

                 LEFT JOIN MovementItemDate AS MIDate_Insert
                                            ON MIDate_Insert.MovementItemId = MovementItem.Id
                                           AND MIDate_Insert.DescId = zc_MIDate_Insert()
                 LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                  ON MILO_Insert.MovementItemId = MovementItem.Id
                                                 AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                             ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                            AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                 LEFT JOIN MovementItemFloat AS MIFloat_PriceSample
                                             ON MIFloat_PriceSample.MovementItemId = MovementItem.Id
                                            AND MIFloat_PriceSample.DescId = zc_MIFloat_PriceSample()

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                  ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

                 LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                             ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

                 LEFT JOIN MovementItemDate  AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                 LEFT JOIN MovementItemString AS MIString_PartionGoods
                                              ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                 LEFT JOIN MovementItemString AS MIString_Measure
                                              ON MIString_Measure.MovementItemId = MovementItem.Id
                                             AND MIString_Measure.DescId = zc_MIString_Measure()
                 LEFT JOIN MovementItemString AS MIString_FEA
                                              ON MIString_FEA.MovementItemId = MovementItem.Id
                                             AND MIString_FEA.DescId = zc_MIString_FEA()
                 LEFT JOIN MovementItemString AS MIString_GoodsName
                                              ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                             AND MIString_GoodsName.DescId = zc_MIString_GoodsName()

                 LEFT JOIN MovementItemString AS MIString_SertificatNumber
                                              ON MIString_SertificatNumber.MovementItemId = MovementItem.Id
                                             AND MIString_SertificatNumber.DescId = zc_MIString_SertificatNumber()
                 LEFT JOIN MovementItemDate  AS MIDate_SertificatStart
                                             ON MIDate_SertificatStart.MovementItemId = MovementItem.Id
                                            AND MIDate_SertificatStart.DescId = zc_MIDate_SertificatStart()
                 LEFT JOIN MovementItemDate  AS MIDate_SertificatEnd
                                             ON MIDate_SertificatEnd.MovementItemId = MovementItem.Id
                                            AND MIDate_SertificatEnd.DescId = zc_MIDate_SertificatEnd()

                 LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                             ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                 LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceWithVAT
                                             ON MIFloat_JuridicalPriceWithVAT.MovementItemId = MovementItem.Id
                                            AND MIFloat_JuridicalPriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

                 LEFT JOIN MovementItemFloat AS MIFloat_PrintCount
                                             ON MIFloat_PrintCount.MovementItemId = MovementItem.Id
                                            AND MIFloat_PrintCount.DescId = zc_MIFloat_PrintCount()

                 LEFT JOIN MovementItemBoolean AS MIBoolean_Print
                                               ON MIBoolean_Print.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Print.DescId = zc_MIBoolean_Print()

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                                  ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
              WHERE COALESCE(MILinkObject_ReasonDifferences.ObjectId, 0) <> 0
                 OR inShowAll = TRUE
               )

 , DublePrice AS         (SELECT tmpMI.GoodsId
                               , zc_Color_Yelow() AS DublePriceColour --zc_Color_Goods_Additional() AS DublePriceColour
                          FROM tmpMI
                          WHERE tmpMI.isErased   = FALSE
                          GROUP BY tmpMI.GoodsId
                          HAVING COUNT(DISTINCT tmpMI.Price) > 1
                         )

 , AVGIncome AS     (  SELECT MI_Income.ObjectId,
                              AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                                          THEN  MIFloat_Price.ValueData
                                       ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                  END)::TFloat AS AVGIncomePrice
                       FROM Movement AS Movement_Income
                              JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                   ON MovementBoolean_PriceWithVAT.MovementId =  Movement_Income.Id
                                                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                              JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                      ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                     AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                              JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                               ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                              JOIN MovementItem AS MI 
                                                ON MI.MovementId = inMovementId                                
                              JOIN MovementItem AS MI_Income
                                                ON MI_Income.MovementId = Movement_Income.Id
                                               AND MI_Income.DescId = zc_MI_Master()
                                               AND MI_Income.isErased = FALSE
                                               AND MI_Income.Amount > 0
                                               AND MI_Income.ObjectID = MI.ObjectId
                              JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                         AND Movement_Income.Id <> inMovementId
                         AND Movement_Income.OperDate >= vbAVGDateStart
                         AND Movement_Income.OperDate <= vbAVGDateEnd
                       GROUP BY MI_Income.ObjectId
                      )
 , tmpOrderMI AS   (SELECT MovementItem.ObjectId              AS GoodsId
                         , MovementItem.Amount                AS Amount
                         , MIFloat_Price.ValueData            AS Price
                         , MovementItem.Amount * MIFloat_Price.ValueData   AS Summ
                     FROM MovementItem
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     WHERE MovementItem.MovementId = vbOrderId --1090244
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.isErased  = FAlse
                    )
 , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                     , ROUND(Price_Value.ValueData,2) ::TFloat AS Price
                     , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                     , COALESCE(Price_Fix.ValueData,False)     AS Fix
                     , COALESCE(Price_Top.ValueData,False)     AS isTop
                FROM ObjectLink AS ObjectLink_Price_Unit
                     LEFT JOIN ObjectBoolean AS Price_Fix
                            ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                     LEFT JOIN ObjectBoolean AS Price_Top
                            ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                     LEFT JOIN ObjectFloat AS Price_Value
                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                     LEFT JOIN ObjectFloat AS Price_PercentMarkup
                            ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                     LEFT JOIN MovementItem AS MI 
                            ON MI.MovementId = inMovementId                                
                           AND  ObjectLink_Price_Unit.ObjectId = MI.ObjectId
                     LEFT JOIN ObjectLink AS Price_Goods
                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                 WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                )

   -- Товары соц-проект (документ)
 , tmpGoodsSP AS (SELECT tmp.GoodsId
                       , TRUE AS isSP
                       , MIN(MIFloat_PriceOptSP.ValueData)          AS PriceOptSP
                       , MIN(MovementFloat_PercentMarkup.ValueData) AS PercentMarkupSP
                  FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= vbAVGDateEnd, inEndDate:= vbAVGDateEnd, inUnitId:= vbUnitId) AS tmp
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                   ON MIFloat_PriceOptSP.MovementItemId = tmp.MovementItemId
                                                  AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                       LEFT JOIN MovementFloat AS MovementFloat_PercentMarkup
                                               ON MovementFloat_PercentMarkup.MovementId = tmp.MovementId
                                              AND MovementFloat_PercentMarkup.DescId = zc_MovementFloat_PercentMarkup()
                  GROUP BY tmp.GoodsId
                  )

 , tmpMainParam AS (SELECT ObjectLink_Child.ChildObjectId AS GoodsId
                         , COALESCE (tmpGoodsSP.isSP, False) ::Boolean AS isSP
                         , tmpGoodsSP.PercentMarkupSP
                         , (COALESCE (tmpGoodsSP.PriceOptSP,0) * 1.1) :: TFloat AS PriceOptSP
                                -- получаем GoodsMainId
                    FROM  ObjectLink AS ObjectLink_Child
                          LEFT JOIN ObjectLink AS ObjectLink_Main
                                               ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                              AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                          LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                    WHERE ObjectLink_Child.ChildObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                      AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                   )

 , tmpObjectString_PartnerGoods AS (SELECT ObjectString.*
                                    FROM ObjectString
                                    WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpMI.PartnerGoodsId FROM tmpMI)
                                      AND ObjectString.DescId IN (zc_ObjectString_Goods_Code(), zc_ObjectString_Goods_Maker())
                                    )
 , tmpObjectObjectBoolean AS (SELECT ObjectBoolean.*
                              FROM ObjectBoolean
                              WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                                AND ObjectBoolean.DescId = zc_ObjectBoolean_Goods_TOP()
                             )   
 , tmpObjectFloat AS (SELECT ObjectFloat.*
                      FROM ObjectFloat
                      WHERE ObjectFloat.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                        AND ObjectFloat.DescId IN ( zc_ObjectFloat_Goods_PercentMarkup(), zc_ObjectFloat_Goods_Price())
                      )   
 , tmpObjectLink AS (SELECT ObjectLink.*
                     FROM ObjectLink
                     WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                       AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()
                     )
 , tmpObjectLink_PartnerGoods AS (SELECT ObjectLink.*
                                  FROM ObjectLink
                                  WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpMI.PartnerGoodsId FROM tmpMI)
                                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Area()
                                 )

 , tmpMIBoolean AS (SELECT MovementItemBoolean.*
                    FROM MovementItemBoolean
                    WHERE MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                      AND MovementItemBoolean.MovementItemId IN ( SELECT DISTINCT tmpMI.Id FROM tmpMI)  
                   )

 , tmpObjectLink_GoodsGroup AS (SELECT ObjectLink.ObjectId AS GoodsId
                                     , Object_GoodsGroup.ValueData         AS GoodsGroupName
                                FROM ObjectLink
                                     LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink.ChildObjectId 
                                WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                                  AND ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup()
                               )
 , tmpObjectLink_ConditionsKeep AS (SELECT ObjectLink.ObjectId AS GoodsId
                                         , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                                    FROM ObjectLink
                                         LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink.ChildObjectId 
                                    WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                                      AND ObjectLink.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                    )
 , tmpPromoBonus_GoodsWeek AS (SELECT * FROM gpSelect_PromoBonus_GoodsWeek(inSession := inSession))
 , PromoBonus AS (SELECT MovementItem.Id                               AS Id
                       , MovementItem.ObjectId                         AS GoodsId
                       , MovementItem.Amount                           AS Amount
                       , COALESCE (tmpPromoBonus_GoodsWeek.ID, 0) <> 0 AS isLearnWeek
                  FROM MovementItem
                       LEFT JOIN tmpPromoBonus_GoodsWeek ON tmpPromoBonus_GoodsWeek.ID = MovementItem.Id 
                  WHERE MovementItem.MovementId = vbMovPromoBonus
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = False
                    AND MovementItem.Amount > 0)
 , MarginCategoryItem_View AS (SELECT DISTINCT Object_MarginCategoryItem_View.MarginPercent, Object_MarginCategoryItem_View.MinPrice
                               FROM Object_MarginCategoryItem_View
                                    INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                                  AND Object_MarginCategoryItem.isErased = FALSE
                               WHERE Object_MarginCategoryItem_View.MarginCategoryId = vbMarginCategoryId)
 , MarginCondition AS (SELECT MarginCategoryItem_View.MarginPercent, MarginCategoryItem_View.MinPrice,
                              COALESCE((SELECT MIN(FF.minprice) FROM MarginCategoryItem_View AS FF WHERE FF.MinPrice > MarginCategoryItem_View.MinPrice), 1000000) AS MaxPrice
                       FROM MarginCategoryItem_View)
 , tmpExpirationDatePG AS (SELECT tmpMI.ID
                                , MIN(ObjectDate_ExpirationDate.ValueData) AS ExpirationDate
                           FROM tmpMI
                             
                                INNER JOIN MovementItemContainer AS MIC
                                                                 ON MIC.MovementId = inMovementId
                                                                AND MIC.MovementItemId = tmpMI.Id
                                                                AND MIC.DescId = zc_MIContainer_Count()

                                INNER JOIN Container AS ContainerPD
                                                     ON ContainerPD.ParentId = MIC.ContainerId
                                                    AND ContainerPD.DescId = zc_Container_CountPartionDate()

                                LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = ContainerPD.ID
                                                             AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                     ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId
                                                    AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                           GROUP BY tmpMI.ID
                           )

       -- результат
          SELECT 
              MovementItem.Id
            , MovementItem.GoodsId
            , Object_Goods.ObjectCode            AS GoodsCode
            , Object_Goods.ValueData             AS GoodsName
            , ObjectString_Code.ValueData        AS PartnerGoodsCode
            , COALESCE (MovementItem.GoodsName, Object_PartnerGoods.ValueData)      AS PartnerGoodsName
            , Object_Retail.ValueData            AS RetailName
            , Object_Area.ValueData              AS AreaName
            , MovementItem.Amount
            , MovementItem.Price
            , MovementItem.PriceWithVAT
            , ((MovementItem.PriceSale/NULLIF (MovementItem.PriceWithVAT, 0) - 1) * 100)::TFloat AS MarginPercent
            , MovementItem.AmountSumm
            , MovementItem.PriceSale
            , MovementItem.SummSale
            , MovementItem.PriceSample
            , MovementItem.SummSample
            , MovementItem.JuridicalPrice
            , MovementItem.JuridicalPriceWithVAT
            , MovementItem.isErased
            , MovementItem.ExpirationDate
            , tmpExpirationDatePG.ExpirationDate  :: TDateTime AS ExpirationDatePG
            , MovementItem.PartionGoods
            , ObjectString_Goods_Maker.ValueData  AS MakerName
            , MovementItem.FEA
            , MovementItem.Measure
            , ObjectLink_Goods_GoodsGroup.GoodsGroupName
            , ObjectLink_Goods_ConditionsKeep.ConditionsKeepName
            , DublePrice.DublePriceColour
            , MovementItem.SertificatNumber
            , MovementItem.SertificatStart
            , MovementItem.SertificatEnd
            , CASE WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()
                   WHEN ObjectString_Code.ValueData IS NULL THEN zc_Color_Warning_Navy()
              END AS WarningColor
            , AVGIncome.AVGIncomePrice
            , CASE WHEN (ABS(AVGIncome.AVGIncomePrice - MovementItem.PriceWithVAT) / NULLIF(MovementItem.PriceWithVAT,0)) > 0.25
                      THEN TRUE
                   ELSE FALSE
              END AS AVGIncomePriceWarning
            , MovementItem.AmountManual
            , (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0))::TFloat as AmountDiff
            , (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0))::TFloat as Amount
            , Object_ReasonDifferences.Id                AS ReasonDifferencesId
            , Object_ReasonDifferences.ValueData         AS ReasonDifferencesName
            , COALESCE (tmpOrderMI.Amount,0)  ::TFloat   AS OrderAmount
            , COALESCE (tmpOrderMI.Price,0)   ::TFloat   AS OrderPrice
            , COALESCE (tmpOrderMI.Summ,0)    ::TFloat   AS OrderSumm
            , CAST (COALESCE (tmpOrderMI.Price,0) /
                                    NULLIF (CASE WHEN TRUE = False THEN MovementItem.Price
                                                                             ELSE (MovementItem.Price - MovementItem.Price * (7 / (7 + 100)))
                                            END, 0) * 100 - 100  AS NUMERIC (16, 2)) :: Tfloat AS PersentDiff

            , CASE WHEN COALESCE (tmpOrderMI.Amount,0) <> MovementItem.Amount THEN TRUE ELSE FALSE END AS isAmountDiff
--              , CASE WHEN COALESCE (tmpOrderMI.Price,0) <> MovementItem.Price THEN TRUE ELSE FALSE END AS isSummDiff
            , CASE WHEN vbPriceWithVAT = False AND MovementItem.Price = 0
                   THEN
                       CASE WHEN COALESCE (tmpOrderMI.Price,0) <> MovementItem.Price THEN TRUE ELSE FALSE END
                   WHEN CAST (MovementItem.Price - MovementItem.Price * (vbVAT / NULLIF ((vbVAT + 100), 0)) AS NUMERIC (16, 2)) = 0
                   THEN
                       CASE WHEN COALESCE (tmpOrderMI.Price,0) <> CAST (MovementItem.Price - MovementItem.Price * (vbVAT / NULLIF ((vbVAT + 100), 0)) AS NUMERIC (16, 2)) THEN TRUE ELSE FALSE END
                   WHEN vbPriceWithVAT = False
                   THEN
                       CASE WHEN ABS((COALESCE (tmpOrderMI.Price,0) - MovementItem.Price) / MovementItem.Price * 100) > 0.5  THEN TRUE ELSE FALSE END
                   ELSE
                       CASE WHEN ABS((COALESCE (tmpOrderMI.Price,0) - CAST (MovementItem.Price - MovementItem.Price * (vbVAT / NULLIF ((vbVAT + 100), 0)) AS NUMERIC (16, 2))) /
                                 CAST (MovementItem.Price - MovementItem.Price * (vbVAT / NULLIF ((vbVAT + 100), 0)) AS NUMERIC (16, 2)) * 100) > 0.5 THEN TRUE ELSE FALSE END
              END  AS isSummDiff

            , COALESCE (tmpPrice.isTop,FALSE)            :: Boolean  AS isTop
            , COALESCE (tmpMainParam.isSP, False)        :: Boolean  AS isSP
            , COALESCE (tmpMainParam.PercentMarkupSP,0)  :: TFloat   AS PriceOptSP
            , COALESCE (tmpMainParam.PriceOptSP,0)       :: TFloat   AS PriceOptSP
            , tmpPrice.PercentMarkup                     :: TFloat   AS PercentMarkup
            , CASE WHEN COALESCE(tmpPrice.Fix,False) = TRUE THEN COALESCE(tmpPrice.Price,0) ELSE 0 END ::TFloat AS Fix_Price

            , CASE WHEN COALESCE (DublePrice.DublePriceColour, zc_Color_White()) <> zc_Color_White() THEN DublePrice.DublePriceColour ELSE zc_Color_White() END AS Color_calc --вроде розовый

            , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false) ::Boolean AS Goods_isTop
            , ObjectFloat_Goods_PercentMarkup.ValueData          ::TFloat  AS Goods_PercentMarkup
            , ObjectFloat_Goods_Price.ValueData                  ::TFloat  AS Goods_Price
            , CASE WHEN tmpMainParam.isSP = TRUE THEN 25088  -- зеленый green выделяем товары соц проекта
                   WHEN (tmpPrice.isTop = TRUE OR ObjectBoolean_Goods_TOP.ValueData = TRUE) THEN zc_Color_Blue() -- 15993821 -- розовый 16440317
                   WHEN MovementItem.ExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Red()
                   WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()                -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                   WHEN ObjectString_Code.ValueData IS NULL THEN zc_Color_Warning_Navy()      -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                   ELSE zc_Color_Black()
              END      AS Color_ExpirationDate                --vbAVGDateEnd

            , CASE WHEN MovementItem.ExpirationDate < vbAVGDateEnd + INTERVAL '1 YEAR'
                   THEN zfCalc_Color (0, 255, 255)
                   ELSE COALESCE (DublePrice.DublePriceColour, zc_Color_White()) END          AS Color_ExpirationDatePh

            , MovementItem.PrintCount
            , MovementItem.isPrint

            , MovementItem.InsertName
            , MovementItem.InsertDate

            , CASE WHEN COALESCE (MIBoolean_Conduct.ValueData, FALSE) THEN zc_Color_Greenl() ELSE zc_Color_White() END AS Color_AmountManual
              
            , Accommodation.AccommodationId                                    AS AccommodationId
            , Object_Accommodation.ValueData                                   AS AccommodationName
              
            , PromoBonus.Amount                                                AS PromoBonus  
            , CASE WHEN COALESCE(PromoBonus.Amount, 0) <> 0 THEN MarginCondition.MarginPercent END::TFloat  AS MarginPercentUnit  
            , COALESCE(PromoBonus.isLearnWeek, FALSE)                          AS isLearnWeek
              
          FROM tmpMI AS MovementItem
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
              LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MovementItem.ReasonDifferencesId

              LEFT JOIN DublePrice ON MovementItem.GoodsId = DublePrice.GoodsId
              LEFT JOIN AVGIncome ON AVGIncome.ObjectId = MovementItem.GoodsId
              LEFT JOIN tmpOrderMI ON tmpOrderMI.GoodsId =  MovementItem.GoodsId
              LEFT OUTER JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.GoodsId

              LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = MovementItem.PartnerGoodsId
              LEFT JOIN tmpObjectString_PartnerGoods AS ObjectString_Code
                                                     ON ObjectString_Code.ObjectId = MovementItem.PartnerGoodsId
                                                    AND ObjectString_Code.DescId = zc_ObjectString_Goods_Code()
              LEFT JOIN tmpObjectString_PartnerGoods AS ObjectString_Goods_Maker
                                                     ON ObjectString_Goods_Maker.ObjectId = MovementItem.PartnerGoodsId
                                                    AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

              LEFT JOIN tmpObjectObjectBoolean AS ObjectBoolean_Goods_TOP
                                               ON ObjectBoolean_Goods_TOP.ObjectId = MovementItem.GoodsId
              LEFT JOIN tmpObjectFloat AS ObjectFloat_Goods_PercentMarkup
                                       ON ObjectFloat_Goods_PercentMarkup.ObjectId = MovementItem.GoodsId
                                      AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
              LEFT JOIN tmpObjectFloat AS ObjectFloat_Goods_Price
                                       ON ObjectFloat_Goods_Price.ObjectId = MovementItem.GoodsId
                                      AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()

              LEFT JOIN tmpObjectLink AS ObjectLink_Object
                                      ON ObjectLink_Object.ObjectId = MovementItem.GoodsId
              LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId

              LEFT JOIN tmpObjectLink_PartnerGoods AS ObjectLink_Goods_Area
                                                   ON ObjectLink_Goods_Area.ObjectId = MovementItem.PartnerGoodsId
              LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

              -- получаем GoodsMainId
              LEFT JOIN  tmpMainParam ON tmpMainParam.GoodsId = MovementItem.GoodsId
                                    
              LEFT JOIN tmpMIBoolean AS MIBoolean_Conduct 
                                     ON MIBoolean_Conduct.DescId = zc_MIBoolean_Conduct()
                                    AND MIBoolean_Conduct.MovementItemId = MovementItem.Id
                                      
             LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                    ON Accommodation.UnitId = vbUnitId
                                                   AND Accommodation.GoodsId = MovementItem.GoodsId
                                                   AND Accommodation.isErased = False
             -- Размещение товара
             LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId

             -- группа товара
             LEFT JOIN tmpObjectLink_GoodsGroup AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.GoodsId = MovementItem.GoodsId
             -- условия хранения
             LEFT JOIN tmpObjectLink_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                    ON ObjectLink_Goods_ConditionsKeep.GoodsId = MovementItem.GoodsId
                                                      
             -- Маркетинговый бонус
             LEFT JOIN PromoBonus ON PromoBonus.GoodsId = MovementItem.GoodsId

             LEFT JOIN MarginCondition ON MarginCondition.MinPrice < MovementItem.PriceWithVAT AND MovementItem.PriceWithVAT <= MarginCondition.MaxPrice
            
             LEFT JOIN tmpExpirationDatePG ON tmpExpirationDatePG.ID = MovementItem.Id
               
              ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 01.12.21                                                                                       *

*/

-- тест
-- 

select * from gpSelect_MovementItem_Income_CreatePretension(inMovementId := 25315193   , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');