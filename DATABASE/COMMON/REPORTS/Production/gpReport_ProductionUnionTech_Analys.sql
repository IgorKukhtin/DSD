-- Function: gpReport_ProductionUnionTech_Analys()

DROP FUNCTION IF EXISTS gpReport_ProductionUnionTech_Analys (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionUnionTech_Analys(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inFromId            Integer,
    IN inToId              Integer,
    IN inGoodsGroupId      Integer,
    IN inisPeriodOrder     Boolean,     --
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , MovementItemId        Integer
             , InvNumber             TVarChar
             , OperDate              TDateTime --TDateTime
             , FromId_prod           Integer
             , FromName_prod         TVarChar
             , ToId_prod             Integer
             , ToName_prod           TVarChar
             , MovementId_order      Integer
             , MovementItemId_order  Integer
             , InvNumber_order       TVarChar
             , OperDate_order        TDateTime --TDateTime
             , OperDate_cuter        TDateTime
             , OperDate_real         TDateTime
           --, OperDate_ContainerMin TVarChar
             , OperDate_ContainerMax TDateTime
            
             , GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , Amount              TFloat
             , CuterCount          TFloat
             , Amount_calc         TFloat
             , Amount_container    TFloat
             , isPartionClose      Boolean
             , Comment             TVarChar
             , Count               TFloat
             , RealWeight          TFloat
             , CuterWeight         TFloat
             , RealWeightShp       TFloat
             , RealWeightMsg       TFloat
             , Amount_Order        TFloat
             , CuterCount_Order    TFloat
             , Amount_diff         TFloat
             , CuterCount_diff     TFloat
             , GoodsKindId         Integer
             , GoodsKindCode       Integer
             , GoodsKindName       TVarChar
             , MeasureName         TVarChar
             , GoodsGroupNameFull  TVarChar
             , GoodsGroupId        Integer
             , GoodsGroupName      TVarChar
             , GoodsKindId_Complete   Integer
             , GoodsKindCode_Complete Integer
             , GoodsKindName_Complete TVarChar
             , ReceiptId           Integer
             , ReceiptCode         TVarChar
             , ReceiptName         TVarChar
             , Comment_receipt     TVarChar
             , isMain              Boolean
             , TermProduction      TFloat
             , PartionGoodsDate    TDateTime
             , PartionGoodsDateClose TDateTime
             , isOrderSecond       Boolean
             , StartProductionInDays Integer
  )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbFromId_group Integer;
  DECLARE vbIsOrder Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Select_Movement_ProductionUnionTech());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- пока только по дате заявки
     inisPeriodOrder = TRUE;


     -- замена - Склады База + Реализации
     IF COALESCE (inFromId, 0) = 0 THEN inFromId:= 8457; END IF;
     -- замена - Цех ковбаса+делікатеси
     IF COALESCE (inToId, 0)   = 0 THEN inToId  := 8446; END IF;


     CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;

     -- Ограничения по товару ГП
    INSERT INTO _tmpGoods (GoodsId)
       SELECT lfSelect.GoodsId
       FROM lfSelect_Object_Goods_byGoodsGroup (1832 ) AS lfSelect    -- ГП
       --WHERE inGoodsGroupId <> 0
             ;
     -- определяется
     vbFromId_group:= (SELECT ObjectLink_Parent.ChildObjectId FROM ObjectLink AS ObjectLink_Parent WHERE ObjectLink_Parent.ObjectId = inFromId AND ObjectLink_Parent.DescId = zc_ObjectLink_Unit_Parent());

     -- если выбранна группа получаем список подразделений
     CREATE TEMP TABLE _tmpUnitFrom (UnitId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnitTo (UnitId Integer) ON COMMIT DROP;
     
     INSERT INTO _tmpUnitFrom (UnitId)
           SELECT lfSelect.UnitId 
           FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect
           WHERE COALESCE (inFromId,0) <> 0
          UNION 
           SELECT (SELECT ObjectLink_Parent.ChildObjectId FROM ObjectLink AS ObjectLink_Parent WHERE ObjectLink_Parent.ObjectId = inFromId AND ObjectLink_Parent.DescId = zc_ObjectLink_Unit_Parent()) AS UnitId
           WHERE COALESCE (inFromId ,0) <> 0
         UNION 
           SELECT Object.Id AS UnitId 
           FROM Object
           WHERE Object.DescId = zc_Object_Unit()
             AND COALESCE (inFromId, 0) = 0
           ;

     INSERT INTO _tmpUnitTo (UnitId)
           SELECT lfSelect.UnitId 
           FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect
           WHERE COALESCE (inToId,0) <> 0
         UNION 
           SELECT (SELECT ObjectLink_Parent.ChildObjectId FROM ObjectLink AS ObjectLink_Parent WHERE ObjectLink_Parent.ObjectId = inToId AND ObjectLink_Parent.DescId = zc_ObjectLink_Unit_Parent()) AS UnitId
           WHERE COALESCE (inFromId ,0) <> 0
         UNION  
           SELECT Object.Id AS UnitId 
           FROM Object
           WHERE Object.DescId = zc_Object_Unit()
             AND COALESCE (inToId,0) = 0
           ;

     -- 
     CREATE TEMP TABLE _tmpListMaster (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, FromId_prod Integer, MovementItemId Integer
                                     , MovementId_order Integer, InvNumber_order TVarChar, OperDate_order TDateTime, MovementItemId_order Integer
                                     , GoodsId Integer, GoodsKindId Integer, GoodsKindId_Complete Integer, ReceiptId Integer
                                     , StartProductionInDays Integer
                                     , Amount_Order TFloat, CuterCount_Order TFloat, Amount TFloat, CuterCount TFloat, isPartionDate Boolean, isOrderSecond Boolean
                                     , TermProduction TFloat, PartionGoodsDate TVarChar, PartionGoodsDateClose TDateTime) ON COMMIT DROP;

     -- определяется - ЦЕХ колбаса+дел-сы
     --vbIsOrder:= (inFromId = inToId) AND EXISTS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId = inFromId);

    --(SELECT (inStartDate - INTERVAL '5 DAY') AS StartDate, (inEndDate + INTERVAL '5 DAY') AS EndDate WHERE vbIsOrder = TRUE) AS tmpDate
     WITH 
        tmpMov_order AS (SELECT Movement.*
                              , MLO_To.ObjectId   AS ToId
                              , MLO_From.ObjectId AS FromId
                         FROM Movement 
                              INNER JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                           AND MLO_To.ObjectId IN (SELECT _tmpUnitTo.UnitId FROM _tmpUnitTo)  --(SELECT _tmpUnitFrom.UnitId FROM _tmpUnitFrom) --(SELECT _tmpUnitTo.UnitId FROM _tmpUnitTo) -- --(SELECT _tmpUnitTo.UnitId FROM _tmpUnitTo)
                              INNER JOIN MovementLinkObject AS MLO_From
                                                            ON MLO_From.MovementId = Movement.Id
                                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
                                                           AND MLO_From.ObjectId IN (SELECT _tmpUnitFrom.UnitId FROM _tmpUnitFrom) --
                         WHERE ((inisPeriodOrder = TRUE AND Movement.OperDate BETWEEN inStartDate AND inEndDate)
                           -- OR (inisPeriodOrder = FALSE AND Movement.OperDate BETWEEN inStartDate::TDateTime - INTERVAL '5 DAY'  AND inEndDate::TDateTime+ INTERVAL '5 DAY')
                               )
                            AND Movement.DescId = zc_Movement_OrderInternal()
                            AND Movement.StatusId = zc_Enum_Status_Complete() --<> zc_Enum_Status_Erased()
--AND MLO_To.ObjectId = MLO_From.ObjectId 
                         )
      , tmpMI_ord AS (SELECT MovementItem.*
                           , COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId) AS GoodsId
                      FROM MovementItem 
                           LEFT JOIN MovementItemLinkObject AS MILO_Goods
                                                            ON MILO_Goods.MovementItemId = MovementItem.Id
                                                           AND MILO_Goods.DescId = zc_MILinkObject_Goods()
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId)
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov_order.Id From tmpMov_order)
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.DescId     = zc_MI_Master()
                      )
 
      , tmpMovementItemFloat_ord AS (SELECT *
                                     FROM MovementItemFloat
                                     WHERE MovementItemFloat.MovementItemId IN ((SELECT DISTINCT tmpMI_ord.Id From tmpMI_ord))
                                    )
      , tmpMovementItemLinkObject_ord AS (SELECT *
                                          FROM MovementItemLinkObject
                                          WHERE MovementItemLinkObject.MovementItemId IN ((SELECT  DISTINCT tmpMI_ord.Id From tmpMI_ord))
                                          )
      , tmpMI_order2 AS (SELECT (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime AS OperDate_calc    --дата производства
                               , Movement.OperDate                                              AS OperDate
                               , Movement.Id                                                    AS MovementId
                               , Movement.InvNumber                                             AS InvNumber
                               , MAX (MovementItem.Id)                                          AS MovementItemId
                               , MovementItem.GoodsId                                           AS GoodsId
                               , ObjectLink_Receipt_GoodsKind.ChildObjectId                     AS GoodsKindId
                               , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_Complete
                               , COALESCE (MILO_ReceiptBasis.ObjectId, 0)                       AS ReceiptId 
                               , Movement.FromId                                                AS FromId
                               -- , MLO_To.ObjectId                                                AS ToId
                               , COALESCE (OrderType_Unit.ChildObjectId, Movement.ToId)         AS ToId
                               , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                               , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))                       AS AmountSecond
                               , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0) + COALESCE (MIFloat_CuterCountSecond.ValueData, 0)) AS CuterCount
                               , MIFloat_StartProductionInDays.ValueData AS StartProductionInDays
                          FROM tmpMov_order AS Movement 
                             
                               INNER JOIN tmpMI_ord AS MovementItem ON MovementItem.MovementId = Movement.Id

                               LEFT JOIN tmpMovementItemFloat_ord AS MIFloat_StartProductionInDays
                                                                  ON MIFloat_StartProductionInDays.MovementItemId = MovementItem.Id 
                                                                 AND MIFloat_StartProductionInDays.DescId = zc_MIFloat_StartProductionInDays()
                               LEFT JOIN tmpMovementItemFloat_ord AS MIFloat_AmountSecond
                                                                  ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                               LEFT JOIN tmpMovementItemFloat_ord AS MIFloat_CuterCount
                                                                  ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                               LEFT JOIN tmpMovementItemFloat_ord AS MIFloat_CuterCountSecond
                                                                  ON MIFloat_CuterCountSecond.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_CuterCountSecond.DescId = zc_MIFloat_CuterCountSecond()

                               LEFT JOIN tmpMovementItemLinkObject_ord AS MILO_ReceiptBasis
                                                                       ON MILO_ReceiptBasis.MovementItemId = MovementItem.Id
                                                                      AND MILO_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()

                               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = MILO_ReceiptBasis.ObjectId
                                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                               LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                                    ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = MILO_ReceiptBasis.ObjectId
                                                   AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()

                               LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                    ON ObjectLink_OrderType_Goods.ChildObjectId = MovementItem.GoodsId
                                                   AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                               LEFT JOIN ObjectLink AS OrderType_Unit
                                                    ON OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                   AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit() 
                          WHERE ((inisPeriodOrder = TRUE AND Movement.OperDate BETWEEN inStartDate AND inEndDate)
                             -- OR (inisPeriodOrder = FALSE AND (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime BETWEEN inStartDate AND inEndDate)
                                )
                              AND COALESCE (OrderType_Unit.ChildObjectId, Movement.ToId) IN (SELECT _tmpUnitTo.UnitId FROM _tmpUnitTo)
                          GROUP BY Movement.OperDate
                                 , MovementItem.GoodsId
                                 , ObjectLink_Receipt_GoodsKind.ChildObjectId
                                 , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis())
                                 , MILO_ReceiptBasis.ObjectId
                                 , COALESCE (OrderType_Unit.ChildObjectId,  Movement.ToId)
                                 , Movement.FromId
                                 , MIFloat_StartProductionInDays.ValueData
                                 , Movement.OperDate
                                 , Movement.Id
                                 , Movement.InvNumber
                                 , MIFloat_StartProductionInDays.ValueData
                          HAVING SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                              OR SUM (COALESCE (MIFloat_CuterCount.ValueData, 0) + COALESCE (MIFloat_CuterCountSecond.ValueData, 0)) <> 0
                         )

     -- Док. производства 
  , tmpMov_production AS (SELECT Movement.* 
                              , MLO_From.ObjectId   AS FromId
                              , MLO_To.ObjectId     AS ToId
                          FROM (SELECT (SELECT MIN (COALESCE (tmpMI_order2.OperDate_calc, tmpMI_order2.OperDate)) FROM tmpMI_order2) AS StartDate
                                     , (SELECT MAX (COALESCE (tmpMI_order2.OperDate_calc, tmpMI_order2.OperDate)) FROM tmpMI_order2) AS EndDate
                                ) AS tmpDate
                               INNER JOIN Movement ON Movement.OperDate BETWEEN tmpDate.StartDate AND tmpDate.EndDate
                                                 AND Movement.DescId = zc_Movement_ProductionUnion()
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()

                               LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                            ON MLO_DocumentKind.MovementId = Movement.Id
                                                           AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()

                               LEFT JOIN MovementLinkObject AS MLO_From
                                                            ON MLO_From.MovementId = Movement.Id
                                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
                               --INNER JOIN _tmpUnitTo AS tmpUnitTo ON tmpUnitTo.UnitId = MLO_From.ObjectId
 
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId = zc_MovementLinkObject_To()
                               INNER JOIN _tmpUnitTo ON _tmpUnitTo.UnitId = MLO_To.ObjectId
                          WHERE MLO_From.ObjectId = MLO_To.ObjectId
                            AND COALESCE (MLO_DocumentKind.ObjectId,0) = 0
                          )

  , tmpMI_prod AS (SELECT MovementItem.*
                   FROM MovementItem 
                         INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                   WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov_production.Id From tmpMov_production)
                     AND MovementItem.isErased   = FALSE
                     AND MovementItem.DescId     = zc_MI_Master()
                  )

  , tmpMovementItemFloat AS (SELECT *
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN ((SELECT DISTINCT tmpMI_prod.Id From tmpMI_prod))
                           )

  , tmpMovementItemLinkObject AS (SELECT *
                                  FROM MovementItemLinkObject
                                  WHERE MovementItemLinkObject.MovementItemId IN ((SELECT DISTINCT tmpMI_prod.Id From tmpMI_prod))
                                 )
 
    -- Док. производства 
  , tmpMI_production AS (SELECT Movement.Id                                                    AS MovementId
                              , Movement.InvNumber                                             AS InvNumber
                              , Movement.OperDate                                              AS OperDate
                              , (Movement.OperDate :: Date - COALESCE (ObjectFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime AS OperDate_calc            --дата заказа
                              , MovementItem.ObjectId                                          AS GoodsId
                              , MILO_GoodsKind.ObjectId                                        AS GoodsKindId
                              , MILO_GoodsKindComplete.ObjectId                                AS GoodsKindId_Complete
                              , MILO_Receipt.ObjectId                                          AS ReceiptId
                              , Movement.ToId                                                  AS ToId
                              , Movement.FromId                                                AS FromId
                              , MovementItem.Id                                                AS MovementItemId
                              , MovementItem.Amount                                            AS Amount
                              , COALESCE (MIFloat_CuterCount.ValueData, 0)                     AS CuterCount
                              , COALESCE ((ObjectBoolean_UnitFrom_PartionDate.ValueData = TRUE AND ObjectBoolean_UnitTo_PartionDate.ValueData = TRUE), FALSE) AS isPartionDate  
                              , ObjectFloat_StartProductionInDays.ValueData AS StartProductionInDays
                         FROM tmpMov_production AS Movement
                              INNER JOIN tmpMI_prod AS MovementItem 
                                                    ON MovementItem.MovementId = Movement.Id

                              INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                              LEFT JOIN tmpMovementItemFloat AS MIFloat_CuterCount
                                                             ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                              LEFT JOIN tmpMovementItemLinkObject AS MILO_GoodsKind
                                                                  ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              LEFT JOIN tmpMovementItemLinkObject AS MILO_GoodsKindComplete
                                                                  ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                 AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                              LEFT JOIN tmpMovementItemLinkObject AS MILO_Receipt
                                                                  ON MILO_Receipt.MovementItemId = MovementItem.Id
                                                                 AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_UnitFrom_PartionDate
                                                      ON ObjectBoolean_UnitFrom_PartionDate.ObjectId = Movement.FromId
                                                     AND ObjectBoolean_UnitFrom_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_UnitTo_PartionDate
                                                      ON ObjectBoolean_UnitTo_PartionDate.ObjectId = Movement.ToId
                                                     AND ObjectBoolean_UnitTo_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()

                              LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                   ON ObjectLink_OrderType_Goods.ChildObjectId = MovementItem.ObjectId
                                                  AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                              LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                                                    ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                   AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays() 
                          )

 /*       -- найти заказы для производства если в  _tmpListMaster нет такого
   , tmpMI_order3 AS (SELECT (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime AS OperDate_calc
                            , Movement.OperDate 
                            , Movement.Id                                                    AS MovementId
                            , Movement.InvNumber
                            , MAX (MovementItem.Id)                                          AS MovementItemId
                            , COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId)          AS GoodsId
                            , ObjectLink_Receipt_GoodsKind.ChildObjectId                     AS GoodsKindId
                            , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_Complete
                            , COALESCE (MILO_ReceiptBasis.ObjectId, 0)                       AS ReceiptId
                            -- , MLO_To.ObjectId                                                AS ToId
                            , COALESCE (OrderType_Unit.ChildObjectId,MLO_To.ObjectId)        AS ToId
                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                            , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountSecond
                            , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0) + COALESCE (MIFloat_CuterCountSecond.ValueData, 0)) AS CuterCount
                            , MIFloat_StartProductionInDays.ValueData AS StartProductionInDays
                       FROM (SELECT MIN (_tmpListMaster.OperDate_order) AS StartDate, MAX (_tmpListMaster.OperDate_order) AS EndDate
                             FROM _tmpListMaster
                             WHERE COALESCE (_tmpListMaster.MovementId_order,0) = 0) AS tmpDate
                             
                            INNER JOIN Movement ON Movement.OperDate BETWEEN tmpDate.StartDate AND tmpDate.EndDate
                                               AND Movement.DescId = zc_Movement_OrderInternal()
                                               AND Movement.StatusId <> zc_Enum_Status_Erased()
                            INNER JOIN MovementLinkObject AS MLO_To
                                                          ON MLO_To.MovementId = Movement.Id
                                                         AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                        -- AND MLO_To.ObjectId IN (SELECT _tmpUnitFrom.UnitId FROM _tmpUnitFrom)     --(inFromId, vbFromId_group)
 
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.isErased = FALSE
                                                   AND MovementItem.DescId     = zc_MI_Master()
 
                            LEFT JOIN MovementItemLinkObject AS MILO_Goods
                                                             ON MILO_Goods.MovementItemId = MovementItem.Id
                                                            AND MILO_Goods.DescId = zc_MILinkObject_Goods()
 
                            INNER JOIN (SELECT _tmpListMaster.GoodsId
                                        FROM _tmpListMaster
                                        WHERE COALESCE (_tmpListMaster.MovementId_order,0) = 0
                                        ) AS tmpGoods ON tmpGoods.GoodsId = COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId)
 
                            LEFT JOIN MovementItemFloat AS MIFloat_StartProductionInDays
                                                        ON MIFloat_StartProductionInDays.MovementItemId = MovementItem.Id 
                                                       AND MIFloat_StartProductionInDays.DescId = zc_MIFloat_StartProductionInDays()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                        ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                            LEFT JOIN MovementItemFloat AS MIFloat_CuterCountSecond
                                                        ON MIFloat_CuterCountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CuterCountSecond.DescId = zc_MIFloat_CuterCountSecond()
 
                            LEFT JOIN MovementItemLinkObject AS MILO_ReceiptBasis
                                                             ON MILO_ReceiptBasis.MovementItemId = MovementItem.Id
                                                            AND MILO_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
 
                            LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                 ON ObjectLink_Receipt_GoodsKind.ObjectId = MILO_ReceiptBasis.ObjectId
                                                AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                            LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                                 ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = MILO_ReceiptBasis.ObjectId
                                                AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
 
                            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                 ON ObjectLink_OrderType_Goods.ChildObjectId = COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId)
                                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                            LEFT JOIN ObjectLink AS OrderType_Unit
                                                 ON OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                AND OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
                       GROUP BY Movement.OperDate
                              , COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId)
                              , ObjectLink_Receipt_GoodsKind.ChildObjectId
                              , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis())
                              , MILO_ReceiptBasis.ObjectId
                              , COALESCE (OrderType_Unit.ChildObjectId,MLO_To.ObjectId)
                              , MIFloat_StartProductionInDays.ValueData  
                             , (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) 
                             , Movement.OperDate 
                             , Movement.InvNumber
                             , Movement.Id 
                       HAVING SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                           OR SUM (COALESCE (MIFloat_CuterCount.ValueData, 0) + COALESCE (MIFloat_CuterCountSecond.ValueData, 0)) <> 0
                      )
*/
        --
      , tmpMI_order22 AS (SELECT tmpMI.OperDate_calc
                               , tmpMI.OperDate       AS OperDate_order
                               , tmpMI.InvNumber      AS InvNumber_order
                               , tmpMI.MovementId     AS MovementId_order
                               , tmpMI.MovementItemId AS MovementItemId_order
                               , tmpMI.GoodsId
                               , tmpMI.GoodsKindId
                               , tmpMI.GoodsKindId_Complete
                               , tmpMI.ReceiptId
                               , tmpMI.StartProductionInDays  
                               , tmpMI.FromId
                               , tmpMI.ToId
                               , tmpMI.Amount
                               , CASE WHEN tmpMI.AmountSecond <> 0 THEN TRUE ELSE FALSE END AS isOrderSecond
                               , tmpMI.CuterCount
                          FROM tmpMI_order2 AS tmpMI   --(SELECT tmp.* FROM tmpMI_order2 AS tmp) AS tmpMI
                          --UNION SELECT tmp.* FROM tmpMI_order3 AS tmp) AS tmpMI
                          --     INNER JOIN _tmpUnitFrom ON _tmpUnitFrom.UnitId = tmpMI.ToId
                          --WHERE tmpMI.ToId = inToId
                         )

        , tmpMI_order_find AS (SELECT tmpMI_order22.MovementItemId_order    AS MovementItemId_order
                                    , MAX (tmpMI_production.MovementItemId) AS MovementItemId
                               FROM tmpMI_production
                                    INNER JOIN tmpMI_order22 ON tmpMI_order22.GoodsId       = tmpMI_production.GoodsId
                                                            AND tmpMI_order22.GoodsKindId   = tmpMI_production.GoodsKindId
                                                            AND tmpMI_order22.GoodsKindId_Complete = tmpMI_production.GoodsKindId_Complete
                                                            AND tmpMI_order22.ReceiptId     = tmpMI_production.ReceiptId
                                                            AND tmpMI_order22.OperDate_calc = tmpMI_production.OperDate
                                                            AND tmpMI_order22.ToId          = tmpMI_production.FromId  
                               GROUP BY tmpMI_order22.MovementItemId_order
                              )
       , tmpMI_order AS (SELECT tmpMI_order22.OperDate_calc
                              , tmpMI_order22.OperDate_order
                              , tmpMI_order22.InvNumber_order
                              , tmpMI_order22.MovementId_order
                              , tmpMI_order22.MovementItemId_order
                              , tmpMI_order22.GoodsId
                              , tmpMI_order22.GoodsKindId
                              , tmpMI_order22.GoodsKindId_Complete
                              , tmpMI_order22.ReceiptId 
                              , tmpMI_order22.StartProductionInDays
                              , tmpMI_order22.FromId
                              , tmpMI_order22.ToId
                              , tmpMI_order22.Amount
                              , tmpMI_order22.CuterCount
                              , tmpMI_order22.isOrderSecond
                              , COALESCE (tmpMI_order_find.MovementItemId, 0) AS MovementItemId_find
                              --, ROW_NUMBER() OVER (PARTITION by tmpMI_order22.MovementId_order, tmpMI_order22.MovementItemId_order) 
                         FROM tmpMI_order22
                              LEFT JOIN tmpMI_order_find ON tmpMI_order_find.MovementItemId_order = tmpMI_order22.MovementItemId_order
                         )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    INSERT INTO _tmpListMaster (MovementId, InvNumber, OperDate, FromId_prod, MovementItemId
                              , MovementId_order, InvNumber_order, OperDate_order, MovementItemId_order
                              , GoodsId, GoodsKindId, GoodsKindId_Complete, ReceiptId, StartProductionInDays
                              , Amount_Order, CuterCount_Order, Amount, CuterCount, isPartionDate, isOrderSecond
                              , TermProduction, PartionGoodsDate, PartionGoodsDateClose)
       WITH
       tmpAll AS (SELECT COALESCE (tmpMI_production.MovementId, 0)        AS MovementId
                       , COALESCE (tmpMI_production.InvNumber, '')        AS InvNumber
                       , COALESCE (tmpMI_production.OperDate, NULL)::TDateTime AS OperDate
                       , tmpMI_production.FromId                          AS FromId_prod
                       , COALESCE (tmpMI_production.MovementItemId,0)     AS MovementItemId
                       , tmpMI_order.MovementItemId_order                 AS MovementItemId_order 
                       , COALESCE (tmpMI_order.OperDate_order, tmpMI_production.OperDate_calc) AS OperDate_order
                       , tmpMI_order.InvNumber_order
                       , tmpMI_order.MovementId_order
                       , COALESCE (tmpMI_production.GoodsId, tmpMI_order.GoodsId)                           AS GoodsId
                       , COALESCE (tmpMI_production.GoodsKindId, tmpMI_order.GoodsKindId)                   AS GoodsKindId
                       , COALESCE (tmpMI_production.GoodsKindId_Complete, tmpMI_order.GoodsKindId_Complete) AS GoodsKindId_Complete
                       , COALESCE (tmpMI_production.ReceiptId, tmpMI_order.ReceiptId)                       AS ReceiptId
                       , COALESCE (tmpMI_order.Amount, 0)                 AS Amount_Order
                       , COALESCE (tmpMI_order.CuterCount, 0)             AS CuterCount_Order
                       , COALESCE (tmpMI_production.Amount, 0)            AS Amount
                       , COALESCE (tmpMI_production.CuterCount, 0)        AS CuterCount
                       , COALESCE (tmpMI_production.isPartionDate, FALSE) AS isPartionDate
                       , COALESCE (tmpMI_order.isOrderSecond, FALSE)      AS isOrderSecond 
                       , CASE WHEN COALESCE (tmpMI_order.StartProductionInDays,0 ) <> 0 THEN tmpMI_order.StartProductionInDays ELSE COALESCE (tmpMI_production.StartProductionInDays, 0) END AS StartProductionInDays
                      
                  FROM tmpMI_production
                       FULL JOIN tmpMI_order ON tmpMI_order.MovementItemId_find = tmpMI_production.MovementItemId
                  WHERE COALESCE (tmpMI_order.OperDate_order, tmpMI_production.OperDate_calc) BETWEEN inStartDate AND inEndDate
                  )

       SELECT tmp.MovementId
            , tmp.InvNumber
            , tmp.OperDate 
            , tmp.FromId_prod
            , tmp.MovementItemId 
            , tmp.MovementId_order
            , tmp.InvNumber_order
            , tmp.OperDate_order
            , tmp.MovementItemId_order
            , tmp.GoodsId
            , tmp.GoodsKindId
            , tmp.GoodsKindId_Complete
            , tmp.ReceiptId 
            , tmp.StartProductionInDays
            , tmp.Amount_Order
            , tmp.CuterCount_Order
            , tmp.Amount
            , tmp.CuterCount
            , tmp.isPartionDate
            , tmp.isOrderSecond
            , ObjectFloat_TermProduction.ValueData :: TFloat AS TermProduction
            , CASE WHEN tmp.isPartionDate = TRUE THEN tmp.OperDate ELSE (MIDate_PartionGoods.ValueData)  END :: TDateTime AS PartionGoodsDate
            , (CASE WHEN tmp.isPartionDate = TRUE THEN tmp.OperDate ELSE MIDate_PartionGoods.ValueData END
             + (COALESCE (ObjectFloat_TermProduction.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS PartionGoodsDateClose
       FROM tmpAll AS tmp
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = tmp.MovementItemId
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                      AND tmp.isPartionDate = FALSE
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = tmp.GoodsId
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                  ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                 AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
       ;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListMaster;


    -- для оптимизации - в Табл. 1
    CREATE TEMP TABLE _tmpRes_cur1 ON COMMIT DROP AS
      WITH
         tmpMIFloat AS (SELECT *
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT _tmpListMaster.MovementItemId From _tmpListMaster)
                        )
                        
       , tmpMIContainer1 AS (SELECT MIContainer.ContainerId
                                 , MIContainer.MovementItemId
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementItemId IN (SELECT DISTINCT _tmpListMaster.MovementItemId From _tmpListMaster)
                               AND DescId = zc_MIContainer_Count()   -- = 1
                             ) 
 
       , tmpMIContainer2 AS (SELECT MIContainer.ContainerId
                                  , MLO_From.ObjectId      AS FromId
                                  , MLO_To.ObjectId        AS ToId
                                  , SUM (MI_parent.Amount) AS Amount
                                  --, MIN (MovementDate_Insert.ValueData) AS OperDate_min
                                  , MAX (MovementDate_Insert.ValueData) AS OperDate_max
                             FROM MovementItemContainer AS MIContainer 
                                 INNER JOIN MovementLinkObject AS MLO_To
                                                               ON MLO_To.MovementId = MIContainer.MovementId
                                                              AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                              AND MLO_To.ObjectId IN (SELECT _tmpUnitFrom.UnitId FROM _tmpUnitFrom) 
                                 LEFT JOIN MovementLinkObject AS MLO_From
                                                              ON MLO_From.MovementId = MIContainer.MovementId
                                                             AND MLO_From.DescId = zc_MovementLinkObject_From()
                                 JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                                                  AND MovementItem.DescId = zc_MI_Child() -- =2 
                                 JOIN MovementItem AS MI_parent 
                                                   ON MI_parent.Id = MovementItem.ParentId
                                                  AND MI_parent.DescId = zc_MI_Master()  --1
                                -- LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                                 LEFT JOIN MovementDate AS MovementDate_Insert
                                                        ON MovementDate_Insert.MovementId = MIContainer.MovementId
                                                       AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
 
                             WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpMIContainer1.ContainerId FROM tmpMIContainer1)
                               AND MIContainer.MovementDescId = zc_Movement_ProductionUnion() 
                             GROUP BY MIContainer.ContainerId
                                    , MLO_To.ObjectId
                                    , MLO_From.ObjectId
                             )
       , tmpMIContainer AS (SELECT tmpMIContainer1.MovementItemId
                                 , tmpMIContainer2.FromId
                                 , tmpMIContainer2.ToId
                                 , SUM (tmpMIContainer2.Amount) AS Amount
                                -- , MIN (tmpMIContainer2.OperDate_min) AS OperDate_min
                                 , MAX (tmpMIContainer2.OperDate_max) AS OperDate_max
                            FROM tmpMIContainer1
                                 JOIN tmpMIContainer2 ON tmpMIContainer2.ContainerId = tmpMIContainer1.ContainerId
                            GROUP BY tmpMIContainer1.MovementItemId
                                   , tmpMIContainer2.FromId
                                   , tmpMIContainer2.ToId
                            )
       --док. взвешивания , для кот док. произв. смеш. явл. партией 
         , tmpPartionAll AS (SELECT MIFloat_MovementItemId.ValueData::Integer AS MovementItemId_prod
                              , MIFloat_MovementItemId.MovementItemId     AS MovementItemId
                         FROM MovementItemFloat AS MIFloat_MovementItemId
                         WHERE MIFloat_MovementItemId.ValueData IN (SELECT DISTINCT _tmpListMaster.MovementItemId FROM _tmpListMaster) 
                           AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                         )
         , tmpPartionWeight AS (SELECT tmpPartionAll.MovementItemId_prod
                                     , tmpPartionAll.MovementItemId
                                     , Movement.OperDate
                                     , MovementLinkObject_DocumentKind.ObjectId AS DocumentKindId
                                     , MovementItem.Amount
                               /*  , MAX (CASE WHEN MovementLinkObject_DocumentKind.ObjectId = zc_Enum_DocumentKind_CuterWeight() THEN MIDate_Insert.ValueData ELSE NULL::TDateTime END)            AS OperDate_cuter 
                                 , SUM (CASE WHEN MovementLinkObject_DocumentKind.ObjectId = zc_Enum_DocumentKind_CuterWeight() THEN Amount /*COALESCE (MIFloat_CuterWeight.ValueData,0)*/ ELSE 0 END) AS CuterWeight
                                 , MAX (CASE WHEN MovementLinkObject_DocumentKind.ObjectId = zc_Enum_DocumentKind_RealWeight() THEN MIDate_Insert.ValueData ELSE NULL ::TDateTime END )           AS OperDate_real
                                 , SUM (CASE WHEN MovementLinkObject_DocumentKind.ObjectId = zc_Enum_DocumentKind_RealWeight() THEN /*COALESCE (MIFloat_RealWeight.ValueData,0)*/ ELSE 0 END)  AS RealWeight
                                 */
                            FROM tmpPartionAll
                                 INNER JOIN MovementItem ON MovementItem.Id = tmpPartionAll.MovementItemId
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = False
                                 INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                    AND Movement.DescId = zc_Movement_WeighingProduction()
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                                              ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                                             AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                                                             AND MovementLinkObject_DocumentKind.ObjectId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight())
                                )
             
         , tmpMI_Weight AS (SELECT tmpPartionWeight.MovementItemId_prod
                                 --, MIFloat_MovementItemId.MovementItemId     AS MovementItemId
                                 --, Movement.OperDate
                                 --, MovementLinkObject_DocumentKind.ObjectId AS DocumentKindId                                                               
                                 , MAX (CASE WHEN tmpPartionWeight.DocumentKindId = zc_Enum_DocumentKind_CuterWeight() THEN MIDate_Insert.ValueData ELSE NULL   ::TDateTime END)  AS OperDate_cuter 
                                 , SUM (CASE WHEN tmpPartionWeight.DocumentKindId = zc_Enum_DocumentKind_CuterWeight() THEN tmpPartionWeight.Amount ELSE 0 END)                   AS CuterWeight
                                 , MAX (CASE WHEN tmpPartionWeight.DocumentKindId = zc_Enum_DocumentKind_RealWeight()  THEN MIDate_Insert.ValueData ELSE NULL   ::TDateTime END ) AS OperDate_real
                                 , SUM (CASE WHEN tmpPartionWeight.DocumentKindId = zc_Enum_DocumentKind_RealWeight()  THEN tmpPartionWeight.Amount ELSE 0 END)                   AS RealWeight
                            FROM tmpPartionWeight
                                 /*LEFT JOIN tmpMIFloat AS MIFloat_RealWeight
                                                      ON MIFloat_RealWeight.MovementItemId = tmpPartionWeight.MovementItemId
                                                     AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                                 LEFT JOIN tmpMIFloat AS MIFloat_CuterWeight
                                                      ON MIFloat_CuterWeight.MovementItemId = tmpPartionWeight.MovementItemId
                                                     AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()
                                */
                                 LEFT JOIN MovementItemDate AS MIDate_Insert
                                                            ON MIDate_Insert.MovementItemId = tmpPartionWeight.MovementItemId
                                                           AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                                                                                                     
                            GROUP BY tmpPartionWeight.MovementItemId_prod 
                                   --, MIFloat_MovementItemId.MovementItemId
                            )


         --  данные док. производства
       , tmpDataAll AS (SELECT _tmpListMaster.MovementId              AS MovementId
                               , _tmpListMaster.MovementItemId        AS MovementItemId
                               , _tmpListMaster.InvNumber             AS InvNumber
                               , _tmpListMaster.OperDate  ::TDateTime AS OperDate
                             --, _tmpListMaster.FromId_prod           AS FromId_prod 
                               , tmpMIContainer.FromId                AS FromId_prod
                               , tmpMIContainer.ToId                  AS ToId_prod
                               , _tmpListMaster.MovementId_order      AS MovementId_order
                               ,  _tmpListMaster.OperDate_order ::TDateTime AS OperDate_order
                               , _tmpListMaster.InvNumber_order       AS InvNumber_order
                               , _tmpListMaster.MovementItemId_order  AS MovementItemId_order
                               , _tmpListMaster.GoodsId
                               , _tmpListMaster.Amount
                               , _tmpListMaster.CuterCount
                               , _tmpListMaster.Amount_Order
                               , _tmpListMaster.CuterCount_Order
                               , _tmpListMaster.GoodsKindId
                               , _tmpListMaster.GoodsKindId_Complete
                               , _tmpListMaster.ReceiptId
                               , _tmpListMaster.StartProductionInDays
                               , _tmpListMaster.TermProduction
                               , _tmpListMaster.PartionGoodsDate
                               , _tmpListMaster.PartionGoodsDateClose
                             
                               , CASE WHEN _tmpListMaster.MovementItemId > 0 AND _tmpListMaster.MovementItemId <> _tmpListMaster.MovementItemId_order THEN COALESCE (MIBoolean_OrderSecond.ValueData, FALSE) ELSE _tmpListMaster.isOrderSecond END :: Boolean AS isOrderSecond

                               , COALESCE (MIBoolean_PartionClose.ValueData, FALSE) AS isPartionClose
                               , MIString_Comment.ValueData          AS Comment
                               , MIFloat_Count.ValueData             AS Count
                               , tmpMI_Weight.RealWeight             AS RealWeight
                               , tmpMI_Weight.CuterWeight            AS CuterWeight 
                               , MIFloat_RealWeightShp.ValueData ::TFloat  AS RealWeightShp
                               , MIFloat_RealWeightMsg.ValueData ::TFloat  AS RealWeightMsg 
                               , tmpMIContainer.Amount           ::TFloat  AS Amount_container 
                              -- , tmpMIContainer.OperDate_min  AS OperDate_ContainerMin
                               , tmpMIContainer.OperDate_max  AS OperDate_ContainerMax
                               , tmpMI_Weight.OperDate_cuter
                               , tmpMI_Weight.OperDate_real

                          FROM _tmpListMaster
                               LEFT JOIN MovementItemBoolean AS MIBoolean_OrderSecond
                                                             ON MIBoolean_OrderSecond.MovementItemId = _tmpListMaster.MovementItemId
                                                            AND MIBoolean_OrderSecond.DescId = zc_MIBoolean_OrderSecond()

                               LEFT JOIN tmpMIFloat AS MIFloat_Count
                                                    ON MIFloat_Count.MovementItemId = _tmpListMaster.MovementItemId
                                                   AND MIFloat_Count.DescId = zc_MIFloat_Count()
                                                   AND _tmpListMaster.MovementId <> 0
                               /*LEFT JOIN tmpMIFloat AS MIFloat_RealWeight
                                                    ON MIFloat_RealWeight.MovementItemId = _tmpListMaster.MovementItemId
                                                   AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                                                   AND _tmpListMaster.MovementId <> 0
                               LEFT JOIN tmpMIFloat AS MIFloat_CuterWeight
                                                    ON MIFloat_CuterWeight.MovementItemId = _tmpListMaster.MovementItemId
                                                   AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()
                                                   AND _tmpListMaster.MovementId <> 0
                               */
                               LEFT JOIN tmpMIFloat AS MIFloat_RealWeightShp
                                                    ON MIFloat_RealWeightShp.MovementItemId = _tmpListMaster.MovementItemId
                                                   AND MIFloat_RealWeightShp.DescId = zc_MIFloat_RealWeightShp()
                               LEFT JOIN tmpMIFloat AS MIFloat_RealWeightMsg
                                                    ON MIFloat_RealWeightMsg.MovementItemId = _tmpListMaster.MovementItemId
                                                   AND MIFloat_RealWeightMsg.DescId = zc_MIFloat_RealWeightMsg()
             
                               LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                                             ON MIBoolean_PartionClose.MovementItemId = _tmpListMaster.MovementItemId
                                                            AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()
                                                            AND _tmpListMaster.MovementId <> 0
                               LEFT JOIN MovementItemString AS MIString_Comment
                                                            ON MIString_Comment.MovementItemId = _tmpListMaster.MovementItemId
                                                           AND MIString_Comment.DescId = zc_MIString_Comment()
                                                           AND _tmpListMaster.MovementId <> 0 

                               LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = _tmpListMaster.MovementItemId
                               
                               LEFT JOIN tmpMI_Weight ON tmpMI_Weight.MovementItemId_prod = _tmpListMaster.MovementItemId
                               
                          )



       SELECT 0 AS MovementId      --tmp.MovementId
            , 0 AS MovementItemId  --tmp.MovementItemId
            , NULL ::TVarChar AS InvNumber --tmp.InvNumber 
            , tmp.OperDate
            , tmp.FromId_prod 
            , tmp.FromName_prod 
            , tmp.ToId_prod
            , tmp.ToName_prod

            , tmp.MovementId_order
            , tmp.MovementItemId_order
            , tmp.InvNumber_order
            , tmp.OperDate_order :: TDateTime
          
            , tmp.OperDate_cuter :: TDateTime
            , tmp.OperDate_real  :: TDateTime
            --, MIN (tmp.OperDate_ContainerMin) AS OperDate_ContainerMin
            , MAX (tmp.OperDate_ContainerMax) :: TDateTime AS OperDate_ContainerMax 

            , tmp.GoodsId
            , tmp.GoodsCode
            , tmp.GoodsName
            , tmp.isPartionClose
            
            , STRING_AGG (tmp.Comment, ';') AS Comment

            , tmp.GoodsKindId
            , tmp.GoodsKindCode
            , tmp.GoodsKindName
            , tmp.MeasureName
            , tmp.GoodsGroupNameFull
            , tmp.GoodsGroupId
            , tmp.GoodsGroupName

            , tmp.GoodsKindId_Complete
            , tmp.GoodsKindCode_Complete
            , tmp.GoodsKindName_Complete

            , tmp.ReceiptId
            , tmp.ReceiptCode
            , tmp.ReceiptName
            , tmp.Comment_receipt
            , tmp.isMain

            , tmp.TermProduction
            , tmp.PartionGoodsDate
            , tmp.PartionGoodsDateClose

            , tmp.isOrderSecond

            , SUM (tmp.Amount)       AS Amount
            , SUM (tmp.CuterCount)   AS CuterCount
            , SUM (tmp.Amount_calc)  AS Amount_calc
            
            , SUM (tmp.Amount_container) ::TFloat AS Amount_container
            
            , SUM (tmp.Count)           AS Count
            , SUM (tmp.RealWeight)      AS RealWeight
            , SUM (tmp.CuterWeight)     AS CuterWeight 
            , SUM (tmp.RealWeightShp) ::TFloat  AS RealWeightShp
            , SUM (tmp.RealWeightMsg) ::TFloat  AS RealWeightMsg

            , SUM (tmp.Amount_Order)    AS Amount_Order
            , SUM (tmp.CuterCount_Order) AS CuterCount_Order

            
            , tmp.StartProductionInDays
            
       FROM (SELECT _tmpListMaster.MovementId
                  , _tmpListMaster.MovementItemId 
                  , _tmpListMaster.InvNumber
                  , _tmpListMaster.OperDate 
                  , _tmpListMaster.FromId_prod 
                  , Object_Unit.ValueData     AS FromName_prod 
                  , Object_Unit_to.Id         AS ToId_prod
                  , Object_Unit_to.ValueData  AS ToName_prod
                  , _tmpListMaster.MovementId_order
                  , _tmpListMaster.MovementItemId_order
                  , _tmpListMaster.InvNumber_order
                  , _tmpListMaster.OperDate_order 
                  , _tmpListMaster.OperDate_cuter
                  , _tmpListMaster.OperDate_real
                 -- ,  (_tmpListMaster.OperDate_ContainerMin) AS OperDate_ContainerMin
                  ,  (_tmpListMaster.OperDate_ContainerMax) AS OperDate_ContainerMax                
                  , Object_Goods.Id                     AS GoodsId
                  , Object_Goods.ObjectCode             AS GoodsCode
                  , Object_Goods.ValueData              AS GoodsName
                  , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                  , Object_GoodsGroup.Id                        AS GoodsGroupId
                  , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                  , _tmpListMaster.Amount
                  , _tmpListMaster.CuterCount
                  , COALESCE (ObjectFloat_Receipt_Value.ValueData, 0) * _tmpListMaster.CuterCount AS  Amount_calc 
                  , _tmpListMaster.Amount_container 
                  , COALESCE (_tmpListMaster.isPartionClose, FALSE) AS isPartionClose
                  , _tmpListMaster.Comment
                  , _tmpListMaster.Count
                  , _tmpListMaster.RealWeight
                  , _tmpListMaster.CuterWeight 
                  , _tmpListMaster.RealWeightShp
                  , _tmpListMaster.RealWeightMsg
                  , _tmpListMaster.Amount_Order
                  , _tmpListMaster.CuterCount_Order
                  , _tmpListMaster.StartProductionInDays
                  , Object_GoodsKind.Id                 AS GoodsKindId
                  , Object_GoodsKind.ObjectCode         AS GoodsKindCode
                  , Object_GoodsKind.ValueData          AS GoodsKindName
                  , Object_Measure.ValueData            AS MeasureName
                  , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
                  , Object_GoodsKindComplete.ObjectCode AS GoodsKindCode_Complete
                  , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete
                  , Object_Receipt.Id                   AS ReceiptId
                  , ObjectString_Receipt_Code.ValueData AS ReceiptCode
                  , Object_Receipt.ValueData            AS ReceiptName
                  , ObjectString_Receipt_Comment.ValueData AS Comment_receipt
                  , COALESCE (ObjectBoolean_Receipt_Main.ValueData, FALSE) ::Boolean   AS isMain
                  , _tmpListMaster.TermProduction
                  , _tmpListMaster.PartionGoodsDate
                  , _tmpListMaster.PartionGoodsDateClose
                  , _tmpListMaster.isOrderSecond


             FROM tmpDataAll AS _tmpListMaster
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpListMaster.GoodsId
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpListMaster.GoodsKindId
                   LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpListMaster.GoodsKindId_Complete
                   LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = _tmpListMaster.ReceiptId
                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpListMaster.FromId_prod
                   LEFT JOIN Object AS Object_Unit_to ON Object_Unit_to.Id = _tmpListMaster.ToId_prod
      
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
      
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
      
                   LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                          ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                         AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                   LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                   LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                          ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                         AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
                   LEFT JOIN ObjectString AS ObjectString_Receipt_Comment
                                          ON ObjectString_Receipt_Comment.ObjectId = Object_Receipt.Id
                                         AND ObjectString_Receipt_Comment.DescId = zc_ObjectString_Receipt_Comment()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Receipt_Main
                                           ON ObjectBoolean_Receipt_Main.ObjectId = Object_Receipt.Id
                                          AND ObjectBoolean_Receipt_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Receipt_Value
                                         ON ObjectFloat_Receipt_Value.ObjectId = Object_Receipt.Id
                                        AND ObjectFloat_Receipt_Value.DescId = zc_ObjectFloat_Receipt_Value()
                ) AS tmp
             GROUP BY /*tmp.MovementId
                    , tmp.MovementItemId */
                      tmp.FromId_prod
                    , tmp.FromName_prod  
                    , tmp.ToId_prod 
                    , tmp.ToName_prod
                    , tmp.MovementId_order
                    , tmp.MovementItemId_order
                    , tmp.InvNumber_order
                    , tmp.OperDate_order
                    --, tmp.InvNumber
                    , tmp.OperDate
                    , tmp.GoodsId
                    , tmp.GoodsCode
                    , tmp.GoodsName
                    , tmp.isPartionClose       
                    , tmp.GoodsKindId
                    , tmp.GoodsKindCode
                    , tmp.GoodsKindName
                    , tmp.GoodsGroupNameFull 
                    , tmp.GoodsGroupId
                    , tmp.GoodsGroupName
                    , tmp.MeasureName
                    , tmp.GoodsKindId_Complete
                    , tmp.GoodsKindCode_Complete
                    , tmp.GoodsKindName_Complete
                    , tmp.ReceiptId
                    , tmp.ReceiptCode
                    , tmp.ReceiptName
                    , tmp.Comment_receipt
                    , tmp.isMain
                    , tmp.TermProduction
                    , tmp.PartionGoodsDate
                    , tmp.PartionGoodsDateClose
                    , tmp.isOrderSecond 
                    , tmp.StartProductionInDays
                    --, tmp.OperDate_fact 
                    , tmp.OperDate_cuter
                    , tmp.OperDate_real
           ;

    -- Результат
    RETURN QUERY

    SELECT    tmpData.MovementId
            , tmpData.MovementItemId
            , tmpData.InvNumber :: TVarChar
            , tmpData.OperDate  :: TDateTime
            , tmpData.FromId_prod   :: Integer
            , tmpData.FromName_prod :: TVarChar 
            , tmpData.ToId_prod   :: Integer
            , tmpData.ToName_prod :: TVarChar
            
            , tmpData.MovementId_order
            , tmpData.MovementItemId_order
            , tmpData.InvNumber_order :: TVarChar
            , tmpData.OperDate_order  :: TDateTime 
            
            ,  (tmpData.OperDate_cuter)         :: TDateTime AS OperDate_cuter
            ,  (tmpData.OperDate_real)          :: TDateTime AS OperDate_real
         -- ,  (tmpData.OperDate_ContainerMin)  :: TVarChar AS OperDate_ContainerMin    --zfConvert_DateToString
            , (tmpData.OperDate_ContainerMax)  :: TDateTime AS OperDate_ContainerMax    --zfConvert_DateToString
            , tmpData.GoodsId
            , tmpData.GoodsCode 
            , tmpData.GoodsName       :: TVarChar

            , tmpData.Amount          :: TFloat
            , tmpData.CuterCount      :: TFloat
            , tmpData.Amount_calc     :: TFloat
            , tmpData.Amount_container ::TFloat

            , tmpData.isPartionClose

            , tmpData.Comment         :: TVarChar
            , tmpData.Count           :: TFloat
            , tmpData.RealWeight      :: TFloat
            , tmpData.CuterWeight     :: TFloat
            , tmpData.RealWeightShp   :: TFloat
            , tmpData.RealWeightMsg   :: TFloat

            , tmpData.Amount_Order     :: TFloat
            , tmpData.CuterCount_Order :: TFloat
            
            , (tmpData.Amount - tmpData.Amount_Order)         ::TFloat AS Amount_diff
            , (tmpData.CuterCount - tmpData.CuterCount_Order) ::TFloat AS CuterCount_diff

            , tmpData.GoodsKindId
            , tmpData.GoodsKindCode
            , tmpData.GoodsKindName
            , tmpData.MeasureName
            , tmpData.GoodsGroupNameFull
            , tmpData.GoodsGroupId
            , tmpData.GoodsGroupName

            , tmpData.GoodsKindId_Complete
            , tmpData.GoodsKindCode_Complete
            , tmpData.GoodsKindName_Complete

            , tmpData.ReceiptId
            , tmpData.ReceiptCode
            , tmpData.ReceiptName
            , tmpData.Comment_receipt
            , tmpData.isMain


            , tmpData.TermProduction        :: TFloat
            , tmpData.PartionGoodsDate      :: tdatetime
            , tmpData.PartionGoodsDateClose :: tdatetime

            , tmpData.isOrderSecond

            , tmpData.StartProductionInDays
    FROM _tmpRes_cur1 AS tmpData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР

               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.23         *
*/

-- тест
-- select * from gpReport_ProductionUnionTech_Analys(inStartDate := ('11.09.2023')::TDateTime , inEndDate := ('11.09.2023')::TDateTime , inFromId := 8447 , inToId := 8447 , inGoodsGroupId:=0, inisPeriodOrder := 'true',  inSession := '5')

--select * from gpReport_ProductionUnionTech_Analys(inStartDate := ('11.09.2023')::TDateTime , inEndDate := ('11.09.2023')::TDateTime , inFromId := 8447 , inToId := 8447 , inGoodsGroupId:=0, inisPeriodOrder := 'False',  inSession := '5')
--select * from gpReport_ProductionUnionTech_Analys(inStartDate := ('30.09.2023')::TDateTime , inEndDate := ('30.09.2023')::TDateTime , inFromId := 8447 , inToId := 8447 , inGoodsGroupId := 0 , inisPeriodOrder := 'True' ,  inSession := '9457');
--select * from gpReport_ProductionUnionTech_Analys(inStartDate := ('30.09.2023')::TDateTime , inEndDate := ('30.09.2023')::TDateTime , inFromId := 8447 , inToId := 8447 , inGoodsGroupId := 0 , inisPeriodOrder := 'True' ,  inSession := '9457');
