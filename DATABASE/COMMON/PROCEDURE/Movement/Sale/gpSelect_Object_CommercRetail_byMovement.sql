-- Function: gpSelect_Object_CommercRetail_byMovement()

DROP FUNCTION IF EXISTS gpSelect_Object_CommercRetail_byMovement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommercRetail_byMovement(
    IN inMovementId          Integer  , -- ключ Документа
    IN inSession             TVarChar   -- сессия пользователя
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
          vbUserId_order    Integer;
          vbPersonalId      Integer;
          vbRetailId        Integer;
          vbUnitId          Integer;
          vbBranchId        Integer;
          
          vbPositionId_1      Integer;
          vbPersonalGroupId_1 Integer;
          vbPositionId_ContractTag Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT ObjectLink_Juridical_Retail.ChildObjectId
          , ObjectLink_ContractTag_Position.ChildObjectId AS PositionId_ContractTag
    INTO vbRetailId, vbPositionId_ContractTag 
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id        
                                      AND MovementLinkObject_Partner.DescId = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                                   WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                              END
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

         LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                              ON ObjectLink_Contract_ContractTag.ObjectId = MovementLinkObject_Contract.ObjectId
                             AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()

         LEFT JOIN ObjectLink AS ObjectLink_ContractTag_Position
                              ON ObjectLink_ContractTag_Position.ObjectId = ObjectLink_Contract_ContractTag.ChildObjectId
                             AND ObjectLink_ContractTag_Position.DescId = zc_ObjectLink_ContractTag_Position()

     WHERE Movement.Id = inMovementId  ;

--vbRetailId := 992487;

     SELECT MovementLinkObject_Insert_order.ObjectId AS UserId_order
    INTO vbUserId_order
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                         ON MovementLinkMovement_Order.MovementId = Movement.Id
                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
          -- Автор Заявки
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert_order
                                       ON MovementLinkObject_Insert_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                      AND MovementLinkObject_Insert_order.DescId     = zc_MovementLinkObject_Insert()
     WHERE Movement.Id = inMovementId;


     --данные по пользователю для определения данных из справочника CommercLocal 
     SELECT tmpPersonal.PersonalId
          , tmpPersonal.UnitId
          , tmpPersonal.BranchId
          , tmpPersonal.PositionId
          , ObjectLink_Personal_PersonalGroup.ChildObjectId AS PersonalGroupId
    INTO vbPersonalId, vbUnitId, vbBranchId, vbPositionId_1, vbPersonalGroupId_1 
     FROM (SELECT lfSelect.MemberId
                , lfSelect.PersonalId 
                , lfSelect.UnitId
                , lfSelect.BranchId
                , lfSelect.PositionId
           FROM lfSelect_Object_Member_findPersonal (zfCalc_UserAdmin()) AS lfSelect
           ) AS tmpPersonal
           INNER JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ChildObjectId = tmpPersonal.MemberId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                AND ObjectLink_User_Member.ObjectId = vbUserId_order
           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                ON ObjectLink_Personal_PersonalGroup.ObjectId = tmpPersonal.PersonalId
                               AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
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
                                                        AND ObjectLink_CommercRetail_Retail.ChildObjectId = vbRetailId
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
                              WHERE ObjectLink_Retail_KAM_add.ObjectId = vbRetailId
                                AND ObjectLink_Retail_KAM_add.DescId = zc_ObjectLink_Retail_KAM_add()
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
                              WHERE ObjectLink_Retail_KAM.ObjectId = vbRetailId
                                AND ObjectLink_Retail_KAM.DescId = zc_ObjectLink_Retail_KAM()
                                AND COALESCE (vbPositionId_ContractTag,0) = 0
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
-- SELECT * FROM gpSelect_Object_CommercRetail_byMovement (inMovementId:= 40874, inSession := zfCalc_UserAdmin());

--select * from gpSelect_Object_CommercRetail_byMovement(inMovementId := 34932287 ,  inSession := '9457');

--