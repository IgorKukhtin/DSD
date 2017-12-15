--- Function: gpSelect_MovementItem_PromoCodeSign()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCodeSign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCodeSign(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , GUID       TVarChar
             , BayerName  TVarChar
             , BayerPhone TVarChar
             , BayerEmail TVarChar
             , Comment    TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , IsChecked  boolean
             , isErased   Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

        RETURN QUERY
           SELECT MI_Sign.Id
                , MIString_GUID.ValueData       ::TVarChar AS GUID
                , MIString_Bayer.ValueData      ::TVarChar AS BayerName
                , MIString_BayerPhone.ValueData ::TVarChar AS BayerPhone
                , MIString_BayerEmail.ValueData ::TVarChar AS BayerEmail
                , MIString_Comment.ValueData    ::TVarChar AS Comment
                
                , Object_Insert.ValueData                  AS InsertName
                , Object_Update.ValueData                  AS UpdateName
                , MIDate_Insert.ValueData                  AS InsertDate
                , MIDate_Update.ValueData                  AS UpdateDate

                , CASE WHEN MI_Sign.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                , MI_Sign.IsErased

           FROM MovementItem AS MI_Sign
               LEFT JOIN MovementItemString AS MIString_GUID
                                            ON MIString_GUID.MovementItemId = MI_Sign.Id
                                           AND MIString_GUID.DescId = zc_MIString_GUID()
               LEFT JOIN MovementItemString AS MIString_Bayer
                                            ON MIString_Bayer.MovementItemId = MI_Sign.Id
                                           AND MIString_Bayer.DescId = zc_MIString_Bayer()
               LEFT JOIN MovementItemString AS MIString_BayerPhone
                                            ON MIString_BayerPhone.MovementItemId = MI_Sign.Id
                                           AND MIString_BayerPhone.DescId = zc_MIString_BayerPhone()
               LEFT JOIN MovementItemString AS MIString_BayerEmail
                                            ON MIString_BayerEmail.MovementItemId = MI_Sign.Id
                                           AND MIString_BayerEmail.DescId = zc_MIString_BayerEmail()
                                                      
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MI_Sign.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MI_Sign.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
               LEFT JOIN MovementItemDate AS MIDate_Update
                                          ON MIDate_Update.MovementItemId = MI_Sign.Id
                                         AND MIDate_Update.DescId = zc_MIDate_Update()
  
               LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                ON MILO_Insert.MovementItemId = MI_Sign.Id
                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
               LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                ON MILO_Update.MovementItemId = MI_Sign.Id
                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
               LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

           WHERE MI_Sign.MovementId = inMovementId
             AND MI_Sign.DescId = zc_MI_Sign()
             AND (MI_Sign.isErased = FALSE or inIsErased = TRUE);
  
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 13.12.17         *
*/

--select * from gpSelect_MovementItem_PromoCodeSign(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');