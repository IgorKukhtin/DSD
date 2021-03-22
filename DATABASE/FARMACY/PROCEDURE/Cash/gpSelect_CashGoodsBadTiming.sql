-- Function: gpSelect_CashGoodsBadTiming()

DROP FUNCTION IF EXISTS gpSelect_CashGoodsBadTiming (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoodsBadTiming(
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               ExpirationDate TDateTime,
               PartionDateKindId Integer,
               PartionDateKindName  TVarChar,
               Price TFloat,
               AmountSend TFloat,
               AmountReserve TFloat,
               Amount TFloat,
               Remains TFloat,
               AmountCheck TFloat,
               SummaCheck TFloat,
               DivisionPartiesId Integer,
               DivisionPartiesName  TVarChar,
               DiscountExternalID Integer,
               DiscountExternalName  TVarChar,
               NDSKindId  Integer,
               AccommodationName TVarChar,
               CheckList TVarChar
               )

AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbObjectId    Integer;
  DECLARE vbUnitId      Integer;
  DECLARE vbUnitIdStr   TVarChar;

  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
  DECLARE vbDiscountExternal    boolean;
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

    IF  zfGet_Unit_DiscountExternal (13216391, vbUnitId, vbUserId) = 13216391
    THEN
      vbDiscountExternal := True;
    ELSE
      vbDiscountExternal := False;
    END IF;

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

    RETURN QUERY
    WITH
         tmpContainerSend AS (SELECT MICPD.ContainerId        AS ContainerId,
                                     SUM(-1.0 * MICPD.Amount) AS Amount
                               FROM Movement

                                    INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                                  ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()

                                    INNER JOIN MovementItemContainer AS MICPD
                                                                     ON MICPD.MovementId =  Movement.ID
                                                                    AND MICPD.descid = zc_MIContainer_CountPartionDate()
                                                                    AND MICPD.Amount < 0

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_To
                                                                 ON MovementLinkObject_Unit_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit_To.DescId = zc_MovementLinkObject_To()

                               WHERE Movement.DescId = zc_Movement_Send()
                                 AND Movement.statusid = zc_Enum_Status_UnComplete() 
                                 AND MovementLinkObject_Unit_To.ObjectId = 11299914
                                 AND COALESCE(MovementLinkObject_PartionDateKind.ObjectId, 0) = zc_Enum_PartionDateKind_0()
                                 AND MovementLinkObject_Unit.ObjectId = vbUnitId 
                               GROUP BY MICPD.Id)
       , tmpContainerPD AS (SELECT Container.Id
                                 , Container.ParentId
                                 , Container.ObjectId
                                 , COALESCE(tmpContainerSend.Amount, 0)                              AS AmountSend
                                 , Container.Amount                                                  AS Amount
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())      AS ExpirationDate
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                        ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с                             
                            FROM Container
 
                                 LEFT JOIN tmpContainerSend ON tmpContainerSend.ContainerId = Container.Id
                                                                  
                                 LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                                  
                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND (Container.Amount <> 0 OR COALESCE (tmpContainerSend.Amount, 0) <> 0)
                              AND Container.WhereObjectId = vbUnitId
                           )
       , tmpContainerAll AS (SELECT  Container.Id
                                   , Container.ObjectId
                                   , tmpContainerPD.AmountSend                                      AS AmountSend
                                   , tmpContainerPD.Amount                                          AS Amount
                                   , tmpContainerPD.ExpirationDate                                  AS ExpirationDate
                                   , tmpContainerPD.PartionDateKindId                               AS PartionDateKindId
                                   , ContainerLinkObject_DivisionParties.ObjectId                   AS DivisionPartiesId
                              FROM tmpContainerPD
                              
                                   LEFT JOIN Container ON Container.ID = tmpContainerPD.ParentId
                                                      AND Container.DescId = zc_Container_Count()
                                                      AND Container.WhereObjectId = vbUnitId
 
                                   LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                 ON ContainerLinkObject_DivisionParties.Containerid = COALESCE(Container.ParentId, Container.Id)
                                                                AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                             )

       , tmpContainerIncome AS (SELECT Container.Id
                                     , Container.ObjectId
                                     , Container.AmountSend                                            AS AmountSend
                                     , Container.Amount                                                AS Amount
                                     , Container.ExpirationDate                                        AS ExpirationDate
                                     , Container.PartionDateKindId                                     AS PartionDateKindId
                                     , Container.DivisionPartiesId                                     AS DivisionPartiesId
                                     , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                                     , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)       AS M_IncomeId
                                FROM tmpContainerAll AS Container
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
                                )
       , tmpContainer AS (SELECT Container.Id
                               , Container.ObjectId
                               , Container.AmountSend
                               , Container.Amount
                               , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                        OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                 THEN Object_Goods_Main.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                               , COALESCE(Container.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate
                               , Container.PartionDateKindId                                               AS PartionDateKindId
                               , Container.DivisionPartiesId                                               AS DivisionPartiesId
                               , CASE WHEN vbDiscountExternal = TRUE
                                      THEN Object_Goods_Juridical.DiscountExternalID
                                      ELSE NULL END                                                        AS DiscountExternalID
                          FROM tmpContainerIncome AS Container

                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Container.ObjectId
                               LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                               LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = Container.MI_IncomeId
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                               ON MovementBoolean_UseNDSKind.MovementId = Container.M_IncomeId
                                                              AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                            ON MovementLinkObject_NDSKind.MovementId = Container.M_IncomeId
                                                           AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                               LEFT OUTER JOIN MovementItem ON MovementItem.Id = Container.MI_IncomeId
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                ON MILinkObject_Goods.MovementItemId = Container.MI_IncomeId
                                                               AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                               LEFT OUTER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.Id = MILinkObject_Goods.ObjectID

                         )
       , tmpGoodsRemains AS (SELECT Container.ObjectId
                                  , Container.NDSKindId
                                  , Container.PartionDateKindId
                                  , Container.DivisionPartiesId
                                  , Container.DiscountExternalID
                                  , SUM(Container.AmountSend)                                AS AmountSend
                                  , SUM(Container.Amount)                                    AS Amount
                                  , SUM(Container.Amount) + SUM(Container.AmountSend)        AS Remains
                                  , MIN(Container.ExpirationDate)                            AS ExpirationDate
                             FROM tmpContainer AS Container
                             GROUP BY Container.ObjectId
                                    , Container.NDSKindId
                                    , Container.DiscountExternalID
                                    , Container.DivisionPartiesId
                                    , Container.PartionDateKindId
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
         -- Отложенные чеки
       , tmpMovementCheck AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                              FROM Movement
                              WHERE Movement.DescId = zc_Movement_Check()
                                AND Movement.StatusId = zc_Enum_Status_UnComplete())
       , tmpMovReserveId AS (SELECT DISTINCT Movement.Id
                                           , Movement.InvNumber
                                           , Movement.OperDate
                             FROM tmpMovementCheck AS Movement
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                AND MovementLinkObject_Unit.ObjectId = vbUnitId
                             )
       , tmpMovReserveAll AS (
                             SELECT Movement.Id
                                  , Movement.InvNumber
                                  , Movement.OperDate
                             FROM MovementBoolean AS MovementBoolean_Deferred
                                  INNER JOIN tmpMovReserveId AS Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                             WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                               AND MovementBoolean_Deferred.ValueData = TRUE
                             UNION ALL
                             SELECT Movement.Id
                                  , Movement.InvNumber
                                  , Movement.OperDate
                             FROM MovementString AS MovementString_CommentError
                                  INNER JOIN tmpMovReserveId AS Movement ON Movement.Id     = MovementString_CommentError.MovementId
                             WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                               AND MovementString_CommentError.ValueData <> ''
                             )
       , tmpReserve AS (SELECT MovementItemMaster.ObjectId                                           AS GoodsId
                             , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId) AS NDSKindId
                             , COALESCE(MILinkObject_DiscountExternal.ObjectId, 0)                   AS DiscountExternalId
                             , COALESCE(MILinkObject_DivisionParties.ObjectId, 0)                    AS DivisionPartiesId
                             , COALESCE(MILinkObject_PartionDateKind.ObjectId, 0)                    AS PartionDateKindId
                             , SUM(COALESCE (MovementItemChild.Amount, MovementItemMaster.Amount))   AS Amount
                             , STRING_AGG(Movement.InvNumber||' от '||zfConvert_DateShortToString(Movement.OperDate), ',') AS CheckList
                        FROM tmpMovReserveAll AS Movement

                             INNER JOIN MovementItem AS MovementItemMaster
                                                     ON MovementItemMaster.MovementId = Movement.Id
                                                    AND MovementItemMaster.DescId     = zc_MI_Master()
                                                    AND MovementItemMaster.isErased   = FALSE
                                                    AND MovementItemMaster.ObjectId  IN (SELECT DISTINCT tmpGoodsRemains.ObjectId FROM tmpGoodsRemains)

                             LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemMaster.ObjectId
                             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                              ON MILinkObject_NDSKind.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountExternal
                                                              ON MILinkObject_DiscountExternal.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                                              ON MILinkObject_DivisionParties.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                              ON MILinkObject_PartionDateKind.MovementItemId = MovementItemMaster.Id
                                                             AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()

                             LEFT JOIN MovementItem AS MovementItemChild
                                                    ON MovementItemChild.MovementId = Movement.Id
                                                   AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                   AND MovementItemChild.DescId     = zc_MI_Child()
                                                   AND MovementItemChild.Amount     > 0
                                                   AND MovementItemChild.isErased   = FALSE

                             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                         ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                        GROUP BY MovementItemMaster.ObjectId
                               , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId)
                               , MILinkObject_DiscountExternal.ObjectId
                               , MILinkObject_DivisionParties.ObjectId
                               , MILinkObject_PartionDateKind.ObjectId
                        )

    SELECT GoodsRemains.ObjectId                                             AS Id
         , Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name
         , GoodsRemains.ExpirationDate::TDateTime
         , GoodsRemains.PartionDateKindId                                    AS PartionDateKindId
         , Object_PartionDateKind.ValueData                                  AS PartionDateKindName
         , COALESCE(tmpObject_Price.Price,0)::TFloat                         AS Price
         , GoodsRemains.AmountSend::TFloat                                   AS AmountSend
         , COALESCE(tmpReserve.Amount, 0)::TFloat                            AS AmountReserve
         , GoodsRemains.Amount::TFloat                                       AS Amount
         , GoodsRemains.Remains::TFloat                                      AS Remains
         , 0::TFloat                                                         AS AmountCheck
         , 0::TFloat                                                         AS SummaCheck
         , GoodsRemains.DivisionPartiesId
         , Object_DivisionParties.ValueData                                  AS DivisionPartiesName
         , GoodsRemains.DiscountExternalID
         , Object_DiscountExternal.ValueData                                 AS DiscountExternalName
         , GoodsRemains.NDSKindId
         , Object_Accommodation.ValueData                                    AS AccommodationName
         , tmpReserve.CheckList::TVarChar                                    AS CheckList
    FROM  tmpGoodsRemains AS GoodsRemains 

        LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = GoodsRemains.ObjectId

        LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = GoodsRemains.ObjectId
        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
        
        LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = GoodsRemains.PartionDateKindId 
        LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = GoodsRemains.DivisionPartiesId
        LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = GoodsRemains.DiscountExternalID

        LEFT JOIN AccommodationLincGoods AS Accommodation
                                         ON Accommodation.UnitId = vbUnitId
                                        AND Accommodation.GoodsId = GoodsRemains.ObjectId
        LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId
        
        LEFT JOIN tmpReserve ON tmpReserve.GoodsId = GoodsRemains.ObjectId
                            AND tmpReserve.PartionDateKindId = COALESCE(GoodsRemains.PartionDateKindId, 0)  
                            AND tmpReserve.DivisionPartiesId = COALESCE(GoodsRemains.DivisionPartiesId, 0) 
                            AND tmpReserve.DiscountExternalID = COALESCE(GoodsRemains.DiscountExternalID, 0) 
                            AND tmpReserve.NDSKindId = GoodsRemains.NDSKindId  
        
    WHERE GoodsRemains.ExpirationDate <= CURRENT_DATE + INTERVAL '30 DAY';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.03.21                                                       * 
*/

-- тест 
SELECT * FROM gpSelect_CashGoodsBadTiming('3');