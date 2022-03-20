-- Function: gpReport_PaperRecipeSPInsulin()

DROP FUNCTION IF EXISTS gpReport_PaperRecipeSPInsulin (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PaperRecipeSPInsulin(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , BrandSPName TVarChar, MakerSP TVarChar, KindOutSPName TVarChar, Pack TVarChar, CountSP TFloat, PriceSP TFloat
             , CountSPMin TFloat, PriceSPMin TFloat
             , Price TFloat, Amount TFloat, Summa TFloat
             , SummsSP TFloat, SummChangePercent TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbAmountSale TFloat;
  DECLARE vbAmountIn TFloat;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
    -- Результат
    RETURN QUERY
    WITH 
        tmpMI_GoodsSP AS (SELECT tmp.MovementItemId AS Id
                               , tmp.GoodsId
                               , tmp.OperDateStart
                               , tmp.OperDateEnd
                               , tmp.OperDate
                               , tmp.MedicalProgramSPId
                          FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= inStartDate, inEndDate:= inEndDate, inMedicalProgramSPId := 0, inGroupMedicalProgramSPId := 0) AS tmp
                          ),
         tmpGoodsSP AS (SELECT DISTINCT MovementItem.GoodsId                        AS GoodsMainId
                            , MovementItem.MedicalProgramSPId                       AS MedicalProgramSPId
                            , MovementItem.OperDateStart                            AS OperDateStart
                            , MovementItem.OperDateEnd                              AS OperDateEnd
                            , MovementItem.OperDate                                 AS InsertDateSP
                            , COALESCE(Object_IntenalSP.Id ,0)           ::Integer  AS IntenalSPId
                            , COALESCE(Object_IntenalSP.ValueData,'')    ::TVarChar AS IntenalSPName
                            , COALESCE(Object_BrandSP.Id ,0)             ::Integer  AS BrandSPId
                            , COALESCE(Object_BrandSP.ValueData,'')      ::TVarChar AS BrandSPName
                            , COALESCE(Object_KindOutSP.Id ,0)           ::Integer  AS KindOutSPId
                            , COALESCE(Object_KindOutSP.ValueData,'')    ::TVarChar AS KindOutSPName
                            , MIFloat_PriceSP.ValueData                             AS PriceSP
                            , MIFloat_CountSP.ValueData                             AS CountSP
                            , MIFloat_GroupSP.ValueData                             AS GroupSP
                            , MIFloat_CountSPMin.ValueData                          AS CountSPMin
                            , MIString_Pack.ValueData                               AS Pack
                            , MIString_CodeATX.ValueData                            AS CodeATX
                            , MIString_MakerSP.ValueData                            AS MakerSP
                            , MIString_ReestrSP.ValueData                           AS ReestrSP
                            , MIString_ReestrDateSP.ValueData                       AS ReestrDateSP
                            , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
                            , MIFloat_PriceRetSP.ValueData                          AS PriceRetSP
                            , MIFloat_DailyNormSP.ValueData                         AS DailyNormSP
                            , MIFloat_DailyCompensationSP.ValueData                 AS DailyCompensationSP
                            , MIFloat_PaymentSP.ValueData                           AS PaymentSP
                            , MIFloat_ColSP.ValueData                               AS ColSP
                       FROM tmpMI_GoodsSP AS MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_ColSP
                                                        ON MIFloat_ColSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ColSP.DescId = zc_MIFloat_ColSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                        ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                        ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                        ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()  
                            LEFT JOIN MovementItemFloat AS MIFloat_DailyNormSP
                                                        ON MIFloat_DailyNormSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_DailyNormSP.DescId = zc_MIFloat_DailyNormSP() 
                            LEFT JOIN MovementItemFloat AS MIFloat_DailyCompensationSP
                                                        ON MIFloat_DailyCompensationSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_DailyCompensationSP.DescId = zc_MIFloat_DailyCompensationSP() 
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                        ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                        ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_GroupSP
                                                        ON MIFloat_GroupSP.MovementItemId = MovementItem.Id
                                                       AND MIFloat_GroupSP.DescId = zc_MIFloat_GroupSP()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountSPMin
                                                        ON MIFloat_CountSPMin.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountSPMin.DescId = zc_MIFloat_CountSPMin()
                            LEFT JOIN MovementItemString AS MIString_Pack
                                                         ON MIString_Pack.MovementItemId = MovementItem.Id
                                                        AND MIString_Pack.DescId = zc_MIString_Pack()
                            LEFT JOIN MovementItemString AS MIString_CodeATX
                                                         ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                                        AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
                            LEFT JOIN MovementItemString AS MIString_MakerSP
                                                         ON MIString_MakerSP.MovementItemId = MovementItem.Id
                                                        AND MIString_MakerSP.DescId = zc_MIString_MakerSP()
                            LEFT JOIN MovementItemString AS MIString_ReestrSP
                                                         ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                                        AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()
                            LEFT JOIN MovementItemString AS MIString_ReestrDateSP
                                                         ON MIString_ReestrDateSP.MovementItemId = MovementItem.Id
                                                        AND MIString_ReestrDateSP.DescId = zc_MIString_ReestrDateSP()
                            LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                             ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                            AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId 
                            LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                                             ON MI_BrandSP.MovementItemId = MovementItem.Id
                                                            AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
                            LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 
                            LEFT JOIN MovementItemLinkObject AS MI_KindOutSP
                                                             ON MI_KindOutSP.MovementItemId = MovementItem.Id
                                                            AND MI_KindOutSP.DescId = zc_MILinkObject_KindOutSP()
                            LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = MI_KindOutSP.ObjectId
                       ), 
        tmpMovement AS (SELECT Movement_Check.*
                             , MovementLinkObject_SPKind.ObjectId                 AS SPKindId
                             , Object_SPKind.ValueData                            AS SPKindName
                             , MovementLinkObject_MedicalProgramSP.ObjectId       AS MedicalProgramSPId
                             , Object_MedicalProgramSP.ValueData                  AS MedicalProgramSPName
                        FROM Movement AS Movement_Check
                             INNER JOIN MovementBoolean AS MovementBoolean_PaperRecipeSP
                                                        ON MovementBoolean_PaperRecipeSP.MovementId = Movement_Check.Id
                                                       AND MovementBoolean_PaperRecipeSP.DescId = zc_MovementBoolean_PaperRecipeSP()
                                                       AND MovementBoolean_PaperRecipeSP.ValueData = TRUE
                                                       
                             INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                           ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                             LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

                             INNER JOIN MovementLinkObject AS MovementLinkObject_MedicalProgramSP
                                                           ON MovementLinkObject_MedicalProgramSP.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                             LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = MovementLinkObject_MedicalProgramSP.ObjectId
                             
                        WHERE Movement_Check.DescId = zc_Movement_Check()
                          AND Movement_Check.StatusId = zc_Enum_Status_Complete() 
                          AND Movement_Check.OperDate >= inStartDate
                          AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY' 
                          AND  MovementLinkObject_MedicalProgramSP.ObjectId IN (18078185, 18078194, 18078210, 18078197, 18078175)
                        ),
        tmpMI_All AS (SELECT Movement.*
                           , MovementItem.Id        AS MovementItemId
                           , MovementItem.ObjectId  AS GoodsId
                           , COALESCE(MovementItem.Amount, - MovementItemContainer.Amount)::TFloat AS Amount
                           , COALESCE (MIFloat_SummChangePercent.ValueData * MovementItem.Amount /
                             COALESCE(MovementItem.Amount, - MovementItemContainer.Amount), 0)::TFloat             AS SummChangePercent
                           , COALESCE (MIFloat_PriceSale.ValueData, 0)::TFloat                     AS PriceSale
                           , COALESCE (MIFloat_Price.ValueData, 0)::TFloat                         AS Price
                           , MovementItemContainer.ContainerId
                      FROM tmpMovement AS Movement
                       
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.Amount <> 0
                                                  AND MovementItem.isErased = FALSE    
                                                  
                           INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                           AND MovementItemContainer.MovementItemId = MovementItem.Id
                                                           AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                  
                           --Сумма Скидки
                           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                       ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                      AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     ),
        tmpMI AS (SELECT tmpMI.*
                       /*, COALESCE (MI_Income_find.Id, MI_Income.Id) AS MI_IncomeId
                       , COALESCE (MI_Income_find.Id, MI_Income.Id) AS MI_IncomeId*/
                  FROM tmpMI_All AS tmpMI
                  
/*                       LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                     ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                       -- элемент прихода
                       LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                       -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                   ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                       -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                       LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)*/
                 )

  SELECT tmpMI.Id
       , tmpMI.InvNumber 
       , tmpMI.OperDate
       , Object_Unit.ObjectCode          AS UnitCode
       , Object_Unit.ValueData           AS UnitName 
       , Object_Goods_Main.ObjectCode    AS GoodsCode
       , Object_Goods_Main.Name          AS GoodsName
       
       , tmpGoodsSP.BrandSPName
       , tmpGoodsSP.MakerSP
       , tmpGoodsSP.KindOutSPName
       , tmpGoodsSP.Pack
       , tmpGoodsSP.CountSP
       , tmpGoodsSP.PriceSP
       , CASE WHEN COALESCE (tmpGoodsSP.CountSPMin, 0) = 0 THEN tmpGoodsSP.CountSP ELSE tmpGoodsSP.CountSPMin END :: TFloat 
       , (tmpGoodsSP.PriceSP * CASE WHEN COALESCE (tmpGoodsSP.CountSPMin, 0) = 0 THEN tmpGoodsSP.CountSP ELSE tmpGoodsSP.CountSPMin END / tmpGoodsSP.CountSP):: TFloat  AS PriceSPMin

       , tmpMI.Price
       , Round(tmpMI.Amount * tmpGoodsSP.CountSP / CASE WHEN COALESCE (tmpGoodsSP.CountSPMin, 0) = 0 THEN tmpGoodsSP.CountSP ELSE tmpGoodsSP.CountSPMin END, 2):: TFloat  AS Amount
       , Round(tmpMI.Price * tmpMI.Amount, 2):: TFloat
       
       , Round(tmpGoodsSP.PriceSP * tmpMI.Amount, 2):: TFloat AS SummsSP
       , tmpMI.SummChangePercent
             
             
  FROM tmpMI

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = tmpMI.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
       
       INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpMI.GoodsId
       INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

       LEFT JOIN tmpGoodsSP AS tmpGoodsSP 
                            ON tmpGoodsSP.GoodsMainId = Object_Goods_Main.Id
                           AND DATE_TRUNC('DAY', tmpMI.OperDate ::TDateTime) >= tmpGoodsSP.OperDateStart
                           AND DATE_TRUNC('DAY', tmpMI.OperDate ::TDateTime) <= tmpGoodsSP.OperDateEnd
                           AND tmpGoodsSP.MedicalProgramSPId = tmpMI.MedicalProgramSPId
                           
  ORDER BY tmpMI.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_PaperRecipeSP (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
-- 
select * from gpReport_PaperRecipeSPInsulin(inStartDate := ('01.03.2022')::TDateTime , inEndDate := ('31.03.2022')::TDateTime ,  inSession := '3');