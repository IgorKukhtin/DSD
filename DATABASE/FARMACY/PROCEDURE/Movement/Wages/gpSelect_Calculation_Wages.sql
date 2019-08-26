-- Function: gpSelect_Calculation_Wages()

DROP FUNCTION IF EXISTS gpSelect_Calculation_Wages (TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_Wages(
    IN inOperDate    TDateTime,     -- ���� ����������
    IN inUserID      Integer,       -- ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar, OperDate TDateTime
             , PersonalId Integer, UserId Integer
             , WorkTimeKindID Integer, WorkTimeKindCode Integer, WorkTimeKindName TVarChar, ShortName TVarChar
             , PayrollGroupID Integer, PayrollGroupCode Integer, PayrollGroupName TVarChar
             , Percent TFloat, MinAccrualAmount TFloat
             , SummCS TFloat, SummSCS TFloat, SummHS TFloat
             , IncomeCount Integer, SummIncomeCheck TFloat
             , SummaBase TFloat, SummaCalc TFloat, FormulaCalc TVarChar
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

   -- ������ ����� ������
   vbStartDate := DATE_TRUNC ('MONTH', inOperDate);
   -- ��������� ����� ������
   vbEndDate := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 second';

   CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
      SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;


   -- ��� ������ �� ����� �� ������
   CREATE TEMP TABLE tmpBoard ON COMMIT DROP AS
       SELECT MovementLinkObject_Unit.ObjectId              AS UnitId
            , Movement.OperDate                             AS OperDate
            , MI_SheetWorkTime.ObjectId                     AS PersonalId
            , ObjectLink_User_Member.ObjectId               AS UserID
            , MIObject_WorkTimeKind.ObjectId                AS WorkTimeKindID
            , ObjectLink_Goods_PayrollType.ChildObjectId    AS PayrollTypeID
            , ObjectLink_Goods_PayrollGroup.ChildObjectId   AS PayrollGroupID
       FROM tmpOperDate

            LEFT JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                              AND Movement.DescId = zc_Movement_SheetWorkTime()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            INNER JOIN MovementItem AS MI_SheetWorkTime
                                    ON MI_SheetWorkTime.MovementId = Movement.Id
                                   AND MI_SheetWorkTime.DescId = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = MI_SheetWorkTime.ObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

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
          AND Movement.OperDate  BETWEEN vbStartDate AND vbEndDate;


   -- ��� ���� �� �����
   CREATE TEMP TABLE tmpCheck ON COMMIT DROP AS
      WITH tmpCheck AS (
              SELECT DATE_TRUNC ('DAY', Movement.OperDate - INTERVAL '8 hour')              AS OperDate
                   , date_part('HOUR',  Movement.OperDate - INTERVAL '8 hour')::Integer     AS Hour
                   , MovementLinkObject_Unit.ObjectId                                       AS UnitId
                   , MovementFloat_TotalSumm.ValueData                                      AS TotalSumm
              FROM Movement

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                           ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                          AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

              WHERE Movement.OperDate BETWEEN vbStartDate + INTERVAL '8 hour' AND vbEndDate + INTERVAL '8 hour'
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()),
           tmpCheckSum AS (
               SELECT tmpCheck.OperDate
                    , tmpCheck.UnitId
                    , SUM(CASE WHEN tmpCheck.Hour < 2 OR
                                    tmpCheck.Hour >= 11 AND tmpCheck.Hour < 13 THEN tmpCheck.TotalSumm END)::TFloat AS SummCS
                    , SUM(CASE WHEN tmpCheck.Hour >= 2 AND tmpCheck.Hour < 11 THEN tmpCheck.TotalSumm END)::TFloat AS SummSCS
                    , SUM(CASE WHEN tmpCheck.Hour > 13    THEN tmpCheck.TotalSumm END)::TFloat AS SummHS
               FROM tmpCheck
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
                                AND UserDeyS.PayrollTypeID  = zc_Enum_PayrollType_WorkS();

   -- ���������� ��� �������� �� �����
   CREATE TEMP TABLE tmpIncome ON COMMIT DROP AS
      WITH tmpIncome AS (
              SELECT Movement.ID
                   , DATE_TRUNC ('DAY', Movement.OperDate)              AS OperDate
                   , MovementLinkObject_Unit.ObjectId                   AS UnitId
              FROM Movement

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()

              WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_Income()
                AND Movement.StatusId = zc_Enum_Status_Complete()),
           tmpIncomeCount AS (
               SELECT Movement.OperDate              AS OperDate
                    , Movement.UnitId                AS UnitId
                    , COUNT(*)::Integer              AS IncomeCount
               FROM tmpIncome AS Movement
               GROUP BY Movement.OperDate, Movement.UnitId
               ),
           tmpIncomeContainer AS (
               SELECT Movement.OperDate                  AS OperDate
                    , Movement.UnitId                    AS UnitId
                    , MICIncome.ContainerID              AS ContainerID
               FROM tmpIncome AS Movement

                    INNER JOIN MovementItemContainer AS MICIncome
                                                     ON MICIncome.MovementID = Movement.Id
                                                    AND MICIncome.DescId = zc_MIContainer_Count()

               ),
           tmpIncomeCheck AS (
               SELECT Movement.OperDate                  AS OperDate
                    , Movement.UnitId                    AS UnitId
                    , SUM((COALESCE(-MICCheck.Amount,0) *
                      COALESCE(MovementItemFloat_Price.ValueData,0))::NUMERIC (16, 1))::TFloat AS SummCheck
               FROM tmpIncomeContainer AS Movement

                    INNER JOIN MovementItemContainer AS MICCheck
                                                     ON MICCheck.ContainerID = Movement.ContainerID
                                                    AND MICCheck.MovementDescId = zc_Movement_Check()
                                                    AND MICCheck.DescId = zc_MIContainer_Count()
                                                    AND MICCheck.OperDate BETWEEN vbStartDate AND vbEndDate

                    INNER JOIN MovementItemFloat AS MovementItemFloat_Price
                                                 ON MovementItemFloat_Price.MovementItemId = MICCheck.MovementItemId
                                                AND MovementItemFloat_Price.DescId = zc_MIFloat_Price()

               GROUP BY Movement.OperDate, Movement.UnitId
               ),
           tmpUserDey AS (
              SELECT tmpBoard.OperDate
                   , tmpBoard.UnitId
                   , COUNT(*)::Integer         AS CountUser
              FROM tmpBoard
              WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
              GROUP BY tmpBoard.OperDate
                     , tmpBoard.UnitId)

       SELECT tmpIncomeCheck.OperDate::TDateTime
            , tmpIncomeCheck.UnitId
            , IncomeCount.IncomeCount
            , tmpIncomeCheck.SummCheck
            , UserDey.CountUser
       FROM tmpIncomeCheck

            LEFT JOIN tmpIncomeCount AS IncomeCount
                                     ON IncomeCount.OperDate       = tmpIncomeCheck.OperDate
                                    AND IncomeCount.UnitId         = tmpIncomeCheck.UnitId

            LEFT JOIN tmpUserDey AS UserDey
                                 ON UserDey.OperDate       = tmpIncomeCheck.OperDate
                                AND UserDey.UnitId         = tmpIncomeCheck.UnitId;

   RETURN QUERY
   WITH
     tmpIncomeCalc AS (  -- O� ����� ���������� ������������� ���������
       SELECT tmpBoard.UnitId
            , tmpBoard.OperDate
            , tmpBoard.PersonalId
            , tmpBoard.UserID

            , tmpBoard.WorkTimeKindID
            , tmpBoard.PayrollTypeID
            , tmpBoard.PayrollGroupID

            , Income.IncomeCount                              AS IncomeCount
            , Income.SummCheck                                AS SummCheck

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

            LEFT OUTER JOIN gpSelect_Calculation_PayrollGroup(inPayrollTypeID    := tmpBoard.PayrollTypeID,
                                                              inPercent          := Null::TFloat,
                                                              inMinAccrualAmount := Null::TFloat,
                                                              inCountUserCS      := Income.CountUser,
                                                              inCountUserAS      := Income.IncomeCount ,
                                                              inCountUserNS      := Null::Integer,
                                                              inCountUserSCS     := Null::Integer,
                                                              inCountUserS       := Null::Integer,
                                                              inSummCS           := Income.SummCheck,
                                                              inSummSCS          := Null::TFloat,
                                                              inSummHS           := Null::TFloat) AS Calculation
                                                                                                  ON 1 = 1
       WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
         AND (tmpBoard.PersonalId = inUserID OR inUserID = 0)),
     tmpIncomeMonth AS (  -- O� ����� ���������� ������������� ��������� ���� ������
       SELECT tmpIncomeCalc.UnitId
            , vbEndDate                                       AS OperDate
            , tmpIncomeCalc.PersonalId
            , tmpIncomeCalc.UserID

            , tmpIncomeCalc.WorkTimeKindID
            , tmpIncomeCalc.PayrollTypeID
            , tmpIncomeCalc.PayrollGroupID

            , SUM(tmpIncomeCalc.SummaBase)::TFloat            AS SummaBase
       FROM tmpIncomeCalc
       GROUP BY tmpIncomeCalc.UnitId, tmpIncomeCalc.PersonalId, tmpIncomeCalc.UserID
              , tmpIncomeCalc.WorkTimeKindID, tmpIncomeCalc.PayrollTypeID, tmpIncomeCalc.PayrollGroupID)


     -- �� ����� ����������� ����� �� ����
   SELECT tmpBoard.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpBoard.OperDate
        , tmpBoard.PersonalId
        , tmpBoard.UserID

        , tmpBoard.WorkTimeKindID
        , Object_WorkTimeKind.ObjectCode                  AS WorkTimeKindCode
        , Object_WorkTimeKind.ValueData                   AS WorkTimeKindName
        , ObjectString_WorkTimeKind_ShortName.ValueData   AS ShortName

        , Object_PayrollType.Id                           AS PayrollGroupID
        , Object_PayrollType.ObjectCode                   AS PayrollGroupCode
        , Object_PayrollType.ValueData                    AS PayrollGroupName

        , ObjectFloat_Percent.ValueData                   AS Percent
        , ObjectFloat_MinAccrualAmount.ValueData          AS MinAccrualAmount

        , CheckSum.SummCS
        , CheckSum.SummSCS
        , CheckSum.SummHS

        , NULL::Integer                                   AS IncomeCount
        , NULL::TFloat                                    AS SummIncomeCheck

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

        LEFT OUTER JOIN gpSelect_Calculation_PayrollGroup(inPayrollTypeID    := Object_PayrollType.Id,
                                                          inPercent          := ObjectFloat_Percent.ValueData,
                                                          inMinAccrualAmount := ObjectFloat_MinAccrualAmount.ValueData,
                                                          inCountUserCS      := CheckSum.CountUserCS,
                                                          inCountUserAS      := CheckSum.CountUserAS,
                                                          inCountUserNS      := CheckSum.CountUserNS,
                                                          inCountUserSCS     := CheckSum.CountUserSCS,
                                                          inCountUserS       := CheckSum.CountUserS,
                                                          inSummCS           := CheckSum.SummCS,
                                                          inSummSCS          := CheckSum.SummSCS,
                                                          inSummHS           := CheckSum.SummHS) AS Calculation
                                                                                                 ON 1 = 1
   WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_Check()
     AND (tmpBoard.PersonalId = inUserID OR inUserID = 0)
   UNION ALL  -- O� ����� ���������� ������������� ��������� �� ����
   SELECT tmpIncomeCalc.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpIncomeCalc.OperDate
        , tmpIncomeCalc.PersonalId
        , tmpIncomeCalc.UserID

        , tmpIncomeCalc.WorkTimeKindID
        , Object_WorkTimeKind.ObjectCode                  AS WorkTimeKindCode
        , Object_WorkTimeKind.ValueData                   AS WorkTimeKindName
        , ObjectString_WorkTimeKind_ShortName.ValueData   AS ShortName

        , Object_PayrollType.Id                           AS PayrollGroupID
        , Object_PayrollType.ObjectCode                   AS PayrollGroupCode
        , Object_PayrollType.ValueData                    AS PayrollGroupName

        , ObjectFloat_Percent.ValueData                   AS Percent
        , ObjectFloat_MinAccrualAmount.ValueData          AS MinAccrualAmount

        , NULL::TFloat                                    AS SummCS
        , NULL::TFloat                                    AS SummSCS
        , NULL::TFloat                                    AS SummHS

        , tmpIncomeCalc.IncomeCount                       AS IncomeCount
        , tmpIncomeCalc.SummCheck                         AS SummIncomeCheck

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
   UNION ALL  -- O� ����� ���������� ������������� ��������� �������� �����
   SELECT tmpIncomeMonth.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpIncomeMonth.OperDate
        , tmpIncomeMonth.PersonalId
        , tmpIncomeMonth.UserID

        , tmpIncomeMonth.WorkTimeKindID
        , Object_WorkTimeKind.ObjectCode                  AS WorkTimeKindCode
        , Object_WorkTimeKind.ValueData                   AS WorkTimeKindName
        , ObjectString_WorkTimeKind_ShortName.ValueData   AS ShortName

        , Object_PayrollType.Id                           AS PayrollGroupID
        , Object_PayrollType.ObjectCode                   AS PayrollGroupCode
        , Object_PayrollType.ValueData                    AS PayrollGroupName

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

        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = tmpIncomeMonth.PayrollTypeID

        INNER JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = tmpIncomeMonth.PayrollGroupID

        INNER JOIN ObjectFloat AS ObjectFloat_Percent
                               ON ObjectFloat_Percent.ObjectId = tmpIncomeMonth.PayrollTypeID
                              AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

        INNER JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                               ON ObjectFloat_MinAccrualAmount.ObjectId = tmpIncomeMonth.PayrollTypeID
                              AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()

        LEFT OUTER JOIN gpSelect_Calculation_PayrollGroup_Total(inPayrollTypeID    := Object_PayrollType.Id,
                                                                inPercent          := ObjectFloat_Percent.ValueData,
                                                                inMinAccrualAmount := ObjectFloat_MinAccrualAmount.ValueData,
                                                                inSummaBase        := tmpIncomeMonth.SummaBase) AS Calculation
                                                                                                                ON 1 = 1

   ;



END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.19                                                        *

*/

-- ����
-- SELECT * FROM gpSelect_Calculation_Wages (('01.08.2019')::TDateTime, 0, '3')