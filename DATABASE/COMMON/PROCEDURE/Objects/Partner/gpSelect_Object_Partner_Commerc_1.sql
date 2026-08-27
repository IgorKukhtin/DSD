-- Function: gpSelect_Object_Partner_Commerc_1()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Commerc_1 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_Commerc_1(
    IN inId          Integer,        -- Контрагенты 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Ord Integer,               
               PersonalName TVarChar,
               PositionName TVarChar,
               UnitName TVarChar
               )
AS
$BODY$
     DECLARE vbPersonalGroupCommercId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Partner());

     SELECT CASE WHEN TRIM (Object_PersonalGroupCommerc.ValueData) = '' THEN 0 ELSE Object_PersonalGroupCommerc.Id END :: Integer AS PersonalGroupCommercId
    INTO vbPersonalGroupCommercId 
     FROM ObjectLink AS ObjectLink_Partner_PersonalGroupCommerc
         LEFT JOIN Object AS Object_PersonalGroupCommerc ON Object_PersonalGroupCommerc.Id = ObjectLink_Partner_PersonalGroupCommerc.ChildObjectId
     WHERE ObjectLink_Partner_PersonalGroupCommerc.ObjectId = inId
       AND ObjectLink_Partner_PersonalGroupCommerc.DescId = zc_ObjectLink_Partner_PersonalGroupCommerc()
     ;

       
       RETURN QUERY
       WITH 
       tmpRouteTT AS (SELECT ObjectLink_Partner_RouteTT.ChildObjectId   AS RouteTTId
                           , ObjectLink_RouteTT_Unit.ChildObjectId      AS UnitId
                           , Object_Unit.ValueData           ::TVarChar AS UnitName
                           , ObjectLink_RouteTT_Position.ChildObjectId  AS PositionId
                           , CASE WHEN Object_PersonalGroup.ValueData <> '' THEN ObjectLink_RouteTT_PersonalGroup.ChildObjectId ELSE 0 END AS PersonalGroupId
                           , ObjectLink_RouteTT_Personal.ChildObjectId  AS PersonalId
                           --, Object_Personal.ValueData                  AS PersonalName
                           --
                           , ObjectLink_Personal_Position.ChildObjectId AS PositionId_Personal
                           , ObjectLink_Personal_Unit.ChildObjectId     AS UnitId_Personal
                           , CASE WHEN Object_PersonalGroup_Personal.ValueData <> '' THEN Object_PersonalGroup_Personal.Id ELSE 0 END AS PersonalGroupId_Personal
                           , COALESCE (ObjectBoolean_Main.ValueData, FALSE) ::Boolean AS isMain_Personal 
                           
                      FROM ObjectLink AS ObjectLink_Partner_RouteTT  --Маршрут ТТ контрагента
                       LEFT JOIN Object AS Object_RouteTT ON Object_RouteTT.Id = ObjectLink_Partner_RouteTT.ChildObjectId
                                LEFT JOIN ObjectLink AS ObjectLink_RouteTT_Unit
                                                     ON ObjectLink_RouteTT_Unit.ObjectId = Object_RouteTT.Id
                                                    AND ObjectLink_RouteTT_Unit.DescId = zc_ObjectLink_RouteTT_Unit()
                                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_RouteTT_Unit.ChildObjectId --
                      
                                LEFT JOIN ObjectLink AS ObjectLink_RouteTT_Position
                                                     ON ObjectLink_RouteTT_Position.ObjectId = Object_RouteTT.Id
                                                    AND ObjectLink_RouteTT_Position.DescId = zc_ObjectLink_RouteTT_Position()
                                LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_RouteTT_Position.ChildObjectId --
                      
                                LEFT JOIN ObjectLink AS ObjectLink_RouteTT_Personal
                                                     ON ObjectLink_RouteTT_Personal.ObjectId = Object_RouteTT.Id
                                                    AND ObjectLink_RouteTT_Personal.DescId = zc_ObjectLink_RouteTT_Personal()
                                --LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_RouteTT_Personal.ChildObjectId
                      
                                LEFT JOIN ObjectLink AS ObjectLink_RouteTT_PersonalGroup
                                                     ON ObjectLink_RouteTT_PersonalGroup.ObjectId = Object_RouteTT.Id
                                                    AND ObjectLink_RouteTT_PersonalGroup.DescId = zc_ObjectLink_RouteTT_PersonalGroup()
                                LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_RouteTT_PersonalGroup.ChildObjectId

                                --факт должность сотрудника
                                LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                     ON ObjectLink_Personal_Position.ObjectId = ObjectLink_RouteTT_Personal.ChildObjectId
                                                    AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                LEFT JOIN Object AS Object_Position_Personal ON Object_Position_Personal.Id = ObjectLink_Personal_Position.ChildObjectId
                                --факт подразделение сотрудника
                                LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                     ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_RouteTT_Personal.ChildObjectId
                                                    AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                LEFT JOIN Object AS Object_Unit_Personal ON Object_Unit_Personal.Id = ObjectLink_Personal_Unit.ChildObjectId
                                --факт группа сотрудника
                                LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                     ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_RouteTT_Personal.ChildObjectId
                                                    AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                LEFT JOIN Object AS Object_PersonalGroup_Personal ON Object_PersonalGroup_Personal.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                                --у сотрудника должно быть основное место работы
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                        ON ObjectBoolean_Main.ObjectId = ObjectLink_RouteTT_Personal.ChildObjectId
                                                       AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()

                       WHERE ObjectLink_Partner_RouteTT.ObjectId = inId --5817065  --inPartnerId
                        AND ObjectLink_Partner_RouteTT.DescId = zc_ObjectLink_Partner_RouteTT()
                      )

       --получем строку справочника, у которой 3 условия выполняются  -- подразд+ должность ур.1 + группа сотр. 1 
     , tmpCommercLocal AS (SELECT Object_CommercLocal.Id
                                , Object_Unit.Id                      ::Integer  AS UnitId
                                , Object_Unit.ValueData               ::TVarChar AS UnitName
                                , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                                , Object_Position_1.Id                ::Integer  AS PositionId_1
                                , Object_Position_1.ValueData         ::TVarChar AS PositionName_1 
                                , Object_PersonalGroup_1.Id           ::Integer  AS PersonalGroupId_1
                                , Object_PersonalGroup_1.ValueData    ::TVarChar AS PersonalGroupName_1
                                , Object_Position_2.Id                ::Integer  AS PositionId_2
                                , Object_Position_2.ValueData         ::TVarChar AS PositionName_2 
                                , Object_PersonalGroup_2.Id           ::Integer  AS PersonalGroupId_2
                                , Object_PersonalGroup_2.ValueData    ::TVarChar AS PersonalGroupName_2

                                , Object_Position_3.Id                ::Integer  AS PositionId_3
                                , Object_Position_3.ValueData         ::TVarChar AS PositionName_3
                                , Object_Position_4.Id                ::Integer  AS PositionId_4
                                , Object_Position_4.ValueData         ::TVarChar AS PositionName_4
                                , Object_Position_5.Id                ::Integer  AS PositionId_5
                                , Object_Position_5.ValueData         ::TVarChar AS PositionName_5
                                , Object_Position_6.Id                ::Integer  AS PositionId_6
                                , Object_Position_6.ValueData         ::TVarChar AS PositionName_6
  
                           FROM Object AS Object_CommercLocal
                                  INNER JOIN ObjectLink AS ObjectLink_CommercLocal_Unit
                                                        ON ObjectLink_CommercLocal_Unit.ObjectId = Object_CommercLocal.Id
                                                       AND ObjectLink_CommercLocal_Unit.DescId = zc_ObjectLink_CommercLocal_Unit()
                                                       AND ObjectLink_CommercLocal_Unit.ChildObjectId IN (SELECT DISTINCT tmpRouteTT.UnitId FROM tmpRouteTT)
                                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_CommercLocal_Unit.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                       ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_CommercLocal_Unit.ChildObjectId
                                                      AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                  --LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

                                  INNER JOIN ObjectLink AS ObjectLink_CommercLocal_Position_1
                                                        ON ObjectLink_CommercLocal_Position_1.ObjectId = Object_CommercLocal.Id
                                                       AND ObjectLink_CommercLocal_Position_1.DescId = zc_ObjectLink_CommercLocal_Position_1()
                                                       AND ObjectLink_CommercLocal_Position_1.ChildObjectId IN (SELECT DISTINCT tmpRouteTT.PositionId FROM tmpRouteTT)
                                  LEFT JOIN Object AS Object_Position_1 ON Object_Position_1.Id = ObjectLink_CommercLocal_Position_1.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_PersonalGroup_1
                                                       ON ObjectLink_CommercLocal_PersonalGroup_1.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_PersonalGroup_1.DescId = zc_ObjectLink_CommercLocal_PersonalGroup_1()
                                                      --AND ObjectLink_CommercLocal_PersonalGroup_1.ChildObjectId IN (SELECT DISTINCT tmpRouteTT.PersonalGroupId FROM tmpRouteTT)
                                  LEFT JOIN Object AS Object_PersonalGroup_1 ON Object_PersonalGroup_1.Id = ObjectLink_CommercLocal_PersonalGroup_1.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_2
                                                       ON ObjectLink_CommercLocal_Position_2.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_Position_2.DescId = zc_ObjectLink_CommercLocal_Position_2()
                                  LEFT JOIN Object AS Object_Position_2 ON Object_Position_2.Id = ObjectLink_CommercLocal_Position_2.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_PersonalGroup_2
                                                       ON ObjectLink_CommercLocal_PersonalGroup_2.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_PersonalGroup_2.DescId = zc_ObjectLink_CommercLocal_PersonalGroup_2()
                                  LEFT JOIN Object AS Object_PersonalGroup_2 ON Object_PersonalGroup_2.Id = ObjectLink_CommercLocal_PersonalGroup_2.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_3
                                                       ON ObjectLink_CommercLocal_Position_3.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_Position_3.DescId = zc_ObjectLink_CommercLocal_Position_3()
                                  LEFT JOIN Object AS Object_Position_3 ON Object_Position_3.Id = ObjectLink_CommercLocal_Position_3.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_4
                                                       ON ObjectLink_CommercLocal_Position_4.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_Position_4.DescId = zc_ObjectLink_CommercLocal_Position_4()
                                  LEFT JOIN Object AS Object_Position_4 ON Object_Position_4.Id = ObjectLink_CommercLocal_Position_4.ChildObjectId
                        
                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_5
                                                       ON ObjectLink_CommercLocal_Position_5.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_Position_5.DescId = zc_ObjectLink_CommercLocal_Position_5()
                                  LEFT JOIN Object AS Object_Position_5 ON Object_Position_5.Id = ObjectLink_CommercLocal_Position_5.ChildObjectId
                        
                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_6
                                                       ON ObjectLink_CommercLocal_Position_6.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_Position_6.DescId = zc_ObjectLink_CommercLocal_Position_6()
                                  LEFT JOIN Object AS Object_Position_6 ON Object_Position_6.Id = ObjectLink_CommercLocal_Position_6.ChildObjectId

                             WHERE Object_CommercLocal.DescId = zc_Object_CommercLocal()
                              AND Object_CommercLocal.isErased = FALSE
                              AND COALESCE (ObjectLink_CommercLocal_PersonalGroup_1.ChildObjectId,0) IN (SELECT DISTINCT COALESCE (tmpRouteTT.PersonalGroupId,0) FROM tmpRouteTT)
                             )

     , tmpRetail AS (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                          , ObjectLink_Retail_KAM.ChildObjectId       AS KAMId
                          , ObjectLink_Retail_KAM_add.ChildObjectId   AS KAM_addId
                          , ObjectLink_Retail_NOP_NM.ChildObjectId    AS NOP_NMId
                     FROM ObjectLink AS OL_Juridical
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = OL_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                          LEFT JOIN ObjectLink AS ObjectLink_Retail_KAM
                                               ON ObjectLink_Retail_KAM.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                              AND ObjectLink_Retail_KAM.DescId = zc_ObjectLink_Retail_KAM()

                          LEFT JOIN ObjectLink AS ObjectLink_Retail_KAM_add
                                               ON ObjectLink_Retail_KAM_add.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                              AND ObjectLink_Retail_KAM_add.DescId = zc_ObjectLink_Retail_KAM_add()

                          LEFT JOIN ObjectLink AS ObjectLink_Retail_NOP_NM
                                               ON ObjectLink_Retail_NOP_NM.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                              AND ObjectLink_Retail_NOP_NM.DescId = zc_ObjectLink_Retail_NOP_NM()
                      WHERE OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical() AND OL_Juridical.ObjectId = inId --5817065 --inPartnerId
                     )
     --список сотрудников из подразделения и Филиала
     , tmpPersonal_byUnit AS (SELECT Object_Personal.Id                              AS PersonalId
                                   , Object_Personal.ValueData                       AS PersonalName
                                   , ObjectLink_Personal_Position.ChildObjectId      AS PositionId
                                   , ObjectLink_Personal_PersonalGroup.ChildObjectId AS PersonalGroupId
                                   , Object_PersonalGroup.ValueData                  AS PersonalGroupName
                                   , ObjectLink_Personal_Unit.ChildObjectId          AS UnitId
                                   , Object_Unit.ValueData                           AS UnitName
                                   , ObjectLink_Unit_Branch.ChildObjectId            AS BranchId
                              FROM Object AS Object_Personal
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                        --AND ObjectLink_Personal_Unit.ChildObjectId = vbUnitId
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                        ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                   LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                        ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
 
                                   LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                        ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                       AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()                                  
                                                        
                              WHERE Object_Personal.DescId = zc_Object_Personal()
                                AND Object_Personal.isErased = FALSE 
                                AND (ObjectLink_Unit_Branch.ChildObjectId IN (SELECT DISTINCT tmpCommercLocal.BranchId FROM tmpCommercLocal)
                                  OR ObjectLink_Personal_Unit.ChildObjectId IN (SELECT DISTINCT tmpCommercLocal.UnitId FROM tmpCommercLocal))
                                AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd()
                              )

       --Заповнюється автоматично на основі маршруту, якщо вказана в маршруті посада співпадає з посадами поточного рівня відповідно до структури відділу 
     , tmpLevel1 AS (SELECT 1                              AS ord
                          , Object_Personal.Id             AS PersonalId
                          , Object_Personal.ValueData      AS PersonalName
                          , tmpCommercLocal.PositionId_1   AS PositionId
                          , tmpCommercLocal.PositionName_1 AS PositionName
                          , tmpCommercLocal.UnitId         AS UnitId
                          , tmpCommercLocal.UnitName       AS UnitName
                     FROM tmpRouteTT
                          INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                    AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                    AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                          --выбираем сотрудника по 3 усл. + главное место работы
                          LEFT JOIN Object AS Object_Personal
                                           ON Object_Personal.Id = CASE WHEN tmpRouteTT.PositionId = tmpRouteTT.PositionId_Personal
                                                                         AND tmpRouteTT.UnitId = tmpRouteTT.UnitId_Personal
                                                                         AND COALESCE (tmpRouteTT.PersonalGroupId,0) = COALESCE (tmpRouteTT.PersonalGroupId_Personal,0)
                                                                         AND tmpRouteTT.isMain_Personal = TRUE    
                                                                        THEN tmpRouteTT.PersonalId
                                                                        ELSE 0
                                                                   END
                     )
       --Автоматично - відносно рівня 1, відповідно до структури комерції, по співпадінню "Підрозділ торгівельної команди + посада (рівень 1) + група співробітників (рівень 1)". Якщо Рівень 1 - пусто, то Рівень 2 також пусто.
     , tmpLevel2 AS (SELECT 2                              AS ord
                          , COALESCE (tmpPersonal_byUnit.PersonalId, tmpPersonal_byBranch.PersonalId)     AS PersonalId
                          , COALESCE (tmpPersonal_byUnit.PersonalName, tmpPersonal_byBranch.PersonalName) AS PersonalName
                          , tmpCommercLocal.PositionId_2                                                  AS PositionId
                          , tmpCommercLocal.PositionName_2                                                AS PositionName
                          , COALESCE (tmpPersonal_byUnit.UnitId, tmpPersonal_byBranch.UnitId)             AS UnitId
                          , COALESCE (tmpPersonal_byUnit.UnitName, tmpPersonal_byBranch.UnitName)         AS UnitName
                     FROM tmpCommercLocal    -- элемент справочника уже соотв. 3 условиям из Маршрут ТТ
                          --находим сотружника по 3 условиям
                          LEFT JOIN tmpPersonal_byUnit ON tmpPersonal_byUnit.PositionId = tmpCommercLocal.PositionId_2
                                                      AND COALESCE (tmpPersonal_byUnit.PersonalGroupId, 0) = COALESCE (tmpCommercLocal.PersonalGroupId_2,0)
                                                      AND tmpPersonal_byUnit.UnitId = tmpCommercLocal.UnitId

                          --находим сотружника по 2 условиям + филиал,
                          LEFT JOIN tmpPersonal_byUnit AS tmpPersonal_byBranch
                                                       ON tmpPersonal_byBranch.PositionId = tmpCommercLocal.PositionId_2
                                                      AND COALESCE (tmpPersonal_byBranch.PersonalGroupId, 0) = COALESCE (tmpCommercLocal.PersonalGroupId_2,0)
                                                      AND tmpPersonal_byBranch.BranchId = tmpCommercLocal.BranchId
                                                      AND tmpPersonal_byUnit.PersonalId IS  NULL
                     )
       --Автоматично - відносно рівня 1, відповідно до структури комерції по співпадінню "Філія підрозділу (рівень 1) + посада (рівень 3). При умові, що по мережі в довіднику "Торгівельна мережа" поля "КАМ" та "НОП НМ" пусті. В іншому випадку пусто.
     , tmpLevel3 AS (SELECT 3                              AS ord
                          , tmpPersonal_byUnit.PersonalId
                          , tmpPersonal_byUnit.PersonalName
                          , tmpPersonal_byUnit.PositionId
                          , tmpCommercLocal.PositionName_3 AS PositionName
                          , tmpPersonal_byUnit.UnitId
                          , tmpPersonal_byUnit.UnitName
                     FROM tmpRouteTT
                          INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                    AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                   --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                          LEFT JOIN tmpPersonal_byUnit ON tmpPersonal_byUnit.PositionId = tmpCommercLocal.PositionId_3
                                                      AND tmpPersonal_byUnit.BranchId = tmpCommercLocal.BranchId
                          LEFT JOIN  tmpRetail ON 1 = 1
                     WHERE COALESCE (tmpRetail.KAMId,0) = 0 AND COALESCE (tmpRetail.NOP_NMId,0) = 0
                     )

       --Автоматично - відносно рівня 1, відповідно до структури комерції по співпадінню "Філія підрозділу (рівень 1) + посада (рівень 4)
     , tmpLevel4 AS (SELECT 4                              AS ord
                          , tmpPersonal_byUnit.PersonalId
                          , tmpPersonal_byUnit.PersonalName
                          , tmpPersonal_byUnit.PositionId
                          , tmpCommercLocal.PositionName_4 AS PositionName
                          , tmpPersonal_byUnit.UnitId
                          , tmpPersonal_byUnit.UnitName
                     FROM tmpRouteTT
                          INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                    AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                   --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                          LEFT JOIN tmpPersonal_byUnit ON tmpPersonal_byUnit.PositionId = tmpCommercLocal.PositionId_4
                                                      AND tmpPersonal_byUnit.BranchId = tmpCommercLocal.BranchId
                     )

       --Автоматично - відносно рівня 1, відповідно до структури комерції по співпадінню посади - рівень 5. При умові, що по мережі в довіднику "Торгівельна мережа" поле "НОП НМ" пусте. В іншому випадку пусто.
     , tmpLevel5 AS (SELECT 5                              AS ord
                          , Object_Personal.Id             AS PersonalId
                          , Object_Personal.ValueData      AS PersonalName
                          , tmpCommercLocal.PositionId_5   AS PositionId
                          , tmpCommercLocal.PositionName_5 AS PositionName
                          , Object_Unit.Id                 AS UnitId
                          , Object_Unit.ValueData          AS UnitName
                     FROM tmpRouteTT
                          INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                    AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                   --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                     
                          INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                ON ObjectLink_Personal_Position.ChildObjectId = tmpCommercLocal.PositionId_5 
                                               AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId
                      
                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                               ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                              AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
                     
                          LEFT JOIN  tmpRetail ON 1 = 1
                     WHERE COALESCE (tmpRetail.NOP_NMId,0) = 0
                     )
       --Автоматично - відносно рівня 1, відповідно до структури комерції по співпадінню посади - рівень 6. При умові, що по мережі в довіднику "Торгівельна мережа" поле "НОП НМ" пусте. В іншому випадку пусто.
     , tmpLevel6 AS (SELECT 6                              AS ord
                          , Object_Personal.Id             AS PersonalId
                          , Object_Personal.ValueData      AS PersonalName
                          , tmpCommercLocal.PositionId_6   AS PositionId
                          , tmpCommercLocal.PositionName_6 AS PositionName
                          , Object_Unit.Id                 AS UnitId
                          , Object_Unit.ValueData          AS UnitName
                     FROM tmpRouteTT
                          INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                    AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                   --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                     
                          INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                ON ObjectLink_Personal_Position.ChildObjectId = tmpCommercLocal.PositionId_6 
                                               AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId
                      
                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                               ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                              AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                             --AND ObjectLink_Personal_Unit.ChildObjectId = vbUnitId
                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
                     
                          LEFT JOIN  tmpRetail ON 1 = 1
                     WHERE COALESCE (tmpRetail.NOP_NMId,0) = 0
                     )

                     
 
       SELECT 1                 ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel1 AS tmp
      UNION
       SELECT 2                 ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel2 AS tmp
      UNION
       SELECT 3                 ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel3 AS tmp
      UNION
       SELECT 4                 ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel4 AS tmp
      UNION
       SELECT 5                 ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel5 AS tmp
      UNION
       SELECT 6                 ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel6 AS tmp
       ORDER BY 1
       ;
       
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.26         *
*/

-- тест
--  select * from gpGet_Object_Partner_Commerc (inId := 5817065 , inSession := '5');    
-- select * from gpSelect_Object_Partner_Commerc_1 (inId := 5817065 , inSession := '5');