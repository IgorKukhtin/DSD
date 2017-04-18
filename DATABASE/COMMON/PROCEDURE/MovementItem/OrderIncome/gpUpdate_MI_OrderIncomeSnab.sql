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
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());

    -- Ограничения по товарам
    CREATE TEMP TABLE _tmpGoods (MI_Id Integer, GoodsId Integer) ON COMMIT DROP;
        INSERT INTO _tmpGoods (MI_Id, GoodsId)
                    SELECT MovementItem.Id              AS MI_Id
                         , MILinkObject_Goods.ObjectId  AS GoodsId
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                               AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = False;

    vbCountDays := (SELECT DATE_PART('day', (inEndDate - inStartDate )) + 1);

    -- рассчетные данные
    CREATE TEMP TABLE _tmpData (MI_Id Integer, GoodsId Integer, RemainsStart TFloat, RemainsEnd TFloat, CountIncome TFloat, CountProductionOut TFloat, CountIn_oth TFloat, CountOut_oth TFloat, CountOrder TFloat) ON COMMIT DROP; 

    INSERT INTO _tmpData (MI_Id, GoodsId, RemainsStart, RemainsEnd, CountIncome, CountProductionOut, CountIn_oth, CountOut_oth, CountOrder)
     WITH
     tmpContainerAll AS (SELECT Container.Id                           AS ContainerId
                              , Container.ObjectId                     AS GoodsId
                              , Container.Amount
                         FROM ContainerLinkObject AS CLO_Unit
                              INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count()
                              INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Container.ObjectId
                         WHERE CLO_Unit.ObjectId = inUnitId
                           AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                         GROUP BY Container.Id, Container.ObjectId, Container.Amount
                        )
  -- выбираем поставщиков
  /*, tmpContainerIncome AS (SELECT DISTINCT tmpContainerAll.GoodsId, MIContainer.ObjectExtId_Analyzer AS PartnerId
                           FROM tmpContainerAll
                                INNER JOIN MovementItemContainer AS MIContainer
                                        ON MIContainer.Containerid = tmpContainerAll.ContainerId
                                       AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                       AND MIContainer.MovementDescId = zc_Movement_Income()
                                       AND COALESCE (MIContainer.ObjectExtId_Analyzer,0) <> 0
                          )
  , tmpPartnerList AS (SELECT goodsid, STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName
                       FROM tmpContainerIncome
                            LEFT JOIN Object ON Object.Id = tmpContainerIncome.PartnerId
                       GROUP BY tmpContainerIncome.GoodsId
                       )*/
  --
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
                           GROUP BY tmpContainerAll.GoodsId, tmpContainerAll.Amount
                           ) AS tmp
                     GROUP BY tmp.GoodsId
                     )
/*
, tmpGoodsListIncome AS (SELECT tmpGoods.GoodsId
                              , STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName
                         FROM _tmpGoods AS tmpGoods
                              INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                                      ON ObjectLink_GoodsListIncome_Goods.ChildObjectId = tmpGoods.GoodsId
                                     AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                              LEFT JOIN Object AS Object_GoodsListIncome
                                     ON Object_GoodsListIncome.Id = ObjectLink_GoodsListIncome_Goods.ObjectId
                                    AND Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome()
                              INNER JOIN ObjectBoolean AS ObjectBoolean_GoodsListIncome_Last
                                      ON ObjectBoolean_GoodsListIncome_Last.ObjectId = Object_GoodsListIncome.Id
                                     AND ObjectBoolean_GoodsListIncome_Last.DescId = zc_ObjectBoolean_GoodsListIncome_Last()
                                     AND ObjectBoolean_GoodsListIncome_Last.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                                     ON ObjectLink_GoodsListIncome_Partner.ObjectId = Object_GoodsListIncome.Id
                                    AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
                              LEFT JOIN Object ON Object.Id = ObjectLink_GoodsListIncome_Partner.ChildObjectId
                          GROUP BY tmpGoods.GoodsId
                         )
*/
  , tmpOrderIncome AS (SELECT MILinkObject_Goods.ObjectId AS GoodsId
                            --, STRING_AGG (Object.ValueData :: TVarChar, '; ') AS PartnerName
                            , SUM (MovementItem.Amount) AS Amount
                       FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND MovementLinkObject_Unit.ObjectId = inUnitId

                            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
*/
                            LEFT JOIN MovementItem ON MovementItem.MovementId  = Movement.Id
                                                  AND MovementItem.isErased = False
                                                  AND MovementItem.DescId = zc_MI_Master()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MILinkObject_Goods.ObjectId

                            --LEFT JOIN Object ON Object.Id = MovementLinkObject_Juridical.ObjectId

                       WHERE Movement.DescId = zc_Movement_OrderIncome()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                       GROUP BY MILinkObject_Goods.ObjectId
                       )
 
       -- Результат
      SELECT 
             _tmpGoods.MI_Id 
           , _tmpGoods.GoodsId
           , COALESCE (tmpContainer.RemainsStart,0)        :: TFloat
           , COALESCE (tmpContainer.RemainsEnd,0)          :: TFloat
           , COALESCE (tmpContainer.CountIncome,0)         :: TFloat 
           , COALESCE (tmpContainer.CountProductionOut,0)  :: TFloat 
           , COALESCE (tmpContainer.CountIn_oth,0)         :: TFloat
           , COALESCE (tmpContainer.CountOut_oth,0)        :: TFloat
           , COALESCE (tmpOrderIncome.Amount,0)            :: TFloat

       FROM _tmpGoods
          LEFT JOIN tmpContainer ON tmpContainer.GoodsId = _tmpGoods.GoodsId
          LEFT JOIN tmpOrderIncome ON tmpOrderIncome.GoodsId = _tmpGoods.GoodsId;

      PERFORM lpInsertUpdate_MI_OrderIncomeSnab_Property
                                                   (inId              := _tmpData.MI_Id
                                                  , inGoodsId         := _tmpData.GoodsId
                                                  , inRemainsStart    := _tmpData.RemainsStart
                                                  , inRemainsEnd      := _tmpData.RemainsEnd 
                                                  , inIncome          := _tmpData.CountIncome
                                                  , inAmountForecast  := _tmpData.CountProductionOut
                                                  , inAmountIn        := _tmpData.CountIn_oth
                                                  , inAmountOut       := _tmpData.CountOut_oth
                                                  , inAmountOrder     := _tmpData.CountOrder
                                                  , inUserId          := vbUserId
                                                    )
      FROM _tmpData;

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