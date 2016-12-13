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

    inStartDate := date_trunc('month', inStartDate);
    inEndDate := date_trunc('month', inEndDate) + Interval '1 MONTH';
 
        
    RETURN QUERY
   WITH
    -- все документы Промо и товары , нач./ конечн. даты действия 
    tmpGoods_Promo AS (SELECT MI_Goods.ObjectId                    AS GoodsId_MI     -- здесь товар "сети"
                              , ObjectLink_Child_R.ChildObjectId   AS GoodsId        -- здесь товар
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
                               -- !!!
                              INNER JOIN ObjectLink AS ObjectLink_Child
                                                    ON ObjectLink_Child.ChildObjectId = MI_Goods.ObjectId 
                                                   AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                        AND ObjectLink_Main_R.DescId     = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                         AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                         WHERE Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_Promo()
                        ) 
 
           -- выбираем все чеки с товарами маркетингового контракта
           ,   tmpMI AS (SELECT MIContainer.ContainerId
                              , date_trunc('month', Movement_Check.OperDate)::TDateTime AS PlanDate
                              , MovementLinkObject_Unit.ObjectId    AS UnitId
                              , MI_Check.ObjectId                   AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE

                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MI_Check.ObjectId
                                , MovementLinkObject_Unit.ObjectId
                                , MIContainer.ContainerId
                                , date_trunc('month', Movement_Check.OperDate)
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                         )
         -- tmpData_01/tmpData_02/tmpData_03  получаем связь с партиями
        , tmpData_01 AS (SELECT tmpMI.PlanDate
                              , tmpMI.UnitId
                              , CLO.ObjectId AS CLO_MI_ObjectId
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM ContainerlinkObject AS CLO
                            INNER JOIN tmpMI ON CLO.Containerid = tmpMI.ContainerId
                         WHERE CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                 )
  
        , tmpData_02 AS (SELECT tmpMI.PlanDate
                              , tmpMI.UnitId
                              , Object_PartionMovementItem.ObjectCode :: Integer  AS OPMI_ObjectCode
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM tmpData_01 AS tmpMI
                              LEFT JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = tmpMI.CLO_MI_ObjectId
                         )

        , tmpData_03 AS (SELECT tmpMI.PlanDate
                              , tmpMI.UnitId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId_Income
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
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

       -- здесь ограничиваем товарами маркетингового контракта
       , tmpData AS (SELECT tmp.PlanDate
                              , tmp.UnitId
                              , SUM (tmp.Amount)      AS TotalAmount
                              , SUM (tmp.SummaSale)   AS TotalSumma
                              , SUM (CASE WHEN COALESCE (tmpGoods_Promo.GoodsId,0) <> 0 THEN tmp.Amount ELSE 0 END)    AS AmountPromo
                              , SUM (CASE WHEN COALESCE (tmpGoods_Promo.GoodsId,0) <> 0 THEN tmp.SummaSale ELSE 0 END) AS SummaPromo
                         FROM tmpData_03 AS tmp
                              INNER JOIN Movement AS Movement_Income ON Movement_Income.Id = tmp.MovementId
                                                    
                              LEFT JOIN tmpGoods_Promo ON tmpGoods_Promo.GoodsId = tmp.GoodsId
                                                      AND tmpGoods_Promo.StartDate_Promo <= Movement_Income.OperDate
                                                      AND tmpGoods_Promo.EndDate_Promo   >= Movement_Income.OperDate
                         GROUP BY tmp.PlanDate
                                , tmp.UnitId
                         ) 

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
 23.11.16         *
 08.11.16         *
*/

-- тест
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.11.2016', inEndDate:= '08.11.2016', inSession:= '2')
--SELECT * FROM gpReport_Check_Promo (inMakerId:= 2336604  , inStartDate:= '08.05.2016', inEndDate:= '08.05.2016', inSession:= '2')
--select * from gpReport_Check_Promo( inStartDate := ('02.11.2016')::TDateTime , inEndDate := ('02.11.2016')::TDateTime ,  inSession := '3');