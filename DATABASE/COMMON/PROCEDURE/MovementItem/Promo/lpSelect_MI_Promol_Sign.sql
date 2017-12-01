-- Function: lpSelect_MI_Promo_Sign (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS lpSelect_MI_Promo_Sign (Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_Promo_Sign(
    IN inMovementId  Integer       -- ключ Документа
)
RETURNS TABLE (Id             Integer
             , SignInternalId Integer
             , strSign        TVarChar -- Пользователи - среди подписанных
             , strSignNo      TVarChar -- Пользователи - среди НЕ подписанных
             , strIdSign      TVarChar -- Id Пользователей - среди подписанных
             , strIdSignNo    TVarChar -- Id Пользователей - среди НЕ подписанных
             , strMIIdSign    TVarChar -- Id MovementItem - среди подписанных
              )
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbObjectDescId Integer;
  DECLARE vbObjectId Integer;  
BEGIN
   
     -- Параметры из документа - для определения <Модель электронной подписи>
     SELECT Movement.DescId                                AS MovementDescId
          , COALESCE (Object_To.DescId,0)                  AS ObjectDescId
          , COALESCE (MovementLinkObject_From.ObjectId,0)  AS ObjectId
            INTO vbMovementDescId, vbObjectDescId, vbObjectId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
     WHERE Movement.Id = inMovementId;

     
     -- Результат
     RETURN QUERY 
     
     WITH -- данные из Модели для данного документа
          tmpObject AS (SELECT * FROM lpSelect_Object_SignInternalItem (vbMovementDescId, vbObjectDescId, 0))
          -- данные из уже сохраненных элементов подписи
        , tmpMI AS (SELECT MovementItem.Id                    AS MovementItemId
                         , MovementItem.ObjectId              AS SignInternalId
                         , MILO_Insert.ObjectId               AS UserId
                         , Object_User.ValueData              AS UserName
                    FROM MovementItem 
                       LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                        ON MILO_Insert.MovementItemId = MovementItem.Id
                                                       AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                       LEFT JOIN Object AS Object_User ON Object_User.Id = MILO_Insert.ObjectId
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Sign()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount <> 0
                    ORDER BY MovementItem.Amount
                   )
         -- кто уже подписал
       , tmpSign AS (SELECT STRING_AGG (tmpMI.UserName,                   ', ') AS strSign      -- с пробелом
                          , STRING_AGG (tmpMI.UserId         :: TVarChar, ',')  AS strIdSign    -- без пробела
                          , STRING_AGG (tmpMI.MovementItemId :: TVarChar, ',')  AS strMIIdSign  -- без пробела
                     FROM tmpMI
                    )
         -- кто остался подписать
       , tmpSignNo AS (SELECT STRING_AGG (tmp.UserName,           ', ') AS strSignNo    -- с пробелом
                            , STRING_AGG (tmp.UserId :: TVarChar, ',')  AS strIdSignNo  -- без пробела
                       FROM
                      (SELECT tmpObject.UserName, tmpObject.UserId
                       FROM tmpObject
                            LEFT JOIN tmpMI ON tmpMI.UserId         = tmpObject.UserId
                                           AND tmpMI.SignInternalId = tmpObject.SignInternalId
                       WHERE tmpMI.UserId IS NULL
                       ORDER BY tmpObject.Ord
                       ) AS tmp
                       )
     -- Результат
     SELECT inMovementId                      AS Id
          , (SELECT DISTINCT tmpObject.SignInternalId FROM tmpObject) AS SignInternalId
          , tmpSign.strSign       :: TVarChar AS strSign
          , tmpSignNo.strSignNo   :: TVarChar AS strSignNo
          , tmpSign.strIdSign     :: TVarChar AS strIdSign
          , tmpSignNo.strIdSignNo :: TVarChar AS strIdSignNo
          , tmpSign.strMIIdSign   :: TVarChar AS strMIIdSign
     FROM tmpSign
          LEFT JOIN tmpSignNo ON 1=1
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.16         * 

*/

-- тест
-- SELECT * FROM lpSelect_MI_Promo_Sign (inMovementId:= 4136053)
