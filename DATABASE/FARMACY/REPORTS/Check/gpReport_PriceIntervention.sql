-- Function:  gpReport_PriceIntervention()


DROP FUNCTION IF EXISTS gpReport_PriceIntervention (TDateTime, TDateTime, TFloat,TFloat, TFloat,TFloat, TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_PriceIntervention (TDateTime, TDateTime, TFloat,TFloat, TFloat,TFloat, TFloat,TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_PriceIntervention(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inPrice1           TFloat ,
    IN inPrice2           TFloat ,
    IN inPrice3           TFloat ,
    IN inPrice4           TFloat ,
    IN inPrice5           TFloat ,
    IN inPrice6           TFloat ,
    IN inMarginReportId   Integer,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  JuridicalMainCode  Integer, 
  JuridicalMainName  TVarChar,
  UnitId             Integer, 
  UnitCode           Integer, 
  UnitName           TVarChar,

  Amount            TFloat,
  Summa             TFloat,
  SummaSale         TFloat,
  
  Amount1            TFloat,
  Summa1             TFloat,
  SummaSale1         TFloat,
  PercentAmount1            TFloat,
  PercentSumma1             TFloat,
  PercentSummaSale1         TFloat,
  
  Amount2            TFloat,
  Summa2             TFloat,
  SummaSale2         TFloat,
  PercentAmount2            TFloat,
  PercentSumma2             TFloat,
  PercentSummaSale2         TFloat,
  
  Amount3            TFloat,
  Summa3             TFloat,
  SummaSale3         TFloat,
  PercentAmount3            TFloat,
  PercentSumma3             TFloat,
  PercentSummaSale3         TFloat,
  
  Amount4            TFloat,
  Summa4             TFloat,
  SummaSale4         TFloat,
  PercentAmount4            TFloat,
  PercentSumma4             TFloat,
  PercentSummaSale4         TFloat,
  
  Amount5            TFloat,
  Summa5             TFloat,
  SummaSale5         TFloat,
  PercentAmount5            TFloat,
  PercentSumma5             TFloat,
  PercentSummaSale5         TFloat,

  Amount6            TFloat,
  Summa6             TFloat,
  SummaSale6         TFloat,
  PercentAmount6            TFloat,
  PercentSumma6             TFloat,
  PercentSummaSale6         TFloat,

  Amount7            TFloat,
  Summa7             TFloat,
  SummaSale7         TFloat,
  PercentAmount7            TFloat,
  PercentSumma7             TFloat,
  PercentSummaSale7         TFloat,

  SummaProfit       TFloat,
  SummaProfit1      TFloat,
  SummaProfit2      TFloat,
  SummaProfit3      TFloat,
  SummaProfit4      TFloat,
  SummaProfit5      TFloat,
  SummaProfit6      TFloat,
  SummaProfit7      TFloat,

  PercentProfit       TFloat,
  PercentProfit1      TFloat,
  PercentProfit2      TFloat,
  PercentProfit3      TFloat,
  PercentProfit4      TFloat,
  PercentProfit5      TFloat,
  PercentProfit6      TFloat,
  PercentProfit7      TFloat,

  VirtPercent         TFloat,
  VirtPercent1        TFloat,
  VirtPercent2        TFloat,
  VirtPercent3        TFloat,
  VirtPercent4        TFloat,
  VirtPercent5        TFloat,
  VirtPercent6        TFloat,
  VirtPercent7        TFloat,

  VirtSummaSale       TFloat,
  VirtSummaSale1      TFloat,
  VirtSummaSale2      TFloat,
  VirtSummaSale3      TFloat,
  VirtSummaSale4      TFloat,
  VirtSummaSale5      TFloat,
  VirtSummaSale6      TFloat,
  VirtSummaSale7      TFloat,
           
  VirtProfit       TFloat,
  VirtProfit1      TFloat,
  VirtProfit2      TFloat,
  VirtProfit3      TFloat,
  VirtProfit4      TFloat,
  VirtProfit5      TFloat,
  VirtProfit6      TFloat,
  VirtProfit7      TFloat,

  MarginPercent1  TFloat, 
  MarginPercent2  TFloat, 
  MarginPercent3  TFloat, 
  MarginPercent4  TFloat, 
  MarginPercent5  TFloat, 
  MarginPercent6  TFloat, 
  MarginPercent7  TFloat, 

  MarginCategoryName  TVarChar,
  
  Color_Amount       Integer,
  Color_Summa        Integer,
  Color_SummaSale    Integer,

  Color_PercentAmount1            Integer,
  Color_PercentSumma1             Integer,
  Color_PercentSummaSale1         Integer,
  
  Color_PercentAmount2            Integer,
  Color_PercentSumma2             Integer,
  Color_PercentSummaSale2         Integer,
  
  Color_PercentAmount3            Integer,
  Color_PercentSumma3             Integer,
  Color_PercentSummaSale3         Integer,
  
  Color_PercentAmount4            Integer,
  Color_PercentSumma4             Integer,
  Color_PercentSummaSale4         Integer,
  
  Color_PercentAmount5            Integer,
  Color_PercentSumma5             Integer,
  Color_PercentSummaSale5         Integer,

  Color_PercentAmount6            Integer,
  Color_PercentSumma6             Integer,
  Color_PercentSummaSale6         Integer,

  Color_PercentAmount7            Integer,
  Color_PercentSumma7             Integer,
  Color_PercentSummaSale7         Integer
  
    
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
          
          WITH tmpMI AS (SELECT MIContainer.ContainerId
                              , MI_Check.ObjectId                  AS GoodsId
                              , MovementLinkObject_Unit.ObjectId   AS UnitId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           --AND MovementLinkObject_Unit.ObjectId = inUnitId
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
                                , MIContainer.ContainerId
                                , MovementLinkObject_Unit.ObjectId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )
       , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                              , MI_Income_find.MovementId AS MovementId_find
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , tmpMI.GoodsId
                              , tmpMI.UnitId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM tmpMI
                              -- нашли партию
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
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
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                        )
           , tmpData AS (SELECT MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income  -- ПОСТАВЩИК
                              , tmpData_all.UnitId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              --, SUM (tmpData_all.Amount * COALESCE (MIFloat_Income_Price.ValueData,    0)) AS Summa_original
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice1 THEN tmpData_all.Amount ELSE 0 END ) AS Amount1
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice1 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale1
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice1 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa1
                              
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice2 THEN tmpData_all.Amount ELSE 0 END ) AS Amount2
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice2 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale2
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice2 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa2

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice3 THEN tmpData_all.Amount ELSE 0 END ) AS Amount3
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice3 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale3
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice3 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa3

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice4 THEN tmpData_all.Amount ELSE 0 END ) AS Amount4
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice4 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale4
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice4 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa4

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice5 THEN tmpData_all.Amount ELSE 0 END ) AS Amount5
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice5 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale5
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice5 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa5

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice6 THEN tmpData_all.Amount ELSE 0 END ) AS Amount6
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice6 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale6
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<inPrice6 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa6

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice6 THEN tmpData_all.Amount ELSE 0 END ) AS Amount7
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice6 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale7
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>=inPrice6 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa7
                         FROM tmpData_all
                              -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- цена "оригинал", для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 

                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                          
                         GROUP BY MovementLinkObject_From_Income.ObjectId
                                , tmpData_all.UnitId
                        )
      
