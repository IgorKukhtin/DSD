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
  DECLARE vbCount_member         Integer;
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
          
          , tmp.Count_member

            INTO vbSignInternalId, vbStrMIIdSign, vbStrIdSign, vbStrIdSignNo, vbIndex, vbIndexNo, vbCount_member

      FROM lpSelect_MI_Sign (inMovementId:= inMovementId) AS tmp;



      -- проверка - если подписано
      IF vbStrIdSign <> '' AND inPromoStateKindId = zc_Enum_PromoStateKind_Start()
      THEN
          -- если 3 раза подписали
          IF zfCalc_Word_Split (vbStrIdSign, ',', 3) <> ''
          THEN
              -- убрали подпись - под Пользователем № 3
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, FALSE, zfCalc_Word_Split (vbStrIdSign, ',', 3));
          END IF;

          -- если 2 раза подписали
          IF zfCalc_Word_Split (vbStrIdSign, ',', 2) <> ''
          THEN
              -- убрали подпись - под Пользователем № 2
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, FALSE, zfCalc_Word_Split (vbStrIdSign, ',', 2));
          END IF;

          -- если 1 раза подписали
          IF zfCalc_Word_Split (vbStrIdSign, ',', 1) <> ''
          THEN
              -- убрали подпись - под Пользователем № 1
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, FALSE, zfCalc_Word_Split (vbStrIdSign, ',', 1));
          END IF;
      END IF;


      -- проверка - если есть подпись
      IF vbStrIdSign <> '' AND inPromoStateKindId NOT IN (zc_Enum_PromoStateKind_Start(), zc_Enum_PromoStateKind_Head(), zc_Enum_PromoStateKind_Main()) AND vbIndexNo <> 1
    --IF vbStrIdSign <> '' AND inPromoStateKindId NOT IN (zc_Enum_PromoStateKind_Start(), zc_Enum_PromoStateKind_StartSign()) AND vbIndexNo <> 1
      THEN
          RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> уже <Подписан>.Измененния невозможны.<%><%>'
                        , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                        , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                        , vbIndex, vbIndexNo
                         ;
      END IF;


      -- подписали для: Согласован
      IF inPromoStateKindId IN (zc_Enum_PromoStateKind_Complete())
      THEN
          -- если inUserId еще не подписывал
          IF vbIndex = 0 OR 1=1
          THEN
              -- подписали
              PERFORM gpInsertUpdate_MI_Sign (inMovementId, TRUE, lfGet_User_Session (inUserId));
          END IF;
          --
          -- если надо 2 раза подписать + есть кому подписать после текущего
          IF vbCount_member = 2 AND zfCalc_Word_Split (vbStrIdSignNo, ',', 2) <> ''
          THEN
              -- добавили состояние
              PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId                  := 0
                                                              , inMovementId          := inMovementId
                                                              , inPromoStateKindId    := zc_Enum_PromoStateKind_Head()
                                                              , inIsQuickly           := TRUE
                                                              , inComment             := ''
                                                              , inSession             := lfGet_User_Session (inUserId)
                                                               );
          END IF;
          
          -- если надо 3 раза подписать + есть кому подписать после текущего + после текущего
          IF vbCount_member = 3 AND zfCalc_Word_Split (vbStrIdSignNo, ',', 2) <> '' AND zfCalc_Word_Split (vbStrIdSignNo, ',', 3) <> ''
          THEN
              -- добавили состояние
              PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId                  := 0
                                                              , inMovementId          := inMovementId
                                                              , inPromoStateKindId    := zc_Enum_PromoStateKind_Head()
                                                              , inIsQuickly           := TRUE
                                                              , inComment             := ''
                                                              , inSession             := lfGet_User_Session (inUserId)
                                                               );
          END IF;

          -- если надо 3 раза подписать + есть кому подписать после текущего + нет следующего
          IF vbCount_member = 3 AND zfCalc_Word_Split (vbStrIdSignNo, ',', 2) <> '' AND zfCalc_Word_Split (vbStrIdSignNo, ',', 3) = ''
          THEN
              -- добавили состояние
              PERFORM gpInsertUpdate_MI_Message_PromoStateKind (ioId                  := 0
                                                              , inMovementId          := inMovementId
                                                              , inPromoStateKindId    := zc_Enum_PromoStateKind_Main()
                                                              , inIsQuickly           := TRUE
                                                              , inComment             := ''
                                                              , inSession             := lfGet_User_Session (inUserId)
                                                               );
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
