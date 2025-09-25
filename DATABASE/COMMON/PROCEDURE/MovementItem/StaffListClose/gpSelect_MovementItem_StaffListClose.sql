-- Function: gpSelect_MovementItem_StaffListClose()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_StaffListClose (Integer, Boolean, Boolean, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_StaffListClose(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , UnitId Integer, UnitName TVarChar
             , isAmount Boolean
             , InsertDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId          Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_StaffListClose());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     IF inShowAll THEN
     RETURN QUERY
       WITH 
       -- 
       tmpMember AS (SELECT Object.Id          AS MemberId
                          , Object.ObjectCode  AS MemberCode
                          , Object.ValueData   AS MemberName
                     FROM Object
                     WHERE Object.DescId = zc_Object_Member()
                       AND Object.isErased = False
                    )

       -- Существующие MovementItem
     , tmpMI AS (SELECT MovementItem.Id
                      , MovementItem.ObjectId   AS MemberId
                      , MovementItem.Amount     AS Amount
                      , MovementItem.isErased
                 FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                      INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                 )

       SELECT
             0 :: Integer                   AS Id
           , tmpMember.MemberId
           , tmpMember.MemberCode
           , tmpMember.MemberName
           , 0                   ::Integer  AS UnitId
           , ''                  ::TVarChar AS UnitName
           , FALSE               ::Boolean  AS Amount
           , CURRENT_TIMESTAMP ::TDateTime  AS InsertDate
           , FALSE AS isErased
       FROM tmpMember
            LEFT JOIN tmpMI ON tmpMI.MemberId     = tmpMember.MemberId                     
       WHERE tmpMI.MemberId IS NULL
      UNION ALL
        SELECT
             tmpMI.Id                :: Integer  AS Id
           , Object_Member.Id          		 AS MemberId
           , Object_Member.ObjectCode  		 AS MemberCode
           , Object_Member.ValueData   		 AS MemberName
           , Object_Unit.Id                  AS UnitId
           , Object_Unit.ValueData           AS UnitName
           , CASE WHEN COALESCE (tmpMI.Amount,0)=0 THEN FALSE ELSE TRUE END ::Boolean AS isAmount
           , MIDate_Insert.ValueData         AS InsertDate
           , tmpMI.isErased                  AS isErased
       FROM tmpMI
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMI.MemberId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = tmpMI.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpMI.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
       ;
     ELSE

     -- Результат другой
     RETURN QUERY

       WITH 
       tmpMI AS (SELECT MovementItem.Id                               AS Id
                      , MovementItem.Amount                           AS Amount
                      , MovementItem.ObjectId                         AS MemberId
                      , MovementItem.isErased                         AS isErased
                 FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                      INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                 )


        SELECT
             tmpMI.Id                :: Integer AS Id
           , Object_Member.Id          		AS MemberId
           , Object_Member.ObjectCode  		AS MemberCode
           , Object_Member.ValueData   		AS MemberName
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , CASE WHEN COALESCE (tmpMI.Amount,0)=0 THEN FALSE ELSE TRUE END ::Boolean AS isAmount
           , MIDate_Insert.ValueData        AS InsertDate
           , tmpMI.isErased                 AS isErased
       FROM tmpMI
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMI.MemberId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpMI.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = tmpMI.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
           ;

     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.25         *
*/

-- тест
-- select * from gpSelect_MovementItem_StaffListClose(inMovementId := 18298048 , inShowAll:= false, inIsErased := 'False' ,  inSession := '5')
-- select * from gpSelect_MovementItem_StaffListClose(inMovementId := 18298048 , inShowAll:= true, inIsErased := 'False' ,  inSession := '5')