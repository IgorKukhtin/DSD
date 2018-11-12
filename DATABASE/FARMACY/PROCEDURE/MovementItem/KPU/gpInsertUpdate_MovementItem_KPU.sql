-- Function: gpInsertUpdate_MovementItem_KPU()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_KPU (Integer, TDateTime, Integer, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_KPU(
 INOUT ioId                    Integer    , -- Ключ объекта <Докумен>
   OUT outKPU                  TFloat     , -- КПУ
    IN inDateIn                TDateTime  , -- Дата приема
    IN inMarkRatio             Integer    , -- Коеффициент выполнение плана по маркетингу
    IN inAverageCheckRatio     TFloat     , -- Коеффициент за средний чек
    IN inLateTimeRatio         Integer,
    IN inFinancPlanRatio       Integer,
    IN inIT_ExamRatio          Integer,

    IN inComplaintsRatio       Integer,
    IN inComplaintsNote        TVarChar,

    IN inDirectorRatio         Integer,
    IN inDirectorNote          TVarChar,


    IN inYuriIT                Integer,
    IN inOlegIT                Integer,
    IN inMaximIT               Integer,
    IN inCollegeITRatio        Integer,
    IN inCollegeITNote         TVarChar,

    IN inVIPDepartRatio        Integer,
    IN inVIPDepartRatioNote    TVarChar,

    IN inRomanova              Integer,
    IN inGolovko               Integer,
    IN inControlRGRatio        Integer,
    IN inControlRGNote         TVarChar,

    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId                Integer;
   DECLARE vbUnitId                Integer;
   DECLARE vbDateStart             TDateTime;
   DECLARE vbEndDate               TDateTime;

   DECLARE vbDateIn                TDateTime;
   DECLARE vbPersonalId            Integer;

   DECLARE vbMarkRatio             Integer;
   DECLARE vbAverageCheckRatio     TFloat;
   DECLARE vbLateTimeRatio         Integer;
   DECLARE vbFinancPlanRatio       Integer;
   DECLARE vbIT_ExamRatio          Integer;

   DECLARE vbComplaintsRatio       Integer;
   DECLARE vbComplaintsNote        TVarChar;

   DECLARE vbDirectorRatio         Integer;
   DECLARE vbDirectorNote          TVarChar;


   DECLARE vbYuriIT                Integer;
   DECLARE vbOlegIT                Integer;
   DECLARE vbMaximIT               Integer;
   DECLARE vbCollegeITRatio        Integer;
   DECLARE vbCollegeITNote         TVarChar;

   DECLARE vbVIPDepartRatio        Integer;
   DECLARE vbVIPDepartRatioNote    TVarChar;

   DECLARE vbRomanova              Integer;
   DECLARE vbGolovko               Integer;
   DECLARE vbControlRGRatio        Integer;
   DECLARE vbControlRGNote         TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
    -- vbUserId := inSession;

  IF (COALESCE (ioId, 0) = 0) OR NOT EXISTS(SELECT ID FROM MovementItem WHERE MovementItem.ID = ioId)
  THEN
    RAISE EXCEPTION 'Ошибка. Номер содержимого документа должен быть заполнен или содержимое не найдено.';
  END IF;

  SELECT
    Movement.OperDate,
    MovementItem.ObjectId,
    MILinkObject_Unit.ObjectId
  INTO
    vbDateStart,
    vbUserId,
    vbUnitId
  FROM MovementItem
       INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
  WHERE MovementItem.ID = ioId;

  vbEndDate := date_trunc('month', vbDateStart) + Interval '1 MONTH';

  WITH tmpTestingUser AS (SELECT
                             MovementItem.ObjectId                                          AS UserID
                           , MovementItem.Amount::Integer                                   AS Result
                           , CASE WHEN COALESCE (MovementFloat.ValueData, 0) > 0 THEN
                             Round(MovementItem.Amount / MovementFloat.ValueData * 100, 2)
                             ELSE 0 END::TFloat                                             AS ExamPercentage
                           , MovementItemFloat.ValueData::Integer                           AS Attempts
                      FROM Movement

                           INNER JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                                   AND MovementFloat.DescId = zc_MovementFloat_TestingUser_Question()

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()

                           INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                       AND MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()

                      WHERE Movement.DescId = zc_Movement_TestingUser()
                        AND MovementItem.ObjectId = vbUserId
                        AND Movement.OperDate = vbDateStart)

  SELECT
          Object_Personal_View.DateIn
        , Object_Personal_View.PersonalId
        , COALESCE (MIFloat_MarkRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) = COALESCE (MIFloat_BonusAmountTab.ValueData, 0)
            THEN 0 ELSE CASE WHEN COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0)
            THEN 1 ELSE -1 END END)::Integer              AS MarkRatio

        , COALESCE (MIFloat_AverageCheckRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_AverageCheck.ValueData, 0) / COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) - 1) * 100, 1)
            END)::TFloat                              AS AverageCheckRatio

        , COALESCE (MIFloat_LateTimeRatio.ValueData, 
            MIFloat_LateTimePenalty.ValueData)::Integer    AS LateTimeRatio
  
        , COALESCE (MIFloat_FinancPlanRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_FinancPlan.ValueData, 0) = 0 or COALESCE (MIFloat_FinancPlanFact.ValueData, 0) = 0
            THEN 0 ELSE CASE WHEN MIFloat_FinancPlan.ValueData <= MIFloat_FinancPlanFact.ValueData THEN 1 ELSE -1 END
            END)::Integer                             AS FinancPlanRatio

        , COALESCE (MIFloat_IT_ExamRatio.ValueData::Integer,
          CASE WHEN TestingUser.ExamPercentage IS NULL
          THEN NULL ELSE
          CASE WHEN TestingUser.ExamPercentage >= 80
          THEN 4 - TestingUser.Attempts ELSE Null END END)   AS IT_ExamRatio

        , MIFloat_ComplaintsRatio.ValueData::Integer  AS ComplaintsRatio
        , MIString_ComplaintsNote.ValueData           AS ComplaintsNote

        , MIFloat_DirectorRatio.ValueData::Integer    AS DirectorRatio
        , MIString_DirectorNote.ValueData             AS DirectorNote

        , MIFloat_YuriIT.ValueData::Integer           AS YuriIT
        , MIFloat_OlegIT.ValueData::Integer           AS OlegIT
        , MIFloat_MaximIT.ValueData::Integer          AS MaximIT
        , MIFloat_CollegeITRatio.ValueData::Integer   AS CollegeITRatio
        , MIString_CollegeITNote.ValueData            AS CollegeITNote

        , MIFloat_VIPDepartRatio.ValueData::Integer   AS VIPDepartRatio
        , MIString_VIPDepartRatioNote.ValueData       AS VIPDepartRatioNote

        , MIFloat_Romanova.ValueData::Integer         AS Romanova
        , MIFloat_Golovko.ValueData::Integer          AS Golovko
        , MIFloat_ControlRGRatio.ValueData::Integer   AS ControlRGRatio
        , MIString_ControlRGNote.ValueData            AS ControlRGNote
  INTO
    vbDateIn,
    vbPersonalId,
    
    vbMarkRatio,
    vbAverageCheckRatio,
    vbLateTimeRatio,
    vbFinancPlanRatio,
    vbIT_ExamRatio,

    vbComplaintsRatio,
    vbComplaintsNote,

    vbDirectorRatio,
    vbDirectorNote,

    vbYuriIT,
    vbOlegIT,
    vbMaximIT,
    vbCollegeITRatio,
    vbCollegeITNote,

    vbVIPDepartRatio,
    vbVIPDepartRatioNote,

    vbRomanova,
    vbGolovko,
    vbControlRGRatio,
    vbControlRGNote
  FROM MovementItem

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

       LEFT JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectid

       LEFT JOIN MovementItemFloat AS MIFloat_AmountTheFineTab
                                   ON MIFloat_AmountTheFineTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_AmountTheFineTab.DescId = zc_MIFloat_AmountTheFineTab()

       LEFT JOIN MovementItemFloat AS MIFloat_BonusAmountTab
                                   ON MIFloat_BonusAmountTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_BonusAmountTab.DescId = zc_MIFloat_BonusAmountTab()

       LEFT JOIN MovementItemFloat AS MIFloat_MarkRatio
                                   ON MIFloat_MarkRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_MarkRatio.DescId = zc_MIFloat_MarkRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_PrevAverageCheck
                                   ON MIFloat_PrevAverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_PrevAverageCheck.DescId = zc_MIFloat_PrevAverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheck
                                   ON MIFloat_AverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheck.DescId = zc_MIFloat_AverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheckRatio
                                   ON MIFloat_AverageCheckRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheckRatio.DescId = zc_MIFloat_AverageCheckRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_LateTimePenalty
                                   ON MIFloat_LateTimePenalty.MovementItemId = MovementItem.Id
                                  AND MIFloat_LateTimePenalty.DescId = zc_MIFloat_LateTimePenalty()

       LEFT JOIN MovementItemFloat AS MIFloat_LateTimeRatio
                                   ON MIFloat_LateTimeRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_LateTimeRatio.DescId = zc_MIFloat_LateTimeRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlan
                                   ON MIFloat_FinancPlan.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlan.DescId = zc_MIFloat_FinancPlan()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlanFact
                                   ON MIFloat_FinancPlanFact.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlanFact.DescId = zc_MIFloat_FinancPlanFact()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlanRatio
                                   ON MIFloat_FinancPlanRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlanRatio.DescId = zc_MIFloat_FinancPlanRatio()

       LEFT JOIN tmpTestingUser AS TestingUser
                                ON TestingUser.UserId = MovementItem.ObjectId

       LEFT JOIN MovementItemFloat AS MIFloat_IT_ExamRatio
                                   ON MIFloat_IT_ExamRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_IT_ExamRatio.DescId = zc_MIFloat_IT_ExamRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_ComplaintsRatio
                                   ON MIFloat_ComplaintsRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_ComplaintsRatio.DescId = zc_MIFloat_ComplaintsRatio()

       LEFT JOIN MovementItemString AS MIString_ComplaintsNote
                                    ON MIString_ComplaintsNote.MovementItemId = MovementItem.Id
                                   AND MIString_ComplaintsNote.DescId = zc_MIString_ComplaintsNote()

       LEFT JOIN MovementItemFloat AS MIFloat_DirectorRatio
                                   ON MIFloat_DirectorRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_DirectorRatio.DescId = zc_MIFloat_DirectorRatio()

       LEFT JOIN MovementItemString AS MIString_DirectorNote
                                    ON MIString_DirectorNote.MovementItemId = MovementItem.Id
                                   AND MIString_DirectorNote.DescId = zc_MIString_DirectorNote()

       LEFT JOIN MovementItemFloat AS MIFloat_YuriIT
                                   ON MIFloat_YuriIT.MovementItemId = MovementItem.Id
                                  AND MIFloat_YuriIT.DescId = zc_MIFloat_YuriIT()

       LEFT JOIN MovementItemFloat AS MIFloat_OlegIT
                                   ON MIFloat_OlegIT.MovementItemId = MovementItem.Id
                                  AND MIFloat_OlegIT.DescId = zc_MIFloat_OlegIT()

       LEFT JOIN MovementItemFloat AS MIFloat_MaximIT
                                   ON MIFloat_MaximIT.MovementItemId = MovementItem.Id
                                  AND MIFloat_MaximIT.DescId = zc_MIFloat_MaximIT()

       LEFT JOIN MovementItemFloat AS MIFloat_CollegeITRatio
                                   ON MIFloat_CollegeITRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_CollegeITRatio.DescId = zc_MIFloat_CollegeITRatio()

       LEFT JOIN MovementItemString AS MIString_CollegeITNote
                                    ON MIString_CollegeITNote.MovementItemId = MovementItem.Id
                                   AND MIString_CollegeITNote.DescId = zc_MIString_CollegeITNote()

       LEFT JOIN MovementItemFloat AS MIFloat_VIPDepartRatio
                                   ON MIFloat_VIPDepartRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_VIPDepartRatio.DescId = zc_MIFloat_VIPDepartRatio()

       LEFT JOIN MovementItemString AS MIString_VIPDepartRatioNote
                                    ON MIString_VIPDepartRatioNote.MovementItemId = MovementItem.Id
                                   AND MIString_VIPDepartRatioNote.DescId = zc_MIString_VIPDepartRatioNote()

       LEFT JOIN MovementItemFloat AS MIFloat_Romanova
                                   ON MIFloat_Romanova.MovementItemId = MovementItem.Id
                                  AND MIFloat_Romanova.DescId = zc_MIFloat_Romanova()

       LEFT JOIN MovementItemFloat AS MIFloat_Golovko
                                   ON MIFloat_Golovko.MovementItemId = MovementItem.Id
                                  AND MIFloat_Golovko.DescId = zc_MIFloat_Golovko()

       LEFT JOIN MovementItemFloat AS MIFloat_ControlRGRatio
                                   ON MIFloat_ControlRGRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_ControlRGRatio.DescId = zc_MIFloat_ControlRGRatio()

       LEFT JOIN MovementItemString AS MIString_ControlRGNote
                                    ON MIString_ControlRGNote.MovementItemId = MovementItem.Id
                                   AND MIString_ControlRGNote.DescId = zc_MIString_ControlRGNote()

  WHERE MovementItem.Id = ioId;


  IF COALESCE (inDateIn, CURRENT_DATE::TDateTime) <> COALESCE (vbDateIn, CURRENT_DATE::TDateTime) and COALESCE (vbPersonalId, 0) <> 0
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer
    THEN
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), vbPersonalId, inDateIn);
    ELSE
      RAISE EXCEPTION 'Изменение <Дата приема> вам запрещено.';
    END IF;
  END IF;

    -- Выполнение плана по маркетингу
  IF COALESCE (inMarkRatio, 0) <> COALESCE (vbMarkRatio, 0)
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer OR
       948223 = inSession::Integer OR 758920 = inSession::Integer OR 5168766 = inSession::Integer
    THEN
      if (inMarkRatio > 1) OR (inMarkRatio < -1)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Выполнение плана по маркетингу> должно быть в пределах от -1 до 1.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MarkRatio(), ioId, inMarkRatio);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Выполнение плана по маркетингу> вам запрещено.';
    END IF;
  END IF;

    -- Средний чек
  IF COALESCE (inAverageCheckRatio, 0) <> COALESCE (vbAverageCheckRatio, 0)
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer OR
       948223 = inSession::Integer OR 758920 = inSession::Integer OR 5168766 = inSession::Integer
    THEN
      if (inAverageCheckRatio > 1) OR (inAverageCheckRatio < -1)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Средний чек> должно быть в пределах от -1 до 1.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AverageCheckRatio(), ioId, inAverageCheckRatio);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Средний чек> вам запрещено.';
    END IF;
  END IF;

    -- Время опоздания
  IF COALESCE (inLateTimeRatio, 0) <> COALESCE (vbLateTimeRatio, 0)
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer OR
       948223 = inSession::Integer OR 758920 = inSession::Integer OR 5168766 = inSession::Integer
    THEN
      if (inLateTimeRatio > 3) OR (inLateTimeRatio < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Время опоздания> должно быть в пределах от -3 до 3.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LateTimeRatio(), ioId, inLateTimeRatio);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Время опоздания> вам запрещено.';
    END IF;
  END IF;

    -- Финансовый план
  IF COALESCE (inFinancPlanRatio, 0) <> COALESCE (vbFinancPlanRatio, 0)
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer OR
       948223 = inSession::Integer OR 758920 = inSession::Integer OR 5168766 = inSession::Integer
    THEN
      if (inFinancPlanRatio > 1) OR (inFinancPlanRatio < -1)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Финансовый план> должно быть в пределах от -1 до 1.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_FinancPlanRatio(), ioId, inFinancPlanRatio);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Финансовый план> вам запрещено.';
    END IF;
  END IF;

    -- Экзамен IT
  IF COALESCE (inIT_ExamRatio, 0) <> COALESCE (vbIT_ExamRatio, 0)
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer OR
       948223 = inSession::Integer OR 758920 = inSession::Integer OR 5168766 = inSession::Integer
    THEN
      if (inIT_ExamRatio > 3) OR (inIT_ExamRatio < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Экзамен IT> должно быть в пределах от -3 до 3.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_IT_ExamRatio(), ioId, inIT_ExamRatio);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Экзамен IT> вам запрещено.';
    END IF;
  END IF;

    -- Жалобы от клиентов
  IF COALESCE (inComplaintsRatio, 0) <> COALESCE (vbComplaintsRatio, 0) OR
    COALESCE (inComplaintsNote, '') <> COALESCE (vbComplaintsNote, '')
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer OR
       948223 = inSession::Integer OR 758920 = inSession::Integer OR 5168766 = inSession::Integer
    THEN
      if (inComplaintsRatio > 3) OR (inComplaintsRatio < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Жалобы от клиентов> должно быть в пределах от -3 до 3.';
      END IF;

      IF COALESCE (inComplaintsNote, '') = ''
      THEN
        RAISE EXCEPTION 'Комментарий к коэффициенту <Жалобы от клиентов> не заполнен.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ComplaintsRatio(), ioId, inComplaintsRatio);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComplaintsNote(), ioId, inComplaintsNote);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Жалобы от клиентов> вам запрещено.';
    END IF;
  END IF;

    -- Директор
  IF COALESCE (inDirectorRatio, 0) <> COALESCE (vbDirectorRatio, 0) OR
    COALESCE (inDirectorNote, '') <> COALESCE (vbDirectorNote, '')
  THEN
    IF 948223 = inSession::Integer
    THEN
      if (inDirectorRatio > 3) OR (inDirectorRatio < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Директор> должно быть в пределах от -3 до 3.';
      END IF;

      IF COALESCE (inDirectorNote, '') = ''
      THEN
        RAISE EXCEPTION 'Комментарий к коэффициенту <Директор> не заполнен.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DirectorRatio(), ioId, inDirectorRatio);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DirectorNote(), ioId, inDirectorNote);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Директор> вам запрещено.';
    END IF;
  END IF;

    --  Коллегия IT
  IF COALESCE (inYuriIT, 0) <> COALESCE (vbYuriIT, 0)
  THEN
    IF 375661 = inSession::Integer
    THEN
      if (inYuriIT > 3) OR (inYuriIT < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Юрий IT> должно быть в пределах от -3 до 3.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_YuriIT(), ioId, inYuriIT);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Юрий IT> вам запрещено.';
    END IF;
  END IF;

  IF COALESCE (inOlegIT, 0) <> COALESCE (vbOlegIT, 0)
  THEN
    IF 4183126 = inSession::Integer
    THEN
      if (inOlegIT > 3) OR (inOlegIT < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Олег IT> должно быть в пределах от -3 до 3.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OlegIT(), ioId, inOlegIT);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Олег IT> вам запрещено.';
    END IF;
  END IF;

  IF COALESCE (inMaximIT, 0) <> COALESCE (vbMaximIT, 0)
  THEN
    IF 8001630 = inSession::Integer
    THEN
      if (inMaximIT > 3) OR (inMaximIT < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <<Максим IT> должно быть в пределах от -3 до 3.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MaximIT(), ioId, inMaximIT);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Максим IT> вам запрещено.';
    END IF;
  END IF;

  IF COALESCE (inCollegeITRatio, 0) <> COALESCE (vbCollegeITRatio, 0) OR
    COALESCE (inCollegeITNote, '') <> COALESCE (vbCollegeITNote, '')
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer
    THEN
      if (inCollegeITRatio > 3) OR (inCollegeITRatio < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Коллегия IT> должно быть в пределах от -3 до 3.';
      END IF;

      IF COALESCE (inCollegeITNote, '') = ''
      THEN
        RAISE EXCEPTION 'Комментарий к коэффициенту <Коллегия IT> не заполнен.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CollegeITRatio(), ioId, inCollegeITRatio);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CollegeITNote(), ioId, inCollegeITNote);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Коллегия IT> вам запрещено.';
    END IF;
  END IF;

    -- VIP отдел
  IF COALESCE (inVIPDepartRatio, 0) <> COALESCE (vbVIPDepartRatio, 0) OR
    COALESCE (inVIPDepartRatioNote, '') <> COALESCE (vbVIPDepartRatioNote, '')
  THEN
    IF 375661 = inSession::Integer OR 4183126 = inSession::Integer OR 8001630 = inSession::Integer
    THEN
      if (inVIPDepartRatio > 3) OR (inVIPDepartRatio < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <VIP отдел> должно быть в пределах от -3 до 3.';
      END IF;

      IF COALESCE (inVIPDepartRatioNote, '') = ''
      THEN
        RAISE EXCEPTION 'Комментарий к коэффициенту <VIP отдел> не заполнен.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_VIPDepartRatio(), ioId, inVIPDepartRatio);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_VIPDepartRatioNote(), ioId, inVIPDepartRatioNote);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <VIP отдел> вам запрещено.';
    END IF;
  END IF;

    -- Контроль Т.В. и Т.А.
  IF COALESCE (inRomanova, 0) <> COALESCE (vbRomanova, 0)
  THEN
    IF 758920 = inSession::Integer
    THEN
      if (inRomanova > 3) OR (inRomanova < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Романова Т.В.> должно быть в пределах от -3 до 3.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Romanova(), ioId, inRomanova);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Романова Т.В.> вам запрещено.';
    END IF;
  END IF;

  IF COALESCE (inGolovko, 0) <> COALESCE (vbGolovko, 0)
  THEN
    IF 5168766 = inSession::Integer
    THEN
      if (inGolovko > 3) OR (inGolovko < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Головко Т.А.> должно быть в пределах от -3 до 3.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Golovko(), ioId, inGolovko);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Головко Т.А.> вам запрещено.';
    END IF;
  END IF;

  IF COALESCE (inControlRGRatio, 0) <> COALESCE (vbControlRGRatio, 0) OR
    COALESCE (inControlRGNote, '') <> COALESCE (vbControlRGNote, '')
  THEN
    IF 758920 = inSession::Integer OR 5168766 = inSession::Integer
    THEN
      if (inControlRGRatio > 3) OR (inControlRGRatio < -3)
      THEN
        RAISE EXCEPTION 'Ошибка. Значение коэффициента <Контроль Т.В. и Т.А.> должно быть в пределах от -3 до 3.';
      END IF;

      IF COALESCE (inControlRGNote, '') = ''
      THEN
        RAISE EXCEPTION 'Комментарий к коэффициенту <Контроль Т.В. и Т.А.> не заполнен.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ControlRGRatio(), ioId, inControlRGRatio);
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ControlRGNote(), ioId, inControlRGNote);
    ELSE
      RAISE EXCEPTION 'Изменение коэффициента <Контроль Т.В. и Т.А.> вам запрещено.';
    END IF;
  END IF;

  PERFORM lpUpdate_MovementItem_KPU (ioId);

  SELECT
    Amount
  INTO
    outKPU
  FROM MovementItem
  WHERE MovementItem.ID = ioId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 12.11.18         *
 05.11.18         *
 05.10.18         *
*/