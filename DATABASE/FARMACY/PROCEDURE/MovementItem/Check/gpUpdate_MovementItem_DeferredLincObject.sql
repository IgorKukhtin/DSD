-- Function: gpUpdate_MovementItem_DeferredLincObject()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_DeferredLincObject (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_DeferredLincObject(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

    CREATE TEMP TABLE tmpMovementItem ON COMMIT DROP AS (
    WITH
       tmpMovementCheck AS (SELECT Movement.Id
                            FROM Movement
                            WHERE Movement.DescId = zc_Movement_Check()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete())
     , tmpMovReserveId AS (
                        SELECT Movement.Id
                             , COALESCE(MovementBoolean_Deferred.ValueData, FALSE) AS  isDeferred
                        FROM tmpMovementCheck AS Movement
                             LEFT JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                       AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                          )

     , tmpMov AS (
                        SELECT Movement.Id
                             , MovementLinkObject_Unit.ObjectId            AS UnitId
                        FROM tmpMovReserveId AS Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                    --      AND MovementLinkObject_Unit.ObjectId = 183292
                        WHERE isDeferred = TRUE)

     , tmpMI AS (SELECT Movement.UnitId
                      , MovementItem.Id
                      , MovementItem.MovementId
                      , MovementItem.ObjectId                                                       AS GoodsID
                      , MovementItem.Amount
                      , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)::Integer   AS NDSKindId
                      , COALESCE(MILinkObject_PartionDateKind.ObjectId, 0)  AS PartionDateKindId
                      , COALESCE(MILinkObject_DivisionParties.ObjectId, 0)  AS DivisionPartiesID
                 FROM MovementItem AS MovementItem

                      LEFT JOIN tmpMov AS Movement ON Movement.Id = MovementItem.MovementId

                      LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                      LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                       ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                       ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                                       ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
                  WHERE MovementItem.MovementId in (SELECT tmpMov.ID FROM tmpMov)
                    AND MovementItem.DescId = zc_MI_Master()
                 )
     , tmpContainerPD AS (SELECT Container.ParentId
                               , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                           COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                            THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                      WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                      WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                      WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 1 месяца
                                      WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                      ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                               , Container.Amount
                          FROM (SELECT DISTINCT tmpMI.UnitId, tmpMI.GoodsId FROM tmpMI) AS tmp

                                INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                                    AND Container.DescId = zc_Container_CountPartionDate()
                                                    AND Container.Amount <> 0
                                                    AND Container.WhereObjectId = tmp.UnitId

                               LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()


                               LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                    ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                   AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                       ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                      AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                           )
     , tmpContainerAll AS (SELECT Container.ObjectId
                                , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                         OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                  THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                                , COALESCE(tmpContainerPD.PartionDateKindId, 0)                             AS PartionDateKindId
                                , COALESCE(ContainerLinkObject_DivisionParties.ObjectId, 0)                 AS DivisionPartiesId
                                , COALESCE(tmpContainerPD.Amount,  Container.Amount)                        AS Amount
                           FROM (SELECT DISTINCT tmpMI.UnitId, tmpMI.GoodsId FROM tmpMI) AS tmp

                                INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                                    AND Container.WhereObjectId =  tmp.UnitId

                                LEFT JOIN tmpContainerPD ON tmpContainerPD.ParentId = Container.Id

                                LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                              ON CLO_MovementItem.Containerid = Container.Id
                                                             AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                              ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                             AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_MovementItem.ObjectId
                                -- элемент прихода
                                LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                            ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                                LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
                                LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                                LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                               AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                             ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                                            AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                           )
     , tmpContainer AS (SELECT Container.ObjectId
                             , Container.NDSKindId
                             , Container.PartionDateKindId
                             , Container.DivisionPartiesId
                             , SUM(Container.Amount) AS Amount
                        FROM tmpContainerAll AS Container
                        GROUP BY Container.ObjectId
                               , Container.NDSKindId
                               , Container.PartionDateKindId
                               , Container.DivisionPartiesId
                        )
     , tmpContainerOrd AS (SELECT Container.ObjectId
                                , Container.NDSKindId
                                , Container.PartionDateKindId
                                , Container.DivisionPartiesId
                                , Container.Amount
                                , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) AS NDS
                                , ROW_NUMBER() OVER (PARTITION BY Container.ObjectId ORDER BY Container.Amount DESC) AS Ord
                           FROM tmpContainer AS Container
                                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = Container.NDSKindId
                                                     AND ObjectFloat_NDSKind_NDS.DescId   = zc_ObjectFloat_NDSKind_NDS()
                           )

         SELECT
               MovementItem.Id
             , MovementItem.MovementId
             , tmpContainerOrd.NDSKindId
             , tmpContainerOrd.PartionDateKindId
             , tmpContainerOrd.DivisionPartiesId
             , MovementItem.PartionDateKindId             AS PartionDateKindOldId
         FROM tmpMI AS MovementItem

              LEFT JOIN tmpContainer ON tmpContainer.ObjectId          = MovementItem.GoodsId
                                    AND tmpContainer.NDSKindId         = MovementItem.NDSKindId
                                    AND tmpContainer.DivisionPartiesId = MovementItem.DivisionPartiesId
                                    AND tmpContainer.PartionDateKindId = MovementItem.PartionDateKindId

              LEFT JOIN tmpContainerOrd ON tmpContainerOrd.ObjectId = MovementItem.GoodsId
                                       AND tmpContainerOrd.Ord = 1
         WHERE CASE WHEN (COALESCE(MovementItem.Amount, 0) <= 0)
                      OR (COALESCE(tmpContainer.Amount, 0) >= MovementItem.Amount)
                      OR (COALESCE(tmpContainerOrd.Amount, 0) < MovementItem.Amount)
                    THEN COALESCE(MovementItem.NDSKindId, 0)
                    ELSE COALESCE(tmpContainerOrd.NDSKindId, 0) END  <> COALESCE(MovementItem.NDSKindId, 0)
            OR CASE WHEN (COALESCE(MovementItem.Amount, 0) <= 0)
                      OR (COALESCE(tmpContainer.Amount, 0) >= MovementItem.Amount)
                      OR (COALESCE(tmpContainerOrd.Amount, 0) < MovementItem.Amount)
                    THEN COALESCE(MovementItem.PartionDateKindId, 0)
                    ELSE COALESCE(tmpContainerOrd.PartionDateKindId, 0) END  <> COALESCE(MovementItem.PartionDateKindId, 0)
            OR CASE WHEN (COALESCE(MovementItem.Amount, 0) <= 0)
                      OR (COALESCE(tmpContainer.Amount, 0) >= MovementItem.Amount)
                      OR (COALESCE(tmpContainerOrd.Amount, 0) < MovementItem.Amount)
                    THEN COALESCE(MovementItem.DivisionPartiesId, 0)
                    ELSE COALESCE(tmpContainerOrd.DivisionPartiesId, 0) END  <> COALESCE(MovementItem.DivisionPartiesId, 0))
         ;

     -- Правим НДС если надо
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NDSKind(), tmpMovementItem.Id, tmpMovementItem.NDSKindId)
          , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DivisionParties(), tmpMovementItem.Id, COALESCE (tmpMovementItem.DivisionPartiesId, 0))
    FROM tmpMovementItem;
    
    IF EXISTS(SELECT 1 FROM tmpMovementItem WHERE COALESCE(tmpMovementItem.PartionDateKindId, 0) <> COALESCE(tmpMovementItem.PartionDateKindOldId, 0))
    THEN
      PERFORM gpUpdate_MovementIten_Check_PartionDateKind (inMovementId         := tmpMovementItem.MovementId
                                                         , inMovementItemID     := tmpMovementItem.Id
                                                         , inPartionDateKindId  := tmpMovementItem.PartionDateKindId
                                                         , inSession            := inSession)
      FROM tmpMovementItem 
      WHERE COALESCE(tmpMovementItem.PartionDateKindId, 0) <> COALESCE(tmpMovementItem.PartionDateKindOldId, 0);
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_DeferredLincObject (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 02.10.20                                                                                   *
 */

-- тест
-- select * from gpUpdate_MovementItem_DeferredLincObject(inSession := '3');
