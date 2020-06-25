-- Function: lpCheck_Movement_Promo_Sign()

DROP FUNCTION IF EXISTS lpCheck_Movement_Promo_Sign (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_Promo_Sign(
    IN inMovementId          Integer   , -- ключ Документа
    IN inUserId              Integer     -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbSignInternalId       Integer;
  DECLARE vbStrMIIdSign          TVarChar;
  DECLARE vbStrIdSign            TVarChar;
  DECLARE vbStrIdSignNo          TVarChar;
  DECLARE vbIndex                Integer; -- № п/п в очереди - кто уже подписал
  DECLARE vbIndexNo              Integer; -- № п/п в очереди - кто остался подписать
  DECLARE vbPromoStateKindId_old Integer;
BEGIN

     -- данные - кто подписал/не подписал
     SELECT -- Модель для подписи
            tmp.SignInternalId
            -- MovementItemId
          , tmp.StrMIIdSign
            -- Id Пользователей - кто уже подписал
          , tmp.StrIdSign
            -- Id Пользователей - кто остался подписать
          , tmp.StrIdSignNo
            -- № п/п в очереди - кто уже подписал
          , zfCalc_WordNumber_Split (tmp.strIdSign,   ',', inUserId :: TVarChar)
            -- № п/п в очереди - кто остался подписать
          , zfCalc_WordNumber_Split (tmp.strIdSignNo, ',', inUserId :: TVarChar)

            INTO vbSignInternalId, vbStrMIIdSign, vbStrIdSign, vbStrIdSignNo, vbIndex, vbIndexNo

     FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp;
      
     -- если действие - проведение, должны быть все записи 
     -- если действие - изменения чего-либо - 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.05.16                                        *
*/

-- тест
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT lpCheck_Movement_Promo_Sign (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
-- SELECT lpCheck_Movement_Promo_Sign (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 15265833
