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
          
          vbPositionId_1      Integer;
          vbPersonalGroupId_1 Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT ObjectLink_Juridical_Retail.ChildObjectId
    INTO vbRetailId 
     FROM MovementLinkObject AS MovementLinkObject_To
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE MovementLinkObject_To.MovementId = inMovementId        
       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();

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
          , tmpPersonal.PositionId
          , ObjectLink_Personal_PersonalGroup.ChildObjectId AS PersonalGroupId
    INTO vbPersonalId, vbUnitId, vbPositionId_1, vbPersonalGroupId_1 
     FROM (SELECT lfSelect.MemberId
                , lfSelect.PersonalId 
                , lfSelect.UnitId
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

              , tmpLevel1 AS (SELECT 1 AS Ord 
                                   , tmpCommercRetail.PositionName_1       AS PositionName
                                   , tmpCommercRetail.PersonalGroupName_1  AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData) AS PersonalName
                                   , Object_Unit.ValueData                 AS UnitName
                              FROM tmpCommercRetail
                               /*    INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                         ON ObjectLink_Personal_PersonalGroup.ChildObjectId = tmpCommercRetail.PersonalGroupId_1
                                                        AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                                        AND ObjectLink_Personal_PersonalGroup.ObjectId = tmpCommercRetail.PersonalGroupId_1

                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                         ON ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                       AND ObjectLink_Personal_Position.ChildObjectId = tmpCommercRetail.PositionId_1  --149847
                                                       AND ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_PersonalGroup.ObjectId 
*/
                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                         ON ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                        AND ObjectLink_Personal_Position.ChildObjectId = tmpCommercRetail.PositionId_1

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                  -- LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
 
                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId AND Object_Personal.isErased = FALSE
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
                              WHERE Object_Personal.isErased = FALSE
                                AND (COALESCE (ObjectLink_Personal_PersonalGroup.ObjectId,0) = COALESCE (tmpCommercRetail.PersonalGroupId_1,0) OR COALESCE (tmpCommercRetail.PersonalGroupId_1,0) = 0)
                              GROUP BY tmpCommercRetail.PositionName_1
                                     , tmpCommercRetail.PersonalGroupName_1
                                     , Object_Unit.ValueData
                              )

              , tmpLevel2 AS (SELECT 2 AS Ord 
                                   , tmpCommercRetail.PositionName_2       AS PositionName
                                   , String_AGG (DISTINCT Object_PersonalGroup.ValueData, '; ') ::TVarChar AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData) AS PersonalName
                                   , String_AGG (DISTINCT Object_Unit.ValueData, '; ')          ::TVarChar AS UnitName
                              FROM tmpCommercRetail

                                   INNER JOIN ObjectLink AS ObjectLink_Personal_Position
                                                         ON ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                        AND ObjectLink_Personal_Position.ChildObjectId = tmpCommercRetail.PositionId_2

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
                              GROUP BY tmpCommercRetail.PositionName_2
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
                              WHERE Object_Personal.isErased = FALSE
                              GROUP BY tmpCommercRetail.PositionName_3
                              )


           SELECT 1 ::Integer AS Ord 
                , COALESCE (tmp.PositionName, tmpCommercRetail.PositionName_1)           ::TVarChar AS PositionName
                , COALESCE (tmp.PersonalGroupName, tmpCommercRetail.PersonalGroupName_1) ::TVarChar AS PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName     ::TVarChar      
           FROM tmpCommercRetail
               LEFT JOIN tmpLevel1 AS tmp ON 1 = 1  
          UNION ALL
           SELECT 2 ::Integer AS Ord 
                , COALESCE (tmp.PositionName, tmpCommercRetail.PositionName_2) ::TVarChar AS PositionName
                , tmp.PersonalGroupName                                        ::TVarChar AS PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName     ::TVarChar      
           FROM tmpCommercRetail
               LEFT JOIN tmpLevel2 AS tmp ON 1 = 1 
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

--select * from gpSelect_Object_CommercRetail_byMovement(inMovementId := 34499291 ,  inSession := '9457');

--select * from gpSelect_Object_CommercRetail(inIsErased := 'False' ,  inSession := '9457');