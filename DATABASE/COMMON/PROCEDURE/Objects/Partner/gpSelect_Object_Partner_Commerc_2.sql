-- Function: gpSelect_Object_Partner_Commerc_2()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Commerc_2 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_Commerc_2(
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
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Partner());

       RETURN QUERY
       WITH 
       tmpRetail AS (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                          , ObjectLink_Retail_KAM.ChildObjectId       AS KAMId
                          , ObjectLink_Retail_KAM_add.ChildObjectId   AS KAM_addId
                          , ObjectLink_Retail_NOP_NM.ChildObjectId    AS NOP_NMId
                     FROM ObjectLink AS ObjectLink_Partner_Juridical
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
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
                      WHERE ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                        AND ObjectLink_Partner_Juridical.ObjectId = inId --5817065 --inPartnerId
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

                --получаем сотрудника из справочника торговой сети Помошник КАМ
              , tmpLevel1 AS (SELECT 1 AS Ord 
                                   , Object_Position.ValueData       AS PositionName
                                   , Object_PersonalGroup.ValueData  AS PersonalGroupName
                                   , Object_Personal.ValueData       AS PersonalName
                                   , Object_Unit.ValueData           AS UnitName
                              FROM tmpRetail
                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = tmpRetail.KAM_addId

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
                              )

                --получаем сотрудника из справочника торговой сети сотрудник КАМ
              , tmpLevel2 AS (SELECT 2 AS Ord 
                                   , Object_Position.ValueData       AS PositionName
                                   , Object_PersonalGroup.ValueData  AS PersonalGroupName
                                   , Object_Personal.ValueData       AS PersonalName
                                   , Object_Unit.ValueData           AS UnitName
                              FROM tmpRetail
                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = tmpRetail.KAMId

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
                              )

              , tmpLevel3 AS (SELECT 3 AS Ord 
                                   , tmpCommercRetail.PositionName_3       AS PositionName
                                   , String_AGG (DISTINCT Object_PersonalGroup.ValueData, '; ') ::TVarChar AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData) AS PersonalName
                                   , String_AGG (DISTINCT Object_Unit.ValueData, '; ')          ::TVarChar AS UnitName
                              FROM tmpCommercRetail

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
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
                              WHERE Object_Personal.isErased = FALSE
                              GROUP BY tmpCommercRetail.PositionName_3
                              )

       ----
       SELECT tmp.Ord           ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel1 AS tmp
      UNION
       SELECT tmp.Ord           ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel2 AS tmp
      UNION
       SELECT tmp.Ord           ::Integer        AS Ord
            , tmp.PersonalName  ::TVarChar       AS PersonalName
            , tmp.PositionName  ::TVarChar       AS PositionName
            , tmp.UnitName      ::TVarChar       AS UnitName
       FROM tmpLevel3 AS tmp
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
-- select * from gpSelect_Object_Partner_Commerc_2 (inId := 5817065 , inSession := '5');