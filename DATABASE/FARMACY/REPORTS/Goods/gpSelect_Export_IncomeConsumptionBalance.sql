-- Function:  gpSelect_Export_AnalysisRemainsSelling()

DROP FUNCTION IF EXISTS gpSelect_Export_IncomeConsumptionBalance (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Export_IncomeConsumptionBalance (
  inStartDate TDateTime,
  inEndDate TDateTime,
  inMaker Integer,
  inSession TVarChar
)
RETURNS TABLE (
   ParentName TVarChar,
   UnitName TVarChar,

   GoodsId integer,
   GoodsName TVarChar,

   AmountIncome TFloat,
   AmountIncomeSumWith TFloat,

   AmountCheck TFloat,
   AmountCheckSumJuridical TFloat,

   SaldoOut TFloat,
   SummaOut TFloat
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   WITH
    tmpGoodsPromo AS (SELECT MI_Goods.ObjectId                  AS GoodsID
                           , MAX(MIFloat_Price.ValueData)       AS Price
                      FROM Movement

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                         ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                        AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()

                           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                  AND MI_Goods.DescId = zc_MI_Master()
                                                  AND MI_Goods.isErased = FALSE

                           INNER JOIN MovementDate AS MovementDate_StartPromo
                                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                           INNER JOIN MovementDate AS MovementDate_EndPromo
                                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

                      WHERE Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId = zc_Movement_Promo()
                        AND MovementDate_StartPromo.ValueData <= inEndDate
                        AND MovementDate_EndPromo.ValueData >= inEndDate
                        AND MovementLinkObject_Maker.ObjectId = inMaker
                      GROUP BY MI_Goods.ObjectId),
    tmpGoods AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                      , tmpGoodsPromo.Price 
                 FROM tmpGoodsPromo
                               -- !!!
                      INNER JOIN ObjectLink AS ObjectLink_Child
                                            ON ObjectLink_Child.ChildObjectId = tmpGoodsPromo.GoodsId 
                                           AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                      INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                 AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                 WHERE  ObjectLink_Child_R.ChildObjectId<>0
                      ), 
    tmpContainer AS (
                        SELECT AnalysisContainer.UnitID                                                      AS UnitID
                             , AnalysisContainer.GoodsId                                                     AS GoodsId
                             , SUM(AnalysisContainer.Saldo)::TFloat                                          AS Saldo
                             , SUM((AnalysisContainer.Saldo  *
                                 AnalysisContainer.Price)::NUMERIC (16, 2))::TFloat                          AS Summa
                        FROM tmpGoods
                             INNER JOIN AnalysisContainer AS AnalysisContainer
                                                          ON AnalysisContainer.GoodsId = tmpGoods.GoodsId
                        GROUP BY AnalysisContainer.UnitID
                               , AnalysisContainer.GoodsId),
    tmContainerItem AS (SELECT
                            AnalysisContainerItem.UnitID                       AS UnitID
                          , AnalysisContainerItem.GoodsId                      AS GoodsId

                          , SUM(AnalysisContainerItem.AmountIncome)            AS AmountIncome             -- Приход
                          , SUM(AnalysisContainerItem.AmountIncomeSumWith)     AS AmountIncomeSumWith

                          , SUM(AnalysisContainerItem.AmountCheck)             AS AmountCheck              -- Кассовый чек
                          , SUM(AnalysisContainerItem.AmountCheckSumJuridical) AS AmountCheckSumJuridical

                          , SUM(AnalysisContainerItem.Saldo)                   AS Saldo
                          , SUM(AnalysisContainerItem.SaldoSum)                AS Summa

                          , Count(*)                                           AS CountItem
                        FROM tmpGoods
                             INNER JOIN AnalysisContainerItem AS AnalysisContainerItem
                                                              ON AnalysisContainerItem.GoodsId = tmpGoods.GoodsId
                        WHERE AnalysisContainerItem.Operdate >= inStartDate
                          AND AnalysisContainerItem.Operdate <= inEndDate
                        GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsId
                        ),
    tmpSaldoOut AS (
                        SELECT MovementItem.UnitID                                                       AS UnitID
                             , MovementItem.GoodsId                                                      AS GoodsId
                             , SUM(MovementItem.Saldo)                                                   AS Saldo
                             , SUM(MovementItem.SaldoSum)                                                AS Summa
                        FROM tmpGoods
                             INNER JOIN AnalysisContainerItem AS MovementItem
                                                              ON MovementItem.GoodsId = tmpGoods.GoodsId
                        WHERE MovementItem.Operdate > inEndDate
                        GROUP BY MovementItem.UnitID
                               , MovementItem.GoodsId )


    SELECT
        Object_Parent.ValueData                      AS ParentName
      , Object_Unit.ValueData                        AS UnitName

      , Object_Goods.ObjectCode                      AS GoodsId
      , Object_Goods.ValueData                       AS GoodsName

      , tmpMovement.AmountIncome::TFloat             AS AmountIncome       -- Приход
      , tmpMovement.AmountIncomeSumWith::TFloat      AS AmountIncomeSumWith

      , tmpMovement.AmountCheck::TFloat              AS AmountCheck       -- Кассовый чек
      , tmpMovement.AmountCheckSumJuridical::TFloat  AS AmountCheckSumJuridical

      , (tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0))::TFloat    AS SaldoOut
      , (tmpContainer.Summa - COALESCE(tmpSaldoOut.Summa, 0))::TFloat    AS SummaOut

    FROM tmpContainer as tmpContainer

        LEFT JOIN tmpSaldoOut AS tmpSaldoOut
                              ON tmpSaldoOut.UnitID = tmpContainer.UnitID
                             AND tmpSaldoOut.GoodsId = tmpContainer.GoodsId

        LEFT JOIN tmContainerItem AS tmpMovement
                                  ON tmpMovement.UnitID = tmpContainer.UnitID
                                 AND tmpMovement.GoodsId = tmpContainer.GoodsId

        INNER JOIN Object AS Object_Unit  ON Object_Unit.Id  = tmpContainer.UnitID
        INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpContainer.GoodsId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent
                         ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

    WHERE COALESCE(tmpMovement.CountItem, tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0)) <> 0
      AND ObjectLink_Unit_Parent.ChildObjectId not in (2141104, 3031071, 5603546, 377601, 5778621, 5062813)
      AND tmpContainer.UnitID not in (SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (Object_Unit_View.ParentId, 0) = 0)
    ORDER BY Object_Goods.ObjectCode, Object_Parent.ValueData, Object_Unit.ValueData;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 18.04.19        *
 01.02.19        *                                                                         *

*/

-- тест
-- select * from gpSelect_Export_IncomeConsumptionBalance ('2019-01-01'::TDateTime, '2019-01-31'::TDateTime, 2336605 , '3')
