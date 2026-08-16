-- Function: lpSelect_Object_CommercRetail_choice()

DROP FUNCTION IF EXISTS gpSelect_Object_CommercRetail_byReport (Integer,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS lpSelect_Object_CommercRetail_choice (Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpSelect_Object_CommercRetail_choice(
    IN inMemberId_order        Integer  , --
    IN inRetailId              Integer  ,
    IN inContractTagId         Integer  ,
    IN inSession              TVarChar   -- сессия пользователя
)
RETURNS TABLE (Ord Integer
             , PositionName TVarChar
             , PersonalGroupName TVarChar
             , PersonalName Text
             , UnitName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId          Integer;
          vbUnitId          Integer;
          vbBranchId        Integer;
          vbPositionId_ContractTag Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     vbPositionId_ContractTag := (SELECT ObjectLink_ContractTag_Position.ChildObjectId AS PositionId_ContractTag
                                  FROM ObjectLink AS ObjectLink_ContractTag_Position
                                  WHERE ObjectLink_ContractTag_Position.ObjectId = inContractTagId
                                    AND ObjectLink_ContractTag_Position.DescId = zc_ObjectLink_ContractTag_Position()
                                  );

     --данные по пользователю для определения данных из справочника CommercRetail
     SELECT ObjectLink_Personal_Unit.ChildObjectId           AS UnitId
          , ObjectLink_Unit_Branch.ChildObjectId             AS BranchId
            INTO vbUnitId, vbBranchId
     FROM ObjectLink AS ObjectLink_Personal_Member
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                 ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
         LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                              ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                             AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
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
         tmpCommercRetail AS (SELECT Object_CommercRetail.Id
                                   , Object_Retail.Id                    ::Integer  AS RetailId
                                   , Object_Retail.ValueData             ::TVarChar AS RetailName

                                   , Object_PersonalGroup_1.Id           ::Integer  AS PersonalGroupId_1
                                   , Object_PersonalGroup_1.ValueData    ::TVarChar AS PersonalGroupName_1
                                   , Object_Position_1.Id                ::Integer  AS PositionId_1
                                   , Object_Position_1.ValueData         ::TVarChar AS PositionName_1
                                   , Object_Position_2.Id                ::Integer  AS PositionId_2
                                   , Object_Position_2.ValueData         ::TVarChar AS PositionName_2
                                   , Object_Position_3.Id                ::Integer  AS PositionId_3
                                   , Object_Position_3.ValueData         ::TVarChar AS PositionName_3

                              FROM Object AS Object_CommercRetail
                                   INNER JOIN ObjectLink AS ObjectLink_CommercRetail_Retail
                                                         ON ObjectLink_CommercRetail_Retail.ObjectId = Object_CommercRetail.Id
                                                        AND ObjectLink_CommercRetail_Retail.DescId = zc_ObjectLink_CommercRetail_Retail()
                                                        AND ObjectLink_CommercRetail_Retail.ChildObjectId = inRetailId
                                   LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_CommercRetail_Retail.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_PersonalGroup_1
                                                        ON ObjectLink_CommercRetail_PersonalGroup_1.ObjectId = Object_CommercRetail.Id
                                                       AND ObjectLink_CommercRetail_PersonalGroup_1.DescId = zc_ObjectLink_CommercRetail_PersonalGroup_1()
                                   LEFT JOIN Object AS Object_PersonalGroup_1 ON Object_PersonalGroup_1.Id = ObjectLink_CommercRetail_PersonalGroup_1.ChildObjectId

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

                              WHERE Object_CommercRetail.DescId = zc_Object_CommercRetail()
                                AND Object_CommercRetail.isErased = FALSE
                             )
                --получаем сотрудника из справочника торговой сети Помошник КАМ
              , tmpLevel1 AS (SELECT 1 AS Ord
                                   , Object_Position.ValueData       AS PositionName
                                   , Object_PersonalGroup.ValueData  AS PersonalGroupName
                                   , Object_Personal.ValueData       AS PersonalName
                                   , Object_Unit.ValueData           AS UnitName
                              FROM ObjectLink AS ObjectLink_Retail_KAM_add
                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = ObjectLink_Retail_KAM_add.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                        ON ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                       AND ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                   LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                                   LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                        ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                       AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
                              WHERE ObjectLink_Retail_KAM_add.ObjectId = inRetailId
                                AND ObjectLink_Retail_KAM_add.DescId = zc_ObjectLink_Retail_KAM_add()
                                AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd()
                              )

                --получаем сотрудника из справочника торговой сети сотрудник КАМ
              , tmpLevel2 AS (SELECT 2 AS Ord
                                   , Object_Position.ValueData       AS PositionName
                                   , Object_PersonalGroup.ValueData  AS PersonalGroupName
                                   , Object_Personal.ValueData       AS PersonalName
                                   , Object_Unit.ValueData           AS UnitName
                              FROM ObjectLink AS ObjectLink_Retail_KAM
                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = ObjectLink_Retail_KAM.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                        ON ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                       AND ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                   LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                                   LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                        ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                       AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
                              WHERE ObjectLink_Retail_KAM.ObjectId = inRetailId
                                AND ObjectLink_Retail_KAM.DescId = zc_ObjectLink_Retail_KAM()
                                AND COALESCE (vbPositionId_ContractTag,0) = 0
                                AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd()
                           UNION
                              --если заполнена должность по признаку договора
                              SELECT 2 AS Ord
                                   , Object_Position.ValueData       AS PositionName
                                   , Object_PersonalGroup.ValueData  AS PersonalGroupName
                                   , Object_Personal.ValueData       AS PersonalName
                                   , Object_Unit.ValueData           AS UnitName
                              FROM ObjectLink AS ObjectLink_Personal_Position
                                   LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                   INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                         ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                                        AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                                        AND ObjectLink_Unit_Branch.ChildObjectId = vbBranchId
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                                   LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                        ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                       AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
                              WHERE ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                AND ObjectLink_Personal_Position.ChildObjectId = vbPositionId_ContractTag
                                AND COALESCE (vbPositionId_ContractTag,0) <> 0
                                AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd()
                              )

              , tmpLevel3 AS (SELECT 3 AS Ord
                                   , tmpCommercRetail.PositionName_3       AS PositionName
                                   , String_AGG (DISTINCT Object_PersonalGroup.ValueData, '; ') ::TVarChar AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData) AS PersonalName
                                   , String_AGG (DISTINCT Object_Unit.ValueData, '; ')          ::TVarChar AS UnitName
                              FROM tmpCommercRetail

                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                         ON ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                        AND ObjectLink_Personal_Position.ChildObjectId = tmpCommercRetail.PositionId_3

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId AND Object_Personal.isErased = FALSE
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

                                   LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                        ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                       AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
                              WHERE Object_Personal.isErased = FALSE
                                AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd()
                              GROUP BY tmpCommercRetail.PositionName_3
                              )


           SELECT 1 ::Integer AS Ord
                , tmp.PositionName          ::TVarChar
                , tmp.PersonalGroupName     ::TVarChar
                , tmp.PersonalName          ::Text
                , tmp.UnitName              ::TVarChar
           FROM tmpLevel1 AS tmp
          UNION ALL
           SELECT 2 ::Integer AS Ord
                , tmp.PositionName          ::TVarChar
                , tmp.PersonalGroupName     ::TVarChar
                , tmp.PersonalName          ::Text
                , tmp.UnitName              ::TVarChar
           FROM tmpLevel2 AS tmp
          UNION
           SELECT 3 ::Integer AS Ord
                , COALESCE (tmp.PositionName, tmpCommercRetail.PositionName_3)           ::TVarChar AS PositionName
                , COALESCE (tmp.PersonalGroupName, tmpCommercRetail.PersonalGroupName_1) ::TVarChar AS PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName     ::TVarChar
           FROM tmpCommercRetail
               LEFT JOIN tmpLevel3 AS tmp ON 1 = 1
          order by 1
           ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.26         *
*/

-- тест
-- SELECT * FROM lpSelect_Object_CommercRetail_choice (inMemberId_order:= 9481147 , inRetailId := 310839,  inContractTagId:= 10087645, inSession := '9457');
