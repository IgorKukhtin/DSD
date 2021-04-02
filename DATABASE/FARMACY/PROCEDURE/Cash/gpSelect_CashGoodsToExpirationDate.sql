-- Function: gpSelect_CashGoodsToExpirationDate()

DROP FUNCTION IF EXISTS gpSelect_CashGoodsToExpirationDate (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoodsToExpirationDate(
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (ID Integer,
               Price TFloat,
               Amount TFloat,
               ExpirationDate TDateTime,
               PartionDateKindId  Integer,
               Color_calc Integer)

AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbObjectId   Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbUnitIdStr  TVarChar;

  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;


    IF COALESCE((SELECT count(*) as CountProc  
                 FROM pg_stat_activity
                 WHERE state = 'active'
                   AND query ilike '%gpSelect_CashGoodsToExpirationDate%'), 0) > 7
    THEN
      RAISE EXCEPTION 'Ошибка. Пропускаем из за нагрузки';
    END IF;
       
    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();


     RETURN QUERY
     WITH tmpContainer AS (SELECT Container.Id,
                                  Container.ParentId,
                                  Container.DescId,
                                  Container.ObjectId                            AS GoodsId,
                                  Container.Amount
                             FROM Container
                             WHERE Container.DescId in (zc_Container_Count(), zc_Container_CountPartionDate())
                               AND Container.WhereObjectId = vbUnitId
                               AND Container.Amount <> 0
                            )
       , tmpContainerPDId AS (SELECT Container.ParentId                         AS ContainerId
                                   , Container.Amount
                                   , ContainerLinkObject.ObjectId               AS PartionGoodsId
                              FROM tmpContainer AS Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()


                              WHERE Container.DescId = zc_Container_CountPartionDate())
       , tmpContainerPD AS (SELECT tmpContainerPDId.ContainerId                                  AS ContainerId
                                 , tmpContainerPDId.Amount 
                                 , ObjectDate_ExpirationDate.ValueData                           AS ExpirationDate
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                              COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                        ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                            FROM tmpContainerPDId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId =  tmpContainerPDId.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = tmpContainerPDId.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5())
       , tmpExpirationIn AS (SELECT tmp.Id
                                    , tmp.GoodsId
                                    , tmp.Amount
                                    , COALESCE (MI_Income_find.Id,MI_Income.Id)    AS MI_IncomeId
                               FROM tmpContainer AS tmp

                                     -- находим срок годности из прихода
                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                ON ContainerLinkObject_MovementItem.Containerid = tmp.Id
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
                                  
                               WHERE tmp.DescId = zc_Container_Count()
                               )
       , tmpExpirationDate AS (SELECT tmp.Id
                                    , tmp.GoodsId
                                    , COALESCE(tmpContainerPD.Amount, tmp.Amount)                                             AS Amount
                                    , COALESCE (tmpContainerPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate
                                    , tmpContainerPD.PartionDateKindId                                                        AS PartionDateKindId
                               FROM tmpExpirationIn AS tmp

                                   -- находим срок годности для партийного товара
                                  LEFT JOIN tmpContainerPD ON tmpContainerPD.ContainerId = tmp.Id

                                  LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                    ON MIDate_ExpirationDate.MovementItemId = tmp.MI_IncomeId
                                                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
/*       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                          AND ObjectFloat_Goods_Price.ValueData > 0
                                         THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                         ELSE ROUND (Price_Value.ValueData, 2)
                                    END :: TFloat                           AS Price
                                  , Price_Goods.ChildObjectId               AS GoodsId
                             FROM ObjectLink AS ObjectLink_Price_Unit
                                LEFT JOIN ObjectLink AS Price_Goods
                                                     ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                LEFT JOIN ObjectFloat AS Price_Value
                                                      ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                -- Фикс цена для всей Сети
                                LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                       ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                      AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                        ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                       AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                             WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                               AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )
*/
     SELECT Container.GoodsId                                                      AS ID
         -- , COALESCE(tmpObject_Price.Price,0)::TFloat                              AS Price
          , 0::TFloat                                                             AS Price
          , Container.Amount                                                       AS Amount
          , Container.ExpirationDate                                       AS MinExpirationDate
          , Container.PartionDateKindId                                    AS PartionDateKindId
          , CASE WHEN COALESCE (Container.ExpirationDate, zc_DateEnd()) <= vbDate_0 THEN zc_Color_Red()        -- просрочено
                 WHEN COALESCE (Container.ExpirationDate, zc_DateEnd()) <= vbDate_1 THEN zc_Color_Yelow()      -- Меньше 1 месяца
                 WHEN COALESCE (Container.ExpirationDate, zc_DateEnd()) <= vbDate_3 THEN zc_Color_Cyan()       -- Меньше 1 месяца
                 WHEN COALESCE (Container.ExpirationDate, zc_DateEnd()) <= vbDate_6 THEN zc_Color_Cyan()       -- Меньше 6 месяца
                 ELSE zc_Color_White() END                                         AS Color_calc
     FROM tmpExpirationDate AS Container

        --  LEFT JOIN tmpExpirationDate ON tmpExpirationDate.id = Container.Id

        --  LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Container.GoodsId
     
     ORDER BY 1, 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 21.09.19                                                                                     *
 15.07.19                                                                                     *
 28.03.19                                                                                     *
*/

-- тест
--
SELECT * FROM gpSelect_CashGoodsToExpirationDate (inSession := '3') where id = 12434818;