-- Function: gpUpdate_MI_OrderIncomeSnab()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderIncomeSnab (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderIncomeSnab(
    IN inMovementId         Integer   , -- Ключ объекта <Документ>
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- подразделение склад
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCountDays Integer;
   DECLARE vbJuridicalId_From Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());

    --определяем пост. из документа
    vbJuridicalId_From := (SELECT MovementLinkObject_From.ObjectId AS JuridicalId_From
                           FROM MovementLinkObject AS MovementLinkObject_From
                           WHERE MovementLinkObject_From.MovementId = inMovementId
                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_Juridical());

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoodsMI (MI_Id Integer, GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpGoodsListIncome (MI_Id Integer, GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpGoods (MI_Id Integer, GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    --
       INSERT INTO _tmpUnit (UnitId)
              (SELECT inUnitId AS UnitId
              UNION
               SELECT 8448 AS UnitId       --цех деликатесов+   
              UNION
               SELECT 8447 AS UnitId       -- колбасный+           
              UNION
               SELECT 8451 AS UnitId       -- упаковка+            
              UNION
               SELECT 951601 AS UnitId     -- упаковка мясо+       
              UNION
               SELECT 981821 AS UnitId     -- шприцевание          
               );

       INSERT INTO _tmpGoodsMI (MI_Id, GoodsId)
                    SELECT MovementItem.Id              AS MI_Id
                         , MILinkObject_Goods.ObjectId  AS GoodsId
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                               AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = False;

       INSERT INTO _tmpGoodsListIncome (MI_Id, GoodsId)
                    SELECT DISTINCT 0 AS MI_Id, ObjectLink_GoodsListIncome_Goods.ChildObjectId AS GoodsId
                    FROM Object AS Object_GoodsListIncome
                         INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                                 ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                                AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
                                AND ObjectLink_GoodsListIncome_Juridical.ChildObjectId = vbJuridicalId_From
                         INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                 ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                                AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                    WHERE Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome()
                      AND Object_GoodsListIncome.isErased = False;

       INSERT INTO _tmpGoods (MI_Id, GoodsId)
                   SELECT COALESCE (_tmpGoodsMI.MI_Id,0) AS MI_Id
                        , COALESCE (_tmpGoodsMI.GoodsId, _tmpGoodsListIncome.GoodsId) AS GoodsId
                   FROM _tmpGoodsMI
                       FULL JOIN _tmpGoodsListIncome ON _tmpGoodsListIncome.GoodsId = _tmpGoodsMI.GoodsId;


    vbCountDays := (SELECT DATE_PART('day', (inEndDate - inStartDate )) + 1);

    -- рассчетные данные
    CREATE TEMP TABLE _tmpData (MI_Id Integer, GoodsId Integer, RemainsStart TFloat, RemainsEnd TFloat, RemainsStart_Oth TFloat, RemainsEnd_Oth TFloat, CountIncome TFloat, CountProductionOut TFloat, CountIn_oth TFloat, CountOut_oth TFloat, CountOrder TFloat) ON COMMIT DROP; 

    INSERT INTO _tmpData (MI_Id, GoodsId, RemainsStart, RemainsEnd, RemainsStart_Oth, RemainsEnd_Oth, CountIncome, CountProductionOut, CountIn_oth, CountOut_oth, CountOrder)
     WITH
     tmpContainerAll AS (SELECT Container.Id         AS ContainerId
                              , CLO_Unit.ObjectId    AS UnitId
                              , Container.ObjectId   AS GoodsId
                              , Container.Amount
                         FROM ContainerLinkObject AS CLO_Unit
                              INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count()
                              INNER JOIN _tmpUnit ON _tmpUnit.UnitId = CLO_Unit.ObjectId
                              INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId
                         WHERE /*CLO_Unit.ObjectId = inUnitId
                           AND */CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                         GROUP BY Container.Id, Container.ObjectId, Container.Amount, CLO_Unit.ObjectId 
                        )

  , tmpContainer AS (SELECT tmp.GoodsId 
                          , SUM (tmp.StartAmount)        AS RemainsStart
                          , SUM (tmp.EndAmount)          AS RemainsEnd
                          , SUM (tmp.CountIncome)        AS CountIncome
                          , SUM (tmp.CountSendOut)       AS CountProductionOut
                          , SUM (tmp.CountIn_oth)        AS CountIn_oth
                          , SUM (tmp.CountOut_oth)       AS CountOut_oth
                     FROM (SELECT tmpContainerAll.GoodsId
                                , tmpContainerAll.Amount
                                , tmpContainerAll.Amount - SUM (COALESCE(MIContainer.Amount, 0))  AS StartAmount
                                , tmpContainerAll.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId in (zc_Movement_Income(), zc_Movement_ReturnOut())
                                            THEN COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountIncome
                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_Send()
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountSendOut

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate(), zc_Movement_Loss())
                                             AND MIContainer.isActive = FALSE
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_Inventory())
                                             AND MIContainer.Amount < 0
                                            THEN -1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountOut_oth

                                , SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                                             AND MIContainer.isActive = TRUE
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END
                                     + CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                             AND MIContainer.MovementDescId = zc_Movement_Inventory()
                                             AND MIContainer.Amount > 0
                                            THEN 1 * COALESCE (MIContainer.Amount, 0)
                                            ELSE 0
                                       END) AS CountIn_oth

                           FROM tmpContainerAll
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.Containerid = tmpContainerAll.ContainerId
                                                               AND MIContainer.OperDate >= inStartDate
                           WHERE tmpContainerAll.UnitId = inUnitId
                           GROUP BY tmpContainerAll.GoodsId, tmpContainerAll.Amount
                           ) AS tmp
                     GROUP BY tmp.GoodsId
                     )

  , tmpOrderIncome AS (SELECT MILinkObject_Goods.ObjectId AS GoodsId
                            , SUM (MovementItem.Amount) AS Amount
                       FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId = inUnitId
                            LEFT JOIN MovementItem ON MovementItem.MovementId  = Movement.Id
                                                  AND MovementItem.isErased = False
                                                  AND MovementItem.DescId = zc_MI_Master()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MILinkObject_Goods.ObjectId
                       WHERE Movement.DescId = zc_Movement_OrderIncome()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       GROUP BY MILinkObject_Goods.ObjectId
                       )
 
   --"остатки впроизводстве"
  , tmpRemains_Oth AS (SELECT tmp.GoodsId
                            , SUM (tmp.StartAmount)        AS RemainsStart
                            , SUM (tmp.EndAmount)          AS RemainsEnd
                       FROM (SELECT tmpContainerAll.GoodsId
                                  , tmpContainerAll.Amount - SUM (COALESCE(MIContainer.Amount, 0))  AS StartAmount
                                  , tmpContainerAll.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS EndAmount
                             FROM tmpContainerAll
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.Containerid = tmpContainerAll.ContainerId
                                                                 AND MIContainer.OperDate >= inStartDate
                             WHERE tmpContainerAll.UnitId <> inUnitId
                             GROUP BY tmpContainerAll.GoodsId, tmpContainerAll.Amount
                             ) AS tmp
                       GROUP BY tmp.GoodsId
                       )

       -- Результат
      SELECT 
             _tmpGoods.MI_Id 
           , _tmpGoods.GoodsId
           , COALESCE (tmpContainer.RemainsStart,0)        :: TFloat
           , COALESCE (tmpContainer.RemainsEnd,0)          :: TFloat
           , COALESCE (tmpRemains_Oth.RemainsStart,0)      :: TFloat
           , COALESCE (tmpRemains_Oth.RemainsEnd,0)        :: TFloat
           , COALESCE (tmpContainer.CountIncome,0)         :: TFloat 
           , COALESCE (tmpContainer.CountProductionOut,0)  :: TFloat 
           , COALESCE (tmpContainer.CountIn_oth,0)         :: TFloat
           , COALESCE (tmpContainer.CountOut_oth,0)        :: TFloat
           , COALESCE (tmpOrderIncome.Amount,0)            :: TFloat

       FROM _tmpGoods
          LEFT JOIN tmpContainer ON tmpContainer.GoodsId = _tmpGoods.GoodsId
          LEFT JOIN tmpOrderIncome ON tmpOrderIncome.GoodsId = _tmpGoods.GoodsId
          LEFT JOIN tmpRemains_Oth ON tmpRemains_Oth.GoodsId = _tmpGoods.GoodsId;

      PERFORM lpInsertUpdate_MI_OrderIncomeSnab_Property
                                                   (inId              := COALESCE (_tmpData.MI_Id,0)
                                                  , inMovementId      := inMovementId
                                                  , inGoodsId         := _tmpData.GoodsId
                                                  , inMeasureId       := ObjectLink_Goods_Measure.ChildObjectId
                                                  , inRemainsStart    := _tmpData.RemainsStart
                                                  --, inRemainsEnd      := _tmpData.RemainsEnd 
                                                  , inBalanceStart    := _tmpData.RemainsStart_Oth
                                                  , inBalanceEnd      := _tmpData.RemainsEnd_Oth 
                                                  , inIncome          := _tmpData.CountIncome
                                                  , inAmountForecast  := _tmpData.CountProductionOut
                                                  , inAmountIn        := _tmpData.CountIn_oth
                                                  , inAmountOut       := _tmpData.CountOut_oth
                                                  , inAmountOrder     := _tmpData.CountOrder
                                                  , inUserId          := vbUserId
                                                    )
      FROM _tmpData
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = _tmpData.GoodsId
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.04.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_OrderIncomeSnab(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('21.12.2016')::TDateTime , inUnitId := 8455 , inGoodsGroupId := 1917 ,  inSession := '5');
