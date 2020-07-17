 -- Function: gpReport_CheckSendSUN_InOut()

DROP FUNCTION IF EXISTS gpReport_CheckSendSUN_InOut(TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckSendSUN_InOut(
    IN inStartDate1        TDateTime,  -- Дата начала пер.1
    IN inEndDate1          TDateTime,  -- Дата окончания пер.1
    IN inStartDate2        TDateTime,  -- Дата начала пер.2
    IN inEndDate2          TDateTime,  -- Дата окончания пер.2
    IN inUnitId            Integer  ,  -- Подразделение
    IN inGoodsId           Integer  ,  -- товар
    --IN inisSendDefSUN     Boolean,    -- Отложенное Перемещение по СУН (да / нет)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId    Integer
             , UnitName  TVarChar
             , GoodsId   Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , GoodsGroupName TVarChar
             , FromName       TVarChar
             , ToName         TVarChar
             , InvNumber_From TVarChar
             , InvNumber_To   TVarChar
             , OperDate_From  TVarChar
             , OperDate_To    TVarChar
             , ExpirationDate_From TVarChar
             , ExpirationDate_To   TVarChar
             , Amount_In     TFloat
             , Amount_Out    TFloat
             , SummaFrom_In  TFloat
             , SummaTo_In    TFloat
             , SummaFrom_Out TFloat
             , SummaTo_Out   TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   
   DECLARE vbDate_0 TDateTime;
   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

    -- Результат
    RETURN QUERY
    WITH   
     -- Данные 1-го периода приход
     tmpMovement1 AS (SELECT Movement.*
                           , MovementLinkObject_To.ObjectId              AS ToId -- кому
                           , MovementLinkObject_From.ObjectId            AS FromId --от кого
                           , MovementLinkObject_PartionDateKind.ObjectId AS PartionDateKindId
                           , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     AS isSUN
                           , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  AS isDefSUN
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                        AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId =0)
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
  
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
 
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                        ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId
                      WHERE Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.OperDate >= inStartDate1 AND Movement.OperDate < inEndDate1 + INTERVAL '1 DAY'
                        AND (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE /*OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE*/)
                      )

   , tmpMI_Master1 AS (SELECT MovementItem.*
                            , COALESCE(MIFloat_PriceFrom.ValueData,0)*MovementItem.Amount     AS SummaFrom
                            , COALESCE(MIFloat_PriceTo.ValueData,0)*MovementItem.Amount       AS SummaTo
                       FROM tmpMovement1 AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                                                   AND COALESCE (MovementItem.Amount,0) <> 0
                                                   AND (MovementItem.ObjectId  = inGoodsId OR inGoodsId = 0)

                            -- цена подразделений записанная при автоматическом распределении 
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                              ON MIFloat_PriceFrom.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                                              ON MIFloat_PriceTo.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()
                      )

    -- Данные 2-го периода расход
   , tmpMovement2 AS (SELECT Movement.*
                           , MovementLinkObject_To.ObjectId              AS ToId
                           , MovementLinkObject_From.ObjectId            AS FromId
                           , MovementLinkObject_PartionDateKind.ObjectId AS PartionDateKindId
                           , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     AS isSUN
                           , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)  AS isDefSUN
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                        AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId =0)

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
 
                           LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
  
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                        ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId
                      WHERE Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.OperDate >= inStartDate2 AND Movement.OperDate < inEndDate2 + INTERVAL '1 DAY'
                        AND (COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE /*OR COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) = TRUE*/)
                      )

   , tmpMI_Master2 AS (SELECT MovementItem.*
                            , COALESCE(MIFloat_PriceFrom.ValueData,0)*MovementItem.Amount     AS SummaFrom
                            , COALESCE(MIFloat_PriceTo.ValueData,0)*MovementItem.Amount       AS SummaTo
                       FROM tmpMovement2 AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                                                   AND COALESCE (MovementItem.Amount,0) <> 0
                                                   AND (MovementItem.ObjectId  = inGoodsId OR inGoodsId = 0)
                            -- цена подразделений записанная при автоматическом распределении 
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                              ON MIFloat_PriceFrom.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                            LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceTo
                                                              ON MIFloat_PriceTo.MovementItemId = MovementItem.Id
                                                             AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()
                      )

   , tmpMI_Child AS (SELECT MovementItem.*
                     FROM (SELECT DISTINCT tmpMI_Master1.Id, tmpMI_Master1.MovementId FROM tmpMI_Master1
                         UNION
                           SELECT DISTINCT tmpMI_Master2.Id, tmpMI_Master2.MovementId FROM tmpMI_Master2
                           ) AS tmpMI_Master
                          INNER JOIN MovementItem ON MovementItem.ParentId   = tmpMI_Master.Id
                                                 AND MovementItem.MovementId = tmpMI_Master.MovementId
                                                 AND MovementItem.DescId   = zc_MI_Child()
                                                 AND MovementItem.isErased = FALSE                       
                     )

   , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                     , MovementItemFloat.ValueData :: Integer AS ContainerId
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_Child.Id FROM tmpMI_Child WHERE tmpMI_Child.IsErased = FALSE)
                                  AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                )

   , tmpContainer AS (SELECT tmp.ContainerId
                           , tmp.MovementItemId
                           , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                           , COALESCE (ObjectDate_Value.ValueData, zc_DateEnd())       AS ExpirationDate
                           , CASE WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_0 THEN zc_Enum_PartionDateKind_0()
                                  WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_0  AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_1 THEN zc_Enum_PartionDateKind_1()
                                  WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_1  AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_3 THEN zc_Enum_PartionDateKind_3()
                                  WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_3  AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_6 THEN zc_Enum_PartionDateKind_6()
                                  ELSE 0
                             END                                                       AS PartionDateKindId
                      FROM tmpMIFloat_ContainerId AS tmp
                      
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = tmp.ContainerId
                                                        AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                           LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                      ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                     AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()
                           -- находим партию
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
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

   , tmpPartion AS (SELECT Movement.Id
                         , MovementDate_Branch.ValueData AS BranchDate
                         , Movement.Invnumber            AS Invnumber
                         , Object_From.ValueData         AS FromName
                         , Object_Contract.ValueData     AS ContractName
                    FROM Movement
                         LEFT JOIN MovementDate AS MovementDate_Branch
                                                ON MovementDate_Branch.MovementId = Movement.Id
                                               AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                    WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                    )


   , tmpIN AS (SELECT Movement.OperDate     AS OperDate
                    , Movement.InvNumber    AS InvNumber
                    , Movement.ToId         AS UnitId
                    , Object_To.ValueData   AS UnitName
                    , Movement.FromId       AS FromId
                    , Object_From.ValueData AS FromName
                    , Movement.ToId         AS ToId
                    , Object_To.ValueData   AS ToName
                    , tmpMI_Master.MovementId AS MovementId
                    , tmpMI_Master.Id       AS Id
                    , tmpMI_Master.ObjectId AS GoodsId
                    , tmpMI_Master.Amount   AS Amount
                    , COALESCE(tmpMI_Master.SummaFrom,0) AS SummaFrom
                    , COALESCE(tmpMI_Master.SummaTo,0)   AS SummaTo
               FROM tmpMI_Master1 AS tmpMI_Master
                    LEFT JOIN tmpMovement1 AS Movement ON Movement.Id    = tmpMI_Master.MovementId
                    LEFT JOIN Object AS Object_From    ON Object_From.Id = Movement.FromId
                    LEFT JOIN Object AS Object_To      ON Object_To.Id   = Movement.ToId
               )

   , tmpOUT AS (SELECT Movement.OperDate     AS OperDate
                     , Movement.InvNumber    AS InvNumber
                     , Movement.FromId       AS UnitId
                     , Object_From.ValueData AS UnitName
                     , Movement.FromId       AS FromId
                     , Object_From.ValueData AS FromName
                     , Movement.ToId         AS ToId
                     , Object_To.ValueData   AS ToName
                     , tmpMI_Master.MovementId AS MovementId
                     , tmpMI_Master.Id       AS Id
                     , tmpMI_Master.ObjectId AS GoodsId
                     , tmpMI_Master.Amount   AS Amount
                     , COALESCE(tmpMI_Master.SummaFrom,0) AS SummaFrom
                     , COALESCE(tmpMI_Master.SummaTo,0)   AS SummaTo
                FROM tmpMI_Master2 AS tmpMI_Master
                     LEFT JOIN tmpMovement2 AS Movement ON Movement.Id    = tmpMI_Master.MovementId
                     LEFT JOIN Object AS Object_From    ON Object_From.Id = Movement.FromId
                     LEFT JOIN Object AS Object_To      ON Object_To.Id   = Movement.ToId
                )

       --Результат
       SELECT tmpIN.UnitId                         AS UnitId
            , tmpIN.UnitName                       AS UnitName
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsGroup.ValueData          AS GoodsGroupName

            , STRING_AGG (DISTINCT tmpIN.FromName, ','  ORDER BY tmpIN.FromName DESC) ::TVarChar AS FromName
            , STRING_AGG (DISTINCT tmpOUT.ToName,   ','  ORDER BY tmpOUT.ToName DESC) ::TVarChar AS ToName

            --, STRING_AGG (DISTINCT ('№ '||tmpIN.InvNumber ||' ('|| LEFT(tmpIN.OperDate::TVarChar,10)::TVarChar||')') ::TVarChar , ',' ::TVarChar) ::TVarChar AS InvNumber_From
            --, STRING_AGG (DISTINCT ('№ '||tmpOUT.InvNumber ||' ('||LEFT(tmpOUT.OperDate::TVarChar,10)::TVarChar||')') ::TVarChar , ',' ::TVarChar)::TVarChar AS InvNumber_To

            , STRING_AGG (DISTINCT ('№ '||tmpIN.InvNumber), ',' ::TVarChar) ::TVarChar AS InvNumber_From
            , STRING_AGG (DISTINCT ('№ '||tmpOUT.InvNumber), ',' ::TVarChar)::TVarChar AS InvNumber_To


            , STRING_AGG (DISTINCT ( ( lpad (DATE_PART('Day', tmpIN.OperDate)::TVarChar,2,'0')||'.'||lpad (DATE_PART('Month', tmpIN.OperDate)::TVarChar,2,'0'))::TVarChar) ::TVarChar , ',' ::TVarChar)   ::TVarChar AS OperDate_From
            , STRING_AGG (DISTINCT ( ( lpad (DATE_PART('Day', tmpOUT.OperDate)::TVarChar,2,'0')||'.'||lpad (DATE_PART('Month', tmpOUT.OperDate)::TVarChar,2,'0'))::TVarChar) ::TVarChar , ',' ::TVarChar) ::TVarChar AS OperDate_To
            
            , STRING_AGG (DISTINCT (lpad (DATE_PART('Day', COALESCE (tmpContainer_IN.ExpirationDate, zc_DateEnd()) )::TVarChar ,2,'0'::TVarChar)||'.'||lpad (DATE_PART('Month', COALESCE (tmpContainer_IN.ExpirationDate, zc_DateEnd()))::TVarChar ,2,'0'::TVarChar)||'.'||lpad (DATE_PART('YEAR', COALESCE (tmpContainer_IN.ExpirationDate, zc_DateEnd()))::TVarChar ,4,'0'::TVarChar)
                         ||' (№ '|| tmpPartion_IN.Invnumber ||' от ' || lpad (DATE_PART('Day', tmpPartion_IN.BranchDate)::TVarChar,2,'0') ||'.'||lpad (DATE_PART('Month', tmpPartion_IN.BranchDate)::TVarChar,2,'0') ||'.'||lpad (DATE_PART('YEAR', tmpPartion_IN.BranchDate)::TVarChar,4,'0') ||')'), ',' ::TVarChar) ::TVarChar AS ExpirationDate_From
            , STRING_AGG (DISTINCT (lpad (DATE_PART('Day', COALESCE (tmpContainer_OUT.ExpirationDate, zc_DateEnd()) )::TVarChar ,2,'0'::TVarChar)||'.'||lpad (DATE_PART('Month', COALESCE (tmpContainer_OUT.ExpirationDate, zc_DateEnd()))::TVarChar ,2,'0'::TVarChar)||'.'||lpad (DATE_PART('YEAR', COALESCE (tmpContainer_OUT.ExpirationDate, zc_DateEnd()))::TVarChar ,4,'0'::TVarChar)
                         ||' (№ '|| tmpPartion_OUT.Invnumber ||' от '|| lpad (DATE_PART('Day', tmpPartion_OUT.BranchDate)::TVarChar,2,'0') ||'.' || lpad (DATE_PART('Month', tmpPartion_OUT.BranchDate)::TVarChar,2,'0') ||'.' || lpad (DATE_PART('YEAR', tmpPartion_OUT.BranchDate)::TVarChar,4,'0') ||')'), ',' ::TVarChar) ::TVarChar AS ExpirationDate_To

            , SUM (COALESCE (tmpIN.Amount,0))    ::TFloat  AS Amount_In
            , SUM (COALESCE (tmpOUT.Amount,0))   ::TFloat  AS Amount_Out
            , SUM (COALESCE(tmpIN.SummaFrom,0))  ::TFloat  AS SummaFrom_In
            , SUM (COALESCE(tmpIN.SummaTo,0))    ::TFloat  AS SummaTo_In
            , SUM (COALESCE(tmpOUT.SummaFrom,0)) ::TFloat  AS SummaFrom_Out
            , SUM (COALESCE(tmpOUT.SummaTo,0))   ::TFloat  AS SummaTo_Out
       FROM tmpIN
            LEFT JOIN tmpOUT ON tmpOUT.GoodsId = tmpIN.GoodsId
                            AND tmpOUT.UnitId = tmpIN.UnitId --tmpOUT.FromId = tmpIN.ToId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpIN.GoodsId


            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpIN.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            
            ---
            LEFT JOIN tmpMI_Child AS tmpMI_Child_IN 
                                  ON tmpMI_Child_IN.ParentId   = tmpIN.Id
                                 AND tmpMI_Child_IN.MovementId = tmpIN.MovementId

            LEFT JOIN tmpMIFloat_ContainerId AS MIFloat_ContainerId_IN
                                             ON MIFloat_ContainerId_IN.MovementItemId = tmpMI_Child_IN.Id
            LEFT JOIN tmpContainer AS tmpContainer_IN ON tmpContainer_IN.ContainerId = MIFloat_ContainerId_IN.ContainerId
            LEFT JOIN tmpPartion AS tmpPartion_IN ON tmpPartion_IN.Id= tmpContainer_IN.MovementId_Income

            LEFT JOIN Object AS Object_PartionDateKind_IN ON Object_PartionDateKind_IN.Id = tmpContainer_IN.PartionDateKindId

            ---
            LEFT JOIN tmpMI_Child AS tmpMI_Child_OUT 
                                  ON tmpMI_Child_OUT.ParentId   = tmpOUT.Id
                                 AND tmpMI_Child_OUT.MovementId = tmpOUT.MovementId

            LEFT JOIN tmpMIFloat_ContainerId AS MIFloat_ContainerId_OUT
                                             ON MIFloat_ContainerId_OUT.MovementItemId = tmpMI_Child_OUT.Id
            LEFT JOIN tmpContainer AS tmpContainer_OUT ON tmpContainer_OUT.ContainerId = MIFloat_ContainerId_OUT.ContainerId
            LEFT JOIN tmpPartion AS tmpPartion_OUT ON tmpPartion_OUT.Id= tmpContainer_OUT.MovementId_Income

            LEFT JOIN Object AS Object_PartionDateKind_OUT ON Object_PartionDateKind_OUT.Id = tmpContainer_OUT.PartionDateKindId

       WHERE tmpOUT.GoodsId IS NOT NULL
       GROUP BY tmpIN.UnitId
              , tmpIN.UnitName 
              , Object_Goods.Id
              , Object_Goods.ValueData
              , Object_GoodsGroup.ValueData
       ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.19         *
*/

-- тест
--select * from gpReport_CheckSendSUN_InOut(inStartDate1:= '01.08.2019' ::TDateTime, inEndDate1:= '16.08.2019' ::TDateTime, inStartDate2 := '01.08.2019' ::TDateTime, inEndDate2 := '16.08.2019' ::TDateTime,inUnitId:= 0, inGoodsId:= 0, inSession:= '3'::TVarChar);

--select lpad('yu', 5, '0')