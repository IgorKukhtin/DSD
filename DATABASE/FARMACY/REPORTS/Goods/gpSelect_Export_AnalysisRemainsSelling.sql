-- Function:  gpSelect_Export_AnalysisRemainsSelling()

DROP FUNCTION IF EXISTS gpSelect_Export_AnalysisRemainsSelling (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Export_AnalysisRemainsSelling (
  inStartDate TDateTime,
  inEndDate TDateTime,
  inMaker Integer,
  inSession TVarChar
)
RETURNS TABLE (
  UnitID integer,
  UnitName TVarChar,
  GoodsId integer,
  GoodsName TVarChar,
  Amount TFloat,
  OutSaldo TFloat,
  Summ TFloat,
  SummSaldo TFloat,
  SummSIP TFloat,
  SummSaldoSIP TFloat
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
    tmpPriceAll AS (
                        SELECT ROW_NUMBER() OVER (PARTITION BY AnalysisContainer.UnitID
                             , AnalysisContainer.GoodsId  ORDER BY AnalysisContainer.Id Desc)                AS Ord
                             , AnalysisContainer.UnitID                                                      AS UnitID
                             , AnalysisContainer.GoodsId                                                     AS GoodsId
                             , AnalysisContainer.Price                                                       AS Price
                        FROM tmpGoods
                             INNER JOIN AnalysisContainer AS AnalysisContainer
                                                          ON AnalysisContainer.GoodsId = tmpGoods.GoodsId),
    tmpContainer AS (
                        SELECT AnalysisContainer.UnitID                                                      AS UnitID
                             , AnalysisContainer.GoodsId                                                     AS GoodsId
                             , Sum(AnalysisContainer.Saldo)::TFloat                                          AS Saldo
                        FROM tmpGoods
                             INNER JOIN AnalysisContainer AS AnalysisContainer
                                                          ON AnalysisContainer.GoodsId = tmpGoods.GoodsId
                        GROUP BY AnalysisContainer.UnitID
                               , AnalysisContainer.GoodsId),
    tmpAnalysisContainerItem AS (
                        SELECT AnalysisContainerItem.UnitID                                               AS UnitID
                             , AnalysisContainerItem.GoodsId                                              AS GoodsId


                             , Sum(CASE WHEN AnalysisContainerItem.OperDate <= inEndDate THEN
                                 AnalysisContainerItem.AmountCheck END)                                  AS Amount
                             , Sum(CASE WHEN AnalysisContainerItem.OperDate > inEndDate THEN
                                 AnalysisContainerItem.Saldo END)                                         AS Saldo
                        FROM tmpGoods
                             INNER JOIN AnalysisContainerItem AS AnalysisContainerItem
                                                          ON AnalysisContainerItem.GoodsId = tmpGoods.GoodsId
                        WHERE AnalysisContainerItem.OperDate >= inStartDate
                        GROUP BY AnalysisContainerItem.UnitID
                               , AnalysisContainerItem.GoodsId)

   SELECT
      Object_Unit.ObjectCode           AS UnitID
    , Object_Unit.ValueData            AS UnitName
    , Object_Goods.ObjectCode          AS GoodsId
    , Object_Goods.ValueData           AS GoodsName
    , tmpAnalysisContainerItem.Amount::TFloat    AS Amount
    , (tmpContainer.Saldo - COALESCE(tmpAnalysisContainerItem.Saldo, 0))::TFloat AS OutSaldo

    , Round(tmpAnalysisContainerItem.Amount * tmpPriceAll.Price, 2) ::TFloat AS Summ
    , Round((tmpContainer.Saldo - COALESCE(tmpAnalysisContainerItem.Saldo, 0)) * tmpPriceAll.Price, 2) ::TFloat AS SummSaldo

    , Round(tmpAnalysisContainerItem.Amount * tmpGoods.Price, 2) ::TFloat AS SummSIP
    , Round((tmpContainer.Saldo - COALESCE(tmpAnalysisContainerItem.Saldo, 0)) * tmpGoods.Price, 2) ::TFloat AS SummSaldoSIP
    
   FROM tmpContainer
        LEFT OUTER JOIN tmpAnalysisContainerItem AS tmpAnalysisContainerItem
                                                 ON tmpAnalysisContainerItem.UnitId = tmpContainer.UnitId
                                                AND tmpAnalysisContainerItem.GoodsId = tmpContainer.GoodsId

        INNER JOIN Object AS Object_Unit
                          ON Object_Unit.ID = tmpContainer.UnitID
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = tmpContainer.GoodsID

        LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpContainer.GoodsID

        LEFT JOIN tmpPriceAll ON tmpPriceAll.UnitID = tmpContainer.UnitID
                             AND tmpPriceAll.GoodsId = tmpContainer.GoodsId
                             AND tmpPriceAll.Ord = 1

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()

   WHERE ((tmpContainer.Saldo - COALESCE(tmpAnalysisContainerItem.Saldo, 0)) <> 0 OR
           COALESCE(tmpAnalysisContainerItem.Amount, 0) <> 0)
     AND ObjectLink_Unit_Parent.ChildObjectId not in (2141104, 3031071, 5603546, 377601, 5778621, 5062813)
     AND Object_Unit.ID not in (10129562, 11299914, 11460971, 12812109, 14890823)
     AND tmpContainer.UnitID not in (SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (Object_Unit_View.ParentId, 0) = 0
);



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 18.04.19        *
 01.01.19        *                                                                         *

*/

-- тест
-- select * from gpSelect_Export_AnalysisRemainsSelling ('2019-01-01'::TDateTime, '2019-01-31'::TDateTime, 2336605 , '3')


select * from gpSelect_Export_AnalysisRemainsSelling ('01.01.2022', '01.02.2022', 2336604 , '3')