, tmpDataAll AS (SELECT tmpData.UnitId
                      , (tmpData.Amount)      AS Amount
                      , (tmpData.Summa)       AS Summa
                      , (tmpData.SummaSale)   AS SummaSale

                      , (tmpData.Amount1)      AS Amount1
                      , (tmpData.Summa1)       AS Summa1
                      , (tmpData.SummaSale1)   AS SummaSale1
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount1*100/tmpData.Amount) ElSE 0 END)           AS PercentAmount1
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa1*100/tmpData.Summa) ElSE 0 END)              AS PercentSumma1
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale1*100/tmpData.SummaSale) ElSE 0 END)  AS PercentSummaSale1
                      
                      , (tmpData.Amount2)      AS Amount2
                      , (tmpData.Summa2)       AS Summa2
                      , (tmpData.SummaSale2)   AS SummaSale2
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount2*100/tmpData.Amount) ElSE 0 END)           AS PercentAmount2
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa2*100/tmpData.Summa) ElSE 0 END)              AS PercentSumma2
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale2*100/tmpData.SummaSale) ElSE 0 END)  AS PercentSummaSale2
                      
                      , (tmpData.Amount3)      AS Amount3
                      , (tmpData.Summa3)       AS Summa3
                      , (tmpData.SummaSale3)   AS SummaSale3
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount3*100/tmpData.Amount) ElSE 0 END)           AS PercentAmount3
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa3*100/tmpData.Summa) ElSE 0 END)              AS PercentSumma3
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale3*100/tmpData.SummaSale) ElSE 0 END)  AS PercentSummaSale3
                      
                      , (tmpData.Amount4)      AS Amount4
                      , (tmpData.Summa4)       AS Summa4
                      , (tmpData.SummaSale4)   AS SummaSale4
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount4*100/tmpData.Amount) ElSE 0 END)           AS PercentAmount4
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa4*100/tmpData.Summa) ElSE 0 END)              AS PercentSumma4
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale4*100/tmpData.SummaSale) ElSE 0 END)  AS PercentSummaSale4
                      
                      , (tmpData.Amount5)      AS Amount5
                      , (tmpData.Summa5)       AS Summa5
                      , (tmpData.SummaSale5)   AS SummaSale5
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount5*100/tmpData.Amount) ElSE 0 END)           AS PercentAmount5
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa5*100/tmpData.Summa) ElSE 0 END)              AS PercentSumma5
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale5*100/tmpData.SummaSale) ElSE 0 END)  AS PercentSummaSale5
                      
                      , (tmpData.Amount6)      AS Amount6
                      , (tmpData.Summa6)       AS Summa6
                      , (tmpData.SummaSale6)   AS SummaSale6
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount6*100/tmpData.Amount) ElSE 0 END)           AS PercentAmount6
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa6*100/tmpData.Summa) ElSE 0 END)              AS PercentSumma6
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale6*100/tmpData.SummaSale) ElSE 0 END)  AS PercentSummaSale6
                      
                      , (tmpData.Amount7)      AS Amount7
                      , (tmpData.Summa7)       AS Summa7
                      , (tmpData.SummaSale7)   AS SummaSale7
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount7*100/tmpData.Amount) ElSE 0 END)           AS PercentAmount7
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa7*100/tmpData.Summa) ElSE 0 END)              AS PercentSumma7
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale7*100/tmpData.SummaSale) ElSE 0 END)  AS PercentSummaSale7
                 FROM (
                      SELECT tmpData.UnitId
                      , SUM(tmpData.Amount)      AS Amount
                      , SUM(tmpData.Summa)       AS Summa
                      , SUM(tmpData.SummaSale)   AS SummaSale

                      , SUM(tmpData.Amount1)      AS Amount1
                      , SUM(tmpData.Summa1)       AS Summa1
                      , SUM(tmpData.SummaSale1)   AS SummaSale1
                      
                      , SUM(tmpData.Amount2)      AS Amount2
                      , SUM(tmpData.Summa2)       AS Summa2
                      , SUM(tmpData.SummaSale2)   AS SummaSale2
                      
                      , SUM(tmpData.Amount3)      AS Amount3
                      , SUM(tmpData.Summa3)       AS Summa3
                      , SUM(tmpData.SummaSale3)   AS SummaSale3
                      
                      , SUM(tmpData.Amount4)      AS Amount4
                      , SUM(tmpData.Summa4)       AS Summa4
                      , SUM(tmpData.SummaSale4)   AS SummaSale4
                      
                      , SUM(tmpData.Amount5)      AS Amount5
                      , SUM(tmpData.Summa5)       AS Summa5
                      , SUM(tmpData.SummaSale5)   AS SummaSale5
                      
                      , SUM(tmpData.Amount6)      AS Amount6
                      , SUM(tmpData.Summa6)       AS Summa6
                      , SUM(tmpData.SummaSale6)   AS SummaSale6
                      
                      , SUM(tmpData.Amount7)      AS Amount7
                      , SUM(tmpData.Summa7)       AS Summa7
                      , SUM(tmpData.SummaSale7)   AS SummaSale7
                 FROM tmpData
                 GROUP BY tmpData.UnitId) AS tmpData
                 
                )
