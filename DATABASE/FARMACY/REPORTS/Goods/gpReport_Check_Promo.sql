-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_Check_Promo (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_Promo(
    IN inStartDate     TDateTime ,
    IN inEndDate       TDateTime ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    PlanDate          TDateTime,  --Месяц плана
    UnitName          TVarChar,   --подразделение
    TotalAmount       TFloat,     --итого продажа шт
    TotalSumma        TFloat,     --итого продажа грн
    AmountPromo       TFloat,     --продажа Промо шт
    SummaPromo        TFloat,     --продажа Промо грн
    Amount            TFloat,     --продажа Промо шт
    Summa             TFloat,     --продажа Промо грн
    PercentPromo      TFloat     --% ПРомо от всех продаж
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    --inStartDate := date_trunc('month', inStartDate);
    --inEndDate := date_trunc('month', inEndDate) + Interval '1 MONTH';
    inEndDate := inEndDate + interval '1  day';
        
    RETURN QUERY
      WITH
      -- все документы Промо и товары, нач./ конечн. даты действия 
      tmpGoods_Promo_Main AS (SELECT MI_Goods.ObjectId 
                              , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                              , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                              FROM Movement
                                  INNER JOIN MovementDate AS MovementDate_StartPromo
                                                          ON MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                         AND MovementDate_StartPromo.MovementId = Movement.Id
                                  INNER JOIN MovementDate AS MovementDate_EndPromo
                                                          ON MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                         AND MovementDate_EndPromo.MovementId = Movement.Id
                                                  
                                  INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                     AND MI_Goods.DescId = zc_MI_Master()
                                                                     AND MI_Goods.isErased = FALSE
                             WHERE Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.DescId = zc_Movement_Promo()
                            ) 

      -- товары сети
      , tmpGoods_Promo AS (SELECT ObjectLink_Child_R.ChildObjectId   AS GoodsId        -- здесь товар
                                , tmpGoods_Promo_Main.StartDate_Promo
                                , tmpGoods_Promo_Main.EndDate_Promo
                           FROM tmpGoods_Promo_Main
                              INNER JOIN ObjectLink AS ObjectLink_Child
                                                    ON ObjectLink_Child.ChildObjectId = tmpGoods_Promo_Main.ObjectId 
                                                   AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                        AND ObjectLink_Main_R.DescId     = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                         AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                           )
            -- товары промо
           , tmpGoods AS (SELECT DISTINCT tmpGoods_Promo.GoodsId FROM tmpGoods_Promo)

 
           -- выбираем все чеки за выбранный период
           ,  tmpMov AS (SELECT Movement_Check.Id
                              , date_trunc('month', Movement_Check.OperDate)::TDateTime AS PlanDate
                              , MovementLinkObject_Unit.ObjectId    AS UnitId
                         FROM Movement AS Movement_Check
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate-- + INTERVAL '1 DAY'
                         --  AND Movement_Check.OperDate >= '03.10.2016' AND Movement_Check.OperDate < '01.11.2016'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         )


         ,   tmpMI_1 AS (SELECT MIContainer.ContainerId
                              , MIContainer.MovementItemId
                              , Movement_Check.PlanDate
                              , Movement_Check.UnitId
                              , MIContainer.ObjectId_Analyzer   AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                         FROM tmpMov AS Movement_Check
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementId = Movement_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count()
                         GROUP BY MIContainer.ContainerId
                              , MIContainer.MovementItemId
                              , Movement_Check.PlanDate
                              , Movement_Check.UnitId
                              , MIContainer.ObjectId_Analyzer 
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                        )

           ,   tmpMI AS (SELECT tmpMI_1.ContainerId
                              , tmpMI_1.PlanDate
                              , tmpMI_1.UnitId
                              , tmpMI_1.GoodsId
                              , SUM (COALESCE (tmpMI_1.Amount, 0)) AS Amount
                              , SUM (COALESCE (tmpMI_1.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM tmpMI_1 
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = tmpMI_1.MovementItemId
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         GROUP BY tmpMI_1.ContainerId
                                , tmpMI_1.PlanDate
                                , tmpMI_1.UnitId
                                , tmpMI_1.GoodsId
                        )

       -- таблица всех продаж 
       , tmpMI_All AS (SELECT tmpMI.PlanDate
                            , tmpMI.UnitId
                            , SUM (tmpMI.Amount)    AS  Amount
                            , SUM (tmpMI.SummaSale) AS SummaSale
                         FROM tmpMI
                         GROUP BY tmpMI.PlanDate
                                , tmpMI.UnitId
                         )  

       --попробую выбрать товары промо и только по ним делать связь с партиями
       , tmpMI_Promo AS (SELECT tmpMI.ContainerId
                              , tmpMI.PlanDate
                              , tmpMI.UnitId
                              , tmpMI.GoodsId
                              , tmpMI.Amount
                              , tmpMI.SummaSale
                         FROM tmpMI
                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpMI.GoodsId
                         )

         -- tmpData_01/tmpData_02/tmpData_03  получаем связь с партиями
        , tmpData_01 AS (SELECT tmpMI.PlanDate
                              , tmpMI.UnitId
                              , CLO.ObjectId AS CLO_MI_ObjectId
                              , tmpMI.GoodsId
                              , SUM (tmpMI.Amount)    AS  Amount
                              , SUM (tmpMI.SummaSale) AS SummaSale
                         FROM ContainerlinkObject AS CLO
                            INNER JOIN tmpMI_Promo AS tmpMI ON CLO.Containerid = tmpMI.ContainerId
                         WHERE CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                         GROUP BY  tmpMI.PlanDate
                                 , tmpMI.UnitId
                                 , CLO.ObjectId
                                 , tmpMI.GoodsId
                 )

        , tmpData_02 AS (SELECT tmpMI.PlanDate
                              , tmpMI.UnitId
                              , Object_PartionMovementItem.ObjectCode :: Integer  AS OPMI_ObjectCode
                              , tmpMI.GoodsId
                              , SUM (tmpMI.Amount)    AS  Amount
                              , SUM (tmpMI.SummaSale) AS SummaSale
                         FROM tmpData_01 AS tmpMI
                              LEFT JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = tmpMI.CLO_MI_ObjectId
                         GROUP BY tmpMI.PlanDate
                              , tmpMI.UnitId
                              , Object_PartionMovementItem.ObjectCode 
                              , tmpMI.GoodsId
                         )

        , tmpData_03 AS (SELECT tmpMI.PlanDate
                              , tmpMI.UnitId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId_Income
                              , tmpMI.GoodsId
                              , tmpMI.Amount
                              , tmpMI.SummaSale
                         FROM tmpData_02 AS tmpMI
                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpMI.OPMI_ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                         )

       -- здесь віделяем кол-во/сумму продажи товаров маркетингового контракта
     , tmpData_Promo AS (SELECT tmp.PlanDate
                              , tmp.UnitId
                              , SUM (tmp.Amount)    AS AmountPromo
                              , SUM (tmp.SummaSale) AS SummaPromo
                         FROM tmpData_03 AS tmp
                              INNER JOIN Movement AS Movement_Income ON Movement_Income.Id = tmp.MovementId
                                                    
                              INNER JOIN tmpGoods_Promo ON tmpGoods_Promo.GoodsId = tmp.GoodsId
                                                       AND tmpGoods_Promo.StartDate_Promo <= Movement_Income.OperDate
                                                       AND tmpGoods_Promo.EndDate_Promo   >= Movement_Income.OperDate
                         GROUP BY tmp.PlanDate
                                , tmp.UnitId
                         ) 

           -- объединяем данные всех продаж с промо продажей
           , tmpData AS (SELECT tmp.PlanDate
                              , tmp.UnitId
                              , SUM (tmp.Amount)                AS TotalAmount
                              , SUM (tmp.SummaSale)             AS TotalSumma
                              , SUM (tmpData_Promo.AmountPromo) AS AmountPromo
                              , SUM (tmpData_Promo.SummaPromo)  AS SummaPromo
                         FROM tmpMI_All AS tmp
                              LEFT JOIN tmpData_Promo ON tmpData_Promo.PlanDate = tmp.PlanDate
                                                     AND tmpData_Promo.UnitId   = tmp.UnitId
                         GROUP BY tmp.PlanDate
                                , tmp.UnitId
                        )

         -- результат
         SELECT tmpData.PlanDate
              , Object_Unit.ValueData      AS UnitName
              , tmpData.TotalAmount        :: TFloat
              , tmpData.TotalSumma         :: TFloat
              , tmpData.AmountPromo        :: TFloat
              , tmpData.SummaPromo         :: TFloat
              , (tmpData.TotalAmount - tmpData.AmountPromo)     :: TFloat AS Amount
              , (tmpData.TotalSumma - tmpData.SummaPromo)       :: TFloat AS SummaSale
              , (tmpData.SummaPromo * 100 / tmpData.TotalSumma) :: TFloat AS PercentPromo
          FROM tmpData
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 12.12.16         *
*/

-- тест
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.11.2016', inEndDate:= '08.11.2016', inSession:= '2')
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.05.2016', inEndDate:= '08.05.2016', inSession:= '2')
--select * from gpReport_Check_Promo( inStartDate := ('02.11.2016')::TDateTime , inEndDate := ('02.12.2016')::TDateTime ,  inSession := '3');