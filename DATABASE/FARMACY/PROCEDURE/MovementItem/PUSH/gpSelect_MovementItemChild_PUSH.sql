-- Function: gpSelect_MovementItemChild_PUSH()

DROP FUNCTION IF EXISTS gpSelect_MovementItemChild_PUSH (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemChild_PUSH(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , ParentName TVarChar
             
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_UnnamedEnterprises());
  vbUserId:= lpGetUserBySession (inSession);

  IF inShowAll = True 
  THEN

    RETURN QUERY

      SELECT 
             0                                                   AS Id
           , Object_Unit_View.Id                                 AS UnitId  
           , Object_Unit_View.Code                               AS UnitCode
           , Object_Unit_View.Name                               AS UnitName
           , Object_Parent.ValueData                             AS ParentName

           , True                                               AS isErased
       FROM Object_Unit_View

                LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = Object_Unit_View.ParentId
       
       
       WHERE Object_Unit_View.isErased = False
         AND COALESCE (Object_Unit_View.ParentId, 0) IN 
             (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0)
         AND Object_Unit_View.Id NOT IN (SELECT MovementItem.ObjectId
                                         FROM MovementItem
                                         WHERE MovementItem.MovementID = inMovementId
                                           AND MovementItem.DescId = zc_MI_Child())
      UNION ALL
      SELECT
             MovementItem.Id                                     AS Id
           , Object_Unit.Id                                      AS UnitId
           , Object_Unit.ObjectCode                              AS UnitCode
           , Object_Unit.ValueData                               AS UnitName
           , Object_Parent.ValueData                             AS ParentName

           , MovementItem.IsErased                               AS isErased
      FROM MovementItem
      

                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =  MovementItem.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                     ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                LEFT JOIN Object AS Object_Parent 
                                 ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

      WHERE MovementItem.MovementID = inMovementId
        AND MovementItem.DescId = zc_MI_Child()
      ORDER BY 5;
    
  ELSE

    RETURN QUERY

      SELECT
             MovementItem.Id                                     AS Id
           , Object_Unit.Id                                      AS UnitId
           , Object_Unit.ObjectCode                              AS UnitCode
           , Object_Unit.ValueData                               AS UnitName
           , Object_Parent.ValueData                             AS ParentName

           , MovementItem.IsErased                               AS isErased
      FROM MovementItem
      

                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =  MovementItem.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                     ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                LEFT JOIN Object AS Object_Parent 
                                 ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

      WHERE MovementItem.MovementID = inMovementId
        AND MovementItem.DescId = zc_MI_Child()
        AND (inIsErased = True or MovementItem.IsErased  = False)
      ORDER BY Object_Parent.ValueData;
      
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 21.03.19         *
*/
-- select * from gpSelect_MovementItemChild_PUSH(inMovementId := 10582538  , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
