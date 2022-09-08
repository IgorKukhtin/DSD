--- Function: gpSelect_MovementItem_SalePromoGoodsSign()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_SalePromoGoodsSign (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SalePromoGoodsSign(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , JuridicalName TVarChar
             , RetailName    TVarChar
             , IsChecked Boolean
             , IsErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);
    
    
    vbRetailId := COALESCE ((SELECT MovementLinkObject_Retail.ObjectId FROM MovementLinkObject AS MovementLinkObject_Retail
                             WHERE MovementLinkObject_Retail.MovementId = inMovementId
                               AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()), 0);

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
           WITH
           tmpUnit AS (SELECT T1.Id AS UnitId FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS T1
                       )
         , tmpMI AS (SELECT MI_SalePromoGoods.Id             AS Id
                          , MI_SalePromoGoods.ObjectId       AS ObjectId
                          , MI_SalePromoGoods.Amount         AS Amount
                          , MI_SalePromoGoods.IsErased       AS IsErased
                     FROM MovementItem AS MI_SalePromoGoods
                     WHERE MI_SalePromoGoods.MovementId = inMovementId
                       AND MI_SalePromoGoods.DescId = zc_MI_Sign()
                       AND (MI_SalePromoGoods.isErased = FALSE or inIsErased = TRUE)
                    )

           SELECT COALESCE (tmpMI.Id, 0)                AS Id
                , Object_Unit.Id                        AS UnitId
                , Object_Unit.ObjectCode                AS UnitCode
                , Object_Unit.ValueData                 AS UnitName
                , Object_Juridical.ValueData            AS JuridicalName
                , Object_Retail.ValueData               AS RetailName
                , CASE WHEN COALESCE (tmpMI.Amount, 0) = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , COALESCE (tmpMI.IsErased, FALSE)      AS IsErased
           FROM tmpUnit

               FULL JOIN tmpMI ON tmpMI.ObjectId = tmpUnit.UnitId
                         
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpMI.ObjectId, tmpUnit.UnitId)

               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                    ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
           WHERE vbRetailId = 0 OR ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId OR tmpMI.ObjectId <> 0
           ;
    ELSE
    -- Результат другой
    RETURN QUERY
           SELECT MI_SalePromoGoods.Id
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                , Object_Juridical.ValueData         AS JuridicalName
                , Object_Retail.ValueData            AS RetailName
                , CASE WHEN MI_SalePromoGoods.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_SalePromoGoods.IsErased
           FROM MovementItem AS MI_SalePromoGoods

               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI_SalePromoGoods.ObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                    ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           WHERE MI_SalePromoGoods.MovementId = inMovementId
             AND MI_SalePromoGoods.DescId = zc_MI_Sign()
             AND (MI_SalePromoGoods.isErased = FALSE or inIsErased = TRUE);
    END IF;
 
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.22                                                       *
*/

-- select * from gpSelect_MovementItem_SalePromoGoodsSign(inMovementId := 0  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3'::TVarChar);