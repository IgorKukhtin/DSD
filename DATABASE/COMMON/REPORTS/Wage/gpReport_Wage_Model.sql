-- По штатному расписанию - из Модели + из Табеля - По проводкам кол-во
-- Function: gpSelect_Report_Wage_Model ()

DROP FUNCTION IF EXISTS gpSelect_Report_Wage_Model (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage_Model(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение
    IN inModelServiceId Integer,   --модель начисления
    IN inMemberId       Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     StaffListId                    Integer
    ,DocumentKindId                 Integer
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,Count_Member                   Integer   -- Кол-во человек (все)
    ,HoursPlan                      TFloat
    ,HoursDay                       TFloat
    ,PersonalGroupId                Integer
    ,PersonalGroupName              TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SheetWorkTime_Date             TDateTime
    ,SUM_MemberHours                TFloat     -- итого часов всех сотрудников (с этой должностью+...) - !!!инф.!!!
    ,SheetWorkTime_Amount           TFloat     -- итого часов сотрудника - !!!инф.!!!
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
    ,ModelServiceItemChild_FromDescId Integer
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToId     Integer
    ,ModelServiceItemChild_ToDescId Integer
    ,ModelServiceItemChild_ToName   TVarChar

    ,StorageLineId_From             Integer
    ,StorageLineName_From           TVarChar
    ,StorageLineId_To               Integer
    ,StorageLineName_To             TVarChar
    ,GoodsKind_FromId               Integer
    ,GoodsKind_FromName             TVarChar
    ,GoodsKindComplete_FromId       Integer
    ,GoodsKindComplete_FromName     TVarChar
    ,GoodsKind_ToId                 Integer
    ,GoodsKind_ToName               TVarChar
    ,GoodsKindComplete_ToId         Integer
    ,GoodsKindComplete_ToName       TVarChar

    ,OperDate                       TDateTime
    ,Count_Day                      Integer   -- Отраб. дн. 1 чел (инф.)
    ,Count_MemberInDay              Integer   -- Кол-во человек (за 1 д.)
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

    -- список дней
    /*CREATE TEMP TABLE tmpOperDate ON COMMIT DROP
       AS SELECT generate_series (inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate;*/

    -- Таблица - Данные для расчета
    /*CREATE TEMP TABLE Setting_Wage_1(
        StaffListId     Integer
       ,DocumentKindId  Integer
       ,UnitId          Integer
       ,UnitName        TVarChar
       ,PositionId Integer
       ,PositionName TVarChar
       ,isPositionLevel_all Boolean
       ,PositionLevelId Integer
       ,PositionLevelName TVarChar
       ,Count_Member Integer
       ,HoursPlan TFloat
       ,HoursDay TFloat
       ,ServiceModelKindId Integer
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
       ,SelectKindName TVarChar
       ,isActive Boolean
       ,Ratio TFloat
       ,ModelServiceItemChild_FromId     Integer
       ,ModelServiceItemChild_FromDescId Integer
       ,ModelServiceItemChild_FromName   TVarChar
       ,ModelServiceItemChild_ToId       Integer
       ,ModelServiceItemChild_ToDescId   Integer
       ,ModelServiceItemChild_ToName     TVarChar
       ,StorageLineId_From               Integer
       ,StorageLineName_From             TVarChar
       ,StorageLineId_To                 Integer
       ,StorageLineName_To               TVarChar
       ,GoodsKind_FromId                 Integer
       ,GoodsKind_FromName               TVarChar
       ,GoodsKindComplete_FromId         Integer
       ,GoodsKindComplete_FromName       TVarChar
       ,GoodsKind_ToId                   Integer
       ,GoodsKind_ToName                 TVarChar
       ,GoodsKindComplete_ToId           Integer
       ,GoodsKindComplete_ToName         TVarChar
       ) ON COMMIT DROP;*/


    -- Результат
    RETURN QUERY

    WITH tmpOperDate AS (SELECT generate_series (inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate)
              -- получили Настройки
            , Setting_Wage_1 /*(StaffListId, DocumentKindId, UnitId,UnitName,PositionId,PositionName, isPositionLevel_all, PositionLevelId, PositionLevelName, Count_Member,HoursPlan,HoursDay, ServiceModelKindId, ServiceModelId,ServiceModelCode
                              , ServiceModelName,Price,FromId,FromName,ToId,ToName,MovementDescId,MovementDescName, SelectKindId, SelectKindCode, SelectKindName, isActive
                              , Ratio,ModelServiceItemChild_FromId,ModelServiceItemChild_FromDescId,ModelServiceItemChild_FromName,ModelServiceItemChild_ToId,ModelServiceItemChild_ToDescId,ModelServiceItemChild_ToName
                              , StorageLineId_From, StorageLineName_From, StorageLineId_To, StorageLineName_To
                              , GoodsKind_FromId, GoodsKind_FromName, GoodsKindComplete_FromId, GoodsKindComplete_FromName
                              , GoodsKind_ToId, GoodsKind_ToName, GoodsKindComplete_ToId, GoodsKindComplete_ToName
                               )*/
AS  (SELECT
        Object_StaffList.Id                                 AS StaffListId            -- Штатное расписание
       ,COALESCE (ObjectLink_ModelServiceItemMaster_DocumentKind.ChildObjectId, 0) AS DocumentKindId
       ,ObjectLink_StaffList_Unit.ChildObjectId             AS UnitId                 -- Поразделение
       ,Object_Unit.ValueData                               AS UnitName
       ,ObjectLink_StaffList_Position.ChildObjectId         AS PositionId             -- Должность
       ,Object_Position.ValueData                           AS PositionName
       ,COALESCE (ObjectBoolean_PositionLevel.ValueData, FALSE) AS isPositionLevel_all
       ,CASE WHEN ObjectBoolean_PositionLevel.ValueData = TRUE THEN 0 ELSE ObjectLink_StaffList_PositionLevel.ChildObjectId END AS PositionLevelId -- Разряд должности
       ,Object_PositionLevel.ValueData                      AS PositionLevelName
       ,ObjectFloat_PersonalCount.ValueData::Integer        AS Count_Member          -- !!!информативно!!! кол-во сотрудников (из справочника Штатное расписание)
       ,ObjectFloat_HoursPlan.ValueData                     AS HoursPlan              -- !!!информативно!!! 1.Общий план часов в месяц на человека (из справочника Штатное расписание)
       ,ObjectFloat_HoursDay.ValueData                      AS HoursDay               -- !!!информативно!!! 2.Дневной план часов на человека (из справочника Штатное расписание)
       ,ObjectLink_ModelService_ModelServiceKind.ChildObjectId AS ServiceModelKindId  -- Тип модели начисления
       ,ObjectLink_StaffListCost_ModelService.ChildObjectId    AS ServiceModelId      -- Модель начисления
       ,Object_ModelService.ObjectCode::Integer                AS ServiceModelCode
       ,Object_ModelService.ValueData                          AS ServiceModelName
       ,ObjectFloat_StaffListCost_Price.ValueData           AS Price                  -- Расценка грн./кг. (из справочника Расценки штатного расписания для Модель начисления)
       ,Object_From.Id                                      AS FromId                 -- Подразделение(От кого) (из справочника Главные элементы Модели начисления)
       ,Object_From.ValueData                               AS FromName
       ,Object_To.Id                                        AS ToId                   -- Подразделение(Кому) (из справочника Главные элементы Модели начисления)
       ,Object_To.ValueData                                 AS ToName
       ,MovementDesc.Id                                     AS MovementDescId         -- Код документа (из справочника Главные элементы Модели начисления)
       ,MovementDesc.ItemName                               AS MovementDescName
       ,Object_SelectKind.Id                                AS SelectKindId           -- Тип выбора данных (из справочника Главные элементы Модели начисления)
       ,Object_SelectKind.ObjectCode                        AS SelectKindCode
       ,Object_SelectKind.ValueData                         AS SelectKindName
       ,CASE WHEN MovementDesc.Id = zc_Movement_Send()
                  THEN FALSE
             WHEN Object_SelectKind.Id IN (zc_Enum_SelectKind_InAmount(), zc_Enum_SelectKind_InWeight(), zc_Enum_SelectKind_InHead()) -- Кол-во приход
                  THEN TRUE
              WHEN Object_SelectKind.Id IN (zc_Enum_SelectKind_OutAmount(), zc_Enum_SelectKind_OutWeight(), zc_Enum_SelectKind_OutHead()) -- Кол-во расход
                  THEN FALSE
        END                                                 AS isActive              -- Тип выбора данных
       ,ObjectFloat_Ratio.ValueData                         AS Ratio                 -- Коэффициент для выбора данных
       ,ModelServiceItemChild_From.Id                       AS ModelServiceItemChild_FromId       -- Товар,Группа(От кого) (из справочника Подчиненные элементы Модели начисления)
       ,ModelServiceItemChild_From.DescId                   AS ModelServiceItemChild_FromDescId
       ,ModelServiceItemChild_From.ValueData                AS ModelServiceItemChild_FromName
       ,ModelServiceItemChild_To.Id                         AS ModelServiceItemChild_ToId         -- Товар,Группа(Кому) (из справочника Подчиненные элементы Модели начисления)
       ,ModelServiceItemChild_To.DescId                     AS ModelServiceItemChild_ToDescId
       ,ModelServiceItemChild_To.ValueData                  AS ModelServiceItemChild_ToName

       , Object_StorageLine_From.Id              AS StorageLineId_From
       , Object_StorageLine_From.ValueData       AS StorageLineName_From
       , Object_StorageLine_To.Id                AS StorageLineId_To
       , Object_StorageLine_To.ValueData         AS StorageLineName_To

       , Object_GoodsKind_From.Id                AS GoodsKind_FromId
       , Object_GoodsKind_From.ValueData         AS GoodsKind_FromName
       , Object_GoodsKindComplete_From.Id        AS GoodsKindComplete_FromId
       , Object_GoodsKindComplete_From.ValueData AS GoodsKindComplete_FromName
       , Object_GoodsKind_To.Id                  AS GoodsKind_ToId
       , Object_GoodsKind_To.ValueData           AS GoodsKind_ToName
       , Object_GoodsKindComplete_To.Id          AS GoodsKindComplete_ToId
       , Object_GoodsKindComplete_To.ValueData   AS GoodsKindComplete_ToName

    FROM Object as Object_StaffList
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionLevel
                                ON ObjectBoolean_PositionLevel.ObjectId = Object_StaffList.Id
                               AND ObjectBoolean_PositionLevel.DescId = zc_ObjectBoolean_StaffList_PositionLevel()
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
        INNER JOIN Object AS Object_ModelService
                          ON Object_ModelService.Id = ObjectLink_StaffListCost_ModelService.ChildObjectId
                         AND Object_ModelService.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelService_ModelServiceKind
                                   ON ObjectLink_ModelService_ModelServiceKind.ObjectId = Object_ModelService.Id
                                  AND ObjectLink_ModelService_ModelServiceKind.DescId = zc_ObjectLink_ModelService_ModelServiceKind()
        --ModelServiceItemMaster Типы документов для обработки
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_ModelService
                                   ON ObjectLink_ModelServiceItemMaster_ModelService.ChildObjectId = Object_ModelService.Id
                                  AND ObjectLink_ModelServiceItemMaster_ModelService.DescId = zc_ObjectLink_ModelServiceItemMaster_ModelService()


        INNER JOIN Object AS Object_ModelServiceItemMaster
                          ON Object_ModelServiceItemMaster.Id       = ObjectLink_ModelServiceItemMaster_ModelService.ObjectId
                         AND Object_ModelServiceItemMaster.DescId   = zc_Object_ModelServiceItemMaster()
                         AND Object_ModelServiceItemMaster.isErased = FALSE

        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_DocumentKind
                                   ON ObjectLink_ModelServiceItemMaster_DocumentKind.ChildObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_DocumentKind.DescId = zc_ObjectLink_ModelServiceItemMaster_DocumentKind()

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
        INNER JOIN Object AS Object_ModelServiceItemChild
                          ON Object_ModelServiceItemChild.Id = ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ObjectId
                         AND Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild()
                         AND Object_ModelServiceItemChild.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                                   ON ObjectLink_ModelServiceItemChild_From.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_ModelServiceItemChild_From.DescId = zc_ObjectLink_ModelServiceItemChild_From()
        LEFT OUTER JOIN Object AS ModelServiceItemChild_From
                               ON ModelServiceItemChild_From.Id = ObjectLink_ModelServiceItemChild_From.ChildObjectId
                              -- AND ModelServiceItemChild_From.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                                   ON ObjectLink_ModelServiceItemChild_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_ModelServiceItemChild_To.DescId = zc_ObjectLink_ModelServiceItemChild_To()
        LEFT JOIN Object AS ModelServiceItemChild_To
                         ON ModelServiceItemChild_To.Id = ObjectLink_ModelServiceItemChild_To.ChildObjectId
                        -- AND ModelServiceItemChild_To.isErased = FALSE

        LEFT OUTER JOIN ObjectLink AS ObjectLink_StorageLine_From
                                   ON ObjectLink_StorageLine_From.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_StorageLine_From.DescId = zc_ObjectLink_ModelServiceItemChild_FromStorageLine()
        LEFT OUTER JOIN Object AS Object_StorageLine_From
                               ON Object_StorageLine_From.Id = ObjectLink_StorageLine_From.ChildObjectId
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StorageLine_To
                                   ON ObjectLink_StorageLine_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_StorageLine_To.DescId = zc_ObjectLink_ModelServiceItemChild_ToStorageLine()
        LEFT OUTER JOIN Object AS Object_StorageLine_To
                               ON Object_StorageLine_To.Id = ObjectLink_StorageLine_To.ChildObjectId

        LEFT OUTER JOIN ObjectLink AS ObjectLink_GoodsKind_From
                                   ON ObjectLink_GoodsKind_From.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_GoodsKind_From.DescId = zc_ObjectLink_ModelServiceItemChild_FromGoodsKind()
        LEFT OUTER JOIN Object AS Object_GoodsKind_From
                               ON Object_GoodsKind_From.Id = ObjectLink_GoodsKind_From.ChildObjectId
                              -- AND Object_GoodsKind_From.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_GoodsKind_To
                                   ON ObjectLink_GoodsKind_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_GoodsKind_To.DescId = zc_ObjectLink_ModelServiceItemChild_ToGoodsKind()
        LEFT OUTER JOIN Object AS Object_GoodsKind_To
                               ON Object_GoodsKind_To.Id = ObjectLink_GoodsKind_To.ChildObjectId
                              -- AND Object_GoodsKind_To.isErased = FALSE

        LEFT OUTER JOIN ObjectLink AS ObjectLink_GoodsKindComplete_From
                                   ON ObjectLink_GoodsKindComplete_From.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_GoodsKindComplete_From.DescId = zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete()
        LEFT OUTER JOIN Object AS Object_GoodsKindComplete_From
                               ON Object_GoodsKindComplete_From.Id = ObjectLink_GoodsKindComplete_From.ChildObjectId
                              -- AND Object_GoodsKindComplete_From.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_GoodsKindComplete_To
                                   ON ObjectLink_GoodsKindComplete_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_GoodsKindComplete_To.DescId = zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete()
        LEFT OUTER JOIN Object AS Object_GoodsKindComplete_To
                               ON Object_GoodsKindComplete_To.Id = ObjectLink_GoodsKindComplete_To.ChildObjectId
                              -- AND Object_GoodsKindComplete_To.isErased = FALSE

    WHERE Object_StaffList.DescId = zc_Object_StaffList()
        AND (ObjectLink_StaffList_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
        AND (ObjectLink_StaffList_Position.ChildObjectId = inPositionId OR inPositionId = 0)
        AND (ObjectLink_StaffListCost_ModelService.ChildObjectId = inModelServiceId OR inModelServiceId = 0)
   )

         -- ВСЕ документы для расчета по Расценкам грн./кг. - по MovementId
       , tmpMovement_all AS
       (SELECT
            MovementItemContainer.OperDate
           ,MovementItemContainer.MovementId
           ,DATE_PART ('ISODOW', MovementItemContainer.OperDate)  AS OperDate_num
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive

           ,COALESCE (MLO_DocumentKind.ObjectId, 0) AS DocumentKindId

           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectExtId_Analyzer
                 ELSE MovementItemContainer.WhereObjectId_Analyzer
            END AS FromId
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.WhereObjectId_Analyzer
                 ELSE MovementItemContainer.ObjectExtId_Analyzer
            END AS ToId

           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectId_Analyzer -- NULL::Integer
                 ELSE MovementItemContainer.ObjectId_Analyzer
            END AS GoodsId_from
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectId_Analyzer
                 ELSE Container.ObjectId
            END AS GoodsId_to

           ,SUM (CASE  WHEN MovementItemContainer.IsActive = TRUE
                            THEN MovementItemContainer.Amount
                       ELSE -1 * MovementItemContainer.Amount
                 END)::TFloat as Amount

           , MovementItemContainer.ObjectIntId_Analyzer AS GoodsKindId

           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN MovementItemContainer.ObjectIntId_Analyzer -- NULL::Integer
                  ELSE MovementItemContainer.ObjectIntId_Analyzer
             END AS GoodsKind_FromId
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN OL_GoodsKindComplete_master.ChildObjectId -- NULL::Integer
                  ELSE OL_GoodsKindComplete_master.ChildObjectId
             END AS GoodsKindComplete_FromId
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN MovementItemContainer.ObjectIntId_Analyzer
                  ELSE CLO_GoodsKind.ObjectId
             END AS GoodsKind_ToId
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN OL_GoodsKindComplete_master.ChildObjectId
                  ELSE OL_GoodsKindComplete.ChildObjectId
             END AS GoodsKindComplete_ToId

           , CASE WHEN MovementItemContainer.IsActive = FALSE
                       THEN MILO_StorageLine.ObjectId
                  ELSE 0
             END AS StorageLineId_From
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN MILO_StorageLine.ObjectId
                  ELSE 0
             END AS StorageLineId_To

        FROM (SELECT DISTINCT
                     Setting.MovementDescId
              FROM Setting_Wage_1 as Setting
              WHERE Setting.MovementDescId IS NOT NULL
                AND Setting.SelectKindId NOT IN (zc_Enum_SelectKind_MI_Master(), zc_Enum_SelectKind_MI_MasterCount(), zc_Enum_SelectKind_MovementCount())
             ) AS SettingDesc
             INNER JOIN MovementItemContainer ON MovementItemContainer.MovementDescId = SettingDesc.MovementDescId
                                             AND MovementItemContainer.DescId         = zc_MIContainer_Count()
                                             AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
             LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionGoods_master ON CLO_PartionGoods_master.ContainerId = MovementItemContainer.ContainerId
                                                                           AND CLO_PartionGoods_master.DescId      = zc_ContainerLinkObject_PartionGoods()
             LEFT OUTER JOIN ObjectLink AS OL_GoodsKindComplete_master ON OL_GoodsKindComplete_master.ObjectId = CLO_PartionGoods_master.ObjectId
                                                                      AND OL_GoodsKindComplete_master.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()

             LEFT OUTER JOIN Container ON Container.Id = COALESCE (MovementItemContainer.ContainerIntId_Analyzer, MovementItemContainer.ContainerId_Analyzer)
             LEFT OUTER JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                 AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
             LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                    AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
             LEFT OUTER JOIN ObjectLink AS OL_GoodsKindComplete ON OL_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                                               AND OL_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()
             LEFT OUTER JOIN MovementLinkObject AS MLO_DocumentKind ON MLO_DocumentKind.MovementId = MovementItemContainer.MovementId
                                                                   AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
             LEFT OUTER JOIN MovementItemLinkObject AS MILO_StorageLine ON MILO_StorageLine.MovementItemId = MovementItemContainer.MovementItemId
                                                                       AND MILO_StorageLine.DescId     = zc_MILinkObject_StorageLine()
        GROUP BY
            MovementItemContainer.OperDate
           ,MovementItemContainer.MovementId
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive
           ,MLO_DocumentKind.ObjectId
           ,MovementItemContainer.ObjectIntId_Analyzer
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
                    THEN MovementItemContainer.ObjectId_Analyzer -- NULL::Integer
            ELSE MovementItemContainer.ObjectId_Analyzer
            END
           ,CASE
                WHEN MovementItemContainer.IsActive = TRUE
                    THEN MovementItemContainer.ObjectId_Analyzer
            ELSE Container.ObjectId
            END

           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN MovementItemContainer.ObjectIntId_Analyzer -- NULL::Integer
                  ELSE MovementItemContainer.ObjectIntId_Analyzer
             END
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN OL_GoodsKindComplete_master.ChildObjectId -- NULL::Integer
                  ELSE OL_GoodsKindComplete_master.ChildObjectId
             END
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN MovementItemContainer.ObjectIntId_Analyzer
                  ELSE CLO_GoodsKind.ObjectId
             END
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN OL_GoodsKindComplete_master.ChildObjectId
                  ELSE OL_GoodsKindComplete.ChildObjectId
             END
           , CASE WHEN MovementItemContainer.IsActive = FALSE
                       THEN MILO_StorageLine.ObjectId
                  ELSE 0
             END
           , CASE WHEN MovementItemContainer.IsActive = TRUE
                       THEN MILO_StorageLine.ObjectId
                  ELSE 0
             END
       )
         -- Документы разделения - поиск мастера
       , tmpGoodsMaster_out AS
       (SELECT tmpMovementList.MovementId, MAX (MovementItem.ObjectId) AS GoodsId
        FROM (SELECT DISTINCT
                     tmpMovement_all.MovementId
              FROM tmpMovement_all
              WHERE tmpMovement_all.MovementDescId = zc_Movement_ProductionSeparate()
             ) AS tmpMovementList
             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementList.MovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
        GROUP BY tmpMovementList.MovementId
       )
         -- ВСЕ документы для расчета по Расценкам грн./кг. - без MovementId, но с найденным GoodsId_from
       , tmpMovement AS
       (SELECT
             tmpMovement_all.OperDate
           , tmpMovement_all.OperDate_num
           , tmpMovement_all.MovementDescId
           , tmpMovement_all.IsActive
           , tmpMovement_all.DocumentKindId
           , tmpMovement_all.FromId
           , tmpMovement_all.ToId
           , COALESCE (tmpGoodsMaster_out.GoodsId, tmpMovement_all.GoodsId_from) AS GoodsId_from
           , tmpMovement_all.GoodsId_to
           , SUM (tmpMovement_all.Amount) :: TFloat AS Amount
           , tmpMovement_all.GoodsKindId
           , tmpMovement_all.GoodsKind_FromId
           , tmpMovement_all.GoodsKindComplete_FromId
           , tmpMovement_all.GoodsKind_ToId
           , tmpMovement_all.GoodsKindComplete_ToId
           , tmpMovement_all.StorageLineId_From
           , tmpMovement_all.StorageLineId_To
        FROM tmpMovement_all
             LEFT JOIN tmpGoodsMaster_out ON tmpGoodsMaster_out.MovementId = tmpMovement_all.MovementId
                                         AND tmpMovement_all.IsActive      = TRUE
        GROUP BY
             tmpMovement_all.OperDate
           , tmpMovement_all.OperDate_num
           , tmpMovement_all.MovementDescId
           , tmpMovement_all.IsActive
           , tmpMovement_all.DocumentKindId
           , tmpMovement_all.FromId
           , tmpMovement_all.ToId
           , COALESCE (tmpGoodsMaster_out.GoodsId, tmpMovement_all.GoodsId_from)
           , tmpMovement_all.GoodsId_to
           , tmpMovement_all.GoodsKindId
           , tmpMovement_all.GoodsKind_FromId
           , tmpMovement_all.GoodsKindComplete_FromId
           , tmpMovement_all.GoodsKind_ToId
           , tmpMovement_all.GoodsKindComplete_ToId
           , tmpMovement_all.StorageLineId_From
           , tmpMovement_all.StorageLineId_To
       )
         -- Модели начисления + необходимые документы для расчета по Кол-во голов
       , tmpMovement_HeadCount AS
       (SELECT tmpMI.OperDate
             , tmpMI.MovementDescId
             , tmpMI.IsActive
             , tmpMI.FromId
             , tmpMI.ToId
             , tmpMI.GoodsId_from
             , tmpMI.GoodsId_to
             , tmpMI.GoodsKindId
             , SUM (MIFloat_HeadCount.ValueData) AS Amount
        FROM
        (SELECT DISTINCT MovementItemContainer.MovementItemId
           ,MovementItemContainer.OperDate
           ,MovementItemContainer.MovementDescId
           ,MovementItemContainer.IsActive
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectExtId_Analyzer
                 ELSE MovementItemContainer.WhereObjectId_Analyzer
            END AS FromId
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.WhereObjectId_Analyzer
                 ELSE MovementItemContainer.ObjectExtId_Analyzer
            END AS ToId
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectId_Analyzer -- NULL::Integer
                 ELSE MovementItemContainer.ObjectId_Analyzer
            END AS GoodsId_from
           ,CASE WHEN MovementItemContainer.IsActive = TRUE
                      THEN MovementItemContainer.ObjectId_Analyzer
                 ELSE Container.ObjectId
            END AS GoodsId_to
           ,MovementItemContainer.ObjectIntId_Analyzer AS GoodsKindId

        FROM (SELECT DISTINCT Setting.MovementDescId FROM Setting_Wage_1 AS Setting WHERE Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead())) AS tmp  -- Кол-во голов приход + Кол-во голов расход
             INNER JOIN MovementItemContainer ON MovementItemContainer.MovementDescId = tmp.MovementDescId
                                             AND MovementItemContainer.DescId         = zc_MIContainer_Count()
                                             AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
             LEFT OUTER JOIN Container ON Container.Id = COALESCE (MovementItemContainer.ContainerIntId_Analyzer, MovementItemContainer.ContainerId_Analyzer)
       ) AS tmpMI
             /*INNER JOIN MovementItem ON MovementItem.Id = tmpMI.MovementItemId
                                    AND MovementItem.isErased = FALSE
                                    AND MovementItem.Amount <> 0*/
             INNER JOIN MovementItemFloat AS MIFloat_HeadCount
                                          ON MIFloat_HeadCount.MovementItemId = tmpMI.MovementItemId
                                         AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
        GROUP BY tmpMI.OperDate
               , tmpMI.MovementDescId
               , tmpMI.IsActive
               , tmpMI.FromId
               , tmpMI.ToId
               , tmpMI.GoodsId_from
               , tmpMI.GoodsId_to
               , tmpMI.GoodsKindId
       )

         -- Модели начисления + необходимые документы для расчета по Расценкам грн./кг.
       , tmpGoodsByGoodsKind AS
       (SELECT Object_GoodsByGoodsKind_View.Id, Object_GoodsByGoodsKind_View.GoodsId, Object_GoodsByGoodsKind_View.GoodsKindId
        FROM (SELECT 0 AS X FROM Setting_Wage_1 AS Setting WHERE Setting.SelectKindId = zc_Enum_SelectKind_InPack() LIMIT 1) AS tmp  -- Кол-во упаковок приход (расчет)
             INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsKindId > tmp.X
       )
         -- Модели начисления + необходимые документы для расчета по Расценкам грн./кг.
       , ServiceModelMovement AS
       (SELECT
            Setting.StaffListId
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
           ,Setting.StorageLineId_From
           ,Setting.StorageLineId_To
           ,Setting.GoodsKind_FromId
           ,Setting.GoodsKindComplete_FromId
           ,Setting.GoodsKind_ToId
           ,Setting.GoodsKindComplete_ToId
           , COALESCE (tmpMovement.OperDate, tmpMovement_HeadCount.OperDate) AS OperDate
           , tmpMovement.DocumentKindId

           , SUM (CASE WHEN Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_SatSheetWorkTime() -- по субботам табель
                        AND tmpMovement.OperDate_num <> 6 -- суббота
                            THEN 0
                       WHEN Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead()) -- Кол-во голов
                            THEN tmpMovement_HeadCount.Amount
                       WHEN Setting.SelectKindId = zc_Enum_SelectKind_InPack() -- Кол-во упаковок приход (расчет)
                            THEN CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                                           THEN CAST ((tmpMovement.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                                    / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                                      ELSE 0
                                 END
                       ELSE tmpMovement.Amount
                  END) :: TFloat AS Gross  -- Общая база, кол-во
           , ROUND (Setting.Price * Setting.Ratio
           * SUM (CASE WHEN Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_SatSheetWorkTime() -- по субботам табель
                        AND tmpMovement.OperDate_num <> 6 -- суббота
                            THEN 0
                       WHEN Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead()) -- Кол-во голов
                            THEN tmpMovement_HeadCount.Amount
                       WHEN Setting.SelectKindId = zc_Enum_SelectKind_InPack() -- Кол-во упаковок приход (расчет)
                            THEN CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                                           THEN CAST ((tmpMovement.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                                    / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                                      ELSE 0
                                 END
                       ELSE tmpMovement.Amount
                  END)
           , 2) :: TFloat AS Amount -- Общая сумма, грн
        FROM Setting_Wage_1 AS Setting
             LEFT JOIN tmpMovement ON tmpMovement.MovementDescId = Setting.MovementDescId
                                  AND tmpMovement.IsActive = Setting.IsActive
                                  AND Setting.SelectKindId NOT IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead())
             LEFT JOIN tmpMovement_HeadCount ON tmpMovement_HeadCount.MovementDescId = Setting.MovementDescId
                                            AND tmpMovement_HeadCount.IsActive = Setting.IsActive
                                            AND Setting.SelectKindId IN (zc_Enum_SelectKind_InHead(), zc_Enum_SelectKind_OutHead())

             LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = tmpMovement.GoodsId_from
                                          AND tmpGoodsByGoodsKind.GoodsKindId = tmpMovement.GoodsKindId
             LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                   ON ObjectFloat_WeightTotal.ObjectId = tmpGoodsByGoodsKind.Id
                                  AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = tmpMovement.GoodsId_from
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpMovement.GoodsId_from
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        WHERE Setting.SelectKindId NOT IN (zc_Enum_SelectKind_MI_Master(), zc_Enum_SelectKind_MI_MasterCount(), zc_Enum_SelectKind_MovementCount())
          AND (Setting.FromId IS NULL OR COALESCE (tmpMovement_HeadCount.FromId, tmpMovement.FromId) IN (SELECT UnitTree.UnitId FROM lfSelect_Object_Unit_byGroup (Setting.FromId) AS UnitTree))
          AND (Setting.ToId   IS NULL OR COALESCE (tmpMovement_HeadCount.ToId,   tmpMovement.ToId)   IN (SELECT UnitTree.UnitId FROM lfSelect_Object_Unit_byGroup (Setting.ToId)   AS UnitTree))
          AND (Setting.ModelServiceItemChild_FromId IS NULL OR (Setting.ModelServiceItemChild_FromDescId = zc_Object_Goods()
                                                            AND COALESCE (tmpMovement_HeadCount.GoodsId_from, tmpMovement.GoodsId_from) = Setting.ModelServiceItemChild_FromId
                                                               )
                                                            OR (Setting.ModelServiceItemChild_FromDescId = zc_Object_GoodsGroup()
                                                            AND COALESCE (tmpMovement_HeadCount.GoodsId_from, tmpMovement.GoodsId_from) IN (SELECT GoodsTree.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (Setting.ModelServiceItemChild_FromId) AS GoodsTree)
                                                               )
              )
          AND (Setting.ModelServiceItemChild_ToId IS NULL OR (Setting.ModelServiceItemChild_ToDescId = zc_Object_Goods()
                                                          AND COALESCE (tmpMovement_HeadCount.GoodsId_to, tmpMovement.GoodsId_to) = Setting.ModelServiceItemChild_ToId
                                                             )
                                                          OR (Setting.ModelServiceItemChild_ToDescId = zc_Object_GoodsGroup()
                                                          AND COALESCE (tmpMovement_HeadCount.GoodsId_to, tmpMovement.GoodsId_to) IN (SELECT GoodsTree.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (Setting.ModelServiceItemChild_ToId) AS GoodsTree)
                                                             )
              )

          AND (Setting.GoodsKind_FromId         IS NULL OR tmpMovement.GoodsKind_FromId         = Setting.GoodsKind_FromId)
          AND (Setting.GoodsKindComplete_FromId IS NULL OR tmpMovement.GoodsKindComplete_FromId = Setting.GoodsKindComplete_FromId)
          AND (Setting.GoodsKind_ToId           IS NULL OR tmpMovement.GoodsKind_ToId           = Setting.GoodsKind_ToId)
          AND (Setting.GoodsKindComplete_ToId   IS NULL OR tmpMovement.GoodsKindComplete_ToId   = Setting.GoodsKindComplete_ToId)
          AND (Setting.StorageLineId_From       IS NULL OR tmpMovement.StorageLineId_From       = Setting.StorageLineId_From)
          AND (Setting.StorageLineId_To         IS NULL OR tmpMovement.StorageLineId_To         = Setting.StorageLineId_To)

        GROUP BY
             Setting.StaffListId
           , Setting.UnitId
           , Setting.PositionId
           , Setting.PositionLevelId
           , Setting.ServiceModelId
           , Setting.Price
           , Setting.FromId
           , Setting.ToId
           , Setting.MovementDescId
           , Setting.SelectKindId
           , Setting.SelectKindCode
           , Setting.ModelServiceItemChild_FromId
           , Setting.ModelServiceItemChild_ToId
           , Setting.StorageLineId_From
           , Setting.StorageLineId_To
           , Setting.GoodsKind_FromId
           , Setting.GoodsKindComplete_FromId
           , Setting.GoodsKind_ToId
           , Setting.GoodsKindComplete_ToId
           , COALESCE (tmpMovement.OperDate, tmpMovement_HeadCount.OperDate)
           , tmpMovement.DocumentKindId
           , Setting.Price
           , Setting.Ratio
       )
         -- табель - кто в какие дни работал
       , MI_SheetWorkTime AS
       (SELECT
             Movement.OperDate                             AS OperDate
           , MI_SheetWorkTime.ObjectId                     AS MemberId
           , Object_Member.ValueData                       AS MemberName
           , COALESCE (MIObject_PersonalGroup.ObjectId, 0) AS PersonalGroupId
           , MIObject_Position.ObjectId                    AS PositionId
           , COALESCE (MIObject_PositionLevel.ObjectId, 0) AS PositionLevelId
           , COALESCE (MIObject_StorageLine.ObjectId, 0)   AS StorageLineId
           , -- !!!может измениться!!!
             (CASE WHEN Object_WorkTimeKind.Tax > 0 THEN Object_WorkTimeKind.Tax / 100 ELSE 1 END * MI_SheetWorkTime.Amount) :: TFloat AS Amount

           -- , SUM (MI_SheetWorkTime.Amount) OVER (PARTITION BY MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS SUM_MemberHours
           -- , SUM (MI_SheetWorkTime.Amount) OVER (PARTITION BY Movement.OperDate, MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS AmountInDay
           -- , COUNT(*) OVER (PARTITION BY Movement.OperDate, MIObject_Position.ObjectId, MIObject_PositionLevel.ObjectId) AS Count_MemberInDay
        FROM Movement
             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                          AND (MovementLinkObject_Unit.ObjectId = inUnitId /*OR inUnitId = 0*/)
             INNER JOIN MovementItem AS MI_SheetWorkTime
                                     ON MI_SheetWorkTime.MovementId = Movement.Id
                                    AND MI_SheetWorkTime.Amount > 0
                                    AND MI_SheetWorkTime.isErased = FALSE

             INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                               ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id
                                              AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
             INNER JOIN Object_WorkTimeKind_Wages_View AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MIObject_WorkTimeKind.ObjectId

             LEFT JOIN Object AS Object_Member ON Object_Member.Id = MI_SheetWorkTime.ObjectId

             LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                    ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id
                                                   AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
             LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                    ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id
                                                   AND MIObject_Position.DescId = zc_MILinkObject_Position()
             LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                    ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id
                                                   AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
             LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                    ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                   AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()

        WHERE Movement.DescId = zc_Movement_SheetWorkTime()
          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
       )
         -- табель - сколько дней отработал (информативно)
       , Movement_Sheet_Count_Day AS
       (SELECT MI_SheetWorkTime.MemberId
             , MI_SheetWorkTime.PersonalGroupId
             , MI_SheetWorkTime.PositionId
             , MI_SheetWorkTime.PositionLevelId
             , MI_SheetWorkTime.StorageLineId
             , COUNT(*) AS Count_Day
        FROM (SELECT DISTINCT DATE_TRUNC ('DAY', MI_SheetWorkTime.OperDate), MI_SheetWorkTime.MemberId, MI_SheetWorkTime.PersonalGroupId, MI_SheetWorkTime.PositionId, MI_SheetWorkTime.PositionLevelId, MI_SheetWorkTime.StorageLineId FROM MI_SheetWorkTime) AS MI_SheetWorkTime
        GROUP BY MI_SheetWorkTime.MemberId
               , MI_SheetWorkTime.PersonalGroupId
               , MI_SheetWorkTime.PositionId
               , MI_SheetWorkTime.PositionLevelId
               , MI_SheetWorkTime.StorageLineId
       )
         -- табель - кто в какие дни работал
       , Movement_Sheet AS
       (SELECT MI_SheetWorkTime.OperDate
             , MI_SheetWorkTime.MemberId
             , MI_SheetWorkTime.MemberName
             , MI_SheetWorkTime.PersonalGroupId
             , MI_SheetWorkTime.PositionId
             , MI_SheetWorkTime.PositionLevelId
             , MI_SheetWorkTime.StorageLineId
             , MI_SheetWorkTime.Amount
             , SUM (MI_SheetWorkTime.Amount) OVER (PARTITION BY MI_SheetWorkTime.PositionId, MI_SheetWorkTime.PositionLevelId, MI_SheetWorkTime.StorageLineId) AS SUM_MemberHours
             , SUM (MI_SheetWorkTime.Amount) OVER (PARTITION BY MI_SheetWorkTime.OperDate, MI_SheetWorkTime.PositionId, MI_SheetWorkTime.PositionLevelId, MI_SheetWorkTime.StorageLineId) AS AmountInDay
             , COUNT(*) OVER (PARTITION BY MI_SheetWorkTime.OperDate, MI_SheetWorkTime.PositionId, MI_SheetWorkTime.PositionLevelId) AS Count_MemberInDay
             , COUNT(*) OVER (PARTITION BY MI_SheetWorkTime.PositionId, MI_SheetWorkTime.PositionLevelId) AS Count_Member
        FROM (SELECT MI_SheetWorkTime.OperDate
                   , MI_SheetWorkTime.MemberId
                   , MI_SheetWorkTime.MemberName
                   , MI_SheetWorkTime.PersonalGroupId
                   , MI_SheetWorkTime.PositionId
                   , MI_SheetWorkTime.PositionLevelId
                   , MI_SheetWorkTime.StorageLineId
                   , MI_SheetWorkTime.Amount
              FROM MI_SheetWorkTime
             UNION ALL
              SELECT MI_SheetWorkTime.OperDate
                   , MI_SheetWorkTime.MemberId
                   , MI_SheetWorkTime.MemberName
                   , MI_SheetWorkTime.PersonalGroupId
                   , MI_SheetWorkTime.PositionId
                   , 0 AS PositionLevelId
                   , MI_SheetWorkTime.StorageLineId
                   , MI_SheetWorkTime.Amount
              FROM (SELECT DISTINCT Setting_Wage_1.PositionId FROM Setting_Wage_1 WHERE Setting_Wage_1.isPositionLevel_all = TRUE) AS Setting
                   INNER JOIN MI_SheetWorkTime ON MI_SheetWorkTime.PositionId = Setting.PositionId AND MI_SheetWorkTime.PositionLevelId <> 0
             )AS MI_SheetWorkTime
       )

         -- табель - если понадобится итог за месяц
       , Movement_SheetGroup AS
      (SELECT Movement_Sheet.MemberId
            , Movement_Sheet.MemberName
            , Movement_Sheet.PersonalGroupId
            , Movement_Sheet.PositionId
            , Movement_Sheet.PositionLevelId
            , Movement_Sheet.StorageLineId
            , (Movement_Sheet.Amount) AS Amount
            , SUM (Movement_Sheet.Amount) OVER (PARTITION BY Movement_Sheet.PositionId, Movement_Sheet.PositionLevelId) AS AmountInMonth
            , COUNT(*) OVER (PARTITION BY Movement_Sheet.PositionId, Movement_Sheet.PositionLevelId) AS Count_Member
       FROM (SELECT Movement_Sheet.MemberId
                  , Movement_Sheet.MemberName
                  , Movement_Sheet.PersonalGroupId
                  , Movement_Sheet.PositionId
                  , Movement_Sheet.PositionLevelId
                  , Movement_Sheet.StorageLineId
                  , SUM (Movement_Sheet.Amount) AS Amount
             FROM Movement_Sheet
             GROUP BY Movement_Sheet.MemberId
                    , Movement_Sheet.MemberName
                    , Movement_Sheet.PersonalGroupId
                    , Movement_Sheet.PositionId
                    , Movement_Sheet.PositionLevelId
                    , Movement_Sheet.StorageLineId
            ) AS Movement_Sheet
       )
         -- Данные для - Кол-во строк в документе
       , tmpMovement_PersonalComplete AS
       (SELECT gpReport.OperDate
             , DATE_PART ('ISODOW', gpReport.OperDate)  AS OperDate_num
             , gpReport.UnitId, gpReport.UnitCode, gpReport.UnitName
             , gpReport.PersonalId, gpReport.PersonalCode, gpReport.PersonalName
             , gpReport.PositionId, gpReport.PositionCode, gpReport.PositionName
               -- Кол. строк (компл.)
             , SUM (COALESCE (gpReport.CountMI, 0))        :: TFloat AS CountMI
               -- Вес (компл.)
             , SUM (COALESCE (gpReport.TotalCountKg, 0))   :: TFloat AS TotalCountKg
               -- Кол. док. (компл.)
             , SUM (COALESCE (gpReport.CountMovement, 0))  :: TFloat AS CountMovement

        FROM gpReport_PersonalComplete (inStartDate:= inStartDate, inEndDate:= inEndDate, inPersonalId:= 0, inPositionId:= 0, inBranchId:= 0, inIsDay:= TRUE, inIsDetail:= FALSE, inSession:= inSession) AS gpReport
             INNER JOIN (SELECT DISTINCT Setting_Wage_1.FromId
                         FROM Setting_Wage_1
                         WHERE Setting_Wage_1.SelectKindId IN (zc_Enum_SelectKind_MI_Master(), zc_Enum_SelectKind_MI_MasterCount(), zc_Enum_SelectKind_MovementCount())
                           AND Setting_Wage_1.FromId > 0
                        ) AS tmpFrom ON tmpFrom.FromId = gpReport.UnitId
        WHERE EXISTS (SELECT 1 FROM Setting_Wage_1 AS Setting WHERE Setting.SelectKindId IN (zc_Enum_SelectKind_MI_Master(), zc_Enum_SelectKind_MI_MasterCount(), zc_Enum_SelectKind_MovementCount()))
        GROUP BY gpReport.OperDate
               , gpReport.UnitId, gpReport.UnitCode, gpReport.UnitName
               , gpReport.PersonalId, gpReport.PersonalCode, gpReport.PersonalName
               , gpReport.PositionId, gpReport.PositionCode, gpReport.PositionName
       )
    -- Результат
    SELECT
        Setting.StaffListId
      , ServiceModelMovement.DocumentKindId :: Integer AS DocumentKindId
      , Setting.UnitId
      , Setting.UnitName
       ,Setting.PositionId
       ,Setting.PositionName
       ,Setting.PositionLevelId
       ,Setting.PositionLevelName
       -- ,Setting.Count_Member
       , COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_Member) :: Integer AS Count_Member
       ,Setting.HoursPlan
       ,Setting.HoursDay
       , Object_PersonalGroup.Id        AS PersonalGroupId
       , Object_PersonalGroup.ValueData AS PersonalGroupName
       ,COALESCE (Movement_SheetGroup.MemberId,   Movement_Sheet.MemberId)   :: Integer  AS MemberId
       ,COALESCE (Movement_SheetGroup.MemberName, Movement_Sheet.MemberName) :: TVarChar AS MemberName
       ,tmpOperDate.OperDate :: TDateTime        AS SheetWorkTime_Date
       ,Movement_Sheet.SUM_MemberHours :: TFloat AS SUM_MemberHours
       ,Movement_Sheet.Amount                    AS SheetWorkTime_Amount
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

       ,Setting.StorageLineId_From, Setting.StorageLineName_From
       ,Setting.StorageLineId_To, Setting.StorageLineName_To

       ,Setting.GoodsKind_FromId, Setting.GoodsKind_FromName, Setting.GoodsKindComplete_FromId, Setting.GoodsKindComplete_FromName
       ,Setting.GoodsKind_ToId, Setting.GoodsKind_ToName, Setting.GoodsKindComplete_ToId, Setting.GoodsKindComplete_ToName

       , tmpOperDate.OperDate               :: TDateTime  AS OperDate
       , Movement_Sheet_Count_Day.Count_Day :: Integer    AS Count_Day
       , COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_MemberInDay) :: Integer
       , (ServiceModelMovement.Gross * Setting.Ratio) :: TFloat AS Gross
       , (ServiceModelMovement.Gross * Setting.Ratio
        / NULLIF (
          CASE WHEN (Movement_Sheet.AmountInDay = 0 OR Movement_Sheet.Amount = 0) AND Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- по дням табель
                    THEN 0
               WHEN Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- по дням + по часам табель
                    THEN Movement_Sheet.AmountInDay / NULLIF (Movement_Sheet.Amount, 0)
               ELSE COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_MemberInDay)
          END, 0)) :: TFloat AS GrossOnOneMember
       , ServiceModelMovement.Amount
       , ROUND (ServiceModelMovement.Amount
              / NULLIF (
                CASE WHEN (Movement_Sheet.AmountInDay = 0 OR Movement_Sheet.Amount = 0) AND Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- по дням + по часам табель
                          THEN 0
                     WHEN Setting.ServiceModelKindId = zc_Enum_ModelServiceKind_DayHoursSheetWorkTime () -- по дням + по часам табель
                          THEN Movement_Sheet.AmountInDay / NULLIF (Movement_Sheet.Amount, 0)
                     ELSE COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_MemberInDay)
                END, 0)
              , 2) :: TFloat AS AmountOnOneMember
    FROM Setting_Wage_1 AS Setting
         CROSS JOIN tmpOperDate
         LEFT OUTER JOIN Movement_SheetGroup ON COALESCE (Movement_SheetGroup.PositionId, 0)      = COALESCE (Setting.PositionId, 0)
                                            AND COALESCE (Movement_SheetGroup.PositionLevelId, 0) = COALESCE (Setting.PositionLevelId, 0)
                                            AND (COALESCE (Movement_SheetGroup.StorageLineId, 0)   = COALESCE (Setting.StorageLineId_From, 0)
                                              OR COALESCE (Movement_SheetGroup.StorageLineId, 0)   = COALESCE (Setting.StorageLineId_To, 0))
                                            AND Setting.ServiceModelKindId                        = zc_Enum_ModelServiceKind_MonthSheetWorkTime() -- за месяц табель

         LEFT OUTER JOIN Movement_Sheet ON COALESCE (Movement_Sheet.PositionId, 0)      = COALESCE (Setting.PositionId, 0)
                                       AND COALESCE (Movement_Sheet.PositionLevelId, 0) = COALESCE (Setting.PositionLevelId, 0)
                                       AND (COALESCE (Movement_Sheet.StorageLineId, 0)   = COALESCE (Setting.StorageLineId_From, 0)
                                         OR COALESCE (Movement_Sheet.StorageLineId, 0)   = COALESCE (Setting.StorageLineId_To, 0))
                                       AND Movement_Sheet.OperDate                      = tmpOperDate.OperDate
                                       AND (COALESCE (Movement_Sheet.MemberId, 0)       = Movement_SheetGroup.MemberId OR Movement_SheetGroup.MemberId IS NULL)

         LEFT OUTER JOIN Movement_Sheet_Count_Day ON Movement_Sheet_Count_Day.MemberId        = COALESCE (Movement_SheetGroup.MemberId, Movement_Sheet.MemberId)
                                                 AND Movement_Sheet_Count_Day.PersonalGroupId = COALESCE (Movement_SheetGroup.PersonalGroupId, Movement_Sheet.PersonalGroupId)
                                                 AND Movement_Sheet_Count_Day.PositionLevelId = COALESCE (Movement_SheetGroup.PositionLevelId, Movement_Sheet.PositionLevelId)
                                                 AND Movement_Sheet_Count_Day.PositionId      = COALESCE (Movement_SheetGroup.PositionId, Movement_Sheet.PositionId)
                                                 AND Movement_Sheet_Count_Day.StorageLineId   = COALESCE (Movement_SheetGroup.StorageLineId, Movement_Sheet.StorageLineId)

        LEFT OUTER JOIN ServiceModelMovement ON COALESCE (Setting.StaffListId, 0)                  = COALESCE (ServiceModelMovement.StaffListId, 0)
                                            AND COALESCE (Setting.UnitId, 0)                       = COALESCE (ServiceModelMovement.UnitId, 0)
                                            AND COALESCE (Setting.PositionId, 0)                   = COALESCE (ServiceModelMovement.PositionId, 0)
                                            AND COALESCE (Setting.PositionLevelId, 0)              = COALESCE (ServiceModelMovement.PositionLevelId, 0)
                                            AND COALESCE (Setting.ServiceModelId, 0)               = COALESCE (ServiceModelMovement.ServiceModelId, 0)
                                            AND COALESCE (Setting.Price, 0)                        = COALESCE (ServiceModelMovement.Price, 0)
                                            AND COALESCE (Setting.FromId, 0)                       = COALESCE (ServiceModelMovement.FromId, 0)
                                            AND COALESCE (Setting.ToId, 0)                         = COALESCE (ServiceModelMovement.ToId, 0)
                                            AND COALESCE (Setting.MovementDescId, 0)               = COALESCE (ServiceModelMovement.MovementDescId, 0)
                                            AND COALESCE (Setting.SelectKindId, 0)                 = COALESCE (ServiceModelMovement.SelectKindId, 0)
                                            AND COALESCE (Setting.ModelServiceItemChild_FromId, 0) = COALESCE (ServiceModelMovement.ModelServiceItemChild_FromId, 0)
                                            AND COALESCE (Setting.ModelServiceItemChild_ToId, 0)   = COALESCE (ServiceModelMovement.ModelServiceItemChild_ToId, 0)

                                            AND COALESCE (Setting.StorageLineId_From, 0)           = COALESCE (ServiceModelMovement.StorageLineId_From, 0)
                                            AND COALESCE (Setting.StorageLineId_To, 0)             = COALESCE (ServiceModelMovement.StorageLineId_To, 0)

                                            AND COALESCE (Setting.GoodsKind_FromId, 0)             = COALESCE (ServiceModelMovement.GoodsKind_FromId, 0)
                                            AND COALESCE (Setting.GoodsKindComplete_FromId, 0)     = COALESCE (ServiceModelMovement.GoodsKindComplete_FromId, 0)
                                            AND COALESCE (Setting.GoodsKind_ToId, 0)               = COALESCE (ServiceModelMovement.GoodsKind_ToId, 0)
                                            AND COALESCE (Setting.GoodsKindComplete_ToId, 0)       = COALESCE (ServiceModelMovement.GoodsKindComplete_ToId, 0)

                                            AND ServiceModelMovement.OperDate                      = tmpOperDate.OperDate
                                            AND (ServiceModelMovement.DocumentKindId               = Setting.DocumentKindId
                                              OR Setting.DocumentKindId = 0)

        LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = COALESCE (Movement_SheetGroup.PersonalGroupId, Movement_Sheet.PersonalGroupId)

    WHERE Setting.SelectKindId NOT IN (zc_Enum_SelectKind_MI_Master(), zc_Enum_SelectKind_MI_MasterCount(), zc_Enum_SelectKind_MovementCount())

   UNION ALL
    SELECT
        Setting.StaffListId
      , 0 :: Integer AS DocumentKindId
      , Setting.UnitId
      , Setting.UnitName
       ,tmpMovement_PersonalComplete.PositionId
       ,tmpMovement_PersonalComplete.PositionName
       ,Object_PositionLevel.Id        AS PositionLevelId
       ,Object_PositionLevel.ValueData AS PositionLevelName
       ,Setting.Count_Member
       -- , COALESCE (Movement_SheetGroup.Count_Member, Movement_Sheet.Count_Member) :: Integer AS Count_Member
       ,Setting.HoursPlan
       ,Setting.HoursDay
       , Object_PersonalGroup.Id        AS PersonalGroupId
       , Object_PersonalGroup.ValueData AS PersonalGroupName
       ,tmpMovement_PersonalComplete.PersonalId   :: Integer   AS MemberId
       ,tmpMovement_PersonalComplete.PersonalName :: TVarChar  AS MemberName
       ,tmpMovement_PersonalComplete.OperDate     :: TDateTime AS SheetWorkTime_Date
       ,0 :: TFloat AS SUM_MemberHours
       ,0 :: TFloat AS SheetWorkTime_Amount
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

       ,Setting.StorageLineId_From, Setting.StorageLineName_From
       ,Setting.StorageLineId_To, Setting.StorageLineName_To

       ,Setting.GoodsKind_FromId, Setting.GoodsKind_FromName, Setting.GoodsKindComplete_FromId, Setting.GoodsKindComplete_FromName
       ,Setting.GoodsKind_ToId, Setting.GoodsKind_ToName, Setting.GoodsKindComplete_ToId, Setting.GoodsKindComplete_ToName

       , tmpMovement_PersonalComplete.OperDate AS OperDate
       , 0 :: Integer AS Count_Day
       , 0 :: Integer AS Count_MemberInDay
       , CASE -- Вес (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master()
                    THEN tmpMovement_PersonalComplete.TotalCountKg
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_MasterCount()
                    THEN tmpMovement_PersonalComplete.CountMI
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MovementCount()
                    THEN tmpMovement_PersonalComplete.CountMovement
              ELSE 0
         END :: TFloat AS Gross
       , CASE -- Вес (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master()
                    THEN tmpMovement_PersonalComplete.TotalCountKg
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_MasterCount()
                    THEN tmpMovement_PersonalComplete.CountMI
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MovementCount()
                    THEN tmpMovement_PersonalComplete.CountMovement
              ELSE 0
         END :: TFloat AS GrossOnOneMember
       , (CASE -- Вес (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master()
                    THEN tmpMovement_PersonalComplete.TotalCountKg
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_MasterCount()
                    THEN tmpMovement_PersonalComplete.CountMI
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MovementCount()
                    THEN tmpMovement_PersonalComplete.CountMovement
              ELSE 0
         END * Setting.Ratio * Setting.Price) :: TFloat AS Amount
       , (CASE -- Вес (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master()
                    THEN tmpMovement_PersonalComplete.TotalCountKg
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_MasterCount()
                    THEN tmpMovement_PersonalComplete.CountMI
              -- Кол. строк (компл.)
              WHEN Setting.SelectKindId = zc_Enum_SelectKind_MovementCount()
                    THEN tmpMovement_PersonalComplete.CountMovement
              ELSE 0
         END * Setting.Ratio * Setting.Price) :: TFloat AS AmountOnOneMember

    FROM Setting_Wage_1 AS Setting
         INNER JOIN tmpMovement_PersonalComplete ON tmpMovement_PersonalComplete.UnitId = Setting.FromId
                                                AND (tmpMovement_PersonalComplete.CountMI       <> 0
                                                  OR tmpMovement_PersonalComplete.TotalCountKg  <> 0
                                                  OR tmpMovement_PersonalComplete.CountMovement <> 0
                                                    )
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                              ON ObjectLink_Personal_PersonalGroup.ChildObjectId = tmpMovement_PersonalComplete.PersonalId
                             AND ObjectLink_Personal_PersonalGroup.DescId        = zc_ObjectLink_Personal_PersonalGroup()
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                              ON ObjectLink_Personal_PositionLevel.ChildObjectId = tmpMovement_PersonalComplete.PersonalId
                             AND ObjectLink_Personal_PositionLevel.DescId        = zc_ObjectLink_Personal_PositionLevel()
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = ObjectLink_Personal_PositionLevel.ChildObjectId
    WHERE Setting.SelectKindId IN (zc_Enum_SelectKind_MI_Master(), zc_Enum_SelectKind_MI_MasterCount(), zc_Enum_SelectKind_MovementCount())
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Report_Wage_Model (inStartDate:= '02.11.2017', inEndDate:= '02.11.2017', inUnitId:= 8439, inModelServiceId:= 632844, inMemberId:= 0, inPositionId:= 0, inSession:= '5');
