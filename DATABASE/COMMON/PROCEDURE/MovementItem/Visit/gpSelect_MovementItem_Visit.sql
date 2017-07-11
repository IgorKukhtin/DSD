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
             , PhotoData                TBlob
             , GUID                     TVarChar
             , Comment                  TVarChar
             , GPSN                     TFloat
             , GPSE                     TFloat
             , AddressByGPS             TVarChar
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
        SELECT MovementItem.Id                 AS Id
             , Object_PhotoMobile.Id           AS PhotoMobileId
             , Object_PhotoMobile.ValueData    AS PhotoMobileName
             , ObjectBlob_Photo.ValueData      AS PhotoData
             , MIString_GUID.ValueData         AS GUID
             , MIString_Comment.ValueData      AS Comment
             , MIFloat_GPSN.ValueData          AS GPSN
             , MIFloat_GPSE.ValueData          AS GPSE
             , MIString_AddressByGPS.ValueData AS AddressByGPS
             , MIDate_InsertMobile.ValueData   AS InsertMobileDate
             , MovementItem.isErased
        FROM (SELECT false AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.isErased = tmpIsErased.isErased

            LEFT JOIN Object AS Object_PhotoMobile ON Object_PhotoMobile.Id = MovementItem.ObjectId
            LEFT JOIN ObjectBlob AS ObjectBlob_Photo
                                 ON ObjectBlob_Photo.ObjectId = Object_PhotoMobile.Id
                                AND ObjectBlob_Photo.DescId = zc_ObjectBlob_PhotoMobile_Data()

            LEFT JOIN MovementItemString AS MIString_GUID
                                         ON MIString_GUID.MovementItemId = MovementItem.Id
                                        AND MIString_GUID.DescId = zc_MIString_GUID()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
          
            LEFT JOIN MovementItemFloat AS MIFloat_GPSN
                                        ON MIFloat_GPSN.MovementItemId = MovementItem.Id
                                       AND MIFloat_GPSN.DescId = zc_MIFloat_GPSN()
          
            LEFT JOIN MovementItemFloat AS MIFloat_GPSE
                                        ON MIFloat_GPSE.MovementItemId = MovementItem.Id
                                       AND MIFloat_GPSE.DescId = zc_MIFloat_GPSE()

            LEFT JOIN MovementItemString AS MIString_AddressByGPS
                                         ON MIString_AddressByGPS.MovementItemId = MovementItem.Id
                                        AND MIString_AddressByGPS.DescId = zc_MIString_AddressByGPS()
          
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
 11.07.17                                                        * AddressByGPS
 20.04.17                                                        *
 26.03.17         *
*/

-- тест
-- 
--select * from gpSelect_MovementItem_Visit(inMovementId := 0 ,  inOperDate := ('30.12.1899')::TDateTime ,  inIsErased := 'False' ,  inSession := '5');