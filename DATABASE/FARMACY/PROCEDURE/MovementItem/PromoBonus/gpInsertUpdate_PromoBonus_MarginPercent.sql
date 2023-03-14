-- Function: gpInsertUpdate_PromoBonus_MarginPercent()

DROP FUNCTION IF EXISTS gpInsertUpdate_PromoBonus_MarginPercent (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_PromoBonus_MarginPercent(
    IN inMovementId    Integer ,   --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
                        
     CREATE TEMP TABLE tmpMIPromoBonus_MarginPercent ON COMMIT DROP AS
     SELECT MovementItem.ObjectId                            AS GoodsId
     FROM MovementItem

          LEFT JOIN MovementItemFloat AS MIFloat_BonusInetOrder
                                      ON MIFloat_BonusInetOrder.MovementItemId = MovementItem.Id
                                     AND MIFloat_BonusInetOrder.DescId = zc_MIFloat_BonusInetOrder()

     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND (MovementItem.Amount > 0 OR COALESCE (MIFloat_BonusInetOrder.ValueData, 0) > 0)
       AND MovementItem.isErased = False
     GROUP BY MovementItem.ObjectId;
     
     ANALYSE tmpMIPromoBonus_MarginPercent;
     
     raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpMIPromoBonus_MarginPercent);     
     
     CREATE TEMP TABLE tmpUnit_MarginPercent ON COMMIT DROP AS
     SELECT Object_Unit_View.Id
     FROM Object_Unit_View
     WHERE Object_Unit_View.iserased = False 
       AND COALESCE (Object_Unit_View.ParentId, 0) <> 377612
       AND Object_Unit_View.Id <> 389328
       AND Object_Unit_View.Name NOT ILIKE 'Зачинена%'
       AND COALESCE (Object_Unit_View.ParentId, 0) IN 
           (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0);
           
     ANALYSE tmpUnit_MarginPercent;

     CREATE TEMP TABLE tmpMIAll_MarginPercent ON COMMIT DROP AS
     WITH tmpMI AS(SELECT Movement.OperDate
                        , MovementLinkObject_Unit.ObjectId                AS UnitId
                        , MovementItem.Id                                 AS ID
                        , MovementItem.ObjectId                           AS GoodsID
                        , MIFloat_JuridicalPrice.ValueData                AS JuridicalPrice
                        , ROW_NUMBER() OVER (PARTITION BY MovementLinkObject_Unit.ObjectId, MovementItem.ObjectId  ORDER BY Movement.OperDate DESC) AS Ord
                   FROM tmpMIPromoBonus_MarginPercent 
                                        
                        INNER JOIN MovementItem ON MovementItem.ObjectId = tmpMIPromoBonus_MarginPercent.GoodsID
                                               AND MovementItem.DescId = zc_MI_Master()
                                        

                        INNER JOIN Movement ON Movement.DescId = zc_Movement_Reprice()
                                           AND Movement.Id = MovementItem.MovementId
                                           AND Movement.StatusId <> zc_Enum_Status_Erased()

                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        INNER JOIN tmpUnit_MarginPercent ON tmpUnit_MarginPercent.ID = MovementLinkObject_Unit.ObjectId

                        INNER JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                     ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.Id
                                                    AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                                                    AND MIFloat_JuridicalPrice.ValueData > 0

                        LEFT JOIN MovementItemBoolean AS MIBoolean_ClippedReprice
                                                      ON MIBoolean_ClippedReprice.MovementItemId = MovementItem.Id
                                                     AND MIBoolean_ClippedReprice.DescId         = zc_MIBoolean_ClippedReprice()
                                                                   
                   WHERE COALESCE(MIBoolean_ClippedReprice.ValueData, False) = FALSE)
                     
     SELECT tmpMI.OperDate
          , tmpMI.UnitId
          , tmpMI.Id
          , tmpMI.GoodsID
          , tmpMI.JuridicalPrice
     FROM tmpMI
     WHERE tmpMI.Ord = 1;
     
     ANALYSE tmpMIAll_MarginPercent;
     
     raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM tmpMIAll_MarginPercent);  
                        
     PERFORM lpInsertUpdate_MI_PromoBonus_Child(inId             := tmpMarginPercent.Id
                                              , inMovementId     := inMovementId
                                              , inParentId       := tmpMarginPercent.ParentId 
                                              , inUnitId         := tmpMarginPercent.UnitId
                                              , inMarginPercent  := tmpMarginPercent.MarginPercent
                                              , inUserId         := vbUserId)
     FROM (
     WITH DD AS(
                  SELECT DISTINCT
                      Object_MarginCategoryItem_View.MarginPercent,
                      Object_MarginCategoryItem_View.MinPrice,
                      Object_MarginCategoryItem_View.MarginCategoryId,
                      ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
                  FROM Object_MarginCategoryItem_View
                       INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                     AND Object_MarginCategoryItem.isErased = FALSE
                      )
               , MarginCondition AS (
                  SELECT
                      D1.MarginCategoryId,
                      D1.MarginPercent,
                      D1.MinPrice,
                      COALESCE(D2.MinPrice, 1000000) AS MaxPrice
                  FROM DD AS D1
                      LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
                      )

     SELECT MIChild.Id
          , MIMaster.ID                   AS ParentId
          , tmpMI.GoodsID                 AS GoodsID
          , tmpMI.UnitID                  AS UnitID
          , CASE WHEN COALESCE (MIFloat_ContractPercent.ValueData, 0) <> 0
                 THEN COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_ContractPercent.ValueData, 0)
                 ELSE COALESCE (MarginCondition.MarginPercent,0) + COALESCE (MIFloat_JuridicalPercent.ValueData, 0)
                 END::TFloat         AS MarginPercent

     FROM tmpMIAll_MarginPercent AS tmpMI
     
          LEFT JOIN Object_Goods_Retail AS Object_Goods
                                        ON Object_Goods.Id = tmpMI.GoodsID
          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
          
          LEFT JOIN tmpMIPromoBonus_MarginPercent ON tmpMIPromoBonus_MarginPercent.GoodsID = tmpMI.GoodsID

          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

          LEFT JOIN MovementItemLinkObject AS MI_Juridical
                                           ON MI_Juridical.MovementItemId = tmpMI.Id
                                          AND MI_Juridical.DescId = zc_MILinkObject_Juridical()

          LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_unit
                                                   ON Object_MarginCategoryLink_unit.UnitId = tmpMI.UnitID  
                                                  AND Object_MarginCategoryLink_unit.JuridicalId = MI_Juridical.ObjectId
          LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                   ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                  AND Object_MarginCategoryLink_all.JuridicalId = MI_Juridical.ObjectId
                                                  AND Object_MarginCategoryLink_unit.JuridicalId IS NULL

          LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPercent
                                      ON MIFloat_JuridicalPercent.MovementItemId = tmpMI.Id
                                     AND MIFloat_JuridicalPercent.DescId = zc_MIFloat_JuridicalPercent()
          LEFT JOIN MovementItemFloat AS MIFloat_ContractPercent
                                      ON MIFloat_ContractPercent.MovementItemId = tmpMI.Id
                                     AND MIFloat_ContractPercent.DescId = zc_MIFloat_ContractPercent()

          LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink_unit.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                  AND (tmpMI.JuridicalPrice  * (100 + ObjectFloat_NDSKind_NDS.ValueData  )/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
                                  
          INNER JOIN MovementItem AS MIMaster
                                  ON MIMaster.MovementId = inMovementId
                                 AND MIMaster.DescId = zc_MI_Master()
                                 AND MIMaster.ObjectId = tmpMI.GoodsID
                                  
          LEFT JOIN MovementItem AS MIChild
                                 ON MIChild.MovementId = inMovementId
                                AND MIChild.ParentId = MIMaster.Id
                                AND MIChild.DescId = zc_MI_Child()
                                AND MIChild.ObjectId = tmpMI.UnitID

     WHERE COALESCE(Object_Goods.isTop, FALSE) = FALSE) AS tmpMarginPercent

     ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_PromoBonus_MarginPercent (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.   Шаблий О.В.
 11.03.23                                                                          *
*/

-- ТЕСТ
--

select * from gpInsertUpdate_PromoBonus_MarginPercent(inMovementId := 22188745  ,  inSession := '3');