, tmpMaxPercent AS (SELECT MAX(tmpDataAll.PercentAmount1)    AS MaxPercentAmount1
                         , MAX(tmpDataAll.PercentSumma1)     AS MaxPercentSumma1
                         , MAX(tmpDataAll.PercentSummaSale1) AS MAxPercentSummaSale1

                         , MAX(tmpDataAll.PercentAmount2)    AS MaxPercentAmount2
                         , MAX(tmpDataAll.PercentSumma2)     AS MaxPercentSumma2
                         , MAX(tmpDataAll.PercentSummaSale2) AS MAxPercentSummaSale2

                         , MAX(tmpDataAll.PercentAmount3)    AS MaxPercentAmount3
                         , MAX(tmpDataAll.PercentSumma3)     AS MaxPercentSumma3
                         , MAX(tmpDataAll.PercentSummaSale3) AS MAxPercentSummaSale3

                         , MAX(tmpDataAll.PercentAmount4)    AS MaxPercentAmount4
                         , MAX(tmpDataAll.PercentSumma4)     AS MaxPercentSumma4
                         , MAX(tmpDataAll.PercentSummaSale4) AS MAxPercentSummaSale4

                         , MAX(tmpDataAll.PercentAmount5)    AS MaxPercentAmount5
                         , MAX(tmpDataAll.PercentSumma5)     AS MaxPercentSumma5
                         , MAX(tmpDataAll.PercentSummaSale5) AS MAxPercentSummaSale5

                         , MAX(tmpDataAll.PercentAmount6)    AS MaxPercentAmount6
                         , MAX(tmpDataAll.PercentSumma6)     AS MaxPercentSumma6
                         , MAX(tmpDataAll.PercentSummaSale6) AS MAxPercentSummaSale6

                         , MAX(tmpDataAll.PercentAmount7)    AS MaxPercentAmount7
                         , MAX(tmpDataAll.PercentSumma7)     AS MaxPercentSumma7
                         , MAX(tmpDataAll.PercentSummaSale7) AS MAxPercentSummaSale7                         
                    FROM tmpDataAll
                    )               

, tmpMarginReportItem AS (SELECT ObjectLink_Unit.ChildObjectId     AS UnitId
                               , ObjectFloat_Percent1.ValueData    AS Percent1 
                               , ObjectFloat_Percent2.ValueData    AS Percent2
                               , ObjectFloat_Percent3.ValueData    AS Percent3
                               , ObjectFloat_Percent4.ValueData    AS Percent4
                               , ObjectFloat_Percent5.ValueData    AS Percent5
                               , ObjectFloat_Percent6.ValueData    AS Percent6
                               , ObjectFloat_Percent7.ValueData    AS Percent7 
                          FROM ObjectLink AS ObjectLink_MarginReport
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent1 	
                                                     ON ObjectFloat_Percent1.ObjectId = ObjectLink_MarginReport.ObjectId
                                                    AND ObjectFloat_Percent1.DescId = zc_ObjectFloat_MarginReportItem_Percent1()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent2 	
                                                     ON ObjectFloat_Percent2.ObjectId = ObjectLink_MarginReport.ObjectId
                                                    AND ObjectFloat_Percent2.DescId = zc_ObjectFloat_MarginReportItem_Percent2()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent3 	
                                                     ON ObjectFloat_Percent3.ObjectId = ObjectLink_MarginReport.ObjectId
                                                    AND ObjectFloat_Percent3.DescId = zc_ObjectFloat_MarginReportItem_Percent3()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent4 	
                                                     ON ObjectFloat_Percent4.ObjectId = ObjectLink_MarginReport.ObjectId
                                                    AND ObjectFloat_Percent4.DescId = zc_ObjectFloat_MarginReportItem_Percent4()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent5 	
                                                     ON ObjectFloat_Percent5.ObjectId = ObjectLink_MarginReport.ObjectId
                                                    AND ObjectFloat_Percent5.DescId = zc_ObjectFloat_MarginReportItem_Percent5()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent6 	
                                                     ON ObjectFloat_Percent6.ObjectId = ObjectLink_MarginReport.ObjectId
                                                    AND ObjectFloat_Percent6.DescId = zc_ObjectFloat_MarginReportItem_Percent6()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent7 	
                                                     ON ObjectFloat_Percent7.ObjectId = ObjectLink_MarginReport.ObjectId
                                                    AND ObjectFloat_Percent7.DescId = zc_ObjectFloat_MarginReportItem_Percent7()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                    ON ObjectLink_Unit.DescId = zc_ObjectLink_MarginReportItem_Unit()
                                                   AND ObjectLink_Unit.ObjectId = ObjectLink_MarginReport.ObjectId
                          WHERE ObjectLink_MarginReport.DescId = zc_ObjectLink_MarginReportItem_MarginReport()
                            AND ObjectLink_MarginReport.ChildObjectId = inMarginReportId
                            AND inMarginReportId <> 0 
                          )

