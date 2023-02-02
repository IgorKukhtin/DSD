-- По штатному расписанию
-- Function: gpReport_StaffList ()

DROP FUNCTION IF EXISTS gpReport_StaffList (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffList(
    IN inUnitId         Integer,   --подразделение
    IN inModelServiceId Integer,   --модель начисления
    IN inPositionId     Integer,   --должность
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     StaffListId                    Integer
    ,StaffListCode                  Integer
   -- ,StaffListName                  TVarChar
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
    ,SelectKindCode                 Integer
    ,SelectKindName                 TVarChar
    ,Ratio                          TFloat
    
    ,ModelServiceItemChild_FromId   Integer
    ,ModelServiceItemChild_FromDescId Integer  
    ,ModelServiceItemChild_FromCode Integer
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToId     Integer
    ,ModelServiceItemChild_ToDescId Integer
    ,ModelServiceItemChild_ToCode   Integer
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
    , StaffListSummKindId           Integer
    , StaffListSummKindName         TVarChar
    , Value_StaffListSummKind       TFloat 

    , UpdateName_ModelServiceItemChild  TVarChar
    , UpdateDate_ModelServiceItemChild  TDateTime
    , UpdateName_StaffListCost TVarChar
    , UpdateDate_StaffListCost TDateTime
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY

    WITH 
    tmpProtocol_ModelServiceItemChild AS (SELECT tmp.ObjectId
                                               , tmp.UserId
                                               , Object_User.ValueData AS UserName
                                               , tmp.OperDate
                                          FROM (SELECT ObjectProtocol.*
                                                       -- № п/п
                                                     , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                                                FROM ObjectProtocol
                                                WHERE ObjectProtocol.ObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ModelServiceItemChild())  --(SELECT DISTINCT StaffList.ModelServiceItemChildId FROM StaffList)
                                                ) AS tmp
                                                LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId
                                          WHERE tmp.Ord = 1
                                          ) 

  , tmpProtocol_StaffListCost AS (SELECT tmp.ObjectId
                                               , tmp.UserId
                                               , Object_User.ValueData AS UserName
                                               , tmp.OperDate
                                  FROM (SELECT ObjectProtocol.*
                                               -- № п/п
                                             , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                                        FROM ObjectProtocol
                                        WHERE ObjectProtocol.ObjectId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StaffListCost()) --(SELECT DISTINCT StaffList.StaffListCostId FROM StaffList)
                                        ) AS tmp 
                                        LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId
                                  WHERE tmp.Ord = 1
                                  )

  , tmpStaffList AS (SELECT Object_StaffList.Id                                      --AS StaffListId
                           ,Object_StaffList.ObjectCode                              AS StaffListCode
                           ,ObjectLink_StaffList_Unit.ChildObjectId                  AS UnitId
                           ,Object_Unit.ValueData                                    AS UnitName
                           ,ObjectLink_StaffList_Position.ChildObjectId              AS PositionId
                           ,Object_Position.ValueData                                AS PositionName
                           ,COALESCE (ObjectBoolean_PositionLevel.ValueData, FALSE)  AS isPositionLevel_all
                           ,CASE WHEN ObjectBoolean_PositionLevel.ValueData = TRUE THEN 0 ELSE ObjectLink_StaffList_PositionLevel.ChildObjectId END AS PositionLevelId
                           ,Object_PositionLevel.ValueData                           AS PositionLevelName
                           ,ObjectFloat_PersonalCount.ValueData::Integer             AS Count_Member
                           ,ObjectFloat_HoursPlan.ValueData                          AS HoursPlan
                           ,ObjectFloat_HoursDay.ValueData                           AS HoursDay
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
                                                 
                        WHERE Object_StaffList.DescId = zc_Object_StaffList()
                          AND Object_StaffList.isErased = FALSE
                          AND (ObjectLink_StaffList_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
                          AND (ObjectLink_StaffList_Position.ChildObjectId = inPositionId OR inPositionId = 0)
                       )

     , tmpStaffListSum AS (SELECT Object_StaffList.*
                                , ObjectLink_StaffListSumm_StaffList.ChildObjectId         AS StaffListSummId
                                , ObjectFloat_StaffListSumm_Value.ValueData                AS StaffListSumm_Value
                                , ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId AS StaffListSummKindId
                                , Object_StaffListSummKind.ValueData                       AS StaffListSummKindName
                           FROM tmpStaffList AS Object_StaffList
                             --StaffListCost
                              INNER JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffList
                                                    ON ObjectLink_StaffListSumm_StaffList.ChildObjectId = Object_StaffList.Id
                                                   AND ObjectLink_StaffListSumm_StaffList.DescId = zc_ObjectLink_StaffListSumm_StaffList()
                              INNER JOIN Object AS Object_StaffListSumm
                                                ON Object_StaffListSumm.Id = ObjectLink_StaffListSumm_StaffList.ObjectId
                                               AND Object_StaffListSumm.isErased = FALSE
                              --Сумма
                              LEFT JOIN ObjectFloat AS ObjectFloat_StaffListSumm_Value
                                                    ON ObjectFloat_StaffListSumm_Value.ObjectId = Object_StaffListSumm.Id 
                                                   AND ObjectFloat_StaffListSumm_Value.DescId = zc_ObjectFloat_StaffListSumm_Value()
                              --Тип суммы
                              LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffListSumm_StaffListSummKind
                                                         ON ObjectLink_StaffListSumm_StaffListSummKind.ObjectId = Object_StaffListSumm.Id
                                                        AND ObjectLink_StaffListSumm_StaffListSummKind.DescId = zc_ObjectLink_StaffListSumm_StaffListSummKind()
                              LEFT OUTER JOIN Object AS Object_StaffListSummKind
                                                     ON Object_StaffListSummKind.Id = ObjectLink_StaffListSumm_StaffListSummKind.ChildObjectId
                                                  -- AND Object_StaffListSummKind.isErased = FALSE
                           )
     , tmpStaffListModel AS (SELECT Object_StaffList.*
                                   ,ObjectLink_StaffListCost_ModelService.ChildObjectId    AS ServiceModelId      -- Модель начисления
                                   ,Object_ModelService.ObjectCode::Integer                AS ServiceModelCode
                                   ,Object_ModelService.ValueData                          AS ServiceModelName
                                   ,COALESCE (ObjectLink_ModelServiceItemMaster_DocumentKind.ChildObjectId, 0) AS DocumentKindId
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
                                   ,ObjectFloat_Ratio.ValueData                         AS Ratio                 -- Коэффициент для выбора данных
                                   ,ModelServiceItemChild_From.Id                       AS ModelServiceItemChild_FromId       -- Товар,Группа(От кого) (из справочника Подчиненные элементы Модели начисления)
                                   ,ModelServiceItemChild_From.DescId                   AS ModelServiceItemChild_FromDescId
                                   ,ModelServiceItemChild_From.ObjectCode               AS ModelServiceItemChild_FromCode
                                   ,ModelServiceItemChild_From.ValueData                AS ModelServiceItemChild_FromName
                                   ,ModelServiceItemChild_To.Id                         AS ModelServiceItemChild_ToId         -- Товар,Группа(Кому) (из справочника Подчиненные элементы Модели начисления)
                                   ,ModelServiceItemChild_To.DescId                     AS ModelServiceItemChild_ToDescId
                                   ,ModelServiceItemChild_To.ObjectCode                 AS ModelServiceItemChild_ToCode
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

                                    --протоколы
                                   , tmpProtocol_ModelServiceItemChild.UserName AS UpdateName_ModelServiceItemChild
                                   , tmpProtocol_ModelServiceItemChild.OperDate AS UpdateDate_ModelServiceItemChild
                            
                                   , tmpProtocol_StaffListCost.UserName         AS UpdateName_StaffListCost
                                   , tmpProtocol_StaffListCost.OperDate         AS UpdateDate_StaffListCost 
       
                             FROM tmpStaffList AS Object_StaffList
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
        LEFT JOIN Object AS Object_ModelServiceItemChild
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
                               AND Object_GoodsKind_From.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_GoodsKind_To
                                   ON ObjectLink_GoodsKind_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_GoodsKind_To.DescId = zc_ObjectLink_ModelServiceItemChild_ToGoodsKind()
        LEFT OUTER JOIN Object AS Object_GoodsKind_To
                               ON Object_GoodsKind_To.Id = ObjectLink_GoodsKind_To.ChildObjectId
                               AND Object_GoodsKind_To.isErased = FALSE

        LEFT OUTER JOIN ObjectLink AS ObjectLink_GoodsKindComplete_From
                                   ON ObjectLink_GoodsKindComplete_From.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_GoodsKindComplete_From.DescId = zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete()
        LEFT OUTER JOIN Object AS Object_GoodsKindComplete_From
                               ON Object_GoodsKindComplete_From.Id = ObjectLink_GoodsKindComplete_From.ChildObjectId
                               AND Object_GoodsKindComplete_From.isErased = FALSE
        LEFT OUTER JOIN ObjectLink AS ObjectLink_GoodsKindComplete_To
                                   ON ObjectLink_GoodsKindComplete_To.ObjectId = Object_ModelServiceItemChild.Id
                                  AND ObjectLink_GoodsKindComplete_To.DescId = zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete()
        LEFT OUTER JOIN Object AS Object_GoodsKindComplete_To
                               ON Object_GoodsKindComplete_To.Id = ObjectLink_GoodsKindComplete_To.ChildObjectId
                               AND Object_GoodsKindComplete_To.isErased = FALSE

       --  протоколы
        LEFT JOIN tmpProtocol_ModelServiceItemChild ON tmpProtocol_ModelServiceItemChild.ObjectId = Object_ModelServiceItemChild.Id
        LEFT JOIN tmpProtocol_StaffListCost ON tmpProtocol_StaffListCost.ObjectId = Object_StaffListCost.Id

                             WHERE (ObjectLink_StaffListCost_ModelService.ChildObjectId = inModelServiceId OR inModelServiceId = 0)
 
                            )                         
 
 
      
  -- результат                      
    SELECT
        tmpStaffList.Id AS StaffListId            -- Штатное расписание
       ,tmpStaffList.StaffListCode
       ,tmpStaffList.DocumentKindId
       ,tmpStaffList.UnitId                 -- Поразделение
       ,tmpStaffList.UnitName
       ,tmpStaffList.PositionId             -- Должность
       ,tmpStaffList.PositionName

       ,tmpStaffList.PositionLevelId -- Разряд должности
       ,tmpStaffList.PositionLevelName
       ,tmpStaffList.Count_Member          -- !!!информативно!!! кол-во сотрудников (из справочника Штатное расписание)
       ,tmpStaffList.HoursPlan              -- !!!информативно!!! 1.Общий план часов в месяц на человека (из справочника Штатное расписание)
       ,tmpStaffList.HoursDay               -- !!!информативно!!! 2.Дневной план часов на человека (из справочника Штатное расписание)

       ,tmpStaffList.ServiceModelId      -- Модель начисления
       ,tmpStaffList.ServiceModelCode
       ,tmpStaffList.ServiceModelName
      
       ,tmpStaffList.Price                  -- Расценка грн./кг. (из справочника Расценки штатного расписания для Модель начисления)
       ,tmpStaffList.FromId                 -- Подразделение(От кого) (из справочника Главные элементы Модели начисления)
       ,tmpStaffList.FromName
       ,tmpStaffList.ToId                   -- Подразделение(Кому) (из справочника Главные элементы Модели начисления)
       ,tmpStaffList.ToName
       ,tmpStaffList.MovementDescId         -- Код документа (из справочника Главные элементы Модели начисления)
       ,tmpStaffList.MovementDescName
       ,tmpStaffList.SelectKindId           -- Тип выбора данных (из справочника Главные элементы Модели начисления)
       ,tmpStaffList.SelectKindCode
       ,tmpStaffList.SelectKindName
       ,tmpStaffList.Ratio                 -- Коэффициент для выбора данных
       ,tmpStaffList.ModelServiceItemChild_FromId       -- Товар,Группа(От кого) (из справочника Подчиненные элементы Модели начисления)
       ,tmpStaffList.ModelServiceItemChild_FromDescId
       ,tmpStaffList.ModelServiceItemChild_FromCode
       ,tmpStaffList.ModelServiceItemChild_FromName
       ,tmpStaffList.ModelServiceItemChild_ToId         -- Товар,Группа(Кому) (из справочника Подчиненные элементы Модели начисления)
       ,tmpStaffList.ModelServiceItemChild_ToDescId
       ,tmpStaffList.ModelServiceItemChild_ToCode
       ,tmpStaffList.ModelServiceItemChild_ToName

       , tmpStaffList.StorageLineId_From
       , tmpStaffList.StorageLineName_From
       , tmpStaffList.StorageLineId_To
       , tmpStaffList.StorageLineName_To

       , tmpStaffList.GoodsKind_FromId
       , tmpStaffList.GoodsKind_FromName
       , tmpStaffList.GoodsKindComplete_FromId
       , tmpStaffList.GoodsKindComplete_FromName
       , tmpStaffList.GoodsKind_ToId
       , tmpStaffList.GoodsKind_ToName
       , tmpStaffList.GoodsKindComplete_ToId
       , tmpStaffList.GoodsKindComplete_ToName

       --
       , 0              AS StaffListSummKindId              -- Типы сумм для штатного расписания
       , ''  ::TVarChar AS StaffListSummKindName
       , 0   ::TFloat   AS Value_StaffListSummKind          -- Суммы для штатного расписания

       --протоколы
       , tmpStaffList.UpdateName_ModelServiceItemChild
       , tmpStaffList.UpdateDate_ModelServiceItemChild
       , tmpStaffList.UpdateName_StaffListCost
       , tmpStaffList.UpdateDate_StaffListCost       

    FROM tmpStaffListModel AS tmpStaffList
  UNION  all
   SELECT
         tmpStaffList.Id AS StaffListId           -- Штатное расписание
       ,tmpStaffList.StaffListCode
       ,0 AS DocumentKindId
       ,tmpStaffList.UnitId                 -- Поразделение
       ,tmpStaffList.UnitName
       ,tmpStaffList.PositionId             -- Должность
       ,tmpStaffList.PositionName

       ,tmpStaffList.PositionLevelId -- Разряд должности
       ,tmpStaffList.PositionLevelName
       ,tmpStaffList.Count_Member          -- !!!информативно!!! кол-во сотрудников (из справочника Штатное расписание)
       ,tmpStaffList.HoursPlan              -- !!!информативно!!! 1.Общий план часов в месяц на человека (из справочника Штатное расписание)
       ,tmpStaffList.HoursDay               -- !!!информативно!!! 2.Дневной план часов на человека (из справочника Штатное расписание)

       ,0 ::Integer      AS ServiceModelId      -- Модель начисления
       ,0 ::Integer      AS ServiceModelCode
       ,''::TVarChar     AS ServiceModelName
      
       ,0 :: TFloat      AS Price                  -- Расценка грн./кг. (из справочника Расценки штатного расписания для Модель начисления)
       ,0 ::Integer      AS FromId                 -- Подразделение(От кого) (из справочника Главные элементы Модели начисления)
       ,''::TVarChar     AS FromName
       ,0 ::Integer      AS ToId                   -- Подразделение(Кому) (из справочника Главные элементы Модели начисления)
       ,''::TVarChar     AS ToName
       ,0 ::Integer      AS MovementDescId         -- Код документа (из справочника Главные элементы Модели начисления)
       ,''::TVarChar     AS MovementDescName
       ,0 ::Integer      AS SelectKindId           -- Тип выбора данных (из справочника Главные элементы Модели начисления)
       ,0 ::Integer      AS SelectKindCode
       ,''::TVarChar     AS SelectKindName
       ,0 :: TFloat      AS Ratio                 -- Коэффициент для выбора данных
       ,0 ::Integer      AS ModelServiceItemChild_FromId       -- Товар,Группа(От кого) (из справочника Подчиненные элементы Модели начисления)
       ,0 ::Integer      AS ModelServiceItemChild_FromDescId
       ,0 ::Integer      AS ModelServiceItemChild_FromCode
       ,''::TVarChar     AS ModelServiceItemChild_FromName
       ,0 ::Integer      AS ModelServiceItemChild_ToId         -- Товар,Группа(Кому) (из справочника Подчиненные элементы Модели начисления)
       ,0 ::Integer      AS ModelServiceItemChild_ToDescId
       ,0 ::Integer      AS ModelServiceItemChild_ToCode
       ,''::TVarChar     AS ModelServiceItemChild_ToName

       , 0 ::Integer      AS StorageLineId_From
       , ''::TVarChar     AS StorageLineName_From
       , 0 ::Integer      AS StorageLineId_To
       , ''::TVarChar     AS StorageLineName_To

       , 0 ::Integer      AS GoodsKind_FromId
       , ''::TVarChar     AS GoodsKind_FromName
       , 0 ::Integer      AS GoodsKindComplete_FromId
       , ''::TVarChar     AS GoodsKindComplete_FromName
       , 0 ::Integer      AS GoodsKind_ToId
       , ''::TVarChar     AS GoodsKind_ToName
       , 0 ::Integer      AS GoodsKindComplete_ToId
       , ''::TVarChar     AS GoodsKindComplete_ToName

       --
       , tmpStaffList.StaffListSummKindId              -- Типы сумм для штатного расписания
       , tmpStaffList.StaffListSummKindName
       , tmpStaffList.StaffListSumm_Value AS Value_StaffListSummKind          -- Суммы для штатного расписания

       --протоколы
       , '' ::TVarChar    AS UpdateName_ModelServiceItemChild
       , NULL ::TDateTime AS UpdateDate_ModelServiceItemChild
       , '' ::TVarChar    AS UpdateName_StaffListCost
       , NULL ::TDateTime AS UpdateDate_StaffListCost

    FROM tmpStaffListSum AS tmpStaffList
     
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.02.23         *
*/
-- тест
-- select * from gpReport_StaffList22 (inUnitId := 8395 , inModelServiceId := 0 , inPositionId := 0,  inSession := '5');
--select * from gpReport_StaffList (inUnitId := 8451 , inModelServiceId := 582633 , inPositionId := 12452 ,  inSession := '9457');