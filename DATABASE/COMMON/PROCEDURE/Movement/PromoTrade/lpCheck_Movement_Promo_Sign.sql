-- Function: lpCheck_Movement_Promo_Sign()

DROP FUNCTION IF EXISTS lpCheck_Movement_Promo_Sign (Integer, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_Promo_Sign(
    IN inMovementId          Integer   , -- ключ Документа
    IN inIsComplete          Boolean   , -- 
    IN inIsUpdate            Boolean   , -- 
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

     -- если без проверки
     -- IF zc_isPromo_Sign_check() = FALSE THEN RETURN; END IF;

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
      
     -- если действие - проведение, должны быть все подписи 
     IF inIsComplete = TRUE AND vbStrIdSignNo <> '' AND zc_isPromo_Sign_check() = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка.Нельзя установить статус <%>.Ожидается подписание документа пользователем <%>.'
                        , lfGet_Object_ValueData_sh (zc_Enum_Status_Complete())
                        , lfGet_Object_ValueData_sh (zfConvert_StringToFloat (zfCalc_Word_Split (vbStrIdSignNo, ',', 1)) :: Integer)
                         ;
     END IF;
     
     -- если действие - изменения чего-либо, не должно быть подписей вообще
     IF inIsUpdate = TRUE AND vbStrIdSign <> ''
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже подписан пользователем <%>.Корректировка не возможна.'
                        , lfGet_Object_ValueData_sh (zfConvert_StringToFloat (zfCalc_Word_Split (vbStrIdSign, ',', 1)) :: Integer)
                         ;
     END IF;

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
