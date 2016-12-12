-- Function: gpSelect_MovementItem_Income()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, IdBarCode TVarChar, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsCode TVarChar, PartnerGoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , PriceWithVAT TFloat
             , MarginPercent TFloat
             , Summ TFloat
             , SalePrice TFloat
             , SaleSumm TFloat
             , JuridicalPrice TFloat
             , JuridicalPriceWithVAT TFloat
             , isErased Boolean
             , ExpirationDate TDateTime
             , PartionGoods TVarChar
             , MakerName TVarChar
             , FEA TVarChar
             , Measure TVarChar
             , DublePriceColour Integer
             , SertificatNumber TVarChar
             , SertificatStart TDateTime
             , SertificatEnd TDateTime
             , WarningColor Integer
             , AVGIncomePrice TFloat
             , AVGIncomePriceWarning Boolean
             , AmountManual TFloat
             , AmountDiff TFloat
             , ReasonDifferencesId Integer
             , ReasonDifferencesName TVarChar
             , OrderAmount TFloat
             , OrderPrice TFloat
             , OrderSumm TFloat
             , PersentDiff Tfloat
             , isAmountDiff Boolean
             , isSummDiff Boolean

             , isTop  Boolean
             , PercentMarkup TFloat
             , Fix_Price TFloat
             , Color_calc Integer

             , Goods_isTop Boolean
             , Goods_PercentMarkup  TFloat
             , Goods_Price TFloat
             , Color_ExpirationDate  Integer
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
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    SELECT 
        Movement_Income_View.PriceWithVAT
      , Movement_Income_View.NDS
      , Movement_Income_View.OperDate
      , Movement_Income_View.OperDate - INTERVAL '30 day'
      , Movement_Income_View.ToId
    INTO 
        vbPriceWithVAT
      , vbVAT
      , vbAVGDateEnd
      , vbAVGDateStart
      , vbUnitId 
    FROM 
        Movement_Income_View 
    WHERE
        Movement_Income_View.Id = inMovementId;

    vbOrderId := (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.descid = zc_MovementLinkMovement_Order() AND MLM.MovementId = inMovementId);  --1084910

    IF inShowAll 
    THEN
        RETURN QUERY
        WITH 
       tmpIsErased AS (SELECT FALSE AS isErased 
                        UNION ALL 
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
                        
      , tmpGoods AS (SELECT Object_Goods.Id           AS GoodsId
                          , Object_Goods.GoodsCodeInt AS GoodsCode
                          , Object_Goods.GoodsName    AS GoodsName
                          , Object_Goods.isTop            AS Goods_isTop
                          , Object_Goods.PercentMarkup    AS Goods_PercentMarkup
                          , Object_Goods.Price            AS Goods_Price
                     FROM Object_Goods_View AS Object_Goods
                     WHERE Object_Goods.isErased = FALSE 
                       AND Object_Goods.ObjectId = vbObjectId
                     )
       , tmpMI AS   (SELECT MovementItem.ObjectId                         AS GoodsId
                     FROM tmpIsErased
                        JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased
                     )
      , AVGIncome AS      (SELECT MI_Income.ObjectId
                               , AVG(CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE 
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
                             
                                JOIN MovementItem AS MI_Income
                                                  ON MI_Income.MovementId = Movement_Income.Id
                                                 AND MI_Income.DescId = zc_MI_Master()
                                                 AND MI_Income.isErased = FALSE
                                                 AND MI_Income.Amount > 0
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
                           
    , DublePrice AS        (SELECT MovementItem_Income_View.GoodsId
                                 , zc_Color_Yelow() AS DublePriceColour --zc_Color_Goods_Additional() AS DublePriceColour
                            FROM MovementItem_Income_View
                            WHERE MovementItem_Income_View.MovementId = inMovementId 
                              AND MovementItem_Income_View.isErased   = FALSE
                            GROUP BY MovementItem_Income_View.GoodsId
                            HAVING COUNT(DISTINCT MovementItem_Income_View.Price) > 1
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
                      
            SELECT
                0                          AS Id
              , zfFormat_BarCode(zc_BarCodePref_Object(), Object_Price_View.Id) AS IdBarCode
              , tmpGoods.GoodsId           AS GoodsId
              , tmpGoods.GoodsCode         AS GoodsCode
              , tmpGoods.GoodsName         AS GoodsName
              , ''::TVarChar               AS PartnerGoodsCode
              , ''::TVarChar               AS PartnerGoodsName
              , CAST (NULL AS TFloat)      AS Amount
              , CAST (NULL AS TFloat)      AS Price
              , CAST (NULL AS TFloat)      AS PriceWithVAT
              , CAST (NULL AS TFloat)      AS MarginPercent
              , CAST (NULL AS TFloat)      AS Summ
              , CAST (NULL AS TFloat)      AS PriceSale
              , CAST (NULL AS TFloat)      AS SummSale
              , CAST (NULL AS TFloat)      AS JuridicalPrice
              , CAST (NULL AS TFloat)      AS JuridicalPriceWithVAT
              , FALSE                      AS isErased
              , NULL::TDateTime            AS ExpirationDate
              , NULL::TVarChar             AS PartionGoods
              , NULL::TVarChar             AS MakerName
              , NULL::TVarChar             AS FEA
              , NULL::TVarChar             AS Measure
              , NULL::Integer              AS DublePriceColour
              , NULL::TVarChar             AS SertificatNumber
              , NULL::TDateTime            AS SertificatStart
              , NULL::TDateTime            AS SertificatEnd
              , NULL::Integer              AS WarningColor
              , NULL::TFloat               AS AVGIncomePrice
              , FALSE                      AS AVGIncomePriceWarning
              , NULL::TFloat               AS AmountManual
              , NULL::TFloat               AS AmountDiff
              , NULL::Integer              AS ReasonDifferencesId
              , NULL::TVarChar             AS ReasonDifferencesName
              , NULL::TFloat               AS OrderAmount
              , NULL::TFloat               AS OrderPrice
              , NULL::TFloat               AS OrderSumm
              , NULL::TFloat               AS PersentDiff
              , FALSE                      AS isAmountDiff
              , FALSE                      AS isSummDiff

              , COALESCE (Object_Price_View.isTop,FALSE)          ::Boolean  AS isTop 
              , Object_Price_View.PercentMarkup  ::TFloat   AS PercentMarkup
              , CASE WHEN COALESCE(Object_Price_View.Fix,False) = TRUE THEN COALESCE(Object_Price_View.Price,0) ELSE 0 END  ::TFloat AS Fix_Price

              , zc_Color_White()  AS Color_calc

              , tmpGoods.Goods_isTop          ::Boolean
              , tmpGoods.Goods_PercentMarkup  ::TFloat 
              , tmpGoods.Goods_Price          ::TFloat 
              , CASE WHEN (Object_Price_View.isTop = TRUE OR tmpGoods.Goods_isTop = TRUE) THEN 15993821 -- розовый 16440317 
                     ELSE zc_Color_Black()
                END        AS Color_ExpirationDate               --zc_Color_Blue 
            FROM tmpGoods
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.GoodsId = tmpGoods.GoodsId
                                                 AND Object_Price_View.UnitId = vbUnitId
            WHERE tmpMI.GoodsId IS NULL

            UNION ALL
            SELECT
                MovementItem.Id
              , zfFormat_BarCode(zc_BarCodePref_Object(), Object_Price_View.Id) AS IdBarCode
              , MovementItem.GoodsId
              , MovementItem.GoodsCode
              , MovementItem.GoodsName
              , MovementItem.PartnerGoodsCode
              , MovementItem.PartnerGoodsName
              , MovementItem.Amount
              , MovementItem.Price
              , MovementItem.PriceWithVAT
              , ((MovementItem.PriceSale/MovementItem.PriceWithVAT - 1) * 100)::TFloat AS MarginPercent
              , MovementItem.AmountSumm
              , MovementItem.PriceSale
              , MovementItem.SummSale
              , COALESCE(MIFloat_JuridicalPrice.ValueData,0) ::TFloat AS JuridicalPrice
              , COALESCE(MIFloat_JuridicalPriceWithVAT.ValueData,0) ::TFloat AS JuridicalPriceWithVAT
              , MovementItem.isErased
              , MovementItem.ExpirationDate
              , MovementItem.PartionGoods
              , MovementItem.MakerName
              , MovementItem.FEA
              , MovementItem.Measure
              , DublePrice.DublePriceColour
              , MovementItem.SertificatNumber
              , MovementItem.SertificatStart
              , MovementItem.SertificatEnd
              , CASE 
                   WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()
                   WHEN MovementItem.PartnerGoodsCode IS NULL THEN zc_Color_Warning_Navy()
                END AS WarningColor
              , AVGIncome.AVGIncomePrice
              , CASE 
                    WHEN (ABS(AVGIncome.AVGIncomePrice - MovementItem.PriceWithVAT) / NULLIF(MovementItem.PriceWithVAT,0)) > 0.25
                        THEN TRUE
                    ELSE FALSE
                END AS AVGIncomePriceWarning
              , MovementItem.AmountManual
              , (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0))::TFloat as AmountDiff
              , MovementItem.ReasonDifferencesId
              , MovementItem.ReasonDifferencesName

              , COALESCE (tmpOrderMI.Amount,0)  ::TFloat   AS OrderAmount
              , COALESCE (tmpOrderMI.Price,0)   ::TFloat   AS OrderPrice
              , COALESCE (tmpOrderMI.Summ,0)    ::TFloat   AS OrderSumm

              , CAST (COALESCE (tmpOrderMI.Price,0) / 
                                      NULLIF (CASE WHEN vbPriceWithVAT = False THEN MovementItem.Price
                                                                               ELSE (MovementItem.Price - MovementItem.Price * (vbVAT / (vbVAT + 100)))
                                              END, 0) * 100 - 100  AS NUMERIC (16, 2))  :: Tfloat  AS PersentDiff

              , CASE WHEN COALESCE (tmpOrderMI.Amount, 0) <> MovementItem.Amount THEN TRUE ELSE FALSE END AS isAmountDiff
              , CASE WHEN vbPriceWithVAT = False 
                     THEN 
                         CASE WHEN COALESCE (tmpOrderMI.Price,0) <> MovementItem.Price THEN TRUE ELSE FALSE END
                     ELSE 
                         CASE WHEN COALESCE (tmpOrderMI.Price,0) <> CAST (MovementItem.Price - MovementItem.Price * (vbVAT / (vbVAT + 100)) AS NUMERIC (16, 2)) THEN TRUE ELSE FALSE END
                END  AS isSummDiff


              , COALESCE (Object_Price_View.isTop,FALSE)          ::Boolean AS isTop 
              , Object_Price_View.PercentMarkup  ::TFloat  AS PercentMarkup
              , CASE WHEN COALESCE(Object_Price_View.Fix,False) = TRUE THEN COALESCE(Object_Price_View.Price,0) ELSE 0 END  ::TFloat  AS Fix_Price

              , CASE WHEN COALESCE (DublePrice.DublePriceColour, zc_Color_White()) <> zc_Color_White() THEN DublePrice.DublePriceColour ELSE zc_Color_White() END AS Color_calc --вроде розовый

              , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false) ::Boolean AS Goods_isTop          
              , ObjectFloat_Goods_PercentMarkup.ValueData          ::TFloat  AS Goods_PercentMarkup  
              , ObjectFloat_Goods_Price.ValueData                  ::TFloat  AS Goods_Price          

              , CASE WHEN (Object_Price_View.isTop = TRUE OR ObjectBoolean_Goods_TOP.ValueData = TRUE) THEN 15993821 -- розовый 16440317
                     WHEN MovementItem.ExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                     WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()                -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     WHEN MovementItem.PartnerGoodsCode IS NULL THEN zc_Color_Warning_Navy()      -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     ELSE zc_Color_Black()
                END      AS Color_ExpirationDate
            FROM tmpIsErased
                JOIN MovementItem_Income_View AS MovementItem 
                                              ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                            ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceWithVAT
                                            ON MIFloat_JuridicalPriceWithVAT.MovementItemId = MovementItem.Id
                                           AND MIFloat_JuridicalPriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

                LEFT JOIN DublePrice ON MovementItem.GoodsId = DublePrice.GoodsId
                LEFT JOIN AVGIncome ON AVGIncome.ObjectId = MovementItem.GoodsId
                LEFT JOIN tmpOrderMI ON tmpOrderMI.GoodsId =  MovementItem.GoodsId
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.GoodsId = MovementItem.GoodsId
                                                 AND Object_Price_View.UnitId = vbUnitId

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                        ON ObjectBoolean_Goods_TOP.ObjectId = MovementItem.GoodsId
                                       AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                                      ON ObjectFloat_Goods_PercentMarkup.ObjectId = MovementItem.GoodsId
                                     AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()   
                LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                                      ON ObjectFloat_Goods_Price.ObjectId = MovementItem.GoodsId
                                     AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()   
               ;
    ELSE
       RETURN QUERY
       WITH 
       tmpIsErased AS (SELECT FALSE AS isErased 
                        UNION ALL 
                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                      )
   , DublePrice AS         (SELECT MovementItem_Income_View.GoodsId
                                 , zc_Color_Yelow() AS DublePriceColour --zc_Color_Goods_Additional() AS DublePriceColour 
                            FROM MovementItem_Income_View
                            WHERE MovementItem_Income_View.MovementId = inMovementId 
                              AND MovementItem_Income_View.isErased   = FALSE
                            GROUP BY MovementItem_Income_View.GoodsId
                            HAVING COUNT(DISTINCT MovementItem_Income_View.Price) > 1
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
                             
                                JOIN MovementItem AS MI_Income
                                                  ON MI_Income.MovementId = Movement_Income.Id
                                                 AND MI_Income.DescId = zc_MI_Master()
                                                 AND MI_Income.isErased = FALSE
                                                 AND MI_Income.Amount > 0
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
                                          
            SELECT
                MovementItem.Id
              , zfFormat_BarCode(zc_BarCodePref_Object(), Object_Price_View.Id) AS IdBarCode
              , MovementItem.GoodsId
              , MovementItem.GoodsCode
              , MovementItem.GoodsName
              , MovementItem.PartnerGoodsCode
              , MovementItem.PartnerGoodsName
              , MovementItem.Amount
              , MovementItem.Price
              , MovementItem.PriceWithVAT
              , ((MovementItem.PriceSale/MovementItem.PriceWithVAT - 1) * 100)::TFloat AS MarginPercent
              , MovementItem.AmountSumm
              , MovementItem.PriceSale
              , MovementItem.SummSale
              , COALESCE(MIFloat_JuridicalPrice.ValueData,0) ::TFloat AS JuridicalPrice
              , COALESCE(MIFloat_JuridicalPriceWithVAT.ValueData,0) ::TFloat AS JuridicalPriceWithVAT
              , MovementItem.isErased
              , MovementItem.ExpirationDate
              , MovementItem.PartionGoods
              , MovementItem.MakerName
              , MovementItem.FEA
              , MovementItem.Measure
              , DublePrice.DublePriceColour
              , MovementItem.SertificatNumber
              , MovementItem.SertificatStart
              , MovementItem.SertificatEnd
              , CASE 
                    WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()
                    WHEN MovementItem.PartnerGoodsCode IS NULL THEN zc_Color_Warning_Navy()
                END AS WarningColor
              , AVGIncome.AVGIncomePrice
              , CASE 
                    WHEN (ABS(AVGIncome.AVGIncomePrice - MovementItem.PriceWithVAT) / NULLIF(MovementItem.PriceWithVAT,0)) > 0.25
                        THEN TRUE
                    ELSE FALSE
                END AS AVGIncomePriceWarning
              , MovementItem.AmountManual
              , (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0))::TFloat as AmountDiff
              , MovementItem.ReasonDifferencesId
              , MovementItem.ReasonDifferencesName      
              , COALESCE (tmpOrderMI.Amount,0)  ::TFloat   AS OrderAmount
              , COALESCE (tmpOrderMI.Price,0)   ::TFloat   AS OrderPrice
              , COALESCE (tmpOrderMI.Summ,0)    ::TFloat   AS OrderSumm
              , CAST (COALESCE (tmpOrderMI.Price,0) / 
                                      NULLIF (CASE WHEN vbPriceWithVAT = False THEN MovementItem.Price
                                                                               ELSE (MovementItem.Price - MovementItem.Price * (vbVAT / (vbVAT + 100)))
                                              END, 0) * 100 - 100  AS NUMERIC (16, 2)) :: Tfloat AS PersentDiff
                                                       
              , CASE WHEN COALESCE (tmpOrderMI.Amount,0) <> MovementItem.Amount THEN TRUE ELSE FALSE END AS isAmountDiff
--              , CASE WHEN COALESCE (tmpOrderMI.Price,0) <> MovementItem.Price THEN TRUE ELSE FALSE END AS isSummDiff
              , CASE WHEN vbPriceWithVAT = False 
                     THEN 
                         CASE WHEN COALESCE (tmpOrderMI.Price,0) <> MovementItem.Price THEN TRUE ELSE FALSE END
                     ELSE 
                         CASE WHEN COALESCE (tmpOrderMI.Price,0) <> CAST (MovementItem.Price - MovementItem.Price * (vbVAT / (vbVAT + 100)) AS NUMERIC (16, 2)) THEN TRUE ELSE FALSE END
                END  AS isSummDiff

              , COALESCE (Object_Price_View.isTop,FALSE)   ::Boolean AS isTop 
              , Object_Price_View.PercentMarkup  ::TFloat  AS PercentMarkup
              , CASE WHEN COALESCE(Object_Price_View.Fix,False) = TRUE THEN COALESCE(Object_Price_View.Price,0) ELSE 0 END ::TFloat AS Fix_Price

              , CASE WHEN COALESCE (DublePrice.DublePriceColour, zc_Color_White()) <> zc_Color_White() THEN DublePrice.DublePriceColour ELSE zc_Color_White() END AS Color_calc --вроде розовый

              , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false) ::Boolean AS Goods_isTop          
              , ObjectFloat_Goods_PercentMarkup.ValueData          ::TFloat  AS Goods_PercentMarkup  
              , ObjectFloat_Goods_Price.ValueData                  ::TFloat  AS Goods_Price   
              , CASE WHEN (Object_Price_View.isTop = TRUE OR ObjectBoolean_Goods_TOP.ValueData = TRUE) THEN 15993821 -- розовый 16440317
                     WHEN MovementItem.ExpirationDate < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                     WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()                -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     WHEN MovementItem.PartnerGoodsCode IS NULL THEN zc_Color_Warning_Navy()      -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     ELSE zc_Color_Black()
                END      AS Color_ExpirationDate                --vbAVGDateEnd
            FROM tmpIsErased
                JOIN MovementItem_Income_View AS MovementItem 
                                              ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                            ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceWithVAT
                                            ON MIFloat_JuridicalPriceWithVAT.MovementItemId = MovementItem.Id
                                           AND MIFloat_JuridicalPriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

                LEFT JOIN DublePrice ON MovementItem.GoodsId = DublePrice.GoodsId
                LEFT JOIN AVGIncome ON AVGIncome.ObjectId = MovementItem.GoodsId
                LEFT JOIN tmpOrderMI ON tmpOrderMI.GoodsId =  MovementItem.GoodsId
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.GoodsId = MovementItem.GoodsId
                                                 AND Object_Price_View.UnitId = vbUnitId

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                        ON ObjectBoolean_Goods_TOP.ObjectId = MovementItem.GoodsId
                                       AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                                      ON ObjectFloat_Goods_PercentMarkup.ObjectId = MovementItem.GoodsId
                                     AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()   
                LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                                      ON ObjectFloat_Goods_Price.ObjectId = MovementItem.GoodsId
                                     AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()     

                ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 12.12.16         * add IdBarCode
 14.09.16         *
 27.04.16         *
 23.04.16         *
 01.10.15                                                                        *SertificatNumber,SertificatStart,SertificatEnd               
 09.04.15                         *
 06.03.15                         *
 26.12.14                         *
 09.12.14                         *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 1084910, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 1084910, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
