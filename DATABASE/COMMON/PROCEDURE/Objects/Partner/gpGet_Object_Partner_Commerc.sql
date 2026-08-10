-- Function: gpGet_Object_Partner_Commerc()

DROP FUNCTION IF EXISTS gpGet_Object_Partner_Commerc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner_Commerc(
    IN inId          Integer,        -- Контрагенты 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,               
               PersonalId_1 Integer, PersonalName_1 TVarChar,
               PersonalId_2 Integer, PersonalName_2 TVarChar,
               PersonalId_3 Integer, PersonalName_3 TVarChar,
               PersonalId_4 Integer, PersonalName_4 TVarChar,
               PersonalId_5 Integer, PersonalName_5 TVarChar,
               PersonalId_6 Integer, PersonalName_6 TVarChar,
               PositionId_1 Integer, PositionName_1 TVarChar,
               PositionId_2 Integer, PositionName_2 TVarChar,
               PositionId_3 Integer, PositionName_3 TVarChar,
               PositionId_4 Integer, PositionName_4 TVarChar,
               PositionId_5 Integer, PositionName_5 TVarChar,
               PositionId_6 Integer, PositionName_6 TVarChar,
               UnitId_1 Integer, UnitName_1 TVarChar,
               UnitId_2 Integer, UnitName_2 TVarChar,
               UnitId_3 Integer, UnitName_3 TVarChar,
               UnitId_4 Integer, UnitName_4 TVarChar,
               UnitId_5 Integer, UnitName_5 TVarChar,
               UnitId_6 Integer, UnitName_6 TVarChar,
               --
               PersonalName_1ret TVarChar,
               PersonalName_2ret TVarChar,
               PersonalName_3ret TVarChar,
               PositionName_1ret TVarChar,
               PositionName_2ret TVarChar,
               PositionName_3ret TVarChar,
               UnitName_1ret TVarChar,
               UnitName_2ret TVarChar,
               UnitName_3ret TVarChar
               )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Partner());

       RETURN QUERY
       WITH 
       tmpRouteTT AS (SELECT ObjectLink_Partner_RouteTT.ChildObjectId   AS RouteTTId
                           , ObjectLink_RouteTT_Unit.ChildObjectId      AS UnitId
                           , Object_Unit.ValueData           ::TVarChar AS UnitName
                           , ObjectLink_RouteTT_Position.ChildObjectId  AS PositionId
                           , CASE WHEN Object_PersonalGroup.ValueData <> '' THEN ObjectLink_RouteTT_PersonalGroup.ChildObjectId ELSE 0 END AS PersonalGroupId
                           , ObjectLink_RouteTT_Personal.ChildObjectId  AS PersonalId
                           , Object_Personal.ValueData                  AS PersonalName
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
                                LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_RouteTT_Personal.ChildObjectId
                      
                                LEFT JOIN ObjectLink AS ObjectLink_RouteTT_PersonalGroup
                                                     ON ObjectLink_RouteTT_PersonalGroup.ObjectId = Object_RouteTT.Id
                                                    AND ObjectLink_RouteTT_PersonalGroup.DescId = zc_ObjectLink_RouteTT_PersonalGroup()
                                LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_RouteTT_PersonalGroup.ChildObjectId
                      
                      WHERE ObjectLink_Partner_RouteTT.ObjectId = inId --5817065  --inPartnerId
                        AND ObjectLink_Partner_RouteTT.DescId = zc_ObjectLink_Partner_RouteTT()
                      )

         --получем строку справочника, у которой подразд+ должность ур.1 + группа сотр. 1 соответствуют  пользователю созд. заявку
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
                              WHERE Object_Personal.DescId = zc_Object_Personal()
                                AND Object_Personal.isErased = FALSE 
                                AND (ObjectLink_Unit_Branch.ChildObjectId IN (SELECT DISTINCT tmpCommercLocal.BranchId FROM tmpCommercLocal)
                                  OR ObjectLink_Personal_Unit.ChildObjectId IN (SELECT DISTINCT tmpCommercLocal.UnitId FROM tmpCommercLocal))
                              )
       --Заповнюється автоматично на основі маршруту, якщо вказана в маршруті посада співпадає з посадами поточного рівня відповідно до структури відділу 
     , tmpLevel1 AS (SELECT 1                              AS ord
                     , Object_Personal.Id             AS PersonalId
                     , Object_Personal.ValueData      AS PersonalName
                     , tmpCommercLocal.PositionId_1   AS PositionId
                     , tmpCommercLocal.PositionName_1 AS PositionName
                     , tmpRouteTT.UnitId              AS UnitId
                     , tmpRouteTT.UnitName            AS UnitName
                FROM tmpRouteTT
                     INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                               AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                     LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = CASE WHEN tmpCommercLocal.Id IS NOT NULL THEN tmpRouteTT.PersonalId ELSE 0 END
                )
       --Автоматично - відносно рівня 1, відповідно до структури комерції, по співпадінню "Підрозділ торгівельної команди + посада (рівень 1) + група співробітників (рівень 1)". Якщо Рівень 1 - пусто, то Рівень 2 також пусто.
     , tmpLevel2 AS (SELECT 2                              AS ord
                          , tmpPersonal_byUnit.PersonalId
                          , tmpPersonal_byUnit.PersonalName
                          , tmpPersonal_byUnit.PositionId
                          , tmpCommercLocal.PositionName_2 AS PositionName
                          , tmpPersonal_byUnit.UnitId
                          , tmpPersonal_byUnit.UnitName
                     FROM tmpRouteTT
                          INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                    AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                    AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                          LEFT JOIN tmpPersonal_byUnit ON tmpPersonal_byUnit.PositionId = tmpCommercLocal.PositionId_2 
                     WHERE (SELECT COUNT(*) FROM tmpLevel1) <> 0
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
     --Сети
     , tmpCommercRetail AS (SELECT Object_Position_1.Id                ::Integer  AS PositionId_1
                                 , Object_Position_1.ObjectCode        ::Integer  AS PositionCode_1
                                 , Object_Position_1.ValueData         ::TVarChar AS PositionName_1 
                                 , Object_Position_2.Id                ::Integer  AS PositionId_2
                                 , Object_Position_2.ObjectCode        ::Integer  AS PositionCode_2
                                 , Object_Position_2.ValueData         ::TVarChar AS PositionName_2 
                                 , Object_Position_3.Id                ::Integer  AS PositionId_3
                                 , Object_Position_3.ObjectCode        ::Integer  AS PositionCode_3
                                 , Object_Position_3.ValueData         ::TVarChar AS PositionName_3
                                 , ObjectLink_CommercRetail_PersonalGroup_1.ChildObjectId ::Integer  AS PersonalGroupId
                            FROM Object AS Object_CommercRetail
                                 INNER JOIN ObjectLink AS ObjectLink_CommercRetail_Retail
                                                       ON ObjectLink_CommercRetail_Retail.ObjectId = Object_CommercRetail.Id
                                                      AND ObjectLink_CommercRetail_Retail.DescId = zc_ObjectLink_CommercRetail_Retail()
                                                      AND ObjectLink_CommercRetail_Retail.ChildObjectId IN (SELECT DISTINCT tmpRetail.RetailId FROM tmpRetail)
                                 --LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_CommercRetail_Retail.ChildObjectId
                       
                                 LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_Position_1
                                                      ON ObjectLink_CommercRetail_Position_1.ObjectId = Object_CommercRetail.Id
                                                     AND ObjectLink_CommercRetail_Position_1.DescId = zc_ObjectLink_CommercRetail_Position_1()
                                 LEFT JOIN Object AS Object_Position_1 ON Object_Position_1.Id = ObjectLink_CommercRetail_Position_1.ChildObjectId
                       
                                 LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_Position_2
                                                      ON ObjectLink_CommercRetail_Position_2.ObjectId = Object_CommercRetail.Id
                                                     AND ObjectLink_CommercRetail_Position_2.DescId = zc_ObjectLink_CommercRetail_Position_2()
                                 LEFT JOIN Object AS Object_Position_2 ON Object_Position_2.Id = ObjectLink_CommercRetail_Position_2.ChildObjectId
                       
                                 LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_Position_3
                                                      ON ObjectLink_CommercRetail_Position_3.ObjectId = Object_CommercRetail.Id
                                                     AND ObjectLink_CommercRetail_Position_3.DescId = zc_ObjectLink_CommercRetail_Position_3()
                                 LEFT JOIN Object AS Object_Position_3 ON Object_Position_3.Id = ObjectLink_CommercRetail_Position_3.ChildObjectId
                       
                                 LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_PersonalGroup_1
                                                      ON ObjectLink_CommercRetail_PersonalGroup_1.ObjectId = Object_CommercRetail.Id
                                                     AND ObjectLink_CommercRetail_PersonalGroup_1.DescId = zc_ObjectLink_CommercRetail_PersonalGroup_1()
                                 --LEFT JOIN Object AS Object_PersonalGroup_1 ON Object_PersonalGroup_1.Id = ObjectLink_CommercRetail_PersonalGroup_1.ChildObjectId
                       
                            WHERE Object_CommercRetail.DescId = zc_Object_CommercRetail()
                              AND Object_CommercRetail.isErased = FALSE
                           )


     , tmpLevel1_Ret AS (SELECT Count (*) AS Count
                              , STRING_AGG (tmpPersonal_byUnit.PersonalName, ';') AS PersonalName
                              , STRING_AGG (tmpCommercRetail.PositionName_1, ';') AS PositionName
                              , STRING_AGG (tmpPersonal_byUnit.UnitName, ';')     AS UnitName
                         FROM tmpCommercRetail
                              LEFT JOIN tmpPersonal_byUnit ON tmpPersonal_byUnit.PositionId = tmpCommercRetail.PositionId_1
                         )
     , tmpLevel2_Ret AS (SELECT Count (*) AS Count
                              , STRING_AGG (tmpPersonal_byUnit.PersonalName, ';') AS PersonalName
                              , STRING_AGG (tmpCommercRetail.PositionName_2, ';') AS PositionName
                              , STRING_AGG (tmpPersonal_byUnit.UnitName, ';')     AS UnitName
                         FROM tmpCommercRetail
                              LEFT JOIN tmpPersonal_byUnit ON tmpPersonal_byUnit.PositionId = tmpCommercRetail.PositionId_2
                         )
     , tmpLevel3_Ret AS (SELECT Count (*) AS Count
                              , STRING_AGG (tmpPersonal_byUnit.PersonalName, ';') AS PersonalName
                              , STRING_AGG (tmpCommercRetail.PositionName_3, ';') AS PositionName
                              , STRING_AGG (tmpPersonal_byUnit.UnitName, ';')     AS UnitName
                         FROM tmpCommercRetail
                              LEFT JOIN tmpPersonal_byUnit ON tmpPersonal_byUnit.PositionId = tmpCommercRetail.PositionId_3
                         )

                     
 
       SELECT 
             Object_Partner.Id          :: Integer AS Id
           , Object_Partner.ObjectCode  :: Integer AS Code
           , Object_Partner.ValueData   :: TVarChar AS Name
           
           , tmpLevel1.PersonalId  ::Integer         AS PersonalId_1
           , tmpLevel1.PersonalName::TVarChar        AS PersonalName_1
           , tmpLevel2.PersonalId  ::Integer         AS PersonalId_2
           , tmpLevel2.PersonalName::TVarChar        AS PersonalName_2
           , tmpLevel3.PersonalId  ::Integer         AS PersonalId_3
           , tmpLevel3.PersonalName::TVarChar        AS PersonalName_3
           , tmpLevel4.PersonalId  ::Integer         AS PersonalId_4
           , tmpLevel4.PersonalName::TVarChar        AS PersonalName_4
           , tmpLevel5.PersonalId  ::Integer         AS PersonalId_5
           , tmpLevel5.PersonalName::TVarChar        AS PersonalName_5
           , tmpLevel6.PersonalId  ::Integer         AS PersonalId_6
           , tmpLevel6.PersonalName::TVarChar        AS PersonalName_6

           , tmpLevel1.PositionId  ::Integer         AS PositionId_1
           , tmpLevel1.PositionName::TVarChar        AS PositionName_1
           , tmpLevel2.PositionId  ::Integer         AS PositionId_2
           , tmpLevel2.PositionName::TVarChar        AS PositionName_2
           , tmpLevel3.PositionId  ::Integer         AS PositionId_3
           , tmpLevel3.PositionName::TVarChar        AS PositionName_3
           , tmpLevel4.PositionId  ::Integer         AS PositionId_4
           , tmpLevel4.PositionName::TVarChar        AS PositionName_4
           , tmpLevel5.PositionId  ::Integer         AS PositionId_5
           , tmpLevel5.PositionName::TVarChar        AS PositionName_5
           , tmpLevel6.PositionId  ::Integer         AS PositionId_6
           , tmpLevel6.PositionName::TVarChar        AS PositionName_6
         
           , tmpLevel1.UnitId  ::Integer         AS UnitId_1
           , tmpLevel1.UnitName::TVarChar        AS UnitName_1
           , tmpLevel2.UnitId  ::Integer         AS UnitId_2
           , tmpLevel2.UnitName::TVarChar        AS UnitName_2
           , tmpLevel3.UnitId  ::Integer         AS UnitId_3
           , tmpLevel3.UnitName::TVarChar        AS UnitName_3
           , tmpLevel4.UnitId  ::Integer         AS UnitId_4
           , tmpLevel4.UnitName::TVarChar        AS UnitName_4
           , tmpLevel5.UnitId  ::Integer         AS UnitId_5
           , tmpLevel5.UnitName::TVarChar        AS UnitName_5
           , tmpLevel6.UnitId  ::Integer         AS UnitId_6
           , tmpLevel6.UnitName::TVarChar        AS UnitName_6

           --
           , (CASE WHEN COALESCE (tmpLevel1_Ret.Count,0) > 1 THEN '('||tmpLevel1_Ret.Count::TVarChar||')' ELSE '' END ||tmpLevel1_Ret.PersonalName ) ::TVarChar  AS PersonalName_1ret 
           , (CASE WHEN COALESCE (tmpLevel1_Ret.Count,0) > 1 THEN '('||tmpLevel1_Ret.Count::TVarChar||')' ELSE '' END ||tmpLevel2_Ret.PersonalName ) ::TVarChar  AS PersonalName_2ret
           , (CASE WHEN COALESCE (tmpLevel1_Ret.Count,0) > 1 THEN '('||tmpLevel1_Ret.Count::TVarChar||')' ELSE '' END ||tmpLevel3_Ret.PersonalName ) ::TVarChar  AS PersonalName_3ret
           , tmpLevel1_Ret.PositionName ::TVarChar  AS PositionName_1ret
           , tmpLevel2_Ret.PositionName ::TVarChar  AS PositionName_2ret
           , tmpLevel3_Ret.PositionName ::TVarChar  AS PositionName_3ret
           , tmpLevel1_Ret.UnitName     ::TVarChar  AS UnitName_1ret    
           , tmpLevel2_Ret.UnitName     ::TVarChar  AS UnitName_2ret    
           , tmpLevel3_Ret.UnitName     ::TVarChar  AS UnitName_3ret    
       FROM Object AS Object_Partner
            LEFT JOIN tmpLevel1 ON 1=1
            LEFT JOIN tmpLevel2 ON 1=1
            LEFT JOIN tmpLevel3 ON 1=1
            LEFT JOIN tmpLevel4 ON 1=1
            LEFT JOIN tmpLevel5 ON 1=1
            LEFT JOIN tmpLevel6 ON 1=1
            LEFT JOIN tmpLevel1_Ret ON 1=1
            LEFT JOIN tmpLevel2_Ret ON 1=1
            LEFT JOIN tmpLevel3_Ret ON 1=1
       WHERE Object_Partner.Id = inId;
       
   
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
-- select * from gpGet_Object_Partner_Commerc (inId := 5817065 , inSession := '5');