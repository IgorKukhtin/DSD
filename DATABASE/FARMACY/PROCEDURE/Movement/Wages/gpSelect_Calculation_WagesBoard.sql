-- Function: gpSelect_Calculation_WagesBoard()

DROP FUNCTION IF EXISTS gpSelect_Calculation_WagesBoard (TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_WagesBoard(
    IN inOperDate    TDateTime,     -- Дата начисления
    IN inUserID      Integer,       -- Сотрудник
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar, OperDate TDateTime
             , PersonalId Integer, UserId Integer, UnitUserId Integer
             , WorkTimeKindID Integer, WorkTimeKindCode Integer, WorkTimeKindName TVarChar, ShortName TVarChar
             , PayrollTypeID Integer, PayrollTypeCode Integer, PayrollTypeName TVarChar
             , Percent TFloat, MinAccrualAmount TFloat
             , SummCS TFloat, SummSCS TFloat, SummHS TFloat
             , IncomeCount Integer, IncomeSaleSumm TFloat
             , SummaBase TFloat, SummaCalc TFloat, FormulaCalc TVarChar
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

   -- первое число месяца
   vbStartDate := DATE_TRUNC ('MONTH', inOperDate);
   -- последнее число месяца
   vbEndDate := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 second';

   CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
      SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;


   -- все данные за месяц по табелю
   CREATE TEMP TABLE tmpBoard ON COMMIT DROP AS
       SELECT MovementLinkObject_Unit.ObjectId                                    AS UnitId
            , Movement.OperDate                                                   AS OperDate
            , MI_SheetWorkTime.ObjectId                                           AS PersonalId
            , ObjectLink_User_Member.ObjectId                                     AS UserID
            , MIObject_WorkTimeKind.ObjectId                                      AS WorkTimeKindID
            , ObjectLink_Goods_PayrollType.ChildObjectId                          AS PayrollTypeID
            , ObjectLink_Goods_PayrollGroup.ChildObjectId                         AS PayrollGroupID
            , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, FALSE)::Boolean  AS isManagerPharmacy
            , ObjectLink_Personal_Unit.ChildObjectId                              AS UnitUserId
       FROM tmpOperDate

            LEFT JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                              AND Movement.DescId = zc_Movement_SheetWorkTime()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            INNER JOIN MovementItem AS MI_SheetWorkTime
                                    ON MI_SheetWorkTime.MovementId = Movement.Id
                                   AND MI_SheetWorkTime.DescId = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = MI_SheetWorkTime.ObjectId
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = MI_SheetWorkTime.ObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                    ON ObjectBoolean_ManagerPharmacy.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                   AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_User_Member.ObjectId 

            LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                             ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                            AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PayrollType
                                 ON ObjectLink_Goods_PayrollType.ObjectId = MIObject_WorkTimeKind.ObjectId
                                AND ObjectLink_Goods_PayrollType.DescId = zc_ObjectLink_WorkTimeKind_PayrollType()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PayrollGroup
                                 ON ObjectLink_Goods_PayrollGroup.ObjectId = ObjectLink_Goods_PayrollType.ChildObjectId
                                AND ObjectLink_Goods_PayrollGroup.DescId = zc_ObjectLink_PayrollType_PayrollGroup()

       WHERE Movement.DescId = zc_Movement_SheetWorkTime()
          AND COALESCE (Object_User.isErased, FALSE) = False
          AND Movement.OperDate  BETWEEN vbStartDate AND vbEndDate;


   -- все чеки за месяц
   CREATE TEMP TABLE tmpCheck ON COMMIT DROP AS
      WITH tmpCheck1 AS (
              SELECT DATE_TRUNC ('DAY', Movement.OperDate)                                   AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                        AS UnitId
                   , CASE WHEN Movement.OperDate::Time >= '10:00'::Time
                           AND Movement.OperDate::Time < '19:01'::Time THEN 2 ELSE 1 END     AS Change
                   , MovementFloat_TotalSumm.ValueData                                       AS TotalSumm
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId <> 377606

                   INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                            ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

              WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()),
           tmpCheck2 AS (
              SELECT DATE_TRUNC ('DAY', Movement.OperDate - INTERVAL '8 hour')                 AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                          AS UnitId
                   , CASE WHEN (Movement.OperDate - INTERVAL '8 hour')::Time > '13:00'::Time
                          THEN 3 ELSE
                     CASE WHEN (Movement.OperDate - INTERVAL '8 hour')::Time >= '02:00'::Time
                           AND (Movement.OperDate - INTERVAL '8 hour')::Time < '11:01'::Time
                          THEN 2 ELSE 1 END END                                                AS Change
                   , MovementFloat_TotalSumm.ValueData                                         AS TotalSumm
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId = 377606

                   INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                            ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

              WHERE Movement.OperDate BETWEEN vbStartDate + INTERVAL '8 hour' AND vbEndDate + INTERVAL '8 hour'
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()),
           tmpCheckSum AS (
               SELECT tmpCheck.OperDate
                    , tmpCheck.UnitId
                    , SUM(CASE WHEN tmpCheck.Change = 1 THEN tmpCheck.TotalSumm END)::TFloat   AS SummCS
                    , SUM(CASE WHEN tmpCheck.Change = 2 THEN tmpCheck.TotalSumm END)::TFloat   AS SummSCS
                    , SUM(CASE WHEN tmpCheck.Change = 3  THEN tmpCheck.TotalSumm END)::TFloat  AS SummHS
               FROM tmpCheck1 AS tmpCheck
               GROUP BY tmpCheck.OperDate
                      , tmpCheck.UnitId
               UNION ALL
               SELECT tmpCheck.OperDate
                    , tmpCheck.UnitId
                    , SUM(CASE WHEN tmpCheck.Change = 1 THEN tmpCheck.TotalSumm END)::TFloat   AS SummCS
                    , SUM(CASE WHEN tmpCheck.Change = 2 THEN tmpCheck.TotalSumm END)::TFloat   AS SummSCS
                    , SUM(CASE WHEN tmpCheck.Change = 3  THEN tmpCheck.TotalSumm END)::TFloat  AS SummHS
               FROM tmpCheck2 AS tmpCheck
               GROUP BY tmpCheck.OperDate
                      , tmpCheck.UnitId),
           tmpUserDey AS (
              SELECT tmpBoard.OperDate
                   , tmpBoard.UnitId
                   , tmpBoard.PayrollTypeID
                   , COUNT(*)::Integer         AS CountUser
              FROM tmpBoard
              WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_Check()
              GROUP BY tmpBoard.OperDate
                     , tmpBoard.UnitId
                     , tmpBoard.PayrollTypeID)


       SELECT tmpCheckSum.OperDate::TDateTime
            , tmpCheckSum.UnitId
            , tmpCheckSum.SummCS
            , tmpCheckSum.SummSCS
            , tmpCheckSum.SummHS
            , UserDeyCS.CountUser     AS CountUserCS
            , UserDeyAS.CountUser     AS CountUserAS
            , UserDeyNS.CountUser     AS CountUserNS
            , UserDeySCS.CountUser    AS CountUserSCS
            , UserDeyS.CountUser      AS CountUserS
            , UserDeyS.CountUser      AS CountUserSAS
       FROM tmpCheckSum

            LEFT JOIN tmpUserDey AS UserDeyCS
                                 ON UserDeyCS.OperDate       = tmpCheckSum.OperDate
                                AND UserDeyCS.UnitId         = tmpCheckSum.UnitId
                                AND UserDeyCS.PayrollTypeID  = zc_Enum_PayrollType_WorkCS()

            LEFT JOIN tmpUserDey AS UserDeyAS
                                 ON UserDeyAS.OperDate       = tmpCheckSum.OperDate
                                AND UserDeyAS.UnitId         = tmpCheckSum.UnitId
                                AND UserDeyAS.PayrollTypeID  = zc_Enum_PayrollType_WorkAS()

            LEFT JOIN tmpUserDey AS UserDeyNS
                                 ON UserDeyNS.OperDate       = tmpCheckSum.OperDate
                                AND UserDeyNS.UnitId         = tmpCheckSum.UnitId
                                AND UserDeyNS.PayrollTypeID  = zc_Enum_PayrollType_WorkNS()

            LEFT JOIN tmpUserDey AS UserDeySCS
                                 ON UserDeySCS.OperDate       = tmpCheckSum.OperDate
                                AND UserDeySCS.UnitId         = tmpCheckSum.UnitId
                                AND UserDeySCS.PayrollTypeID  = zc_Enum_PayrollType_WorkSCS()

            LEFT JOIN tmpUserDey AS UserDeyS
                                 ON UserDeyS.OperDate       = tmpCheckSum.OperDate
                                AND UserDeyS.UnitId         = tmpCheckSum.UnitId
                                AND UserDeyS.PayrollTypeID  = zc_Enum_PayrollType_WorkS()

            LEFT JOIN tmpUserDey AS UserDeySAS
                                 ON UserDeySAS.OperDate       = tmpCheckSum.OperDate
                                AND UserDeySAS.UnitId         = tmpCheckSum.UnitId
                                AND UserDeySAS.PayrollTypeID  = zc_Enum_PayrollType_WorkSAS();

   -- реализация про приходам за месяц
   CREATE TEMP TABLE tmpIncome ON COMMIT DROP AS
      WITH tmpIncome AS (
              SELECT DATE_TRUNC ('DAY', MovementDate_Branch.ValueData)                AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                 AS UnitId
                   , SUM(COALESCE(MovementFloat_TotalSummSale.ValueData, 0))::TFloat  AS SaleSumm
                   , COUNT(*)::Integer                                                AS IncomeCount
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()


                   INNER JOIN MovementDate AS MovementDate_Branch
                                           ON MovementDate_Branch.MovementId = Movement.Id
                                          AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                   LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                           ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                          AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

              WHERE MovementDate_Branch.ValueData BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_Income()
                AND Movement.StatusId = zc_Enum_Status_Complete()
              GROUP BY DATE_TRUNC ('DAY', MovementDate_Branch.ValueData), MovementLinkObject_Unit.ObjectId),
           tmpUserDey AS (
              SELECT tmpBoard.OperDate
                   , tmpBoard.UnitId
                   , COUNT(*)::Integer         AS CountUser
              FROM tmpBoard
              WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
              GROUP BY tmpBoard.OperDate
                     , tmpBoard.UnitId)

       SELECT tmpIncome.OperDate::TDateTime
            , tmpIncome.UnitId
            , tmpIncome.IncomeCount
            , tmpIncome.SaleSumm
            , UserDey.CountUser
       FROM tmpIncome

            LEFT OUTER JOIN tmpUserDey AS UserDey
                                       ON UserDey.OperDate       = tmpIncome.OperDate
                                      AND UserDey.UnitId         = tmpIncome.UnitId;

   IF EXISTS(SELECT 1 FROM tmpBoard
             WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
             GROUP BY tmpBoard.UnitId, tmpBoard.PersonalId, tmpBoard.UserID
                    , tmpBoard.WorkTimeKindID, tmpBoard.PayrollTypeID, tmpBoard.PayrollGroupID
                    , tmpBoard.isManagerPharmacy, tmpBoard.UnitUserId
             HAVING count(*) >= 18)
   THEN
     WITH
       tmpBoardUserAll AS (
             SELECT tmpBoard.UnitId
                  , tmpBoard.PersonalId
                  , tmpBoard.UserID
                  , tmpBoard.WorkTimeKindID
                  , tmpBoard.PayrollTypeID
                  , tmpBoard.PayrollGroupID
                  , tmpBoard.isManagerPharmacy
                  , tmpBoard.UnitUserId
             FROM tmpBoard
             WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
             GROUP BY tmpBoard.UnitId, tmpBoard.PersonalId, tmpBoard.UserID
                    , tmpBoard.WorkTimeKindID, tmpBoard.PayrollTypeID, tmpBoard.PayrollGroupID
                    , tmpBoard.isManagerPharmacy, tmpBoard.UnitUserId
             HAVING count(*) >= 18),
       tmpBoardUser AS (
             SELECT tmpBoardUserAll.*, tmpIncome.OperDate
             FROM tmpBoardUserAll

                  INNER JOIN tmpIncome ON tmpIncome.UnitID = tmpBoardUserAll.UnitID

                  LEFT OUTER JOIN tmpBoard ON tmpBoard.UnitID = tmpBoardUserAll.UnitID
                                          AND tmpBoard.UserID = tmpBoardUserAll.UserID
                                          AND tmpBoard.OperDate = tmpIncome.OperDate
                                          AND tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()

             WHERE COALESCE (tmpBoard.UserID, 0) = 0)

       INSERT INTO tmpBoard
       SELECT tmpBoardUser.UnitId
            , tmpBoardUser.OperDate
            , tmpBoardUser.PersonalId
            , tmpBoardUser.UserID
            , tmpBoardUser.WorkTimeKindID
            , tmpBoardUser.PayrollTypeID
            , tmpBoardUser.PayrollGroupID
            , tmpBoardUser.isManagerPharmacy
            , tmpBoardUser.UnitUserId
       FROM tmpBoardUser;

       UPDATE tmpIncome SET CountUser = UserDey.NewCountUser
       FROM (SELECT tmpBoard.OperDate
                  , tmpBoard.UnitId
                  , COUNT(*)::Integer         AS NewCountUser
             FROM tmpBoard
             WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
             GROUP BY tmpBoard.OperDate
                    , tmpBoard.UnitId) AS UserDey
       WHERE UserDey.OperDate = tmpIncome.OperDate
         AND UserDey.UnitId   = tmpIncome.UnitId;
   END IF;

   RETURN QUERY
   WITH
     tmpIncomeCalc AS (  -- Oт суммы реализации оприходоанных накладных
       SELECT tmpBoard.UnitId
            , tmpBoard.OperDate
            , tmpBoard.PersonalId
            , tmpBoard.UserID
            , tmpBoard.UnitUserId

            , tmpBoard.WorkTimeKindID
            , tmpBoard.PayrollTypeID
            , tmpBoard.PayrollGroupID

            , Income.IncomeCount                              AS IncomeCount
            , Income.SaleSumm                                 AS SaleSumm

            , Calculation.SummaBase                           AS SummaBase
            , Calculation.Summa                               AS SummaCalc
            , Calculation.Formula                             AS FormulaCalc
       FROM tmpBoard

            INNER JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpBoard.WorkTimeKindID
            INNER JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                             ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpBoard.WorkTimeKindID
                                            AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()

            LEFT OUTER JOIN tmpIncome AS Income
                                      ON Income.OperDate  = tmpBoard.OperDate
                                     AND Income.UnitId    = tmpBoard.UnitId

            LEFT OUTER JOIN gpSelect_Calculation_PayrollGroupBoard(inPayrollTypeID    := tmpBoard.PayrollTypeID,
                                                                   inPercent          := Null::TFloat,
                                                                   inMinAccrualAmount := Null::TFloat,
                                                                   inCountUserCS      := Income.CountUser,
                                                                   inCountUserAS      := Income.IncomeCount ,
                                                                   inCountUserNS      := Null::Integer,
                                                                   inCountUserSCS     := Null::Integer,
                                                                   inCountUserS       := Null::Integer,
                                                                   inCountUserSAS     := Null::Integer,
                                                                   inSummCS           := Income.SaleSumm,
                                                                   inSummSCS          := Null::TFloat,
                                                                   inSummHS           := Null::TFloat) AS Calculation
                                                                                                  ON 1 = 1
       WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
         AND (tmpBoard.PersonalId = inUserID OR inUserID = 0)),
     tmpIncomeMonth AS (  -- Oт суммы реализации оприходоанных накладных база месяца
       SELECT tmpIncomeCalc.UnitId
            , vbEndDate                                       AS OperDate
            , tmpIncomeCalc.PersonalId
            , tmpIncomeCalc.UserID
            , tmpIncomeCalc.UnitUserId

            , tmpIncomeCalc.WorkTimeKindID
            , tmpIncomeCalc.PayrollTypeID
            , tmpIncomeCalc.PayrollGroupID

            , SUM(tmpIncomeCalc.SummaBase)::TFloat            AS SummaBase
       FROM tmpIncomeCalc
       GROUP BY tmpIncomeCalc.UnitId, tmpIncomeCalc.PersonalId, tmpIncomeCalc.UserID, tmpIncomeCalc.UnitUserId
              , tmpIncomeCalc.WorkTimeKindID, tmpIncomeCalc.PayrollTypeID, tmpIncomeCalc.PayrollGroupID),
     tmpCountShifts AS (SELECT tmpBoard.PersonalId
                            , count(*)::Integer      AS CountShift
                        FROM tmpBoard
                        GROUP BY tmpBoard.PersonalId),
     tmpManagerPharmacy AS (  -- Заведующие аптекой
       SELECT ROW_NUMBER() OVER (PARTITION BY tmpBoard.UserID ORDER BY tmpBoard.PersonalId DESC) AS Ord
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, tmpBoard.UnitId) AS UnitId
            , vbEndDate                                                       AS OperDate
            , tmpBoard.PersonalId
            , tmpBoard.UserID
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, tmpBoard.UnitId) AS UnitUserId

            , tmpBoard.WorkTimeKindID
            , 1000::TFloat                                                    AS SummaCalc
            , 'Доплата заведующим аптекой: 1000.00'::TVarChar                 AS FormulaCalc
       FROM (SELECT tmpBoard.UnitId
                  , tmpBoard.PersonalId
                  , tmpBoard.UserID
                  , tmpBoard.UnitUserId
                  , tmpBoard.WorkTimeKindID
             FROM tmpBoard
             WHERE tmpBoard.isManagerPharmacy = TRUE
               AND tmpBoard.UnitId = tmpBoard.UnitUserId   
               AND (tmpBoard.PersonalId = inUserID OR inUserID = 0)
             GROUP BY tmpBoard.UnitId
                    , tmpBoard.PersonalId
                    , tmpBoard.UserID
                    , tmpBoard.UnitUserId
                    , tmpBoard.WorkTimeKindID) tmpBoard

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId =  tmpBoard.UserID
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                               ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                              AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit())


     -- От суммы проведенных чеков по дням
   SELECT tmpBoard.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpBoard.OperDate
        , tmpBoard.PersonalId
        , tmpBoard.UserID
        , tmpBoard.UnitUserId

        , tmpBoard.WorkTimeKindID
        , Object_WorkTimeKind.ObjectCode                  AS WorkTimeKindCode
        , Object_WorkTimeKind.ValueData                   AS WorkTimeKindName
        , ObjectString_WorkTimeKind_ShortName.ValueData   AS ShortName

        , Object_PayrollType.Id                           AS PayrollTypeID
        , Object_PayrollType.ObjectCode                   AS PayrollTypeCode
        , Object_PayrollType.ValueData                    AS PayrollTypeName

        , ObjectFloat_Percent.ValueData                   AS Percent
        , ObjectFloat_MinAccrualAmount.ValueData          AS MinAccrualAmount

        , CheckSum.SummCS
        , CheckSum.SummSCS
        , CheckSum.SummHS

        , NULL::Integer                                   AS IncomeCount
        , NULL::TFloat                                    AS IncomeSaleSumm

        , Calculation.SummaBase                           AS SummaBase
        , Calculation.Summa                               AS SummaCalc
        , Calculation.Formula                             AS FormulaCalc
   FROM tmpBoard

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpBoard.UnitId

        INNER JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpBoard.WorkTimeKindID
        INNER JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                         ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpBoard.WorkTimeKindID
                                        AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()

        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = tmpBoard.PayrollTypeID

        INNER JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = tmpBoard.PayrollGroupID

        INNER JOIN ObjectFloat AS ObjectFloat_Percent
                               ON ObjectFloat_Percent.ObjectId = tmpBoard.PayrollTypeID
                              AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

        INNER JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                               ON ObjectFloat_MinAccrualAmount.ObjectId = tmpBoard.PayrollTypeID
                              AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()

        LEFT OUTER JOIN tmpCheck AS CheckSum
                                 ON CheckSum.OperDate  = tmpBoard.OperDate
                                AND CheckSum.UnitId    = tmpBoard.UnitId

        LEFT OUTER JOIN gpSelect_Calculation_PayrollGroupBoard(inPayrollTypeID    := Object_PayrollType.Id,
                                                               inPercent          := ObjectFloat_Percent.ValueData,
                                                               inMinAccrualAmount := ObjectFloat_MinAccrualAmount.ValueData,
                                                               inCountUserCS      := CheckSum.CountUserCS,
                                                               inCountUserAS      := CheckSum.CountUserAS,
                                                               inCountUserNS      := CheckSum.CountUserNS,
                                                               inCountUserSCS     := CheckSum.CountUserSCS,
                                                               inCountUserS       := CheckSum.CountUserS,
                                                               inCountUserSAS       := CheckSum.CountUserS,
                                                               inSummCS           := CheckSum.SummCS,
                                                               inSummSCS          := CheckSum.SummSCS,
                                                               inSummHS           := CheckSum.SummHS) AS Calculation
                                                                                                      ON 1 = 1
   WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_Check()
     AND (tmpBoard.PersonalId = inUserID OR inUserID = 0)
   UNION ALL  -- Oт суммы реализации оприходоанных накладных по дням
   SELECT tmpIncomeCalc.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpIncomeCalc.OperDate
        , tmpIncomeCalc.PersonalId
        , tmpIncomeCalc.UserID
        , tmpIncomeCalc.UnitUserId

        , tmpIncomeCalc.WorkTimeKindID
        , Object_WorkTimeKind.ObjectCode                  AS WorkTimeKindCode
        , Object_WorkTimeKind.ValueData                   AS WorkTimeKindName
        , ObjectString_WorkTimeKind_ShortName.ValueData   AS ShortName

        , Object_PayrollType.Id                           AS PayrollTypeID
        , Object_PayrollType.ObjectCode                   AS PayrollTypeCode
        , Object_PayrollType.ValueData                    AS PayrollTypeName

        , ObjectFloat_Percent.ValueData                   AS Percent
        , ObjectFloat_MinAccrualAmount.ValueData          AS MinAccrualAmount

        , NULL::TFloat                                    AS SummCS
        , NULL::TFloat                                    AS SummSCS
        , NULL::TFloat                                    AS SummHS

        , tmpIncomeCalc.IncomeCount                       AS IncomeCount
        , tmpIncomeCalc.SaleSumm                          AS IncomeSaleSumm

        , tmpIncomeCalc.SummaBase                         AS SummaBase
        , tmpIncomeCalc.SummaCalc                         AS SummaCalc
        , tmpIncomeCalc.FormulaCalc                       AS FormulaCalc
   FROM tmpIncomeCalc

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpIncomeCalc.UnitId

        INNER JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpIncomeCalc.WorkTimeKindID
        INNER JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                         ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpIncomeCalc.WorkTimeKindID
                                        AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()

        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = tmpIncomeCalc.PayrollTypeID

        INNER JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = tmpIncomeCalc.PayrollGroupID

        INNER JOIN ObjectFloat AS ObjectFloat_Percent
                               ON ObjectFloat_Percent.ObjectId = tmpIncomeCalc.PayrollTypeID
                              AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

        INNER JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                               ON ObjectFloat_MinAccrualAmount.ObjectId = tmpIncomeCalc.PayrollTypeID
                              AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()
   UNION ALL  -- Oт суммы реализации оприходоанных накладных месячные итоги
   SELECT tmpIncomeMonth.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpIncomeMonth.OperDate
        , tmpIncomeMonth.PersonalId
        , tmpIncomeMonth.UserID
        , tmpIncomeMonth.UnitUserId

        , tmpIncomeMonth.WorkTimeKindID
        , Object_WorkTimeKind.ObjectCode                  AS WorkTimeKindCode
        , Object_WorkTimeKind.ValueData                   AS WorkTimeKindName
        , ObjectString_WorkTimeKind_ShortName.ValueData   AS ShortName

        , Object_PayrollType.Id                           AS PayrollTypeID
        , Object_PayrollType.ObjectCode                   AS PayrollTypeCode
        , Object_PayrollType.ValueData                    AS PayrollTypeName

        , ObjectFloat_Percent.ValueData                   AS Percent
        , ObjectFloat_MinAccrualAmount.ValueData          AS MinAccrualAmount

        , NULL::TFloat                                    AS SummCS
        , NULL::TFloat                                    AS SummSCS
        , NULL::TFloat                                    AS SummHS

        , NULL::Integer                                   AS IncomeCount
        , tmpIncomeMonth.SummaBase                        AS SummaCalc

        , Calculation.SummaBase                           AS SummaBase
        , Calculation.Summa                               AS SummaCalc
        , Calculation.Formula                             AS FormulaCalc
   FROM tmpIncomeMonth

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpIncomeMonth.UnitId

        INNER JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpIncomeMonth.WorkTimeKindID
        INNER JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                         ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpIncomeMonth.WorkTimeKindID
                                        AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                                        
        INNER JOIN tmpCountShifts AS CountShifts
                                  ON CountShifts.PersonalId = tmpIncomeMonth.PersonalId

        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = tmpIncomeMonth.PayrollTypeID

        INNER JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = tmpIncomeMonth.PayrollGroupID

        INNER JOIN ObjectFloat AS ObjectFloat_Percent
                               ON ObjectFloat_Percent.ObjectId = tmpIncomeMonth.PayrollTypeID
                              AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

        INNER JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                               ON ObjectFloat_MinAccrualAmount.ObjectId = tmpIncomeMonth.PayrollTypeID
                              AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()

        LEFT OUTER JOIN gpSelect_Calculation_PayrollGroup_Total(inPayrollTypeID    := Object_PayrollType.Id,
                                                                inPercent          := 0.45,
                                                                inMinAccrualAmount := 7000,
                                                                inSummaBase        := tmpIncomeMonth.SummaBase,
                                                                inCountShift       := CountShifts.CountShift) AS Calculation
                                                                                                                ON 1 = 1
   UNION ALL
     -- Доплаты заведующим аптекой
   SELECT tmpManagerPharmacy.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpManagerPharmacy.OperDate
        , tmpManagerPharmacy.PersonalId
        , tmpManagerPharmacy.UserID
        , tmpManagerPharmacy.UnitUserId

        , tmpManagerPharmacy.WorkTimeKindID
        , Object_WorkTimeKind.ObjectCode                  AS WorkTimeKindCode
        , Object_WorkTimeKind.ValueData                   AS WorkTimeKindName
        , ObjectString_WorkTimeKind_ShortName.ValueData   AS ShortName

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , NULL::TFloat                                    AS SummCS
        , NULL::TFloat                                    AS SummSCS
        , NULL::TFloat                                    AS SummHS

        , NULL::Integer                                   AS IncomeCount
        , NULL::TFloat                                    AS IncomeSaleSumm

        , 0::TFloat                                       AS SummaBase
        , 1000::TFloat                                    AS SummaCalc
        , 'Доплата заведующим аптекой: 1000.00'::TVarChar AS FormulaCalc
   FROM tmpManagerPharmacy

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpManagerPharmacy.UnitId

        INNER JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpManagerPharmacy.WorkTimeKindID
        INNER JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpManagerPharmacy.WorkTimeKindID
                               AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
   WHERE tmpManagerPharmacy.Ord = 1

   ;



END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                        *
 22.08.19                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Calculation_WagesBoard (('01.08.2019')::TDateTime, 0, '3')