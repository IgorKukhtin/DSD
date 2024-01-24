-- Function: gpSelect_GoodsPartionDatePromo()

DROP FUNCTION IF EXISTS gpSelect_GoodsPartionDatePromo (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsPartionDatePromo (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPartionDatePromo (
    IN inUnitId         Integer ,
    IN inMakerId        Integer ,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitID Integer, UnitCode Integer, UnitName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, PartionDateKindName TVarChar,
               Remains TFloat, ExpirationDate TDateTime, DayOverdue Integer,
               InvNumber TVarChar, MakerName TVarChar,
               MainJuridicalId Integer, MainJuridicalName TVarChar,  --Наше Юр. лицо
               PriceWithVAT TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;

   DECLARE vbDate0     TDateTime;
   DECLARE vbDate180   TDateTime;
   DECLARE vbDate30    TDateTime;

   DECLARE vbMonth_0   TFloat;
   DECLARE vbMonth_1   TFloat;
   DECLARE vbMonth_6   TFloat;
   DECLARE vbIsMonth_0 Boolean;
   DECLARE vbIsMonth_1 Boolean;
   DECLARE vbIsMonth_6 Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    -- получаем значения из справочника
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_0, vbIsMonth_0
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0();
    --
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_1, vbIsMonth_1
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1();
    --
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_6, vbIsMonth_6
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6();

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + CASE WHEN vbIsMonth_6 = TRUE THEN vbMonth_6 ||' MONTH'  ELSE vbMonth_6 ||' DAY' END :: INTERVAL;
    vbDate30  := CURRENT_DATE + CASE WHEN vbIsMonth_1 = TRUE THEN vbMonth_1 ||' MONTH'  ELSE vbMonth_1 ||' DAY' END :: INTERVAL;
    vbDate0   := CURRENT_DATE + CASE WHEN vbIsMonth_0 = TRUE THEN vbMonth_0 ||' MONTH'  ELSE vbMonth_0 ||' DAY' END :: INTERVAL;

    RETURN QUERY
    WITH           -- Id строк Маркетинговых контрактов inMakerId
         tmpMIPromo AS (SELECT DISTINCT MI_Goods.Id                        AS MI_Id
                                      , MI_Goods.ObjectId                  AS GoodsId
                                      , Movement.InvNumber                 AS InvNumber
                                      , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                      , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                                      , MIFloat_Price.ValueData            AS Price
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
                                 WHERE Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.DescId = zc_Movement_Promo()
                                  )    
       , tmpContainer AS (SELECT Container.Id
                               , Container.WhereObjectId
                               , Container.ObjectId
                               , Container.Amount
                               , ContainerLinkObject.ObjectId                       AS PartionGoodsId
                               , MIFloat_PriceWithVAT.ValueData                     AS PriceWithVAT
                          FROM Container
                          
                               INNER JOIN tmpMIPromo ON tmpMIPromo.GoodsId = Container.ObjectId

                               LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                               LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                             ON ContainerLinkObject_MovementItem.Containerid = Container.Id
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
                               
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                           ON MIFloat_PriceWithVAT.MovementItemId = COALESCE(MI_Income_find.Id,MI_Income.Id)
                                                          AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                               
                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                            AND Container.Amount <> 0
                         )
       , tmpPDContainer AS (SELECT Container.Id
                                 , Container.WhereObjectId
                                 , Container.ObjectId
                                 , Container.Amount
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5() -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0   THEN zc_Enum_PartionDateKind_0()     -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate30  THEN zc_Enum_PartionDateKind_1()     -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate180 THEN zc_Enum_PartionDateKind_6()     -- Меньше 6 месяца
                                        ELSE zc_Enum_PartionDateKind_Good() END                  AS PartionDateKindId              -- Востановлен с просрочки
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())                              AS ExpirationDate
                                 , DATE_PART('DAY', date_trunc('DAY', COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())) -
                                             CURRENT_DATE)                                                                   AS DayOverdue
                                 , Object_PartionGoods.ObjectCode                                                            AS MovementIncomeID
                                 , Movement_Income.OperDate                                                                  AS IncomeOperDate
                                 , Container.PriceWithVAT                                                                    AS PriceWithVAT  
                            FROM tmpContainer AS Container

                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = Container.PartionGoodsId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                 LEFT OUTER JOIN Movement AS Movement_Income ON Movement_Income.Id = Object_PartionGoods.ObjectCode
                            )


    SELECT Object_Unit.ID                         AS UnitID
         , Object_Unit.ObjectCode                 AS UnitCode
         , Object_Unit.ValueData                  AS UnitName
         , Container.ObjectId                     AS GoodsId
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_PartionDateKind.ValueData       AS PartionDateKindName
         , Container.Amount                       AS Amount
         , Container.ExpirationDate::TDateTime    AS ExpirationDate
         , Container.DayOverdue::Integer          AS DayOverdue
         , tmpMIPromo.InvNumber                   AS InvNumber
         , Object_Maker.ValueData                 AS MakerName
         , Object_MainJuridical.Id                AS MainJuridicalId
         , Object_MainJuridical.ValueData         AS MainJuridicalName
         , Container.PriceWithVAT                 AS PriceWithVAT 
    FROM tmpPDContainer AS Container

         INNER JOIN tmpMIPromo ON tmpMIPromo.GoodsId = Container.ObjectId
                              AND Container.IncomeOperDate >= StartDate_Promo
                              AND Container.IncomeOperDate <= EndDate_Promo

         LEFT JOIN Object AS Object_Unit
                          ON Object_Unit.Id = Container.WhereObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                              ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                             AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

         LEFT JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Container.ObjectId

         LEFT JOIN Object AS Object_PartionDateKind
                          ON Object_PartionDateKind.Id = Container.PartionDateKindId

         LEFT JOIN Object AS Object_Maker
                          ON Object_Maker.Id = tmpMIPromo.MakerId;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsPartionDatePromo(inUnitId :=  183292, inMakerId := 0, inSession := '3')