-- Function: gpSelect_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Visit (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Visit(
    IN inMovementId  Integer      , -- ключ Документа
    IN inOperDate    TDateTime    , -- Дата документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                       Integer
             , PhotoMobileId            Integer
             , PhotoMobileName          TVarChar
             , Amount                   TFloat
             , GUID                     TVarChar
             , Comment                  TVarChar
             , InsertMobileDate         TDateTime
             , isErased                 Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_Visit());
      vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
        SELECT MovementItem.Id               AS Id
             , Object_PhotoMobile.Id         AS PhotoMobileId
             , Object_PhotoMobile.ValueData  AS PhotoMobileName
             , MovementItem.Amount
             , MIString_GUID.ValueData       AS GUID
             , MIString_Comment.ValueData    AS Comment
             , MIDate_InsertMobile.ValueData AS InsertMobileDate
             , MovementItem.isErased
        FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.isErased = tmpIsErased.isErased

            LEFT JOIN Object AS Object_PhotoMobile ON Object_PhotoMobile.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_GUID
                                         ON MIString_GUID.MovementItemId = MovementItem.Id
                                        AND MIString_GUID.DescId = zc_MIString_GUID()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
          
            LEFT JOIN MovementItemDate AS MIDate_InsertMobile
                                       ON MIDate_InsertMobile.MovementItemId = MovementItem.Id
                                      AND MIDate_InsertMobile.DescId = zc_MIDate_InsertMobile()
;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 26.03.17         *
*/

-- тест
-- 
--select * from gpSelect_MovementItem_Visit(inMovementId := 0 ,  inOperDate := ('30.12.1899')::TDateTime ,  inIsErased := 'False' ,  inSession := '5');