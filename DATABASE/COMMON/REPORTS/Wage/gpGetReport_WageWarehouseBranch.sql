-- Function: gpGetReport_WageWarehouseBranch()

DROP FUNCTION IF EXISTS GetReport_WageWarehouseBranch (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGetReport_WageWarehouseBranch (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGetReport_WageWarehouseBranch(
    IN inStartDate   TDateTime ,              --
    IN inEndDate     TDateTime ,              --
    IN inPersonalId  Integer   ,              -- сотудник
    IN inPositionId  Integer   ,              -- должность
    IN inBranchId    Integer   ,              -- филиал   
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (koeff_11 TFloat
             , koeff_12 TFloat
             , koeff_13 TFloat
             , koeff_22 TFloat
             , koeff_31 TFloat
             , koeff_32 TFloat
             , koeff_33 TFloat
             , koeff_41 TFloat
             , koeff_42 TFloat
             , koeff_43 TFloat
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Account());
   
      RETURN QUERY 
 
 WITH  
 Setting_Wage_1 AS (
    SELECT
        ObjectLink_StaffList_Unit.ChildObjectId             AS UnitId                 -- Поразделение
       ,ObjectLink_StaffList_Position.ChildObjectId         AS PositionId             -- Должность
       ,ObjectFloat_StaffListCost_Price.ValueData           AS Price                  -- Расценка грн./кг. (из справочника Расценки штатного расписания для Модель начисления)
       ,ObjectLink_ModelServiceItemMaster_From.ChildObjectId  AS FromId                 -- Подразделение(От кого) (из справочника Главные элементы Модели начисления)
       ,ObjectLink_ModelServiceItemMaster_SelectKind.ChildObjectId AS SelectKindId           -- Тип выбора данных (из справочника Главные элементы Модели начисления)
    FROM Object as Object_StaffList
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionLevel
                                ON ObjectBoolean_PositionLevel.ObjectId = Object_StaffList.Id
                               AND ObjectBoolean_PositionLevel.DescId = zc_ObjectBoolean_StaffList_PositionLevel()
        --Unit подразделение
        LEFT OUTER JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                   ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                  AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
        
        --Position  должность
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                             ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
        --PositionLevel разряд должности
        LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                             ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                            AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
        LEFT JOIN Object AS Object_PositionLevel
                         ON Object_PositionLevel.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
        
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
       
        --SelectKind тип выбора
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemMaster_SelectKind
                                   ON ObjectLink_ModelServiceItemMaster_SelectKind.ObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemMaster_SelectKind.DescId = zc_ObjectLink_ModelServiceItemMaster_SelectKind()
        --ограничения по товару / группе
        LEFT OUTER JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ModelServiceItemMaster
                                   ON ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ChildObjectId = Object_ModelServiceItemMaster.Id
                                  AND ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.DescId = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()
        LEFT JOIN Object AS Object_ModelServiceItemChild
                         ON Object_ModelServiceItemChild.Id = ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ObjectId
                        AND Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild()
                        AND Object_ModelServiceItemChild.isErased = FALSE
          

    WHERE Object_StaffList.DescId = zc_Object_StaffList()
        AND Object_StaffList.isErased = FALSE
        AND (Object_ModelServiceItemChild.Id > 0
          OR ObjectLink_ModelServiceItemMaster_SelectKind.ChildObjectId IN (zc_Enum_SelectKind_MovementTransportHours()
                                                                          , zc_Enum_SelectKind_MovementReestrWeight()
                                                                          , zc_Enum_SelectKind_MovementReestrDoc()
                                                                          , zc_Enum_SelectKind_MovementReestrPartner()
                                                                            -- Комплектация
                                                                          , zc_Enum_SelectKind_MovementCount(), zc_Enum_SelectKind_MI_MasterCount(), zc_Enum_SelectKind_MI_Master()
                                                                            -- Стикеровка
                                                                          , zc_Enum_SelectKind_MI_MasterSh()
                                                                            -- Значение для клдв.
                                                                          , zc_Enum_SelectKind_MovementCount_Ware(), zc_Enum_SelectKind_MI_MasterCount_Ware(), zc_Enum_SelectKind_MI_Master_Ware()
                                                                            -- Значение возврат на филилал
                                                                          , zc_Enum_SelectKind_MovementCount_WareIn(), zc_Enum_SelectKind_MI_Master_WareIn()
                                                                            -- Значение возврат на Днепр
                                                                          , zc_Enum_SelectKind_MI_Master_WareOut()
                                                                            -- Транспорт - Рабочее время из путевого листа + Транспорт - Кол-во вес (реестр) + Транспорт - Кол-во документов (реестр)
                                                                          , zc_Enum_SelectKind_MovementTransportHours(), zc_Enum_SelectKind_MovementReestrWeight(), zc_Enum_SelectKind_MovementReestrDoc(), zc_Enum_SelectKind_MovementReestrPartner()
                                                                           )
            )
   )

     -- Данные для - WageWarehouseBranch
       , tmpWageWarehouseBranch AS (SELECT *
                                    FROM gpReport_WageWarehouseBranch (inStartDate   := inStartDate
                                                                     , inEndDate     := inEndDate
                                                                     , inPersonalId  := inPersonalId
                                                                     , inPositionId  := inPositionId
                                                                     , inBranchId    := inBranchId
                                                                     , inIsDay       := FALSE
                                                                     , inKoef_11     := 0
                                                                     , inKoef_12     := 0
                                                                     , inKoef_13     := 0
                                                                     , inKoef_22     := 0
                                                                     , inKoef_31     := 0
                                                                     , inKoef_32     := 0
                                                                     , inKoef_33     := 0
                                                                     , inKoef_41     := 0
                                                                     , inKoef_42     := 0
                                                                     , inKoef_43     := 0
                                                                     , inSession     := inSession
                                                                      ))
       , tmpMovement_WarehouseBranch AS
       (SELECT gpReport.UnitId, gpReport.UnitCode, gpReport.UnitName
             --, gpReport.PersonalId, gpReport.PersonalCode, gpReport.PersonalName
             , gpReport.PositionId, gpReport.PositionCode, gpReport.PositionName
        FROM tmpWageWarehouseBranch AS gpReport
             INNER JOIN (SELECT DISTINCT Setting_Wage_1.FromId, Setting_Wage_1.UnitId
                         FROM Setting_Wage_1
                         WHERE Setting_Wage_1.SelectKindId IN (-- Стикеровка
                                                               zc_Enum_SelectKind_MI_MasterSh()
                                                               -- Значение для клдв.
                                                             , zc_Enum_SelectKind_MovementCount_Ware(), zc_Enum_SelectKind_MI_MasterCount_Ware(), zc_Enum_SelectKind_MI_Master_Ware()
                                                               -- Значение возврат на филилал
                                                             , zc_Enum_SelectKind_MovementCount_WareIn(), zc_Enum_SelectKind_MI_Master_WareIn()
                                                               -- Значение возврат на Днепр
                                                             , zc_Enum_SelectKind_MI_Master_WareOut()
                                                              )
                           AND Setting_Wage_1.FromId > 0 OR Setting_Wage_1.UnitId > 0
                        ) AS tmpFrom ON (tmpFrom.FromId = gpReport.UnitId AND tmpFrom.FromId > 0)
                                     OR (tmpFrom.UnitId = gpReport.UnitId AND tmpFrom.UnitId > 0 AND COALESCE (tmpFrom.FromId, 0) = 0)
        GROUP BY gpReport.UnitId, gpReport.UnitCode, gpReport.UnitName
               , gpReport.PositionId, gpReport.PositionCode, gpReport.PositionName
       )

    , tmpKoeff AS (SELECT MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MovementCount() THEN Setting.Price ELSE 0 END)        AS koeff_1
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_MasterCount() THEN Setting.Price ELSE 0 END)       AS koeff_2
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master() THEN Setting.Price ELSE 0 END)            AS koeff_3
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_MasterSh() THEN Setting.Price ELSE 0 END)          AS koeff_4
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MovementCount_Ware() THEN Setting.Price ELSE 0 END)   AS koeff_5
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_MasterCount_Ware() THEN Setting.Price ELSE 0 END)  AS koeff_6
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master_Ware() THEN Setting.Price ELSE 0 END)       AS koeff_7
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MovementCount_WareIn() THEN Setting.Price ELSE 0 END) AS koeff_8
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master_WareIn() THEN Setting.Price ELSE 0 END)     AS koeff_9
                        , MAX (CASE WHEN Setting.SelectKindId = zc_Enum_SelectKind_MI_Master_WareOut() THEN Setting.Price ELSE 0 END)    AS koeff_10
                     
                      FROM Setting_Wage_1 AS Setting
                           INNER JOIN tmpMovement_WarehouseBranch AS tmpMovement_PersonalComplete
                                                                  ON ((tmpMovement_PersonalComplete.UnitId = Setting.FromId AND Setting.FromId > 0)
                                                                         OR (tmpMovement_PersonalComplete.UnitId = Setting.UnitId AND Setting.UnitId > 0 AND COALESCE (Setting.FromId, 0) = 0)
                                                                     )
                                                                 AND tmpMovement_PersonalComplete.PositionId = Setting.PositionId
                           
                  
                    WHERE Setting.SelectKindId IN (-- Стикеровка
                                                     zc_Enum_SelectKind_MI_MasterSh()
                                                     -- Значение для клдв.
                                                   , zc_Enum_SelectKind_MovementCount_Ware(), zc_Enum_SelectKind_MI_MasterCount_Ware(), zc_Enum_SelectKind_MI_Master_Ware()
                                                     -- Значение возврат на филилал
                                                   , zc_Enum_SelectKind_MovementCount_WareIn(), zc_Enum_SelectKind_MI_Master_WareIn()
                                                     -- Значение возврат на Днепр
                                                   , zc_Enum_SelectKind_MI_Master_WareOut()
                                                     --"Кол-во документов компл."
                                                   ,  zc_Enum_SelectKind_MovementCount()
                                                     --"Кол-во строк по документам компл."
                                                   , zc_Enum_SelectKind_MI_MasterCount()
                                                     --;"Кол-во вес по документам компл."
                                                   , zc_Enum_SelectKind_MI_Master()
                                                    )
                   )

     SELECT COALESCE (tmpKoeff.koeff_1, tmp.koeff_1)   ::TFloat AS koeff_11 
          , COALESCE (tmpKoeff.koeff_2, tmp.koeff_2)   ::TFloat AS koeff_12 
          , COALESCE (tmpKoeff.koeff_3, tmp.koeff_3)   ::TFloat AS koeff_13 
          , COALESCE (tmpKoeff.koeff_4, tmp.koeff_4)   ::TFloat AS koeff_22 
          , COALESCE (tmpKoeff.koeff_5, tmp.koeff_5)   ::TFloat AS koeff_31 
          , COALESCE (tmpKoeff.koeff_6, tmp.koeff_6)   ::TFloat AS koeff_32 
          , COALESCE (tmpKoeff.koeff_7, tmp.koeff_7)   ::TFloat AS koeff_33 
          , COALESCE (tmpKoeff.koeff_8, tmp.koeff_8)   ::TFloat AS koeff_41 
          , COALESCE (tmpKoeff.koeff_9, tmp.koeff_9)   ::TFloat AS koeff_42 
          , COALESCE (tmpKoeff.koeff_10, tmp.koeff_10) ::TFloat AS koeff_43
     
     FROM (SELECT 0,1  AS koeff_1
                , 0,3  AS koeff_2
                , 0,15 AS koeff_3
                , 0,1  AS koeff_4
                , 0,4  AS koeff_5
                , 0,3  AS koeff_6
                , 0,22 AS koeff_7
                , 0,4  AS koeff_8
                , 0,2  AS koeff_9
                , 0,2  AS koeff_10
           )  AS tmp
           FULL JOIN tmpKoeff ON 1 = 1  
 
 
 ;      

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.23          *
*/

-- тест
-- select * from gpGetReport_WageWarehouseBranch(inStartDate := ('01.09.2023')::TDateTime , inEndDate := ('30.09.2023')::TDateTime , inPersonalId := 0 , inPositionId := 0 , inBranchId := 301310 ,  inSession := '9457');