-- Function: gpReport_StockTiming_Remainder()

DROP FUNCTION IF EXISTS gpReport_StockTiming_Remainder (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StockTiming_Remainder(
    IN inOperDate     TDateTime,
    IN inUnitID       Integer,
    IN inMakerId      Integer,    -- Производитель
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE ( UnitCode         Integer      --Код подразделение откуда
              , UnitName         TVarChar     --Наименование подразделение откуда
              , GoodsCode        Integer      --Код товара
              , GoodsName        TVarChar     --Наименование товара
              , MakerId          Integer
              , MakerCode        Integer      --Производитель
              , MakerName        TVarChar     --Наименование производителя
              , Price            TFloat
              , Amount           TFloat
              , Summa            TFloat
              , ExpirationDate   TDateTime    --Срок годности
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     inOperDate := DATE_TRUNC ('DAY', inOperDate);

     RETURN QUERY
     WITH
          tmpUnit AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId   AS UnitId
                      FROM Movement

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    

                      WHERE Movement.DescId         = zc_Movement_Check()
                        AND Movement.OperDate > CURRENT_DATE - INTERVAL '14 DAY')
       ,  tmpGoodsPromo AS (SELECT DISTINCT
                                     MI_Goods.ObjectId  AS GoodsId        -- здесь товар
                                   , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                   , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                                   , MIFloat_Price.ValueData            AS Price
                                   , COALESCE (MIBoolean_Checked.ValueData, FALSE)                                           ::Boolean  AS isChecked
                                   , CASE WHEN COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE THEN FALSE ELSE TRUE END ::Boolean  AS isReport
                                   , MovementLinkObject_Maker.ObjectId  AS MakerId
                              FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                              ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                             AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                             AND (MovementLinkObject_Maker.ObjectId = inMakerId OR inMakerId = 0)
                                INNER JOIN MovementDate AS MovementDate_StartPromo
                                                        ON MovementDate_StartPromo.MovementId = Movement.Id
                                                       AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                INNER JOIN MovementDate AS MovementDate_EndPromo
                                                        ON MovementDate_EndPromo.MovementId = Movement.Id
                                                       AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                   AND MI_Goods.DescId = zc_MI_Master()
                                                                   AND MI_Goods.isErased = FALSE
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                              ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                             AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                              WHERE Movement.StatusId = zc_Enum_Status_Complete()
                                AND Movement.DescId = zc_Movement_Promo()
                         )
          -- товары промо
     ,  tmpGoods_All AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                              , tmpGoodsPromo.StartDate_Promo
                              , tmpGoodsPromo.EndDate_Promo
                              , tmpGoodsPromo.Price               AS PriceSIP
                              , tmpGoodsPromo.isChecked
                              , tmpGoodsPromo.isReport
                              , tmpGoodsPromo.MakerId
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
                        )
      ,   tmpGoods AS (SELECT DISTINCT tmpGoods_All.GoodsId FROM tmpGoods_All)

      ,   tmpListGodsMarket AS (SELECT DISTINCT tmpGoods_All.GoodsId
                                     , tmpGoods_All.StartDate_Promo
                                     , tmpGoods_All.EndDate_Promo
                                     , tmpGoods_All.PriceSIP
                                     , tmpGoods_All.isChecked
                                     , tmpGoods_All.isReport
                                     , tmpGoods_All.MakerId
                                FROM tmpGoods_All
                                WHERE tmpGoods_All.StartDate_Promo <= inOperDate
                                  AND tmpGoods_All.EndDate_Promo >= '01.01.2019'
                                )
      , tmpMovementSendAll AS (SELECT MovementItemContainer.Id,
                                      MovementItemContainer.ContainerId,
                                      MovementItemContainer.Amount
                               FROM Movement

                                    INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                                  ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
 
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()
 
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_To
                                                                 ON MovementLinkObject_Unit_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit_To.DescId = zc_MovementLinkObject_To()

                                    LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                   AND MovementItemContainer.descid = zc_Container_CountPartionDate()
                                                                   AND MovementItemContainer.Amount < 0

                                WHERE Movement.DescId = zc_Movement_Send()
                                  AND Movement.statusid = zc_Enum_Status_UnComplete() 
                                  AND MovementLinkObject_Unit_To.ObjectId = 11299914
                                  AND COALESCE(MovementLinkObject_PartionDateKind.ObjectId, 0) = zc_Enum_PartionDateKind_0()
                                  AND (MovementLinkObject_Unit.ObjectId = inUnitID OR inUnitID = 0)
                                  AND MovementLinkObject_Unit.ObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit))
      , tmpMIC AS (SELECT DISTINCT Movement.Id
                   FROM tmpMovementSendAll AS Movement)
      , tmpMovementSend AS (SELECT Movement.ContainerId,
                                   SUM(-1.0 * Movement.Amount)::TFloat  AS AmountSend
                            FROM tmpMovementSendAll AS Movement
                            GROUP BY Movement.ContainerId)
      , tmpContainerAll AS (SELECT Container.Id                                                AS ContainerId,
                                   Container.ParentId                                          AS ParentId,
                                   Container.WhereObjectId                                     AS UnitId,
                                   Container.ObjectId                                          AS GoodsId,
                                   Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) 
                                                    + MAX (COALESCE (tmpMovementSend.AmountSend, 0)) AS Amount
                            FROM Container
                            
                                 LEFT JOIN tmpMovementSend ON tmpMovementSend.ContainerId = Container.Id
                                      
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.OperDate >= inOperDate

                                 LEFT JOIN tmpMIC ON tmpMIC.ID = MIContainer.Id

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND (Container.WhereObjectId  = inUnitID OR COALESCE(inUnitID, 0) = 0)
                              AND Container.WhereObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit)
                              AND COALESCE(tmpMIC.ID, 0) = 0
                            GROUP BY Container.Id
                                   , Container.WhereObjectId
                                   , Container.ObjectId
                                   , Container.Amount
                            HAVING Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) 
                                                    + MAX (COALESCE (tmpMovementSend.AmountSend, 0)) <> 0)
      , tmpContainer AS (SELECT Container.ContainerId                    AS ContainerId,
                                Container.ParentId                       AS ParentId, 
                                Container.UnitId                         AS UnitId,
                                Container.GoodsId                        AS GoodsId,
                                Container.Amount                         AS Amount,
                                ObjectDate_ExpirationDate.ValueData      AS ExpirationDate
                         FROM tmpContainerAll AS Container

                              INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.ContainerId
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                          
                              INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                    ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId    
                                                   AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                         WHERE ObjectDate_ExpirationDate.ValueData <= inOperDate)

      ,   tmpMovementItemSum AS (SELECT Container.UnitId,
                                        Container.GoodsId,
                                        SUM(Container.Amount)                                                  AS Amount,
                                        SUM(Container.Amount * AnalysisContainer.Price)                        AS Summa,
                                        tmpListGodsMarket.MakerId,
                                        Container.ExpirationDate                                               AS ExpirationDate

                                 FROM tmpContainer AS Container
                                      LEFT JOIN AnalysisContainer ON AnalysisContainer.Id = Container.ParentId
                                      
                                      LEFT JOIN tmpListGodsMarket ON tmpListGodsMarket.GoodsId = Container.GoodsId
                                                                 AND tmpListGodsMarket.StartDate_Promo <= inOperDate
                                                                 AND tmpListGodsMarket.EndDate_Promo >= inOperDate 
                                 GROUP BY Container.UnitId,
                                          Container.GoodsId,
                                          tmpListGodsMarket.MakerId,
                                          Container.ExpirationDate 
                                 )

     SELECT

           Object_Unit.ObjectCode,
           Object_Unit.ValueData,
           Object_Goods.ObjectCode,
           Object_Goods.ValueData,
           Object_Maker.Id,
           Object_Maker.ObjectCode,
           Object_Maker.ValueData,

           Round(Movement.Summa / Movement.Amount, 2)::TFloat ,

           Movement.Amount::TFloat,
           ROUND(Movement.Amount * Round(Movement.Summa / Movement.Amount, 2), 2)::TFloat ,

           DATE_TRUNC ('DAY', Movement.ExpirationDate)::TDateTime

     FROM tmpMovementItemSum AS Movement

          LEFT JOIN Object AS Object_Unit
                           ON Object_Unit.ID = Movement.UnitId

          LEFT JOIN Object AS Object_Goods
                           ON Object_Goods.ID = Movement.GoodsId

          LEFT JOIN Object AS Object_Maker
                           ON Object_Maker.ID = Movement.MakerId

     WHERE Movement.MakerId = inMakerId OR inMakerId = 0;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.03.21                                                       *
*/

-- тест
/*
select UnitCode, UnitName, Sum(Amount), Sum(Summa) from gpReport_StockTiming_Remainder(inOperDate := ('31.03.2021')::TDateTime , inUnitId := 0 , inMakerId := 0 ,  inSession := '3')
group by UnitCode, UnitName
order by UnitCode, UnitName;

*/

select * from gpReport_StockTiming_Remainder(inOperDate := ('01.01.2021')::TDateTime , inUnitId := 0 /*6309262*/  , inMakerId := 0 ,  inSession := '3')