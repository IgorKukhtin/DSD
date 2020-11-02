--- Function: gpSelect_MovementItem_LayoutChild()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_LayoutChild (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LayoutChild(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
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
                                                 AND ObjectLink_Juridical_Retail.ChildObjectId = 4

                            INNER JOIN ObjectString AS ObjectString_Unit_Address
                                                    ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                                   AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                                                   AND COALESCE(ObjectString_Unit_Address.ValueData, '') <> ''
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = inIsErased OR inIsErased = TRUE
                       )
         , tmpMI AS (SELECT MI_Layout.Id             AS Id
                          , MI_Layout.ObjectId       AS ObjectId
                          , MI_Layout.Amount         AS Amount
                          , MI_Layout.IsErased       AS IsErased
                     FROM MovementItem AS MI_Layout

                     WHERE MI_Layout.MovementId = inMovementId
                       AND MI_Layout.DescId = zc_MI_Child()
                    )

           SELECT COALESCE (tmpMI.Id, 0)                AS Id
                , Object_Unit.Id                        AS UnitId
                , Object_Unit.ObjectCode                AS UnitCode
                , Object_Unit.ValueData                 AS UnitName
                , CASE WHEN COALESCE (tmpMI.Amount, 0) = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , COALESCE (tmpMI.IsErased, FALSE)      AS IsErased
           FROM tmpUnit
               FULL JOIN tmpMI ON tmpMI.ObjectId = tmpUnit.UnitId

               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpMI.ObjectId, tmpUnit.UnitId)

           ;
    ELSE
    -- Результат другой
    RETURN QUERY
           SELECT MI_Layout.Id
                , Object_Unit.Id                   AS UnitId
                , Object_Unit.ObjectCode           AS UnitCode
                , Object_Unit.ValueData            AS UnitName
                , CASE WHEN MI_Layout.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_Layout.IsErased
           FROM MovementItem AS MI_Layout

               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MI_Layout.ObjectId

           WHERE MI_Layout.MovementId = inMovementId
             AND MI_Layout.DescId = zc_MI_Child()
             AND (MI_Layout.isErased = FALSE or inIsErased = TRUE);
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.11.20                                                       *
*/

-- select * from gpSelect_MovementItem_LayoutChild(inMovementId := 20462215 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');