-- Function: gpSelect_Movement_ProductionUnionTech_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnionTech_Print2 (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnionTechOut_Print (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
                                                                
CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnionTechOut_Print(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inFromId            Integer,
    IN inToId              Integer,
    IN inGoodsId_child     Integer,
    IN inGroupNum          Integer,
    IN inisCuterCount      Boolean,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbFromId_group Integer;
  DECLARE vbIsOrder Boolean;

  DECLARE Cursor1 refcursor;
  DECLARE inisCuterCount      Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inGoodsId_child,0) <> 0 AND inStartDate <> inEndDate
     THEN
          RAISE EXCEPTION 'Ошибка. Данная печать предусматривает выбор 1 дня.'; 
     END IF;
     
     -- определяется
     vbFromId_group:= (SELECT ObjectLink_Parent.ChildObjectId FROM ObjectLink AS ObjectLink_Parent WHERE ObjectLink_Parent.ObjectId = inFromId AND ObjectLink_Parent.DescId = zc_ObjectLink_Unit_Parent());
     --
     CREATE TEMP TABLE _tmpListMaster (MovementId Integer, StatusId Integer, InvNumber TVarChar, OperDate TDateTime, DocumentKindId integer,MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_Complete Integer, ReceiptId Integer, Amount TFloat, CuterCount TFloat) ON COMMIT DROP;

     WITH
     -- пр-во приход
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
                               LEFT JOIN MovementBoolean AS MB_Peresort
                                                         ON MB_Peresort.MovementId = Movement.Id
                                                        AND MB_Peresort.DescId     = zc_MovementBoolean_Peresort()
                                                        AND MB_Peresort.ValueData  = TRUE
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
                              AND MB_Peresort.MovementId IS NULL
                           )
    -- пр-во приход - строчная часть
    INSERT INTO _tmpListMaster (MovementId, StatusId, InvNumber, OperDate, DocumentKindId, MovementItemId, GoodsId, GoodsKindId, GoodsKindId_Complete, ReceiptId, Amount, CuterCount)
       SELECT COALESCE (tmpMI_production.MovementId, 0)           AS MovementId
            , COALESCE (tmpMI_production.StatusId, 0)             AS StatusId
            , COALESCE (tmpMI_production.InvNumber, '')           AS InvNumber
            , tmpMI_production.OperDate                           AS OperDate
            , COALESCE (tmpMI_production.DocumentKindId, 0)       AS DocumentKindId
            , COALESCE (tmpMI_production.MovementItemId, 0)       AS MovementItemId
            , COALESCE (tmpMI_production.GoodsId, 0)              AS GoodsId
            , COALESCE (tmpMI_production.GoodsKindId, 0)          AS GoodsKindId
            , COALESCE (tmpMI_production.GoodsKindId_Complete, 0) AS GoodsKindId_Complete
            , COALESCE (tmpMI_production.ReceiptId, 0)            AS ReceiptId
            , COALESCE (tmpMI_production.Amount, 0)               AS Amount
            , COALESCE (tmpMI_production.CuterCount, 0)           AS CuterCount
       FROM tmpMI_production
       ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListMaster;

    -- для оптимизации - в Табл. 1
    CREATE TEMP TABLE _tmpRes_cur1 ON COMMIT DROP AS
       -- Результат - пр-во приход - строчная часть
       SELECT
              _tmpListMaster.MovementId
            , _tmpListMaster.MovementItemId

            , _tmpListMaster.InvNumber
            , _tmpListMaster.OperDate

            , Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName

            , _tmpListMaster.Amount
              -- Кол-во куттеров
            , _tmpListMaster.CuterCount         AS CuterCount
              -- Кол-во партий рецептуры для замеса
            , COALESCE (ObjectFloat_CountReceipt.ValueData, 0) AS CountReceipt_goods

            , Object_GoodsKind.Id                   AS GoodsKindId
            , Object_GoodsKind.ObjectCode           AS GoodsKindCode
            , Object_GoodsKind.ValueData            AS GoodsKindName
            , Object_Measure.ValueData              AS MeasureName
            , Object_GoodsGroupAnalyst.ValueData    AS GoodsGroupName

            , Object_GoodsKindComplete.Id           AS GoodsKindId_Complete
            , Object_GoodsKindComplete.ObjectCode   AS GoodsKindCode_Complete
            , Object_GoodsKindComplete.ValueData    AS GoodsKindName_Complete

            , Object_Receipt.Id                     AS ReceiptId
            , ObjectString_Receipt_Code.ValueData   AS ReceiptCode
            , Object_Receipt.ValueData              AS ReceiptName
            , ObjectBoolean_Receipt_Main.ValueData  AS isMain

       FROM _tmpListMaster
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = _tmpListMaster.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
             LEFT JOIN ObjectFloat AS ObjectFloat_CountReceipt
                                   ON ObjectFloat_CountReceipt.ObjectId = _tmpListMaster.GoodsId
                                  AND ObjectFloat_CountReceipt.DescId   = zc_ObjectFloat_Goods_CountReceipt()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = _tmpListMaster.GoodsId
                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

             LEFT JOIN Object AS Object_Goods             ON Object_Goods.Id             = _tmpListMaster.GoodsId
             LEFT JOIN Object AS Object_GoodsKind         ON Object_GoodsKind.Id         = _tmpListMaster.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpListMaster.GoodsKindId_Complete
             LEFT JOIN Object AS Object_Receipt           ON Object_Receipt.Id           = _tmpListMaster.ReceiptId
             LEFT JOIN Object AS Object_Measure           ON Object_Measure.Id           = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                    ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                   AND ObjectString_Receipt_Code.DescId   = zc_ObjectString_Receipt_Code()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Receipt_Main
                                     ON ObjectBoolean_Receipt_Main.ObjectId = Object_Receipt.Id
                                    AND ObjectBoolean_Receipt_Main.DescId   = zc_ObjectBoolean_Receipt_Main()
           ;

    -- !!!оптимизация!!!
    CREATE TEMP TABLE _tmpMI_Child_two (ParentId Integer, MovementItemId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
    --
    -- Пр-во расход - строчная часть
    INSERT INTO _tmpMI_Child_two (ParentId, MovementItemId, GoodsId, Amount)
       SELECT MovementItem.ParentId                  AS ParentId
            , MovementItem.Id                        AS MovementItemId
            , MovementItem.ObjectId                  AS GoodsId
          --, COALESCE (MILO_GoodsKind.ObjectId, 0)  AS GoodsKindId
            , MovementItem.Amount                    AS Amount
       FROM _tmpListMaster
            INNER JOIN MovementItem ON MovementItem.ParentId   = _tmpListMaster.MovementItemId
                                   AND MovementItem.MovementId = _tmpListMaster.MovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased   = FALSE  
          --LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
          --                                 ON MILO_GoodsKind.MovementItemId = MovementItem.Id
          --                                AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
       WHERE _tmpListMaster.MovementId <> 0
         AND (MovementItem.ObjectId = inGoodsId_child OR COALESCE (inGoodsId_child,0) = 0)
;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpMI_Child_two;


     -- для оптимизации - в Табл. - 2
     CREATE TEMP TABLE _tmpRes_cur2 ON COMMIT DROP AS
     WITH tmpMILO_GoodsKind AS (SELECT MILO_GoodsKind.*
                                FROM MovementItemLinkObject AS MILO_GoodsKind
                                WHERE MILO_GoodsKind.MovementItemId IN (SELECT DISTINCT _tmpMI_Child_two.MovementItemId FROM _tmpMI_Child_two)
                                  AND MILO_GoodsKind.DescId        = zc_MILinkObject_GoodsKind()
                               )
        , tmpMI_Child AS (SELECT tmpMI_Child_two.ParentId
                               , tmpMI_Child_two.MovementItemId
                               , tmpMI_Child_two.GoodsId
                               , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
                               , tmpMI_Child_two.Amount

                          FROM _tmpMI_Child_two AS tmpMI_Child_two
                               LEFT JOIN tmpMILO_GoodsKind AS MILO_GoodsKind
                                                           ON MILO_GoodsKind.MovementItemId = tmpMI_Child_two.MovementItemId
                                                          AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                         )
 , tmpData AS (SELECT Object_Goods.Id                   AS GoodsId
                    , Object_Goods.ObjectCode           AS GoodsCode
                    , Object_Goods.ValueData            AS GoodsName
                    , Object_GoodsKind.Id               AS GoodsKindId
                    , Object_GoodsKind.ObjectCode       AS GoodsKindCode
                    , Object_GoodsKind.ValueData        AS GoodsKindName

                    , tmpMI_Child.ParentId              AS ParentId

                    , tmpMI_Child.Amount                AS Amount
                    , MIFloat_AmountReceipt.ValueData   AS AmountReceipt

                    , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := Object_Goods.Id
                                                     , inGoodsKindId            := Object_GoodsKind.Id
                                                     , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                     , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                     , inIsWeightMain           := MIBoolean_WeightMain.ValueData
                                                     , inIsTaxExit              := MIBoolean_TaxExit.ValueData
                                                      ) AS GroupNumber

               FROM tmpMI_Child
                    LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMI_Child.GoodsId
                    LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Child.GoodsKindId
                                                        AND tmpMI_Child.GoodsKindId <> zc_GoodsKind_Basis()
                    LEFT JOIN MovementItemBoolean AS MIBoolean_TaxExit
                                                  ON MIBoolean_TaxExit.MovementItemId = tmpMI_Child.MovementItemId
                                                 AND MIBoolean_TaxExit.DescId         = zc_MIBoolean_TaxExit()
                    LEFT JOIN MovementItemBoolean AS MIBoolean_WeightMain
                                                  ON MIBoolean_WeightMain.MovementItemId = tmpMI_Child.MovementItemId
                                                 AND MIBoolean_WeightMain.DescId         = zc_MIBoolean_WeightMain()

                    LEFT JOIN MovementItemFloat AS MIFloat_AmountReceipt
                                                ON MIFloat_AmountReceipt.MovementItemId = tmpMI_Child.MovementItemId
                                               AND MIFloat_AmountReceipt.DescId = zc_MIFloat_AmountReceipt()

                    LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                         ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                        AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                    )
   -- группы для печати
 , tmpGroupPrint AS (-- сырье
                     SELECT 1 AS GroupNum WHERE inGroupNum = 1
                    UNION
                     SELECT 2 AS GroupNum WHERE inGroupNum = 1
                     -- прочее
                    UNION
                     SELECT 3 AS GroupNum WHERE inGroupNum = 4
                    UNION
                     SELECT 4 AS GroupNum WHERE inGroupNum = 4
                    UNION
                     SELECT 5 AS GroupNum WHERE inGroupNum = 4
                   UNION
                     SELECT 6 AS GroupNum WHERE inGroupNum = 4
                    --специи
                   UNION
                     SELECT 7 AS GroupNum WHERE inGroupNum = 2
                    --оболочка
                   UNION
                     SELECT tmp.GroupNumber AS GroupNum
                     FROM (SELECT DISTINCT tmpData.GroupNumber FROM tmpData) AS tmp
                     WHERE inGroupNum = 3
                     AND tmp.GroupNumber NOT IN (1,2,3,4,5,6,7)
                    )
       -- Результат - пр-во расход - строчная часть
       SELECT tmpData.GoodsId
            , tmpData.GoodsCode
            , tmpData.GoodsName
            , tmpData.GoodsKindId
            , tmpData.GoodsKindCode
            , tmpData.GoodsKindName
            , _tmpRes_cur1.GoodsId AS GoodsId_master 
            , 0 AS GoodsKindId_Complete_master
            , _tmpRes_cur1.OperDate
              -- итого - Кол-во факт
            , SUM (COALESCE (tmpData.Amount, 0)) AS Amount
              -- итого - Кол-во по рецептуре
            , SUM (_tmpRes_cur1.CuterCount * tmpData.AmountReceipt) AS AmountReceipt_sum
              -- Кол-во партий рецептуры для замеса
            , _tmpRes_cur1.CountReceipt_goods
            , _tmpRes_cur1.GoodsGroupName  
       FROM tmpData
            INNER JOIN _tmpRes_cur1  ON _tmpRes_cur1.MovementItemId = tmpData.ParentId
            INNER JOIN tmpGroupPrint ON tmpGroupPrint.GroupNum      = tmpData.GroupNumber
       WHERE COALESCE (inGoodsId_child,0) = 0
       GROUP BY tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsName
              , tmpData.GoodsKindId
              , tmpData.GoodsKindCode
              , tmpData.GoodsKindName
              , _tmpRes_cur1.GoodsId
              , _tmpRes_cur1.OperDate
              , _tmpRes_cur1.CountReceipt_goods
              , _tmpRes_cur1.GoodsGroupName 
    UNION
       SELECT tmpData.GoodsId
            , tmpData.GoodsCode
            , tmpData.GoodsName
            , tmpData.GoodsKindId
            , tmpData.GoodsKindCode
            , tmpData.GoodsKindName
            , _tmpRes_cur1.GoodsId AS GoodsId_master
            , _tmpRes_cur1.GoodsKindId_Complete AS GoodsKindId_Complete_master
            , _tmpRes_cur1.OperDate
              -- итого - Кол-во факт
            , SUM (COALESCE (tmpData.Amount, 0)) AS Amount
              -- итого - Кол-во по рецептуре
            , SUM (_tmpRes_cur1.CuterCount * tmpData.AmountReceipt) AS AmountReceipt_sum
              -- Кол-во партий рецептуры для замеса
            , _tmpRes_cur1.CountReceipt_goods
            , _tmpRes_cur1.GoodsGroupName
       FROM tmpData
            INNER JOIN _tmpRes_cur1  ON _tmpRes_cur1.MovementItemId = tmpData.ParentId
       WHERE COALESCE (inGoodsId_child,0) <> 0
       GROUP BY tmpData.GoodsId
              , tmpData.GoodsCode
              , tmpData.GoodsName
              , tmpData.GoodsKindId
              , tmpData.GoodsKindCode
              , tmpData.GoodsKindName
              , _tmpRes_cur1.GoodsId
              , _tmpRes_cur1.OperDate
              , _tmpRes_cur1.CountReceipt_goods
              , _tmpRes_cur1.GoodsGroupName
              , _tmpRes_cur1.GoodsKindId_Complete 
      ;

    -- Результат - 1
    OPEN Cursor1 FOR

    SELECT tmpWeekDay.DayOfWeekName_Full :: TVarChar AS DayOfWeekName
         , tmp_Res.OperDate
         , tmp_Res.GoodsId
         , tmp_Res.GoodsCode
         , tmp_Res.GoodsName
         , tmp_Res.GoodsGroupName 
         , tmp_Res.GoodsKindName  :: TVarChar
         , tmp_Res.GoodsKindName_Complete :: TVarChar
         , '' :: TVarChar AS GoodsKind_group  
         , tmp_Res.MeasureName

         , tmp_Res.GoodsId_child
         , tmp_Res.GoodsCode_child
         , tmp_Res.GoodsName_child
         , tmp_Res.GoodsKindId_child
         , tmp_Res.GoodsKindCode_child
         , tmp_Res.GoodsKindName_child

           -- Кол-во куттеров
         , tmp_Res.CuterCount         :: TFloat AS CuterCount
           -- Кол-во партий рецептуры для замеса
         , tmp_Res.CountReceipt_goods :: TFloat AS CountReceipt_goods
           -- Итого Кол-во по рецептуре
         , tmp_Res.AmountReceipt_sum :: TFloat AS AmountReceipt_sum
           -- Кол-во по рецептуре - на 1 куттер (на 100 кг.)
         , (tmp_Res.AmountReceipt_sum / NULLIF (tmp_Res.CuterCount, 0)) :: TFloat AS AmountReceipt

           -- Кол-во по рецептуре для 1-ого ПОЛНОГО замеса
         , CASE WHEN tmp_Res.CuterCount_1 > 0 THEN tmp_Res.AmountReceipt_sum / NULLIF (tmp_Res.CuterCount, 0) * tmp_Res.CountReceipt_goods ELSE 0 END :: TFloat AS AmountReceipt_1
         
           -- Кол-во по рецептуре для 1-ого хвоста от ПОЛНОГО замеса
         , (tmp_Res.AmountReceipt_sum / NULLIF (tmp_Res.CuterCount, 0) * tmp_Res.CuterCount_0) :: TFloat AS AmountReceipt_0

           -- Кол-во Целых замесов
         , tmp_Res.CuterCount_1 :: TFloat AS CuterCount_1
           -- Хвост от Целых замесов
         , tmp_Res.CuterCount_0 :: TFloat AS CuterCount_0

    FROM (
          SELECT tmpRes_cur1.OperDate
               , tmpRes_cur1.GoodsId
               , tmpRes_cur1.GoodsCode
               , tmpRes_cur1.GoodsName
               , tmpRes_cur1.GoodsGroupName
               , tmpRes_cur1.GoodsKindName
               , tmpRes_cur1.GoodsKindName_Complete
               , tmpRes_cur1.MeasureName
               , tmpRes_cur2.GoodsId        AS GoodsId_child
               , tmpRes_cur2.GoodsCode      AS GoodsCode_child
               , tmpRes_cur2.GoodsName      AS GoodsName_child
               , tmpRes_cur2.GoodsKindId    AS GoodsKindId_child
               , tmpRes_cur2.GoodsKindCode  AS GoodsKindCode_child
               , tmpRes_cur2.GoodsKindName  AS GoodsKindName_child
                 -- Кол-во куттеров
               , tmpRes_cur1.CuterCount
                 -- Кол-во партий рецептуры для замеса
               , tmpRes_cur1.CountReceipt_goods

                 -- Кол-во Целых замесов
               , FLOOR (tmpRes_cur1.CuterCount / NULLIF (tmpRes_cur1.CountReceipt_goods, 0)) AS CuterCount_1
                 -- Хвост от Целых замесов
               , tmpRes_cur1.CuterCount - FLOOR (tmpRes_cur1.CuterCount / NULLIF (tmpRes_cur1.CountReceipt_goods, 0)) * NULLIF (tmpRes_cur1.CountReceipt_goods, 0) AS CuterCount_0
               
                 -- факт - итого Кол-во пр-во расход
               , tmpRes_cur2.Amount
                 -- по рецептуре - итого Кол-во пр-во расход
               , tmpRes_cur2.AmountReceipt_sum

          FROM -- собрали пр-во приход - строчная часть
               (SELECT _tmpRes_cur1.OperDate
                     , _tmpRes_cur1.GoodsId
                     , _tmpRes_cur1.GoodsCode
                     , _tmpRes_cur1.GoodsName   
                     , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.GoodsKindName ELSE '' END          AS GoodsKindName 
                     , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.GoodsKindId_Complete ELSE 0 END   AS GoodsKindId_Complete
                     , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.GoodsKindName_Complete ELSE '' END AS GoodsKindName_Complete
                     , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.MeasureName ELSE '' END            AS MeasureName
                     , _tmpRes_cur1.CountReceipt_goods
                     , _tmpRes_cur1.GoodsGroupName
                     , SUM (_tmpRes_cur1.Amount)     AS Amount
                     , SUM (_tmpRes_cur1.CuterCount) AS CuterCount
                     , _tmpRes_cur1.MovementItemId
                FROM _tmpRes_cur1
                GROUP BY _tmpRes_cur1.OperDate
                       , _tmpRes_cur1.GoodsId
                       , _tmpRes_cur1.GoodsCode
                       , _tmpRes_cur1.GoodsName
                       , _tmpRes_cur1.CountReceipt_goods
                       , _tmpRes_cur1.GoodsGroupName  
                       , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.GoodsKindName ELSE '' END
                       , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.GoodsKindName_Complete ELSE '' END
                       , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.MeasureName ELSE '' END           
                       , CASE WHEN COALESCE (inGoodsId_child,0) <> 0 THEN _tmpRes_cur1.GoodsKindId_Complete ELSE 0 END
                       , _tmpRes_cur1.MovementItemId
                HAVING SUM (_tmpRes_cur1.CuterCount) > 0
               ) AS tmpRes_cur1
               -- пр-во расход - строчная часть - уже собрана
               INNER JOIN _tmpRes_cur2 AS tmpRes_cur2
                                       ON tmpRes_cur2.GoodsId_master = tmpRes_cur1.GoodsId
                                      AND tmpRes_cur2.OperDate       = tmpRes_cur1.OperDate   
                                      AND tmpRes_cur2.GoodsKindId_Complete_master = tmpRes_cur1.GoodsKindId_Complete
          ) AS tmp_Res
          LEFT JOIN zfCalc_DayOfWeekName (tmp_Res.OperDate) AS tmpWeekDay ON 1=1    
          
         ;


    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР

               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.20         *
 14.04.20         *
*/

-- тест
--
--
--select * from gpSelect_Movement_ProductionUnionTechOut_Print(inStartDate := ('23.03.2020')::TDateTime , inEndDate := ('24.03.2020')::TDateTime , inFromId := 8447 , inToId := 8447 , inGoodsId_child := 0, inGroupNum:=1, inisCuterCount:=true, inSession := '5'::TVarChar);
--FETCH ALL "<unnamed portal 6>";