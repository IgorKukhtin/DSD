-- Function: gpUpdate_MI_PersonalService_CardSecond_num()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_CardSecond_num (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_CardSecond_num(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
   DECLARE vbServiceDate   TDateTime;
   DECLARE vbStartDate     TDateTime;
   DECLARE vbEndDate       TDateTime;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbPersonalServiceListId_avance Integer;
   DECLARE vbMovementId_avance Integer;
   DECLARE vbMemberId_check Integer;

   DECLARE vbBankId_num_1  Integer;
   DECLARE vbBankId_num_2  Integer;
   DECLARE vbBankId_num_3  Integer;
   DECLARE vbSummMin_1     TFloat;
   DECLARE vbSummMin_2     TFloat;
   DECLARE vbSummMin_3     TFloat;
   DECLARE vbSummMax_1     TFloat;
   DECLARE vbSummMax_2     TFloat;
   DECLARE vbSummMax_3     TFloat;

   DECLARE vbBankId_const_1  Integer;
   DECLARE vbBankId_const_2  Integer;

   DECLARE vbKoeff_ro TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

     -- !!!
     vbKoeff_ro:= 20;

-- !!!тест
IF vbUserId = 5 AND 1=0
THEN
    PERFORM gpUnComplete_Movement_PersonalService (inMovementId:= inMovementId, inSession:= inSession);
END IF;

     -- сначала все удалили
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     IN (zc_MI_Master())
       AND MovementItem.isErased   = FALSE
      --AND 1=0
     ;


     -- определяем
     vbBankId_const_1:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.isErased = FALSE AND Object.ValueData ILIKE '%Банк Восток%' ORDER BY Object.Id DESC LIMIT 1);
     vbBankId_const_2:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.isErased = FALSE AND Object.ValueData ILIKE '%ОТП БАНК%' ORDER BY Object.Id DESC LIMIT 1);


     -- определяем <Ведомость> - что б выбрать только этих Сотрудников
     vbPersonalServiceListId := (SELECT MLO_PersonalServiceList.ObjectId
                                 FROM MovementLinkObject AS MLO_PersonalServiceList
                                 WHERE MLO_PersonalServiceList.MovementId = inMovementId
                                   AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                );

     -- определяем <Ведомость> - Аванс, из неё может быть заполнение данных
     vbPersonalServiceListId_avance:= (SELECT OL_PersonalServiceList_Avance_F2.ChildObjectId
                                       FROM ObjectLink AS OL_PersonalServiceList_Avance_F2
                                       WHERE OL_PersonalServiceList_Avance_F2.ObjectId = vbPersonalServiceListId
                                         AND OL_PersonalServiceList_Avance_F2.DescId     = zc_ObjectLink_PersonalServiceList_Avance_F2()
                                      );
     -- определяем документ - Аванс, из него может быть заполнение данных
     vbMovementId_avance:= (SELECT Movement.Id
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                               ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                              AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                              AND MLO_PersonalServiceList.ObjectId   = vbPersonalServiceListId_avance
                                 INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                               ON MovementDate_ServiceDate.MovementId = Movement.Id
                                                              AND MovementDate_ServiceDate.DescId     = zc_MIDate_ServiceDate()
                                                              AND MovementDate_ServiceDate.ValueData  = (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MIDate_ServiceDate())
                            WHERE Movement.DescId   = zc_Movement_PersonalService()
                              AND (Movement.StatusId = zc_Enum_Status_Complete()
                                OR vbUserId = 5
                                  )
                            LIMIT 1
                           );


     -- определяем
     SELECT
             -- какой банк надо первый
             CASE WHEN MovementFloat_BankSecond_num.ValueData = 1
                       THEN 1 -- MovementLinkObject_BankSecond_num.ObjectId

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 1
                       THEN 2 -- MovementLinkObject_BankSecondTwo_num.ObjectId

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 1
                       THEN 3 -- -1 -- MovementLinkObject_BankSecondDiff_num.ObjectId

             END AS BankId_num_1

             -- какой банк надо второй
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 2
                       THEN 1 -- MovementLinkObject_BankSecond_num.ObjectId

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 2
                       THEN 2 -- MovementLinkObject_BankSecondTwo_num.ObjectId

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 2
                       THEN 3 -- -1 -- MovementLinkObject_BankSecondDiff_num.ObjectId

             END AS BankId_num_2

             -- какой банк надо третий
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 3
                       THEN 1 -- MovementLinkObject_BankSecond_num.ObjectId

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 3
                       THEN 2 -- MovementLinkObject_BankSecondTwo_num.ObjectId

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 3
                       THEN 3 -- -1 -- MovementLinkObject_BankSecondDiff_num.ObjectId

             END AS BankId_num_3


             -- ограничение мин - 1
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 1 AND vbMovementId_avance > 0
                       THEN 3000 -- ВОСТОК + аванс

                  WHEN MovementFloat_BankSecond_num.ValueData = 1
                       THEN 4000 -- ВОСТОК

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 1
                       THEN 0

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 1
                       THEN 0

             END AS SummMin_1


             -- ограничение мин - 2
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 2 AND vbMovementId_avance > 0
                       THEN 3000 --ВОСТОК + аванс

                  WHEN MovementFloat_BankSecond_num.ValueData = 2
                       THEN 4000 -- ВОСТОК

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 2
                       THEN 0

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 2
                       THEN 0

             END AS SummMin_2

             -- ограничение мин - 3
           , CASE WHEN MovementFloat_BankSecond_num.ValueData = 3 AND vbMovementId_avance > 0
                       THEN 3000 -- ВОСТОК + аванс

                  WHEN MovementFloat_BankSecond_num.ValueData = 3
                       THEN 4000 -- ВОСТОК

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 3
                       THEN 0

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 3
                       THEN 0

             END AS SummMin_3


             -- ограничение - 1
           , CASE WHEN 1=1
                       THEN 39999

                  WHEN MovementFloat_BankSecond_num.ValueData = 1
                       THEN 0 -- ObjectFloat_BankSecond_SummMax.ValueData

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 1 AND COALESCE (vbMovementId_avance, 0) = 0
                       THEN 39999 -- ObjectFloat_BankSecondTwo_SummMax.ValueData

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 1
                       THEN 0 -- ObjectFloat_BankSecondDiff_SummMax.ValueData

             END AS SummMax_1


             -- ограничение - 2
           , CASE WHEN 1=1
                       THEN 39999

                  WHEN MovementFloat_BankSecond_num.ValueData = 2
                       THEN 0 -- ObjectFloat_BankSecond_SummMax.ValueData

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 2 AND COALESCE (vbMovementId_avance, 0) = 0
                       THEN 39999 -- ObjectFloat_BankSecondTwo_SummMax.ValueData

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 2
                       THEN 0 -- ObjectFloat_BankSecondDiff_SummMax.ValueData

             END AS SummMax_2

             -- ограничение - 3
           , CASE WHEN 1=1
                       THEN 39999

                  WHEN MovementFloat_BankSecond_num.ValueData = 3
                       THEN 0 -- ObjectFloat_BankSecond_SummMax.ValueData

                  WHEN MovementFloat_BankSecondTwo_num.ValueData = 3 AND COALESCE (vbMovementId_avance, 0) = 0
                       THEN 39999 -- ObjectFloat_BankSecondTwo_SummMax.ValueData

                  WHEN MovementFloat_BankSecondDiff_num.ValueData = 3
                       THEN 0 -- ObjectFloat_BankSecondDiff_SummMax.ValueData

             END AS SummMax_3


             INTO vbBankId_num_1, vbBankId_num_2, vbBankId_num_3
                , vbSummMin_1, vbSummMin_2, vbSummMin_3
                , vbSummMax_1, vbSummMax_2, vbSummMax_3

       FROM MovementLinkMovement AS MLM_BankSecondNum

            -- БАНК ВОСТОК
            LEFT JOIN MovementFloat AS MovementFloat_BankSecond_num
                                    ON MovementFloat_BankSecond_num.MovementId =  MLM_BankSecondNum.MovementChildId
                                   AND MovementFloat_BankSecond_num.DescId = zc_MovementFloat_BankSecond_num()

            -- ОТП БАНК
            LEFT JOIN MovementFloat AS MovementFloat_BankSecondTwo_num
                                    ON MovementFloat_BankSecondTwo_num.MovementId =  MLM_BankSecondNum.MovementChildId
                                   AND MovementFloat_BankSecondTwo_num.DescId = zc_MovementFloat_BankSecondTwo_num()

            -- БАНК Личный
            LEFT JOIN MovementFloat AS MovementFloat_BankSecondDiff_num
                                    ON MovementFloat_BankSecondDiff_num.MovementId =  MLM_BankSecondNum.MovementChildId
                                   AND MovementFloat_BankSecondDiff_num.DescId = zc_MovementFloat_BankSecondDiff_num()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecond_num
                                         ON MovementLinkObject_BankSecond_num.MovementId = MLM_BankSecondNum.MovementChildId
                                        AND MovementLinkObject_BankSecond_num.DescId = zc_MovementLinkObject_BankSecond_num()
            LEFT JOIN ObjectFloat AS ObjectFloat_BankSecond_SummMax
                                  ON ObjectFloat_BankSecond_SummMax.ObjectId = MovementLinkObject_BankSecond_num.ObjectId
                                 AND ObjectFloat_BankSecond_SummMax.DescId   = zc_ObjectFloat_Bank_SummMax()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecondTwo_num
                                         ON MovementLinkObject_BankSecondTwo_num.MovementId = MLM_BankSecondNum.MovementChildId
                                        AND MovementLinkObject_BankSecondTwo_num.DescId = zc_MovementLinkObject_BankSecondTwo_num()
            LEFT JOIN ObjectFloat AS ObjectFloat_BankSecondTwo_SummMax
                                  ON ObjectFloat_BankSecondTwo_SummMax.ObjectId = MovementLinkObject_BankSecondTwo_num.ObjectId
                                 AND ObjectFloat_BankSecondTwo_SummMax.DescId   = zc_ObjectFloat_Bank_SummMax()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecondDiff_num
                                         ON MovementLinkObject_BankSecondDiff_num.MovementId = MLM_BankSecondNum.MovementChildId
                                        AND MovementLinkObject_BankSecondDiff_num.DescId = zc_MovementLinkObject_BankSecondDiff_num()
            LEFT JOIN ObjectFloat AS ObjectFloat_BankSecondDiff_SummMax
                                  ON ObjectFloat_BankSecondDiff_SummMax.ObjectId = MovementLinkObject_BankSecondDiff_num.ObjectId
                                 AND ObjectFloat_BankSecondDiff_SummMax.DescId   = zc_ObjectFloat_Bank_SummMax()
       WHERE MLM_BankSecondNum.MovementId =  inMovementId
         AND MLM_BankSecondNum.DescId     =  zc_MovementLinkMovement_BankSecondNum()
      ;


      IF COALESCE (vbBankId_num_1, 0) = 0 AND COALESCE (vbBankId_num_2, 0) = 0 AND COALESCE (vbBankId_num_3, 0) = 0
      THEN
          RAISE EXCEPTION 'Ошибка.Приоритет по банкам не определен';
      END IF;


     -- определяем <Месяц начислений>
     vbServiceDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate());
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= vbServiceDate);

     -- определяем Период - 1 месяц
     vbStartDate:= (SELECT DATE_TRUNC ('MONTH', Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId);
     vbEndDate  := vbStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     -- данные
     /*CREATE TEMP TABLE _tmpServiceDate (ServiceDateId Integer, ServiceDate TDateTime) ON COMMIT DROP;
     INSERT INTO _tmpServiceDate (ServiceDateId Integer, ServiceDate TDateTime)
        WITH tmpPersonalService AS (SELECT DISTINCT
                                           DATE_TRUNC ('MONTH', MovementDate.ValueData) AS ServiceDate
                                    FROM Movement
                                         INNER JOIN MovementDate ON MovementDate.MovementId = Movement.Id
                                                                AND MovementDate.DescId     = zc_MIDate_ServiceDate()
                                    WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND Movement.DescId   = zc_Movement_PersonalService()
                                   )
      --SELECT vbServiceDateId, vbServiceDate
        SELECT lpInsertFind_Object_ServiceDate (inOperDate:= tmpPersonalService.ServiceDate)
             , tmpPersonalService.ServiceDate
        FROM tmpPersonalService
       ;*/




     -- Проверка, у каждого сотрудника с zc_ObjectLink_Personal_PersonalServiceListCardSecond должен быть isMain
     vbMemberId_check:=
          (WITH -- Сотрудники ВСЕ
                tmpPersonal_all AS (SELECT Object_Personal.Id                                         AS PersonalId
                                         , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                         , ObjectLink_Personal_Member.ChildObjectId                   AS MemberId
                                         , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                         , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 Заработная плата
                                         , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                         , CASE WHEN vbPersonalServiceListId_avance > 0
                                                THEN ObjectLink_Personal_PersonalServiceListAvance_F2.ChildObjectId
                                                ELSE ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId
                                           END AS PersonalServiceListId_CardSecond
                                         , ObjectBoolean_isMain.ValueData                             AS isMain

                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceList

                                         INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                                             AND Object_Personal.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                         INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                                                           AND Object_Member.isErased = FALSE
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_isMain
                                                                 ON ObjectBoolean_isMain.ObjectId = Object_Personal.Id
                                                                AND ObjectBoolean_isMain.DescId   = zc_ObjectBoolean_Personal_Main()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                              ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                              ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                              ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                             AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId   = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListAvance_F2
                                                              ON ObjectLink_Personal_PersonalServiceListAvance_F2.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_PersonalServiceListAvance_F2.DescId   = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
                                                             AND vbMovementId_avance >  0

                                         --  только строки, которые содержат в графе "№ карт. ЗП (Ф2)" признак "UA".

                                         -- 1- № карточного счета ЗП - Ф2(Восток)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecond
                                                                ON ObjectString_CardSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardSecond()
                                                               AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardIBANSecond()
                                         -- 1- Номер банковской карточки ЗП - Ф2(Восток)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecond
                                                                ON ObjectString_Member_CardBankSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecond.DescId    = zc_ObjectString_Member_CardBankSecond()
                                         -- 1- Bank - Ф2(Восток)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                                                              ON ObjectLink_Member_BankSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecond.DescId   = zc_ObjectLink_Member_BankSecond()
                                         -- 2 - № карточного счета ЗП - Ф2(ОТП)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                                                ON ObjectString_CardSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                            --AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardSecondTwo()
                                                               AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardIBANSecondTwo()
                                         -- 2 - Номер банковской карточки ЗП - Ф2(ОТП)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondTwo
                                                                ON ObjectString_Member_CardBankSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondTwo.DescId    = zc_ObjectString_Member_CardBankSecondTwo()
                                         -- 2- Bank - Ф2(ОТП)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondTwo
                                                              ON ObjectLink_Member_BankSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondTwo.DescId   = zc_ObjectLink_Member_BankSecondTwo()
                                         -- 3 - № карточного счета ЗП - Ф2(ОТП)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                                                ON ObjectString_CardSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardSecondDiff()
                                                               AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardIBANSecondDiff()
                                         -- 3 - Номер банковской карточки ЗП - Ф2(ОТП)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondDiff
                                                                ON ObjectString_Member_CardBankSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondDiff.DescId    = zc_ObjectString_Member_CardBankSecondDiff()
                                         -- 3- Bank - Ф2(ОТП)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondDiff
                                                              ON ObjectLink_Member_BankSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondDiff.DescId   = zc_ObjectLink_Member_BankSecondDiff()


                                    WHERE ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                      AND (ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId > 0
                                        OR ObjectLink_Personal_PersonalServiceListAvance_F2.ChildObjectId > 0
                                          )
                                      AND (-- 1 - Восток
                                           (/*ObjectString_CardSecond.ValueData ILIKE '%UA%' AND*/  zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecond.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecond.ChildObjectId > 0
                                           )
                                           -- 2 - ОТП
                                        OR (/*ObjectString_CardSecondTwo.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondTwo.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondTwo.ChildObjectId > 0
                                           )
                                           -- 3 - ОТП
                                        OR (/*ObjectString_CardSecondDiff.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondDiff.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondDiff.ChildObjectId > 0
                                           )
                                          )
                                   )
           SELECT tmp.MemberId
           FROM (SELECT DISTINCT tmpPersonal_all.MemberId FROM tmpPersonal_all WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId) AS tmp
                LEFT JOIN (SELECT DISTINCT tmpPersonal_all.MemberId FROM tmpPersonal_all WHERE tmpPersonal_all.isMain = TRUE
                          ) AS tmp_check ON tmp_check.MemberId = tmp.MemberId
           WHERE tmp_check.MemberId IS NULL
           LIMIT 1
          );
     IF vbMemberId_check > 0
        AND vbUserId <> 5
     THEN
       RAISE EXCEPTION 'Ошибка.Для Соотрудника <%> с признаком <Основное место работы = ДА> не заполнено <Ведомость начисления(Карта Ф2)>.', lfGet_Object_ValueData (vbMemberId_check);
     END IF;




     -- новые данные - MovementItem
     CREATE TEMP TABLE _tmpMI (MovementItemId Integer, MemberId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, PersonalServiceListId Integer, FineSubjectId Integer, UnitId_FineSubject Integer
                             , SummCardSecondRecalc TFloat
                             , BankId_1 Integer, BankId_2 Integer, BankId_3 Integer
                             , Num_1 Integer, Num_2 Integer, Num_3 Integer
                             , Sum_min_1 TFloat, Sum_min_2 TFloat, Sum_min_3 TFloat
                             , Sum_max_1 TFloat, Sum_max_2 TFloat, Sum_max_3 TFloat
                             , SummCard_1 TFloat, SummCard_2 TFloat, SummCard_3 TFloat
                              ) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI (MovementItemId, MemberId, PersonalId, UnitId, PositionId, InfoMoneyId, PersonalServiceListId, FineSubjectId, UnitId_FineSubject, SummCardSecondRecalc
                       , BankId_1, BankId_2, BankId_3
                       , Num_1, Num_2, Num_3
                       , Sum_min_1, Sum_min_2, Sum_min_3
                       , Sum_max_1, Sum_max_2, Sum_max_3
                       , SummCard_1, SummCard_2, SummCard_3
                        )
           WITH -- Сотрудники ВСЕ
                tmpPersonal_all AS (SELECT Object_Personal.Id                                         AS PersonalId
                                         , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                         , ObjectLink_Personal_Member.ChildObjectId                   AS MemberId
                                         , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                         , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 Заработная плата
                                         , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                         , CASE WHEN vbPersonalServiceListId_avance > 0
                                                THEN ObjectLink_Personal_PersonalServiceListAvance_F2.ChildObjectId
                                                ELSE ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId
                                           END AS PersonalServiceListId_CardSecond

                                         , ObjectBoolean_isMain.ValueData                             AS isMain
                                           -- 1 - справочно - Восток
                                         , CASE WHEN zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecond.ValueData, 8)) > 0
                                                -- если >0 - тогда формируется
                                                THEN COALESCE (ObjectLink_Member_BankSecond.ChildObjectId, 1)
                                           END AS BankId_1
                                           -- 2 - справочно - ОТП
                                         , CASE WHEN zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondTwo.ValueData, 8)) > 0
                                                -- если >0 - тогда формируется
                                                THEN COALESCE (ObjectLink_Member_BankSecondTwo.ChildObjectId, 1)
                                           END AS BankId_2
                                           -- 3 - справочно - Личный
                                         , CASE WHEN zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondDiff.ValueData, 8)) > 0
                                                -- если >0 - тогда формируется
                                                THEN COALESCE (ObjectLink_Member_BankSecondDiff.ChildObjectId, 1)
                                           END AS BankId_3


                                    FROM ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                         INNER JOIN Object AS Object_Personal ON Object_Personal.Id       = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                                             AND Object_Personal.isErased = FALSE
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                         INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                                                           AND Object_Member.isErased = FALSE
                                         LEFT JOIN ObjectBoolean AS ObjectBoolean_isMain
                                                                 ON ObjectBoolean_isMain.ObjectId = Object_Personal.Id
                                                                AND ObjectBoolean_isMain.DescId   = zc_ObjectBoolean_Personal_Main()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                              ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                              ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                              ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = ObjectLink_Personal_PersonalServiceList.ObjectId
                                                             AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId   = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListAvance_F2
                                                              ON ObjectLink_Personal_PersonalServiceListAvance_F2.ObjectId = Object_Personal.Id
                                                             AND ObjectLink_Personal_PersonalServiceListAvance_F2.DescId   = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
                                                             AND vbMovementId_avance >  0

                                         --  только строки, которые содержат в графе "№ карт. ЗП (Ф2)" признак "UA".
                                         -- 1- № карточного счета ЗП - Ф2(Восток)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecond
                                                                ON ObjectString_CardSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardSecond()
                                                               AND ObjectString_CardSecond.DescId    = zc_ObjectString_Member_CardIBANSecond()
                                         -- 1- Номер банковской карточки ЗП - Ф2(Восток)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecond
                                                                ON ObjectString_Member_CardBankSecond.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecond.DescId    = zc_ObjectString_Member_CardBankSecond()
                                         -- 1- Bank - Ф2(Восток)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecond
                                                              ON ObjectLink_Member_BankSecond.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecond.DescId   = zc_ObjectLink_Member_BankSecond()
                                         -- 2 - № карточного счета ЗП - Ф2(ОТП)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondTwo
                                                                ON ObjectString_CardSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardSecondTwo()
                                                               AND ObjectString_CardSecondTwo.DescId    = zc_ObjectString_Member_CardIBANSecondTwo()
                                         -- 2 - Номер банковской карточки ЗП - Ф2(ОТП)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondTwo
                                                                ON ObjectString_Member_CardBankSecondTwo.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondTwo.DescId    = zc_ObjectString_Member_CardBankSecondTwo()
                                         -- 2- Bank - Ф2(ОТП)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondTwo
                                                              ON ObjectLink_Member_BankSecondTwo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondTwo.DescId   = zc_ObjectLink_Member_BankSecondTwo()
                                         -- 3 - № карточного счета ЗП - Ф2(Личный)
                                         LEFT JOIN ObjectString AS ObjectString_CardSecondDiff
                                                                ON ObjectString_CardSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                             --AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardSecondDiff()
                                                               AND ObjectString_CardSecondDiff.DescId    = zc_ObjectString_Member_CardIBANSecondDiff()
                                         -- 3 - Номер банковской карточки ЗП - Ф2(Личный)
                                         LEFT JOIN ObjectString AS ObjectString_Member_CardBankSecondDiff
                                                                ON ObjectString_Member_CardBankSecondDiff.ObjectId  = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectString_Member_CardBankSecondDiff.DescId    = zc_ObjectString_Member_CardBankSecondDiff()
                                         -- 3- Bank - Ф2(Личный)
                                         LEFT JOIN ObjectLink AS ObjectLink_Member_BankSecondDiff
                                                              ON ObjectLink_Member_BankSecondDiff.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                             AND ObjectLink_Member_BankSecondDiff.DescId   = zc_ObjectLink_Member_BankSecondDiff()

                                    WHERE ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                      AND (ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId > 0
                                        OR ObjectLink_Personal_PersonalServiceListAvance_F2.ChildObjectId > 0
                                          )
                                      AND (-- 1 - Восток
                                           (/*ObjectString_CardSecond.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecond.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecond.ChildObjectId > 0
                                           )
                                           -- 2 - ОТП
                                        OR (/*ObjectString_CardSecondTwo.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondTwo.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondTwo.ChildObjectId > 0
                                           )
                                           -- 3 - Личный
                                        OR (/*ObjectString_CardSecondDiff.ValueData ILIKE '%UA%' AND*/ zfConvert_StringToNumber(LEFT (ObjectString_Member_CardBankSecondDiff.ValueData, 8)) > 0
                                        --AND ObjectLink_Member_BankSecondDiff.ChildObjectId > 0
                                           )
                                          )
                                   )
                -- все Физ лица - по ним все варианты Personal возьмем из Container
              , tmpMember AS (SELECT DISTINCT tmpPersonal_all.MemberId, tmpPersonal_all.InfoMoneyId, tmpPersonal_all.PersonalServiceListId
                                              -- 1 - справочно - Восток
                                            , tmpPersonal_all.BankId_1
                                              -- 2 - справочно - ОТП
                                            , tmpPersonal_all.BankId_2
                                              -- 3 - справочно - Личный
                                            , tmpPersonal_all.BankId_3
                              FROM tmpPersonal_all
                              WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId
                                AND tmpPersonal_all.isMain                           = TRUE
                             )
                -- Сотрудники - такие варианты Personal - убрать из Container, т.к. они будут в другой PersonalServiceListId
              , tmpPersonal_not AS (SELECT tmpPersonal_all.*
                                     FROM tmpPersonal_all
                                          INNER JOIN tmpMember ON tmpMember.MemberId = tmpPersonal_all.MemberId
                                     WHERE tmpPersonal_all.PersonalServiceListId_CardSecond <> vbPersonalServiceListId
                                    )
                -- Сотрудники из vbPersonalServiceListId - по ним варианты Personal - только то что в справочнике
              , tmpPersonal_only AS (SELECT tmpPersonal_all.*
                                     FROM tmpPersonal_all
                                          LEFT JOIN tmpMember ON tmpMember.MemberId = tmpPersonal_all.MemberId
                                     WHERE tmpPersonal_all.PersonalServiceListId_CardSecond = vbPersonalServiceListId
                                       AND tmpMember.MemberId                    IS NULL
                                    )
           -- за ОДИН Месяц начислений - vbServiceDateId
         , tmpContainer_all AS (SELECT CLO_ServiceDate.ContainerId              AS ContainerId
                                     , CLO_Personal.ObjectId                    AS PersonalId
                                     , CLO_Unit.ObjectId                        AS UnitId
                                     , CLO_Position.ObjectId                    AS PositionId
                                     , CLO_InfoMoney.ObjectId                   AS InfoMoneyId           -- 60101 Заработная плата
                                     , CLO_PersonalServiceList.ObjectId         AS PersonalServiceListId
                                     , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                FROM ContainerLinkObject AS CLO_ServiceDate
                                     INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                                    ON CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                     INNER JOIN ContainerLinkObject AS CLO_Personal
                                                                    ON CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                     INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                    ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                     INNER JOIN ContainerLinkObject AS CLO_Position
                                                                    ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                     INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                                    ON CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                                                   AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                     LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = CLO_PersonalServiceList.ObjectId

                                     INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                           ON ObjectLink_Personal_Member.ObjectId      = CLO_Personal.ObjectId
                                                          AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                     LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                          ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = CLO_PersonalServiceList.ObjectId
                                                         AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                                         AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                                     -- !!!исключили!!!
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_BankNot
                                                             ON ObjectBoolean_BankNot.ObjectId  = CLO_PersonalServiceList.ObjectId
                                                            AND ObjectBoolean_BankNot.DescId    = zc_ObjectBoolean_PersonalServiceList_BankNot()
                                                            AND ObjectBoolean_BankNot.ValueData = TRUE
                                WHERE CLO_ServiceDate.ObjectId    = vbServiceDateId
                                  AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                  AND ObjectLink_PersonalServiceList_PaidKind.ObjectId IS NULL
                                  -- !!!исключили!!!
                                  AND ObjectBoolean_BankNot.ObjectId IS NULL
                                  -- если это не Аванс
                                  AND COALESCE (vbPersonalServiceListId_avance, 0) = 0
-- AND CLO_ServiceDate.ContainerId In ( 5822660, 5822652)
                               )

             , tmpPersonal AS (SELECT DISTINCT
                                      tmpContainer_all.PersonalId
                                    , tmpContainer_all.UnitId
                                    , tmpContainer_all.PositionId
                                    , tmpContainer_all.InfoMoneyId           -- 60101 Заработная плата
                                    , tmpContainer_all.PersonalServiceListId
                                    , tmpContainer_all.MemberId
                                      -- 1 - справочно - Восток
                                    , tmpMember.BankId_1
                                      -- 2 - справочно - ОТП
                                    , tmpMember.BankId_2
                                      -- 3 - справочно - Личный
                                    , tmpMember.BankId_3
                               FROM tmpMember
                                    INNER JOIN tmpContainer_all ON tmpContainer_all.MemberId    = tmpMember.MemberId
                                                               AND tmpContainer_all.InfoMoneyId = tmpMember.InfoMoneyId
                                    LEFT JOIN tmpPersonal_not ON tmpPersonal_not.PersonalId            = tmpContainer_all.PersonalId
                                                             AND tmpPersonal_not.UnitId                = tmpContainer_all.UnitId
                                                             AND tmpPersonal_not.PositionId            = tmpContainer_all.PositionId
                                                             AND tmpPersonal_not.InfoMoneyId           = tmpContainer_all.InfoMoneyId
                                                             AND tmpPersonal_not.PersonalServiceListId = tmpContainer_all.PersonalServiceListId
                               WHERE tmpPersonal_not.PersonalId IS NULL
                              UNION
                               SELECT tmpPersonal_only.PersonalId
                                    , tmpPersonal_only.UnitId
                                    , tmpPersonal_only.PositionId
                                    , tmpPersonal_only.InfoMoneyId           -- 60101 Заработная плата
                                    , tmpPersonal_only.PersonalServiceListId
                                    , tmpPersonal_only.MemberId
                                      -- 1 - справочно - Восток
                                    , tmpPersonal_only.BankId_1
                                      -- 2 - справочно - ОТП
                                    , tmpPersonal_only.BankId_2
                                      -- 3 - справочно - Личный
                                    , tmpPersonal_only.BankId_3
                               FROM tmpPersonal_only
                               -- если это не Аванс
                               WHERE COALESCE (vbPersonalServiceListId_avance, 0) = 0
                              )
                -- текущие элементы
              , tmpMI AS (SELECT MovementItem.Id                                        AS MovementItemId
                               , MovementItem.ObjectId                                  AS PersonalId
                               , MILinkObject_Unit.ObjectId                             AS UnitId
                               , MILinkObject_Position.ObjectId                         AS PositionId
                               , MILinkObject_PersonalServiceList.ObjectId              AS PersonalServiceListId
                               , COALESCE (MILinkObject_FineSubject.ObjectId, 0)        AS FineSubjectId
                               , COALESCE (MILinkObject_UnitFineSubject.ObjectId, 0)    AS UnitId_FineSubject
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Unit.ObjectId, MILinkObject_Position.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                                ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_FineSubject
                                                                ON MILinkObject_FineSubject.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_UnitFineSubject
                                                                ON MILinkObject_UnitFineSubject.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                            -- если это не Аванс
                            AND COALESCE (vbPersonalServiceListId_avance, 0) = 0
                         )
         -- нашли Сотрудникам - существующие MovementItemId, причем ТОЛЬКО ОДИН
       , tmpListPersonal AS (SELECT COALESCE (tmpMI.MovementItemId, 0)                    AS MovementItemId
                                  , COALESCE (tmpPersonal.PersonalId,  tmpMI.PersonalId)  AS PersonalId
                                  , COALESCE (tmpPersonal.UnitId,      tmpMI.UnitId)      AS UnitId
                                  , COALESCE (tmpPersonal.PositionId,  tmpMI.PositionId)  AS PositionId
                                    -- если здесь пусто - значит это лишний элемент
                                  , tmpPersonal.InfoMoneyId                               AS InfoMoneyId
                                    -- если здесь пусто - значит это лишний элемент
                                  , tmpPersonal.PersonalServiceListId                     AS PersonalServiceListId
                                  , tmpPersonal.MemberId                                  AS MemberId
                                  , COALESCE (tmpMI.FineSubjectId, 0)                     AS FineSubjectId
                                  , COALESCE (tmpMI.UnitId_FineSubject, 0)                AS UnitId_FineSubject
                                    -- 1 - справочно - Восток
                                  , tmpPersonal.BankId_1
                                    -- 2 - справочно - ОТП
                                  , tmpPersonal.BankId_2
                                    -- 3 - справочно - Личный
                                  , tmpPersonal.BankId_3
                             FROM tmpMI
                                  FULL JOIN tmpPersonal ON tmpPersonal.PersonalId            = tmpMI.PersonalId
                                                       AND tmpPersonal.PositionId            = tmpMI.PositionId
                                                       AND tmpPersonal.UnitId                = tmpMI.UnitId
                                                       AND tmpPersonal.PersonalServiceListId = tmpMI.PersonalServiceListId
                                                       AND tmpMI.Ord              = 1

                            )
         -- список Container - для поиска в проводках - сколько уже выплатили
       , tmpContainer AS (SELECT tmpContainer_all.ContainerId
                               , tmpListPersonal.PersonalId
                               , tmpListPersonal.UnitId
                               , tmpListPersonal.PositionId
                               , tmpListPersonal.InfoMoneyId
                               , tmpListPersonal.PersonalServiceListId
                               , tmpListPersonal.FineSubjectId
                               , tmpListPersonal.UnitId_FineSubject
                          FROM tmpListPersonal
                               INNER JOIN tmpContainer_all ON tmpContainer_all.PersonalId            = tmpListPersonal.PersonalId
                                                          AND tmpContainer_all.UnitId                = tmpListPersonal.UnitId
                                                          AND tmpContainer_all.PositionId            = tmpListPersonal.PositionId
                                                          AND tmpContainer_all.InfoMoneyId           = tmpListPersonal.InfoMoneyId
                                                          AND tmpContainer_all.PersonalServiceListId = tmpListPersonal.PersonalServiceListId
                         )
   -- только проводки - сколько уже выплатили (Авансом)
 , tmpMIContainer_all AS (SELECT MIContainer.*
                               , tmpContainer.PersonalId
                               , tmpContainer.UnitId
                               , tmpContainer.PositionId
                               , tmpContainer.InfoMoneyId
                               , tmpContainer.PersonalServiceListId
                               , tmpContainer.FineSubjectId
                               , tmpContainer.UnitId_FineSubject
                          FROM tmpContainer
                               INNER JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                               AND MIContainer.DescId      = zc_MIContainer_Summ()
                                                             --AND (vbUserId <> 5 OR MIContainer.MovementDescId <> zc_Movement_Cash())
                         )
       -- только Карта БН - вычитаем начисления, а не выплаты
     , tmpSummCard AS (SELECT SUM (COALESCE (MIFloat_SummCard.ValueData, 0) + COALESCE (MIFloat_SummAvCardSecond.ValueData, 0))  AS Amount
                               , tmp.PersonalId
                               , tmp.UnitId
                               , tmp.PositionId
                               , tmp.InfoMoneyId
                               , tmp.PersonalServiceListId
                               , tmp.FineSubjectId
                               , tmp.UnitId_FineSubject
                          FROM (SELECT DISTINCT
                                       tmpMIContainer_all.MovementItemId
                                     , tmpMIContainer_all.PersonalId
                                     , tmpMIContainer_all.UnitId
                                     , tmpMIContainer_all.PositionId
                                     , tmpMIContainer_all.InfoMoneyId
                                     , tmpMIContainer_all.PersonalServiceListId
                                     , tmpMIContainer_all.FineSubjectId
                                     , tmpMIContainer_all.UnitId_FineSubject
                                FROM tmpMIContainer_all
                                WHERE tmpMIContainer_all.MovementDescId = zc_Movement_PersonalService()
                               ) AS tmp
                               LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                           ON MIFloat_SummCard.MovementItemId = tmp.MovementItemId
                                                          AND MIFloat_SummCard.DescId         = zc_MIFloat_SummCard()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                                           ON MIFloat_SummAvCardSecond.MovementItemId = tmp.MovementItemId
                                                          AND MIFloat_SummAvCardSecond.DescId         = zc_MIFloat_SummAvCardSecond()
                          WHERE MIFloat_SummCard.ValueData         <> 0
                             OR MIFloat_SummAvCardSecond.ValueData <> 0
                          GROUP BY tmp.PersonalId
                                 , tmp.UnitId
                                 , tmp.PositionId
                                 , tmp.InfoMoneyId
                                 , tmp.PersonalServiceListId
                                 , tmp.FineSubjectId
                                 , tmp.UnitId_FineSubject
                         )
       -- только проводки - сколько уже выплатили (Авансом)
     , tmpMIContainer AS (SELECT SUM (COALESCE (CASE WHEN tmpMIContainer_all.MovementDescId = zc_Movement_BankAccount()
                                                       OR tmpMIContainer_all.AnalyzerId     = zc_Enum_AnalyzerId_Cash_PersonalCardSecond()
                                                     THEN 0
                                                     ELSE tmpMIContainer_all.Amount
                                                END, 0))  AS Amount
                               , tmpMIContainer_all.PersonalId
                               , tmpMIContainer_all.UnitId
                               , tmpMIContainer_all.PositionId
                               , tmpMIContainer_all.InfoMoneyId
                               , tmpMIContainer_all.PersonalServiceListId
                               , tmpMIContainer_all.FineSubjectId
                               , tmpMIContainer_all.UnitId_FineSubject
                          FROM tmpMIContainer_all
                          GROUP BY tmpMIContainer_all.PersonalId
                                 , tmpMIContainer_all.UnitId
                                 , tmpMIContainer_all.PositionId
                                 , tmpMIContainer_all.InfoMoneyId
                                 , tmpMIContainer_all.PersonalServiceListId
                                 , tmpMIContainer_all.FineSubjectId
                                 , tmpMIContainer_all.UnitId_FineSubject
                         )
            -- Все ведомости БН - Ф1 - ?ОТП? - !!!отключили!!!
          , tmpSummCard_otp AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                     , SUM (COALESCE (MIFloat_SummCardRecalc.ValueData, 0) + COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)) AS SummCard
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                                 ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                                AND MIFloat_SummCardRecalc.DescId         = zc_MIFloat_SummCardRecalc()
                                     LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                                 ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                                AND MIFloat_SummAvCardSecondRecalc.DescId         = zc_MIFloat_SummAvCardSecondRecalc()
                                                                AND 1=0
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()

                                     LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                  ON MLO_PersonalServiceList.MovementId = Movement.Id
                                                                 AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                     LEFT JOIN ObjectLink AS OL_PersonalServiceList_Bank
                                                          ON OL_PersonalServiceList_Bank.ObjectId = MLO_PersonalServiceList.ObjectId
                                                         AND OL_PersonalServiceList_Bank.DescId     = zc_ObjectLink_PersonalServiceList_Bank()
                                     INNER JOIN Object AS Object_Bank ON Object_Bank.Id        = OL_PersonalServiceList_Bank.ChildObjectId
                                                                     AND Object_Bank.ValueData ILIKE '%ОТП Б%'

                                WHERE Movement.Operdate BETWEEN vbStartDate AND vbEndDate
                                  AND Movement.DescId   = zc_Movement_PersonalService()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  -- !!!отключили!!!
                                  AND 1=0

                                GROUP BY ObjectLink_Personal_Member.ChildObjectId
                               )

         -- ВСЕ Відомість карточки БН ... +  Банк 2  ПФ + Банк 2 Аванс
       , tmpSummCard_avance AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                     , SUM (COALESCE (MIFloat_SummCardRecalc.ValueData, 0) + COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)) AS SummCard
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                                 ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                                AND MIFloat_SummCardRecalc.DescId         = zc_MIFloat_SummCardRecalc()
                                     LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                                 ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                                AND MIFloat_SummAvCardSecondRecalc.DescId         = zc_MIFloat_SummAvCardSecondRecalc()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()


                                WHERE Movement.Operdate BETWEEN vbStartDate AND vbEndDate
                                  AND Movement.DescId   = zc_Movement_PersonalService()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                GROUP BY ObjectLink_Personal_Member.ChildObjectId
                               )

       -- результат - SummCardSecondRecalc
     , tmpData_SummCardSecondRecalc
                 AS (SELECT tmpListPersonal.MovementItemId
                          , tmpListPersonal.MemberId
                          , tmpListPersonal.PersonalId
                          , tmpListPersonal.UnitId
                          , tmpListPersonal.PositionId
                          , tmpListPersonal.InfoMoneyId
                          , tmpListPersonal.PersonalServiceListId
                          , tmpListPersonal.FineSubjectId
                          , tmpListPersonal.UnitId_FineSubject
                            -- вычитаем начисления, а не выплаты
                          , CASE WHEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0
                                           -- т.к. в проводках долг с минусом
                                      THEN -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0)
                                 ELSE 0
                            END AS SummCardSecondRecalc

                            -- подставили на первое место
                          , CASE WHEN vbBankId_num_1 = 1 THEN tmpListPersonal.BankId_1
                                 WHEN vbBankId_num_2 = 1 THEN tmpListPersonal.BankId_2
                                 WHEN vbBankId_num_3 = 1 THEN tmpListPersonal.BankId_3
                            END AS BankId_1

                            -- подставили на второе место
                          , CASE WHEN vbBankId_num_1 = 2 THEN tmpListPersonal.BankId_1
                                 WHEN vbBankId_num_2 = 2 THEN tmpListPersonal.BankId_2
                                 WHEN vbBankId_num_3 = 2 THEN tmpListPersonal.BankId_3
                            END AS BankId_2

                            -- подставили на третье место
                          , CASE WHEN vbBankId_num_1 = 3 THEN tmpListPersonal.BankId_1
                                 WHEN vbBankId_num_2 = 3 THEN tmpListPersonal.BankId_2
                                 WHEN vbBankId_num_3 = 3 THEN tmpListPersonal.BankId_3
                            END AS BankId_3

                            -- кто из 1,2,3 на первом месте
                          , vbBankId_num_1 AS Num_1
                            -- кто из 1,2,3 на втором месте
                          , vbBankId_num_2 AS Num_2
                            -- кто из 1,2,3 на третьем месте
                          , vbBankId_num_3 AS Num_3

                            -- ограничение мин - для 1,2,3
                          , vbSummMin_1 AS Sum_min_1
                          , vbSummMin_2 AS Sum_min_2
                          , vbSummMin_3 AS Sum_min_3

                            -- ограничение - для 1
                          , vbSummMax_1 - CASE WHEN vbBankId_num_2 = 1 THEN COALESCE (tmpSummCard_otp.SummCard, 0)
                                               ELSE 0
                                          END
                                        - COALESCE (tmpSummCard_avance.SummCard, 0)
                            AS Sum_max_1
                            -- ограничение - для 2
                          , vbSummMax_2 - CASE WHEN vbBankId_num_2 = 2 THEN COALESCE (tmpSummCard_otp.SummCard, 0)
                                               ELSE 0
                                          END
                                        - COALESCE (tmpSummCard_avance.SummCard, 0)
                            AS Sum_max_2
                            -- ограничение - для 3
                          , vbSummMax_3 - CASE WHEN vbBankId_num_2 = 3 THEN COALESCE (tmpSummCard_otp.SummCard, 0)
                                               ELSE 0
                                          END
                                        - COALESCE (tmpSummCard_avance.SummCard, 0)
                            AS Sum_max_3

                     FROM tmpListPersonal
                          LEFT JOIN tmpSummCard_otp    ON tmpSummCard_otp.MemberId    = tmpListPersonal.MemberId
                          LEFT JOIN tmpSummCard_avance ON tmpSummCard_avance.MemberId = tmpListPersonal.MemberId

                          LEFT JOIN tmpMIContainer ON tmpMIContainer.PersonalId            = tmpListPersonal.PersonalId
                                                  AND tmpMIContainer.UnitId                = tmpListPersonal.UnitId
                                                  AND tmpMIContainer.PositionId            = tmpListPersonal.PositionId
                                                  AND tmpMIContainer.InfoMoneyId           = tmpListPersonal.InfoMoneyId
                                                  AND tmpMIContainer.PersonalServiceListId = tmpListPersonal.PersonalServiceListId

                          LEFT JOIN tmpSummCard ON tmpSummCard.PersonalId            = tmpListPersonal.PersonalId
                                               AND tmpSummCard.UnitId                = tmpListPersonal.UnitId
                                               AND tmpSummCard.PositionId            = tmpListPersonal.PositionId
                                               AND tmpSummCard.InfoMoneyId           = tmpListPersonal.InfoMoneyId
                                               AND tmpSummCard.PersonalServiceListId = tmpListPersonal.PersonalServiceListId
                                               AND tmpSummCard.FineSubjectId         = tmpListPersonal.FineSubjectId
                                               AND tmpSummCard.UnitId_FineSubject     = tmpListPersonal.UnitId_FineSubject
                     WHERE tmpListPersonal.MovementItemId > 0
                        OR -1 * COALESCE (tmpMIContainer.Amount, 0) - COALESCE (tmpSummCard.Amount, 0) > 0 -- !!! т.е. если есть долг по ЗП


                    UNION
                     -- Аванс
                     SELECT 0 AS MovementItemId
                          , tmpMember.MemberId
                          , MovementItem.ObjectId          AS PersonalId
                          , MILinkObject_Unit.ObjectId     AS UnitId
                          , MILinkObject_Position.ObjectId AS PositionId
                          , tmpMember.InfoMoneyId
                          , tmpMember.PersonalServiceListId
                          , 0 AS FineSubjectId
                          , 0 AS UnitId_FineSubject
                            -- вычитаем начисления, а не выплаты
                          , MIF_SummAvanceRecalc.ValueData AS SummCardSecondRecalc

                            -- подставили на первое место
                          , CASE WHEN vbBankId_num_1 = 1 THEN tmpMember.BankId_1
                                 WHEN vbBankId_num_2 = 1 THEN tmpMember.BankId_2
                                 WHEN vbBankId_num_3 = 1 THEN tmpMember.BankId_3
                            END AS BankId_1

                            -- подставили на второе место
                          , CASE WHEN vbBankId_num_1 = 2 THEN tmpMember.BankId_1
                                 WHEN vbBankId_num_2 = 2 THEN tmpMember.BankId_2
                                 WHEN vbBankId_num_3 = 2 THEN tmpMember.BankId_3
                            END AS BankId_2

                            -- подставили на третье место
                          , CASE WHEN vbBankId_num_1 = 3 THEN tmpMember.BankId_1
                                 WHEN vbBankId_num_2 = 3 THEN tmpMember.BankId_2
                                 WHEN vbBankId_num_3 = 3 THEN tmpMember.BankId_3
                            END AS BankId_3

                            -- кто из 1,2,3 на первом месте
                          , vbBankId_num_1 AS Num_1
                            -- кто из 1,2,3 на втором месте
                          , vbBankId_num_2 AS Num_2
                            -- кто из 1,2,3 на третьем месте
                          , vbBankId_num_3 AS Num_3

                            -- ограничение мин - для 1,2,3
                          , vbSummMin_1 AS Sum_min_1
                          , vbSummMin_2 AS Sum_min_2
                          , vbSummMin_3 AS Sum_min_3

                            -- ограничение - для 1
                          , vbSummMax_1 AS Sum_max_1
                            -- ограничение - для 2
                          , vbSummMax_2 AS Sum_max_2
                            -- ограничение - для 3
                          , vbSummMax_3 AS Sum_max_3

                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                           ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                           ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_FineSubject
                                                           ON MILinkObject_FineSubject.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_UnitFineSubject
                                                           ON MILinkObject_UnitFineSubject.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
                          LEFT JOIN MovementItemFloat AS MIF_SummAvanceRecalc
                                                      ON MIF_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                                     AND MIF_SummAvanceRecalc.DescId         = zc_MIFloat_SummAvanceRecalc()

                          INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()

                          -- все Физ лица
                          INNER JOIN tmpMember ON tmpMember.MemberId = ObjectLink_Personal_Member.ChildObjectId

                     WHERE MovementItem.MovementId = vbMovementId_avance
                       AND MovementItem.isErased   = FALSE
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MIF_SummAvanceRecalc.ValueData > 0

                    )
       -- результат
     , tmpMI_res AS (SELECT tmpData.MovementItemId
                          , tmpData.MemberId
                          , tmpData.PersonalId
                          , tmpData.UnitId
                          , tmpData.PositionId
                          , tmpData.InfoMoneyId
                          , tmpData.PersonalServiceListId
                          , tmpData.FineSubjectId
                          , tmpData.UnitId_FineSubject
                          , tmpData.SummCardSecondRecalc
                          , tmpData.SummCardSecondRecalc_orig

                            -- банк на первом месте + вернули пусто
                          , CASE WHEN tmpData.BankId_1 > 1 THEN tmpData.BankId_1 ELSE NULL END AS BankId_1
                            -- банк на втором месте + вернули пусто
                          , CASE WHEN tmpData.BankId_2 > 1 THEN tmpData.BankId_2 ELSE NULL END AS BankId_2
                            -- банк на третьем месте + вернули пусто
                          , CASE WHEN tmpData.BankId_3 > 1 THEN tmpData.BankId_3 ELSE NULL END AS BankId_3

                            -- кто из 1,2,3 на первом месте
                          , tmpData.Num_1
                            -- кто из 1,2,3 на втором месте
                          , tmpData.Num_2
                            -- кто из 1,2,3 на третьем месте
                          , tmpData.Num_3

                            -- лимит мин - для 1,2,3
                          , tmpData.Sum_min_1, tmpData.Sum_min_2, tmpData.Sum_min_3
                            -- лимит - для 1
                          , tmpData.Sum_max_1
                            -- лимит - для 2
                          , tmpData.Sum_max_2
                            -- лимит - для 3
                          , tmpData.Sum_max_3

                            -- сумма для первого места
                          , tmpData.SummCard_1
                            -- сумма для второго места
                          , tmpData.SummCard_2

                            -- сумма для 3 - места
                          , CASE -- если уже распределили
                                 WHEN tmpData.SummCard_1 > 0 OR tmpData.SummCard_2 > 0
                                      THEN 0
                                 -- есть условие и Мин и Макс
                                 WHEN tmpData.BankId_3 > 0 AND tmpData.Sum_max_3 > 0 AND tmpData.Sum_min_3 <= ROUND (tmpData.SummCardSecondRecalc_check, 1) - tmpData.SummCard_1 - tmpData.SummCard_2
                                      THEN CASE WHEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2 > tmpData.Sum_max_3 THEN tmpData.Sum_max_3 ELSE ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2 END

                                 -- есть только Мин
                                 WHEN tmpData.BankId_3 > 0 AND tmpData.Sum_min_3 <= ROUND (tmpData.SummCardSecondRecalc_check, 1) - tmpData.SummCard_1 - tmpData.SummCard_2
                                      THEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2
                                 ELSE 0
                            END AS SummCard_3

                            -- накопительно - 1
                          , SUM (tmpData.SummCard_1) OVER (PARTITION BY tmpData.MemberId ORDER BY tmpData.MovementItemId ASC) AS SummCard_1_sum
                            -- накопительно - 2
                          , SUM (tmpData.SummCard_2) OVER (PARTITION BY tmpData.MemberId ORDER BY tmpData.MovementItemId ASC) AS SummCard_2_sum
                            -- накопительно - 3
                          , SUM (CASE WHEN tmpData.BankId_3 > 0 AND tmpData.Sum_max_3 > 0 AND tmpData.Sum_min_3 <= ROUND (tmpData.SummCardSecondRecalc_check, 1) - tmpData.SummCard_1 - tmpData.SummCard_2
                                      THEN CASE WHEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2 > tmpData.Sum_max_3 THEN tmpData.Sum_max_3 ELSE ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2 END

                                      WHEN tmpData.BankId_3 > 0 AND tmpData.Sum_min_3 <= ROUND (tmpData.SummCardSecondRecalc_check, 1) - tmpData.SummCard_1 - tmpData.SummCard_2
                                      THEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 - tmpData.SummCard_2
                                      ELSE 0
                                 END) OVER (PARTITION BY tmpData.MemberId ORDER BY tmpData.MovementItemId ASC) AS SummCard_3_sum


                     FROM
                    (SELECT tmpData.*

                            -- сумма для 2 - места
                          , CASE -- если уже распределили
                                 WHEN tmpData.SummCard_1 > 0
                                      THEN 0
                                 -- есть условие и Мин и Макс
                                 WHEN tmpData.BankId_2 > 0 AND tmpData.Sum_max_2 > 0 AND tmpData.Sum_min_2 <= ROUND (tmpData.SummCardSecondRecalc_check, 1) - tmpData.SummCard_1
                                 THEN CASE WHEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 > tmpData.Sum_max_2 THEN tmpData.Sum_max_2 ELSE ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1 END

                                 -- есть только Мин
                                 WHEN tmpData.BankId_2 > 0 AND tmpData.Sum_min_2 <= ROUND (tmpData.SummCardSecondRecalc_check, 1) - tmpData.SummCard_1
                                 THEN ROUND (tmpData.SummCardSecondRecalc, 1) - tmpData.SummCard_1
                                 ELSE 0
                            END AS SummCard_2


                     FROM
                    (SELECT tmpData.*
                            -- итого сумма по физ лицу - именно ее проверяем на минимум
                          , tmpData.SummCardSecondRecalc AS SummCardSecondRecalc_orig
                            -- итого сумма по физ лицу - именно ее проверяем на минимум
                          , tmpData_check.SummCardSecondRecalc_check

                            -- сумма для 1 - места
                          , CASE -- есть условие и Мин и Макс
                                 -- WHEN vbUserId = 5
                                 -- THEN 200

                                 WHEN tmpData.BankId_1 > 0 AND tmpData.Sum_max_1 > 0 AND tmpData.Sum_min_1 <= ROUND (tmpData_check.SummCardSecondRecalc_check, 1)
                                 THEN CASE WHEN ROUND (tmpData.SummCardSecondRecalc, 1) > tmpData.Sum_max_1
                                                -- только сумма макс
                                                THEN tmpData.Sum_max_1
                                           ELSE -- вся сумма
                                                ROUND (tmpData.SummCardSecondRecalc, 1)
                                      END

                                 -- есть только Мин
                                 WHEN tmpData.BankId_1 > 0 AND tmpData.Sum_min_1 <= ROUND (tmpData_check.SummCardSecondRecalc_check, 1)
                                 THEN ROUND (tmpData.SummCardSecondRecalc, 1)
                                 ELSE 0
                            END AS SummCard_1


                     FROM tmpData_SummCardSecondRecalc AS tmpData
                          -- итого сумма по физ лицу - именно ее проверяем на минимум
                          LEFT JOIN (SELECT tmpData_SummCardSecondRecalc.MemberId, SUM (tmpData_SummCardSecondRecalc.SummCardSecondRecalc) AS SummCardSecondRecalc_check
                                     FROM tmpData_SummCardSecondRecalc
                                     GROUP BY tmpData_SummCardSecondRecalc.MemberId
                                    ) AS tmpData_check
                                      ON tmpData_check.MemberId = tmpData.MemberId
                    ) AS tmpData
                    ) AS tmpData
                    )

        -- список с лимитами
      , tmpList_limit AS (SELECT tmpMI_res.MemberId
                               , tmpMI_res.Sum_max_1 AS SummMax
                               , 1 AS num
                          FROM tmpMI_res
                          WHERE tmpMI_res.Sum_max_1 > 0
                          GROUP BY tmpMI_res.MemberId, tmpMI_res.Sum_max_1
                          HAVING tmpMI_res.Sum_max_1 < SUM (tmpMI_res.SummCard_1)

                         UNION ALL
                          SELECT
                                 tmpMI_res.MemberId
                               , tmpMI_res.Sum_max_2 AS SummMax
                               , 2 AS num
                          FROM tmpMI_res
                          WHERE tmpMI_res.Sum_max_2 > 0
                          GROUP BY tmpMI_res.MemberId, tmpMI_res.Sum_max_2
                          HAVING tmpMI_res.Sum_max_2 < SUM (tmpMI_res.SummCard_2)

                         UNION ALL
                          SELECT
                                 tmpMI_res.MemberId
                               , tmpMI_res.Sum_max_3 AS SummMax
                               , 3 AS num
                          FROM tmpMI_res
                          WHERE tmpMI_res.Sum_max_3 > 0
                          GROUP BY tmpMI_res.MemberId, tmpMI_res.Sum_max_3
                          HAVING tmpMI_res.Sum_max_3 < SUM (tmpMI_res.SummCard_3)
                         )
     -- распределили согласно лимитов
   , tmpList_limit_res AS (SELECT tmpMI_res.*
                                , tmpList.num
                                  -- сколько распределяется
                                , CASE WHEN tmpList.num = 1
                                            THEN CASE WHEN tmpMI_res.SummCard_1_sum <= tmpList.SummMax
                                                           -- вся сумма остается
                                                           THEN tmpMI_res.SummCard_1
                                                      WHEN tmpMI_res.SummCard_1_sum - tmpMI_res.SummCard_1 <= tmpList.SummMax
                                                           -- сколько осталось от лимита
                                                           THEN tmpList.SummMax - (tmpMI_res.SummCard_1_sum - tmpMI_res.SummCard_1)
                                                      -- ничего не остается
                                                      ELSE 0
                                                 END
                                       ELSE 0
                                  END AS SummCard_new
                           FROM tmpMI_res
                                INNER JOIN tmpList_limit AS tmpList ON tmpList.MemberId = tmpMI_res.MemberId
                          )
           -- Результат
           SELECT tmpMI_res.MovementItemId, tmpMI_res.MemberId, tmpMI_res.PersonalId, tmpMI_res.UnitId, tmpMI_res.PositionId, tmpMI_res.InfoMoneyId
                , tmpMI_res.PersonalServiceListId, tmpMI_res.FineSubjectId, tmpMI_res.UnitId_FineSubject

                  -- НЕ пересчитали
                , CASE WHEN 1=1 THEN tmpMI_res.SummCardSecondRecalc_orig
                       /*WHEN vbUserId = 5 AND 1=0 THEN tmpMI_res.SummCardSecondRecalc
                  ELSE
                  -- 1
                  CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 1
                       -- новая сумма
                       THEN tmpList_limit_res.SummCard_new
                       -- оригинал
                       ELSE tmpMI_res.SummCard_1
                  END
                  -- 2
                + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 2
                       -- новая сумма
                       THEN tmpList_limit_res.SummCard_new

                       -- оригинал
                       ELSE tmpMI_res.SummCard_2
                            -- плюс разница из 1 - если для 2 есть банк
                          + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 1 AND tmpMI_res.BankId_2 > 0
                                      THEN tmpMI_res.SummCard_1 - tmpList_limit_res.SummCard_new
                                 ELSE 0
                            END
                  END
                  -- 3
                + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 3
                       -- новая сумма
                       THEN tmpList_limit_res.SummCard_new

                       -- оригинал
                       ELSE tmpMI_res.SummCard_3
                            -- плюс разница из 1 - если для 3 есть банк + если для 2 банк не нашли
                          + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 1 AND tmpMI_res.BankId_3 > 0
                                  -- здесь для 2 банк не нашли
                                  AND COALESCE (tmpMI_res.BankId_2, 0) = 0
                                      THEN tmpMI_res.SummCard_1 - tmpList_limit_res.SummCard_new
                                 ELSE 0
                            END
                            -- плюс разница из 2 - если для 3 есть банк
                          + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 2 AND tmpMI_res.BankId_3 > 0
                                      THEN tmpMI_res.SummCard_2 - tmpList_limit_res.SummCard_new
                                 ELSE 0
                            END
                  END*/
                  END AS SummCardSecondRecalc

                  --
                , tmpMI_res.BankId_1, tmpMI_res.BankId_2, tmpMI_res.BankId_3
                  --
                , tmpMI_res.Num_1, tmpMI_res.Num_2, tmpMI_res.Num_3
                  --
                , tmpMI_res.Sum_min_1, tmpMI_res.Sum_min_2, tmpMI_res.Sum_min_3
                , tmpMI_res.Sum_max_1, tmpMI_res.Sum_max_2, tmpMI_res.Sum_max_3
                  --
                , CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 1
                       -- новая сумма
                       THEN tmpList_limit_res.SummCard_new
                       -- оригинал
                       ELSE tmpMI_res.SummCard_1
                  END AS SummCard_1
                  --
                , CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 2
                       -- новая сумма
                       THEN tmpList_limit_res.SummCard_new

                       -- оригинал
                       ELSE tmpMI_res.SummCard_2
                            -- плюс разница из 1 - если для 2 есть банк
                          + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 1 AND tmpMI_res.BankId_2 > 0
                                      THEN tmpMI_res.SummCard_1 - tmpList_limit_res.SummCard_new
                                 ELSE 0
                            END
                  END AS SummCard_2
                  --
                , CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 3
                       -- новая сумма
                       THEN tmpList_limit_res.SummCard_new

                       -- оригинал
                       ELSE tmpMI_res.SummCard_3
                            -- плюс разница из 1 - если для 3 есть банк + если для 2 банк не нашли
                          + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 1 AND tmpMI_res.BankId_3 > 0
                                  -- здесь для 2 банк не нашли
                                  AND COALESCE (tmpMI_res.BankId_2, 0) = 0
                                      THEN tmpMI_res.SummCard_1 - tmpList_limit_res.SummCard_new
                                 ELSE 0
                            END
                            -- плюс разница из 2 - если для 3 есть банк
                          + CASE WHEN COALESCE (tmpList_limit_res.num, 0) = 2 AND tmpMI_res.BankId_3 > 0
                                      THEN tmpMI_res.SummCard_2 - tmpList_limit_res.SummCard_new
                                 ELSE 0
                            END
                  END AS SummCard_3

           FROM tmpMI_res
                LEFT JOIN tmpList_limit_res ON tmpList_limit_res.PersonalId            = tmpMI_res.PersonalId
                                   AND tmpList_limit_res.UnitId                = tmpMI_res.UnitId
                                   AND tmpList_limit_res.PositionId            = tmpMI_res.PositionId
                                   AND tmpList_limit_res.InfoMoneyId           = tmpMI_res.InfoMoneyId
                                   AND tmpList_limit_res.PersonalServiceListId = tmpMI_res.PersonalServiceListId
                                   AND tmpList_limit_res.FineSubjectId         = tmpMI_res.FineSubjectId
                                   AND tmpList_limit_res.UnitId_FineSubject    = tmpMI_res.UnitId_FineSubject
          ;


     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION '<%>   <%>   <%>   <%>'
       , (select sum (_tmpMI.SummCard_1) from _tmpMI where PersonalId = 5897096)
       , (select sum (_tmpMI.SummCard_2) from _tmpMI where PersonalId = 5897096)
       , (select sum (_tmpMI.SummCard_3) from _tmpMI where PersonalId = 5897096)
       , (select sum (_tmpMI.SummCardSecondRecalc) from _tmpMI where PersonalId = 5897096)
       ;
         /*RAISE EXCEPTION 'Ошибка.Admin <%>  <%>  <%>  <%>.'
                       , (SELECT SUM (_tmpMI.SummCardSecondRecalc) FROM _tmpMI)
                       , (SELECT SUM (_tmpMI.SummCard_1) FROM _tmpMI where _tmpMI.MemberId = 919222)
                       , (SELECT SUM (_tmpMI.SummCard_2) FROM _tmpMI where _tmpMI.MemberId = 919222)
                       , (SELECT SUM (_tmpMI.SummCardSecondRecalc) FROM _tmpMI where _tmpMI.MemberId = 919222)
                        ;*/
     END IF;

     -- сохраняем элементы
     PERFORM -- здесь всегда Восток
             lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankSecond_num(), _tmpMI.MovementItemId
                                                  , CASE WHEN 0 = CASE WHEN _tmpMI.Num_1 = 1 THEN COALESCE (_tmpMI.SummCard_1, 0)
                                                                       WHEN _tmpMI.Num_2 = 1 THEN COALESCE (_tmpMI.SummCard_2, 0)
                                                                       WHEN _tmpMI.Num_3 = 1 THEN COALESCE (_tmpMI.SummCard_3, 0)
                                                                  END
                                                              THEN NULL
                                                         WHEN _tmpMI.Num_1 = 1 THEN COALESCE (_tmpMI.BankId_1, vbBankId_const_1)
                                                         WHEN _tmpMI.Num_2 = 1 THEN COALESCE (_tmpMI.BankId_2, vbBankId_const_1)
                                                         WHEN _tmpMI.Num_3 = 1 THEN _tmpMI.BankId_3
                                                    END
                                                   )
             -- здесь всегда ОТП
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankSecondTwo_num(), _tmpMI.MovementItemId
                                                  , CASE WHEN 0 = CASE WHEN _tmpMI.Num_1 = 2 THEN COALESCE (_tmpMI.SummCard_1, 0)
                                                                       WHEN _tmpMI.Num_2 = 2 THEN COALESCE (_tmpMI.SummCard_2, 0)
                                                                       WHEN _tmpMI.Num_3 = 2 THEN COALESCE (_tmpMI.SummCard_3, 0)
                                                                  END
                                                              THEN NULL
                                                         WHEN _tmpMI.Num_1 = 2 THEN COALESCE (_tmpMI.BankId_1, vbBankId_const_2)
                                                         WHEN _tmpMI.Num_2 = 2 THEN COALESCE (_tmpMI.BankId_2, vbBankId_const_2)
                                                         WHEN _tmpMI.Num_3 = 2 THEN _tmpMI.BankId_3
                                                    END
                                                   )
             -- здесь всегда Личный
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BankSecondDiff_num(), _tmpMI.MovementItemId
                                                  , CASE WHEN 0 = CASE WHEN _tmpMI.Num_1 = 3 THEN COALESCE (_tmpMI.SummCard_1, 0)
                                                                       WHEN _tmpMI.Num_2 = 3 THEN COALESCE (_tmpMI.SummCard_2, 0)
                                                                       WHEN _tmpMI.Num_3 = 3 THEN COALESCE (_tmpMI.SummCard_3, 0)
                                                                  END
                                                              THEN NULL
                                                         WHEN _tmpMI.Num_1 = 3 THEN COALESCE (_tmpMI.BankId_1, _tmpMI.BankId_3)
                                                         WHEN _tmpMI.Num_2 = 3 THEN COALESCE (_tmpMI.BankId_2, _tmpMI.BankId_3)
                                                         WHEN _tmpMI.Num_3 = 3 THEN _tmpMI.BankId_3
                                                    END
                                                   )
             -- здесь всегда Восток
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecond_num(), _tmpMI.MovementItemId
                                             , CASE WHEN _tmpMI.Num_1 = 1 THEN ROUND (_tmpMI.SummCard_1 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    WHEN _tmpMI.Num_2 = 1 THEN ROUND (_tmpMI.SummCard_2 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    WHEN _tmpMI.Num_3 = 1 THEN ROUND (_tmpMI.SummCard_3 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    ELSE 0
                                               END
                                              )
             -- здесь всегда ОТП
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondTwo_num(), _tmpMI.MovementItemId
                                             , CASE WHEN _tmpMI.Num_1 = 2 THEN ROUND (_tmpMI.SummCard_1 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    WHEN _tmpMI.Num_2 = 2 THEN ROUND (_tmpMI.SummCard_2 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    WHEN _tmpMI.Num_3 = 2 THEN ROUND (_tmpMI.SummCard_3 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    ELSE 0
                                               END
                                              )
             -- здесь всегда Личный
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ_BankSecondDiff_num(), _tmpMI.MovementItemId
                                             , CASE WHEN _tmpMI.Num_1 = 3 THEN ROUND (_tmpMI.SummCard_1 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    WHEN _tmpMI.Num_2 = 3 THEN ROUND (_tmpMI.SummCard_2 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    WHEN _tmpMI.Num_3 = 3 THEN ROUND (_tmpMI.SummCard_3 / vbKoeff_ro, 0) * vbKoeff_ro
                                                    ELSE 0
                                               END
                                              )

             -- сохранили свойство <Карта БН (округление) - 2ф>
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecondDiff(), _tmpMI.MovementItemId
                                             ,
                                               CASE WHEN 1=0 AND (_tmpMI.SummCard_1 > 0 OR _tmpMI.SummCard_2 > 0 OR _tmpMI.SummCard_3 > 0)
                                               THEN

                                               ROUND (_tmpMI.SummCard_1 / vbKoeff_ro, 0) * vbKoeff_ro -- - _tmpMI.SummCard_1
                                             + ROUND (_tmpMI.SummCard_2 / vbKoeff_ro, 0) * vbKoeff_ro -- - _tmpMI.SummCard_2
                                             + ROUND (_tmpMI.SummCard_3 / vbKoeff_ro, 0) * vbKoeff_ro -- - _tmpMI.SummCard_3
                                             - _tmpMI.SummCardSecondRecalc

                                               ELSE
                                               ROUND (_tmpMI.SummCard_1 / vbKoeff_ro, 0) * vbKoeff_ro - _tmpMI.SummCard_1
                                             + ROUND (_tmpMI.SummCard_2 / vbKoeff_ro, 0) * vbKoeff_ro - _tmpMI.SummCard_2
                                             + ROUND (_tmpMI.SummCard_3 / vbKoeff_ro, 0) * vbKoeff_ro - _tmpMI.SummCard_3

                                             END
                                              )

     FROM
    (SELECT lpInsertUpdate_MovementItem_PersonalService_item (ioId                 := _tmpMI.MovementItemId
                                                            , inMovementId         := inMovementId
                                                            , inPersonalId         := _tmpMI.PersonalId
                                                            , inIsMain             := COALESCE (ObjectBoolean_Main.ValueData, FALSE)
                                                            , inSummService        := 0
                                                            , inSummCardRecalc     := 0
                                                            , inSummCardSecondRecalc:= CASE WHEN vbPersonalServiceListId_avance > 0 THEN 0
                                                                                            --WHEN vbUserId = 5 THEN _tmpMI.SummCardSecondRecalc
                                                                                            ELSE -- _tmpMI.SummCardSecondRecalc
                                                                                                 ROUND (_tmpMI.SummCard_1 / vbKoeff_ro, 0) * vbKoeff_ro
                                                                                               + ROUND (_tmpMI.SummCard_2 / vbKoeff_ro, 0) * vbKoeff_ro
                                                                                               + ROUND (_tmpMI.SummCard_3 / vbKoeff_ro, 0) * vbKoeff_ro
                                                                                       END
                                                            , inSummCardSecondCash := 0
                                                            , inSummAvCardSecondRecalc:= CASE --WHEN vbUserId = 5 AND vbPersonalServiceListId_avance > 0 THEN _tmpMI.SummCardSecondRecalc
                                                                                              WHEN vbPersonalServiceListId_avance > 0
                                                                                              THEN -- _tmpMI.SummCardSecondRecalc
                                                                                                   ROUND (_tmpMI.SummCard_1 / vbKoeff_ro, 0) * vbKoeff_ro
                                                                                                 + ROUND (_tmpMI.SummCard_2 / vbKoeff_ro, 0) * vbKoeff_ro
                                                                                                 + ROUND (_tmpMI.SummCard_3 / vbKoeff_ro, 0) * vbKoeff_ro
                                                                                              ELSE 0
                                                                                         END
                                                            , inSummNalogRecalc    := 0
                                                            , inSummNalogRetRecalc := 0
                                                            , inSummMinus          := 0
                                                            , inSummAdd            := 0
                                                            , inSummAddOthRecalc   := 0
                                                            , inSummHoliday        := 0
                                                            , inSummSocialIn       := 0
                                                            , inSummSocialAdd      := 0
                                                            , inSummChildRecalc    := 0
                                                            , inSummMinusExtRecalc := 0
                                                            , inSummFine           := 0
                                                            , inSummFineOthRecalc  := 0
                                                            , inSummHosp           := 0
                                                            , inSummHospOthRecalc  := 0
                                                            , inSummCompensationRecalc := 0
                                                            , inSummAuditAdd           := 0
                                                            , inSummHouseAdd           := 0
                                                            , inSummAvanceRecalc   := 0
                                                            , inNumber             := ''
                                                            , inComment            := ''
                                                            , inInfoMoneyId        := _tmpMI.InfoMoneyId
                                                            , inUnitId             := _tmpMI.UnitId
                                                            , inPositionId         := _tmpMI.PositionId
                                                            , inMemberId           := NULL
                                                            , inPersonalServiceListId := _tmpMI.PersonalServiceListId
                                                            , inFineSubjectId      := _tmpMI.FineSubjectId
                                                            , inUnitFineSubjectId  := _tmpMI.UnitId_FineSubject
                                                            , inUserId             := vbUserId
                                                             ) AS MovementItemId
            -- банк на первом месте
          , _tmpMI.BankId_1
            -- банк на втором месте
          , _tmpMI.BankId_2
            -- банк на третьем месте
          , _tmpMI.BankId_3

            -- кто из 1,2,3 на первом месте
          , _tmpMI.Num_1
            -- кто из 1,2,3 на втором месте
          , _tmpMI.Num_2
            -- кто из 1,2,3 на третьем месте
          , _tmpMI.Num_3

            -- сумма для первого места
          , _tmpMI.SummCard_1
            -- сумма для второго места
          , _tmpMI.SummCard_2
            -- сумма для третьего места
          , _tmpMI.SummCard_3

            -- сумма для третьего места
          , _tmpMI.SummCardSecondRecalc

     FROM _tmpMI
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = _tmpMI.PersonalId
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
    ) AS _tmpMI
     ;


     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                 ON MILO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                     INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILO_PersonalServiceList.ObjectId
                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                          AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                --AND MovementItem.Amount     > 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка. В распределении БН найдена ведомость <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT MILO_PersonalServiceList.ObjectId
                                                     FROM MovementItem
                                                          JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                                                      ON MILO_PersonalServiceList.MovementItemId = MovementItem.Id
                                                                                     AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                                                          INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                                                ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MILO_PersonalServiceList.ObjectId
                                                                               AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                                                               AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                                                     WHERE MovementItem.MovementId = inMovementId
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                                     --AND MovementItem.Amount     > 0
                                                     LIMIT 1
                                                    ));
     END IF;

     --для протокола чтоб понимать какую кнопку нажали если свыше 4000 = ДА обычную  = НЕТ
     -- сохранили свойство <Проверен>
     -- PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_4000(), inMovementId, FALSE);
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

/*
RAISE EXCEPTION '<%  >  %', (select count(*)
from _tmpMI where _tmpMI.MemberId = 239655)
, ( select count(*)  FROM MovementItem
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                               ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                              AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                                              AND ObjectLink_Personal_Member.ChildObjectId   = 239655
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
);
*/

-- !!!тест
-- PERFORM gpComplete_Movement_PersonalService (inMovementId:= inMovementId, inSession:= inSession);

IF vbUserId = 5 and 1=0
THEN
    RAISE EXCEPTION 'Ошибка.test=ok   %'
  , (            SELECT sum (coalesce (MIF_SummCardSecondRecalc.ValueData, 0))

            FROM MovementItem
                 LEFT JOIN MovementItemFloat AS MIF_SummCardSecondRecalc
                                             ON MIF_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                            AND MIF_SummCardSecondRecalc.DescId         = zc_MIFloat_SummCardSecondRecalc()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.isErased   = FALSE
              AND MovementItem.DescId     = zc_MI_Master()
)
;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond_num (inMovementId:= 12977959, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond_num (inMovementId:= 27700622 , inSession:= zfCalc_UserAdmin())
