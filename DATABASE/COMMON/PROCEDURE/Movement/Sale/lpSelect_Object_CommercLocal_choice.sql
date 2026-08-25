-- Function: lpSelect_Object_CommercLocal_choice()

DROP FUNCTION IF EXISTS gpSelect_Object_CommercLocal_byReport (Integer, Integer, Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_CommercLocal_byReport (Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpSelect_Object_CommercLocal_choice (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpSelect_Object_CommercLocal_choice(
    IN inMemberId_order        Integer  , --
    IN inUserId_source_order   Integer  , --  = 0 если EDI
    IN inRetailId              Integer  ,
    IN inRouteTTId             Integer  ,
    IN inPartnerId             Integer  ,
    IN inSession               TVarChar   -- сессия пользователя
)
RETURNS TABLE (Ord Integer
             , PositionName TVarChar
             , PersonalGroupName TVarChar
             , PersonalName Text
             , UnitName TVarChar
             , PositionName_inf TVarChar
             , PersonalGroupName_inf TVarChar
             , PersonalName_inf Text
             , UnitName_inf TVarChar
              )
AS
$BODY$
  DECLARE vbUserId          Integer;
          vbPersonalId      Integer;
          vbUnitId          Integer;
          vbPositionId_1      Integer;
          vbPersonalGroupId_1 Integer;
          vbBranchId          Integer;

          vbisEDI           Boolean;
          vbPersonalGroupCommercId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

    -- inUserId_source_order = 0 если док.
    vbisEDI:= (CASE WHEN COALESCE (inUserId_source_order,0) IN (0, 13992997, 13992996)  THEN TRUE ELSE FALSE END);
    --
    vbPersonalGroupCommercId:= (SELECT ObjectLink_Partner_PersonalGroupCommerc.ChildObjectId
                                FROM ObjectLink AS ObjectLink_Partner_PersonalGroupCommerc
                                WHERE ObjectLink_Partner_PersonalGroupCommerc.ObjectId = inPartnerId
                                  AND ObjectLink_Partner_PersonalGroupCommerc.DescId = zc_ObjectLink_Partner_PersonalGroupCommerc()
                                );

     --данные по пользователю для определения данных из справочника CommercLocal
     SELECT ObjectLink_Personal_Member.ObjectId              AS PersonalId
          , ObjectLink_Personal_Unit.ChildObjectId           AS UnitId
          , ObjectLink_Unit_Branch.ChildObjectId             AS BranchId
          , ObjectLink_Personal_Position.ChildObjectId       AS PositionId
          , COALESCE (ObjectLink_Personal_PersonalGroup.ChildObjectId,0)  AS PersonalGroupId
            INTO vbPersonalId, vbUnitId, vbBranchId, vbPositionId_1, vbPersonalGroupId_1
     FROM ObjectLink AS ObjectLink_Personal_Member
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                 ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                              ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                             AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                              ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                             AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
         LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                              ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_Personal_Member.ObjectId
                             AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                              ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                             AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
         LEFT JOIN ObjectDate AS ObjectDate_DateOut
                              ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                             AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
     WHERE ObjectLink_Personal_Member.ChildObjectId              = inMemberId_order
       AND ObjectLink_Personal_Member.DescId                     = zc_ObjectLink_Personal_Member()
       AND COALESCE (ObjectBoolean_Main.ValueData, FALSE)        = TRUE
       AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd()
     ;

         -- Результат
         RETURN QUERY
         WITH
         --
         tmpRouteTT AS (SELECT Object_RouteTT.Id                          AS RouteTTId
                             , ObjectLink_RouteTT_Unit.ChildObjectId      AS UnitId
                             , Object_Unit.ValueData           ::TVarChar AS UnitName
                             , ObjectLink_RouteTT_Position.ChildObjectId  AS PositionId
                             , CASE WHEN Object_PersonalGroup.ValueData <> '' THEN ObjectLink_RouteTT_PersonalGroup.ChildObjectId ELSE 0 END AS PersonalGroupId
                             , ObjectLink_RouteTT_Personal.ChildObjectId  AS PersonalId
                             , Object_Personal.ValueData                  AS PersonalName
                        FROM Object AS Object_RouteTT
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

                        WHERE Object_RouteTT.Id = inRouteTTId
                           AND Object_RouteTT.DescId = zc_Object_RouteTT()
                        )
       , tmpRetail AS (SELECT Object_Retail.Id                          AS RetailId
                            , ObjectLink_Retail_KAM.ChildObjectId       AS KAMId
                            , ObjectLink_Retail_KAM_add.ChildObjectId   AS KAM_addId
                            , ObjectLink_Retail_NOP_NM.ChildObjectId    AS NOP_NMId
                       FROM Object AS Object_Retail
                            LEFT JOIN ObjectLink AS ObjectLink_Retail_KAM
                                                 ON ObjectLink_Retail_KAM.ObjectId = Object_Retail.Id
                                                AND ObjectLink_Retail_KAM.DescId = zc_ObjectLink_Retail_KAM()

                            LEFT JOIN ObjectLink AS ObjectLink_Retail_KAM_add
                                                 ON ObjectLink_Retail_KAM_add.ObjectId = Object_Retail.Id
                                                AND ObjectLink_Retail_KAM_add.DescId = zc_ObjectLink_Retail_KAM_add()

                            LEFT JOIN ObjectLink AS ObjectLink_Retail_NOP_NM
                                                 ON ObjectLink_Retail_NOP_NM.ObjectId = Object_Retail.Id
                                                AND ObjectLink_Retail_NOP_NM.DescId = zc_ObjectLink_Retail_NOP_NM()
                        WHERE Object_Retail.DescId = zc_Object_Retail()
                          AND Object_Retail.Id = inRetailId
                       )

         --получем строку справочника, у которой подразд+ должность ур.1 + группа сотр. 1 соответствуют  пользователю созд. заявку
       , tmpCommercLocal AS (SELECT Object_CommercLocal.Id
                                  , Object_Unit.Id                      ::Integer  AS UnitId
                                  , Object_Unit.ValueData               ::TVarChar AS UnitName
                                  , 0 AS BranchId
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
                                                       AND ObjectLink_CommercLocal_Unit.ChildObjectId = vbUnitId
                                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_CommercLocal_Unit.ChildObjectId

                                  INNER JOIN ObjectLink AS ObjectLink_CommercLocal_Position_1
                                                        ON ObjectLink_CommercLocal_Position_1.ObjectId = Object_CommercLocal.Id
                                                       AND ObjectLink_CommercLocal_Position_1.DescId = zc_ObjectLink_CommercLocal_Position_1()
                                                       AND ObjectLink_CommercLocal_Position_1.ChildObjectId = vbPositionId_1
                                  LEFT JOIN Object AS Object_Position_1 ON Object_Position_1.Id = ObjectLink_CommercLocal_Position_1.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_PersonalGroup_1
                                                       ON ObjectLink_CommercLocal_PersonalGroup_1.ObjectId = Object_CommercLocal.Id
                                                      AND ObjectLink_CommercLocal_PersonalGroup_1.DescId = zc_ObjectLink_CommercLocal_PersonalGroup_1()
                                                      -- AND ObjectLink_CommercLocal_PersonalGroup_1.ChildObjectId = vbPersonalGroupId_1
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
                              AND COALESCE (ObjectLink_CommercLocal_PersonalGroup_1.ChildObjectId,0) = COALESCE (vbPersonalGroupId_1,0)
                              AND vbisEDI = FALSE
                            UNION
                             SELECT Object_CommercLocal.Id
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
                               AND vbisEDI = TRUE
                               AND COALESCE (ObjectLink_CommercLocal_PersonalGroup_1.ChildObjectId,0) IN (SELECT DISTINCT COALESCE (tmpRouteTT.PersonalGroupId,0) FROM tmpRouteTT)
                             )
                --список сотрудников из подразделения Пользователя заявки
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
                                         AND (ObjectLink_Unit_Branch.ChildObjectId = vbBranchId OR ObjectLink_Personal_Unit.ChildObjectId = vbUnitId)
                                       )

              , tmpLevel1 AS (SELECT 1 AS Ord
                                   , Object_Position_1.ValueData       AS PositionName
                                   , Object_PersonalGroup_1.ValueData ::TVarChar AS PersonalGroupName
                                   , Object_Personal.ValueData         AS PersonalName
                                   , Object_Unit.ValueData             AS UnitName
                              FROM object AS Object_Personal
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId
                                   LEFT JOIN Object AS Object_Position_1 ON Object_Position_1.Id = vbPositionId_1
                                   LEFT JOIN Object AS Object_PersonalGroup_1 ON Object_PersonalGroup_1.Id = vbPersonalGroupId_1
                              WHERE Object_Personal.Id = vbPersonalId
                                AND vbisEDI = FALSE
                             UNION
                              SELECT 1                              AS ord
                                   , tmpCommercLocal.PositionName_1 AS PositionName
                                   , Object_PersonalGroup.ValueData AS PersonalGroupName
                                   , Object_Personal.ValueData      AS PersonalName
                                   , tmpRouteTT.UnitName            AS UnitName
                              FROM tmpRouteTT
                                   INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                             AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                   LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = CASE WHEN tmpCommercLocal.Id IS NOT NULL THEN tmpRouteTT.PersonalId ELSE 0 END

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                              WHERE vbisEDI = TRUE
                              )

              , tmpLevel2 AS (SELECT 2 AS Ord
                                   , tmpCommercLocal.PositionName_2       AS PositionName
                                   , tmpCommercLocal.PersonalGroupName_2 ::TVarChar  AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpCommercLocal.UnitName            AS UnitName
                              FROM tmpCommercLocal
                                   INNER JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                 ON tmpPersonal.UnitId = tmpCommercLocal.UnitId
                                                                AND tmpPersonal.PositionId = tmpCommercLocal.PositionId_2
                                                                AND COALESCE (tmpPersonal.PersonalGroupId,0) = COALESCE (tmpCommercLocal.PersonalGroupId_2,0)
                                                               -- AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                              WHERE vbisEDI = FALSE
                              GROUP BY tmpCommercLocal.PositionName_2
                                     , tmpCommercLocal.PersonalGroupName_2
                                     , tmpCommercLocal.UnitName
                             UNION
                              SELECT 2                              AS ord
                                   , tmpCommercLocal.PositionName_2 AS PositionName
                                   , tmpCommercLocal.PersonalGroupName_2 ::TVarChar  AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpPersonal.UnitName
                              FROM tmpRouteTT
                                   INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                             AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                             AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = CASE WHEN COALESCE (tmpRouteTT.PersonalGroupId,0) <> 0 THEN COALESCE (tmpRouteTT.PersonalGroupId,0) ELSE COALESCE (vbPersonalGroupCommercId,0) END
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_2
                                                               AND COALESCE (tmpPersonal.PersonalGroupId, 0) = CASE WHEN COALESCE (tmpRouteTT.PersonalGroupId,0) <> 0 THEN COALESCE (tmpRouteTT.PersonalGroupId,0) ELSE COALESCE (vbPersonalGroupCommercId,0) END

                              WHERE (SELECT COUNT(*) FROM tmpLevel1) <> 0
                                AND vbisEDI = TRUE
                              GROUP BY tmpCommercLocal.PositionName_2
                                     , tmpCommercLocal.PersonalGroupName_2
                                     , tmpPersonal.UnitName
                              )

              , tmpLevel3 AS (--Для НЕ EDI    vbisEDI = Fa
                              SELECT 3 AS Ord
                                   , tmpCommercLocal.PositionName_3                     AS PositionName
                                   , String_AGG (DISTINCT tmpPersonal.PersonalGroupName, '; ') ::TVarChar AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpCommercLocal.UnitName                           AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.UnitId = tmpCommercLocal.UnitId
                                                               AND tmpPersonal.PositionId = tmpCommercLocal.PositionId_3
                                                               -- AND tmpPersonal.PersonalGroupId = tmpCommercLocal.PersonalGroupId_3
                              WHERE vbisEDI = FALSE
                              GROUP BY tmpCommercLocal.PositionName_3
                                     --, Object_PersonalGroup.ValueData
                                     , tmpCommercLocal.UnitName
                             UNION
                              SELECT 3                              AS ord
                                   , tmpCommercLocal.PositionName_3                                       AS PositionName
                                   , String_AGG (DISTINCT tmpPersonal.PersonalGroupName, '; ') ::TVarChar AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpPersonal.UnitName                                                 AS UnitName
                              FROM tmpRouteTT
                                   INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                             AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                            --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_3
                                                               AND tmpPersonal.BranchId = tmpCommercLocal.BranchId
                                   LEFT JOIN  tmpRetail ON 1 = 1
                              WHERE (COALESCE (tmpRetail.KAMId,0) = 0 AND COALESCE (tmpRetail.NOP_NMId,0) = 0)
                                AND vbisEDI = TRUE
                              GROUP BY tmpCommercLocal.PositionName_3
                                     , tmpPersonal.UnitName
                              )
               , tmpLevel4 AS (SELECT 4 AS Ord
                                   , tmpCommercLocal.PositionName_4                     AS PositionName
                                   , String_AGG (DISTINCT tmpPersonal.PersonalGroupName, '; ') ::TVarChar AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpPersonal.UnitName                               AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.BranchId = vbBranchId
                                                               AND tmpPersonal.PositionId = tmpCommercLocal.PositionId_4
                              WHERE vbisEDI = FALSE
                              GROUP BY tmpCommercLocal.PositionName_4
                                     --, Object_PersonalGroup.ValueData
                                     , tmpPersonal.UnitName
                             UNION
                              SELECT 4                              AS ord
                                   , tmpCommercLocal.PositionName_4
                                   , String_AGG (DISTINCT tmpPersonal.PersonalGroupName, '; ') ::TVarChar AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpPersonal.UnitName           AS UnitName
                              FROM tmpRouteTT
                                   INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                             AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                            --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_4
                                                               AND tmpPersonal.BranchId = tmpCommercLocal.BranchId
                              WHERE vbisEDI = TRUE
                              GROUP BY tmpCommercLocal.PositionName_4
                                     , tmpPersonal.UnitName
                              )

              , tmpLevel5 AS (SELECT 5 AS Ord
                                   , tmpCommercLocal.PositionName_5        AS PositionName
                                   , String_AGG (DISTINCT tmpPersonal.PersonalGroupName, '; ') ::TVarChar  AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpPersonal.UnitName            AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_5
                              WHERE vbisEDI = FALSE
                              GROUP BY tmpCommercLocal.PositionName_5
                                     , tmpPersonal.UnitName
                             UNION
                              SELECT 5                              AS ord
                                   , tmpCommercLocal.PositionName_5 AS PositionName
                                   , String_AGG (DISTINCT Object_PersonalGroup.ValueData, '; ') ::TVarChar  AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData) ::Text  AS PersonalName
                                   , Object_Unit.ValueData          AS UnitName
                              FROM tmpRouteTT
                                   INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                             AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                            --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)

                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                         ON ObjectLink_Personal_Position.ChildObjectId = tmpCommercLocal.PositionId_5
                                                        AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                   LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                                   LEFT JOIN  tmpRetail ON 1 = 1
                              WHERE COALESCE (tmpRetail.NOP_NMId,0) = 0
                                AND vbisEDI = TRUE
                              GROUP BY tmpCommercLocal.PositionName_5
                                     , Object_Unit.ValueData
                              )

              , tmpLevel6 AS (SELECT 6 AS Ord
                                   , tmpCommercLocal.PositionName_6 AS PositionName
                                   , String_AGG (DISTINCT Object_PersonalGroup.ValueData, '; ') ::TVarChar  AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData) ::Text  AS PersonalName
                                   , Object_Unit.ValueData          AS UnitName
                              FROM tmpCommercLocal
                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                         ON ObjectLink_Personal_Position.ChildObjectId = tmpCommercLocal.PositionId_6
                                                        AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                   LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
                              WHERE vbisEDI = FALSE
                              GROUP BY tmpCommercLocal.PositionName_6
                                     , Object_Unit.ValueData
                             UNION
                              SELECT 6                              AS ord
                                   , tmpCommercLocal.PositionName_6 AS PositionName
                                   , String_AGG (DISTINCT Object_PersonalGroup.ValueData, '; ') ::TVarChar  AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData) ::Text  AS PersonalName
                                   , Object_Unit.ValueData          AS UnitName
                              FROM tmpRouteTT
                                   INNER JOIN tmpCommercLocal ON tmpCommercLocal.UnitId = tmpRouteTT.UnitId
                                                             AND tmpCommercLocal.PositionId_1 = tmpRouteTT.PositionId
                                                            --AND COALESCE (tmpCommercLocal.PersonalGroupId_1,0) = COALESCE (tmpRouteTT.PersonalGroupId,0)

                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                         ON ObjectLink_Personal_Position.ChildObjectId = tmpCommercLocal.PositionId_6
                                                        AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                   LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                      --AND ObjectLink_Personal_Unit.ChildObjectId = vbUnitId
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                                   LEFT JOIN  tmpRetail ON 1 = 1
                              WHERE COALESCE (tmpRetail.NOP_NMId,0) = 0
                                AND vbisEDI = TRUE
                              GROUP BY tmpCommercLocal.PositionName_6
                                     , Object_Unit.ValueData
                              )

         SELECT tmp.Ord               ::Integer
              , tmp.PositionName      ::TVarChar
              , tmp.PersonalGroupName ::TVarChar
              , tmp.PersonalName      ::Text
              , tmp.UnitName          ::TVarChar

              , '' ::TVarChar AS PositionName_inf
              , '' ::TVarChar AS PersonalGroupName_inf
              , '' ::Text     AS PersonalName_inf
              , '' ::TVarChar AS UnitName_inf
         FROM (SELECT tmp.Ord
                    , tmp.PositionName
                    , tmp.PersonalGroupName
                    , tmp.PersonalName ::Text
                    , tmp.UnitName
               FROM tmpLevel1 AS tmp
               WHERE vbisEDI = False
              UNION ALL
               SELECT 2 AS Ord
                    , COALESCE (tmp.PositionName, tmpCommercLocal.PositionName_2)           AS PositionName
                    , COALESCE (tmp.PersonalGroupName, tmpCommercLocal.PersonalGroupName_2) AS PersonalGroupName
                    , tmp.PersonalName ::Text
                    , COALESCE (tmp.UnitName, tmpCommercLocal.UnitName) AS UnitName
               FROM tmpCommercLocal
                    LEFT JOIN tmpLevel2 AS tmp ON 1 = 1
               WHERE vbisEDI = False
              UNION
               SELECT 3 AS Ord
                    , CASE WHEN vbisEDI = FALSE THEN COALESCE (tmp.PositionName, tmpCommercLocal.PositionName_3) ELSE tmp.PositionName END AS PositionName
                    , tmp.PersonalGroupName
                    , tmp.PersonalName ::Text
                    , CASE WHEN vbisEDI = FALSE THEN COALESCE (tmp.UnitName, tmpCommercLocal.UnitName) ELSE tmp.UnitName END  AS UnitName
               FROM tmpCommercLocal
                    LEFT JOIN tmpLevel3 AS tmp ON 1 = 1
              UNION
               SELECT 4 AS Ord
                    , CASE WHEN vbisEDI = FALSE THEN COALESCE (tmp.PositionName, tmpCommercLocal.PositionName_4) ELSE tmp.PositionName END AS PositionName
                    , tmp.PersonalGroupName
                    , tmp.PersonalName ::Text
                    , CASE WHEN vbisEDI = FALSE THEN COALESCE (tmp.UnitName, tmpCommercLocal.UnitName) ELSE tmp.UnitName END AS UnitName
               FROM tmpCommercLocal
                    LEFT JOIN tmpLevel4 AS tmp ON 1 = 1
              UNION
               SELECT 5 AS Ord
                    , CASE WHEN vbisEDI = FALSE THEN COALESCE (tmp.PositionName, tmpCommercLocal.PositionName_5) ELSE tmp.PositionName END AS PositionName
                    , tmp.PersonalGroupName
                    , tmp.PersonalName ::Text
                    ,  tmp.UnitName
               FROM tmpCommercLocal
                    LEFT JOIN tmpLevel5 AS tmp ON 1 = 1
              UNION
               SELECT 6 AS Ord
                    , CASE WHEN vbisEDI = FALSE THEN COALESCE (tmp.PositionName, tmpCommercLocal.PositionName_6) ELSE tmp.PositionName END AS PositionName
                    , tmp.PersonalGroupName
                    , tmp.PersonalName ::Text
                    , tmp.UnitName
               FROM tmpCommercLocal
                    LEFT JOIN tmpLevel6 AS tmp ON 1 = 1
              ) AS tmp
        UNION ALL --схема для Маршрут ТТ информативно
              SELECT
                     1 AS Ord
                   , '' ::TVarChar AS PositionName
                   , '' ::TVarChar AS PersonalGroupName
                   , '' ::Text     AS PersonalName
                   , '' ::TVarChar AS UnitName

                   , tmp.PositionName        AS PositionName_inf
                   , tmp.PersonalGroupName   AS PersonalGroupName_inf
                   , tmp.PersonalName ::Text AS PersonalName_inf
                   , tmp.UnitName            AS UnitName_inf
              FROM tmpLevel1 AS tmp
              WHERE vbisEDI = TRUE
        UNION ALL --схема для Маршрут ТТ информативно
              SELECT
                     2 AS Ord
                   , '' ::TVarChar AS PositionName
                   , '' ::TVarChar AS PersonalGroupName
                   , '' ::Text AS PersonalName
                   , '' ::TVarChar AS UnitName

                   , tmp.PositionName        AS PositionName_inf
                   , tmp.PersonalGroupName   AS PersonalGroupName_inf
                   , tmp.PersonalName ::Text AS PersonalName_inf
                   , tmp.UnitName            AS UnitName_inf
              FROM tmpLevel2 AS tmp
              WHERE vbisEDI = TRUE
        ORDER BY 1
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.26         *
*/

-- тест
-- SELECT * FROM lpSelect_Object_CommercLocal_choice (inMemberId_order := 9481147, inUserId_source_order:= 9481147, inRetailId := 310839, inRouteTTId:= 13943997, inPartnerId:= 334900,  inSession := '9457'); --EDI
