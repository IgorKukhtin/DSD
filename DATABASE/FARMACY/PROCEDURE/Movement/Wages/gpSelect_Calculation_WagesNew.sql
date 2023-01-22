-- Function: gpSelect_Calculation_Wages()

DROP FUNCTION IF EXISTS gpSelect_Calculation_WagesNew (TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_WagesNew(
    IN inOperDate    TDateTime,     -- Дата начисления
    IN inUserID      Integer,       -- Сотрудник
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar, OperDate TDateTime
             , UserId Integer, UnitUserId Integer
             , PayrollTypeID Integer, PayrollTypeCode Integer, PayrollTypeName TVarChar, ShortName TVarChar
             , Percent TFloat, MinAccrualAmount TFloat
             , SummaBase TFloat, SummaBaseSite TFloat, SummaCalc TFloat, FormulaCalc TVarChar
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


   CREATE TEMP TABLE tmpPayrollRatio ON COMMIT DROP AS
     SELECT 1::Integer  AS Id, 3997718::Integer  AS UserId, 183289 ::Integer  AS UnitId, 50::TFloat AS PayrollRatio;

   ANALYSE tmpPayrollRatio;

   CREATE TEMP TABLE tmpCorrectionPercentage ON COMMIT DROP AS
     SELECT * FROM gpSelect_Object_CorrectWagesPercentage (False, '3')
     ;

   ANALYSE tmpCorrectionPercentage;

raise notice 'Value 5: %', CLOCK_TIMESTAMP();

   CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
      SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

   ANALYSE tmpOperDate;

raise notice 'Value 6: %', CLOCK_TIMESTAMP();

   -- все данные за месяц по графикам
   CREATE TEMP TABLE tmpBoard ON COMMIT DROP AS
       SELECT DISTINCT
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

            INNER JOIN MovementItemDate AS MIDate_Start
                                        ON MIDate_Start.MovementItemId = MIChild.Id
                                       AND MIDate_Start.DescId = zc_MIDate_Start()

            INNER JOIN MovementItemDate AS MIDate_End
                                        ON MIDate_End.MovementItemId = MIChild.Id
                                       AND MIDate_End.DescId = zc_MIDate_End()

       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
          AND Movement.StatusId <> zc_Enum_Status_Erased()
          AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
          AND COALESCE(MILinkObject_PayrollType.ObjectId, 0) <> 0;

   ANALYSE tmpBoard;

raise notice 'Value 7: %', CLOCK_TIMESTAMP();

   -- Добавляем дополнительные смены
   INSERT INTO tmpBoard
   SELECT tmpBoard.UserID
        , tmpBoard.MemberId
        , tmpBoard.UnitUserId

        , tmpBoard.OperDate
        , tmpBoard.UnitId
        , ObjectLink_AddPayrollType.ChildObjectId AS PayrollTypeID
        , ObjectLink_PayrollGroup.ChildObjectId AS PayrollGroupID
        , tmpBoard.DateStart
        , tmpBoard.DateEnd
        , tmpBoard.isManagerPharmacy
   FROM tmpBoard
        INNER JOIN ObjectLink AS ObjectLink_AddPayrollType
                              ON ObjectLink_AddPayrollType.ObjectId = tmpBoard.PayrollTypeID
                             AND ObjectLink_AddPayrollType.DescId = zc_ObjectLink_PayrollType_PayrollType()
        LEFT JOIN ObjectLink AS ObjectLink_PayrollGroup
                             ON ObjectLink_PayrollGroup.ObjectId = ObjectLink_AddPayrollType.ChildObjectId
                            AND ObjectLink_PayrollGroup.DescId = zc_ObjectLink_PayrollType_PayrollGroup()
   WHERE COALESCE(ObjectLink_AddPayrollType.ChildObjectId, 0) <> 0;

   ANALYSE tmpBoard;

raise notice 'Value 8: %', CLOCK_TIMESTAMP();

   CREATE TEMP TABLE tmpMICheckAll ON COMMIT DROP AS (
      WITH tmpCheckAll AS (
              SELECT Movement.ID                                                             AS ID
                   , Movement.OperDate                                                       AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                        AS UnitId
                   , MLO_Insert.ObjectId                                                     AS UserID
                   , CASE WHEN COALESCE(MovementString_InvNumberOrder.ValueData, '') <> ''
                            OR COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0
                          THEN TRUE ELSE FALSE END                                           AS isSite
                   , COALESCE (MB_RoundingDown.ValueData, False)                             AS isRoundingDown
                   , COALESCE (MB_RoundingTo10.ValueData, False)                             AS isRoundingTo10
                   , COALESCE (MB_RoundingTo50.ValueData, False)                             AS isRoundingTo50

              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   LEFT JOIN MovementFloat AS MovementFloat_ApplicationAward
                                           ON MovementFloat_ApplicationAward.MovementId =  Movement.Id
                                          AND MovementFloat_ApplicationAward.DescId = zc_MovementFloat_ApplicationAward()

                   LEFT JOIN MovementLinkObject AS MLO_Insert
                                                ON MLO_Insert.MovementId = Movement.Id
                                               AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()

                   LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                             ON MovementBoolean_CorrectMarketing.MovementId = Movement.Id
                                            AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()

                   LEFT JOIN MovementBoolean AS MovementBoolean_Doctors
                                             ON MovementBoolean_Doctors.MovementId = Movement.Id
                                            AND MovementBoolean_Doctors.DescId = zc_MovementBoolean_Doctors()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                               AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

                   LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                            ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                           AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                   LEFT JOIN MovementLinkObject AS MovementLinkObject_UserReferals
                                                ON MovementLinkObject_UserReferals.MovementId = Movement.Id
                                               AND MovementLinkObject_UserReferals.DescId = zc_MovementLinkObject_UserReferals()

                   LEFT JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                             ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                            AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()

                   LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                             ON MB_RoundingTo10.MovementId = Movement.Id
                                            AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                   LEFT JOIN MovementBoolean AS MB_RoundingDown
                                             ON MB_RoundingDown.MovementId = Movement.Id
                                            AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                   LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                             ON MB_RoundingTo50.MovementId = Movement.Id
                                            AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

              WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate + INTERVAL '9 hour'
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
                AND COALESCE(MovementBoolean_Doctors.ValueData, False) = False
                AND (COALESCE(MovementBoolean_MobileFirstOrder.ValueData, FALSE) = False OR
                     COALESCE(MovementLinkObject_UserReferals.ObjectId, 0) = 0 OR
                     COALESCE(MovementFloat_ApplicationAward.ValueData, 0) = 0)
                AND Movement.Id NOT IN (22653173, 22653613, 22653819, 30699245, 30705746, 30705783))

       SELECT Movement.Id
            , Movement.OperDate
            , Movement.UnitId
            , Movement.UserID
            , MILinkObject_PartionDateKind.ObjectId      AS PartionDateKindId
            , Movement.isSite                            AS isSite
            , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                              , Movement.isRoundingDown
                              , Movement.isRoundingTo10
                              , Movement.isRoundingTo50) :: TFloat AS AmountSumm
       FROM tmpCheckAll AS Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.Amount     > 0

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                             ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                                            AND MILinkObject_PartionDateKind.ObjectId       <> zc_Enum_PartionDateKind_Good()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.ObjectId

       WHERE (Movement.UnitId <> 394426 OR COALESCE(Movement.UserID, 0) <> 8720522)
         AND (Movement.OperDate < '01.10.2021' OR Movement.UnitId <> 10779386 OR COALESCE(Movement.UserID, 0) <> 374175)
         AND COALESCE (Object_Goods_Retail.SummaWages, 0) = 0
         AND COALESCE (Object_Goods_Retail.PercentWages, 0) = 0
       );

   ANALYSE tmpMICheckAll;

raise notice 'Value 9: %', CLOCK_TIMESTAMP();

   -- все чеки за месяц
   CREATE TEMP TABLE tmpResult ON COMMIT DROP AS (
      WITH
          tmpPartionDateWagesAll AS (SELECT Object_PartionDateWages.Id
                                          , ObjectLink_PartionDateKind.ChildObjectId             AS PartionDateKindId
                                          , ObjectDate_DateStart.ValueData                       AS DateStart
                                          , COALESCE (ObjectFloat_Percent.ValueData, 0)::TFloat  AS Percent
                                          , COALESCE (ObjectBoolean_NotCharge.ValueData, False)  AS isNotCharge
                                          , ROW_NUMBER() OVER (PARTITION BY ObjectLink_PartionDateKind.ChildObjectId ORDER BY ObjectDate_DateStart.ValueData) AS Ord
                                       FROM Object AS Object_PartionDateWages
                                            LEFT JOIN ObjectLink AS ObjectLink_PartionDateKind
                                                                 ON ObjectLink_PartionDateKind.ObjectId = Object_PartionDateWages.Id
                                                                AND ObjectLink_PartionDateKind.DescId = zc_ObjectLink_PartionDateWages_PartionDateKind()
                                            LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                                                 ON ObjectDate_DateStart.ObjectId = Object_PartionDateWages.Id
                                                                AND ObjectDate_DateStart.DescId = zc_ObjectDate_PartionDateWages_DateStart()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                                                  ON ObjectFloat_Percent.ObjectId = Object_PartionDateWages.Id
                                                                 AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PartionDateWages_Percent()
                                            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCharge
                                                                    ON ObjectBoolean_NotCharge.ObjectId = Object_PartionDateWages.Id
                                                                   AND ObjectBoolean_NotCharge.DescId = zc_ObjectBoolean_PartionDateWages_NotCharge()
                                       WHERE Object_PartionDateWages.DescId = zc_Object_PartionDateWages()
                                         AND Object_PartionDateWages.isErased = False),
          tmpPartionDateWages AS (SELECT PartionDateWages.Id
                                       , PartionDateWages.PartionDateKindId
                                       , PartionDateWages.DateStart
                                       , COALESCE(PartionDateWagesNext.DateStart, zc_DateEnd())  AS DateEnd
                                       , PartionDateWages.Percent
                                       , PartionDateWages.isNotCharge
                                  FROM tmpPartionDateWagesAll AS PartionDateWages

                                       LEFT JOIN tmpPartionDateWagesAll AS PartionDateWagesNext
                                                                        ON PartionDateWagesNext.PartionDateKindId = PartionDateWages.PartionDateKindId
                                                                       AND PartionDateWagesNext.Ord = PartionDateWages.Ord + 1
                                  ),
           tmpCheckUserAll AS (
              SELECT Movement.ID                                AS ID
                   , DATE_TRUNC ('DAY', Board.DateStart)        AS OperDate
                   , Movement.UnitID                            AS UnitId
                   , Board.UserID                               AS UserID
                   , Movement.PartionDateKindId                 AS PartionDateKindId
                   , Movement.isSite                            AS isSite
                   , SUM(Movement.AmountSumm) :: TFloat         AS TotalSumm
              FROM tmpMICheckAll AS Movement

                   INNER JOIN tmpBoard AS Board
                                       ON Board.UnitID = Movement.UnitID
                                      AND Board.DateStart <= Movement.OperDate
                                      AND (Board.DateEnd + INTERVAL '30 second') > Movement.OperDate
                                      AND Board.PayrollGroupID = zc_Enum_PayrollGroup_Check()

              GROUP BY Movement.ID
                     , DATE_TRUNC ('DAY', Board.DateStart)
                     , Movement.UnitID
                     , Board.UserID
                     , Movement.PartionDateKindId
                     , Movement.isSite
              ),
           tmpCheckCountPrew AS (
               SELECT Movement.ID                                         AS ID
                    , Movement.UnitID                                     AS UnitId
                    , COUNT(DISTINCT  Movement.UserID)                    AS CountUser
                    , string_agg(DISTINCT Movement.UserID::TVarChar, ',')          AS UserList
               FROM tmpCheckUserAll AS Movement
               GROUP BY Movement.ID
                      , Movement.UnitID),
           tmpCheckCount AS (
               SELECT Movement.ID                                         AS ID
                    , Movement.CountUser                                  AS CountUser
                    , tmpPayrollRatio.ID                                  AS PayrollRatioID
               FROM tmpCheckCountPrew AS Movement
                    LEFT JOIN tmpPayrollRatio ON tmpPayrollRatio.UnitID = Movement.UnitID
                                             AND position(','||tmpPayrollRatio.UserID::TVarChar||',' IN ','||Movement.UserList||',') > 0
               ),
           tmpCheckUser AS (
              SELECT Movement.OperDate                                    AS OperDate
                   , Movement.UnitID                                      AS UnitId
                   , Movement.UserID                                      AS UserID
                   , PartionDateWages.PartionDateKindId                   AS PartionDateKindId
                   , Movement.isSite
                   , SUM(Movement.TotalSumm)                              AS TotalSumm
                   , COUNT(*)                                             AS CountCheck
                   , CheckCount.CountUser                                 AS CountUser
                   , CheckCount.PayrollRatioID                            AS PayrollRatioID
                   , COALESCE(PartionDateWages.Percent, 0)                AS PartionDatePercent
              FROM tmpCheckUserAll AS Movement

                   INNER JOIN tmpCheckCount AS CheckCount
                                            ON CheckCount.ID = Movement.ID

                   LEFT JOIN tmpPartionDateWages AS PartionDateWages
                                                 ON PartionDateWages.PartionDateKindId = Movement.PartionDateKindId
                                                AND PartionDateWages.DateStart <= Movement.OperDate
                                                AND PartionDateWages.DateEnd > Movement.OperDate
                                                AND (PartionDateWages.Percent <> 0 OR COALESCE(PartionDateWages.isNotCharge, FALSE) = TRUE)

              WHERE COALESCE (PartionDateWages.ID, 0) = 0 OR COALESCE(PartionDateWages.isNotCharge, FALSE) = FALSE

              GROUP BY Movement.OperDate
                     , Movement.UnitID
                     , Movement.UserID
                     , PartionDateWages.PartionDateKindId
                     , CheckCount.CountUser
                     , CheckCount.PayrollRatioID
                     , Movement.isSite
                     , COALESCE(PartionDateWages.Percent, 0))

     SELECT Movement.OperDate::TDateTime                                      AS OperDate
          , Movement.UnitID                                                   AS UnitId
          , Movement.UserID                                                   AS UserID
          , Movement.PartionDateKindId                                        AS PartionDateKindId
          , Movement.isSite                                                   AS isSite
          , SUM(Round(CASE WHEN COALESCE (tmpPayrollRatio.ID, 0) > 0 AND Movement.CountUser > 2
                      THEN CASE WHEN tmpPayrollRatio.UserID = Movement.UserID
                                THEN Movement.TotalSumm / 2
                                ELSE Movement.TotalSumm / 2 / (Movement.CountUser - 1) END
                      ELSE Movement.TotalSumm / Movement.CountUser END, 2))::TFloat     AS SummaBase
          , SUM(Movement.CountCheck)::Integer                                 AS CountCheck
          , string_agg('('||
                      zfConvert_FloatToString(Movement.TotalSumm)||' / '||
                      CASE WHEN COALESCE (tmpPayrollRatio.ID, 0) > 0 AND Movement.CountUser > 2
                      THEN CASE WHEN tmpPayrollRatio.UserID = Movement.UserID THEN '2'
                                ELSE '2 / '||(Movement.CountUser - 1)::TVarChar END
                      ELSE Movement.CountUser::TVarChar END||' = '||
                      zfConvert_FloatToString(Round(CASE WHEN COALESCE (tmpPayrollRatio.ID, 0) > 0
                                                         THEN CASE WHEN tmpPayrollRatio.UserID = Movement.UserID
                                                                   THEN Movement.TotalSumm / 2
                                                                   ELSE Movement.TotalSumm / 2 / (Movement.CountUser - 1) END
                                                         ELSE Movement.TotalSumm / Movement.CountUser END, 2))||')', '+')::TVarChar                                              AS Detals
          , Movement.PartionDatePercent                                                              AS PartionDatePercent
     FROM tmpCheckUser AS Movement

          LEFT JOIN tmpPayrollRatio ON tmpPayrollRatio.ID = Movement.PayrollRatioID

     GROUP BY Movement.OperDate, Movement.UnitID, Movement.UserID, Movement.PartionDateKindId, Movement.PartionDatePercent, Movement.isSite);


   ANALYSE tmpResult;


raise notice 'Value 91: %', CLOCK_TIMESTAMP();

   -- все чеки за месяц
   CREATE TEMP TABLE tmpCheck ON COMMIT DROP AS (
     WITH
     tmpCorrectMinAmount AS (-- Корректировка минимальной суммы в типе расчета ЗП
                             SELECT *
                             FROM gpSelect_Object_CorrectMinAmount (0, True, inSession))

     SELECT tmpBoard.UnitId
          , tmpBoard.OperDate
          , tmpBoard.UserID
          , tmpBoard.UnitUserId
          , CheckSum.PartionDateKindId                        AS PartionDateKindId
          , CheckSum.PartionDatePercent                       AS PartionDatePercent

          , tmpBoard.PayrollTypeID                            AS PayrollTypeID
          , CheckSum.isSite                                   AS isSite



          , SUM(CheckSum.SummaBase)::TFLoat                   AS SummaBase
          , (CASE WHEN count(*) > 1 THEN '(' ELSE '' END||
            string_agg(CheckSum.Detals, ' + ')||
            CASE WHEN count(*) > 1 THEN ')' ELSE '' END)::TVarChar      AS FormulaCalc

          , count(*)                                          AS CountLine
     FROM tmpBoard

          LEFT OUTER JOIN tmpResult AS CheckSum
                                    ON CheckSum.OperDate  = tmpBoard.OperDate
                                   AND CheckSum.UnitId    = tmpBoard.UnitId
                                   AND CheckSum.UserId    = tmpBoard.UserId

     WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_Check()
     GROUP BY tmpBoard.UnitId, tmpBoard.OperDate, tmpBoard.UserID, tmpBoard.UnitUserId,
              tmpBoard.PayrollTypeID, CheckSum.isSite, CheckSum.PartionDateKindId, CheckSum.PartionDatePercent
     HAVING SUM(CheckSum.SummaBase) > 0);

   ANALYSE tmpCheck;

raise notice 'Value 10: %', CLOCK_TIMESTAMP();

   -- реализация про приходам за месяц
   CREATE TEMP TABLE tmpIncome ON COMMIT DROP AS
      WITH tmpIncomeGoodsSpecial AS (
              SELECT MovementItemContainer.MovementId
                   , SUM(ROUND(MovementItemContainer.Amount * MIFloat_Price.ValueData, 2)) AS Summa
              FROM MovementItemContainer

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                              AND MIFloat_Price.DescId = zc_MIFloat_PriceSale()

              WHERE vbStartDate >= '01.01.2021'
                AND MovementItemContainer.OperDate BETWEEN vbStartDate AND vbEndDate
                AND MovementItemContainer.MovementDescId = zc_Movement_Income()
                AND MovementItemContainer.DescId = zc_MIContainer_Count()
                AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                                 FROM Object_Goods_Retail
                                                                 WHERE COALESCE (Object_Goods_Retail.SummaWagesStore, 0) <> 0
                                                                    OR COALESCE (Object_Goods_Retail.PercentWagesStore, 0) <> 0)
               GROUP BY MovementItemContainer.MovementId),
           tmpSurchargeWages AS (SELECT tmp.*
                                 FROM gpSelect_Object_SurchargeWages (FALSE, inSession) AS tmp
                                 WHERE tmp.DateStart <= vbStartDate
                                   AND COALESCE(tmp.DateEnd, vbStartDate) >= vbStartDate
                                   AND COALESCE(tmp.Summa, 0) = 0),
           tmpIncome AS (
              SELECT DATE_TRUNC ('DAY', MovementDate_Branch.ValueData)                AS OperDate
                   , MovementLinkObject_Unit.ObjectId                                 AS UnitId
                   , SUM(COALESCE(MovementFloat_TotalSummSale.ValueData, 0) - COALESCE(tmpIncomeGoodsSpecial.Summa, 0))::TFloat  AS SaleSumm
                   , COUNT(*)::Integer                                                AS IncomeCount
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()

                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                   INNER JOIN MovementDate AS MovementDate_Branch
                                           ON MovementDate_Branch.MovementId = Movement.Id
                                          AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                   LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                           ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                          AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

                   LEFT JOIN tmpIncomeGoodsSpecial ON tmpIncomeGoodsSpecial.MovementId = Movement.Id

              WHERE MovementDate_Branch.ValueData BETWEEN vbStartDate AND vbEndDate
                AND Movement.DescId = zc_Movement_Income()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND (MovementLinkObject_From.ObjectId <> 17947660 OR
                     EXISTS(SELECT 1 FROM tmpSurchargeWages
                            WHERE tmpSurchargeWages.UnitId = MovementLinkObject_Unit.ObjectId
                              AND tmpSurchargeWages.DateStart <= DATE_TRUNC ('DAY', MovementDate_Branch.ValueData)
                              AND COALESCE(tmpSurchargeWages.DateEnd, vbEndDate) >= DATE_TRUNC ('DAY', MovementDate_Branch.ValueData)))
              GROUP BY DATE_TRUNC ('DAY', MovementDate_Branch.ValueData), MovementLinkObject_Unit.ObjectId),
           tmpUserDey AS (
              SELECT tmpBoard.OperDate
                   , tmpBoard.UnitId
                   , COUNT(*)::Integer         AS CountUser
              FROM tmpBoard
              WHERE tmpBoard.PayrollGroupID = zc_Enum_PayrollGroup_IncomeCheck()
              GROUP BY tmpBoard.OperDate
                     , tmpBoard.UnitId),
           tmpIncomeAdd AS (
              SELECT
                     tmpIncome.OperDate
                   , 15212291                AS UnitId
                   , tmpIncome.SaleSumm
                   , tmpIncome.IncomeCount
              FROM tmpIncome
              WHERE tmpIncome.OperDate = '02.02.2022'
                AND tmpIncome.UnitId = 11152911)

       SELECT tmpIncome.OperDate::TDateTime
            , tmpIncome.UnitId
            , tmpIncome.IncomeCount
            , (tmpIncome.SaleSumm + COALESCE (tmpIncomeAdd.SaleSumm, 0))::TFloat AS SaleSumm
            , UserDey.CountUser
       FROM tmpIncome

            LEFT OUTER JOIN tmpUserDey AS UserDey
                                       ON UserDey.OperDate       = tmpIncome.OperDate
                                      AND UserDey.UnitId         = tmpIncome.UnitId

            LEFT OUTER JOIN tmpIncomeAdd ON tmpIncomeAdd.OperDate = tmpIncome.OperDate
                                        AND tmpIncomeAdd.UnitId   = tmpIncome.UnitId;

   ANALYSE tmpIncome;

