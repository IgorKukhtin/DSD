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

  DECLARE vbMonth_0  TFloat;
  DECLARE vbMonth_1  TFloat;
  DECLARE vbMonth_6  TFloat;

  DECLARE vbOperDate TDateTime;
  DECLARE vbDate180  TDateTime;
  DECLARE vbDate30   TDateTime;

  DECLARE vbPartion   boolean;
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

    -- получаем значения из справочника для разделения по срокам
    vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbMonth_1 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbMonth_1||' MONTH' ) ::INTERVAL;
    vbOperDate:= CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL;

    vbPartion := False;

     RETURN QUERY
     WITH tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpCLO.ObjectId FROM tmpCLO))

       , tmpMIDate AS (SELECT MovementItemDate.*
                       FROM MovementItemDate
                       WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpObject.ObjectCode FROM tmpObject)
                         AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )

       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN tmpMIDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                                                        -- AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
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

     SELECT Container.ObjectId                                                AS ID
           ,COALESCE(tmpObject_Price.Price,0)::TFloat                         AS Price
          , Container.Amount                                                  AS Amount
          , COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) :: TDateTime AS MinExpirationDate
          , CASE WHEN vbPartion = True AND COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0() ELSE   -- просрочено
            CASE WHEN vbPartion = True AND COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) <= vbDate30  THEN zc_Enum_PartionDateKind_1() ELSE    -- Меньше 1 месяца
            CASE WHEN vbPartion = True AND COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Enum_PartionDateKind_6() ELSE      -- Меньше 6 месяца
            0 END END END                                                           AS PartionDateKindId          
          , CASE WHEN COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Color_Red() ELSE   -- просрочено
            CASE WHEN COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) <= vbDate30  THEN zc_Color_Yelow() ELSE     -- Меньше 1 месяца
            CASE WHEN COALESCE (tmpExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Color_Cyan() ELSE      -- Меньше 6 месяца
            zc_Color_White() END END END                                                           AS Color_calc
     FROM tmpContainer AS Container

          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id

          LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Container.ObjectId
     ORDER BY 1, 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 28.03.19                                                                                     *
*/

-- тест
-- SELECT * FROM gpSelect_CashGoodsToExpirationDate (inSession := '3');