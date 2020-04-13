-- Function: lpUpdate_MI_Sign_Promo_recalc()

DROP FUNCTION IF EXISTS lpUpdate_MI_Sign_Promo_recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Sign_Promo_recalc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPromoStateKindId    Integer   ,
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID AS
$BODY$
  DECLARE vbSignInternalId Integer;
  DECLARE vbStrMIIdSign    TVarChar;
  DECLARE vbStrIdSign      TVarChar;
  DECLARE vbStrIdSignNo    TVarChar;
  DECLARE vbIndex          Integer; -- № п/п в очереди - кто уже подписал
  DECLARE vbIndexNo        Integer; -- № п/п в очереди - кто остался подписать
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

      FROM lpSelect_MI_IncomeFuel_Sign (inMovementId:= inMovementId) AS tmp;



      -- проверка - если все подписано
      IF vbStrIdSign <> '' AND vbStrIdSignNo = ''
      THEN
          RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> уже <%>.'
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , lfGet_Object_ValueData_sh (zc_Enum_PromoStateKind_Complete())
                         ;
      END IF;

      -- проверка - если нельзя ставить <Согласован>
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete()) AND vbIndex = 0 AND vbIndexNo = 0
      THEN
          RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав устанавливать значение <%> в документе № <%> от <%>.'
                        , lfGet_Object_ValueData_sh (vbUserId)
                        , lfGet_Object_ValueData_sh (inPromoStateKindId)
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         ;
      END IF;


      -- если есть среди - кто остался подписать
      IF vbIndexNo > 0
      THEN
          -- В работе Исполнительный Директор ИЛИ Согласован
          IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete())
          THEN
              -- если еще никто не подписывал И №п/п = 1 И Согласован
              IF vbStrIdSign = '' AND vbIndexNo = 1 AND inPromoStateKindId = zc_Enum_PromoStateKind_Complete()
              THEN
                  -- надо поменять Модель - находим с isMain = FALSE, там по идее только один подписант = inUserId
                  PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal()
                                                           , inMovementId
                                                           , -- нашли модель
                                                             (SELECT gpSelect.Id
                                                              FROM gpSelect_Object_SignInternal (FALSE, inSession) AS gpSelect
                                                              WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                                                                AND gpSelect.isMain         = FALSE
                                                            ));
              ELSEIF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main()
              THEN
                  -- надо удалить Модель
                  PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, NULL);
              END IF;

              -- подписали
              PERFORM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId, TRUE, inUserId :: TVarChar);

          END IF;
      END IF;

      -- если есть среди - кто уже подписал
      IF vbIndex > 0
      THEN
          -- НЕ В работе Исполнительный Директор ИЛИ Согласован
          IF inPromoStateKindId NOT IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete())
          THEN
              -- убрали подпись
              PERFORM gpInsertUpdate_MI_IncomeFuel_Sign (inMovementId, FALSE, inUserId :: TVarChar);
          END IF;
      END IF;
      
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 03.08.17         *
 23.08.16         *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '12894') -- Степаненко О.М.
-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '12894') -- Степаненко О.М.

-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= TRUE, inSession:= '9463') -- Махота Д.П.
-- SELECT * FROM lpUpdate_MI_Sign_Promo_recalc (inMovementId:= 4136053, inIsSign:= FALSE, inSession:= '9463') -- Махота Д.П.
