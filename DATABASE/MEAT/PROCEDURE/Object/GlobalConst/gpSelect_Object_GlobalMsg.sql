-- Function: gpSelect_Object_GlobalMsg()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalMsg (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalMsg(
    IN inIP          TVarChar,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, NPP Integer, MsgAddr TVarChar, MsgText TVarChar, ColorText_Addr Integer, Color_Addr Integer, ColorText_Text Integer, Color_Text Integer
, OperDate TDateTime)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsMsg_PromoStateKind Boolean;
   DECLARE vbIsMsg_Contract       Boolean;
   DECLARE vbIsUserSigning1       Boolean;
   DECLARE vbIsUserSigning2       Boolean;
   DECLARE vbIsUserSigning3       Boolean;
   DECLARE vbIsMsgColor           Boolean;
   DECLARE vbIsUserPromoTrade     Boolean;

   DECLARE vbMovementId_1_Member  Integer;
   DECLARE vbCount_1_Member       Integer;
   DECLARE vbMovementId_2_Member  Integer;
   DECLARE vbCount_2_Member       Integer;

   DECLARE vbMovementId_1_Head    Integer;
   DECLARE vbCount_1_Head         Integer;
   DECLARE vbMovementId_2_Head    Integer;
   DECLARE vbCount_2_Head         Integer;

   DECLARE vbMovementId_1_Main    Integer;
   DECLARE vbCount_1_Main         Integer;
   DECLARE vbMovementId_2_Main    Integer;
   DECLARE vbCount_2_Main         Integer;

   DECLARE vbCount_Contract       Integer;
   DECLARE vbOperDate_Contract    TDateTime;
   DECLARE vbOperDate_Contract_start TDateTime;

   DECLARE vbMovementId_PromoTrade Integer;
   DECLARE vbCount_PromoTrade      Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- zc_Enum_Role_Admin + Отдел Маркетинг + Маркетинг - Руководитель
     vbIsMsg_PromoStateKind:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View WHERE UserRole_View.RoleId IN (zc_Enum_Role_Admin(), 876016, 5473256) AND UserRole_View.UserId = vbUserId);
     -- Договора-ввод справочников
     vbIsMsg_Contract:= vbUserId = zfCalc_UserAdmin() :: Integer OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View WHERE UserRole_View.RoleId IN (78432) AND UserRole_View.UserId = vbUserId);
     
     -- zc_Enum_Role_Admin + Отдел Маркетинг + Маркетинг - Руководитель
     vbIsUserPromoTrade:= vbUserId = zfCalc_UserAdmin() :: Integer OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View
                                                                              WHERE UserRole_View.RoleId IN (876016   -- Отдел Маркетинг
                                                                                                           , 445981   -- Экономист (расширенные права)
                                                                                                           , 11303484 -- Трейд-маркетинг (создание/проведение док-та)
                                                                                                           , 11317677 -- Трейд-маркетинг (согласование)
                                                                                                            )
                                                                                AND UserRole_View.UserId = vbUserId
                                                                             );

     --
     IF vbIsMsg_Contract = TRUE
     THEN
         -- Юридический отдел
         vbIsMsg_Contract:= vbUserId = zfCalc_UserAdmin() :: Integer
                         OR EXISTS (SELECT 1
                                    FROM ObjectLink AS ObjectLink_User_Member
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                              ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                             AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                               ON ObjectLink_Personal_Unit.ObjectId      = ObjectLink_Personal_Member.ObjectId
                                                              AND ObjectLink_Personal_Unit.DescId        = zc_ObjectLink_Personal_Unit()
                                                              AND ObjectLink_Personal_Unit.ChildObjectId = 8387
                                    WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                   );
         -- если надо найти договора
         IF vbIsMsg_Contract = TRUE
         THEN
             -- дата
             vbOperDate_Contract:= DATE_TRUNC ('MONTH', CURRENT_DATE + INTERVAL '25 DAY') + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
             vbOperDate_Contract_start:= DATE_TRUNC ('MONTH', vbOperDate_Contract) - INTERVAL '1 MONTH';
             -- кол-во
             vbCount_Contract:= COALESCE (
                                (SELECT COUNT (*)
                                 FROM ObjectDate AS ObjectDate_End
                                      INNER JOIN Object AS Object_Contract ON Object_Contract.Id        = ObjectDate_End.ObjectId
                                                                          AND Object_Contract.ValueData <> '-'
                                                                          AND Object_Contract.isErased  = FALSE
                                      INNER JOIN ObjectLink AS ObjectLink_ContractStateKind
                                                            ON ObjectLink_ContractStateKind.ObjectId      = Object_Contract.Id
                                                           AND ObjectLink_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                                           AND ObjectLink_ContractStateKind.ChildObjectId <> zc_Enum_ContractStateKind_Close()
                                      -- Типы пролонгаций договоров
                                      LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTermKind
                                                           ON ObjectLink_Contract_ContractTermKind.ObjectId = Object_Contract.Id
                                                          AND ObjectLink_Contract_ContractTermKind.DescId   = zc_ObjectLink_Contract_ContractTermKind()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Term
                                                            ON ObjectFloat_Term.ObjectId  = Object_Contract.Id
                                                           AND ObjectFloat_Term.DescId    = zc_ObjectFloat_Contract_Term()
                                                           AND ObjectFloat_Term.ValueData > 0
                                 WHERE ObjectDate_End.ValueData BETWEEN vbOperDate_Contract_start AND vbOperDate_Contract
                                   AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                                   AND (ObjectLink_Contract_ContractTermKind.ChildObjectId IS NULL
                                     OR ObjectFloat_Term.ObjectId IS NULL
                                       )
                                ), 0)

                              + COALESCE (
                                (SELECT COUNT (*)
                                 FROM -- Типы пролонгаций договоров
                                      ObjectLink AS ObjectLink_Contract_ContractTermKind
                                      INNER JOIN Object AS Object_Contract ON Object_Contract.Id        = ObjectLink_Contract_ContractTermKind.ObjectId
                                                                          AND Object_Contract.ValueData <> '-'
                                                                          AND Object_Contract.isErased  = FALSE
                                      INNER JOIN ObjectFloat AS ObjectFloat_Term
                                                             ON ObjectFloat_Term.ObjectId  = Object_Contract.Id
                                                            AND ObjectFloat_Term.DescId    = zc_ObjectFloat_Contract_Term()
                                                            AND ObjectFloat_Term.ValueData > 0
                                      INNER JOIN ObjectLink AS ObjectLink_ContractStateKind
                                                            ON ObjectLink_ContractStateKind.ObjectId      = Object_Contract.Id
                                                           AND ObjectLink_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                                           AND ObjectLink_ContractStateKind.ChildObjectId <> zc_Enum_ContractStateKind_Close()
                                      INNER JOIN ObjectDate AS ObjectDate_End
                                                            ON ObjectDate_End.ObjectId = Object_Contract.Id
                                                           AND ObjectDate_End.DescId   = zc_ObjectDate_Contract_End()
                                                           AND ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL BETWEEN vbOperDate_Contract_start AND vbOperDate_Contract
                                 WHERE ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Month()
                                   AND ObjectLink_Contract_ContractTermKind.DescId        = zc_ObjectLink_Contract_ContractTermKind()
                                ), 0)

                              + COALESCE (
                                (SELECT COUNT (*)
                                 FROM -- Типы пролонгаций договоров
                                      ObjectLink AS ObjectLink_Contract_ContractTermKind
                                      INNER JOIN Object AS Object_Contract ON Object_Contract.Id        = ObjectLink_Contract_ContractTermKind.ObjectId
                                                                          AND Object_Contract.ValueData <> '-'
                                                                          AND Object_Contract.isErased  = FALSE
                                      INNER JOIN ObjectFloat AS ObjectFloat_Term
                                                             ON ObjectFloat_Term.ObjectId  = Object_Contract.Id
                                                            AND ObjectFloat_Term.DescId    = zc_ObjectFloat_Contract_Term()
                                                            AND ObjectFloat_Term.ValueData > 0
                                      INNER JOIN ObjectLink AS ObjectLink_ContractStateKind
                                                            ON ObjectLink_ContractStateKind.ObjectId      = Object_Contract.Id
                                                           AND ObjectLink_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                                           AND ObjectLink_ContractStateKind.ChildObjectId <> zc_Enum_ContractStateKind_Close()
                                      INNER JOIN ObjectDate AS ObjectDate_End
                                                            ON ObjectDate_End.ObjectId = Object_Contract.Id
                                                           AND ObjectDate_End.DescId   = zc_ObjectDate_Contract_End()
                                                           AND ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL BETWEEN vbOperDate_Contract_start - INTERVAL '1 MONTH' AND vbOperDate_Contract
                                 WHERE ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Long()
                                   AND ObjectLink_Contract_ContractTermKind.DescId        = zc_ObjectLink_Contract_ContractTermKind()
                                ), 0)
                                ;
         END IF;
     END IF;

     -- Signing
     vbIsUserSigning1:= vbUserId IN (112324);  -- Колосинская С.А.
     vbIsUserSigning2:= vbUserId IN (280164, 5, 133035);  -- Старецкая М.В. + Фурсов А.А.
     vbIsUserSigning3:= vbUserId IN (9463); -- Махота Д.П.
     -- vbIsUserSigning1:= vbUserId IN (133035, 5); -- Фурсов А.А.
     -- vbIsUserSigning2:= vbUserId IN (280164); -- Старецкая М.В.

     -- Отдел Маркетинг
     vbIsMsgColor:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View WHERE UserRole_View.RoleId IN (876016) AND UserRole_View.UserId = vbUserId);


     -- Трейд-маркетинг
     IF 1=1 AND (vbIsUserPromoTrade = TRUE)
     THEN
          SELECT -- 1. MovementId
                 MIN (Movement_PromoTrade.Id) AS MovementId_PromoTrade
                 -- 2. Count
               , SUM (1) AS Count_PromoTrade

                 INTO vbMovementId_PromoTrade
                    , vbCount_PromoTrade

          FROM Movement AS Movement_PromoTrade
               -- В работе Директор по маркетингу + В работе Исполнительный Директор
               INNER JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                             ON MovementLinkObject_PromoStateKind.MovementId = Movement_PromoTrade.Id
                                            AND MovementLinkObject_PromoStateKind.DescId     = zc_MovementLinkObject_PromoTradeStateKind()
                                            AND MovementLinkObject_PromoStateKind.ObjectId   IN (zc_Enum_PromoTradeStateKind_Start()
                                                                                               , zc_Enum_PromoTradeStateKind_Complete_1()
                                                                                               , zc_Enum_PromoTradeStateKind_Complete_2()
                                                                                               , zc_Enum_PromoTradeStateKind_Complete_3()
                                                                                               , zc_Enum_PromoTradeStateKind_Complete_4()
                                                                                               , zc_Enum_PromoTradeStateKind_Complete_5()
                                                                                               , zc_Enum_PromoTradeStateKind_Complete_6()
                                                                                                )
               -- 1.Автор документа - будет подписывать
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                            ON MovementLinkObject_Insert.MovementId = Movement_PromoTrade.Id
                                           AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
               -- кто еще будет подписывать
               INNER JOIN Movement AS Movement_PromoTradeSign
                                   ON Movement_PromoTradeSign.ParentId = Movement_PromoTrade.Id
                                  AND Movement_PromoTradeSign.DescId   = zc_Movement_PromoTradeSign()
               -- 2.Отвественный - коммерческого отдела
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_1
                                            ON MovementLinkObject_Member_1.MovementId = Movement_PromoTradeSign.Id
                                           AND MovementLinkObject_Member_1.DescId     = zc_MovementLinkObject_Member_1()
               -- 3.Отвественный - Экономист
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_2
                                            ON MovementLinkObject_Member_2.MovementId = Movement_PromoTradeSign.Id
                                           AND MovementLinkObject_Member_2.DescId     = zc_MovementLinkObject_Member_2()
               -- 4.Отвественный - Региональнай менеджер
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_3
                                            ON MovementLinkObject_Member_3.MovementId = Movement_PromoTradeSign.Id
                                           AND MovementLinkObject_Member_3.DescId     = zc_MovementLinkObject_Member_3()
               -- 5.Руководитель отдела продаж
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_4
                                            ON MovementLinkObject_Member_4.MovementId = Movement_PromoTradeSign.Id
                                           AND MovementLinkObject_Member_4.DescId     = zc_MovementLinkObject_Member_4()
               -- 6.Отвественный - отдел маркетинга
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_5
                                            ON MovementLinkObject_Member_5.MovementId = Movement_PromoTradeSign.Id
                                           AND MovementLinkObject_Member_5.DescId     = zc_MovementLinkObject_Member_5()
               -- 7.Коммерческий директор
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Member_6
                                            ON MovementLinkObject_Member_6.MovementId = Movement_PromoTradeSign.Id
                                           AND MovementLinkObject_Member_6.DescId     = zc_MovementLinkObject_Member_6()

               -- нашли чью подпись ждем
               LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                    ON ObjectLink_User_Member.ChildObjectId = CASE WHEN -- если уже подписал - Автор документа
                                                                                        MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoTradeStateKind_Complete_1()
                                                                                        THEN MovementLinkObject_Member_1.ObjectId

                                                                                   WHEN -- если уже подписал - Отвественный - коммерческого отдела
                                                                                        MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoTradeStateKind_Complete_2()
                                                                                        THEN MovementLinkObject_Member_2.ObjectId

                                                                                   WHEN -- если уже подписал - 
                                                                                        MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoTradeStateKind_Complete_3()
                                                                                        THEN MovementLinkObject_Member_3.ObjectId

                                                                                   WHEN -- если уже подписал - 
                                                                                        MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoTradeStateKind_Complete_4()
                                                                                        THEN MovementLinkObject_Member_4.ObjectId

                                                                                   WHEN -- если уже подписал - 
                                                                                        MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoTradeStateKind_Complete_5()
                                                                                        THEN MovementLinkObject_Member_5.ObjectId

                                                                                   WHEN -- если уже подписал - 
                                                                                        MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoTradeStateKind_Complete_6()
                                                                                        THEN MovementLinkObject_Member_6.ObjectId
                                                                                   END
                                   AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()

               INNER JOIN Object AS Object_User ON Object_User.Id = CASE WHEN -- если - В работе Автор документа
                                                                              MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoTradeStateKind_Start()
                                                                              -- подписывать - Автор документа
                                                                              THEN MovementLinkObject_Insert.ObjectId
                                                                         ELSE ObjectLink_User_Member.ObjectId
                                                                    END 

          WHERE Movement_PromoTrade.DescId   = zc_Movement_PromoTrade()
            AND Movement_PromoTrade.StatusId = zc_Enum_Status_Complete()
            AND Movement_PromoTrade.OperDate BETWEEN CURRENT_DATE - INTERVAL '2 MONTH' AND CURRENT_DATE + INTERVAL '25 MONTH'
            -- нашли чью подпись ждем
            AND Object_User.Id = CASE WHEN vbUserId = 5 THEN 6604558 ELSE vbUserId END -- Голота К.О.
         ;

     END IF;
     

     -- Отдел Маркетинг
     IF 1=1 AND (vbIsMsg_PromoStateKind = TRUE OR vbIsMsg_Contract = TRUE)
     THEN
          SELECT

                 -- 0.1.1. MovementId - Срочно - Отдел Маркетинга
                 MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_StartSign()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_1_Member
                 -- 0.1.2. Count - Срочно - Отдел Маркетинга
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_StartSign()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN 1
                                ELSE 0
                      END) AS Count_1_Member
                 -- 0.2.1. MovementId - НЕ Срочно - Отдел Маркетинга
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_StartSign()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_2_Member
                 -- 0.2.2. Count - НЕ Срочно - Отдел Маркетинга
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_StartSign()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN 1
                                ELSE 0
                      END) AS Count_2_Member

                 -- 1.1.1. MovementId - Срочно - Директор по маркетингу
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_1_Head
                 -- 1.1.2. Count - Срочно - Директор по маркетингу
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN 1
                                ELSE 0
                      END) AS Count_1_Head
                 -- 1.2.1. MovementId - НЕ Срочно - Директор по маркетингу
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_2_Head
                 -- 1.2.2. Count - НЕ Срочно - Директор по маркетингу
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN 1
                                ELSE 0
                      END) AS Count_2_Head


                 -- 2.1.1. MovementId - Срочно - Исполнительный Директор
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_1_Main
                 -- 2.1.2. Count - Срочно - Исполнительный Директор
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN 1
                                ELSE 0
                      END) AS Count_1_Main

                 -- 2.2.1. MovementId - НЕ Срочно - Исполнительный Директор
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_2_Main
                 -- 2.2.2. Count - НЕ Срочно - Исполнительный Директор
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN 1
                                ELSE 0
                      END) AS Count_2_Main


                 INTO vbMovementId_1_Member
                    , vbCount_1_Member
                    , vbMovementId_2_Member
                    , vbCount_2_Member

                    , vbMovementId_1_Head
                    , vbCount_1_Head
                    , vbMovementId_2_Head
                    , vbCount_2_Head

                    , vbMovementId_1_Main
                    , vbCount_1_Main
                    , vbMovementId_2_Main
                    , vbCount_2_Main

          FROM Movement AS Movement_Promo
               -- В работе Директор по маркетингу + В работе Исполнительный Директор
               INNER JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                             ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                            AND MovementLinkObject_PromoStateKind.DescId     = zc_MovementLinkObject_PromoStateKind()
                                            AND MovementLinkObject_PromoStateKind.ObjectId   IN (zc_Enum_PromoStateKind_StartSign(), zc_Enum_PromoStateKind_Head(), zc_Enum_PromoStateKind_Main())
               -- Срочно
               LEFT JOIN MovementFloat AS MovementFloat_PromoStateKind
                                       ON MovementFloat_PromoStateKind.MovementId = Movement_Promo.Id
                                      AND MovementFloat_PromoStateKind.DescId     = zc_MovementFloat_PromoStateKind()
               LEFT JOIN MovementDate AS MovementDate_StartSale
                                      ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                     AND MovementDate_StartSale.DescId     = zc_MovementDate_StartSale()
          WHERE Movement_Promo.DescId   = zc_Movement_Promo()
          --AND Movement_Promo.StatusId = zc_Enum_Status_UnComplete()
            AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
            AND Movement_Promo.OperDate BETWEEN CURRENT_DATE - INTERVAL '5 MONTH' AND CURRENT_DATE + INTERVAL '25 MONTH'
            AND MovementDate_StartSale.ValueData >= CURRENT_DATE - INTERVAL '7 DAY'
            AND (Movement_Promo.Id <> 16390310 OR vbUserId = 5)
         ;
     END IF;


     -- Результат
     RETURN QUERY

       -- 0.1.
       SELECT CASE WHEN vbCount_1_Member > 0
                        THEN vbMovementId_1_Member
                   WHEN vbCount_2_Member > 0
                        THEN vbMovementId_2_Member
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning1 = TRUE THEN 1 WHEN vbIsUserSigning2 = TRUE THEN 3 ELSE 3 END :: Integer AS NPP
            , 'Отдел Маркетинга : ' :: TVarChar AS MsgAddr

            , (CASE WHEN vbCount_1_Member > 0
                        THEN 'Приоритетных документов для подписания '
                          || ' : '    || vbCount_1_Member :: TVarChar || ' шт.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_1_Member AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_StartSign() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    № ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_1_Member)
                          || ' от '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_1_Member))
                          || ' период продаж с ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Member AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' по '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Member AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE 'Нет приоритетных документов'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_1_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   WHEN vbCount_2_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_1_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Yelow()
                   WHEN vbCount_2_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_1_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_1_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Yelow()
                   ELSE -1
              END AS Color_Text

            , CURRENT_DATE :: TDateTime

       WHERE vbCount_1_Member > 0

      UNION ALL
       -- 0.2.
       SELECT CASE WHEN vbCount_2_Member > 0
                        THEN vbMovementId_2_Member
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning1 = TRUE THEN 1 WHEN vbIsUserSigning2 = TRUE THEN 3 ELSE 3 END :: Integer AS NPP
            , 'Отдел Маркетинга : ' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_2_Member > 0
                        THEN 'подготовлены документы для подписания '
                          || ' : '    || vbCount_2_Member :: TVarChar || ' шт.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_2_Member AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_StartSign() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    № ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_2_Member)
                          || ' от '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_2_Member))
                          || ' период продаж с ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Member AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' по '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Member AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE 'Нет подготовленных документов'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_2_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_2_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_2_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_2_Member > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Text
            , CURRENT_DATE :: TDateTime

       WHERE COALESCE (vbCount_1_Member, 0) = 0

      UNION ALL
       -- 1.1.
       SELECT CASE WHEN vbCount_1_Head > 0
                        THEN vbMovementId_1_Head
                   WHEN vbCount_2_Head > 0
                        THEN vbMovementId_2_Head
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning1 = TRUE THEN 1 WHEN vbIsUserSigning2 = TRUE THEN 2 ELSE 2 END :: Integer AS NPP
            , 'Директору по Маркетингу : ' :: TVarChar AS MsgAddr

            , (CASE WHEN vbCount_1_Head > 0
                        THEN 'Приоритетных документов для подписания '
                          || ' : '    || vbCount_1_Head :: TVarChar || ' шт.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_1_Head AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Head() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    № ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_1_Head)
                          || ' от '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_1_Head))
                          || ' период продаж с ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Head AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' по '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Head AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE 'Нет приоритетных документов'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Yelow()
                   WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Yelow()
                   ELSE -1
              END AS Color_Text
            , CURRENT_DATE :: TDateTime

       WHERE vbCount_1_Head > 0

      UNION ALL
       -- 1.2.
       SELECT CASE WHEN vbCount_2_Head > 0
                        THEN vbMovementId_2_Head
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning1 = TRUE THEN 1 WHEN vbIsUserSigning2 = TRUE THEN 2 ELSE 2 END :: Integer AS NPP
            , 'Директору по Маркетингу : ' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_2_Head > 0
                        THEN 'подготовлены документы для подписания '
                          || ' : '    || vbCount_2_Head :: TVarChar || ' шт.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_2_Head AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Head() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    № ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_2_Head)
                          || ' от '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_2_Head))
                          || ' период продаж с ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Head AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' по '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Head AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE 'Нет подготовленных документов'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Text
            , CURRENT_DATE :: TDateTime

       WHERE COALESCE (vbCount_1_Head, 0) = 0

      UNION ALL
       -- 2.1.
       SELECT CASE WHEN vbCount_1_Main > 0
                        THEN vbMovementId_1_Main
                   WHEN vbCount_2_Main > 0
                        THEN vbMovementId_2_Main
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning1 = TRUE THEN 3 WHEN vbIsUserSigning2 = TRUE THEN 2 ELSE 1 END :: Integer AS NPP
            , 'Исполнительному Директору : ' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_1_Main > 0
                        THEN 'Приоритетных документов для подписания '
                          || ' : '    || vbCount_1_Main :: TVarChar || ' шт.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_1_Main AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Main() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    № ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_1_Main)
                          || ' от '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_1_Main))
                          || ' период продаж с ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Main AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' по '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Main AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE 'Нет приоритетных документов'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Lime()
                   WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Lime()
                   ELSE -1
              END AS Color_Text
            , CURRENT_DATE :: TDateTime

       WHERE vbCount_1_Main > 0
       AND 1=0

      UNION ALL
       -- 2.2.
       SELECT CASE WHEN vbCount_2_Main > 0
                        THEN vbMovementId_2_Main
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning1 = TRUE THEN 3 WHEN vbIsUserSigning2 = TRUE THEN 2 ELSE 1 END :: Integer AS NPP
            , 'Исполнительному Директору : ' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_2_Main > 0
                        THEN 'подготовлены документы для подписания '
                          || ' : '    || vbCount_2_Main :: TVarChar || ' шт.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_2_Main AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Main() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    № ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_2_Main)
                          || ' от '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_2_Main))
                          || ' период продаж с ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Main AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' по '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Main AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE 'Нет подготовленных документов'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsUserSigning3 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Text
            , CURRENT_DATE :: TDateTime

       WHERE COALESCE (vbCount_1_Main, 0) = 0
       AND 1=0

      UNION ALL
       -- 3.
       SELECT -1 :: Integer AS MovementId

            , 11 AS NPP
            , 'Юридический отдел :' :: TVarChar AS MsgAddr
            , ('кол-во договоров = '    || vbCount_Contract :: TVarChar || ' шт.'
            || '  заканчивается срок действия с <' || zfConvert_DateToString (vbOperDate_Contract_start) || '> по <' || zfConvert_DateToString (vbOperDate_Contract) || '>'
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Text
            , CURRENT_DATE :: TDateTime
       WHERE vbIsMsg_Contract = TRUE


      UNION ALL
       -- 4.
       SELECT CASE WHEN vbCount_PromoTrade > 0
                        THEN vbMovementId_PromoTrade
                   ELSE -1
              END :: Integer AS MovementId

            , 44 :: Integer AS NPP
            , 'Трейд-маркетинг : ' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_PromoTrade > 0
                        THEN 'подготовлены документы для подписания '
                          || ' : '    || vbCount_PromoTrade :: TVarChar || ' шт.'
                          || COALESCE ((SELECT ' <' || MS.ValueData || '>' FROM MovementString AS MS WHERE MS.MovementId = vbMovementId_PromoTrade AND MS.DescId = zc_MovementString_Comment()), '')
                          || '    № ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_PromoTrade)
                          || ' от '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_PromoTrade))
                    ELSE 'Нет подготовленных документов'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_PromoTrade > 0 
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_PromoTrade > 0 
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr

              -- 2.1.
            , CASE WHEN vbCount_PromoTrade > 0 
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_PromoTrade > 0
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Text

            , CURRENT_DATE :: TDateTime

       WHERE vbIsUserPromoTrade = TRUE

       ORDER BY 2
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.06.20                                        * add EnumName
*/

-- SELECT * FROM gpSelect_Object_GlobalMsg ('', zfCalc_UserAdmin())
