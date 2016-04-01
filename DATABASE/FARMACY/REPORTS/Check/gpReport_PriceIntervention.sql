-- Function:  gpReport_PriceIntervention()


DROP FUNCTION IF EXISTS gpReport_PriceIntervention (TDateTime, TDateTime, TFloat,TFloat, TFloat,TFloat, TFloat,TFloat, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_PriceIntervention(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inPrice1           TFloat ,
    IN inPrice2           TFloat ,
    IN inPrice3           TFloat ,
    IN inPrice4           TFloat ,
    IN inPrice5           TFloat ,
    IN inPrice6           TFloat ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  JuridicalMainCode  Integer, 
  JuridicalMainName  TVarChar,
  UnitCode           Integer, 
  UnitName           TVarChar,

  Amount            TFloat,
  Summa             TFloat,
  SummaSale         TFloat,
  
  Amount1            TFloat,
  Summa1             TFloat,
  SummaSale1         TFloat,
  PersentAmount1            TFloat,
  PersentSumma1             TFloat,
  PersentSummaSale1         TFloat,
  
  Amount2            TFloat,
  Summa2             TFloat,
  SummaSale2         TFloat,
  PersentAmount2            TFloat,
  PersentSumma2             TFloat,
  PersentSummaSale2         TFloat,
  
  Amount3            TFloat,
  Summa3             TFloat,
  SummaSale3         TFloat,
  PersentAmount3            TFloat,
  PersentSumma3             TFloat,
  PersentSummaSale3         TFloat,
  
  Amount4            TFloat,
  Summa4             TFloat,
  SummaSale4         TFloat,
  PersentAmount4            TFloat,
  PersentSumma4             TFloat,
  PersentSummaSale4         TFloat,
  
  Amount5            TFloat,
  Summa5             TFloat,
  SummaSale5         TFloat,
  PersentAmount5            TFloat,
  PersentSumma5             TFloat,
  PersentSummaSale5         TFloat,

  Amount6            TFloat,
  Summa6             TFloat,
  SummaSale6         TFloat,
  PersentAmount6            TFloat,
  PersentSumma6             TFloat,
  PersentSummaSale6         TFloat,

  Amount7            TFloat,
  Summa7             TFloat,
  SummaSale7         TFloat,
  PersentAmount7            TFloat,
  PersentSumma7             TFloat,
  PersentSummaSale7         TFloat,

  Color_Amount       Integer,
  Color_Summa        Integer,
  Color_SummaSale    Integer,

  Color_PersentAmount1            Integer,
  Color_PersentSumma1             Integer,
  Color_PersentSummaSale1         Integer,
  
  Color_PersentAmount2            Integer,
  Color_PersentSumma2             Integer,
  Color_PersentSummaSale2         Integer,
  
  Color_PersentAmount3            Integer,
  Color_PersentSumma3             Integer,
  Color_PersentSummaSale3         Integer,
  
  Color_PersentAmount4            Integer,
  Color_PersentSumma4             Integer,
  Color_PersentSummaSale4         Integer,
  
  Color_PersentAmount5            Integer,
  Color_PersentSumma5             Integer,
  Color_PersentSummaSale5         Integer,

  Color_PersentAmount6            Integer,
  Color_PersentSumma6             Integer,
  Color_PersentSummaSale6         Integer,

  Color_PersentAmount7            Integer,
  Color_PersentSumma7             Integer,
  Color_PersentSummaSale7         Integer
  
    
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

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice1 THEN tmpData_all.Amount ELSE 0 END ) AS Amount1
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice1 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale1
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice1 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa1
                              
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice2 THEN tmpData_all.Amount ELSE 0 END ) AS Amount2
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice2 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale2
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice2 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa2

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice3 THEN tmpData_all.Amount ELSE 0 END ) AS Amount3
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice3 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale3
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice3 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa3

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice4 THEN tmpData_all.Amount ELSE 0 END ) AS Amount4
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice4 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale4
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice4 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa4

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice5 THEN tmpData_all.Amount ELSE 0 END ) AS Amount5
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice5 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale5
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice5 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa5

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice6 THEN tmpData_all.Amount ELSE 0 END ) AS Amount6
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice6 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale6
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice6 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa6

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice6 THEN tmpData_all.Amount ELSE 0 END ) AS Amount7
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice6 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale7
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice6 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa7
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
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount1*100/tmpData.Amount) ElSE 0 END)           AS PersentAmount1
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa1*100/tmpData.Summa) ElSE 0 END)              AS PersentSumma1
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale1*100/tmpData.SummaSale) ElSE 0 END)  AS PersentSummaSale1
                      
                      , (tmpData.Amount2)      AS Amount2
                      , (tmpData.Summa2)       AS Summa2
                      , (tmpData.SummaSale2)   AS SummaSale2
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount2*100/tmpData.Amount) ElSE 0 END)           AS PersentAmount2
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa2*100/tmpData.Summa) ElSE 0 END)              AS PersentSumma2
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale2*100/tmpData.SummaSale) ElSE 0 END)  AS PersentSummaSale2
                      
                      , (tmpData.Amount3)      AS Amount3
                      , (tmpData.Summa3)       AS Summa3
                      , (tmpData.SummaSale3)   AS SummaSale3
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount3*100/tmpData.Amount) ElSE 0 END)           AS PersentAmount3
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa3*100/tmpData.Summa) ElSE 0 END)              AS PersentSumma3
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale3*100/tmpData.SummaSale) ElSE 0 END)  AS PersentSummaSale3
                      
                      , (tmpData.Amount4)      AS Amount4
                      , (tmpData.Summa4)       AS Summa4
                      , (tmpData.SummaSale4)   AS SummaSale4
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount4*100/tmpData.Amount) ElSE 0 END)           AS PersentAmount4
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa4*100/tmpData.Summa) ElSE 0 END)              AS PersentSumma4
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale4*100/tmpData.SummaSale) ElSE 0 END)  AS PersentSummaSale4
                      
                      , (tmpData.Amount5)      AS Amount5
                      , (tmpData.Summa5)       AS Summa5
                      , (tmpData.SummaSale5)   AS SummaSale5
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount5*100/tmpData.Amount) ElSE 0 END)           AS PersentAmount5
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa5*100/tmpData.Summa) ElSE 0 END)              AS PersentSumma5
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale5*100/tmpData.SummaSale) ElSE 0 END)  AS PersentSummaSale5
                      
                      , (tmpData.Amount6)      AS Amount6
                      , (tmpData.Summa6)       AS Summa6
                      , (tmpData.SummaSale6)   AS SummaSale6
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount6*100/tmpData.Amount) ElSE 0 END)           AS PersentAmount6
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa6*100/tmpData.Summa) ElSE 0 END)              AS PersentSumma6
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale6*100/tmpData.SummaSale) ElSE 0 END)  AS PersentSummaSale6
                      
                      , (tmpData.Amount7)      AS Amount7
                      , (tmpData.Summa7)       AS Summa7
                      , (tmpData.SummaSale7)   AS SummaSale7
                      , (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.Amount7*100/tmpData.Amount) ElSE 0 END)           AS PersentAmount7
                      , (CASE WHEN tmpData.Summa <> 0 THEN (tmpData.Summa7*100/tmpData.Summa) ElSE 0 END)              AS PersentSumma7
                      , (CASE WHEN tmpData.SummaSale <> 0 THEN (tmpData.SummaSale7*100/tmpData.SummaSale) ElSE 0 END)  AS PersentSummaSale7
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
, tmpMaxPersent AS (SELECT MAX(tmpDataAll.PersentAmount1)    AS MaxPersentAmount1
                         , MAX(tmpDataAll.PersentSumma1)     AS MaxPersentSumma1
                         , MAX(tmpDataAll.PersentSummaSale1) AS MAxPersentSummaSale1

                         , MAX(tmpDataAll.PersentAmount2)    AS MaxPersentAmount2
                         , MAX(tmpDataAll.PersentSumma2)     AS MaxPersentSumma2
                         , MAX(tmpDataAll.PersentSummaSale2) AS MAxPersentSummaSale2

                         , MAX(tmpDataAll.PersentAmount3)    AS MaxPersentAmount3
                         , MAX(tmpDataAll.PersentSumma3)     AS MaxPersentSumma3
                         , MAX(tmpDataAll.PersentSummaSale3) AS MAxPersentSummaSale3

                         , MAX(tmpDataAll.PersentAmount4)    AS MaxPersentAmount4
                         , MAX(tmpDataAll.PersentSumma4)     AS MaxPersentSumma4
                         , MAX(tmpDataAll.PersentSummaSale4) AS MAxPersentSummaSale4

                         , MAX(tmpDataAll.PersentAmount5)    AS MaxPersentAmount5
                         , MAX(tmpDataAll.PersentSumma5)     AS MaxPersentSumma5
                         , MAX(tmpDataAll.PersentSummaSale5) AS MAxPersentSummaSale5

                         , MAX(tmpDataAll.PersentAmount6)    AS MaxPersentAmount6
                         , MAX(tmpDataAll.PersentSumma6)     AS MaxPersentSumma6
                         , MAX(tmpDataAll.PersentSummaSale6) AS MAxPersentSummaSale6

                         , MAX(tmpDataAll.PersentAmount7)    AS MaxPersentAmount7
                         , MAX(tmpDataAll.PersentSumma7)     AS MaxPersentSumma7
                         , MAX(tmpDataAll.PersentSummaSale7) AS MAxPersentSummaSale7                         
                    FROM tmpDataAll
                    )               

        SELECT
             Object_JuridicalMain.ObjectCode         AS JuridicalMainCode
           , Object_JuridicalMain.ValueData          AS JuridicalMainName
           , Object_Unit.ObjectCode                  AS UnitCode
           , Object_Unit.ValueData                   AS UnitName

           , tmpDataAll.Amount    ::TFloat AS Amount
           , tmpDataAll.Summa     ::TFloat AS Summa
           , tmpDataAll.SummaSale ::TFloat AS SummaSale

           , tmpDataAll.Amount1    ::TFloat AS Amount1
           , tmpDataAll.Summa1     ::TFloat AS Summa1
           , tmpDataAll.SummaSale1 ::TFloat AS SummaSale1
           , tmpDataAll.PersentAmount1     ::TFloat AS PersentAmount1
           , tmpDataAll.PersentSumma1      ::TFloat AS PersentSumma1
           , tmpDataAll.PersentSummaSale1  ::TFloat AS PersentSummaSale1

           , tmpDataAll.Amount2    ::TFloat AS Amount2
           , tmpDataAll.Summa2     ::TFloat AS Summa2
           , tmpDataAll.SummaSale2 ::TFloat AS SummaSale2
           , tmpDataAll.PersentAmount2     ::TFloat AS PersentAmount2
           , tmpDataAll.PersentSumma2      ::TFloat AS PersentSumma2
           , tmpDataAll.PersentSummaSale2  ::TFloat AS PersentSummaSale2

           , tmpDataAll.Amount3    ::TFloat AS Amount3
           , tmpDataAll.Summa3     ::TFloat AS Summa3
           , tmpDataAll.SummaSale3 ::TFloat AS SummaSale3
           , tmpDataAll.PersentAmount3    ::TFloat AS PersentAmount3
           , tmpDataAll.PersentSumma3     ::TFloat AS PersentSumma3
           , tmpDataAll.PersentSummaSale3 ::TFloat AS PersentSummaSale3

           , tmpDataAll.Amount4    ::TFloat AS Amount4
           , tmpDataAll.Summa4     ::TFloat AS Summa4
           , tmpDataAll.SummaSale4 ::TFloat AS SummaSale4
           , tmpDataAll.PersentAmount4    ::TFloat AS PersentAmount4
           , tmpDataAll.PersentSumma4     ::TFloat AS PersentSumma4
           , tmpDataAll.PersentSummaSale4 ::TFloat AS PersentSummaSale4

           , tmpDataAll.Amount5    ::TFloat AS Amount5
           , tmpDataAll.Summa5     ::TFloat AS Summa5
           , tmpDataAll.SummaSale5 ::TFloat AS SummaSale5
           , tmpDataAll.PersentAmount5     ::TFloat AS PersentAmount5
           , tmpDataAll.PersentSumma5      ::TFloat AS PersentSumma5
           , tmpDataAll.PersentSummaSale5  ::TFloat AS PersentSummaSale5

           , tmpDataAll.Amount6    ::TFloat AS Amount6
           , tmpDataAll.Summa6     ::TFloat AS Summa6
           , tmpDataAll.SummaSale6 ::TFloat AS SummaSale6
           , tmpDataAll.PersentAmount6     ::TFloat AS PersentAmount6
           , tmpDataAll.PersentSumma6      ::TFloat AS PersentSumma6
           , tmpDataAll.PersentSummaSale6  ::TFloat AS PersentSummaSale6

           , tmpDataAll.Amount7    ::TFloat AS Amount7
           , tmpDataAll.Summa7     ::TFloat AS Summa7
           , tmpDataAll.SummaSale7 ::TFloat AS SummaSale7
           , tmpDataAll.PersentAmount7      ::TFloat AS PersentAmount7
           , tmpDataAll.PersentSumma7       ::TFloat AS PersentSumma7
           , tmpDataAll.PersentSummaSale7   ::TFloat AS PersentSummaSale7

           , 14941410 :: Integer  AS Color_Amount            --нежно сал.14941410  -- 
           , 16777158  :: Integer  AS Color_Summa           -- желтый 8978431
           , 8978431   :: Integer  AS Color_SummaSale       --голубой 16380671

           , CASE WHEN tmpDataAll.PersentAmount1 <> tmpMaxPersent.MaxPersentAmount1 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentAmount1
           , CASE WHEN tmpDataAll.PersentSumma1 <> tmpMaxPersent.MaxPersentSumma1 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSumma1
           , CASE WHEN tmpDataAll.PersentSummaSale1 <> tmpMaxPersent.MaxPersentSummaSale1 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSummaSale1

           , CASE WHEN tmpDataAll.PersentAmount2 <> tmpMaxPersent.MaxPersentAmount2 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentAmount2
           , CASE WHEN tmpDataAll.PersentSumma2 <> tmpMaxPersent.MaxPersentSumma2 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSumma2
           , CASE WHEN tmpDataAll.PersentSummaSale2 <> tmpMaxPersent.MaxPersentSummaSale2 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSummaSale2       

           , CASE WHEN tmpDataAll.PersentAmount3 <> tmpMaxPersent.MaxPersentAmount3 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentAmount3
           , CASE WHEN tmpDataAll.PersentSumma3 <> tmpMaxPersent.MaxPersentSumma3 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSumma3
           , CASE WHEN tmpDataAll.PersentSummaSale3 <> tmpMaxPersent.MaxPersentSummaSale3 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSummaSale3   

           , CASE WHEN tmpDataAll.PersentAmount4 <> tmpMaxPersent.MaxPersentAmount4 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentAmount4
           , CASE WHEN tmpDataAll.PersentSumma4 <> tmpMaxPersent.MaxPersentSumma4 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSumma4
           , CASE WHEN tmpDataAll.PersentSummaSale4 <> tmpMaxPersent.MaxPersentSummaSale4 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSummaSale4    

           , CASE WHEN tmpDataAll.PersentAmount5 <> tmpMaxPersent.MaxPersentAmount5 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentAmount5
           , CASE WHEN tmpDataAll.PersentSumma5 <> tmpMaxPersent.MaxPersentSumma5 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSumma5
           , CASE WHEN tmpDataAll.PersentSummaSale5 <> tmpMaxPersent.MaxPersentSummaSale5 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSummaSale5
                      
           , CASE WHEN tmpDataAll.PersentAmount6 <> tmpMaxPersent.MaxPersentAmount6 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentAmount6
           , CASE WHEN tmpDataAll.PersentSumma6 <> tmpMaxPersent.MaxPersentSumma6 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSumma6
           , CASE WHEN tmpDataAll.PersentSummaSale6 <> tmpMaxPersent.MaxPersentSummaSale6 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSummaSale6

           , CASE WHEN tmpDataAll.PersentAmount7 <> tmpMaxPersent.MaxPersentAmount7 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentAmount7
           , CASE WHEN tmpDataAll.PersentSumma7 <> tmpMaxPersent.MaxPersentSumma7 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSumma7
           , CASE WHEN tmpDataAll.PersentSummaSale7 <> tmpMaxPersent.MaxPersentSummaSale7 THEN zc_Color_White() ELSE zc_Color_Cyan() END    :: Integer AS Color_PersentSummaSale7 
                                            
       FROM tmpDataAll
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =tmpDataAll.UnitId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN Object AS Object_JuridicalMain ON Object_JuridicalMain.Id = ObjectLink_Unit_Juridical.ChildObjectId

                LEFT JOIN tmpMaxPersent ON 1=1

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