raise notice 'Value 11: %', CLOCK_TIMESTAMP();

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
                              AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()),
     -- Доплаты сотруднику
     tmpSurchargeWages AS (SELECT tmp.*
                                , COALESCE(ObjectLink_Member_Unit.ChildObjectId, tmp.UnitId) AS UnitUserId
                           FROM gpSelect_Object_SurchargeWages (FALSE, inSession) AS tmp

                                LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                     ON ObjectLink_User_Member.ObjectId =  tmp.UserID
                                                    AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                                     ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                    AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                           WHERE tmp.DateStart <= vbStartDate
                             AND COALESCE(tmp.DateEnd, vbStartDate) >= vbStartDate
                             AND COALESCE(tmp.Summa, 0) > 0),
     tmpGoodsSummaWages AS (-- ЗП за реализацию единицы товара
       SELECT MovementItemContainer.WhereObjectId_analyzer                                                 AS UnitId
            , MLO_Insert.ObjectId                                                                          AS UserID
            , vbEndDate                                                                                    AS OperDate
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, MovementItemContainer.WhereObjectId_analyzer) AS UnitUserId
            , SUM(ROUND(-1 * MovementItemContainer.Amount * Object_Goods_Retail.SummaWages, 2))            AS Summa
       FROM MovementItemContainer

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = MovementItemContainer.MovementId
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()

            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemContainer.ObjectId_analyzer

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId =  MLO_Insert.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

            LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                      ON MovementBoolean_CorrectMarketing.MovementId = MovementItemContainer.MovementId
                                     AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()

            LEFT JOIN MovementBoolean AS MovementBoolean_Doctors
                                      ON MovementBoolean_Doctors.MovementId = MovementItemContainer.MovementId
                                     AND MovementBoolean_Doctors.DescId = zc_MovementBoolean_Doctors()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = MovementItemContainer.MovementId
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  MovementItemContainer.MovementId
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

       WHERE MovementItemContainer.OperDate BETWEEN vbStartDate AND vbEndDate + INTERVAL '9 hour'
         AND MovementItemContainer.MovementDescId = zc_Movement_Check()
         AND MovementItemContainer.DescId = zc_MIContainer_Count()
         AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
         AND COALESCE(MovementBoolean_Doctors.ValueData, False) = False
         AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                         FROM Object_Goods_Retail
                                                         WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0)
       GROUP BY MovementItemContainer.WhereObjectId_analyzer, MLO_Insert.ObjectId, ObjectLink_Member_Unit.ChildObjectId),
     tmpGoodsPercentWages AS (-- ЗП % от продажи
       SELECT MovementItemContainer.WhereObjectId_analyzer                                                 AS UnitId
            , MLO_Insert.ObjectId                                                                          AS UserID
            , vbEndDate                                                                                    AS OperDate
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, MovementItemContainer.WhereObjectId_analyzer) AS UnitUserId
            , SUM(ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price *
                             Object_Goods_Retail.PercentWages / 100.0, 2))                                 AS Summa
       FROM MovementItemContainer

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = MovementItemContainer.MovementId
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()

            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemContainer.ObjectId_analyzer

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId =  MLO_Insert.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

            LEFT JOIN MovementBoolean AS MovementBoolean_CorrectMarketing
                                      ON MovementBoolean_CorrectMarketing.MovementId = MovementItemContainer.MovementId
                                     AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()

            LEFT JOIN MovementBoolean AS MovementBoolean_Doctors
                                      ON MovementBoolean_Doctors.MovementId = MovementItemContainer.MovementId
                                     AND MovementBoolean_Doctors.DescId = zc_MovementBoolean_Doctors()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = MovementItemContainer.MovementId
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  MovementItemContainer.MovementId
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

       WHERE MovementItemContainer.OperDate BETWEEN vbStartDate AND vbEndDate + INTERVAL '9 hour'
         AND MovementItemContainer.MovementDescId = zc_Movement_Check()
         AND MovementItemContainer.DescId = zc_MIContainer_Count()
         AND COALESCE(MovementBoolean_CorrectMarketing.ValueData, False) = False
         AND COALESCE(MovementBoolean_Doctors.ValueData, False) = False
         AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                         FROM Object_Goods_Retail
                                                         WHERE COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
       GROUP BY MovementItemContainer.WhereObjectId_analyzer, MLO_Insert.ObjectId, ObjectLink_Member_Unit.ChildObjectId),
     tmpGoodsIncomeSummaWages AS (-- ЗП за приход единицы товара
       SELECT MovementItemContainer.WhereObjectId_analyzer                                                 AS UnitId
            , MLO_Update.ObjectId                                                                          AS UserID
            , vbEndDate                                                                                    AS OperDate
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, MovementItemContainer.WhereObjectId_analyzer) AS UnitUserId
            , SUM(ROUND(MovementItemContainer.Amount * Object_Goods_Retail.SummaWagesStore, 2))            AS Summa
       FROM MovementItemContainer

            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = MovementItemContainer.MovementId
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()

            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemContainer.ObjectId_analyzer

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId =  MLO_Update.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

       WHERE vbStartDate >= '01.01.2021'
         AND MovementItemContainer.OperDate BETWEEN vbStartDate AND vbEndDate
         AND MovementItemContainer.MovementDescId = zc_Movement_Income()
         AND MovementItemContainer.DescId = zc_MIContainer_Count()
         AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                         FROM Object_Goods_Retail
                                                         WHERE COALESCE (Object_Goods_Retail.SummaWagesStore, 0) <> 0)
       GROUP BY MovementItemContainer.WhereObjectId_analyzer, MLO_Update.ObjectId, ObjectLink_Member_Unit.ChildObjectId),
     tmpGoodsIncomePercentWages AS (-- ЗП % от прихода
       SELECT MovementItemContainer.WhereObjectId_analyzer                                                 AS UnitId
            , MLO_Update.ObjectId                                                                          AS UserID
            , vbEndDate                                                                                    AS OperDate
            , COALESCE(ObjectLink_Member_Unit.ChildObjectId, MovementItemContainer.WhereObjectId_analyzer) AS UnitUserId
            , SUM(ROUND(MovementItemContainer.Amount * MIFloat_Price.ValueData *
                             Object_Goods_Retail.PercentWagesStore / 100.0, 2))                            AS Summa
       FROM MovementItemContainer

            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = MovementItemContainer.MovementId
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()

            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemContainer.ObjectId_analyzer

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId =  MLO_Update.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_PriceSale()

       WHERE vbStartDate >= '01.01.2021'
         AND MovementItemContainer.OperDate BETWEEN vbStartDate AND vbEndDate
         AND MovementItemContainer.MovementDescId = zc_Movement_Income()
         AND MovementItemContainer.DescId = zc_MIContainer_Count()
         AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                         FROM Object_Goods_Retail
                                                         WHERE COALESCE (Object_Goods_Retail.PercentWagesStore, 0) <> 0)
       GROUP BY MovementItemContainer.WhereObjectId_analyzer, MLO_Update.ObjectId, ObjectLink_Member_Unit.ChildObjectId),
     tmpCorrectMinAmount AS (-- Корректировка минимальной суммы в типе расчета ЗП
       SELECT *
       FROM gpSelect_Object_CorrectMinAmount (0, True, inSession)),
     tmpUserReferals AS (
       SELECT date_trunc('Day', Movement.OperDate)                AS OperDate
            , MovementLinkObject_UserReferals.ObjectId            AS UserId
            , MovementLinkObject_Unit.ObjectId                    AS UnitId
            , tmpBoard.UnitUserId                                 AS UnitUserId
            , MovementFloat_ApplicationAward.ValueData            AS ApplicationAward
       FROM Movement

            INNER JOIN MovementLinkObject AS MovementLinkObject_UserReferals
                                          ON MovementLinkObject_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
                                         AND MovementLinkObject_UserReferals.MovementId = Movement.Id
                                         AND COALESCE (MovementLinkObject_UserReferals.ObjectId, 0) > 0

            INNER JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                       ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                      AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                                      AND MovementBoolean_MobileFirstOrder.ValueData = True

            INNER JOIN (SELECT DISTINCT
                               tmpBoard.UserID
                             , tmpBoard.UnitUserId
                        FROM tmpBoard) AS tmpBoard ON tmpBoard.UserID = MovementLinkObject_UserReferals.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_ApplicationAward
                                    ON MovementFloat_ApplicationAward.MovementId =  Movement.Id
                                   AND MovementFloat_ApplicationAward.DescId = zc_MovementFloat_ApplicationAward()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

       WHERE Movement.DescId = zc_Movement_Check()
         AND Movement.OperDate BETWEEN vbStartDate AND vbEndDate
         AND Movement.StatusId = zc_Enum_Status_Complete()
         AND COALESCE(MovementFloat_ApplicationAward.ValueData, 0) > 0),
   tmpCheckSum AS (SELECT CheckSum.UnitId
                        , CheckSum.OperDate
                        , CheckSum.UserID
                        , CheckSum.UnitUserId

                        , CheckSum.PayrollTypeID                            AS PayrollTypeID

                        , ObjectFloat_Percent.ValueData                     AS Percent

                        , (ObjectFloat_MinAccrualAmount.ValueData +
                          COALESCE(tmpCorrectMinAmount.Amount, 0))::TFloat  AS MinAccrualAmount

                        , SUM(CASE WHEN CheckSum.IsSite = False THEN CheckSum.SummaBase END)::TFLoat    AS SummaBase
                        , SUM(CASE WHEN CheckSum.IsSite = TRUE THEN CheckSum.SummaBase END)::TFLoat     AS SummaBaseSite

                        , SUM(ROUND(COALESCE(CASE WHEN CheckSum.IsSite = False THEN CheckSum.SummaBase END, 0) *
                                    CASE WHEN COALESCE(ObjectFloat_Percent.ValueData, 0) + COALESCE(CheckSum.PartionDatePercent, 0) > 0
                                         THEN COALESCE(ObjectFloat_Percent.ValueData, 0) + COALESCE(CheckSum.PartionDatePercent, 0)
                                         ELSE 0 END / 100, 2) +
                              ROUND(COALESCE(CASE WHEN CheckSum.IsSite = TRUE THEN CheckSum.SummaBase END, 0) *
                                    CASE WHEN 2 + COALESCE(CheckSum.PartionDatePercent, 0) > 0
                                         THEN 2 + COALESCE(CheckSum.PartionDatePercent, 0)
                                         ELSE 0 END / 100, 2))::TFLoat               AS SummaCalc

                        , string_agg(CASE WHEN CheckSum.IsSite = TRUE THEN 'Сайт' ELSE '' END||
                                     CASE WHEN COALESCE (CheckSum.PartionDateKindId, 0) > 0 THEN CASE WHEN CheckSum.IsSite = TRUE THEN ',' ELSE '' END||'Срок' ELSE '' END||
                                     CheckSum.FormulaCalc||'*'||
                                     zfConvert_FloatToString(CASE WHEN CheckSum.IsSite = False
                                                                  THEN CASE WHEN COALESCE(ObjectFloat_Percent.ValueData, 0) + COALESCE(CheckSum.PartionDatePercent, 0) > 0
                                                                            THEN COALESCE(ObjectFloat_Percent.ValueData, 0) + COALESCE(CheckSum.PartionDatePercent, 0)
                                                                            ELSE 0 END
                                                                  ELSE CASE WHEN 2 + COALESCE(CheckSum.PartionDatePercent, 0) > 0
                                                                            THEN 2 + COALESCE(CheckSum.PartionDatePercent, 0)
                                                                            ELSE 0 END END),
                                     '+' ORDER BY CheckSum.isSite, COALESCE(CheckSum.PartionDateKindId, 0))::TVarChar                AS FormulaCalc
                   FROM tmpCheck AS CheckSum

                        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = CheckSum.UnitId

                        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = CheckSum.PayrollTypeID
                        INNER JOIN ObjectString AS ObjectString_PayrollType_ShortName
                                                ON ObjectString_PayrollType_ShortName.ObjectId = CheckSum.PayrollTypeID
                                               AND ObjectString_PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

                        INNER JOIN ObjectFloat AS ObjectFloat_Percent
                                               ON ObjectFloat_Percent.ObjectId = CheckSum.PayrollTypeID
                                              AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PayrollType_Percent()

                        INNER JOIN ObjectFloat AS ObjectFloat_MinAccrualAmount
                                               ON ObjectFloat_MinAccrualAmount.ObjectId = CheckSum.PayrollTypeID
                                              AND ObjectFloat_MinAccrualAmount.DescId = zc_ObjectFloat_PayrollType_MinAccrualAmount()

                        LEFT JOIN tmpCorrectMinAmount ON tmpCorrectMinAmount.PayrollTypeId = CheckSum.PayrollTypeID
                                                     AND tmpCorrectMinAmount.DateStart <= CheckSum.OperDate
                                                     AND tmpCorrectMinAmount.DateEnd >= CheckSum.OperDate

                   WHERE (CheckSum.UserId = inUserID OR inUserID = 0)
                   GROUP BY CheckSum.UnitId, CheckSum.OperDate, CheckSum.UserID, CheckSum.UnitUserId
                          , CheckSum.PayrollTypeID, ObjectFloat_Percent.ValueData, ObjectFloat_MinAccrualAmount.ValueData, tmpCorrectMinAmount.Amount)

     -- От суммы проведенных чеков по дням
   SELECT CheckSum.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , CheckSum.OperDate
        , CheckSum.UserID
        , CheckSum.UnitUserId

        , Object_PayrollType.Id                             AS PayrollTypeID
        , Object_PayrollType.ObjectCode                     AS PayrollTypeCode
        , Object_PayrollType.ValueData                      AS PayrollTypeName
        , ObjectString_PayrollType_ShortName.ValueData      AS ShortName

        , CheckSum.Percent                                  AS Percent
        , CheckSum.MinAccrualAmount                         AS MinAccrualAmount

        , CheckSum.SummaBase                                AS SummaBase
        , CheckSum.SummaBaseSite                            AS SummaBaseSite

        , CASE WHEN COALESCE (tmpCorrectionPercentage.Percent, 100) <> 100
               THEN ROUND(CASE WHEN CheckSum.SummaCalc < CheckSum.MinAccrualAmount
                               THEN CheckSum.MinAccrualAmount
                               ELSE CheckSum.SummaCalc END * COALESCE (tmpCorrectionPercentage.Percent, 100) / 100, 2)
               ELSE CASE WHEN CheckSum.SummaCalc < CheckSum.MinAccrualAmount
                         THEN CheckSum.MinAccrualAmount
                         ELSE CheckSum.SummaCalc END
               END :: TFloat        AS SummaCalc

        , (CASE WHEN COALESCE (tmpCorrectionPercentage.Percent, 100) <> 100
               THEN '(' ELSE '' END||
          CheckSum.FormulaCalc||'='||zfConvert_FloatToString(CheckSum.SummaCalc)||
          CASE WHEN CheckSum.SummaCalc < CheckSum.MinAccrualAmount
               THEN ' Меньше '||zfConvert_FloatToString(CheckSum.MinAccrualAmount)||' то = '||zfConvert_FloatToString(CheckSum.MinAccrualAmount)
               ELSE '' END||CASE WHEN COALESCE (tmpCorrectionPercentage.Percent, 100) <> 100
               THEN ')*'||zfConvert_FloatToString(COALESCE (tmpCorrectionPercentage.Percent, 100) / 100)||'='|| 
               zfConvert_FloatToString(CASE WHEN COALESCE (tmpCorrectionPercentage.Percent, 100) <> 100
                                            THEN ROUND(CASE WHEN CheckSum.SummaCalc < CheckSum.MinAccrualAmount
                                                            THEN CheckSum.MinAccrualAmount
                                                            ELSE CheckSum.SummaCalc END * COALESCE (tmpCorrectionPercentage.Percent, 100) / 100, 2)
                                            ELSE CASE WHEN CheckSum.SummaCalc < CheckSum.MinAccrualAmount
                                                      THEN CheckSum.MinAccrualAmount
                                                      ELSE CheckSum.SummaCalc END
                                            END)
               ELSE '' END ) ::TVarChar                   AS FormulaCalc
   FROM tmpCheckSum AS CheckSum

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = CheckSum.UnitId

        INNER JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = CheckSum.PayrollTypeID
        INNER JOIN ObjectString AS ObjectString_PayrollType_ShortName
                                ON ObjectString_PayrollType_ShortName.ObjectId = CheckSum.PayrollTypeID
                               AND ObjectString_PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

        LEFT JOIN tmpCorrectionPercentage ON tmpCorrectionPercentage.UnitId = CheckSum.UnitId
                                         AND tmpCorrectionPercentage.UserID = CheckSum.UserID
                                         AND tmpCorrectionPercentage.isCheck = TRUE
                                         AND tmpCorrectionPercentage.DateStart <= CheckSum.OperDate
                                         AND COALESCE(tmpCorrectionPercentage.DateEnd, CheckSum.OperDate) >= CheckSum.OperDate


   UNION ALL  -- Oт суммы реализации оприходоанных накладных по дням
   SELECT tmpBoard.UnitId
        , Object_Unit.ObjectCode                            AS UnitCode
        , Object_Unit.ValueData                             AS UnitName
        , tmpBoard.OperDate
        , tmpBoard.UserID
        , tmpBoard.UnitUserId

        , Object_PayrollType.Id                             AS PayrollTypeID
        , Object_PayrollType.ObjectCode                     AS PayrollTypeCode
        , Object_PayrollType.ValueData                      AS PayrollTypeName
        , ObjectString_PayrollType_ShortName.ValueData      AS ShortName

        , ObjectFloat_Percent.ValueData                     AS Percent
        , (ObjectFloat_MinAccrualAmount.ValueData +
          COALESCE(tmpCorrectMinAmount.Amount, 0))::TFloat  AS MinAccrualAmount

        , Calculation.SummaBase                             AS SummaBase
        , Calculation.SummaBaseSite                         AS SummaBaseSite
        , Calculation.Summa                                 AS SummaCalc
        , Calculation.Formula                               AS FormulaCalc
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

        LEFT OUTER JOIN tmpCorrectionPercentage ON tmpCorrectionPercentage.UnitId = tmpBoard.UnitId
                                               AND tmpCorrectionPercentage.UserID = tmpBoard.UserID
                                               AND tmpCorrectionPercentage.isStore = TRUE
                                               AND tmpCorrectionPercentage.DateStart <= tmpBoard.OperDate
                                               AND COALESCE(tmpCorrectionPercentage.DateEnd, tmpBoard.OperDate) >= tmpBoard.OperDate

        LEFT OUTER JOIN tmpCorrectMinAmount ON tmpCorrectMinAmount.PayrollTypeId = Object_PayrollType.Id
                                           AND tmpCorrectMinAmount.DateStart <= tmpBoard.OperDate
                                           AND tmpCorrectMinAmount.DateEnd >= tmpBoard.OperDate

        LEFT OUTER JOIN gpSelect_Calculation_PayrollGroup(inOperDate         := tmpBoard.OperDate,
                                                          inPayrollTypeID    := tmpBoard.PayrollTypeID,
                                                          inPercent          := ObjectFloat_Percent.ValueData,
                                                          inMinAccrualAmount := ObjectFloat_MinAccrualAmount.ValueData + COALESCE(tmpCorrectMinAmount.Amount, 0),
                                                          inCountDoc         := Income.IncomeCount,
                                                          inSummBase         := Income.SaleSumm,
                                                          inSummBaseSite     := 0,
                                                          inCountUser        := Income.CountUser,
                                                          inCorrPercentage   := COALESCE (tmpCorrectionPercentage.Percent, 100),
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
        , 0::TFloat                                       AS SummaSite
        , 1000::TFloat                                    AS SummaCalc
        , 'Доплата заведующим аптекой: 1000.00'::TVarChar AS FormulaCalc
   FROM tmpManagerPharmacy

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpManagerPharmacy.UnitId

   WHERE tmpManagerPharmacy.Ord = 1
   UNION ALL
     -- Доплаты сотруднику
   SELECT tmpSurchargeWages.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , vbEndDate                                       AS OperDate
        , tmpSurchargeWages.UserID
        , tmpSurchargeWages.UnitUserId

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName
        , NULL::TVarChar                                  AS ShortName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , 0::TFloat                                       AS SummaBase
        , 0::TFloat                                       AS SummaSite
        , tmpSurchargeWages.Summa                         AS SummaCalc
        , tmpSurchargeWages.Description	                  AS FormulaCalc
   FROM tmpSurchargeWages

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpSurchargeWages.UnitId

   UNION ALL
     -- ЗП за реализацию единицы товара
   SELECT tmpGoodsSummaWages.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpGoodsSummaWages.OperDate
        , tmpGoodsSummaWages.UserID
        , tmpGoodsSummaWages.UnitUserId

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName
        , NULL::TVarChar                                  AS ShortName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , 0::TFloat                                       AS SummaBase
        , 0::TFloat                                       AS SummaSite
        , tmpGoodsSummaWages.Summa::TFloat                AS SummaCalc
        , ('За реализацию единицы товара: '||zfConvert_FloatToString(tmpGoodsSummaWages.Summa))::TVarChar                 AS FormulaCalc
   FROM tmpGoodsSummaWages

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpGoodsSummaWages.UnitId
   WHERE tmpGoodsSummaWages.UserId = inUserID OR inUserID = 0
   UNION ALL
     -- ЗП % от продажи
   SELECT tmpGoodsPercentWages.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpGoodsPercentWages.OperDate
        , tmpGoodsPercentWages.UserID
        , tmpGoodsPercentWages.UnitUserId

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName
        , NULL::TVarChar                                  AS ShortName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , 0::TFloat                                       AS SummaBase
        , 0::TFloat                                       AS SummaBaseSite
        , tmpGoodsPercentWages.Summa::TFloat              AS SummaCalc
        , ('% от продажи товара: '||zfConvert_FloatToString(tmpGoodsPercentWages.Summa))::TVarChar                 AS FormulaCalc
   FROM tmpGoodsPercentWages

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpGoodsPercentWages.UnitId

   WHERE tmpGoodsPercentWages.UserId = inUserID OR inUserID = 0
   UNION ALL
     -- ЗП за приход единицы товара
   SELECT tmpGoodsIncomeSummaWages.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpGoodsIncomeSummaWages.OperDate
        , tmpGoodsIncomeSummaWages.UserID
        , tmpGoodsIncomeSummaWages.UnitUserId

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName
        , NULL::TVarChar                                  AS ShortName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , 0::TFloat                                       AS SummaBase
        , 0::TFloat                                       AS SummaBaseSite
        , tmpGoodsIncomeSummaWages.Summa::TFloat          AS SummaCalc
        , ('За приход единицы товара: '||zfConvert_FloatToString(tmpGoodsIncomeSummaWages.Summa))::TVarChar     AS FormulaCalc
   FROM tmpGoodsIncomeSummaWages

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpGoodsIncomeSummaWages.UnitId
   WHERE tmpGoodsIncomeSummaWages.UserId = inUserID OR inUserID = 0
   UNION ALL
     -- ЗП % от прихода
   SELECT tmpGoodsIncomePercentWages.UnitId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , tmpGoodsIncomePercentWages.OperDate
        , tmpGoodsIncomePercentWages.UserID
        , tmpGoodsIncomePercentWages.UnitUserId

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName
        , NULL::TVarChar                                  AS ShortName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , 0::TFloat                                       AS SummaBase
        , 0::TFloat                                       AS SummaBaseSite
        , tmpGoodsIncomePercentWages.Summa::TFloat        AS SummaCalc
        , ('% от прихода товара: '||zfConvert_FloatToString(tmpGoodsIncomePercentWages.Summa))::TVarChar                 AS FormulaCalc
   FROM tmpGoodsIncomePercentWages

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpGoodsIncomePercentWages.UnitId

   WHERE tmpGoodsIncomePercentWages.UserId = inUserID OR inUserID = 0
   UNION ALL
     -- ЗП 20 грн за помощь при регистрации мобильного приложения
   SELECT tmpUserReferals.UnitUserId
        , Object_Unit.ObjectCode                          AS UnitCode
        , Object_Unit.ValueData                           AS UnitName
        , (tmpUserReferals.OperDate + INTERVAL '1 DAY' - INTERVAL '1 second')::TDateTime AS OperDate
        , tmpUserReferals.UserId
        , tmpUserReferals.UnitUserId

        , NULL::Integer                                   AS PayrollGroupID
        , NULL::Integer                                   AS PayrollGroupCode
        , NULL::TVarChar                                  AS PayrollGroupName
        , NULL::TVarChar                                  AS ShortName

        , NULL::TFloat                                    AS Percent
        , NULL::TFloat                                    AS MinAccrualAmount

        , 0::TFloat                                       AS SummaBase
        , 0::TFloat                                       AS SummaSite
        , SUM(tmpUserReferals.ApplicationAward)::TFloat   AS SummaCalc
        , ('Доплата 20 грн за помощь при регистрации мобильного приложения: '||zfConvert_FloatToString(SUM(tmpUserReferals.ApplicationAward)))::TVarChar AS FormulaCalc
   FROM tmpUserReferals

        INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUserReferals.UnitUserId

   WHERE (tmpUserReferals.UserId = inUserID OR inUserID = 0)

   GROUP BY tmpUserReferals.OperDate
          , tmpUserReferals.UserId
          , tmpUserReferals.UnitUserId
          , Object_Unit.ObjectCode
          , Object_Unit.ValueData

   ;

raise notice 'Value 13: %', CLOCK_TIMESTAMP();

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.03.21                                                        *
 25.10.19                                                        *
 19.10.19                                                        *
 09.09.19                                                        *
 02.09.19                                                        *
 22.08.19                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Calculation_WagesNew(('01.01.2023')::TDateTime, 0 /*19193859*/, '3') order by OperDate