, tmpMarginCategory AS (SELECT DISTINCT  ObjectLink_MarginCategoryLink_Unit.ChildObjectId AS UnitId
                                       , ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId AS MarginCategoryId
                        FROM  ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                          --LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_MarginCategoryLink_Unit.ChildObjectId
                          LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryLink_MarginCategory
                                               ON ObjectLink_MarginCategoryLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId 
                                              AND ObjectLink_MarginCategoryLink_MarginCategory.DescId = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                          --LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id =  ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId
                          LEFT JOIN ObjectFloat AS ObjectFloat_Percent 	
                                                ON ObjectFloat_Percent.ObjectId = ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId
                                               AND ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()  
                        WHERE ObjectLink_MarginCategoryLink_Unit.DescId = zc_ObjectLink_MarginCategoryLink_Unit()
                          AND COALESCE (ObjectFloat_Percent.ValueData,0) = 0
                       ) 

      , tmpMargCatItem AS ( SELECT DISTINCT tmp.UnitId, tmp.MarginCategoryId
                                 , max(tmp.MarginPercent1) AS MarginPercent1, max(tmp.MarginPercent2) AS MarginPercent2, max(tmp.MarginPercent3) AS MarginPercent3
                                 , max(tmp.MarginPercent4) AS MarginPercent4, max(tmp.MarginPercent5) AS MarginPercent5, max(tmp.MarginPercent6) AS MarginPercent6
                                 , max(tmp.MarginPercent7) AS MarginPercent7
                            FROM (   
                                  SELECT tmpMarginCategory.UnitId, tmpMarginCategory.MarginCategoryId
                                       , CASE WHEN COALESCE(Object_MarginCategoryItem.MinPrice,0) < inPrice1 THEN Object_MarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent1
                                       , CASE WHEN COALESCE(Object_MarginCategoryItem.MinPrice,0) >= inPrice1 AND COALESCE(Object_MarginCategoryItem.MinPrice,0) < inPrice2 THEN COALESCE(Object_MarginCategoryItem.MarginPercent,0) ELSE 0 END AS MarginPercent2
                                       , CASE WHEN COALESCE(Object_MarginCategoryItem.MinPrice,0) >= inPrice2 AND COALESCE(Object_MarginCategoryItem.MinPrice,0) < inPrice3 THEN COALESCE(Object_MarginCategoryItem.MarginPercent,0) ELSE 0 END AS MarginPercent3
                                       , CASE WHEN COALESCE(Object_MarginCategoryItem.MinPrice,0) >= inPrice3 AND COALESCE(Object_MarginCategoryItem.MinPrice,0) < inPrice4 THEN COALESCE(Object_MarginCategoryItem.MarginPercent,0) ELSE 0 END AS MarginPercent4
                                       , CASE WHEN COALESCE(Object_MarginCategoryItem.MinPrice,0) >= inPrice4 AND COALESCE(Object_MarginCategoryItem.MinPrice,0) < inPrice5 THEN COALESCE(Object_MarginCategoryItem.MarginPercent,0) ELSE 0 END AS MarginPercent5
                                       , CASE WHEN COALESCE(Object_MarginCategoryItem.MinPrice,0) >= inPrice5 AND COALESCE(Object_MarginCategoryItem.MinPrice,0) < inPrice6 THEN COALESCE(Object_MarginCategoryItem.MarginPercent,0) ELSE 0 END AS MarginPercent6
                                       , CASE WHEN COALESCE(Object_MarginCategoryItem.MinPrice,0) >= inPrice6 THEN Object_MarginCategoryItem.MarginPercent ELSE 0 END AS MarginPercent7
                                  FROM tmpMarginCategory
                                      LEFT JOIN (SELECT Object_MarginCategoryItem_View.*
                                                 FROM Object_MarginCategoryItem_View
                                                      INNER JOIN Object ON Object.Id = Object_MarginCategoryItem_View.Id
                                                                       AND Object.isErased = FALSE
                                                ) AS Object_MarginCategoryItem ON Object_MarginCategoryItem.MarginCategoryId = tmpMarginCategory.MarginCategoryId
                                  ) AS tmp
                            GROUP BY tmp.UnitId, tmp.MarginCategoryId
                           )

, tmpMarginCategoryItem AS (SELECT *
                            FROM (SELECT *, ROW_NUMBER()OVER(PARTITION BY tmp.UnitId Order By tmp.UnitId, tmp.MarginCategoryId desc) AS Ord
                                  FROM tmpMargCatItem AS tmp
                                  ) as tmp
                            WHERE tmp.Ord = 1  
                            )


