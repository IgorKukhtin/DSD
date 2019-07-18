-- Function: gpSelect_MovementItem_PartionGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PartionGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PartionGoods(
    IN inUnitId   Integer      , -- ключ Документа
    IN inGoodsId  Integer      , -- ключ Документа
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               PartionDateKindId  Integer, PartionDateKindName  TVarChar,
               Remains TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

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
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;
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
    WITH           -- Остатки по срокам
         tmpPDContainerAll AS (SELECT Container.Id,
                                     Container.ObjectId,
                                     Container.ParentId,
                                     Container.Amount,
                                     ContainerLinkObject.ObjectId                       AS PartionGoodsId 
                              FROM Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.ObjectId = inGoodsId
                              AND Container.WhereObjectId = inUnitId
                              AND Container.Amount <> 0)
       , tmpPDContainer AS (SELECT Container.Id,
                                   Container.ObjectId,
                                   Container.Amount,
                                   CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0 AND 
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE 
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5() -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0   THEN zc_Enum_PartionDateKind_0()     -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate30  THEN zc_Enum_PartionDateKind_1()     -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate180 THEN zc_Enum_PartionDateKind_6()     -- Меньше 6 месяца
                                        ELSE zc_Enum_PartionDateKind_Good() END                  AS PartionDateKindId              -- Востановлен с просрочки
                            FROM tmpPDContainerAll AS Container

                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = Container.PartionGoodsId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                      
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5() 
                                  )
       , tmpPDGoodsRemains AS (SELECT Container.ObjectId
                                    , Container.PartionDateKindId                                       AS PartionDateKindId
                                    , SUM (Container.Amount)                                            AS Remains
                               FROM tmpPDContainer AS Container
                               GROUP BY Container.ObjectId
                                      , Container.PartionDateKindId
                               )
       , tmpPDGoodsRemainsAll AS (SELECT tmpPDGoodsRemains.ObjectId
                                       , SUM (tmpPDGoodsRemains.Remains)                                AS Remains
                                  FROM tmpPDGoodsRemains
                                  GROUP BY tmpPDGoodsRemains.ObjectId
                                 )
          -- Остатки по основным контейнерам
       , tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.ObjectId = inGoodsId
                            AND Container.WhereObjectId = inUnitId
                            AND Container.Amount <> 0
                         )
       , tmpGoodsRemains AS (SELECT Container.ObjectId
                                  , SUM (Container.Amount) AS Remains
                             FROM tmpContainer AS Container
                             GROUP BY Container.ObjectId
                             )
          -- Непосредственно остатки
       , GoodsRemains AS (SELECT Container.ObjectId
                               , Container.Remains - COALESCE(tmpPDGoodsRemainsAll.Remains, 0)                   AS Remains
                               , NULL                                                                            AS PartionDateKindId
                          FROM tmpGoodsRemains AS Container
                               LEFT JOIN tmpPDGoodsRemainsAll ON tmpPDGoodsRemainsAll.ObjectId = Container.ObjectId
                          UNION ALL
                          SELECT tmpPDGoodsRemains.ObjectId
                               , tmpPDGoodsRemains.Remains
                               , tmpPDGoodsRemains.PartionDateKindId
                          FROM tmpPDGoodsRemains
                         )

    SELECT
           Goods.ID                     AS GoodsId
         , Goods.ObjectCode             AS GoodsCode
         , Goods.ValueData              AS GoodsName
         , PartionDateKind.ID           AS PartionDateKindId
         , PartionDateKind.ValueData    AS PartionDateKindName
         , GoodsRemains.Remains::TFloat AS Remains 
    FROM GoodsRemains

         INNER JOIN Object AS Goods ON Goods.Id = GoodsRemains.ObjectId

         LEFT JOIN Object AS PartionDateKind ON PartionDateKind.Id = GoodsRemains.PartionDateKindId;
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Check (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 19.07.19                                                                                   *
*/

-- тест
-- select * from gpSelect_MovementItem_PartionGoods(inUnitId := 377610 ,  inGoodsId := 2149403 ,  inSession := '3');