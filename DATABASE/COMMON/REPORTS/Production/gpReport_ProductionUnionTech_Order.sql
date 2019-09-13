-- Function: gpReport_ProductionUnionTech_Order()

DROP FUNCTION IF EXISTS gpReport_ProductionUnionTech_Order (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ProductionUnionTech_Order (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ProductionUnionTech_Order (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProductionUnionTech_Order(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inFromId            Integer,
    IN inToId              Integer,
    IN inisMovement        Boolean,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (LineNum             Integer
             , MovementId          Integer
             , MovementItemId      Integer
             , MovementItemId_order  Integer
             , InvNumber           TVarChar
             , OperDate            TDateTime
             , DocumentKindId      Integer
             , DocumentKindName    TVarChar
             , GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , Amount              TFloat
             , CuterCount          TFloat
             , Amount_calc         TFloat
             , isPartionClose      Boolean
             , Comment             TVarChar
             , Count               TFloat
             , RealWeight          TFloat
             , CuterWeight         TFloat
             , Amount_Order        TFloat
             , CuterCount_Order    TFloat
             , Amount_diff         TFloat
             , CuterCount_diff     TFloat
             , GoodsKindId         Integer
             , GoodsKindCode       Integer
             , GoodsKindName       TVarChar
             , MeasureName         TVarChar
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
             , StatusCode          Integer
             , StatusName          TVarChar
             /*, InsertName          TVarChar
             , UpdateName          TVarChar
             , InsertDate          TDateTime
             , UpdateDate          TDateTime
*/
             --, MovementId_fact     Integer
             --, InvNumber_fact      TVarChar
             , OperDate_fact       TDateTime
             , Amount_fact         TFloat

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

     -- определяется
     vbFromId_group:= (SELECT ObjectLink_Parent.ChildObjectId FROM ObjectLink AS ObjectLink_Parent WHERE ObjectLink_Parent.ObjectId = inFromId AND ObjectLink_Parent.DescId = zc_ObjectLink_Unit_Parent());
     -- 
     CREATE TEMP TABLE _tmpListMaster (MovementId Integer, StatusId Integer, InvNumber TVarChar, OperDate TDateTime, DocumentKindId integer,MovementItemId Integer, MovementItemId_order Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_Complete Integer, ReceiptId Integer
                                     , Amount_Order TFloat, CuterCount_Order TFloat, Amount TFloat, CuterCount TFloat, isPartionDate Boolean, isOrderSecond Boolean
                                     , TermProduction TFloat, PartionGoodsDate TVarChar, PartionGoodsDateClose TDateTime) ON COMMIT DROP;

     -- определяется - ЦЕХ колбаса+дел-сы
     vbIsOrder:= (inFromId = inToId) AND EXISTS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect WHERE lfSelect.UnitId = inFromId);


     WITH tmpMI_order2 AS (SELECT (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime AS OperDate
                               , MAX (MovementItem.Id)                                          AS MovementItemId
                               , COALESCE (MILO_Goods.ObjectId, MovementItem.ObjectId)          AS GoodsId
                               , ObjectLink_Receipt_GoodsKind.ChildObjectId                     AS GoodsKindId
                               , COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_Complete
                               , COALESCE (MILO_ReceiptBasis.ObjectId, 0)                       AS ReceiptId
                               -- , MLO_To.ObjectId                                                AS ToId
                               , OrderType_Unit.ChildObjectId                                   AS ToId
                               , SUM (CASE WHEN (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime
                                                BETWEEN inStartDate AND inEndDate
                                                THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                           ELSE 0
                                      END) AS Amount
                               , SUM (CASE WHEN (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime
                                                BETWEEN inStartDate AND inEndDate
                                                THEN COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                           ELSE 0
                                      END) AS AmountSecond
                               , SUM (CASE WHEN (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime
                                                BETWEEN inStartDate AND inEndDate
                                                THEN COALESCE (MIFloat_CuterCount.ValueData, 0) + COALESCE (MIFloat_CuterCountSecond.ValueData, 0)
                                           ELSE 0
                                      END) AS CuterCount
                          FROM (SELECT (inStartDate - INTERVAL '5 DAY') AS StartDate, (inEndDate + INTERVAL '5 DAY') AS EndDate WHERE vbIsOrder = TRUE) AS tmpDate
                               INNER JOIN Movement ON Movement.OperDate BETWEEN tmpDate.StartDate AND tmpDate.EndDate
                                                  AND Movement.DescId = zc_Movement_OrderInternal()
                                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                               INNER JOIN MovementLinkObject AS MLO_To
                                                             ON MLO_To.MovementId = Movement.Id
                                                            AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                            AND MLO_To.ObjectId IN (inFromId, vbFromId_group)

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.isErased = FALSE
                                                      AND MovementItem.DescId     = zc_MI_Master()

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
                               LEFT JOIN MovementItemLinkObject AS MILO_Goods
                                                                ON MILO_Goods.MovementItemId = MovementItem.Id
                                                               AND MILO_Goods.DescId = zc_MILinkObject_Goods()
                               LEFT JOIN MovementItemLinkObject AS MILO_ReceiptBasis
                                                                ON MILO_ReceiptBasis.MovementItemId = MovementItem.Id
                                                               AND MILO_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                               LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                            ON MLO_DocumentKind.MovementId = Movement.Id
                                                           AND MLO_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()

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
                                 , OrderType_Unit.ChildObjectId
                                 , MIFloat_StartProductionInDays.ValueData
                          HAVING SUM (CASE WHEN (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime
                                                BETWEEN inStartDate AND inEndDate
                                                THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                           ELSE 0
                                      END) <> 0
                              OR SUM (CASE WHEN (Movement.OperDate :: Date + COALESCE (MIFloat_StartProductionInDays.ValueData, 0) :: Integer) :: TDateTime
                                                BETWEEN inStartDate AND inEndDate
                                                THEN COALESCE (MIFloat_CuterCount.ValueData, 0) + COALESCE (MIFloat_CuterCountSecond.ValueData, 0)
                                           ELSE 0
                                      END) <> 0
                         )
   , tmpMI_production AS (SELECT Movement.Id                                                    AS MovementId
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
                              AND MLO_From.ObjectId = inFromId
                              AND MLO_To.ObjectId = inToId
                           )
      , tmpMI_order22 AS (SELECT tmpMI_order2.OperDate
                               , tmpMI_order2.MovementItemId AS MovementItemId_order
                               , tmpMI_order2.GoodsId
                               , tmpMI_order2.GoodsKindId
                               , tmpMI_order2.GoodsKindId_Complete
                               , tmpMI_order2.ReceiptId
                               , tmpMI_order2.ToId
                               , tmpMI_order2.Amount
                               , CASE WHEN tmpMI_order2.AmountSecond <> 0 THEN TRUE ELSE FALSE END AS isOrderSecond
                               , tmpMI_order2.CuterCount
                          FROM tmpMI_order2
                          WHERE tmpMI_order2.ToId = inFromId
                         )
        , tmpMI_order_find AS (SELECT tmpMI_order22.MovementItemId_order    AS MovementItemId_order
                                    , MAX (tmpMI_production.MovementItemId) AS MovementItemId
                               FROM tmpMI_production
                                    INNER JOIN tmpMI_order22 ON tmpMI_order22.GoodsId = tmpMI_production.GoodsId
                                                           AND tmpMI_order22.GoodsKindId = tmpMI_production.GoodsKindId
                                                           AND tmpMI_order22.GoodsKindId_Complete = tmpMI_production.GoodsKindId_Complete
                                                           AND tmpMI_order22.ReceiptId = tmpMI_production.ReceiptId
                                                           AND tmpMI_order22.OperDate = tmpMI_production.OperDate
                                                           AND tmpMI_order22.ToId = tmpMI_production.FromId
                               WHERE tmpMI_production.StatusId <> zc_Enum_Status_Erased()
                               GROUP BY tmpMI_order22.MovementItemId_order
                              )
       , tmpMI_order AS (SELECT tmpMI_order22.OperDate
                              , tmpMI_order22.MovementItemId_order
                              , tmpMI_order22.GoodsId
                              , tmpMI_order22.GoodsKindId
                              , tmpMI_order22.GoodsKindId_Complete
                              , tmpMI_order22.ReceiptId
                              , tmpMI_order22.ToId
                              , tmpMI_order22.Amount
                              , tmpMI_order22.CuterCount
                              , tmpMI_order22.isOrderSecond
                              , COALESCE (tmpMI_order_find.MovementItemId, 0) AS MovementItemId_find
                         FROM tmpMI_order22
                              LEFT JOIN tmpMI_order_find ON tmpMI_order_find.MovementItemId_order = tmpMI_order22.MovementItemId_order
                         )

    -- !!!!!!!!!!!!!!!!!!!!!!!
    INSERT INTO _tmpListMaster (MovementId, StatusId, InvNumber, OperDate, DocumentKindId
                              , MovementItemId, MovementItemId_order
                              , GoodsId, GoodsKindId, GoodsKindId_Complete, ReceiptId
                              , Amount_Order, CuterCount_Order, Amount, CuterCount, isPartionDate, isOrderSecond
                              , TermProduction, PartionGoodsDate, PartionGoodsDateClose)
       WITH
       tmpAll AS (SELECT COALESCE (tmpMI_production.MovementId, 0)AS MovementId
                       , COALESCE (tmpMI_production.StatusId, 0)  AS StatusId
                       , COALESCE (tmpMI_production.InvNumber, '') AS InvNumber
                       , COALESCE (tmpMI_production.OperDate, tmpMI_order.OperDate) AS OperDate
                       , COALESCE (tmpMI_production.DocumentKindId, 0)AS DocumentKindId
                       , COALESCE (tmpMI_production.MovementItemId, tmpMI_order.MovementItemId_order) AS MovementItemId
                       , tmpMI_order.MovementItemId_order                  AS MovementItemId_order
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
           
                  FROM tmpMI_production
                       FULL JOIN tmpMI_order ON tmpMI_order.MovementItemId_find = tmpMI_production.MovementItemId
                  )

       SELECT tmp.MovementId
            , tmp.StatusId
            , tmp.InvNumber
            , tmp.OperDate
            , tmp.DocumentKindId
            , tmp.MovementItemId
            , tmp.MovementItemId_order
            , tmp.GoodsId
            , tmp.GoodsKindId
            , tmp.GoodsKindId_Complete
            , tmp.ReceiptId
            , tmp.Amount_Order
            , tmp.CuterCount_Order
            , tmp.Amount
            , tmp.CuterCount
            , tmp.isPartionDate
            , tmp.isOrderSecond
            , ObjectFloat_TermProduction.ValueData :: TFloat AS TermProduction
            , CASE WHEN tmp.isPartionDate = TRUE THEN TO_CHAR (tmp.OperDate, 'DD.MM.YYYY') ELSE '*' || TO_CHAR (MIDate_PartionGoods.ValueData, 'DD.MM.YYYY')  END :: TVarChar AS PartionGoodsDate
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
      WITH tmpStatus AS (SELECT 0                           AS StatusId
                   UNION SELECT zc_Enum_Status_Complete()   AS StatusId
                   UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                        )
           -- показать дата выхода факт, и кол-ва, может быть тоже по № документа,  
           --т.е. док произв цех-цех - это то что сделали,  в нем есть дата партии (это дата док, например 01.09) 
           --а к нему нужно найти док произв цех-склад база (zc_MI_Master с такой же датой - zc_MIDate_PartionGoods) - это выход факт, и даты документов могут быть 3,4,5.09
         , tmpFact_production AS (SELECT /*Movement.Id                                                    AS MovementId
                                       , Movement.StatusId                                              AS StatusId
                                       , Movement.InvNumber                                             AS InvNumber
                                       ,*/ MAX(Movement.OperDate)                                              AS OperDate
                                       , MovementItem.ObjectId                                          AS GoodsId
                                       , MILO_GoodsKind.ObjectId                                        AS GoodsKindId
                                       , MILO_GoodsKindComplete.ObjectId                                AS GoodsKindId_Complete
                                       , MILO_Receipt.ObjectId                                          AS ReceiptId
                                       , SUM (MovementItem.Amount)                                            AS Amount
                                       , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))                     AS CuterCount
                                       , TO_CHAR (MIDate_PartionGoods.ValueData, 'DD.MM.YYYY') :: TVarChar AS PartionGoodsDate
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
                                       LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                  ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                                 AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                    WHERE Movement.OperDate BETWEEN inStartDate - INTERVAL '2 DAY' AND inEndDate + INTERVAL '10 DAY'
                                      AND Movement.DescId = zc_Movement_ProductionUnion()
                                      AND MLO_From.ObjectId = inFromId
                                      AND MLO_To.ObjectId <> inFromId
                                    GROUP BY MovementItem.ObjectId
                                       , MILO_GoodsKind.ObjectId
                                       , MILO_GoodsKindComplete.ObjectId
                                       , MILO_Receipt.ObjectId
                                       , TO_CHAR (MIDate_PartionGoods.ValueData, 'DD.MM.YYYY')
                                    )

       SELECT tmp.LineNum
            , tmp.MovementId
            , tmp.MovementItemId
            , tmp.MovementItemId_order
            , tmp.InvNumber
            , tmp.OperDate
            , tmp.DocumentKindId
            , tmp.DocumentKindName

            , tmp.GoodsId
            , tmp.GoodsCode
            , tmp.GoodsName
            , tmp.isPartionClose
            
            , STRING_AGG (tmp.Comment, ';')       AS Comment

            , tmp.GoodsKindId
            , tmp.GoodsKindCode
            , tmp.GoodsKindName
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

            , SUM (tmp.Amount)       AS Amount
            , SUM (tmp.CuterCount)   AS CuterCount
            , SUM (tmp.Amount_calc)  AS Amount_calc
            
            , SUM (tmp.Count)           AS Count
            , SUM (tmp.RealWeight)      AS RealWeight
            , SUM (tmp.CuterWeight)     AS CuterWeight 

            , SUM (tmp.Amount_Order)    AS Amount_Order
            , SUM (tmp.CuterCount_Order) AS CuterCount_Order

            , tmp.StatusCode
            , tmp.StatusName

            --, tmpFact_production.MovementId  ::Integer   AS MovementId_fact
            --, tmpFact_production.InvNumber   ::TVarChar  AS InvNumber_fact
            , tmp.OperDate_fact
            , SUM (tmp.Amount_fact)      ::TFloat    AS Amount_fact

       FROM (SELECT CASE WHEN inisMovement = TRUE THEN CASE WHEN _tmpListMaster.MovementId <> 0 THEN row_number() OVER (ORDER BY CASE WHEN _tmpListMaster.MovementId <> 0 THEN _tmpListMaster.MovementItemId ELSE NULL END) ELSE 0 END ELSE 0 END:: Integer AS LineNum
                  , CASE WHEN inisMovement = TRUE THEN _tmpListMaster.MovementId ELSE 0 END            AS MovementId
                  , CASE WHEN inisMovement = TRUE THEN _tmpListMaster.MovementItemId ELSE 0 END        AS MovementItemId
                  , CASE WHEN inisMovement = TRUE THEN _tmpListMaster.MovementItemId_order ELSE 0 END  AS MovementItemId_order
                  , CASE WHEN inisMovement = TRUE THEN _tmpListMaster.InvNumber ELSE '' END            AS InvNumber
                  , CASE WHEN inisMovement = TRUE THEN _tmpListMaster.OperDate ELSE NULL END              AS OperDate
                  , CASE WHEN inisMovement = TRUE THEN _tmpListMaster.DocumentKindId ELSE 0 END        AS DocumentKindId
                  , CASE WHEN inisMovement = TRUE THEN Object_DocumentKind.ValueData ELSE '' END       AS DocumentKindName
                  , Object_Goods.Id                   AS GoodsId
                  , Object_Goods.ObjectCode           AS GoodsCode
                  , Object_Goods.ValueData            AS GoodsName
                  , _tmpListMaster.Amount
                  , _tmpListMaster.CuterCount
                  , COALESCE (ObjectFloat_Receipt_Value.ValueData, 0) * _tmpListMaster.CuterCount AS  Amount_calc
                  , COALESCE (MIBoolean_PartionClose.ValueData, FALSE) AS isPartionClose
                  , MIString_Comment.ValueData        AS Comment
                  , MIFloat_Count.ValueData           AS Count
                  , MIFloat_RealWeight.ValueData      AS RealWeight
                  , MIFloat_CuterWeight.ValueData     AS CuterWeight 
                  , _tmpListMaster.Amount_Order
                  , _tmpListMaster.CuterCount_Order
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
                  , ObjectString_Receipt_Comment.ValueData AS Comment_receipt
                  , ObjectBoolean_Receipt_Main.ValueData   AS isMain
                  , _tmpListMaster.TermProduction
                  , _tmpListMaster.PartionGoodsDate
                  , _tmpListMaster.PartionGoodsDateClose
                  , CASE WHEN _tmpListMaster.MovementItemId > 0 AND _tmpListMaster.MovementItemId <> _tmpListMaster.MovementItemId_order THEN COALESCE (MIBoolean_OrderSecond.ValueData, FALSE) ELSE _tmpListMaster.isOrderSecond END :: Boolean AS isOrderSecond
                  , CASE WHEN inisMovement = TRUE THEN Object_Status.ObjectCode ELSE 0 END   AS StatusCode
                  , CASE WHEN inisMovement = TRUE THEN Object_Status.ValueData  ELSE '' END  AS StatusName
                  --, tmpFact_production.MovementId  ::Integer   AS MovementId_fact
                  --, tmpFact_production.InvNumber   ::TVarChar  AS InvNumber_fact
                  , tmpFact_production.OperDate    ::TDateTime AS OperDate_fact
                  , COALESCE (tmpFact_production.Amount,0)      ::TFloat    AS Amount_fact

             FROM _tmpListMaster
                   INNER JOIN tmpStatus ON tmpStatus.StatusId = _tmpListMaster.StatusId
      
                   LEFT JOIN MovementItemBoolean AS MIBoolean_OrderSecond
                                                 ON MIBoolean_OrderSecond.MovementItemId = _tmpListMaster.MovementItemId
                                                AND MIBoolean_OrderSecond.DescId = zc_MIBoolean_OrderSecond()
      
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
      
                   LEFT JOIN MovementItemBoolean AS MIBoolean_PartionClose
                                                 ON MIBoolean_PartionClose.MovementItemId = _tmpListMaster.MovementItemId
                                                AND MIBoolean_PartionClose.DescId = zc_MIBoolean_PartionClose()
                                                AND _tmpListMaster.MovementId <> 0
                   LEFT JOIN MovementItemString AS MIString_Comment
                                                ON MIString_Comment.MovementItemId = _tmpListMaster.MovementItemId
                                               AND MIString_Comment.DescId = zc_MIString_Comment()
                                               AND _tmpListMaster.MovementId <> 0
      
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpListMaster.GoodsId
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpListMaster.GoodsKindId
                   LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpListMaster.GoodsKindId_Complete
                   LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = _tmpListMaster.ReceiptId
                   LEFT JOIN Object AS Object_Status ON Object_Status.Id = _tmpListMaster.StatusId
                   LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = _tmpListMaster.DocumentKindId
      
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
      
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
      
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
      
                   LEFT JOIN tmpFact_production ON tmpFact_production.GoodsId              = _tmpListMaster.GoodsId
                                               AND tmpFact_production.GoodsKindId          = COALESCE (_tmpListMaster.GoodsKindId_Complete,0) --_tmpListMaster.GoodsKindId
                                          --    AND COALESCE (tmpFact_production.GoodsKindId_Complete,0) = COALESCE (_tmpListMaster.GoodsKindId_Complete,0)
                                             --  AND tmpFact_production.ReceiptId            = _tmpListMaster.ReceiptId
                                              -- AND tmpFact_production.FromId               = _tmpListMaster.FromId
                                               AND tmpFact_production.PartionGoodsDate :: tdatetime    = _tmpListMaster.PartionGoodsDate :: tdatetime
                ) AS tmp
             GROUP BY tmp.LineNum
                    , tmp.MovementId
                    , tmp.MovementItemId
                    , tmp.MovementItemId_order
                    , tmp.InvNumber
                    , tmp.OperDate
                    , tmp.DocumentKindId
                    , tmp.DocumentKindName
                    , tmp.GoodsId
                    , tmp.GoodsCode
                    , tmp.GoodsName
                    , tmp.isPartionClose       
                    , tmp.GoodsKindId
                    , tmp.GoodsKindCode
                    , tmp.GoodsKindName
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
                    , tmp.StatusCode
                    , tmp.StatusName
                    , tmp.OperDate_fact
           ;

    -- Результат
    RETURN QUERY
    SELECT    tmpData.LineNum
            , tmpData.MovementId
            , tmpData.MovementItemId
            , tmpData.MovementItemId_order
            , tmpData.InvNumber :: TVarChar
            , tmpData.OperDate  :: TDateTime
            , tmpData.DocumentKindId
            , tmpData.DocumentKindName :: TVarChar

            , tmpData.GoodsId
            , tmpData.GoodsCode 
            , tmpData.GoodsName :: TVarChar

            , tmpData.Amount      :: TFloat
            , tmpData.CuterCount  :: TFloat
            , tmpData.Amount_calc :: TFloat

            , tmpData.isPartionClose

            , tmpData.Comment   :: TVarChar
            , tmpData.Count :: TFloat
            , tmpData.RealWeight :: TFloat
            , tmpData.CuterWeight  :: TFloat

            , tmpData.Amount_Order :: TFloat
            , tmpData.CuterCount_Order :: TFloat
            
            , (tmpData.Amount - tmpData.Amount_Order)         ::TFloat AS Amount_diff
            , (tmpData.CuterCount - tmpData.CuterCount_Order) ::TFloat AS CuterCount_diff

            , tmpData.GoodsKindId
            , tmpData.GoodsKindCode
            , tmpData.GoodsKindName
            , tmpData.MeasureName

            , tmpData.GoodsKindId_Complete
            , tmpData.GoodsKindCode_Complete
            , tmpData.GoodsKindName_Complete

            , tmpData.ReceiptId
            , tmpData.ReceiptCode
            , tmpData.ReceiptName
            , tmpData.Comment_receipt
            , tmpData.isMain


            , tmpData.TermProduction
            , tmpData.PartionGoodsDate      :: tdatetime
            , tmpData.PartionGoodsDateClose :: tdatetime

            , tmpData.isOrderSecond
            , tmpData.StatusCode
            , tmpData.StatusName :: TVarChar

           /* , tmpData.InsertName
            , tmpData.UpdateName
            , tmpData.InsertDate
            , tmpData.UpdateDate
*/
            --, tmpData.MovementId_fact
            --, tmpData.InvNumber_fact
            , tmpData.OperDate_fact
            , tmpData.Amount_fact     :: TFloat

    FROM _tmpRes_cur1 AS tmpData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР

               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.09.19         *
*/

-- тест
--SELECT * FROM gpReport_ProductionUnionTech_Order (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE, inFromId:= 8447, inToId:= 8447, inSession:= zfCalc_UserAdmin()); 
-- FETCH ALL "<unnamed portal 1>";
--SELECT * FROM gpReport_ProductionUnionTech_Order (inStartDate:= '10.09.2019'::tdatetime, inEndDate:= '10.09.2019'::tdatetime, inFromId:= 8447, inToId:= 8447, inisMovement := true, inSession:= zfCalc_UserAdmin())
--SELECT * FROM gpReport_ProductionUnionTech_Order (inStartDate:= '10.09.2019'::tdatetime, inEndDate:= '10.09.2019'::tdatetime, inFromId:= 8447, inToId:= 8447, inisMovement := false, inSession:= zfCalc_UserAdmin())

--where  goodsid =2537;   --CURRENT_DATE
