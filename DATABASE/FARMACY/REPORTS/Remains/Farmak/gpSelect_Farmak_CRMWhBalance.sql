 -- Function: gpSelect_Farmak_CRMWhBalance()

DROP FUNCTION IF EXISTS gpSelect_Farmak_CRMWhBalance (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Farmak_CRMWhBalance(
    IN inMakerId          Integer,    -- Производитель
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (PharmacyId Integer, WarehouseId Integer, WareId Integer
             , Price TFloat, Quantity TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
        WITH
          tmpGoodsPromo AS (SELECT DISTINCT GoodsPromo.GoodsID, GoodsPromo.WareId
                            FROM gpSelect_Farmak_CRMWare (inMakerId, inSession) AS GoodsPromo)
         , tmpUnit AS (SELECT DISTINCT UnitPromo.ID AS UnitId, UnitPromo.PharmacyId
                            FROM gpSelect_Farmak_CRMPharmacy ('3') AS UnitPromo)
         , tmpContainer AS (SELECT Container.Id                   AS ContainerId
                                 , Container.ObjectId             AS GoodsID
                                 , Container.WhereObjectId        AS UnitId
                                 , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Amount
                            FROM Container
                                INNER JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsID = Container.ObjectId
                                INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId

                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.ContainerId = Container.Id
                                                               AND MIContainer.DescId = zc_Container_Count()
                                                               AND MIContainer.OperDate >= CURRENT_DATE

                            WHERE Container.DescId = zc_Container_Count()
                            GROUP BY Container.Id
                                   , Container.ObjectId
                                   , Container.WhereObjectId
                                   , Container.Amount
                            HAVING (Container.Amount -  SUM (COALESCE (MIContainer.Amount, 0)) ) <> 0)
         , tmpContainerIncome AS (SELECT Container.ContainerId
                                       , Container.GoodsID
                                       , Container.UnitId
                                       , Container.Amount
                                       , COALESCE (MI_Income_find.Id,MI_Income.Id)       AS MI_IncomeId
                                  FROM tmpContainer AS Container

                                       LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                     ON ContainerLinkObject_MovementItem.Containerid = Container.ContainerId
                                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                       -- элемент прихода
                                       LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                       -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                   ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                       -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                       LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                  )

        -- Результат
        SELECT tmpUnit.PharmacyId                                   AS PharmacyId
             , NULL::Integer                                        AS WarehouseId
             , tmpGoodsPromo.WareId                                 AS WareId
             , COALESCE (MIF_PriceWithOutVAT.ValueData, 0)::TFloat  AS Price
             , SUM(tmpData.Amount):: TFloat                         AS Quantity
        FROM tmpContainerIncome AS tmpData

             LEFT JOIN tmpGoodsPromo ON tmpGoodsPromo.GoodsID = tmpData.GoodsID
             LEFT JOIN tmpUnit ON tmpUnit.UnitId = tmpData.UnitId

             LEFT JOIN MovementItemFloat AS MIF_PriceWithOutVAT
                                         ON MIF_PriceWithOutVAT.MovementItemId = tmpData.MI_IncomeId
                                        AND MIF_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
        GROUP BY tmpUnit.PharmacyId
               , tmpGoodsPromo.WareId
               , COALESCE (MIF_PriceWithOutVAT.ValueData, 0)
        ORDER BY tmpUnit.PharmacyId
               , tmpGoodsPromo.WareId
         ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.03.21                                                       *
*/

-- тест
--
SELECT * FROM gpSelect_Farmak_CRMWhBalance(13648288 , '3')
