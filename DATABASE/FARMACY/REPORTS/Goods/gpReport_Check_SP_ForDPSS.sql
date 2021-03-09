-- Function:  gpReport_Check_SP_ForDPSS()

DROP FUNCTION IF EXISTS gpReport_Check_SP_ForDPSS (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_SP_ForDPSS(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (NumLine             Integer
             , IntenalSPName       TVarChar
             , BrandSPName         TVarChar
             , Pack                TVarChar
             , KindOutSPName       TVarChar
             , CountSP             TFloat
             , Amount              TFloat
             , PriceSale           TFloat
             , PriceSP             TFloat
             , SummChangePercent   TFloat
             , PriceRetSP          TFloat
             , PriceWithVAT        TFloat
             , Markup              TFloat
             , OperDateIncome      TDateTime
             , FromId              Integer
             , FromName            TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartYear TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    vbStartYear := (SELECT DATE_TRUNC ('YEAR' ,inStartDate)) ::TDateTime;
    
    -- Таблицы
    CREATE TEMP TABLE tmpUnit (UnitId Integer, JuridicalId Integer) ON COMMIT DROP;
 
    INSERT INTO tmpUnit (UnitId, JuridicalId)
               SELECT OL_Unit_Juridical.ObjectId       AS UnitId
                    , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
               FROM ObjectLink AS OL_Unit_Juridical
               WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 AND OL_Unit_Juridical.ChildObjectId = inJuridicalId;

    -- Результат
    RETURN QUERY
          WITH
          -- выбираем товары спец. проекта (главные)
           --  Все Товары соц-проект (документ)
            tmpMI_GoodsSP AS (SELECT tmp.MovementItemId AS Id
                                   , tmp.GoodsId
                                   , tmp.OperDateStart
                                   , tmp.OperDateEnd
                                   , tmp.OperDate
                              FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= inStartDate, inEndDate:= inEndDate) AS tmp
                              )

          , tmpGoodsSP AS (SELECT DISTINCT MovementItem.GoodsId                         AS GoodsMainId
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
                           )

           -- связываем главные товары с товарами сети
        , tmpGoods AS (SELECT ObjectLink_Child.ChildObjectId AS GoodsId
                            , tmpGoodsSP.GoodsMainId
                       FROM (SELECT DISTINCT tmpGoodsSP.GoodsMainId FROM tmpGoodsSP) AS tmpGoodsSP
                            INNER JOIN ObjectLink AS ObjectLink_Main
                                                  ON ObjectLink_Main.ChildObjectId = tmpGoodsSP.GoodsMainId
                                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                            INNER JOIN ObjectLink AS ObjectLink_Child 
                                                  ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 AND COALESCE (ObjectLink_Child.ChildObjectId,0)<>0
                       )

      -- выбираем продажи по товарам соц.проекта
        , tmpMI AS (SELECT MIC.MovementId                                            AS MovementId 
                         , MIC.MovementItemId                                        AS MovementItemId 
                         , MIC.ContainerId                                           AS ContainerId 
                         , MIC.OperDate
                         , tmpUnit.JuridicalId
                         , tmpGoods.GoodsId                                          AS GoodsId
                         , tmpGoods.GoodsMainId                                      AS GoodsMainId
                         , -1.0 * MIC.Amount                                         AS Amount
                    FROM MovementItemContainer AS MIC
                    
                         INNER JOIN tmpGoods ON MIC.ObjectId_Analyzer = tmpGoods.GoodsId
                              
                         INNER JOIN tmpUnit ON WhereObjectId_Analyzer = tmpUnit.UnitId
                                   
                         INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                       ON MovementLinkObject_SPKind.MovementId = MIC.MovementId
                                                      AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                      AND MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_SP()
                    WHERE MIC.MovementDescId = zc_Movement_Check()
                      AND MIC.DescId = zc_MIContainer_Count()
                      AND MIC.OperDate >= inStartDate AND MIC.OperDate < inEndDate + INTERVAL '1 DAY'   
                    )
        , tmpContainerIncome AS (SELECT Container.ContainerId
                                      , MIF_PriceWithVAT.ValueData        AS PriceWithVAT
                                      , MovementLinkObject_From.ObjectId  AS FromId
                                      , Movement_Income.OperDate
                                 FROM (SELECT DISTINCT tmpMI.ContainerId FROM tmpMI) AS Container
                                      LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                    ON ContainerLinkObject_MovementItem.Containerid = Container.ContainerId
                                                                   AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                      LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                      -- элемент прихода
                                      LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                      -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                      LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                  ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                 AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                      -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                      LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                      
                                      LEFT JOIN MovementItemFloat AS MIF_PriceWithVAT
                                                                  ON MIF_PriceWithVAT.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)
                                                                 AND MIF_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                      LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id  = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 )
        , tmpData AS (SELECT tmpMI.GoodsId                                          AS GoodsId
                           , tmpMI.GoodsMainId                                      AS GoodsMainId
                           , Sum(tmpMI.Amount)                                      AS Amount
                           , MIFloat_Price.ValueData                                AS Price
                           , MIFloat_PriceSale.ValueData                            AS PriceSale
                           , Sum(MIFloat_SummChangePercent.ValueData * 
                             tmpMI.Amount / MovementItem.Amount)                    AS SummChangePercent
                           , tmpContainerIncome.PriceWithVAT                        AS PriceWithVAT
                           , tmpContainerIncome.OperDate                            AS OperDateIncome
                           , tmpContainerIncome.FromId                              AS FromId
                           , tmpGoodsSP.IntenalSPName
                           , tmpGoodsSP.BrandSPName
                           , tmpGoodsSP.Pack
                           , tmpGoodsSP.KindOutSPName
                           , tmpGoodsSP.CountSP
                           , tmpGoodsSP.PriceSP                           
                           , tmpGoodsSP.PriceRetSP                        
                      FROM tmpMI
                      
                           LEFT JOIN MovementItem AS MovementItem ON MovementItem.ID = tmpMI.MovementItemId

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = tmpMI.MovementItemId
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                       ON MIFloat_SummChangePercent.MovementItemId = tmpMI.MovementItemId
                                                      AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                                                      
                           LEFT JOIN tmpContainerIncome ON tmpContainerIncome.ContainerId = tmpMI.ContainerId
                           
                           LEFT JOIN tmpGoodsSP AS tmpGoodsSP 
                                                ON tmpGoodsSP.GoodsMainId = tmpMI.GoodsMainId
                                               AND DATE_TRUNC('DAY', tmpMI.OperDate ::TDateTime) >= tmpGoodsSP.OperDateStart
                                               AND DATE_TRUNC('DAY', tmpMI.OperDate ::TDateTime) <= tmpGoodsSP.OperDateEnd
                      GROUP BY tmpMI.GoodsId
                             , tmpMI.GoodsMainId
                             , MIFloat_Price.ValueData
                             , MIFloat_PriceSale.ValueData
                             , tmpContainerIncome.PriceWithVAT
                             , tmpContainerIncome.OperDate
                             , tmpContainerIncome.FromId
                             , tmpGoodsSP.IntenalSPName
                             , tmpGoodsSP.BrandSPName
                             , tmpGoodsSP.Pack
                             , tmpGoodsSP.KindOutSPName
                             , tmpGoodsSP.CountSP
                             , tmpGoodsSP.PriceSP                           
                             , tmpGoodsSP.PriceRetSP   
                      )

        -- результат
        SELECT (ROW_NUMBER()OVER(ORDER BY tmpData.IntenalSPName
                                       , tmpData.PriceSale  
                                       , tmpData.PriceSP                           
                                       , tmpData.PriceRetSP                        
                                       , tmpData.PriceWithVAT
                                       , tmpData.OperDateIncome
                                       , tmpData.FromId))::Integer as Id
             , tmpData.IntenalSPName
             , tmpData.BrandSPName
             , tmpData.Pack
             , tmpData.KindOutSPName
             , tmpData.CountSP
             , tmpData.Amount::TFloat
             , tmpData.PriceSale
             , tmpData.PriceSP        
             , tmpData.SummChangePercent::TFloat
             , tmpData.PriceRetSP                        
             , tmpData.PriceWithVAT
             , ((tmpData.PriceSale - tmpData.PriceWithVAT) / tmpData.PriceWithVAT * 100)::TFloat
             , tmpData.OperDateIncome
             , tmpData.FromId
             , Object_From.ValueData
        FROM tmpData
        
             LEFT JOIN Object AS Object_From ON Object_From.ID = tmpData.FromId
        ORDER BY tmpData.IntenalSPName
               , tmpData.PriceSale  
               , tmpData.PriceSP                           
               , tmpData.PriceRetSP                        
               , tmpData.PriceWithVAT
               , tmpData.OperDateIncome
               , tmpData.FromId   
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.03.21                                                       *
*/

-- тест
-- 
select * from gpReport_Check_SP_ForDPSS(inStartDate := ('01.02.2021')::TDateTime , inEndDate := ('28.02.2021')::TDateTime , inJuridicalId := 2886776 , inSession := '3');