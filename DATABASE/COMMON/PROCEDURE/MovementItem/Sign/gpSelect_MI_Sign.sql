-- Function: gpSelect_MI_Sign (Integer, Boolean, Boolean, TVarChar)

-- DROP FUNCTION IF EXISTS gpSelect_MI_IncomeFuel_Sign (Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_MI_PersonalService_Sign (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_Sign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Sign(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, SignInternalId Integer, SignInternalName TVarChar
             , Ord Integer
             , UserId Integer, UserCode Integer, UserName TVarChar
             , OperDate TDateTime
             , isSign Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId         Integer;

  DECLARE vbMovementDescId Integer;
  DECLARE vbObjectDescId   Integer;
  DECLARE vbObjectId       Integer;
  DECLARE vbSignInternalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Promo());
     vbUserId:= lpGetUserBySession (inSession);


     -- Параметры из документа - для определения <Модель электронной подписи>
     SELECT Movement.DescId                                AS MovementDescId
          , COALESCE (Object_To.DescId,0)                  AS ObjectDescId
          , COALESCE (MovementLinkObject_From.ObjectId,0)  AS ObjectId
          , COALESCE (MovementLinkObject.ObjectId, 0)      AS SignInternalId
            INTO vbMovementDescId, vbObjectDescId, vbObjectId, vbSignInternalId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                      AND Movement.DescId                    = zc_Movement_Income()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                      AND Movement.DescId                  = zc_Movement_Income()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
          LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                        AND MovementLinkObject.DescId     = zc_MovementLinkObject_SignInternal()
     WHERE Movement.Id = inMovementId;


     -- Результат
     RETURN QUERY
        WITH -- данные из Модели для данного документа
          tmpObject AS (SELECT *
                        FROM lpSelect_Object_SignInternalItem (vbSignInternalId, vbMovementDescId, vbObjectDescId, 0) AS tmp
                        )
             -- данные из уже сохраненных элементов подписи
           , tmpMI AS (SELECT MovementItem.Id
                              -- !!!замена
                          --, CASE WHEN vbSignInternalId > 0 THEN vbSignInternalId ELSE MovementItem.ObjectId END AS SignInternalId
                            , MovementItem.ObjectId AS SignInternalId
                              --
                            , MovementItem.Amount     AS Ord
                            , MILO_Insert.ObjectId    AS UserId
                            , MIDate_Insert.ValueData AS OperDate
                            , MovementItem.isErased
                       FROM MovementItem
                            LEFT JOIN MovementItemDate AS MIDate_Insert
                                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
                            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                             ON MILO_Insert.MovementItemId = MovementItem.Id
                                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Sign()
                         AND MovementItem.isErased   = FALSE
                      )
     -- Результат
     SELECT tmpMI.Id                      AS Id
          , Object_SignInternal.Id        AS SignInternalId
          , Object_SignInternal.ValueData AS SignInternalName

          , COALESCE (tmpMI.Ord, tmpObject.Ord) :: Integer AS Ord
          , Object_User.Id         AS UserId
          , Object_User.ObjectCode AS UserCode
          , Object_User.ValueData  AS UserName

          , tmpMI.OperDate

          , CASE WHEN tmpMI.Ord > 0 THEN TRUE ELSE FALSE END AS isSign

          , COALESCE (tmpMI.isErased, FALSE) AS isErased
     FROM tmpObject
          FULL JOIN tmpMI ON tmpMI.SignInternalId = tmpObject.SignInternalId
                         AND ((tmpMI.UserId = tmpObject.UserId AND vbMovementDescId <> zc_Movement_PromoTrade())
                           OR (tmpMI.Ord    = tmpObject.Ord    AND vbMovementDescId = zc_Movement_PromoTrade())
                             )
                         AND tmpMI.isErased       = FALSE
          LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = COALESCE (tmpObject.SignInternalId, tmpMI.SignInternalId)
          LEFT JOIN Object AS Object_User ON Object_User.Id                 = COALESCE (tmpObject.UserId, tmpMI.UserId)
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Sign (inMovementId:= 4135607, inIsErased:= TRUE,  inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MI_Sign (inMovementId:= 15644701, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
