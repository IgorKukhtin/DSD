-- Function: gpInsertUpdate_MovementItem_KPU()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_KPU (Integer, Integer, TFloat, Integer, Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_KPU (Integer, Integer, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_KPU(
 INOUT ioId                    Integer    , -- Ключ объекта <Докумен>
   OUT outKPU                  TFloat     , -- КПУ
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
                        AND Movement.OperDate = vbDateStart),

        tmpPlanAmount AS (SELECT
                                 Object_ReportSoldParams.UnitId                 AS UnitId,
                                 Object_ReportSoldParams.PlanAmount             AS PlanAmount
                          FROM
                               Object_ReportSoldParams_View AS Object_ReportSoldParams
                          WHERE Object_ReportSoldParams.PlanDate >= vbDateStart
                            AND Object_ReportSoldParams.PlanDate < vbEndDate
                            AND Object_ReportSoldParams.UnitId = vbUnitId),

        tmpFactAmount AS (SELECT
                                 MovementCheck.UnitId                           AS UnitID,
                                 SUM(TotalSumm)                                 AS FactAmount
                          FROM
                               Movement_Check_View AS MovementCheck
                          WHERE MovementCheck.OperDate >= vbDateStart
                            AND MovementCheck.OperDate < vbEndDate
                            AND MovementCheck.StatusId = zc_Enum_Status_Complete()
                            AND MovementCheck.UnitId = vbUnitId
                          GROUP BY  MovementCheck.UnitID)

  SELECT
          COALESCE (MIFloat_MarkRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) = COALESCE (MIFloat_BonusAmountTab.ValueData, 0)
            THEN 0 ELSE CASE WHEN COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0)
            THEN 1 ELSE -1 END END)::Integer              AS MarkRatio

        , COALESCE (MIFloat_AverageCheckRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_AverageCheck.ValueData, 0) / COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) - 1) * 100, 1)
            END)::TFloat                              AS AverageCheckRatio

        , MIFloat_LateTimeRatio.ValueData::Integer    AS LateTimeRatio

        , COALESCE (MIFloat_FinancPlanRatio.ValueData,
            CASE WHEN COALESCE (tmpPlanAmount.PlanAmount, 0) = 0 or COALESCE (tmpFactAmount.FactAmount, 0) = 0
            THEN 0 ELSE CASE WHEN tmpPlanAmount.PlanAmount <= tmpFactAmount.FactAmount THEN 1 ELSE -1 END
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

       LEFT JOIN MovementItemFloat AS MIFloat_LateTimeRatio
                                   ON MIFloat_LateTimeRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_LateTimeRatio.DescId = zc_MIFloat_LateTimeRatio()

       LEFT JOIN tmpPlanAmount ON tmpPlanAmount.UnitID = vbUnitId

       LEFT JOIN tmpFactAmount ON tmpFactAmount.UnitID = vbUnitId

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



  if (inMarkRatio > 1) OR (inMarkRatio < -1)
  THEN
    RAISE EXCEPTION 'Ошибка. Значение коэффициента должно быть в пределах от -1 до 1.';
  END IF;

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MarkRatio(), ioId, inMarkRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AverageCheckRatio(), ioId, inAverageCheckRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LateTimeRatio(), ioId, inLateTimeRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_IT_ExamRatio(), ioId, inIT_ExamRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ComplaintsRatio(), ioId, inComplaintsRatio);

  PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComplaintsNote(), ioId, inComplaintsNote);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DirectorRatio(), ioId, inDirectorRatio);

  PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DirectorNote(), ioId, inDirectorNote);

  PERFORM lpUpdate_MovementItem_KPU (ioId);

  RAISE EXCEPTION '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';

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
 05.11.18         *
 05.10.18         *
*/