DROP FUNCTION IF EXISTS gpSelect_Report_Wage(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    Integer,   --модель начисления
    Integer,   --сотрудник
    Integer,   --должность
    Boolean,   --детализировать по дням
    Boolean,   --детализировать по моделям
    Boolean,   --детализировать по типам документов в модели
    Boolean,   --детализировать по товарам в типах документов
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage(
    IN inDateStart      TDateTime, --дата начала периода
    IN inDateFinal      TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение 
    IN inModelServiceId Integer,   --модель начисления
    IN inMemberId       Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
    IN inDetailDay      Boolean,   --детализировать по дням
    IN inDetailModelService Boolean,   --детализировать по моделям
    IN inDetailModelServiceItemMaster Boolean,   --детализировать по типам документов в модели
    IN inDetailModelServiceItemChild  Boolean,   --детализировать по товарам в типах документов
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     StaffList                      Integer
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,PersonalCount                  Integer
    ,HoursPlan                      TFloat
    ,HoursDay                       TFloat
    ,PersonalGroupId                Integer
    ,PersonalGroupName              TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SUM_MemberHours                TFloat  -- итого часов всех сотрудников (с этой должностью+...)
    ,SheetWorkTime_Amount           TFloat  -- итого часов сотрудника
    ,ServiceModelCode               Integer
    ,ServiceModelName               TVarChar
    ,Price                          TFloat
    ,FromName                       TVarChar
    ,ToName                         TVarChar
    ,MovementDescName               TVarChar
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToName   TVarChar
    ,OperDate                       TDateTime
    ,Count_MemberInDay              Integer
    ,Gross                          TFloat
    ,GrossOnOneMember               TFloat
    ,Amount                         TFloat
    ,AmountOnOneMember              TFloat
    ,PersonalServiceListId          Integer
    ,PersonalServiceListName        TVarChar
    ,ServiceModelOrd                Integer
    ,ServiceModelName_1             TVarChar
    ,ServiceModelName_2             TVarChar
    ,ServiceModelName_3             TVarChar
    ,ServiceModelName_4             TVarChar
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;


    CREATE TEMP TABLE Res(
         StaffList                      Integer
        ,UnitId                         Integer
        ,UnitName                       TVarChar
        ,PositionId                     Integer
        ,PositionName                   TVarChar
        ,PositionLevelId                Integer
        ,PositionLevelName              TVarChar
        ,PersonalCount                  Integer
        ,HoursPlan                      TFloat
        ,HoursDay                       TFloat
        ,PersonalGroupId                Integer
        ,PersonalGroupName              TVarChar
        ,MemberId                       Integer
        ,MemberName                     TVarChar
        ,SheetWorkTime_Date             TDateTime
        ,SUM_MemberHours                TFloat
        ,SheetWorkTime_Amount           TFloat
        ,ServiceModelId                 Integer
        ,ServiceModelCode               Integer
        ,ServiceModelName               TVarChar
        ,Price                          TFloat
        ,FromId                         Integer
        ,FromName                       TVarChar
        ,ToId                           Integer
        ,ToName                         TVarChar
        ,MovementDescId                 Integer
        ,MovementDescName               TVarChar
        ,SelectKindId                   Integer
        ,SelectKindName                 TVarChar
        ,Ratio                          TFloat
        ,ModelServiceItemChild_FromId   Integer
        ,ModelServiceItemChild_FromDescId   Integer
        ,ModelServiceItemChild_FromName TVarChar
        ,ModelServiceItemChild_ToId     Integer
        ,ModelServiceItemChild_ToDescId     Integer
        ,ModelServiceItemChild_ToName   TVarChar
        ,OperDate                       TDateTime
        ,Count_MemberInDay              Integer
        ,Gross                          TFloat
        ,GrossOnOneMember               TFloat
        ,Amount                         TFloat
        ,AmountOnOneMember              TFloat
        ,PersonalServiceListId          Integer
        ,PersonalServiceListName        TVarChar
    ) ON COMMIT DROP;
    CREATE TEMP TABLE SMOrd (
        ServiceModelCode Integer
       ,ServiceModelName  TVarChar
       ,ServiceModelOrd Integer
    ) ON COMMIT DROP;
    
    -- Report_1
    Insert Into Res(StaffList,UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,PersonalCount,HoursPlan,HoursDay, PersonalGroupId, PersonalGroupName, MemberId, MemberName, SheetWorkTime_Date, SUM_MemberHours, SheetWorkTime_Amount
                   ,ServiceModelId,ServiceModelCode,ServiceModelName,Price,FromId,FromName,ToId,ToName,MovementDescId,MovementDescName,SelectKindId,SelectKindName,Ratio
                   ,ModelServiceItemChild_FromId,ModelServiceItemChild_FromDescId,ModelServiceItemChild_FromName,ModelServiceItemChild_ToId,ModelServiceItemChild_ToDescId,ModelServiceItemChild_ToName
                   ,OperDate,Count_MemberInDay,Gross,GrossOnOneMember,Amount,AmountOnOneMember)
    SELECT Report_1.StaffList,Report_1.UnitId,Report_1.UnitName,Report_1.PositionId,Report_1.PositionName,Report_1.PositionLevelId,Report_1.PositionLevelName,Report_1.PersonalCount,Report_1.HoursPlan,Report_1.HoursDay
         , Report_1.PersonalGroupId, Report_1.PersonalGroupName, Report_1.MemberId,Report_1.MemberName,Report_1.SheetWorkTime_Date, Report_1.SUM_MemberHours, Report_1.SheetWorkTime_Amount, Report_1.ServiceModelId,Report_1.ServiceModelCode,Report_1.ServiceModelName,Report_1.Price
         , Report_1.FromId,Report_1.FromName,Report_1.ToId,Report_1.ToName,Report_1.MovementDescId,Report_1.MovementDescName,Report_1.SelectKindId,Report_1.SelectKindName,Report_1.Ratio
         , Report_1.ModelServiceItemChild_FromId,Report_1.ModelServiceItemChild_FromDescId,Report_1.ModelServiceItemChild_FromName,Report_1.ModelServiceItemChild_ToId
         , Report_1.ModelServiceItemChild_ToDescId,Report_1.ModelServiceItemChild_ToName,Report_1.OperDate,Report_1.Count_MemberInDay,Report_1.Gross,Report_1.GrossOnOneMember
         , Report_1.Amount,Report_1.AmountOnOneMember
    FROM gpSelect_Report_Wage_Model(inDateStart      := inDateStart,
                                inDateFinal      := inDateFinal, --дата окончания периода
                                inUnitId         := inUnitId,   --подразделение 
                                inModelServiceId := inModelServiceId,   --модель начисления
                                inMemberId       := inMemberId,   --сотрудник
                                inPositionId     := inPositionId,   --должность
                                inSession        := inSession) as Report_1;

    -- Report_2
    INSERT INTO Res(StaffList,UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,PersonalCount,HoursPlan,HoursDay, PersonalGroupId, PersonalGroupName, MemberId, MemberName
                   , SUM_MemberHours, SheetWorkTime_Amount, ServiceModelId,ServiceModelCode,ServiceModelName,Price,AmountOnOneMember)
    Select 
        Report_2.StaffList
       ,Report_2.UnitId
       ,Report_2.UnitName
       ,Report_2.PositionId
       ,Report_2.PositionName
       ,Report_2.PositionLevelId
       ,Report_2.PositionLevelName
       ,Report_2.PersonalCount
       ,Report_2.HoursPlan
       ,Report_2.HoursDay
       ,Report_2.PersonalGroupId
       ,Report_2.PersonalGroupName
       ,Report_2.MemberId
       ,Report_2.MemberName
       ,Report_2.SUM_MemberHours
       ,Report_2.SheetWorkTime_Amount
       ,Report_2.StaffListSummKindId
       ,Report_2.StaffListSummKindId   AS ServiceModelCode
       ,Report_2.StaffListSummKindName AS ServiceModelName
       ,Report_2.StaffListSumm_Value   AS Price
       ,Report_2.Summ
    FROM 
        gpSelect_Report_Wage_Sum(inDateStart      := inDateStart,
                                inDateFinal      := inDateFinal, --дата окончания периода
                                inUnitId         := inUnitId,   --подразделение 
                                inMemberId       := inMemberId,   --сотрудник
                                inPositionId     := inPositionId,   --должность
                                inSession        := inSession) as Report_2;
    WITH ResDistinct AS (
        SELECT DISTINCT
            Res.ServiceModelCode
           ,Res.ServiceModelName
        FROM
            Res
        WHERE
            Res.ServiceModelCode IS NOT NULL
    )
    
    INSERT INTO SMOrd (ServiceModelCode, ServiceModelName, ServiceModelOrd)
    SELECT 
        ResDistinct.ServiceModelCode
       ,ResDistinct.ServiceModelName
       ,(ROW_NUMBER()OVER(ORDER BY ResDistinct.ServiceModelCode))::Integer AS ServiceModelOrd
    FROM
        ResDistinct;
        
    -- Результат
    RETURN QUERY
        WITH tmpRes AS (
            SELECT
                Res.StaffList
               ,Res.UnitId
               ,Res.UnitName
               ,Res.PositionId
               ,Res.PositionName
               ,Res.PositionLevelId
               ,Res.PositionLevelName
               ,Res.PersonalCount
               ,Res.HoursPlan
               ,Res.HoursDay
               , Res.PersonalGroupId
               , Res.PersonalGroupName
               ,Res.MemberId
               ,Res.MemberName
               ,Res.SUM_MemberHours
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.SheetWorkTime_Amount
                ELSE NULL::TFloat END                          AS SheetWorkTime_Amount
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelCode
                ELSE NULL::Integer END                         AS ServiceModelCode
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelName
                ELSE NULL::TVarChar END                        AS ServiceModelName
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.Price
                ELSE NULL::TFloat END                          AS Price
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.FromName
                ELSE NULL::TVarChar END                         AS FromName
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.ToName
                ELSE NULL::TVarChar END                         AS ToName
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.MovementDescName
                ELSE NULL::TVarCHar END                         AS MovementDescName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_FromName
                ELSE NULL::TVarChar END                         AS ModelServiceItemChild_FromName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_ToName
                ELSE NULL::TVarChar END                         AS ModelServiceItemChild_ToName
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.OperDate 
                ELSE NULL::TDateTime END                  AS OperDate
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.Count_MemberInDay
                ELSE NULL::Integer END                    AS Count_MemberInDay
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.Gross
                ELSE NULL::TFloat END                     AS Gross
               ,SUM(Res.GrossOnOneMember)::TFloat         AS GrossOnOneMember
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.Amount
                ELSE NULL::TFloat END                     AS Amount
               ,SUM(Res.AmountOnOneMember)::TFloat        AS AmountOnOneMember
            FROM Res
            WHERE
                Res.MemberId is not null
            GROUP BY
                Res.StaffList
               ,Res.UnitId
               ,Res.UnitName
               ,Res.PositionId
               ,Res.PositionName
               ,Res.PositionLevelId
               ,Res.PositionLevelName
               ,Res.PersonalCount
               ,Res.HoursPlan
               ,Res.HoursDay
               , Res.PersonalGroupId
               , Res.PersonalGroupName
               ,Res.MemberId
               ,Res.MemberName
               ,Res.SUM_MemberHours
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.SheetWorkTime_Amount
                ELSE NULL::TFloat END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelCode
                ELSE NULL::Integer END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.Price
                ELSE NULL::TFloat END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.ToName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.MovementDescName
                ELSE NULL::TVarCHar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_ToName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.OperDate 
                ELSE NULL::TDateTime END
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.Count_MemberInDay
                ELSE NULL::Integer END
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.Gross
                ELSE NULL::TFloat END
               ,CASE WHEN inDetailDay = TRUE 
                     THEN Res.Amount
                ELSE NULL::TFloat END
        )
        SELECT
            tmpRes.StaffList
           ,tmpRes.UnitId
           ,tmpRes.UnitName
           ,tmpRes.PositionId
           ,tmpRes.PositionName
           ,tmpRes.PositionLevelId
           ,tmpRes.PositionLevelName
           ,tmpRes.PersonalCount
           ,tmpRes.HoursPlan
           ,tmpRes.HoursDay
           , tmpRes.PersonalGroupId
           , tmpRes.PersonalGroupName
           ,tmpRes.MemberId
           ,tmpRes.MemberName
           ,tmpRes.SUM_MemberHours
           ,tmpRes.SheetWorkTime_Amount
           ,tmpRes.ServiceModelCode
           ,tmpRes.ServiceModelName
           ,tmpRes.Price
           ,tmpRes.FromName
           ,tmpRes.ToName
           ,tmpRes.MovementDescName
           ,tmpRes.ModelServiceItemChild_FromName
           ,tmpRes.ModelServiceItemChild_ToName
           ,tmpRes.OperDate
           ,tmpRes.Count_MemberInDay
           ,tmpRes.Gross
           ,tmpRes.GrossOnOneMember
           ,ROUND (tmpRes.Amount, 2) :: TFloat            AS Amount
           ,ROUND (tmpRes.AmountOnOneMember, 2) :: TFloat AS AmountOnOneMember
           ,Object_PersonalServiceList.Id                 AS PersonalServiceListId
           ,Object_PersonalServiceList.ValueData          AS PersonalServiceListName
           ,SMOrd.ServiceModelOrd
           ,SMOrd_1.ServiceModelName as ServiceModelName_1
           ,SMOrd_2.ServiceModelName as ServiceModelName_2
           ,SMOrd_3.ServiceModelName as ServiceModelName_3
           ,SMOrd_4.ServiceModelName as ServiceModelName_4
        FROM
            tmpRes
            LEFT OUTER JOIN Object_Personal_View AS Object_Personal
                                                 ON COALESCE(Object_Personal.MemberId,0) = COALESCE(tmpRes.MemberId,0)
                                                AND COALESCE(Object_Personal.PositionId,0) = COALESCE(tmpRes.PositionId,0)
                                                AND COALESCE(Object_Personal.PositionLevelId,0) = COALESCE(tmpRes.PositionLevelId,0)
                                                AND COALESCE(Object_Personal.UnitId,0) = COALESCE(tmpRes.UnitId,0)
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                       ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.PersonalId
                                      AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
            LEFT OUTER JOIN Object AS Object_PersonalServiceList
                                   ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId
            LEFT OUTER JOIN SMOrd ON SMOrd.ServiceModelCode = tmpRes.ServiceModelCode
            LEFT OUTER JOIN SMOrd AS SMOrd_1 ON SMOrd_1.ServiceModelOrd = 1
            LEFT OUTER JOIN SMOrd AS SMOrd_2 ON SMOrd_2.ServiceModelOrd = 2
            LEFT OUTER JOIN SMOrd AS SMOrd_3 ON SMOrd_3.ServiceModelOrd = 3
            LEFT OUTER JOIN SMOrd AS SMOrd_4 ON SMOrd_4.ServiceModelOrd = 4
       ;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
Select * from gpSelect_Report_Wage(
    inDateStart      := '20150701'::TDateTime, --дата начала периода
    inDateFinal      := '20150731'::TDateTime, --дата окончания периода
    inUnitId         := 8448::Integer,   --подразделение 
    inModelServiceId := 0::Integer,   --модель начисления
    inMemberId       := 0::Integer,   --сотрудник
    inPositionId     := 0::Integer,   --должность
    inDetailDay      := TRUE,   --детализировать по дням
    inDetailModelService           := TRUE,   --детализировать по моделям
    inDetailModelServiceItemMaster := TRUE,   --детализировать по типам документов в модели
    inDetailModelServiceItemChild  := TRUE,
    inSession        := '5');
*/
