-- Function: gpReport_IncomeConsumptionBalanceGoods()

DROP FUNCTION IF EXISTS gpReport_IncomeConsumptionBalanceGoods (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeConsumptionBalanceGoods(
    IN inStartDate     TDateTime , -- Начало периода
    IN inEndDate       TDateTime , -- Конец периода
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE cur3 refcursor;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

  vbStartDate := DATE_TRUNC ('DAY', inStartDate);
  vbEndDate := DATE_TRUNC ('DAY', inEndDate);

       -- Медикаменты
    OPEN cur1 FOR
    SELECT DISTINCT
           Object_Goods_Main.ObjectCode       AS GoodsId
         , Object_Goods_Main.Name        AS GoodsName
    FROM
     (SELECT
        AnalysisContainer.GoodsId
      FROM (SELECT
           AnalysisContainer.UnitId,
           AnalysisContainer.GoodsId,
           Sum(AnalysisContainer.Saldo) AS Saldo
         FROM AnalysisContainer
         GROUP BY AnalysisContainer.UnitId, AnalysisContainer.GoodsId) AS AnalysisContainer

         LEFT OUTER JOIN
         (SELECT AnalysisContainerItem.UnitID                                               AS UnitID
               , AnalysisContainerItem.GoodsId                                              AS GoodsId
               , Sum(CASE WHEN AnalysisContainerItem.OperDate <= vbEndDate THEN
                    AnalysisContainerItem.AmountCheck END)                                  AS Amount
               , Sum(CASE WHEN AnalysisContainerItem.OperDate <= vbEndDate THEN
                   AnalysisContainerItem.Saldo END)                                         AS Saldo
          FROM AnalysisContainerItem AS AnalysisContainerItem
          WHERE AnalysisContainerItem.OperDate >= vbStartDate
          GROUP BY AnalysisContainerItem.UnitID
                 , AnalysisContainerItem.GoodsId) AS AnalysisContainerItem
          ON AnalysisContainer.UnitId = AnalysisContainerItem.UnitId AND
             AnalysisContainer.GoodsId = AnalysisContainerItem.GoodsId

      WHERE ((AnalysisContainer.Saldo - COALESCE(AnalysisContainerItem.Saldo, 0)) <> 0 OR
             COALESCE(AnalysisContainerItem.Amount, 0) <> 0)) AS T1

      INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = T1.GoodsId
      INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

      ORDER BY Object_Goods_Main.Name;

    RETURN NEXT cur1;

      -- Маркетинговые контракты
    OPEN cur2 FOR
    SELECT DISTINCT
       Movement.InvNumber AS PromoID
     , Object_Maker.valuedata AS MakerName
    FROM Movement
       INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                     ON MovementLinkObject_Maker.MovementId = Movement.Id
                                    AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
       LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId
    WHERE Movement.StatusId = zc_Enum_Status_Complete()
      AND Movement.DescId = zc_Movement_Promo();
    RETURN NEXT cur2;

      -- Товары маркетинговых контрактов
    OPEN cur3 FOR
    SELECT DISTINCT
        Movement.InvNumber AS PromoId
      , Object_Goods_Main.ObjectCode AS GoodsId
    FROM Movement
      INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                         AND MI_Goods.DescId = zc_MI_Master()
                                         AND MI_Goods.isErased = FALSE
      INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MI_Goods.ObjectId
      INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

    WHERE Movement.StatusId = zc_Enum_Status_Complete()
      AND Movement.DescId = zc_Movement_Promo();
    RETURN NEXT cur3;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
             Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 07.01.20                                                      *
 12.11.18       *
 24.05.18                                                      *
*/

-- тест
--
select * from gpReport_IncomeConsumptionBalanceGoods(inStartDate := ('01.04.2018')::TDateTime , inEndDate := ('30.04.2018')::TDateTime , inSession := '3');
