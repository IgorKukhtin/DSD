-- Function: gpSelect_MovementItem_Income()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, /*IdBarCode TVarChar,*/ GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
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

             , PrintCount TFloat
             , isPrint  Boolean

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

   -- vbOrderId := (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.descid = zc_MovementLinkMovement_Order() AND MLM.MovementId = inMovementId);  --1084910

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
       , tmpMI AS   (SELECT MovementItem.ObjectId   AS GoodsId
                          , MovementItem.Amount
                          , MIFloat_Price.ValueData AS Price
                          , CASE WHEN vbPriceWithVAT THEN MIFloat_Price.ValueData
                                                     ELSE (MIFloat_Price.ValueData * (1 + vbVAT/100))::TFloat
                            END AS PriceWithVAT
                          , MovementItem.Id
                          , MovementItem.isErased
                     FROM tmpIsErased
                        JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
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
                           
    , DublePrice AS        (SELECT tmpMI.GoodsId
                                 , zc_Color_Yelow() AS DublePriceColour --zc_Color_Goods_Additional() AS DublePriceColour
                            FROM tmpMI
                            WHERE tmpMI.isErased = FALSE
                            GROUP BY tmpMI.GoodsId
                            HAVING COUNT(DISTINCT tmpMI.Price) > 1
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
          --    , zfFormat_BarCode(zc_BarCodePref_Object(), Object_Price_View.Id) AS IdBarCode
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

              , NULL::TFloat               AS PrintCount
              , FALSE                      AS isPrint
            FROM tmpGoods
                LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.GoodsId = tmpGoods.GoodsId
                                                 AND Object_Price_View.UnitId = vbUnitId
            WHERE tmpMI.GoodsId IS NULL

            UNION ALL
            SELECT
                MovementItem.Id
             -- , zfFormat_BarCode(zc_BarCodePref_Object(), Object_Price_View.Id) AS IdBarCode
              , MovementItem.GoodsId
              , Object_Goods.ObjectCode            AS GoodsCode
              , Object_Goods.ValueData             AS GoodsName
              , Object_PartnerGoods.GoodsCode      AS PartnerGoodsCode
              , Object_PartnerGoods.GoodsName      AS PartnerGoodsName
              , MovementItem.Amount
              , MovementItem.Price
              , MovementItem.PriceWithVAT

              , ((COALESCE(MIFloat_PriceSale.ValueData,0)/MovementItem.PriceWithVAT - 1) * 100)::TFloat AS MarginPercent
              , (((COALESCE (MovementItem.Amount, 0)) * MovementItem.Price)::NUMERIC (16, 2))::TFloat   AS AmountSumm
              , COALESCE(MIFloat_PriceSale.ValueData,0)::TFloat        AS PriceSale
              , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))::TFloat AS SummSale
              , COALESCE(MIFloat_JuridicalPrice.ValueData,0) ::TFloat AS JuridicalPrice
              , COALESCE(MIFloat_JuridicalPriceWithVAT.ValueData,0) ::TFloat AS JuridicalPriceWithVAT
              , MovementItem.isErased
              , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) :: TDateTime AS ExpirationDate
              , COALESCE(MIString_PartionGoods.ValueData, '')              :: TVarChar  AS PartionGoods

              , Object_PartnerGoods.MakerName      AS MakerName
              , MIString_FEA.ValueData             AS FEA
              , MIString_Measure.ValueData         AS Measure

              , DublePrice.DublePriceColour
              , MIString_SertificatNumber.ValueData AS SertificatNumber
              , MIDate_SertificatStart.ValueData    AS SertificatStart
              , MIDate_SertificatEnd.ValueData      AS SertificatEnd
              , CASE 
                   WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()
                   WHEN Object_PartnerGoods.GoodsCode IS NULL THEN zc_Color_Warning_Navy()
                END AS WarningColor
              , AVGIncome.AVGIncomePrice
              , CASE 
                    WHEN (ABS(AVGIncome.AVGIncomePrice - MovementItem.PriceWithVAT) / NULLIF(MovementItem.PriceWithVAT,0)) > 0.25
                        THEN TRUE
                    ELSE FALSE
                END AS AVGIncomePriceWarning
              , MIFloat_AmountManual.ValueData      AS AmountManual
              , (COALESCE(MIFloat_AmountManual.ValueData,0) - COALESCE(MovementItem.Amount,0))::TFloat as AmountDiff
              , MILinkObject_ReasonDifferences.ObjectId AS ReasonDifferencesId
              , Object_ReasonDifferences.ValueData      AS ReasonDifferencesName

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
                     WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                     WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()                -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     WHEN Object_PartnerGoods.GoodsCode IS NULL THEN zc_Color_Warning_Navy()      -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     ELSE zc_Color_Black()
                END      AS Color_ExpirationDate

              , COALESCE (MIFloat_PrintCount.ValueData, 0)   ::TFloat      AS PrintCount
              , COALESCE (MIBoolean_Print.ValueData, TRUE) ::Boolean     AS isPrint

            FROM tmpMI AS MovementItem
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object_Goods_View AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId

            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
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
            LEFT JOIN MovementItemString AS MIString_SertificatNumber
                                         ON MIString_SertificatNumber.MovementItemId = MovementItem.Id
                                        AND MIString_SertificatNumber.DescId = zc_MIString_SertificatNumber()                                         

            LEFT JOIN MovementItemDate  AS MIDate_SertificatStart
                                        ON MIDate_SertificatStart.MovementItemId = MovementItem.Id
                                       AND MIDate_SertificatStart.DescId = zc_MIDate_SertificatStart()                                         
            LEFT JOIN MovementItemDate  AS MIDate_SertificatEnd
                                        ON MIDate_SertificatEnd.MovementItemId = MovementItem.Id
                                       AND MIDate_SertificatEnd.DescId = zc_MIDate_SertificatEnd()   
            LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                             ON MILinkObject_ReasonDifferences.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
            LEFT JOIN Object AS Object_ReasonDifferences 
                             ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId

