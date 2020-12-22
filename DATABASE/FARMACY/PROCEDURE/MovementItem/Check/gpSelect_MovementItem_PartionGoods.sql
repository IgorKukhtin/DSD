-- Function: gpSelect_MovementItem_PartionGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PartionGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PartionGoods(
    IN inUnitId   Integer      , -- ключ Документа
    IN inGoodsId  Integer      , -- ключ Документа
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               PartionDateKindId  Integer, PartionDateKindName  TVarChar,
               DivisionPartiesId  Integer, DivisionPartiesName  TVarChar,
               NDS TFloat,
               Remains TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDate_0     TDateTime;
   DECLARE vbDate_1    TDateTime;
   DECLARE vbDate_3    TDateTime;
   DECLARE vbDate_6   TDateTime;

BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

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
                                   Container.ParentId,
                                   Container.Amount,
                                   CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5() -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0   THEN zc_Enum_PartionDateKind_0()     -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()     -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()     -- Меньше 3 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()     -- Меньше 6 месяца
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
       , tmpPDGoodsRemains AS (SELECT Container.ParentId
                                    , Container.ObjectId
                                    , Container.PartionDateKindId                                       AS PartionDateKindId
                                    , SUM (Container.Amount)                                            AS Amount
                               FROM tmpPDContainer AS Container
                               GROUP BY Container.ParentId
                                      , Container.ObjectId
                                      , Container.PartionDateKindId
                               )

          -- Остатки по основным контейнерам
       , tmpContainerCount AS (SELECT Container.Id,
                                      Container.ObjectId,
                                      Container.Amount
                               FROM Container
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.ObjectId = inGoodsId
                                 AND Container.WhereObjectId = inUnitId
                                 AND Container.Amount <> 0
                              )
       , tmpContainer AS (SELECT Container.Id,
                                 Container.ObjectId,
                                 tmpPDGoodsRemains.PartionDateKindId,
                                 CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                      THEN Object_Goods_Main.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId,
                                 ContainerLinkObject_DivisionParties.ObjectId                                        AS DivisionPartiesId,
                                 COALESCE(tmpPDGoodsRemains.Amount, Container.Amount)                                AS Amount
                          FROM tmpContainerCount AS Container

                               LEFT JOIN  tmpPDGoodsRemains on tmpPDGoodsRemains.ParentId = Container.Id

                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Container.ObjectId
                               LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                               LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                             ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                            AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()

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
                                                                    -- AND 1=0

                               LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                               ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                              AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                            ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                           AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                         )
       , tmpGoodsRemains AS (SELECT Container.ObjectId,
                                    Container.PartionDateKindId,
                                    Container.NDSKindId,
                                    Container.DivisionPartiesId,
                                    SUM(Container.Amount)                        AS Remains
                             FROM tmpContainer AS Container
                             GROUP BY Container.ObjectId,
                                      Container.PartionDateKindId,
                                      Container.NDSKindId,
                                      Container.DivisionPartiesId
                             )
       , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                             , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                      )


    SELECT
           Goods.ID                          AS GoodsId
         , Goods.ObjectCode                  AS GoodsCode
         , Goods.ValueData                   AS GoodsName
         , PartionDateKind.ID                AS PartionDateKindId
         , PartionDateKind.ValueData         AS PartionDateKindName
         , GoodsRemains.DivisionPartiesId    AS DivisionPartiesId
         , Object_DivisionParties.ValueData  AS DivisionPartiesName
         , ObjectFloat_NDSKind_NDS.ValueData AS NDS

         , GoodsRemains.Remains::TFloat AS Remains
    FROM tmpGoodsRemains AS GoodsRemains

         INNER JOIN Object AS Goods ON Goods.Id = GoodsRemains.ObjectId

         LEFT JOIN Object AS PartionDateKind ON PartionDateKind.Id = GoodsRemains.PartionDateKindId

         LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = GoodsRemains.DivisionPartiesId

         LEFT OUTER JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                    ON ObjectFloat_NDSKind_NDS.ObjectId = GoodsRemains.NDSKindId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PartionGoods (Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 19.07.19                                                                                   *
*/

-- тест
-- select * from gpSelect_MovementItem_PartionGoods(inUnitId := 377610 ,  inGoodsId := 2149403 ,  inSession := '3');
