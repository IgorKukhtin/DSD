-- Function: gpGet_MI_Message_PromoTradeStateKind (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpGet_MI_Message_PromoTradeStateKind (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Message_PromoTradeStateKind(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsComplete  Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementItemId Integer, PromoTradeStateKindId Integer, PromoTradeStateKindName TVarChar, Comment TVarChar)
AS
$BODY$
  DECLARE vbUserId                Integer;
  DECLARE vbMovementItemId        Integer;
  DECLARE vbPromoTradeStateKindId Integer;
  DECLARE vbIsUser_Signing_num    Integer;
  DECLARE vbUserId_insert         Integer;
/*DECLARE vbIsUserSigning1        Boolean;
  DECLARE vbIsUserSigning2        Boolean;
  DECLARE vbIsUserSigning3        Boolean;*/
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Promo());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF 1=1 AND NOT EXISTS (SELECT 1 FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect WHERE lpSelect.UserId = vbUserId)
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав для согласования.', lfGet_Object_ValueData_sh (vbUserId);
     END IF;



     -- Определяется - какой по очереди в подписантах
     vbIsUser_Signing_num:= (SELECT CASE vbUserId
                                         WHEN MLO_6.ObjectId THEN 7
                                         WHEN MLO_5.ObjectId THEN 6
                                         WHEN MLO_4.ObjectId THEN 5
                                         WHEN MLO_3.ObjectId THEN 4
                                         WHEN MLO_2.ObjectId THEN 3
                                         WHEN MLO_1.ObjectId THEN 2
                                         WHEN MLO.ObjectId   THEN 1
                                         ELSE -1
                                    END
                                             
                             FROM MovementLinkObject AS MLO
                                  -- Согласование
                                  LEFT JOIN Movement ON Movement.ParentId = inMovementId
                                                    AND Movement.DescId   = zc_Movement_PromoTradeSign()
                                  LEFT JOIN MovementLinkObject AS MLO_1
                                                               ON MLO_1.MovementId = Movement.Id
                                                              AND MLO_1.DescId     = zc_MovementLinkObject_Member_1()
                                  LEFT JOIN MovementLinkObject AS MLO_2
                                                               ON MLO_2.MovementId = Movement.Id
                                                              AND MLO_2.DescId     = zc_MovementLinkObject_Member_2()
                                  LEFT JOIN MovementLinkObject AS MLO_3
                                                               ON MLO_3.MovementId = Movement.Id
                                                              AND MLO_3.DescId     = zc_MovementLinkObject_Member_3()
                                  LEFT JOIN MovementLinkObject AS MLO_4
                                                               ON MLO_4.MovementId = Movement.Id
                                                              AND MLO_4.DescId     = zc_MovementLinkObject_Member_4()
                                  LEFT JOIN MovementLinkObject AS MLO_5
                                                               ON MLO_5.MovementId = Movement.Id
                                                              AND MLO_5.DescId     = zc_MovementLinkObject_Member_5()
                                  LEFT JOIN MovementLinkObject AS MLO_6
                                                               ON MLO_6.MovementId = Movement.Id
                                                              AND MLO_6.DescId     = zc_MovementLinkObject_Member_6()
                                                    
                             WHERE MLO.MovementId = inMovementId
                               AND MLO.DescId     = zc_MovementLinkObject_Insert()
                            );

     -- последний
     SELECT tmp.MovementItemId, tmp.PromoTradeStateKindId, tmp.UserId_insert
            INTO vbMovementItemId, vbPromoTradeStateKindId, vbUserId_insert
     FROM (WITH tmpMI AS (SELECT MI.Id                AS MovementItemId
                               , MI.ObjectId          AS PromoTradeStateKindId
                               , MILO_Insert.ObjectId AS UserId_insert
                          FROM MovementItem AS MI
                               JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
                               LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                                ON MILO_Insert.MovementItemId = MI.Id
                                                               AND MILO_Insert.DescId         = zc_MILinkObject_Insert()
                          WHERE MI.MovementId = inMovementId
                            AND MI.DescId     = zc_MI_Message()
                            AND MI.isErased   = FALSE
                         )
                -- для пользователя
              , tmpRes_One AS (SELECT tmpMI.MovementItemId, tmpMI.PromoTradeStateKindId, tmpMI.UserId_insert
                               FROM tmpMI
                               WHERE tmpMI.UserId_insert  = vbUserId
                                 AND tmpMI.MovementItemId > (SELECT MAX (tmpMI.MovementItemId) FROM tmpMI WHERE tmpMI.PromoTradeStateKindId = zc_Enum_PromoTradeStateKind_Start())
                                 AND tmpMI.PromoTradeStateKindId <> zc_Enum_PromoTradeStateKind_Complete_1()
                                 -- без поиска для пользовател + БЕЗ исправлений
                                 AND 1=0
                               ORDER BY tmpMI.MovementItemId DESC
                               LIMIT 1
                              )

           -- Результат
           SELECT tmpRes_One.MovementItemId, tmpRes_One.PromoTradeStateKindId, tmpRes_One.UserId_insert
           FROM tmpRes_One
          UNION ALL
           -- последнее найденное состояние
           SELECT 0 AS MovementItemId, tmpMI.PromoTradeStateKindId, 0 AS UserId_insert
           FROM tmpMI
                LEFT JOIN tmpRes_One ON tmpRes_One.MovementItemId > 0
           WHERE tmpRes_One.MovementItemId IS NULL
           ORDER BY 1 DESC
           LIMIT 1
          ) AS tmp;
          

    --RAISE EXCEPTION 'Ошибка. <%>   <%>' , vbMovementItemId, vbPromoTradeStateKindId;

     -- Проверка
     /*IF (vbIsUserSigning1 = TRUE AND COALESCE (vbPromoTradeStateKindId, 0) NOT IN (zc_Enum_PromoTradeStateKind_Start(), zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoTradeStateKind_Return()))
     OR (vbIsUserSigning2 = TRUE AND COALESCE (vbPromoTradeStateKindId, 0) NOT IN (zc_Enum_PromoStateKind_Head(), zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoTradeStateKind_Return()))
     OR (vbIsUserSigning3 = TRUE AND COALESCE (vbPromoTradeStateKindId, 0) NOT IN (zc_Enum_PromoStateKind_Main(), zc_Enum_PromoStateKind_Complete(), zc_Enum_PromoTradeStateKind_Return()))
     THEN
         RAISE EXCEPTION 'Ошибка.Состояние <%> не может быть переведено в состояние <%>'
                       , lfGet_Object_ValueData_sh (vbPromoTradeStateKindId)
                       , lfGet_Object_ValueData_sh (CASE WHEN inIsComplete = TRUE THEN zc_Enum_PromoStateKind_Complete() ELSE zc_Enum_PromoTradeStateKind_Return() END)
                        ;
     END IF;*/



     -- Проверка
     IF inIsComplete = TRUE AND vbPromoTradeStateKindId = zc_Enum_PromoTradeStateKind_Complete_7()
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже согласован.';
     END IF;

     -- Проверка
     IF inIsComplete = FALSE AND vbPromoTradeStateKindId NOT IN (zc_Enum_PromoTradeStateKind_Complete_1()
                                                               , zc_Enum_PromoTradeStateKind_Complete_2()
                                                               , zc_Enum_PromoTradeStateKind_Complete_3()
                                                               , zc_Enum_PromoTradeStateKind_Complete_4()
                                                               , zc_Enum_PromoTradeStateKind_Complete_5()
                                                               , zc_Enum_PromoTradeStateKind_Complete_6()
                                                               , zc_Enum_PromoTradeStateKind_Complete_7()
                                                                )
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не согласован.';
     END IF;


     -- Проверка
     IF inIsComplete = TRUE
        AND NOT EXISTS (SELECT 1
                        -- здесь все кто участвует
                        FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect
                        -- этот пользователь
                        WHERE lpSelect.UserId = vbUserId
                          -- если его № соответствует
                          AND lpSelect.Num = CASE COALESCE (vbPromoTradeStateKindId, 0)
                                                  -- получили следующий
                                                  WHEN zc_Enum_PromoTradeStateKind_Start()      THEN 1
                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_1() THEN 2
                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_2() THEN 3
                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_3() THEN 4
                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_4() THEN 5
                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_5() THEN 6
                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_6() THEN 7
                                             END
                       )
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав для согласования раньше чем % % % %.'
                       , CHR (13)
                       , (SELECT lpSelect.ItemName
                          -- здесь все кто участвует
                          FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect
                          -- какое следующий № 
                          WHERE lpSelect.Num = CASE COALESCE (vbPromoTradeStateKindId, 0)
                                                    -- получили следующий
                                                    WHEN zc_Enum_PromoTradeStateKind_Start()      THEN 1
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_1() THEN 2
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_2() THEN 3
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_3() THEN 4
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_4() THEN 5
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_5() THEN 6
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_6() THEN 7
                                               END
                         )
                       , CHR (13)
                       , (SELECT lpSelect.UserName
                          -- здесь все кто участвует
                          FROM lpSelect_Movement_PromoTradeSign (inMovementId) AS lpSelect
                          -- какой следующий № 
                          WHERE lpSelect.Num = CASE COALESCE (vbPromoTradeStateKindId, 0)
                                                    -- получили следующий
                                                    WHEN zc_Enum_PromoTradeStateKind_Start()      THEN 1
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_1() THEN 2
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_2() THEN 3
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_3() THEN 4
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_4() THEN 5
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_5() THEN 6
                                                    WHEN zc_Enum_PromoTradeStateKind_Complete_6() THEN 7
                                               END
                         )
                        ;
     END IF;


     -- Результат
     RETURN QUERY 
        SELECT CASE WHEN vbUserId_insert = vbUserId
                         THEN vbMovementItemId
                    WHEN vbPromoTradeStateKindId = CASE WHEN inIsComplete = TRUE THEN zc_Enum_PromoStateKind_Complete() ELSE zc_Enum_PromoTradeStateKind_Return() END
                         THEN 0 -- vbMovementItemId
                    ELSE 0
               END :: Integer AS MovementItemId
             , Object_PromoTradeStateKind.Id               AS PromoTradeStateKindId
             , Object_PromoTradeStateKind.ValueData        AS PromoTradeStateKindName
             , CASE WHEN vbUserId_insert = vbUserId
                         THEN (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbMovementItemId AND MIS.DescId = zc_MIString_Comment())
                    ELSE ''
               END :: TVarChar AS Comment
        FROM Object AS Object_PromoTradeStateKind
        WHERE Object_PromoTradeStateKind.Id = CASE WHEN vbUserId_insert = vbUserId
                                                        THEN vbPromoTradeStateKindId
                                                   WHEN inIsComplete = TRUE
                                                        THEN CASE COALESCE (vbPromoTradeStateKindId, 0)
                                                                  -- получили следующий
                                                                  WHEN 0                                        THEN zc_Enum_PromoTradeStateKind_Start()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Return()     THEN zc_Enum_PromoTradeStateKind_Start()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Start()      THEN zc_Enum_PromoTradeStateKind_Complete_1()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_1() THEN zc_Enum_PromoTradeStateKind_Complete_2()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_2() THEN zc_Enum_PromoTradeStateKind_Complete_3()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_3() THEN zc_Enum_PromoTradeStateKind_Complete_4()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_4() THEN zc_Enum_PromoTradeStateKind_Complete_5()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_5() THEN zc_Enum_PromoTradeStateKind_Complete_6()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_6() THEN zc_Enum_PromoTradeStateKind_Complete_7()
                                                                  WHEN zc_Enum_PromoTradeStateKind_Complete_7() THEN zc_Enum_PromoTradeStateKind_Complete_7()
                                                             END
                                                        ELSE zc_Enum_PromoTradeStateKind_Return()
                                              END
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.04.20         * 
*/

-- тест
-- SELECT * FROM gpGet_MI_Message_PromoTradeStateKind (inMovementId:= 16390310, inIsComplete:= TRUE,  inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGet_MI_Message_PromoTradeStateKind (inMovementId:= 16390310, inIsComplete:= FALSE, inSession:= zfCalc_UserAdmin())