--
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
   ,  tmpMI AS (SELECT MovementItem.Id
                     , MovementItem.ObjectId              AS GoodsId
                     , Object_Goods.ObjectCode            AS GoodsCode
                     , Object_Goods.ValueData             AS GoodsName
                     , ObjectString_Code.ValueData        AS PartnerGoodsCode
                     , Object_PartnerGoods.ValueData      AS PartnerGoodsName
                     , MovementItem.Amount                AS Amount
                     , MIFloat_Price.ValueData            AS Price
                     , CASE WHEN vbPriceWithVAT THEN  MIFloat_Price.ValueData
                                                ELSE (MIFloat_Price.ValueData * (1 + vbVAT/100))::TFloat
                       END AS PriceWithVAT

                     , COALESCE(MIFloat_PriceSale.ValueData,0)::TFloat        AS PriceSale
                     , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
                     , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_PriceSale.ValueData)::NUMERIC (16, 2))::TFloat AS SummSale

                     , MovementItem.isErased
                     , ObjectString_Goods_Maker.ValueData  AS MakerName
                     , MIFloat_AmountManual.ValueData      AS AmountManual

                FROM tmpIsErased
                   INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.isErased   = tmpIsErased.isErased
                                    AND MovementItem.DescId     = zc_MI_Master()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                               ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                              AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                    ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

                   LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId 
                   LEFT JOIN ObjectString AS ObjectString_Code
                                          ON ObjectString_Code.ObjectId = Object_PartnerGoods.Id
                                         AND ObjectString_Code.DescId = zc_ObjectString_Goods_Code()
                   LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                          ON ObjectString_Goods_Maker.ObjectId = Object_PartnerGoods.Id
                                         AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                               ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
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
                     , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) :: TDateTime AS ExpirationDate
                     , COALESCE(MIString_PartionGoods.ValueData, '')              :: TVarChar  AS PartionGoods
                     ,MovementItem.MakerName
                     , MIString_FEA.ValueData             AS FEA
                     , MIString_Measure.ValueData         AS Measure
              , DublePrice.DublePriceColour
                     , MIString_SertificatNumber.ValueData AS SertificatNumber
                     , MIDate_SertificatStart.ValueData    AS SertificatStart
                     , MIDate_SertificatEnd.ValueData      AS SertificatEnd
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
              , MILinkObject_ReasonDifferences.ObjectId    AS ReasonDifferencesId
              , Object_ReasonDifferences.ValueData         AS ReasonDifferencesName    
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
                     WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) < CURRENT_DATE + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                     WHEN MovementItem.GoodsId Is Null THEN zc_Color_Warning_Red()                -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     WHEN MovementItem.PartnerGoodsCode IS NULL THEN zc_Color_Warning_Navy()      -- перенесла результат WarningColor , т.к. две колонки с цветом фона быть не может
                     ELSE zc_Color_Black()
                END      AS Color_ExpirationDate                --vbAVGDateEnd

              , COALESCE (MIFloat_PrintCount.ValueData, 0)   ::TFloat      AS PrintCount
              , COALESCE (MIBoolean_Print.ValueData, TRUE) ::Boolean     AS isPrint

            FROM tmpMI AS MovementItem 
                                      
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
                LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId

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
 01.02.17         * немножко оптимизировала
 27.01.17         *
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
