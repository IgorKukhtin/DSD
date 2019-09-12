-- Function: gpSelect_Calculation_Wages()

DROP FUNCTION IF EXISTS gpSelect_Calculation_Wages (TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_Wages(
    IN inOperDate    TDateTime,     -- Дата начисления
    IN inUserID      Integer,       -- Сотрудник
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar, OperDate TDateTime
             , UserId Integer, UnitUserId Integer
             , PayrollTypeID Integer, PayrollTypeCode Integer, PayrollTypeName TVarChar, ShortName TVarChar
             , Percent TFloat, MinAccrualAmount TFloat
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


   -- все данные за месяц по графикам
   CREATE TEMP TABLE tmpBoard ON COMMIT DROP AS
       SELECT
              MIMaster.ObjectId                                                              AS UserID
            , ObjectLink_User_Member.ChildObjectId                                           AS MemberId
            , COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId)     AS UnitUserId

            , (Movement.OperDate + ((MIChild.Amount - 1)::TVarChar||' DAY')::INTERVAL)::TDateTime AS OperDate
            , MIChild.ObjectId                                                               AS UnitId
            , MILinkObject_PayrollType.ObjectId                                              AS PayrollTypeID
            , ObjectLink_Goods_PayrollGroup.ChildObjectId                                    AS PayrollGroupID
            , MIDate_Start.ValueData                                                         AS DateStart
            , MIDate_End.ValueData                                                           AS DateEnd
            , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, FALSE)::Boolean             AS isManagerPharmacy
       FROM Movement


            INNER JOIN MovementItem AS MIMaster
                                    ON MIMaster.MovementId = Movement.id
                                   AND MIMaster.isErased = False
                                   AND MIMaster.DescId = zc_MI_Master()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MIMaster.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MIMaster.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                    ON ObjectBoolean_ManagerPharmacy.ObjectId = ObjectLink_User_Member.ChildObjectId
                                   AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()

            LEFT JOIN MovementItem AS MIChild
                                   ON MIChild.MovementId = Movement.id
                                  AND MIChild.ParentId = MIMaster.ID
                                  AND MIChild.isErased = False
                                  AND MIChild.DescId = zc_MI_Child()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                             ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                            AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PayrollGroup
                                 ON ObjectLink_Goods_PayrollGroup.ObjectId = MILinkObject_PayrollType.ObjectId
                                AND ObjectLink_Goods_PayrollGroup.DescId = zc_ObjectLink_PayrollType_PayrollGroup()

            LEFT JOIN MovementItemDate AS MIDate_Start
                                       ON MIDate_Start.MovementItemId = MIChild.Id
                                      AND MIDate_Start.DescId = zc_MIDate_Start()

            LEFT JOIN MovementItemDate AS MIDate_End
                                       ON MIDate_End.MovementItemId = MIChild.Id
                                      AND MIDate_End.DescId = zc_MIDate_End()

       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
          AND Movement.StatusId <> zc_Enum_Status_Erased()
          AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
          AND COALESCE(MILinkObject_PayrollType.ObjectId, 0) <> 0;

   -- все чеки за месяц
   CREATE TEMP TABLE tmpCheck ON COMMIT DROP AS
      WITH tmpCheckAll AS (
              SELECT Movement.ID                                                             AS ID
                   , Movement.OperDate                                                       AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                        AS UnitId
                   , MovementFloat_TotalSumm.ValueData                                       AS TotalSumm
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                            ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

              WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate + INTERVAL '9 hour'
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()),
           tmpCheckUserAll AS (
              SELECT Movement.ID                                          AS ID
                   , DATE_TRUNC ('DAY', Board.DateStart)                  AS OperDate
                   , Movement.UnitID                                      AS UnitId
                   , Board.UserID                                         AS UserID
                   , Movement.TotalSumm                                   AS TotalSumm
              FROM tmpCheckAll AS Movement

                   INNER JOIN tmpBoard AS Board
                                       ON Board.UnitID = Movement.UnitID
                                      AND Board.DateStart <= Movement.OperDate
                                      AND Board.DateEnd > Movement.OperDate
                                      AND Board.PayrollGroupID = zc_Enum_PayrollGroup_Check()),
           tmpCheckCount AS (
               SELECT  Movement.ID                                        AS ID
                    , COUNT(*)                                            AS  CountUser
               FROM tmpCheckUserAll AS Movement
               GROUP BY Movement.ID),
           tmpCheckUser AS (
              SELECT Movement.OperDate                                    AS OperDate
                   , Movement.UnitID                                      AS UnitId
                   , Movement.UserID                                      AS UserID
                   , SUM(Movement.TotalSumm)                              AS TotalSumm
                   , COUNT(*)                                             AS CountCheck
                   , CheckCount.CountUser                                 AS CountUser
              FROM tmpCheckUserAll AS Movement

                   INNER JOIN tmpCheckCount AS CheckCount
                                            ON CheckCount.ID = Movement.ID

              GROUP BY Movement.OperDate, Movement.UnitID, Movement.UserID, CheckCount.CountUser)

       SELECT Movement.OperDate::TDateTime                                      AS OperDate
            , Movement.UnitID                                                   AS UnitId
            , Movement.UserID                                                   AS UserID
            , SUM(Round(Movement.TotalSumm / Movement.CountUser, 2))::TFloat    AS SummaBase
            , SUM(Movement.CountCheck)::Integer                                 AS CountCheck
            , string_agg(
              '('||
              TRIM(to_char(Movement.TotalSumm, 'G999G999G999G999D99'))||' / '||
              Movement.CountUser::TVarChar||' = '||
              TRIM(to_char(Round(Movement.TotalSumm / Movement.CountUser, 2), 'G999G999G999G999D99'))||
              ')', ' + ')::TVarChar                                              AS Detals
       FROM tmpCheckUser AS Movement
       GROUP BY Movement.OperDate, Movement.UnitID, Movement.UserID;


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

     -- Непосредственно результат
   RETURN QUERY
   WITH
     tmpManagerPharmacy AS (  -- Заведующие аптекой
       SELECT ROW_NUMBER() OVER (PARTITION BY tmpBoard.UserID ORDER BY tmpBoard.UserId DESC) AS Ord
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, tmpBoard.UnitId) AS UnitId
            , vbEndDate                                                       AS OperDate
            , tmpBoard.UserID
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, tmpBoard.UnitId) AS UnitUserId

            , 1000::TFloat                                                    AS SummaCalc
            , 'Доплата заведующим аптекой: 1000.00'::TVarChar                 AS FormulaCalc
       FROM (SELECT tmpBoard.UnitId
                  , tmpBoard.UserID
                  , tmpBoard.UnitUserId
             FROM tmpBoard
             WHERE tmpBoard.isManagerPharmacy = TRUE
               AND tmpBoard.UnitId = tmpBoard.UnitUserId
               AND (tmpBoard.UserId = inUserID OR inUserID = 0)
             GROUP BY tmpBoard.UnitId
                    , tmpBoard.UserID
                    , tmpBoard.UnitUserId) tmpBoard

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
        , tmpBoard.UserID
        , tmpBoard.UnitUserId

        , Object_PayrollType.Id                           AS PayrollTypeID
        , Object_PayrollType.ObjectCode                   AS PayrollTypeCode
        , Object_PayrollType.ValueData                    AS PayrollTypeName
        , ObjectString_PayrollType_ShortName.ValueData    AS ShortName

        , ObjectFloat_Percent.ValueData                   AS Percent
        , ObjectFloat_MinAccrualAmount.ValueData          AS MinAccrualAmount

        , Calculation.SummaBase                           AS SummaBase
        , Calculation.Summa                               AS SummaCalc
        , Calculation.Formula                             AS FormulaCalc
   FROM tmpBoard

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpBoard.UnitId

        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = tmpBoard.PayrollTypeID
        INNER JOIN ObjectString AS ObjectString_PayrollType_ShortName
                                ON ObjectString_PayrollType_ShortName.ObjectId = tmpBoard.PayrollTypeID
                               AND ObjectString_PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

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
                                AND CheckSum.UserId    = tmpBoard.UserId

        LEFT OUTER JOIN gpSelect_Calculation_PayrollGroup(inPayrollTypeID    := Object_PayrollType.Id,
                                                          inPercent          := ObjectFloat_Percent.ValueData,
                                                          inMinAccrualAmount := ObjectFloat_MinAccrualAmount.ValueData,
                                                          inCountDoc         := CheckSum.CountCheck,
                                                          inSummBase         := CheckSum.SummaBase,
                                                          inCountUser        := 0,
                                                          inDetals           := CheckSum.Detals) AS Calculation
                                                                                                 ON 1 = 1
   WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_Check()
     AND (tmpBoard.UserId = inUserID OR inUserID = 0)
   UNION ALL  -- Oт суммы реализации оприходоанных накладных по дням
   SELECT tmpBoard.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpBoard.OperDate
        , tmpBoard.UserID
        , tmpBoard.UnitUserId

        , Object_PayrollType.Id                           AS PayrollTypeID
        , Object_PayrollType.ObjectCode                   AS PayrollTypeCode
        , Object_PayrollType.ValueData                    AS PayrollTypeName
        , ObjectString_PayrollType_ShortName.ValueData    AS ShortName

        , ObjectFloat_Percent.ValueData                   AS Percent
        , ObjectFloat_MinAccrualAmount.ValueData          AS MinAccrualAmount

        , Calculation.SummaBase                           AS SummaBase
        , Calculation.Summa                               AS SummaCalc
        , Calculation.Formula                             AS FormulaCalc
   FROM tmpBoard
   
        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpBoard.UnitId

        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = tmpBoard.PayrollTypeID
        INNER JOIN ObjectString AS ObjectString_PayrollType_ShortName
                                ON ObjectString_PayrollType_ShortName.ObjectId = tmpBoard.PayrollTypeID
                               AND ObjectString_PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

        INNER JOIN Object AS Object_PayrollGroup ON Object_PayrollGroup.Id = tmpBoard.PayrollGroupID

        INNER JOIN ObjectFloat AS ObjectFloat_Percent
                               ON ObjectFloat_Percent.ObjectId = tmpBoard.PayrollTypeID
                              AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

        INNER JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                               ON ObjectFloat_MinAccrualAmount.ObjectId = tmpBoard.PayrollTypeID
                              AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()

        LEFT OUTER JOIN tmpIncome AS Income
                                  ON Income.OperDate  = tmpBoard.OperDate
                                 AND Income.UnitId    = tmpBoard.UnitId
   
        LEFT OUTER JOIN gpSelect_Calculation_PayrollGroup(inPayrollTypeID    := tmpBoard.PayrollTypeID,
                                                          inPercent          := ObjectFloat_Percent.ValueData,
                                                          inMinAccrualAmount := ObjectFloat_MinAccrualAmount.ValueData,
                                                          inCountDoc         := Income.IncomeCount,
                                                          inSummBase         := Income.SaleSumm,
                                                          inCountUser        := Income.CountUser,
                                                          inDetals           := '') AS Calculation
                                                                                    ON 1 = 1
                              
   WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
     AND (tmpBoard.UserId = inUserID OR inUserID = 0)
   UNION ALL
     -- Доплаты заведующим аптекой
   SELECT tmpManagerPharmacy.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpManagerPharmacy.OperDate
        , tmpManagerPharmacy.UserID
        , tmpManagerPharmacy.UnitUserId

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName
        , NULL::TVarChar                                  AS ShortName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , 0::TFloat                                       AS SummaBase
        , 1000::TFloat                                    AS SummaCalc
        , 'Доплата заведующим аптекой: 1000.00'::TVarChar AS FormulaCalc
   FROM tmpManagerPharmacy

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpManagerPharmacy.UnitId

   WHERE tmpManagerPharmacy.Ord = 1

   ;



END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.09.19                                                        *
 02.09.19                                                        *
 22.08.19                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Calculation_Wages (('01.09.2019')::TDateTime, 0, '3')