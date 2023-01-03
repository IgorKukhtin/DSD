-- Function: gpSelect_MovementItem_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendPartionDateChange (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendPartionDateChange(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Remains TFloat, Amount TFloat
             , ExpirationDate TDateTime
             , PartionDateKindId Integer, PartionDateKindName TVarChar
             , NewExpirationDate TDateTime
             , NewPartionDateKindId Integer, NewPartionDateKindName TVarChar
             , MovementIncomeId Integer, MI_InvNumber TVarChar, MI_OperDate TDateTime
             , ContainerId Integer
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbRetailId Integer;

    DECLARE vbDate_6 TDateTime;
    DECLARE vbDate_3 TDateTime;
    DECLARE vbDate_1 TDateTime;
    DECLARE vbDate_0 TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendPartionDateChange());
    vbUserId:= lpGetUserBySession (inSession);

    vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                 FROM MovementLinkObject AS MovementLinkObject_Unit
                 WHERE MovementLinkObject_Unit.MovementId = inMovementId
                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                );


    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

   SELECT Date_6, Date_3, Date_1, Date_0
   INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
   FROM lpSelect_PartionDateKind_SetDate ();

   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMI_Child'))
   THEN
     DROP TABLE tmpMI_Child;
   END IF;
	
   CREATE TEMP TABLE MI_Master ON COMMIT DROP AS 
                                (SELECT MovementItem.Id                         AS Id
                                      , MovementItem.ObjectId                   AS GoodsId
                                      , MovementItem.Amount                     AS Amount
                                      , MIFloat_ContainerId.ValueData::Integer  AS ContainerId
                                      , MIDate_ExpirationDate.ValueData         AS NewExpirationDate
                                      , MovementItem.isErased                   AS isErased
                                 FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                                AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                     LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_ExpirationDate()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True OR inShowAll = True)
                                 );
                                 
   ANALYSE MI_Master;

    IF inShowAll = TRUE
    THEN

        -- Результат такой
        RETURN QUERY
               WITH
                   tmpContainerPD AS (SELECT Container.Id                       AS Id
                                           , Container.ParentId                 AS ParentId
                                           , Container.Amount                   AS Amount
                                           , ContainerLinkObject.ObjectId       AS PartionGoodsId
                                      FROM Container

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                      WHERE Container.DescId = zc_Container_CountPartionDate()
                                        AND Container.WhereObjectId = vbUnitId
                                        AND Container.Amount <> 0)
                 , tmpContainer AS (SELECT Container.Id         AS ContainerId
                                         , ContainerPD.ID       AS ContainerPDId
                                         , Container.ObjectId   AS GoodsId
                                         , COALESCE (ContainerPD.Amount, Container.Amount)                                                AS Amount
                                         , COALESCE (ObjectDate_ExpirationDate.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                         , CASE WHEN ObjectDate_ExpirationDate.ValueData IS NULL      THEN NULL
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                     COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                      THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                                ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен
                                         , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)::Integer                             AS MovementIncomeId
                                    FROM Container

                                         LEFT JOIN tmpContainerPD AS ContainerPD
                                                                  ON ContainerPD.ParentId = Container.Id

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
                                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                         LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                                         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                              ON ObjectDate_ExpirationDate.ObjectId = ContainerPD.PartionGoodsId
                                                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                                 ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerPD.PartionGoodsId
                                                                AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                     WHERE Container.DescId = zc_Container_Count()
                                       AND Container.WhereObjectId = vbUnitId
                                       AND Container.Amount > 0)
                 , tmpPartionDateKind AS (SELECT Object_PartionDateKind.Id
                                               , Object_PartionDateKind.ValueData
                                          FROM Object AS Object_PartionDateKind
                                          WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind())
                 , tmpGoods AS (SELECT Object_Goods_Retail.Id
                                     , Object_Goods_Main.ObjectCode
                                     , Object_Goods_Main.Name
                                FROM Object_Goods_Retail AS Object_Goods_Retail
                                     LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                WHERE Object_Goods_Retail.RetailId = vbRetailId)


               SELECT MI_Master.Id                                      AS Id
                    , COALESCE (Container.GoodsId,  MI_Master.GoodsId)  AS GoodsId
                    , Object_Goods.ObjectCode                           AS GoodsCode
                    , Object_Goods.Name                                 AS GoodsName
                    , Container.Amount                                  AS Remains
                    , MI_Master.Amount                                  AS Amount
                    , Container.ExpirationDate                          AS ExpirationDate
                    , Object_PartionDateKind.ID                         AS PartionDateKindId
                    , Object_PartionDateKind.ValueData                  AS PartionDateKindName
                    , MI_Master.NewExpirationDate                       AS NewExpirationDate
                    , Object_NewPartionDateKind.ID                      AS PartionDateKindId
                    , Object_NewPartionDateKind.ValueData               AS PartionDateKindName
                    , Container.MovementIncomeId                        AS MovementIncomeId
                    , MovementIncome.InvNumber                          AS MI_InvNumber
                    , MovementIncome.OperDate                           AS MI_OperDate
                    , COALESCE (Container.ContainerPDId,  Container.ContainerId, MI_Master.ContainerId) AS ContainerId
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM tmpContainer AS Container
                   FULL JOIN MI_Master ON MI_Master.ContainerID = COALESCE (Container.ContainerPDId,  Container.ContainerId)
                   LEFT JOIN tmpGoods AS Object_Goods ON Object_Goods.Id = COALESCE (Container.GoodsId,  MI_Master.GoodsId)


                   LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = Container.PartionDateKindId

                   LEFT JOIN tmpPartionDateKind AS Object_NewPartionDateKind ON Object_NewPartionDateKind.Id =
                                           CASE WHEN MI_Master.NewExpirationDate Is NULL      THEN NULL
                                                WHEN MI_Master.NewExpirationDate <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                                WHEN MI_Master.NewExpirationDate <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                                WHEN MI_Master.NewExpirationDate <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                                WHEN MI_Master.NewExpirationDate <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                                ELSE  zc_Enum_PartionDateKind_Good() END
                   LEFT JOIN Movement AS MovementIncome ON MovementIncome.ID = Container.MovementIncomeId

                   ;

    ELSE

        -- Результат такой
        RETURN QUERY
               WITH
                   tmpContainerPD AS (SELECT Container.Id                       AS Id
                                           , Container.ParentId                 AS ParentId
                                           , Container.Amount                   AS Amount
                                           , ContainerLinkObject.ObjectId       AS PartionGoodsId
                                      FROM Container

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                      WHERE Container.DescId = zc_Container_CountPartionDate()
                                        AND Container.WhereObjectId = vbUnitId
                                        AND Container.ObjectId IN (SELECT DISTINCT MI_Master.GoodsId FROM MI_Master)
                                        AND Container.Amount <> 0)
                 , tmpContainer AS (SELECT Container.Id         AS ContainerId
                                         , ContainerPD.ID       AS ContainerPDId
                                         , Container.ObjectId   AS GoodsId
                                         , COALESCE (ContainerPD.Amount, Container.Amount)                                                AS Amount
                                         , COALESCE (ObjectDate_ExpirationDate.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                         , CASE WHEN ObjectDate_ExpirationDate.ValueData IS NULL      THEN NULL
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                     COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                      THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                                WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                                ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с
                                         , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)            AS MovementIncomeId
                                    FROM Container

                                         LEFT JOIN tmpContainerPD AS ContainerPD
                                                                  ON ContainerPD.ParentId = Container.Id

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
                                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                         LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                                         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                              ON ObjectDate_ExpirationDate.ObjectId = ContainerPD.PartionGoodsId
                                                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                                 ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerPD.PartionGoodsId
                                                                AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                     WHERE Container.DescId = zc_Container_Count()
                                       AND Container.WhereObjectId = vbUnitId
                                       AND Container.ObjectId IN (SELECT DISTINCT MI_Master.GoodsId FROM MI_Master)
                                       AND Container.Amount > 0)


               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.GoodsId                                 AS GoodsId
                    , Object_Goods.ObjectCode                           AS GoodsCode
                    , Object_Goods.ValueData                            AS GoodsName
                    , Container.Amount                                  AS Remains
                    , MI_Master.Amount                                  AS Amount
                    , Container.ExpirationDate                          AS ExpirationDate
                    , Object_PartionDateKind.ID                         AS PartionDateKindId
                    , Object_PartionDateKind.ValueData                  AS PartionDateKindName
                    , MI_Master.NewExpirationDate                       AS NewExpirationDate
                    , Object_NewPartionDateKind.ID                      AS PartionDateKindId
                    , Object_NewPartionDateKind.ValueData               AS PartionDateKindName
                    , Container.MovementIncomeId                        AS MovementIncomeId
                    , MovementIncome.InvNumber                          AS MI_InvNumber
                    , MovementIncome.OperDate                           AS MI_OperDate
                    , MI_Master.ContainerId                             AS ContainerId
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId

                   LEFT JOIN tmpContainer AS Container
                                          ON COALESCE (Container.ContainerPDId,  Container.ContainerId) = MI_Master.ContainerId

                   LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = Container.PartionDateKindId

                   LEFT JOIN Object AS Object_NewPartionDateKind ON Object_NewPartionDateKind.Id =
                                           CASE WHEN MI_Master.NewExpirationDate Is NULL      THEN NULL
                                                WHEN MI_Master.NewExpirationDate <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                                WHEN MI_Master.NewExpirationDate <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                                WHEN MI_Master.NewExpirationDate <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 3 месяца
                                                WHEN MI_Master.NewExpirationDate <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                                ELSE  zc_Enum_PartionDateKind_Good() END
                   LEFT JOIN Movement AS MovementIncome ON MovementIncome.ID = Container.MovementIncomeId
                   ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 01.07.20                                                      *
*/
-- select * from gpSelect_MovementItem_SendPartionDateChange(inMovementId := 19386934 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');


select * from gpSelect_MovementItem_SendPartionDateChange(inMovementId := 26943906 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');