-- расчет по виртуальным процентам 
, tmpDataAll_2 AS (SELECT tmpDataAll.*
                        
                        , COALESCE(tmpMarginReportItem.Percent1,0)  ::TFloat AS VirtPercent1
                        , COALESCE(tmpMarginReportItem.Percent2,0)  ::TFloat AS VirtPercent2
                        , COALESCE(tmpMarginReportItem.Percent3,0)  ::TFloat AS VirtPercent3
                        , COALESCE(tmpMarginReportItem.Percent4,0)  ::TFloat AS VirtPercent4
                        , COALESCE(tmpMarginReportItem.Percent5,0)  ::TFloat AS VirtPercent5
                        , COALESCE(tmpMarginReportItem.Percent6,0)  ::TFloat AS VirtPercent6
                        , COALESCE(tmpMarginReportItem.Percent7,0)  ::TFloat AS VirtPercent7

                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent1,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent1,0) < 100 THEN tmpDataAll.Summa1 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent1,0)) ELSE tmpDataAll.Summa1 END AS VirtSummaSale1
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent2,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent2,0) < 100 THEN tmpDataAll.Summa2 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent2,0)) ELSE tmpDataAll.Summa2 END AS VirtSummaSale2
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent3,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent3,0) < 100 THEN tmpDataAll.Summa3 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent3,0)) ELSE tmpDataAll.Summa3 END AS VirtSummaSale3
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent4,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent4,0) < 100 THEN tmpDataAll.Summa4 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent4,0)) ELSE tmpDataAll.Summa4 END AS VirtSummaSale4
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent5,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent5,0) < 100 THEN tmpDataAll.Summa5 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent5,0)) ELSE tmpDataAll.Summa5 END AS VirtSummaSale5
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent6,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent6,0) < 100 THEN tmpDataAll.Summa6 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent6,0)) ELSE tmpDataAll.Summa6 END AS VirtSummaSale6
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent7,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent7,0) < 100 THEN tmpDataAll.Summa7 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent7,0)) ELSE tmpDataAll.Summa7 END AS VirtSummaSale7
           
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent1,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent1,0) < 100 THEN (tmpDataAll.Summa1 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent1,0)))-tmpDataAll.Summa1 ELSE 0 END AS VirtProfit1
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent2,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent2,0) < 100 THEN (tmpDataAll.Summa2 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent2,0)))-tmpDataAll.Summa2 ELSE 0 END AS VirtProfit2
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent3,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent3,0) < 100 THEN (tmpDataAll.Summa3 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent3,0)))-tmpDataAll.Summa3 ELSE 0 END AS VirtProfit3
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent4,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent4,0) < 100 THEN (tmpDataAll.Summa4 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent4,0)))-tmpDataAll.Summa4 ELSE 0 END AS VirtProfit4
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent5,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent5,0) < 100 THEN (tmpDataAll.Summa5 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent5,0)))-tmpDataAll.Summa5 ELSE 0 END AS VirtProfit5
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent6,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent6,0) < 100 THEN (tmpDataAll.Summa6 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent6,0)))-tmpDataAll.Summa6 ELSE 0 END AS VirtProfit6
                        , CASE WHEN COALESCE(tmpMarginReportItem.Percent7,0) <> 0 AND COALESCE(tmpMarginReportItem.Percent7,0) < 100 THEN (tmpDataAll.Summa7 * 100 /(100 - COALESCE(tmpMarginReportItem.Percent7,0)))-tmpDataAll.Summa7 ELSE 0 END AS VirtProfit7

                 FROM tmpDataAll
                      LEFT JOIN tmpMarginReportItem ON tmpMarginReportItem.UnitId = tmpDataAll.UnitId      
                )
