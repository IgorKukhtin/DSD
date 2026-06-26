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
          vbRetailId          Integer;
          
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
         tmpCommercLocal AS (SELECT Object_CommercLocal.Id
                                  , Object_Unit.Id                      ::Integer  AS UnitId
                                  , Object_Unit.ValueData               ::TVarChar AS UnitName
         
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
                             )
              , tmpPersonal_byUnit AS (SELECT Object_Personal.Id                              AS PersonalId
                                            , Object_Personal.ValueData                       AS PersonalName
                                            , ObjectLink_Personal_Position.ChildObjectId      AS PositionId
                                            , ObjectLink_Personal_PersonalGroup.ChildObjectId AS PersonalGroupId
                                            , ObjectLink_Personal_Unit.ChildObjectId          AS UnitId
                                       FROM Object AS Object_Personal
                                            INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                  ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                                 AND ObjectLink_Personal_Unit.ChildObjectId = vbUnitId
                                            LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                                 ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                                                                AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                                                 
                                       WHERE Object_Personal.DescId = zc_Object_Personal()
                                         AND Object_Personal.isErased = FALSE 
                                       )

              , tmpLevel1 AS (SELECT 1 AS Ord 
                                   , Object_Position_1.ValueData       AS PositionName
                                   , Object_PersonalGroup_1.ValueData  AS PersonalGroupName
                                   , Object_Personal.ValueData         AS PersonalName
                                   , Object_Unit.ValueData             AS UnitName
                              FROM object AS Object_Personal
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId
                                   LEFT JOIN Object AS Object_Position_1 ON Object_Position_1.Id = vbPositionId_1
                                   LEFT JOIN Object AS Object_PersonalGroup_1 ON Object_PersonalGroup_1.Id = vbPersonalGroupId_1
                              WHERE Object_Personal.Id = vbPersonalId
                              )

              , tmpLevel2 AS (SELECT 2 AS Ord 
                                   , tmpCommercLocal.PositionName_2       AS PositionName
                                   , tmpCommercLocal.PersonalGroupName_2  AS PersonalGroupName
                                   , String_AGG (Object_Personal.ValueData, CHR (10) || CHR (13) order by Object_Personal.ValueData)   AS PersonalName
                                   , Object_Unit.ValueData                AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ChildObjectId = tmpCommercLocal.PersonalGroupId_2
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                        ON ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                                       AND ObjectLink_Personal_Position.ChildObjectId = tmpCommercLocal.PositionId_2  --149847
                                                       AND ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_PersonalGroup.ObjectId 

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                        ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Position.ObjectId
                                                       AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
 
                                   LEFT JOIN object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Position.ObjectId AND Object_Personal.isErased = FALSE
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
WHERE Object_Personal.isErased = FALSE
                              GROUP BY tmpCommercLocal.PositionName_2
                                     , tmpCommercLocal.PersonalGroupName_2
                                     , Object_Unit.ValueData
                              )

              , tmpLevel3 AS (SELECT 3 AS Ord 
                                   , tmpCommercLocal.PositionName_3        AS PositionName
                                   , Object_PersonalGroup.ValueData      AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpCommercLocal.UnitName            AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_3
                                                               -- AND tmpPersonal.PersonalGroupId = tmpCommercLocal.PersonalGroupId_3

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = tmpPersonal.PersonalId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                              GROUP BY tmpCommercLocal.PositionName_3
                                     , Object_PersonalGroup.ValueData
                                     , tmpCommercLocal.UnitName
                              )
               , tmpLevel4 AS (SELECT 4 AS Ord 
                                   , tmpCommercLocal.PositionName_4        AS PositionName
                                   , Object_PersonalGroup.ValueData      AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpCommercLocal.UnitName            AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_4

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = tmpPersonal.PersonalId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                              GROUP BY tmpCommercLocal.PositionName_4
                                     , Object_PersonalGroup.ValueData
                                     , tmpCommercLocal.UnitName
                              )

              , tmpLevel5 AS (SELECT 5 AS Ord 
                                   , tmpCommercLocal.PositionName_5        AS PositionName
                                   , Object_PersonalGroup.ValueData      AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpCommercLocal.UnitName            AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_5

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = tmpPersonal.PersonalId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                              GROUP BY tmpCommercLocal.PositionName_5
                                     , Object_PersonalGroup.ValueData
                                     , tmpCommercLocal.UnitName
                              )

              , tmpLevel6 AS (SELECT 6 AS Ord 
                                   , tmpCommercLocal.PositionName_6        AS PositionName
                                   , Object_PersonalGroup.ValueData      AS PersonalGroupName
                                   , String_AGG (tmpPersonal.PersonalName, CHR (10) || CHR (13) order by tmpPersonal.PersonalName) ::Text  AS PersonalName
                                   , tmpCommercLocal.UnitName            AS UnitName
                              FROM tmpCommercLocal
                                   LEFT JOIN tmpPersonal_byUnit AS tmpPersonal
                                                                ON tmpPersonal.PositionId = tmpCommercLocal.PositionId_6

                                   LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                        ON ObjectLink_Personal_PersonalGroup.ObjectId = tmpPersonal.PersonalId
                                                       AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                                   LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                              GROUP BY tmpCommercLocal.PositionName_6
                                     , Object_PersonalGroup.ValueData
                                     , tmpCommercLocal.UnitName
                              )              


           SELECT tmp.Ord 
                , tmp.PositionName
                , tmp.PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName           
           FROM tmpLevel1 AS tmp
          UNION ALL
           SELECT tmp.Ord 
                , tmp.PositionName
                , tmp.PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName           
           FROM tmpLevel2 AS tmp
          UNION 
           SELECT tmp.Ord 
                , tmp.PositionName
                , tmp.PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName           
           FROM tmpLevel3 AS tmp
          UNION 
           SELECT tmp.Ord 
                , tmp.PositionName
                , tmp.PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName           
           FROM tmpLevel4 AS tmp
          UNION 
           SELECT tmp.Ord 
                , tmp.PositionName
                , tmp.PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName           
           FROM tmpLevel5 AS tmp
          UNION 
           SELECT tmp.Ord 
                , tmp.PositionName
                , tmp.PersonalGroupName
                , tmp.PersonalName ::Text
                , tmp.UnitName           
           FROM tmpLevel6 AS tmp
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
