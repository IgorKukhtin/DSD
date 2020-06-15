-- Function: lpUpdate_MI_Sign_Promo_recalc()

DROP FUNCTION IF EXISTS lpUpdate_MI_Sign_Promo_recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Sign_Promo_recalc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPromoStateKindId    Integer   , -- Состояние Акции
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID AS
$BODY$
  DECLARE vbId                   Integer;
  DECLARE vbSignInternalId       Integer;
  DECLARE vbStrMIIdSign          TVarChar;
  DECLARE vbStrIdSign            TVarChar;
  DECLARE vbStrIdSignNo          TVarChar;
  DECLARE vbIndex                Integer; -- № п/п в очереди - кто уже подписал
  DECLARE vbIndexNo              Integer; -- № п/п в очереди - кто остался подписать
  DECLARE vbPromoStateKindId_old Integer;
BEGIN

     -- данные из шапки
     vbPromoStateKindId_old:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PromoStateKind());

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



      -- проверка - если все подписано
      IF vbStrIdSign <> '' AND vbIndex = 0 AND vbIndexNo = 0 AND inPromoStateKindId <> zc_Enum_PromoStateKind_Main()
      THEN
          RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> уже <Подписан>.Измененния невозможны.<%><%>'
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , vbIndex, vbIndexNo
                         ;
      END IF;
/*
      -- проверка - если нельзя ставить <Согласован>
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete()) AND vbIndex = 0 AND vbIndexNo = 0
      THEN
          RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав устанавливать значение <%> в документе № <%> от <%>.'
                        , lfGet_Object_ValueData_sh (inUserId)
                        , lfGet_Object_ValueData_sh (inPromoStateKindId)
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                         ;
      END IF;*/


      -- Меняется модель (ЕСЛИ НАДО) + подписали для: Согласован
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Complete())
      THEN
          -- если еще не подписывали И №п/п=1 кто должен подписать ИЛИ он уже подписал
          IF (vbStrIdSign ='' AND vbIndexNo = 1) OR vbIndex = 1
          THEN
              -- нашли модель - "другую" - с isMain = FALSE, там по идее только один подписант = inUserId
              vbSignInternalId:= (SELECT gpSelect.Id
                                  FROM gpSelect_Object_SignInternal (FALSE, inUserId :: TVarChar) AS gpSelect
                                  WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                                    AND gpSelect.isMain         = FALSE
                                 );
              -- проверка
              IF COALESCE (vbSignInternalId, 0) = 0
              THEN
                   RAISE EXCEPTION 'Ошибка.Не найдена информация для формирования только ОДНОЙ электронной подписи в документе № <%> от <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
              END IF;

              -- надо поменять Модель
              PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, vbSignInternalId);

              -- если подписан - меняем Модель у самой подписи
              IF vbIndex = 1
              THEN
                  -- так определили Id строки
                  vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) :: Integer END;
                  -- проверка
                  IF COALESCE (vbId, 0) = 0
                  THEN
                       RAISE EXCEPTION 'Ошибка.Не найдена строка ОДНОЙ электронной подписи в документе № <%> от <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
                  END IF;
                  -- поменяли
                  PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, vbSignInternalId, MovementItem.MovementId, MovementItem.Amount, NULL)
                  FROM MovementItem
                  WHERE MovementItem.Id = vbId;

              END IF;
          END IF;
              
          -- если inUserId еще не подписывал
          IF vbIndex <> 1
          THEN
              -- подписал
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, TRUE, inUserId :: TVarChar);
          END IF;


      -- если 1)В работе Исполнительный Директор
      ELSEIF inPromoStateKindId = zc_Enum_PromoStateKind_Main()
      THEN
          -- надо удалить Модель
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), inMovementId, NULL);

          -- если подписан - меняем Модель у существующей подписи
          IF vbIndex = 1 OR (vbStrIdSign <> '' AND vbStrIdSignNo = '')
          THEN
              -- нашли модель
              vbSignInternalId:= (SELECT gpSelect.Id
                                   FROM gpSelect_Object_SignInternal (FALSE, inUserId :: TVarChar) AS gpSelect
                                   WHERE gpSelect.MovementDescId = zc_Movement_Promo()
                                     AND gpSelect.isMain         = TRUE
                                 );
              -- проверка
              IF COALESCE (vbSignInternalId, 0) = 0
              THEN
                   RAISE EXCEPTION 'Ошибка.Не найдена информация для формирования больше ОДНОЙ электронной подписи в документе № <%> от <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
              END IF;

              -- так определили Id существующей подписи
              IF vbIndex = 0 AND vbIndexNo = 0
              THEN
                  -- берем первую
                  vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', 1) :: Integer END;
              ELSE
                  -- берем для этого inUserId
                  vbId:= CASE WHEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) <> '' THEN zfCalc_Word_Split (vbStrMIIdSign, ',', vbIndex) :: Integer END;
              END IF;
              -- проверка
              IF COALESCE (vbId, 0) = 0
              THEN
                   RAISE EXCEPTION 'Ошибка.Не найдена строка ОДНОЙ существующей подписи в документе № <%> от <%>.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
              END IF;
              -- поменяли
              PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, vbSignInternalId, MovementItem.MovementId, MovementItem.Amount, NULL)
              FROM MovementItem
              WHERE MovementItem.Id = vbId;

          END IF;

      END IF;


      -- если надо убрать подпись
      IF inPromoStateKindId NOT IN (zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoStateKind_Main()) AND vbPromoStateKindId_old = zc_Enum_PromoStateKind_Complete()
      THEN
          -- убрали подпись
          PERFORM gpInsertUpdate_MI_Sign (inMovementId, FALSE, inUserId :: TVarChar);
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
