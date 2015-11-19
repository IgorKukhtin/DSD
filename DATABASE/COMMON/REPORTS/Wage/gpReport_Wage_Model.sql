DROP FUNCTION IF EXISTS gpSelect_Report_Wage_Model(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    Integer,   --модель начисления
    Integer,   --сотрудник
    Integer,   --должность
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage_Model(
    IN inDateStart      TDateTime, --дата начала периода
    IN inDateFinal      TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение 
    IN inModelServiceId Integer,   --модель начисления
    IN inMemberId       Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
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
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SheetWorkTime_Date             TDateTime
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
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;

    CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series(inDateStart, inDateFinal, '1 DAY'::interval) OperDate;
    CREATE TEMP TABLE Setting_Wage_1(
        StaffList Integer
       ,UnitId Integer
       ,UnitName TVarChar
       ,PositionId Integer
       ,PositionName TVarChar
       ,PositionLevelId Integer
       ,PositionLevelName TVarChar
       ,PersonalCount Integer
       ,HoursPlan TFloat
       ,HoursDay TFloat
       ,ServiceModelId Integer
       ,ServiceModelCode Integer
       ,ServiceModelName TVarChar
       ,Price TFloat
       ,FromId Integer
       ,FromName TVarChar
       ,ToId Integer
       ,ToName TVarChar
       ,MovementDescId Integer
       ,MovementDescName TVarChar
       ,SelectKindId Integer
       ,SelectKindCode Integer
       ,isActive Boolean
       ,SelectKindName TVarChar
       ,Ratio TFloat
       ,ModelServiceItemChild_FromId Integer
       ,ModelServiceItemChild_FromDescId Integer
       ,ModelServiceItemChild_FromName TVarChar
       ,ModelServiceItemChild_ToId Integer
       ,ModelServiceItemChild_ToDescId Integer
       ,ModelServiceItemChild_ToName TVarChar) ON COMMIT DROP;

    -- CREATE TEMP TABLE tmpMovement(
        -- OperDate TDateTime
       -- ,MovementDescId Integer
       -- ,isActive Boolean
       -- ,UnitFrom Integer
       -- ,UnitTo Integer
       -- ,GoodsFrom Integer
       -- ,GoodsTo Integer
       -- ,Amount TFloat) ON COMMIT DROP;

    INSERT INTO Setting_Wage_1(StaffList,UnitId,UnitName,PositionId,PositionName,PositionLevelId ,PositionLevelName,PersonalCount,HoursPlan,HoursDay,ServiceModelId,ServiceModelCode
                        ,ServiceModelName,Price,FromId,FromName,ToId,ToName,MovementDescId,MovementDescName,SelectKindId,SelectKindCode,isActive,SelectKindName
                        ,Ratio,ModelServiceItemChild_FromId,ModelServiceItemChild_FromDescId,ModelServiceItemChild_FromName,ModelServiceItemChild_ToId,ModelServiceItemChild_ToDescId,ModelServiceItemChild_ToName)
--Настройки
    SELECT
        Object_StaffList.Id                                 AS StaffList
       ,ObjectLink_StaffList_Unit.ChildObjectId             AS UnitId
       ,Object_Unit.ValueData                               AS UnitName
       ,ObjectLink_StaffList_Position.ChildObjectId         AS PositionId
       ,Object_Position.ValueData                           AS PositionName
       ,ObjectLink_StaffList_PositionLevel.ChildObjectId    AS PositionLevelId
       ,Object_PositionLevel.ValueData                      AS PositionLevelName
       ,ObjectFloat_PersonalCount.ValueData::Integer        AS PersonalCount
       ,ObjectFloat_HoursPlan.ValueData                     AS HoursPlan
       ,ObjectFloat_HoursDay.ValueData                      AS HoursDay
       ,ObjectLink_StaffListCost_ModelService.ChildObjectId AS ServiceModelId
       ,Object_ModelService.ObjectCode::Integer             AS ServiceModelCode
       ,Object_ModelService.ValueData                       AS ServiceModelName
       ,ObjectFloat_StaffListCost_Price.ValueData           AS Price
       ,Object_From.Id                                      AS FromId
       ,Object_From.ValueData                               AS FromName
       ,Object_To.Id                                        AS ToId
       ,Object_To.ValueData                                 AS ToName
       ,MovementDesc.Id                                     AS MovementDescId
       ,MovementDesc.ItemName                               AS MovementDescName
       ,Object_SelectKind.Id                                AS SelectKindId
       ,Object_SelectKind.ObjectCode                        AS SelectKindCode
       ,CASE 
            WHEN Object_SelectKind.ObjectCode = 3 
                THEN TRUE
            WHEN Object_SelectKind.ObjectCode = 4
                THEN FALSE
        END                                                 AS isActive
       ,Object_SelectKind.ValueData                         AS SelectKindName
       ,ObjectFloat_Ratio.ValueData                         AS Ratio
       ,ModelServiceItemChild_From.Id                       AS ModelServiceItemChild_FromId
       ,ModelServiceItemChild_From.DescId                   AS ModelServiceItemChild_FromDescId
       ,ModelServiceItemChild_From.ValueData                AS ModelServiceItemChild_FromName
       ,ModelServiceItemChild_To.Id                         AS ModelServiceItemChild_ToId
       ,ModelServiceItemChild_To.DescId                     AS ModelServiceItemChild_ToDescId
       ,ModelServiceItemChild_To.ValueData                  AS ModelServiceItemChild_ToName
    FROM
        Object as Object_StaffList
        --Unit подразделение
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                   ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                  AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
        LEFT OUTER JOIN Object AS Object_Unit
                               ON Object_Unit.Id = ObjectLink_StaffList_Unit.ChildObjectId
        --Position  должность
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                             ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
        LEFT JOIN Object AS Object_Position 
                         ON Object_Position.Id = ObjectLink_StaffList_Position.ChildObjectId
        --PositionLevel разряд должности
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                             ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
        LEFT JOIN Object AS Object_PositionLevel 
                         ON Object_PositionLevel.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
        --PersonalCount  кол-во сотрудников в подразделении/должности/разряде
        LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount 
                              ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
        --HoursPlan  1.Общ.пл.ч.в мес. на человека
        LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                              ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()
        --HoursDay  2.Дневной пл.ч. на человека
        LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay 
                              ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                             AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
        --StaffListCost
        INNER JOIN ObjectLink AS ObjectLink_StaffListCost_StaffList
                              ON ObjectLink_StaffListCost_StaffList.ChildObjectId = Object_StaffList.ID
                             AND ObjectLink_StaffListCost_StaffList.DescId = zc_ObjectLink_StaffListCost_StaffList()
        INNER JOIN Object AS Object_StaffListCost
                          ON Object_StaffListCost.Id = ObjectLink_StaffListCost_StaffList.ObjectId
                         AND Object_StaffListCost.isErased = FALSE
        --Price расценка
        LEFT JOIN ObjectFloat AS ObjectFloat_StaffListCost_Price 
                              ON ObjectFloat_StaffListCost_Price.ObjectId = Object_StaffListCost.Id 
                             AND ObjectFloat_StaffListCost_Price.DescId = zc_ObjectFloat_StaffListCost_Price()
        --ModelService  модель начисления
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffListCost_ModelService
                                   ON ObjectLink_StaffListCost_ModelService.ObjectId = Object_StaffListCost.Id
                                  AND ObjectLink_StaffListCost_ModelService.DescId = zc_ObjectLink_StaffListCost_ModelService()
        LEFT OUTER JOIN Object AS Object_ModelService
                               ON Object_ModelService.Id = ObjectLink_StaffListCost_ModelService.ChildObjectId
                              AND Object_ModelService.isErased = FALSE
        --ModelServiceItemMaster Типы документов для обработки
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_ModelService
                                   ON ObjectLink_ModelServiceItemMaster_ModelService.ChildObjectId = Object_ModelService.Id
                                  AND ObjectLink_ModelServiceItemMaster_ModelService.DescId = zc_ObjectLink_ModelServiceItemMaster_ModelService()
        LEFT OUTER JOIN OBJECT AS Object_ModelServiceItemMaster
                               ON ObjectLink_ModelServiceItemMaster_ModelService.ObjectId = Object_ModelServiceItemMaster.Id
                              AND Object_ModelServiceItemMaster.DescId = zc_Object_ModelServiceItemMaster()
                              AND Object_ModelServiceItemMaster.isErased = FALSE
        --Ftom  документы от кого
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_From
                                   ON ObjectLink_ModelServiceItemMaster_From.ObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_From.DescId = zc_ObjectLink_ModelServiceItemMaster_From()
        LEFT OUTER JOIN Object AS Object_From 
                               ON Object_From.Id = ObjectLink_ModelServiceItemMaster_From.ChildObjectId
        --To  документы кому
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_To
                                   ON ObjectLink_ModelServiceItemMaster_To.ObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_To.DescId = zc_ObjectLink_ModelServiceItemMaster_To()
        LEFT OUTER JOIN Object AS Object_To 
                               ON Object_To.Id = ObjectLink_ModelServiceItemMaster_To.ChildObjectId
        --SelectKind тип выбора
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_SelectKind
                                   ON ObjectLink_ModelServiceItemMaster_SelectKind.ObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_SelectKind.DescId = zc_ObjectLink_ModelServiceItemMaster_SelectKind()
        LEFT OUTER JOIN Object AS Object_SelectKind 
                               ON Object_SelectKind.Id = ObjectLink_ModelServiceItemMaster_SelectKind.ChildObjectId
        --MovementDesc  Тип документа
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_MovementDesc 
                                    ON ObjectFloat_MovementDesc.ObjectId = Object_ModelServiceItemMaster.Id 
                                   AND ObjectFloat_MovementDesc.DescId = zc_ObjectFloat_ModelServiceItemMaster_MovementDesc()
        LEFT OUTER JOIN MovementDesc ON MovementDesc.Id = ObjectFloat_MovementDesc.ValueData
        --Ratio Коэфициент
        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Ratio 
                                    ON ObjectFloat_Ratio.ObjectId = Object_ModelServiceItemMaster.Id 
                                   AND ObjectFloat_Ratio.DescId = zc_ObjectFloat_ModelServiceItemMaster_Ratio()
        --ограничения по товару / группе
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ModelServiceItemMaster
                                   ON ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ChildObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.DescId = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()
        LEFT OUTER JOIN OBJECT AS Object_ModelServiceItemChild
                               ON Object_ModelServiceItemChild.Id = ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ObjectId
                              AND Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild()
                              AND Object_ModelServiceItemChild.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                                   ON ObjectLink_ModelServiceItemChild_From.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_ModelServiceItemChild_From.DescId = zc_ObjectLink_ModelServiceItemChild_From()
        LEFT OUTER JOIN Object AS ModelServiceItemChild_From 
                               ON ModelServiceItemChild_From.Id = ObjectLink_ModelServiceItemChild_From.ChildObjectId
                              AND ModelServiceItemChild_From.isErased = FALSE 
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                                   ON ObjectLink_ModelServiceItemChild_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_ModelServiceItemChild_To.DescId = zc_ObjectLink_ModelServiceItemChild_To()
        LEFT JOIN Object AS ModelServiceItemChild_To
                         ON ModelServiceItemChild_To.Id = ObjectLink_ModelServiceItemChild_To.ChildObjectId
                        AND ModelServiceItemChild_To.isErased = FALSE
    WHERE
        Object_StaffList.DescId = zc_Object_StaffList()
        AND
        (
            ObjectLink_StaffList_Unit.ChildObjectId = inUnitId
            OR
            inUnitId = 0
        )
        AND
        (
            ObjectLink_StaffList_Position.ChildObjectId = inPositionId
            OR
            inPositionId = 0
        )
        AND
        (
            ObjectLink_StaffListCost_ModelService.ChildObjectId = inModelServiceId
            OR
            inModelServiceId = 0
        );

    --Insert Into tmpMovement(OperDate,MovementDescId,isActive,UnitFrom,UnitTo,GoodsFrom,GoodsTo,Amount)
    
    RETURN QUERY
    WITH tmpMovement AS 
    (
        SELECT
            date_trunc('day',MovementItemContainer.OperDate)::TDateTime AS OperDate
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE
                    THEN MovementItemContainer.ObjectExtId_Analyzer
            ELSE MovementItemContainer.WhereObjectId_Analyzer
            END AS UnitFrom
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE
                    THEN MovementItemContainer.WhereObjectId_Analyzer
            ELSE MovementItemContainer.ObjectExtId_Analyzer
            END AS UnitTo
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE 
                    THEN NULL::Integer
            ELSE MovementItemContainer.ObjectId_Analyzer
            END AS GoodsFrom
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE
                    THEN MovementItemContainer.ObjectId_Analyzer
            ELSE Container.ObjectId
            END AS GoodsTo
           ,SUM(CASE 
                    WHEN MovementItemContainer.IsActive = TRUE
                        THEN MovementItemContainer.Amount
                ELSE -MovementItemContainer.Amount
                END)::TFloat as Amount
        FROM
            (
                Select Distinct 
                    Setting.MovementDescId
                from 
                     Setting_Wage_1 as Setting
                Where 
                    Setting.MovementDescId is not null
            ) as SettingDesc
            Inner Join MovementItemContainer ON SettingDesc.MovementDescId = MovementItemContainer.MovementDescId
                                            AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                            AND date_trunc('day',MovementItemContainer.OperDate) between inDateStart AND inDateFinal
            LEFT OUTER JOIN Container ON MovementItemContainer.ContainerId_Analyzer = Container.Id
        GROUP BY
            date_trunc('day',MovementItemContainer.OperDate)::TDateTime
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE
                    THEN MovementItemContainer.ObjectExtId_Analyzer
            ELSE MovementItemContainer.WhereObjectId_Analyzer
            END
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE 
                    THEN MovementItemContainer.WhereObjectId_Analyzer
            ELSE MovementItemContainer.ObjectExtId_Analyzer
            END
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE 
                    THEN NULL::Integer
            ELSE MovementItemContainer.ObjectId_Analyzer
            END
           ,CASE 
                WHEN MovementItemContainer.IsActive = TRUE 
                    THEN MovementItemContainer.ObjectId_Analyzer
            ELSE Container.ObjectId
            END
    ),
    ServiceModelMovement AS
    (
        SELECT
            Setting.StaffList
           ,Setting.UnitId
           ,Setting.PositionId
           ,Setting.PositionLevelId
           ,Setting.ServiceModelId
           ,Setting.Price
           ,Setting.FromId
           ,Setting.ToId
           ,Setting.MovementDescId
           ,Setting.SelectKindCode
           ,Setting.SelectKindId
           ,Setting.ModelServiceItemChild_FromId
           ,Setting.ModelServiceItemChild_ToId
           ,tmpMovement.OperDate as OperDate
           ,SUM(tmpMovement.Amount)::TFloat AS Gross
           ,ROUND(Setting.Price * Setting.Ratio * SUM(tmpMovement.Amount), 2)::TFloat AS Amount
        FROM
            Setting_Wage_1 as Setting
            INNER JOIN tmpMovement ON tmpMovement.MovementDescId = Setting.MovementDescId
                                  AND tmpMovement.IsActive = Setting.IsActive
        WHERE
            (
                Setting.FromId is null
                OR
                tmpMovement.UnitFrom in (Select UnitTree.UnitId from lfSelect_Object_Unit_byGroup(Setting.FromId) as UnitTree)
            )
            AND
            (
                Setting.ToId is null
                OR
                tmpMovement.UnitTo in (Select UnitTree.UnitId from lfSelect_Object_Unit_byGroup(Setting.ToId) as UnitTree)
            )
            AND
            (
                Setting.ModelServiceItemChild_FromId is null
                OR
                (
                    Setting.ModelServiceItemChild_FromDescId = zc_Object_Goods()
                    AND
                    tmpMovement.GoodsFrom = Setting.ModelServiceItemChild_FromId
                )
                OR
                (
                    Setting.ModelServiceItemChild_FromDescId = zc_Object_GoodsGroup()
                    AND
                    tmpMovement.GoodsFrom in (Select GoodsTree.GoodsId from lfSelect_Object_Goods_byGoodsGroup(Setting.ModelServiceItemChild_FromId) as GoodsTree)
                )
            )
            AND
            (
                Setting.ModelServiceItemChild_ToId is null
                OR
                (
                    Setting.ModelServiceItemChild_ToDescId = zc_Object_Goods()
                    AND
                    tmpMovement.GoodsTo = Setting.ModelServiceItemChild_ToId
                )
                OR
                (
                    Setting.ModelServiceItemChild_ToDescId = zc_Object_GoodsGroup()
                    AND
                    tmpMovement.GoodsTo in (Select GoodsTree.GoodsId from lfSelect_Object_Goods_byGoodsGroup(Setting.ModelServiceItemChild_ToId) AS GoodsTree)
                )
            )
        GROUP BY
            Setting.StaffList
           ,Setting.UnitId
           ,Setting.PositionId
           ,Setting.PositionLevelId
           ,Setting.ServiceModelId
           ,Setting.Price
           ,Setting.FromId
           ,Setting.ToId
           ,Setting.MovementDescId
           ,Setting.SelectKindId
           ,Setting.SelectKindCode
           ,Setting.ModelServiceItemChild_FromId
           ,Setting.ModelServiceItemChild_ToId
           ,tmpMovement.OperDate
           ,Setting.Price 
           ,Setting.Ratio
    ),
--табель
    Movement_SheetWorkTime AS
    (
        SELECT
            date_trunc('day',Movement.OperDate)::TDateTime AS SheetWorkTime_Date
           ,MI_SheetWorkTime.ObjectId       AS MemberId
           ,Object_Member.ValueData         AS MemberName
           ,MIObject_Position.ObjectId      AS PositionId
           ,MIObject_PositionLevel.ObjectId AS PositionLevelId
           ,MI_SheetWorkTime.Amount         AS SheetWorkTime_Amount
           ,COUNT(*) OVER(PARTITION BY Movement.OperDate,MIObject_Position.ObjectId,MIObject_PositionLevel.ObjectId) as Count_MemberInDay
        FROM
            Movement
            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            INNER JOIN MovementItem AS MI_SheetWorkTime 
                                    ON MI_SheetWorkTime.MovementId = Movement.Id
            INNER JOIN Object AS Object_Member
                              ON Object_Member.Id = MI_SheetWorkTime.ObjectId
            LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                   ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                  AND MIObject_Position.DescId = zc_MILinkObject_Position() 
            LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                   ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                  AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
            INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                              ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                             AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
            INNER JOIN Object_WorkTimeKind_Wages_View AS Object_WorkTimeKind
                                                      ON Object_WorkTimeKind.Id = MIObject_WorkTimeKind.ObjectId
            
        WHERE 
            Movement.DescId = zc_Movement_SheetWorkTime()
            AND
            date_trunc('day',Movement.OperDate) between inDateStart AND inDateFinal
            AND
            (
                MovementLinkObject_Unit.ObjectId = inUnitId
                OR
                inUnitId = 0
            )
            AND
            (
                MIObject_Position.ObjectId = inPositionId
                OR
                inPositionId = 0
            )
            AND
            (
                MI_SheetWorkTime.ObjectId = inMemberId
                OR
                inMemberId = 0
            )
    )
    SELECT 
        Setting.StaffList
       ,Setting.UnitId
       ,Setting.UnitName
       ,Setting.PositionId
       ,Setting.PositionName
       ,Setting.PositionLevelId
       ,Setting.PositionLevelName
       ,Setting.PersonalCount
       ,Setting.HoursPlan
       ,Setting.HoursDay
       ,Movement_SheetWorkTime.MemberId
       ,Movement_SheetWorkTime.MemberName
       ,Movement_SheetWorkTime.SheetWorkTime_Date
       ,Movement_SheetWorkTime.SheetWorkTime_Amount
       ,Setting.ServiceModelId
       ,Setting.ServiceModelCode
       ,Setting.ServiceModelName
       ,Setting.Price
       ,Setting.FromId
       ,Setting.FromName
       ,Setting.ToId
       ,Setting.ToName
       ,Setting.MovementDescId
       ,Setting.MovementDescName
       ,Setting.SelectKindId
       ,Setting.SelectKindName
       ,Setting.Ratio
       ,Setting.ModelServiceItemChild_FromId
       ,Setting.ModelServiceItemChild_FromDescId
       ,Setting.ModelServiceItemChild_FromName
       ,Setting.ModelServiceItemChild_ToId
       ,Setting.ModelServiceItemChild_ToDescId
       ,Setting.ModelServiceItemChild_ToName
       ,tmpOperDate.OperDate::TDateTime
       ,Movement_SheetWorkTime.Count_MemberInDay::Integer
       ,ServiceModelMovement.Gross
       ,(ServiceModelMovement.Gross / Movement_SheetWorkTime.Count_MemberInDay)::TFloat AS GrossOnOneMember
       ,ServiceModelMovement.Amount
       ,ROUND(ServiceModelMovement.Amount / Movement_SheetWorkTime.Count_MemberInDay,2)::TFloat as AmountOnOneMember
    FROM Setting_Wage_1 AS Setting
        CROSS JOIN tmpOperDate
        LEFT OUTER JOIN Movement_SheetWorkTime ON COALESCE(Movement_SheetWorkTime.PositionId,0) = COALESCE(Setting.PositionId,0)
                                              AND COALESCE(Movement_SheetWorkTime.PositionLevelId,0) = COALESCE(Setting.PositionLevelId,0)
                                              AND tmpOperDate.OperDate = Movement_SheetWorkTime.SheetWorkTime_Date
        LEFT OUTER JOIN ServiceModelMovement ON COALESCE(Setting.StaffList,0) = COALESCE(ServiceModelMovement.StaffList,0)
                                            AND COALESCE(Setting.UnitId,0) = COALESCE(ServiceModelMovement.UnitId,0)
                                            AND COALESCE(Setting.PositionId,0) = COALESCE(ServiceModelMovement.PositionId,0)
                                            AND COALESCE(Setting.PositionLevelId,0) = COALESCE(ServiceModelMovement.PositionLevelId,0)
                                            AND COALESCE(Setting.ServiceModelId,0) = COALESCE(ServiceModelMovement.ServiceModelId,0)
                                            AND COALESCE(Setting.Price,0) = COALESCE(ServiceModelMovement.Price,0)
                                            AND COALESCE(Setting.FromId,0) = COALESCE(ServiceModelMovement.FromId,0)
                                            AND COALESCE(Setting.ToId,0) = COALESCE(ServiceModelMovement.ToId,0)
                                            AND COALESCE(Setting.MovementDescId,0) = COALESCE(ServiceModelMovement.MovementDescId,0)
                                            AND COALESCE(Setting.SelectKindId,0) = COALESCE(ServiceModelMovement.SelectKindId,0)
                                            AND COALESCE(Setting.ModelServiceItemChild_FromId,0) = COALESCE(ServiceModelMovement.ModelServiceItemChild_FromId,0)
                                            AND COALESCE(Setting.ModelServiceItemChild_ToId,0) = COALESCE(ServiceModelMovement.ModelServiceItemChild_ToId,0)
                                            AND tmpOperDate.OperDate = ServiceModelMovement.OperDate
--------------------------------------------------------------------------------------------------
    ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Wage_Model (TDateTime,TDateTime,Integer,Integer,Integer,Integer,TVarChar) OWNER TO postgres;

/*
Select * from gpSelect_Report_Wage_Model(
    inDateStart      := '20150701'::TDateTime, --дата начала периода
    inDateFinal      := '20150731'::TDateTime, --дата окончания периода
    inUnitId         := 8448::Integer,   --подразделение 
    inModelServiceId := 0::Integer,   --модель начисления
    inMemberId     := 0::Integer,   --сотрудник
    inPositionId     := 0::Integer,   --должность
    inSession        := '5');
*/    