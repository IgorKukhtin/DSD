--- Function: gpSelect_MovementItem_LoyaltyPresentChild()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_LoyaltyPresentChild (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LoyaltyPresentChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , DayCount      Integer, SummLimit     TFloat
             , JuridicalName TVarChar
             , RetailName    TVarChar
             , IsChecked Boolean
             , IsErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
           WITH
           tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                       FROM Object AS Object_Unit
                            INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                  ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                                 AND ObjectLink_Unit_Parent.ChildObjectId > 0
                            INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                 AND ObjectLink_Juridical_Retail.ChildObjectId = 
                                                     (SELECT MovementLinkObject_Retail.ObjectId FROM MovementLinkObject AS MovementLinkObject_Retail
                                                      WHERE MovementLinkObject_Retail.MovementId = inMovementId
                                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail())                            
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = inIsErased OR inIsErased = TRUE
                       )
         , tmpMI AS (SELECT MI_LoyaltyPresent.Id             AS Id
                          , MI_LoyaltyPresent.ObjectId       AS ObjectId
                          , MI_LoyaltyPresent.Amount         AS Amount
                          , MI_LoyaltyPresent.IsErased       AS IsErased
                          , COALESCE(MIFloat_DayCount.ValueData,0)::Integer          AS DayCount
                          , COALESCE(MIFloat_Limit.ValueData,0)::TFloat              AS SummLimit
                     FROM MovementItem AS MI_LoyaltyPresent
                    
                          LEFT JOIN MovementItemFloat AS MIFloat_DayCount
                                                      ON MIFloat_DayCount.MovementItemId =  MI_LoyaltyPresent.Id
                                                      AND MIFloat_DayCount.DescId = zc_MIFloat_DayCount()
                          LEFT JOIN MovementItemFloat AS MIFloat_Limit
                                                      ON MIFloat_Limit.MovementItemId =  MI_LoyaltyPresent.Id
                                                     AND MIFloat_Limit.DescId = zc_MIFloat_Limit()

                     WHERE MI_LoyaltyPresent.MovementId = inMovementId
                       AND MI_LoyaltyPresent.DescId = zc_MI_Child()
                       AND (MI_LoyaltyPresent.isErased = FALSE or inIsErased = TRUE)
                    )

           SELECT COALESCE (tmpMI.Id, 0)                AS Id
                , Object_Unit.Id                        AS UnitId
                , Object_Unit.ObjectCode                AS UnitCode
                , Object_Unit.ValueData                 AS UnitName
                , tmpMI.DayCount
                , tmpMI.SummLimit
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
           ;
    ELSE
    -- Результат другой
    RETURN QUERY
           SELECT MI_LoyaltyPresent.Id
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                , COALESCE(MIFloat_DayCount.ValueData,0)::Integer          AS DayCount
                , COALESCE(MIFloat_Limit.ValueData,0)::TFloat              AS SummLimit
                , Object_Juridical.ValueData         AS JuridicalName
                , Object_Retail.ValueData            AS RetailName
                , CASE WHEN MI_LoyaltyPresent.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_LoyaltyPresent.IsErased
           FROM MovementItem AS MI_LoyaltyPresent

               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI_LoyaltyPresent.ObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                    ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

               LEFT JOIN MovementItemFloat AS MIFloat_DayCount
                                           ON MIFloat_DayCount.MovementItemId =  MI_LoyaltyPresent.Id
                                           AND MIFloat_DayCount.DescId = zc_MIFloat_DayCount()
               LEFT JOIN MovementItemFloat AS MIFloat_Limit
                                           ON MIFloat_Limit.MovementItemId =  MI_LoyaltyPresent.Id
                                          AND MIFloat_Limit.DescId = zc_MIFloat_Limit()

           WHERE MI_LoyaltyPresent.MovementId = inMovementId
             AND MI_LoyaltyPresent.DescId = zc_MI_Child()
             AND (MI_LoyaltyPresent.isErased = FALSE or inIsErased = TRUE);
    END IF;
 
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.09.20                                                       *
*/

-- select * from gpSelect_MovementItem_LoyaltyPresentChild(inMovementId := 16406918  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3'::TVarChar);
