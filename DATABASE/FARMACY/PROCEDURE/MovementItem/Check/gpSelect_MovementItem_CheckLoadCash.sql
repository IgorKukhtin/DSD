-- Function: gpSelect_MovementItem_CheckLoadCash()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckLoadCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckLoadCash(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , PriceSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             , isErased Boolean
             , List_UID TVarChar
             , Remains TFloat
             , Color_calc Integer
             , Color_ExpirationDate Integer
             , AccommodationName TVarChar
             , Multiplicity TFloat
             , DoesNotShare Boolean
             , IdSP TVarChar
             , ProgramIdSP TVarChar
             , CountSP TFloat
             , PriceRetSP TFloat
             , PaymentSP TFloat
             , PartionDateKindId Integer
             , PartionDateKindName TVarChar
             , PricePartionDate TFloat
             , PartionDateDiscount TFloat
             , AmountMonth TFloat
             , TypeDiscount Integer
             , PriceDiscount TFloat
             , NDSKindId Integer
             , DiscountExternalID Integer
             , DiscountExternalName TVarChar
             , UKTZED TVarChar
             , GoodsPairSunId Integer
             , isGoodsPairSun boolean
             , GoodsPairSunMainId Integer
             , GoodsPairSunAmount TFloat
             , DivisionPartiesId Integer
             , DivisionPartiesName TVarChar
             , isPresent Boolean
             , MultiplicitySale TFloat
             , isMultiplicityError boolean
             , FixEndDate TDateTime
             , JuridicalId Integer
             , JuridicalName TVarChar
             , GoodsDiscountProcent TFloat
             , PriceSaleDiscount TFloat
             , isPriceDiscount boolean
             , GoodsPresentID Integer
             , isGoodsPresent boolean
             , PriceLoad TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
  DECLARE vbLanguage TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

     SELECT MovementLinkObject_Unit.ObjectId
     INTO vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;

     -- значения для разделения по срокам
     SELECT Date_6, Date_3, Date_1, Date_0
     INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
     FROM lpSelect_PartionDateKind_SetDate ();

    SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
    INTO vbLanguage
    FROM Object AS Object_User
                 
         LEFT JOIN ObjectString AS ObjectString_Language
                ON ObjectString_Language.ObjectId = Object_User.Id
               AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
    WHERE Object_User.Id = vbUserId;  
    
    CREATE TEMP TABLE tmpMovementItem ON COMMIT DROP AS (
    WITH
       tmpMI AS (SELECT MovementItem.Id
                      , MovementItem.MovementId
                      , MovementItem.ObjectId                                                       AS GoodsID
                      , MovementItem.Amount
                      , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId)::Integer   AS NDSKindId
                      , COALESCE(MILinkObject_PartionDateKind.ObjectId, 0)  AS PartionDateKindId
                      , COALESCE(MILinkObject_DivisionParties.ObjectId, 0)  AS DivisionPartiesID
                 FROM MovementItem AS MovementItem

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

                  WHERE MovementItem.MovementId = inMovementId
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
                          FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp

                                INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                                    AND Container.DescId = zc_Container_CountPartionDate()
                                                    AND Container.Amount <> 0
                                                    AND Container.WhereObjectId = vbUnitId

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
                           FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp

                                INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                                    AND Container.WhereObjectId = vbUnitId

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
                    THEN MovementItem.NDSKindId
                    ELSE tmpContainerOrd.NDSKindId END  <> MovementItem.NDSKindId
            OR CASE WHEN (COALESCE(MovementItem.Amount, 0) <= 0)
                      OR (COALESCE(tmpContainer.Amount, 0) >= MovementItem.Amount)
                      OR (COALESCE(tmpContainerOrd.Amount, 0) < MovementItem.Amount)
                    THEN MovementItem.PartionDateKindId
                    ELSE tmpContainerOrd.PartionDateKindId END  <> MovementItem.PartionDateKindId
            OR CASE WHEN (COALESCE(MovementItem.Amount, 0) <= 0)
                      OR (COALESCE(tmpContainer.Amount, 0) >= MovementItem.Amount)
                      OR (COALESCE(tmpContainerOrd.Amount, 0) < MovementItem.Amount)
                    THEN MovementItem.DivisionPartiesId
                    ELSE tmpContainerOrd.DivisionPartiesId END  <> MovementItem.DivisionPartiesId)
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
    
     RETURN QUERY
     WITH
     tmpMI_All AS (SELECT MovementItem.Id
                        , MovementItem.ObjectId
                        , MovementItem.Amount
                        , MovementItem.isErased
                        , MovementItem.MovementId
                        , MovementItem.ParentId	
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                   ),
     tmpMovementBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMI_all.MovementId FROM tmpMI_all)
                          ),
     tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          ),
     tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          ),
     tmpMIBoolean AS (SELECT * FROM MovementItemBoolean WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          ),
     tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          ),
     tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                          , ObjectFloat_NDSKind_NDS.ValueData
                    FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                    WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                   ),
     tmpMI AS (SELECT MovementItem.Id                     AS Id
                    , MovementItem.ObjectId               AS GoodsId
                    , MovementItem.Amount                 AS Amount
                    , MIFloat_Price.ValueData             AS Price
                    , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                                      , COALESCE (MB_RoundingDown.ValueData, False)
                                      , COALESCE (MB_RoundingTo10.ValueData, False)
                                      , COALESCE (MB_RoundingTo50.ValueData, False)) AS AmountSumm
                    , MovementItem.isErased               AS isErased
                    , MovementItem.MovementId             AS MovementId
                    , MovementItem.ParentId               AS ParentId
                    , MIFloat_PriceSale.ValueData         AS PriceSale
                    , MIFloat_ChangePercent.ValueData     AS ChangePercent
                    , MIFloat_SummChangePercent.ValueData AS SummChangePercent
                    , MIFloat_AmountOrder.ValueData       AS AmountOrder
                    , MIString_UID.ValueData              AS List_UID
                    , MIFloat_PriceLoad.ValueData         AS PriceLoad
                    , COALESCE (MIBoolean_Present.ValueData, False)                               AS isPresent
               FROM tmpMI_All AS MovementItem

                    LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                    LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                                ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                               AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                    LEFT JOIN tmpMIFloat AS MIFloat_PriceLoad
                                                ON MIFloat_PriceLoad.MovementItemId = MovementItem.Id
                                               AND MIFloat_PriceLoad.DescId = zc_MIFloat_PriceLoad()
                    LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                                ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                               AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                    LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                                ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                               AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                    LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                                                ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                    LEFT JOIN tmpMIString AS MIString_UID
                                                 ON MIString_UID.MovementItemId = MovementItem.Id
                                                AND MIString_UID.DescId = zc_MIString_UID()
                    LEFT JOIN tmpMovementBoolean AS MB_RoundingTo10
                                              ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                             AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                    LEFT JOIN tmpMovementBoolean AS MB_RoundingDown
                                              ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                             AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                    LEFT JOIN tmpMovementBoolean AS MB_RoundingTo50
                                              ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                             AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

                    LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                  ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                 AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                                                 
               ),
     tmpGoodsUKTZED AS (SELECT Object_Goods_Juridical.GoodsMainId
                             , REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')::TVarChar AS UKTZED
                             , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Juridical.GoodsMainId 
                                            ORDER BY COALESCE(Object_Goods_Juridical.AreaId, 0), Object_Goods_Juridical.JuridicalId) AS Ord
                        FROM Object_Goods_Juridical
                        WHERE COALESCE (Object_Goods_Juridical.UKTZED, '') <> ''
                          AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
                          AND Object_Goods_Juridical.GoodsMainId <> 0
                        ), 
     tmpGoodsPairSunMain AS (SELECT Object_Goods_Retail.GoodsPairSunId                          AS ID
                                  , Min(Object_Goods_Retail.Id)::Integer                        AS MainID
                             FROM Object_Goods_Retail
                             WHERE COALESCE (Object_Goods_Retail.GoodsPairSunId, 0) <> 0
                               AND Object_Goods_Retail.RetailId = 4
                             GROUP BY Object_Goods_Retail.GoodsPairSunId),
     tmpGoodsPairSun AS (SELECT Object_Goods_Retail.Id
                              , Object_Goods_Retail.GoodsPairSunId
                              , COALESCE(Object_Goods_Retail.PairSunAmount, 1)::TFloat AS GoodsPairSunAmount
                         FROM Object_Goods_Retail
                         WHERE COALESCE (Object_Goods_Retail.GoodsPairSunId, 0) <> 0
                           AND Object_Goods_Retail.RetailId = 4),
     tmpObject AS (SELECT * FROM Object 
                         WHERE Object.Id IN (SELECT DISTINCT tmpMILinkObject.ObjectId FROM tmpMILinkObject)),
     tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                               , Object_Object.Id                                          AS GoodsDiscountId
                               , Object_Object.ValueData                                   AS GoodsDiscountName
                               , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                               , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                               , MAX(ObjectFloat_DiscountProcent.ValueData)::TFloat        AS DiscountProcent 
                            FROM Object AS Object_BarCode
                                INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                      ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                     ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                    AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                        ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id 
                                                       AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                      ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                     AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                      ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                     AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

                            WHERE Object_BarCode.DescId = zc_Object_BarCode()
                              AND Object_BarCode.isErased = False
                            GROUP BY Object_Goods_Retail.GoodsMainId
                                   , Object_Object.Id
                                   , Object_Object.ValueData
                                   , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)
                            HAVING MAX(ObjectFloat_DiscountProcent.ValueData) > 0),
     tmpGoodsDiscountPrice AS (SELECT MovementItem.Id
                                    , CASE WHEN Object_Goods.isTop = TRUE
                                            AND Object_Goods.Price > 0
                                           THEN Object_Goods.Price
                                           ELSE ObjectFloat_Price_Value.ValueData
                                           END AS Price
                                    , tmpGoodsDiscount.DiscountProcent
                                    , tmpGoodsDiscount.MaxPrice
                               FROM tmpGoodsDiscount
                                            
                                    INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = tmpGoodsDiscount.GoodsMainId
                                            
                                    INNER JOIN tmpMI AS MovementItem ON MovementItem.GoodsId = Object_Goods.Id
                        
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                          ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                         AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                    INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                          ON ObjectLink_Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                                         AND ObjectLink_Price_Goods.ChildObjectId = Object_Goods.Id 
                                                         AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                          ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                         AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                                            ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                               WHERE COALESCE(tmpGoodsDiscount.DiscountProcent, 0) > 0                                        
                               )

       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , MovementItem.GoodsId
           , Object_Goods_Main.ObjectCode                                        AS GoodsCode
           , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                  THEN Object_Goods_Main.NameUkr
                  ELSE Object_Goods_Main.Name END                                AS GoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , ObjectFloat_NDSKind_NDS.ValueData   AS NDS
           , MovementItem.PriceSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent
           , MovementItem.AmountOrder
           , MovementItem.isErased
           , MovementItem.List_UID
           , MovementItem.Amount
           , zc_Color_White()                                                    AS Color_calc
           , zc_Color_Black()                                                    AS Color_ExpirationDate
           , Null::TVArChar                                                      AS AccommodationName
           , Null::TFloat                                                        AS Multiplicity
           , COALESCE (Object_Goods_Main.isDoesNotShare, FALSE)                  AS DoesNotShare
           , Null::TVArChar                                                      AS IdSP
           , Null::TVArChar                                                      AS ProgramIdSP
           , Null::TFloat                                                        AS CountSP
           , Null::TFloat                                                        AS PriceRetSP
           , Null::TFloat                                                        AS PaymentSP
           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , MIFloat_MovementItem.ValueData                                      AS PricePartionDate
           , Null::TFloat                                                        AS PartionDateDiscount
           , CASE Object_PartionDateKind.Id 
             WHEN zc_Enum_PartionDateKind_Good() THEN 200 / 30.0 + 1.0
             WHEN zc_Enum_PartionDateKind_Cat_5() THEN 200 / 30.0 - 1.0
             ELSE COALESCE (ObjectFloatDay.ValueData / 30, 0) END::TFloat        AS AmountMonth
           , 0::Integer                                                          AS TypeDiscount
           , COALESCE(MIFloat_MovementItem.ValueData, MovementItem.PriceSale)    AS PriceDiscount
           , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId)::Integer     AS NDSKindId
           , Object_DiscountExternal.ID                                          AS DiscountCardId
           , Object_DiscountExternal.ValueData                                   AS DiscountCardName
           , tmpGoodsUKTZED.UKTZED                                               AS UKTZED
           , Object_Goods_PairSun_Main.MainID                                    AS GoodsPairSunId
           , COALESCE(Object_Goods_PairSun_Main.MainID, 0) <> 0                  AS isGoodsPairSun
           , Object_Goods_PairSun.GoodsPairSunID                                 AS GoodsPairSunMainId
           , Object_Goods_PairSun.GoodsPairSunAmount                             AS GoodsPairSunAmount
           , Object_DivisionParties.Id                                           AS DivisionPartiesId 
           , Object_DivisionParties.ValueData                                    AS DivisionPartiesName 
           , MovementItem.isPresent                                              AS isPresent
           , Object_Goods_Main.Multiplicity                                      AS MultiplicitySale
           , Object_Goods_Main.isMultiplicityError                               AS isMultiplicityError
           , Null::TDateTime                                                     AS FixEndDate 
           , MILinkObject_Juridical.ObjectId                                     AS JuridicalId 
           , Object_Juridical.ValueData                                          AS JuridicalName
           , tmpGoodsDiscountPrice.DiscountProcent                               AS GoodsDiscountProcent
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN NULL
                  WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                  THEN tmpGoodsDiscountPrice.Price 
                  ELSE tmpGoodsDiscountPrice.MaxPrice END :: TFLoat              AS PriceSaleDiscount
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN FALSE
                  WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 100 AND COALESCE (MovementItem.Price, 0) = 0
                  THEN TRUE
                  ELSE MovementItem.Price <
                      CASE WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                           THEN tmpGoodsDiscountPrice.Price ELSE tmpGoodsDiscountPrice.MaxPrice END * 98 / 100
                  END :: BOOLEAN                                                 AS isPriceDiscount
           , COALESCE (MILinkObject_GoodsPresent.ObjectId, 0)                    AS GoodsPresentID
           , COALESCE (MIBoolean_GoodsPresent.ValueData, False)                  AS isGoodsPresent
           , MovementItem.PriceLoad

       FROM tmpMI AS MovementItem

            LEFT JOIN tmpMIFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_PricePartionDate()
            -- получаем GoodsMainId
            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
            
            LEFT JOIN tmpMILinkObject AS MILinkObject_NDSKind
                                             ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
                                                    
            LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                 ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId)

            LEFT JOIN tmpGoodsPairSun AS Object_Goods_PairSun
                                      ON Object_Goods_PairSun.Id = MovementItem.GoodsId
            LEFT JOIN tmpGoodsPairSunMain AS Object_Goods_PairSun_Main
                                          ON Object_Goods_PairSun_Main.Id = MovementItem.GoodsId

            --Типы срок/не срок
            LEFT JOIN tmpMILinkObject AS MI_PartionDateKind
                                             ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                            AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
            LEFT JOIN tmpObject AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloatDay
                                  ON ObjectFloatDay.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloatDay.DescId = zc_ObjectFloat_PartionDateKind_Day()

            LEFT JOIN tmpMILinkObject AS MILinkObject_DiscountExternal
                                             ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                            AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
            LEFT JOIN tmpObject AS Object_DiscountExternal ON Object_DiscountExternal.Id = MILinkObject_DiscountExternal.ObjectId

            -- Коды UKTZED
            LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                    AND tmpGoodsUKTZED.Ord = 1

            LEFT JOIN tmpMILinkObject AS MILinkObject_DivisionParties
                                             ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                            AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
            LEFT JOIN tmpObject AS Object_DivisionParties ON Object_DivisionParties.Id = MILinkObject_DivisionParties.ObjectId
            
            LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                             ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Juridical.DescId         = zc_MILinkObject_Juridical()
            LEFT JOIN tmpObject AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId
            
            LEFT JOIN tmpGoodsDiscountPrice ON tmpGoodsDiscountPrice.Id = MovementItem.Id

            LEFT JOIN tmpMILinkObject AS MILinkObject_GoodsPresent
                                             ON MILinkObject_GoodsPresent.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsPresent.DescId = zc_MILinkObject_GoodsPresent()
            LEFT JOIN tmpMIBoolean AS MIBoolean_GoodsPresent
                                          ON MIBoolean_GoodsPresent.MovementItemId = MovementItem.Id
                                         AND MIBoolean_GoodsPresent.DescId         = zc_MIBoolean_GoodsPresent()

       ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckLoadCash (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 25.04.19                                                                                   *
 */

-- тест
-- 
 
select * from gpSelect_MovementItem_CheckLoadCash(inMovementId := 29602143 ,  inSession := '3');