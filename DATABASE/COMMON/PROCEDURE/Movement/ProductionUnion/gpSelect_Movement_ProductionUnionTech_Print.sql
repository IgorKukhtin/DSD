-- Function: gpSelect_Movement_ProductionUnionTech_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnionTech_Print (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnionTech_Print (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnionTech_Print(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inFromId            Integer,
    IN inToId              Integer,
    IN inGroupNum          Integer,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbFromId_group Integer;
  DECLARE vbIsOrder Boolean;

  DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Select_Movement_ProductionUnionTech());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     vbFromId_group:= (SELECT ObjectLink_Parent.ChildObjectId FROM ObjectLink AS ObjectLink_Parent WHERE ObjectLink_Parent.ObjectId = inFromId AND ObjectLink_Parent.DescId = zc_ObjectLink_Unit_Parent());
     -- 
     CREATE TEMP TABLE _tmpListMaster (MovementId Integer, StatusId Integer, InvNumber TVarChar, OperDate TDateTime, DocumentKindId integer,MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_Complete Integer, ReceiptId Integer, Amount TFloat, CuterCount TFloat) ON COMMIT DROP;

     WITH   
     tmpMI_production AS (SELECT Movement.Id                                                    AS MovementId
                               , Movement.StatusId                                              AS StatusId
                               , Movement.InvNumber                                             AS InvNumber
                               , Movement.OperDate                                              AS OperDate
                               , MovementItem.ObjectId                                          AS GoodsId
                               , MILO_GoodsKind.ObjectId                                        AS GoodsKindId
                               , MILO_GoodsKindComplete.ObjectId                                AS GoodsKindId_Complete
                               , MILO_Receipt.ObjectId                                          AS ReceiptId
                               , MLO_From.ObjectId                                              AS FromId
                               , MLO_DocumentKind.ObjectId                                      AS DocumentKindId
                               , MovementItem.Id                                                AS MovementItemId
                               , MovementItem.Amount                                            AS Amount
                               , COALESCE (MIFloat_CuterCount.ValueData, 0)                     AS CuterCount
                               , COALESCE ((ObjectBoolean_UnitFrom_PartionDate.ValueData = TRUE AND ObjectBoolean_UnitTo_PartionDate.ValueData = TRUE), FALSE) AS isPartionDate
                          FROM Movement
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.isErased   = FALSE
                                                      AND MovementItem.DescId     = zc_MI_Master()
                               LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                           ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                               LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                               LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                                ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                               AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                               LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                                ON MILO_Receipt.MovementItemId = MovementItem.Id
                                                               AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                               LEFT JOIN MovementLinkObject AS MLO_From
                                                            ON MLO_From.MovementId = Movement.Id
                                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                            ON MLO_DocumentKind.MovementId = Movement.Id
                                                           AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
         
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_UnitFrom_PartionDate
                                                       ON ObjectBoolean_UnitFrom_PartionDate.ObjectId = MLO_From.ObjectId
                                                      AND ObjectBoolean_UnitFrom_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_UnitTo_PartionDate
                                                       ON ObjectBoolean_UnitTo_PartionDate.ObjectId = MLO_To.ObjectId
                                                      AND ObjectBoolean_UnitTo_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()

                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_ProductionUnion()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND MLO_From.ObjectId = inFromId
                              AND MLO_To.ObjectId = inToId
                           )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    INSERT INTO _tmpListMaster (MovementId, StatusId, InvNumber, OperDate, DocumentKindId, MovementItemId, GoodsId, GoodsKindId, GoodsKindId_Complete, ReceiptId, Amount, CuterCount)
       SELECT COALESCE (tmpMI_production.MovementId, 0)        AS MovementId
            , COALESCE (tmpMI_production.StatusId, 0)          AS StatusId
            , COALESCE (tmpMI_production.InvNumber, '')        AS InvNumber
            , tmpMI_production.OperDate         AS OperDate
            , COALESCE (tmpMI_production.DocumentKindId, 0)    AS DocumentKindId
            , COALESCE (tmpMI_production.MovementItemId,0)      AS MovementItemId
            , COALESCE (tmpMI_production.GoodsId, 0)           AS GoodsId
            , COALESCE (tmpMI_production.GoodsKindId, 0)          AS GoodsKindId
            , COALESCE (tmpMI_production.GoodsKindId_Complete, 0) AS GoodsKindId_Complete
            , COALESCE (tmpMI_production.ReceiptId, 0)         AS ReceiptId
            , COALESCE (tmpMI_production.Amount, 0)            AS Amount
            , COALESCE (tmpMI_production.CuterCount, 0)        AS CuterCount
       FROM tmpMI_production
       ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListMaster;

    -- для оптимизации - в Табл. 1
    CREATE TEMP TABLE _tmpRes_cur1 ON COMMIT DROP AS

       SELECT
              CASE WHEN _tmpListMaster.MovementId <> 0 THEN row_number() OVER (ORDER BY CASE WHEN _tmpListMaster.MovementId <> 0 THEN _tmpListMaster.MovementItemId ELSE NULL END) ELSE 0 END :: Integer AS LineNum
            , _tmpListMaster.MovementId
            , _tmpListMaster.MovementItemId

            , _tmpListMaster.InvNumber
            , _tmpListMaster.OperDate
   
            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , _tmpListMaster.Amount
            , _tmpListMaster.CuterCount
            , COALESCE (ObjectFloat_Receipt_Value.ValueData, 0) * _tmpListMaster.CuterCount AS  Amount_calc

            , MIFloat_Count.ValueData           AS Count
            , MIFloat_RealWeight.ValueData      AS RealWeight
            , MIFloat_CuterWeight.ValueData     AS CuterWeight 


            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_Measure.ValueData          AS MeasureName

            , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
            , Object_GoodsKindComplete.ObjectCode AS GoodsKindCode_Complete
            , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete

            , Object_Receipt.Id                   AS ReceiptId
            , ObjectString_Receipt_Code.ValueData AS ReceiptCode
            , Object_Receipt.ValueData            AS ReceiptName
            , ObjectBoolean_Receipt_Main.ValueData   AS isMain

       FROM _tmpListMaster
             LEFT JOIN MovementItemFloat AS MIFloat_Count
                                         ON MIFloat_Count.MovementItemId = _tmpListMaster.MovementItemId
                                        AND MIFloat_Count.DescId = zc_MIFloat_Count()
                                        AND _tmpListMaster.MovementId <> 0
             LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                         ON MIFloat_RealWeight.MovementItemId = _tmpListMaster.MovementItemId
                                        AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                                        AND _tmpListMaster.MovementId <> 0
             LEFT JOIN MovementItemFloat AS MIFloat_CuterWeight
                                         ON MIFloat_CuterWeight.MovementItemId = _tmpListMaster.MovementItemId
                                        AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()
                                        AND _tmpListMaster.MovementId <> 0

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpListMaster.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpListMaster.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpListMaster.GoodsKindId_Complete
             LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = _tmpListMaster.ReceiptId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                    ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                   AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Receipt_Main
                                     ON ObjectBoolean_Receipt_Main.ObjectId = Object_Receipt.Id
                                    AND ObjectBoolean_Receipt_Main.DescId = zc_ObjectBoolean_Receipt_Main()
             LEFT JOIN ObjectFloat AS ObjectFloat_Receipt_Value
                                   ON ObjectFloat_Receipt_Value.ObjectId = Object_Receipt.Id
                                  AND ObjectFloat_Receipt_Value.DescId = zc_ObjectFloat_Receipt_Value()
           ;


    -- !!!оптимизация!!!
    CREATE TEMP TABLE _tmpMI_Child_two (MovementItemId Integer, MovementItemId_Child Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
    -- 
    INSERT INTO _tmpMI_Child_two (MovementItemId, MovementItemId_Child, GoodsId, Amount)
       SELECT _tmpListMaster.MovementItemId AS MovementItemId
            , MovementItem.Id               AS MovementItemId_Child
            , MovementItem.ObjectId         AS GoodsId
            , MovementItem.Amount           AS Amount
       FROM _tmpListMaster
            INNER JOIN MovementItem ON MovementItem.ParentId = _tmpListMaster.MovementItemId
                                   AND MovementItem.MovementId = _tmpListMaster.MovementId
                                   AND MovementItem.DescId   = zc_MI_Child()
                                   AND MovementItem.isErased = FALSE
       WHERE _tmpListMaster.MovementId <> 0;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpMI_Child_two;


     -- для оптимизации - в Табл. - 2
     CREATE TEMP TABLE _tmpRes_cur2 ON COMMIT DROP AS
     WITH tmpMILO_GoodsKind AS (SELECT MILO_GoodsKind.*
                                FROM MovementItemLinkObject AS MILO_GoodsKind
                                WHERE MILO_GoodsKind.MovementItemId IN (SELECT DISTINCT _tmpMI_Child_two.MovementItemId_Child FROM _tmpMI_Child_two)
                                  AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                               )
        , tmpMI_Child AS (SELECT tmpMI_Child_two.MovementItemId
                               , tmpMI_Child_two.MovementItemId_Child
                               , tmpMI_Child_two.GoodsId
                               , COALESCE (MILO_GoodsKind.ObjectId, 0)      AS GoodsKindId
                               , tmpMI_Child_two.Amount
                               
                          FROM _tmpMI_Child_two AS tmpMI_Child_two
                               LEFT JOIN tmpMILO_GoodsKind AS MILO_GoodsKind
                                                           ON MILO_GoodsKind.MovementItemId = tmpMI_Child_two.MovementItemId_Child
                                                          AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                               
                         )
    , tmpReceiptChild AS (SELECT _tmpListMaster.MovementItemId                                  AS MovementItemId
                               , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)      AS GoodsId
                               , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                               , ObjectFloat_Value.ValueData                                    AS Value
                               , ObjectFloat_Value_master.ValueData                             AS Value_master
                               , COALESCE (ObjectBoolean_TaxExit.ValueData, FALSE)              AS isTaxExit
                               , COALESCE (ObjectBoolean_WeightMain.ValueData, FALSE)           AS isWeightMain

                               , _tmpListMaster.GoodsKindId AS GoodsKindId_master
                          FROM _tmpListMaster
                               INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                     ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = _tmpListMaster.ReceiptId
                                                    AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                               INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                       AND Object_ReceiptChild.isErased = FALSE
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                    ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                   AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                               INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                      ON ObjectFloat_Value_master.ObjectId = _tmpListMaster.ReceiptId
                                                     AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                     AND ObjectFloat_Value_master.ValueData <> 0
                               INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                      ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                     AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                     -- AND ObjectFloat_Value.ValueData <> 0

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                       ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id 
                                                      AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                       ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                                      AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                         )
                         
 , tmpMI_ReceiptChild AS (SELECT MAX (COALESCE (tmpMI_Child.MovementItemId_Child, 0)) AS MovementItemId_Child
                               , tmpReceiptChild.MovementItemId
                               , tmpReceiptChild.GoodsId
                               , tmpReceiptChild.GoodsKindId
                               , tmpReceiptChild.Value
                               , tmpReceiptChild.Value_master
                               , tmpReceiptChild.isTaxExit
                               , tmpReceiptChild.isWeightMain
                               , tmpReceiptChild.GoodsKindId_master
                          FROM tmpReceiptChild
                               LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementItemId = tmpReceiptChild.MovementItemId
                                                    AND tmpMI_Child.GoodsId = tmpReceiptChild.GoodsId
                                                    AND tmpMI_Child.GoodsKindId = tmpReceiptChild.GoodsKindId
                          GROUP BY tmpReceiptChild.MovementItemId
                                 , tmpReceiptChild.GoodsId
                                 , tmpReceiptChild.GoodsKindId
                                 , tmpReceiptChild.Value
                                 , tmpReceiptChild.Value_master
                                 , tmpReceiptChild.isTaxExit
                                 , tmpReceiptChild.isWeightMain
                               
                                 , tmpReceiptChild.GoodsKindId_master
                         )
 , tmpData AS (SELECT Object_Goods.Id                   AS GoodsId
                    , Object_Goods.ObjectCode           AS GoodsCode
                    , Object_Goods.ValueData            AS GoodsName
        
                    , COALESCE (tmpMI_Child.MovementItemId, tmpMI_ReceiptChild.MovementItemId) AS ParentId

                    , tmpMI_Child.Amount
        
                    , COALESCE (MIFloat_AmountReceipt.ValueData, CASE WHEN tmpMI_ReceiptChild.GoodsKindId_master = zc_GoodsKind_WorkProgress() THEN tmpMI_ReceiptChild.Value ELSE 0 END) AS AmountReceipt
        
                    , MIDate_PartionGoods.ValueData     AS PartionGoodsDate
        
                    , Object_GoodsKind.Id               AS GoodsKindId
                    , Object_GoodsKind.ObjectCode       AS GoodsKindCode
                    , Object_GoodsKind.ValueData        AS GoodsKindName
        
                    , Object_GoodsKindComplete.Id               AS GoodsKindCompleteId
                    , Object_GoodsKindComplete.ObjectCode       AS GoodsKindCompleteCode
                    , Object_GoodsKindComplete.ValueData        AS GoodsKindCompleteName
        
                    , Object_Measure.ValueData          AS MeasureName
        
                    , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := Object_Goods.Id
                                                     , inGoodsKindId            := Object_GoodsKind.Id
                                                     , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                     , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                     , inIsWeightMain           := COALESCE (MIBoolean_WeightMain.ValueData, tmpMI_ReceiptChild.isWeightMain)
                                                     , inIsTaxExit              := COALESCE (MIBoolean_WeightMain.ValueData, tmpMI_ReceiptChild.isWeightMain)
                                                      ) AS GroupNumber
        
               FROM tmpMI_Child
                    FULL JOIN tmpMI_ReceiptChild ON tmpMI_ReceiptChild.MovementItemId_Child = tmpMI_Child.MovementItemId_Child
        
                    LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpMI_ReceiptChild.GoodsId, tmpMI_Child.GoodsId)
                    LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (tmpMI_ReceiptChild.GoodsKindId, tmpMI_Child.GoodsKindId)
        
                    LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                    ON MILO_GoodsKindComplete.MovementItemId = tmpMI_Child.MovementItemId_Child
                                                   AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                    LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId
        
                    LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                                  ON MIBoolean_TaxExit.MovementItemId =  tmpMI_Child.MovementItemId_Child
                                                 AND MIBoolean_TaxExit.DescId = zc_MIBoolean_TaxExit()
                    LEFT JOIN MovementItemBoolean AS MIBoolean_WeightMain
                                                  ON MIBoolean_WeightMain.MovementItemId =  tmpMI_Child.MovementItemId_Child
                                                 AND MIBoolean_WeightMain.DescId = zc_MIBoolean_WeightMain()
        
                    LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                               ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                              AND MIDate_PartionGoods.MovementItemId = tmpMI_Child.MovementItemId_Child
        
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                                ON MIFloat_AmountReceipt.MovementItemId = tmpMI_Child.MovementItemId_Child
                                               AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()
        
                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                          ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                         AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
        
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                         ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
        
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                         ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                        AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                    )
  -- группы для печати
  /*1)1+2
    2)3+4+6
    3)5+7
    4) остальное
  */
 , tmpGroupPrint AS (SELECT 1 AS GroupNum WHERE inGroupNum = 1
                    UNION
                     SELECT 2 AS GroupNum WHERE inGroupNum = 1
                    
                    UNION
                     SELECT 3 AS GroupNum WHERE inGroupNum = 2
                    UNION
                     SELECT 4 AS GroupNum WHERE inGroupNum = 2
                    UNION
                     SELECT 6 AS GroupNum WHERE inGroupNum = 2
                    
                   UNION
                     SELECT 5 AS GroupNum WHERE inGroupNum = 3
                   UNION
                     SELECT 7 AS GroupNum WHERE inGroupNum = 3
                    
                   UNION
                     SELECT tmp.GroupNumber AS GroupNum
                     FROM (SELECT DISTINCT tmpData.GroupNumber FROM tmpData) AS tmp
                     WHERE inGroupNum = 4
                     AND tmp.GroupNumber NOT IN (1,2,3,4,6,5,7)
                    )                   

       -- РЕЗУЛЬТАТ
       SELECT tmpData.GoodsId
            , tmpData.GoodsCode
            , tmpData.GoodsName
            , tmpData.ParentId
            , tmpData.Amount
            , tmpData.AmountReceipt
            /*, tmpData.PartionGoodsDate
            , tmpData.GoodsKindId
            , tmpData.GoodsKindCode
            , tmpData.GoodsKindName
            , tmpData.GoodsKindCompleteId
            , tmpData.GoodsKindCompleteCode
            , tmpData.GoodsKindCompleteName
            , tmpData.MeasureName*/
       FROM tmpData
            INNER JOIN tmpGroupPrint ON tmpGroupPrint.GroupNum = tmpData.GroupNumber
      ;
    

    -- Все Результаты - 1
    OPEN Cursor1 FOR
    
     SELECT _tmpRes_cur1.OperDate
          , tmpWeekDay.DayOfWeekName_Full ::TVarChar AS DayOfWeekName
          , _tmpRes_cur1.GoodsName
          , CASE WHEN _tmpRes_cur1.GoodsKindId_Complete = zc_GoodsKind_Basis() THEN '' ELSE _tmpRes_cur1.GoodsKindName_Complete END :: TVarChar AS GoodsKindName_Complete
          , _tmpRes_cur1.CuterCount
          , _tmpRes_cur2.GoodsName  AS GoodsName_child
          , _tmpRes_cur2.AmountReceipt
          , _tmpRes_cur2.Amount
     FROM _tmpRes_cur1
          LEFT JOIN _tmpRes_cur2 ON _tmpRes_cur2.ParentId = _tmpRes_cur1.MovementItemId
          LEFT JOIN zfCalc_DayOfWeekName (_tmpRes_cur1.OperDate) AS tmpWeekDay ON 1=1
     WHERE COALESCE (_tmpRes_cur2.AmountReceipt,0) <> 0 OR COALESCE (_tmpRes_cur2.Amount,0) <> 0
     ORDER BY _tmpRes_cur1.OperDate
            , _tmpRes_cur1.GoodsName
            , _tmpRes_cur2.GoodsName
     ;
    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР

               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.20         *
*/

-- тест
--
--
--select * from gpSelect_Movement_ProductionUnionTech_Print(inStartDate := ('23.03.2020')::TDateTime , inEndDate := ('24.03.2020')::TDateTime , inFromId := 8447 , inToId := 8447 , inSession := '5'::TVarChar);
--FETCH ALL "<unnamed portal 6>"; 