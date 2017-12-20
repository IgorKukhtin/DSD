--- Function: gpSelect_MovementItem_PromoCodeChild()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCodeChild (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCodeChild (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCodeChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , DescName TVarChar
             , JuridicalName TVarChar
             , RetailName    TVarChar
             , Comment TVarChar
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
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = inIsErased OR inIsErased = TRUE
                       )
         , tmpMI AS (SELECT MI_PromoCode.Id             AS Id
                          , MI_PromoCode.ObjectId       AS ObjectId
                          , MIString_Comment.ValueData  AS Comment
                          , MI_PromoCode.Amount         AS Amount
                          , MI_PromoCode.IsErased       AS IsErased
                     FROM MovementItem AS MI_PromoCode
                         LEFT JOIN MovementItemString AS MIString_Comment
                                                      ON MIString_Comment.MovementItemId = MI_PromoCode.Id
                                                     AND MIString_Comment.DescId = zc_MIString_Comment()
                    
                     WHERE MI_PromoCode.MovementId = inMovementId
                       AND MI_PromoCode.DescId = zc_MI_Child()
                       AND (MI_PromoCode.isErased = FALSE or inIsErased = TRUE)
                    )

           SELECT COALESCE (tmpMI.Id, 0)                AS Id
                , Object_Object.Id                      AS ObjectId
                , Object_Object.ObjectCode              AS ObjectCode
                , Object_Object.ValueData               AS ObjectName
                , ObjectDesc.ItemName                   AS DescName
                , Object_Juridical.ValueData            AS JuridicalName
                , Object_Retail.ValueData               AS RetailName
                , COALESCE (tmpMI.Comment, '') ::TVarChar AS Comment
                , CASE WHEN COALESCE (tmpMI.Amount, 0) = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , COALESCE (tmpMI.IsErased, FALSE)      AS IsErased
           FROM tmpUnit
               FULL JOIN tmpMI ON tmpMI.ObjectId = tmpUnit.UnitId
                         
               LEFT JOIN Object AS Object_Object ON Object_Object.Id = COALESCE (tmpMI.ObjectId, tmpUnit.UnitId)
               LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                    ON ObjectLink_Unit_Juridical.ObjectId = Object_Object.Id
                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Object.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
           ;
    ELSE
    -- Результат другой
    RETURN QUERY
           SELECT MI_PromoCode.Id
                , Object_Object.Id                   AS ObjectId
                , Object_Object.ObjectCode           AS ObjectCode
                , Object_Object.ValueData            AS ObjectName
                , ObjectDesc.ItemName                AS DescName
                , Object_Juridical.ValueData         AS JuridicalName
                , Object_Retail.ValueData            AS RetailName
                , MIString_Comment.ValueData ::TVarChar AS Comment
                , CASE WHEN MI_PromoCode.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_PromoCode.IsErased
           FROM MovementItem AS MI_PromoCode
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MI_PromoCode.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()
          
               LEFT JOIN Object AS Object_Object ON Object_Object.Id = MI_PromoCode.ObjectId
               LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

               LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                    ON ObjectLink_Unit_Juridical.ObjectId = Object_Object.Id
                                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
    
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = Object_Object.Id
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           WHERE MI_PromoCode.MovementId = inMovementId
             AND MI_PromoCode.DescId = zc_MI_Child()
             AND (MI_PromoCode.isErased = FALSE or inIsErased = TRUE);
    END IF;
 
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 13.12.17         *
*/

--select * from gpSelect_MovementItem_PromoCodeChild(inMovementId := 0 , inShowAll := 'TRUE' , inIsErased := 'False' ,  inSession := '3'::TVarChar);