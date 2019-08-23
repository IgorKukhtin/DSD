-- Function: gpSelect_Calculation_Wages()

DROP FUNCTION IF EXISTS gpSelect_Calculation_Wages (TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_Wages(
    IN inOperDate    TDateTime,     -- Дата начисления
    IN inUserID      Integer,       -- Сотрудник
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar, OperDate TDateTime
             , PersonalId Integer
             , WorkTimeKindID Integer, WorkTimeKindCode Integer, WorkTimeKindName TVarChar, ShortName TVarChar
             , PayrollGroupID Integer, PayrollGroupCode Integer, PayrollGroupName TVarChar
             , Percent TFloat, MinAccrualAmount TFloat
             , SummCS TFloat, SummSCS TFloat, SummHS TFloat
             , SummaCalc TFloat, FormulaCalc TVarChar
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
   vbEndDate := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

   CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
      SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;


   -- все данные за месяц по табелю
   CREATE TEMP TABLE tmpBoard ON COMMIT DROP AS
       SELECT MovementLinkObject_Unit.ObjectId              AS UnitId
            , Movement.OperDate                             AS OperDate
            , MI_SheetWorkTime.ObjectId                     AS PersonalId
            , ObjectLink_User_Member.ObjectId               AS UserID
            , MIObject_WorkTimeKind.ObjectId                AS WorkTimeKindID
            , ObjectLink_Goods_PayrollType.ChildObjectId    AS PayrollTypeID
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

       WHERE Movement.DescId = zc_Movement_SheetWorkTime()
          AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate;

   -- все данные за месяц по табелю
   CREATE TEMP TABLE tmpCheck ON COMMIT DROP AS
      WITH tmpCheck AS (
              SELECT DATE_TRUNC ('DAY', Movement.OperDate)              AS OperDate
                   , date_part('HOUR',  Movement.OperDate)::Integer     AS Hour
                   , MovementLinkObject_Unit.ObjectId                   AS UnitId
                   , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
              FROM Movement

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                           ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                          AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

              WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()),
           tmpCheckSum AS (
               SELECT tmpCheck.OperDate
                    , tmpCheck.UnitId
                    , SUM(CASE WHEN tmpCheck.Hour >= 8 AND tmpCheck.Hour < 10 OR
                                    tmpCheck.Hour >= 19 AND tmpCheck.Hour < 21 THEN tmpCheck.TotalSumm END)::TFloat AS SummCS
                    , SUM(CASE WHEN tmpCheck.Hour >= 10 AND tmpCheck.Hour < 19 THEN tmpCheck.TotalSumm END)::TFloat AS SummSCS
                    , SUM(CASE WHEN tmpCheck.Hour < 8 OR tmpCheck.Hour > 21    THEN tmpCheck.TotalSumm END)::TFloat AS SummHS
               FROM tmpCheck
               GROUP BY tmpCheck.OperDate
                      , tmpCheck.UnitId),
           tmpUserDey AS (
              SELECT tmpBoard.OperDate
                   , tmpBoard.UnitId
                   , tmpBoard.PayrollTypeID
                   , COUNT(*)::Integer         AS CountUser
              FROM tmpBoard
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

   RETURN QUERY
   SELECT tmpBoard.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpBoard.OperDate
        , tmpBoard.PersonalId

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

        , Calculation.Summa                               AS SummaCalc
        , Calculation.Formula                             AS FormulaCalc
   FROM tmpBoard

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpBoard.UnitId

        INNER JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpBoard.WorkTimeKindID
        INNER JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName
                                         ON ObjectString_WorkTimeKind_ShortName.ObjectId = tmpBoard.WorkTimeKindID
                                        AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()

        INNER JOIN ObjectLink AS ObjectLink_Goods_PayrollType
                              ON ObjectLink_Goods_PayrollType.ObjectId = tmpBoard.WorkTimeKindID
                             AND ObjectLink_Goods_PayrollType.DescId = zc_ObjectLink_WorkTimeKind_PayrollType()
        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = ObjectLink_Goods_PayrollType.ChildObjectId

        INNER JOIN ObjectLink AS ObjectLink_Goods_PayrollGroup
                              ON ObjectLink_Goods_PayrollGroup.ObjectId = ObjectLink_Goods_PayrollType.ChildObjectId
                             AND ObjectLink_Goods_PayrollGroup.DescId = zc_ObjectLink_PayrollType_PayrollGroup()
        INNER JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = ObjectLink_Goods_PayrollGroup.ChildObjectId

        INNER JOIN ObjectFloat AS ObjectFloat_Percent
                               ON ObjectFloat_Percent.ObjectId = ObjectLink_Goods_PayrollType.ChildObjectId
                              AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

        INNER JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                               ON ObjectFloat_MinAccrualAmount.ObjectId = ObjectLink_Goods_PayrollType.ChildObjectId
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
   WHERE (tmpBoard.PersonalId = inUserID OR inUserID = 0) 
   ;



END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.08.19                                                        *

*/

-- тест
--
SELECT * FROM gpSelect_Calculation_Wages (('01.08.2019')::TDateTime, 0, '3')