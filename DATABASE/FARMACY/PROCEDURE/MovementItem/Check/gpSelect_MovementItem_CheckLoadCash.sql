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
             , DivisionPartiesId Integer
             , DivisionPartiesName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
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

     -- Правим НДС если надо
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NDSKind(), T1.Id, T1.NDSKindId)
     FROM (WITH
         tmpMI AS (SELECT MovementItem.*
                   FROM MovementItem_Check_View AS MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                   )
       , tmpContainerAll AS (SELECT Container.ObjectId
                                  , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                           OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                    THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                                  , Container.Amount
                             FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmp

                                   INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                                       AND Container.DescId = zc_Container_Count()
                                                       AND Container.Amount <> 0
                                                       AND Container.WhereObjectId = vbUnitId

                                  LEFT JOIN ContainerlinkObject AS CLO_MovementItem
                                                                ON CLO_MovementItem.Containerid = Container.Id
                                                               AND CLO_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
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
                               , SUM(Container.Amount) AS Amount
                          FROM tmpContainerAll AS Container
                          GROUP BY Container.ObjectId
                                 , Container.NDSKindId
                          )
       , tmpContainerOrd AS (SELECT Container.ObjectId
                                  , Container.NDSKindId
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
               , tmpContainerOrd.NDSKindId 
           FROM tmpMI AS MovementItem

                LEFT JOIN tmpContainer ON tmpContainer.ObjectId = MovementItem.GoodsId
                                      AND tmpContainer.NDSKindId = MovementItem.NDSKindId

                LEFT JOIN tmpContainerOrd ON tmpContainerOrd.ObjectId = MovementItem.GoodsId
                                         AND tmpContainerOrd.Ord = 1
           WHERE CASE WHEN (COALESCE(MovementItem.Amount, 0) <= 0)
                        OR (COALESCE(tmpContainer.Amount, 0) >= MovementItem.Amount)
                        OR (COALESCE(tmpContainerOrd.Amount, 0) < MovementItem.Amount)
                      THEN MovementItem.NDSKindId 
                      ELSE tmpContainerOrd.NDSKindId END  <> MovementItem.NDSKindId) AS T1; 

     RETURN QUERY
     WITH
     tmpMI AS (SELECT MovementItem.*
               FROM MovementItem_Check_View AS MovementItem
               WHERE MovementItem.MovementId = inMovementId
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
     tmpGoodsPairSun AS (SELECT Object_Goods_Retail.Id
                              , Object_Goods_Retail.GoodsPairSunId
                         FROM Object_Goods_Retail 
                         WHERE COALESCE (Object_Goods_Retail.GoodsPairSunId, 0) <> 0
                           AND Object_Goods_Retail.RetailId = 4)

       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.NDS                                                    AS NDS
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
           , COALESCE (ObjectBoolean_DoesNotShare.ValueData, FALSE)              AS DoesNotShare
           , Null::TVArChar                                                      AS IdSP
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
           , MovementItem.NDSKindId                                              AS NDSKindId
           , Object_DiscountExternal.ID                                          AS DiscountCardId
           , Object_DiscountExternal.ValueData                                   AS DiscountCardName
           , tmpGoodsUKTZED.UKTZED                                               AS UKTZED
           , Object_Goods_PairSun.ID                                             AS GoodsPairSunId         
           , Object_DivisionParties.Id                                           AS DivisionPartiesId 
           , Object_DivisionParties.ValueData                                    AS DivisionPartiesName 
           FROM tmpMI AS MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_PricePartionDate()
            -- получаем GoodsMainId
            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.GoodsId
            LEFT JOIN tmpGoodsPairSun AS Object_Goods_PairSun 
                                      ON Object_Goods_PairSun.GoodsPairSunId = MovementItem.GoodsId

            -- Не делить медикамент на кассах
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DoesNotShare
                                    ON ObjectBoolean_DoesNotShare.ObjectId = MovementItem.GoodsId
                                   AND ObjectBoolean_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()
            --Типы срок/не срок
            LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                             ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                            AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloatDay
                                  ON ObjectFloatDay.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloatDay.DescId = zc_ObjectFloat_PartionDateKind_Day()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountExternal
                                             ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                            AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = MILinkObject_DiscountExternal.ObjectId

            -- Коды UKTZED
            LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                    AND tmpGoodsUKTZED.Ord = 1

            LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                             ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                            AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
            LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = MILinkObject_DivisionParties.ObjectId
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
-- select * from gpSelect_MovementItem_CheckLoadCash(inMovementId := 18769698 ,  inSession := '3');
-- select * from gpSelect_MovementItem_CheckLoadCash(inMovementId := 18805062    ,  inSession := '3');