, tmpTotalVirt AS (SELECT tmpDataAll_2.UnitId
                        , (COALESCE(tmpDataAll_2.VirtSummaSale1,0) + COALESCE(tmpDataAll_2.VirtSummaSale2,0) + COALESCE(tmpDataAll_2.VirtSummaSale3,0)
                         + COALESCE(tmpDataAll_2.VirtSummaSale4,0)+ COALESCE(tmpDataAll_2.VirtSummaSale5,0)+ COALESCE(tmpDataAll_2.VirtSummaSale6,0)+ COALESCE(tmpDataAll_2.VirtSummaSale7,0) ) AS VirtSummaSale
                   FROM tmpDataAll_2
                   )                
                            
        SELECT
             Object_JuridicalMain.ObjectCode         AS JuridicalMainCode
           , Object_JuridicalMain.ValueData          AS JuridicalMainName
           , Object_Unit.Id                          AS UnitId
           , Object_Unit.ObjectCode                  AS UnitCode
           , Object_Unit.ValueData                   AS UnitName

           , CAST (tmpDataAll.Amount    AS NUMERIC (16, 2)) ::TFloat AS Amount
           , CAST (tmpDataAll.Summa     AS NUMERIC (16, 2)) ::TFloat AS Summa
           , CAST (tmpDataAll.SummaSale AS NUMERIC (16, 2)) ::TFloat AS SummaSale
           

           , CAST (tmpDataAll.Amount1    AS NUMERIC (16, 2)) ::TFloat AS Amount1
           , CAST (tmpDataAll.Summa1     AS NUMERIC (16, 2)) ::TFloat AS Summa1
           , CAST (tmpDataAll.SummaSale1 AS NUMERIC (16, 2)) ::TFloat AS SummaSale1
           , CAST (tmpDataAll.PercentAmount1    AS NUMERIC (16, 2)) ::TFloat AS PercentAmount1
           , CAST (tmpDataAll.PercentSumma1     AS NUMERIC (16, 2)) ::TFloat AS PercentSumma1
           , CAST (tmpDataAll.PercentSummaSale1 AS NUMERIC (16, 2)) ::TFloat AS PercentSummaSale1

           , CAST (tmpDataAll.Amount2    AS NUMERIC (16, 2)) ::TFloat AS Amount2
           , CAST (tmpDataAll.Summa2     AS NUMERIC (16, 2)) ::TFloat AS Summa2
           , CAST (tmpDataAll.SummaSale2 AS NUMERIC (16, 2)) ::TFloat AS SummaSale2
           , CAST (tmpDataAll.PercentAmount2    AS NUMERIC (16, 2)) ::TFloat AS PercentAmount2
           , CAST (tmpDataAll.PercentSumma2     AS NUMERIC (16, 2)) ::TFloat AS PercentSumma2
           , CAST (tmpDataAll.PercentSummaSale2 AS NUMERIC (16, 2)) ::TFloat AS PercentSummaSale2

           , CAST (tmpDataAll.Amount3    AS NUMERIC (16, 2)) ::TFloat AS Amount3
           , CAST (tmpDataAll.Summa3     AS NUMERIC (16, 2)) ::TFloat AS Summa3
           , CAST (tmpDataAll.SummaSale3 AS NUMERIC (16, 2)) ::TFloat AS SummaSale3
           , CAST (tmpDataAll.PercentAmount3    AS NUMERIC (16, 2)) ::TFloat AS PercentAmount3
           , CAST (tmpDataAll.PercentSumma3     AS NUMERIC (16, 2)) ::TFloat AS PercentSumma3
           , CAST (tmpDataAll.PercentSummaSale3 AS NUMERIC (16, 2)) ::TFloat AS PercentSummaSale3

           , CAST (tmpDataAll.Amount4    AS NUMERIC (16, 2)) ::TFloat AS Amount4
           , CAST (tmpDataAll.Summa4     AS NUMERIC (16, 2)) ::TFloat AS Summa4
           , CAST (tmpDataAll.SummaSale4 AS NUMERIC (16, 2)) ::TFloat AS SummaSale4
           , CAST (tmpDataAll.PercentAmount4    AS NUMERIC (16, 2)) ::TFloat AS PercentAmount4
           , CAST (tmpDataAll.PercentSumma4     AS NUMERIC (16, 2)) ::TFloat AS PercentSumma4
           , CAST (tmpDataAll.PercentSummaSale4 AS NUMERIC (16, 2)) ::TFloat AS PercentSummaSale4

           , CAST (tmpDataAll.Amount5    AS NUMERIC (16, 2)) ::TFloat AS Amount5
           , CAST (tmpDataAll.Summa5     AS NUMERIC (16, 2)) ::TFloat AS Summa5
           , CAST (tmpDataAll.SummaSale5 AS NUMERIC (16, 2)) ::TFloat AS SummaSale5
           , CAST (tmpDataAll.PercentAmount5    AS NUMERIC (16, 2)) ::TFloat AS PercentAmount5
           , CAST (tmpDataAll.PercentSumma5     AS NUMERIC (16, 2)) ::TFloat AS PercentSumma5
           , CAST (tmpDataAll.PercentSummaSale5 AS NUMERIC (16, 2)) ::TFloat AS PercentSummaSale5

           , CAST (tmpDataAll.Amount6    AS NUMERIC (16, 2)) ::TFloat AS Amount6
           , CAST (tmpDataAll.Summa6     AS NUMERIC (16, 2)) ::TFloat AS Summa6
           , CAST (tmpDataAll.SummaSale6 AS NUMERIC (16, 2)) ::TFloat AS SummaSale6
           , CAST (tmpDataAll.PercentAmount6    AS NUMERIC (16, 2)) ::TFloat AS PercentAmount6
           , CAST (tmpDataAll.PercentSumma6     AS NUMERIC (16, 2)) ::TFloat AS PercentSumma6
           , CAST (tmpDataAll.PercentSummaSale6 AS NUMERIC (16, 2)) ::TFloat AS PercentSummaSale6

           , CAST (tmpDataAll.Amount7    AS NUMERIC (16, 2)) ::TFloat AS Amount7
           , CAST (tmpDataAll.Summa7     AS NUMERIC (16, 2)) ::TFloat AS Summa7
           , CAST (tmpDataAll.SummaSale7 AS NUMERIC (16, 2)) ::TFloat AS SummaSale7
           , CAST (tmpDataAll.PercentAmount7    AS NUMERIC (16, 2))  ::TFloat AS PercentAmount7
           , CAST (tmpDataAll.PercentSumma7     AS NUMERIC (16, 2))  ::TFloat AS PercentSumma7
           , CAST (tmpDataAll.PercentSummaSale7 AS NUMERIC (16, 2))  ::TFloat AS PercentSummaSale7

           , CAST ((tmpDataAll.SummaSale  - tmpDataAll.Summa)  AS NUMERIC (16, 2)) ::TFloat AS SummaProfit
           , CAST ((tmpDataAll.SummaSale1 - tmpDataAll.Summa1) AS NUMERIC (16, 2)) ::TFloat AS SummaProfit1
           , CAST ((tmpDataAll.SummaSale2 - tmpDataAll.Summa2) AS NUMERIC (16, 2)) ::TFloat AS SummaProfit2
           , CAST ((tmpDataAll.SummaSale3 - tmpDataAll.Summa3) AS NUMERIC (16, 2)) ::TFloat AS SummaProfit3
           , CAST ((tmpDataAll.SummaSale4 - tmpDataAll.Summa4) AS NUMERIC (16, 2)) ::TFloat AS SummaProfit4
           , CAST ((tmpDataAll.SummaSale5 - tmpDataAll.Summa5) AS NUMERIC (16, 2)) ::TFloat AS SummaProfit5
           , CAST ((tmpDataAll.SummaSale6 - tmpDataAll.Summa6) AS NUMERIC (16, 2)) ::TFloat AS SummaProfit6
           , CAST ((tmpDataAll.SummaSale7 - tmpDataAll.Summa7) AS NUMERIC (16, 2)) ::TFloat AS SummaProfit7

           , CAST (CASE WHEN tmpDataAll.SummaSale  <> 0 THEN 100 - tmpDataAll.Summa /tmpDataAll.SummaSale *100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit
           , CAST (CASE WHEN tmpDataAll.SummaSale1 <> 0 THEN 100 - tmpDataAll.Summa1/tmpDataAll.SummaSale1*100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit1
           , CAST (CASE WHEN tmpDataAll.SummaSale2 <> 0 THEN 100 - tmpDataAll.Summa2/tmpDataAll.SummaSale2*100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit2
           , CAST (CASE WHEN tmpDataAll.SummaSale3 <> 0 THEN 100 - tmpDataAll.Summa3/tmpDataAll.SummaSale3*100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit3
           , CAST (CASE WHEN tmpDataAll.SummaSale4 <> 0 THEN 100 - tmpDataAll.Summa4/tmpDataAll.SummaSale4*100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit4
           , CAST (CASE WHEN tmpDataAll.SummaSale5 <> 0 THEN 100 - tmpDataAll.Summa5/tmpDataAll.SummaSale5*100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit5
           , CAST (CASE WHEN tmpDataAll.SummaSale6 <> 0 THEN 100 - tmpDataAll.Summa6/tmpDataAll.SummaSale6*100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit6
           , CAST (CASE WHEN tmpDataAll.SummaSale7 <> 0 THEN 100 - tmpDataAll.Summa7/tmpDataAll.SummaSale7*100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS PercentProfit7

           , CAST (CASE WHEN tmpTotalVirt.VirtSummaSale  <> 0 THEN 100 - tmpDataAll.Summa /tmpTotalVirt.VirtSummaSale * 100 ELSE 0 END AS NUMERIC (16, 2)) ::TFloat AS VirtPercent
           , tmpDataAll.VirtPercent1  ::TFloat AS VirtPercent1
           , tmpDataAll.VirtPercent2  ::TFloat AS VirtPercent2
           , tmpDataAll.VirtPercent3  ::TFloat AS VirtPercent3
           , tmpDataAll.VirtPercent4  ::TFloat AS VirtPercent4
           , tmpDataAll.VirtPercent5  ::TFloat AS VirtPercent5
           , tmpDataAll.VirtPercent6  ::TFloat AS VirtPercent6
           , tmpDataAll.VirtPercent7  ::TFloat AS VirtPercent7

           , CAST (tmpTotalVirt.VirtSummaSale AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale
           , CAST ( tmpDataAll.VirtSummaSale1 AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale1
           , CAST ( tmpDataAll.VirtSummaSale2 AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale2
           , CAST ( tmpDataAll.VirtSummaSale3 AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale3
           , CAST ( tmpDataAll.VirtSummaSale4 AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale4
           , CAST ( tmpDataAll.VirtSummaSale5 AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale5
           , CAST ( tmpDataAll.VirtSummaSale6 AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale6
           , CAST ( tmpDataAll.VirtSummaSale7 AS NUMERIC (16, 2)) ::TFloat AS VirtSummaSale7

           , CAST ( CASE WHEN  tmpTotalVirt.VirtSummaSale  <> 0 THEN (tmpTotalVirt.VirtSummaSale - tmpDataAll.Summa) ELSE 0 END  AS NUMERIC (16, 2)) ::TFloat AS VirtProfit
           , CAST ( tmpDataAll.VirtProfit1 AS NUMERIC (16, 2)) ::TFloat AS VirtProfit1
           , CAST ( tmpDataAll.VirtProfit2 AS NUMERIC (16, 2)) ::TFloat AS VirtProfit2
           , CAST ( tmpDataAll.VirtProfit3 AS NUMERIC (16, 2)) ::TFloat AS VirtProfit3
           , CAST ( tmpDataAll.VirtProfit4 AS NUMERIC (16, 2)) ::TFloat AS VirtProfit4
           , CAST ( tmpDataAll.VirtProfit5 AS NUMERIC (16, 2)) ::TFloat AS VirtProfit5
           , CAST ( tmpDataAll.VirtProfit6 AS NUMERIC (16, 2)) ::TFloat AS VirtProfit6
           , CAST ( tmpDataAll.VirtProfit7 AS NUMERIC (16, 2)) ::TFloat AS VirtProfit7

           , tmpMarginCategoryItem.MarginPercent1  ::TFloat 
           , tmpMarginCategoryItem.MarginPercent2  ::TFloat 
           , tmpMarginCategoryItem.MarginPercent3  ::TFloat 
           , tmpMarginCategoryItem.MarginPercent4  ::TFloat 
           , tmpMarginCategoryItem.MarginPercent5  ::TFloat 
           , tmpMarginCategoryItem.MarginPercent6  ::TFloat 
           , tmpMarginCategoryItem.MarginPercent7  ::TFloat 

           , Object_MarginCategory.ValueData AS MarginCategoryName
           
           , 14941410 :: Integer  AS Color_Amount            --нежно сал.14941410  -- 
           , 16777158  :: Integer  AS Color_Summa           -- желтый 8978431
           , 8978431   :: Integer  AS Color_SummaSale       --голубой 16380671

           , CASE WHEN tmpDataAll.PercentAmount1 <> tmpMaxPercent.MaxPercentAmount1 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentAmount1
           , CASE WHEN tmpDataAll.PercentSumma1 <> tmpMaxPercent.MaxPercentSumma1 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSumma1
           , CASE WHEN tmpDataAll.PercentSummaSale1 <> tmpMaxPercent.MaxPercentSummaSale1 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSummaSale1

           , CASE WHEN tmpDataAll.PercentAmount2 <> tmpMaxPercent.MaxPercentAmount2 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentAmount2
           , CASE WHEN tmpDataAll.PercentSumma2 <> tmpMaxPercent.MaxPercentSumma2 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSumma2
           , CASE WHEN tmpDataAll.PercentSummaSale2 <> tmpMaxPercent.MaxPercentSummaSale2 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSummaSale2       

           , CASE WHEN tmpDataAll.PercentAmount3 <> tmpMaxPercent.MaxPercentAmount3 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentAmount3
           , CASE WHEN tmpDataAll.PercentSumma3 <> tmpMaxPercent.MaxPercentSumma3 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSumma3
           , CASE WHEN tmpDataAll.PercentSummaSale3 <> tmpMaxPercent.MaxPercentSummaSale3 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSummaSale3   

           , CASE WHEN tmpDataAll.PercentAmount4 <> tmpMaxPercent.MaxPercentAmount4 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentAmount4
           , CASE WHEN tmpDataAll.PercentSumma4 <> tmpMaxPercent.MaxPercentSumma4 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSumma4
           , CASE WHEN tmpDataAll.PercentSummaSale4 <> tmpMaxPercent.MaxPercentSummaSale4 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSummaSale4    

           , CASE WHEN tmpDataAll.PercentAmount5 <> tmpMaxPercent.MaxPercentAmount5 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentAmount5
           , CASE WHEN tmpDataAll.PercentSumma5 <> tmpMaxPercent.MaxPercentSumma5 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSumma5
           , CASE WHEN tmpDataAll.PercentSummaSale5 <> tmpMaxPercent.MaxPercentSummaSale5 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSummaSale5
                      
           , CASE WHEN tmpDataAll.PercentAmount6 <> tmpMaxPercent.MaxPercentAmount6 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentAmount6
           , CASE WHEN tmpDataAll.PercentSumma6 <> tmpMaxPercent.MaxPercentSumma6 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSumma6
           , CASE WHEN tmpDataAll.PercentSummaSale6 <> tmpMaxPercent.MaxPercentSummaSale6 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSummaSale6

           , CASE WHEN tmpDataAll.PercentAmount7 <> tmpMaxPercent.MaxPercentAmount7 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentAmount7
           , CASE WHEN tmpDataAll.PercentSumma7 <> tmpMaxPercent.MaxPercentSumma7 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSumma7
           , CASE WHEN tmpDataAll.PercentSummaSale7 <> tmpMaxPercent.MaxPercentSummaSale7 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PercentSummaSale7 
                                            
       FROM tmpDataAll_2 AS tmpDataAll
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =tmpDataAll.UnitId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN Object AS Object_JuridicalMain ON Object_JuridicalMain.Id = ObjectLink_Unit_Juridical.ChildObjectId

                LEFT JOIN tmpMaxPercent ON 1=1
               -- LEFT JOIN tmpMarginReportItem ON tmpMarginReportItem.UnitId = Object_Unit.Id
                LEFT JOIN tmpTotalVirt ON tmpTotalVirt.UnitId = Object_Unit.Id
                
                LEFT JOIN tmpMarginCategoryItem ON tmpMarginCategoryItem.UnitId = Object_Unit.Id
                LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = tmpMarginCategoryItem.MarginCategoryId
                
        ORDER BY Object_JuridicalMain.ValueData 
               , Object_Unit.ValueData 
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 21.03.16         *
*/
-- тест
-- SELECT * FROM gpReport_PriceIntervention (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
--select * from gpReport_PriceIntervention(inStartDate := ('01.03.2016')::TDateTime , inEndDate := ('10.03.2016')::TDateTime , inPrice1 := 100 , inPrice2 := 200 , inPrice3 := 300 , inPrice4 := 400 , inPrice5 := 500 , inPrice6 := 600 ,  inSession := '3');
--select * from gpReport_PriceIntervention(inStartDate := ('01.01.2016')::TDateTime , inEndDate := ('02.01.2016')::TDateTime , inPrice1 := 15 , inPrice2 := 30 , inPrice3 := 50 , inPrice4 := 70 , inPrice5 := 300 , inPrice6 := 1000 , inMarginReportId := 2082814 ,  inSession := '3');
--select * from gpReport_PriceIntervention(inStartDate := ('01.01.2016')::TDateTime , inEndDate := ('02.01.2016')::TDateTime , inPrice1 := 15 , inPrice2 := 50 , inPrice3 := 100 , inPrice4 := 200 , inPrice5 := 300 , inPrice6 := 1000 , inMarginReportId := 2082837 ,  inSession := '3');