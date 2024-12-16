-- Function: gpReport_Protocol_ChangeStatus ()

DROP FUNCTION IF EXISTS gpReport_Protocol_ChangeStatus (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Protocol_ChangeStatus(
    IN inStartDate_pr     Tdatetime,
    IN inEndDate_pr       Tdatetime,
    IN inStartDate_mov    Tdatetime,
    IN inEndDate_mov      Tdatetime,
    IN inIsComplete_yes   Boolean  , -- Измения в статус Проведен
    IN inIsComplete_from  Boolean   , -- Измения со статуса Проведен
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId          Integer
             , OperDate_Movement   TDateTime
             , Invnumber_Movement  TVarChar
             , DescName_Movement   TVarChar
             , StatusCode_Movement Integer
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , StatusCode_1        Integer
             , StatusName_1        TVarChar
             , OperDate_Protocol_1 TDateTime
             , UserId_1            Integer
             , UserCode_1          Integer
             , UserName_1          TVarChar
             , MemberId_1          Integer
             , MemberName_1        TVarChar
             , PositionName_1      TVarChar
             , UnitName_1          TVarChar
             , StatusCode_2        Integer
             , StatusName_2        TVarChar
             , OperDate_Protocol_2 TDateTime
             , UserId_2            Integer
             , UserCode_2          Integer
             , UserName_2          TVarChar
             , MemberId_2          Integer
             , MemberName_2        TVarChar
             , PositionName_2      TVarChar
             , UnitName_2          TVarChar
             , Diff_minute         Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   RETURN QUERY 
     WITH
     tmpMovProtocol AS (SELECT MovementProtocol.UserId
                             , MovementProtocol.IsInsert
                             , MovementProtocol.OperDate_Protocol
                             , MovementProtocol.MovementId
                             , MovementProtocol.StatusId_Movement
                             , MovementProtocol.OperDate_Movement
                             , MovementProtocol.Invnumber_Movement
                             , MovementProtocol.DescId_Movement
                             , MovementProtocol.Id_protocol
                             , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"]/@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS StatusName
                               -- от первого изменения к последним
                             , ROW_NUMBER() OVER(PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.Id_protocol ASC) AS Ord
                        FROM (SELECT MovementProtocol.UserId              AS UserId
                                   , MovementProtocol.IsInsert            AS IsInsert
                                   , MovementProtocol.OperDate            AS OperDate_Protocol
                                   , MovementProtocol.MovementId          AS MovementId
                                   , MovementProtocol.ProtocolData
                                   , Movement.StatusId                    AS StatusId_Movement
                                   , Movement.OperDate                    AS OperDate_Movement
                                   , Movement.Invnumber                   AS Invnumber_Movement
                                   , Movement.DescId                      AS DescId_Movement
                                   , MovementProtocol.Id                  AS Id_protocol
                              FROM MovementProtocol
                                   INNER JOIN Movement ON Movement.Id = MovementProtocol.MovementId 
                                                      AND Movement.OperDate BETWEEN inStartDate_mov AND inEndDate_mov
                                                      AND Movement.DescId NOT IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
                                                      AND Movement.DescId NOT IN (zc_Movement_RouteMember())
                                                      
                              WHERE MovementProtocol.OperDate >= inStartDate_pr AND MovementProtocol.OperDate < inEndDate_pr + INTERVAL '1 DAY'
                                AND MovementProtocol.UserId NOT IN (zc_Enum_Process_Auto_PrimeCost(), zc_Enum_Process_Auto_ReComplete()
                                                                  , zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Defroster()
                                                                  , zc_Enum_Process_Auto_PartionDate(), zc_Enum_Process_Auto_PartionClose()
                                                                  --, zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_ReturnIn(), zc_Enum_Process_Auto_Medoc()
                                                                   )
 --and MovementProtocol.MovementId = 29945271  --29865871 -- 
                              ) AS MovementProtocol
                        )	
  , tmpMovProtocol_all AS (SELECT tmpMovProtocol.UserId
                                 , tmpMovProtocol.IsInsert
                                 , tmpMovProtocol.OperDate_Protocol
                                 , tmpMovProtocol.StatusName

                                   -- от первого изменения к последним
                                 , ROW_NUMBER() OVER(PARTITION BY tmpMovProtocol.MovementId ORDER BY tmpMovProtocol.Id_protocol ASC,  CASE WHEN tmpMovProtocol.StatusName ILIKE 'Проведен' THEN 1 ELSE 0 END ASC)  AS Ord_asc
                                 , ROW_NUMBER() OVER(PARTITION BY tmpMovProtocol.MovementId ORDER BY tmpMovProtocol.Id_protocol DESC, CASE WHEN tmpMovProtocol.StatusName ILIKE 'Проведен' THEN 1 ELSE 0 END DESC) AS Ord_desc

                                 , tmpMovProtocol.MovementId
                                 , tmpMovProtocol.StatusId_Movement
                                 , tmpMovProtocol.OperDate_Movement
                                 , tmpMovProtocol.Invnumber_Movement
                                 , tmpMovProtocol.DescId_Movement 
                                 , tmpMovProtocol.Id_protocol

                            FROM (SELECT MovementProtocol.UserId
                                       , MovementProtocol.IsInsert
                                       , MovementProtocol.OperDate  AS OperDate_Protocol
                                       , MovementProtocol.Id        AS Id_protocol
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"]                       /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS StatusName
      
                                       , tmpMovProtocol.MovementId
                                       , tmpMovProtocol.StatusId_Movement
                                       , tmpMovProtocol.OperDate_Movement
                                       , tmpMovProtocol.Invnumber_Movement
                                       , tmpMovProtocol.DescId_Movement
      
                                  FROM (SELECT DISTINCT tmpMovProtocol.MovementId
                                                      , tmpMovProtocol.StatusId_Movement
                                                      , tmpMovProtocol.OperDate_Movement
                                                      , tmpMovProtocol.Invnumber_Movement
                                                      , tmpMovProtocol.DescId_Movement
                                        FROM tmpMovProtocol
                                       ) AS tmpMovProtocol
                                       JOIN MovementProtocol ON MovementProtocol.MovementId = tmpMovProtocol.MovementId
                                                            AND MovementProtocol.UserId NOT IN (zc_Enum_Process_Auto_PrimeCost(), zc_Enum_Process_Auto_ReComplete()
                                                                                              , zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Defroster()
                                                                                              , zc_Enum_Process_Auto_PartionDate(), zc_Enum_Process_Auto_PartionClose()
                                                                                              --, zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_ReturnIn(), zc_Enum_Process_Auto_Medoc()
                                                                                               )
                                 ) AS tmpMovProtocol
                           )

     -- только статус Проведен
   , tmpMovProtocol_complete AS (SELECT tmpMovProtocol.MovementId
                                      , tmpMovProtocol.Ord_asc
                                      , tmpMovProtocol.Ord_desc
                                        -- от последнего раза в статусе Проведен к предыдущим
                                      , ROW_NUMBER() OVER (PARTITION BY tmpMovProtocol.MovementId ORDER BY tmpMovProtocol.Id_protocol DESC) AS Ord_complete_desc
                                      , ROW_NUMBER() OVER (PARTITION BY tmpMovProtocol.MovementId ORDER BY tmpMovProtocol.Id_protocol ASC)  AS Ord_complete_asc
                                 FROM tmpMovProtocol_all AS tmpMovProtocol
                                 WHERE tmpMovProtocol.StatusName ILIKE 'Проведен'
                                )

   , tmpData AS (-- c Проведенного на любой
                 SELECT tmp2.MovementId
                      , tmp2.StatusId_Movement
                      , tmp2.OperDate_Movement
                      , tmp2.Invnumber_Movement
                      , tmp2.DescId_Movement

                      , tmp1.StatusName        AS StatusName_1         --статус проведен
                      , tmp1.UserId            AS UserId_1             --пользователь, установивший статус  проведен 
                      , tmp1.OperDate_Protocol AS OperDate_Protocol_1  --дата/воремя - статус проведен

                      , tmp2.StatusName        AS StatusName_2         --статус проведен
                      , tmp2.UserId            AS UserId_2             --пользователь, статус не проведен/удален
                      , tmp2.OperDate_Protocol AS OperDate_Protocol_2  --дата/воремя - статус не проведен/удален

                 FROM tmpMovProtocol_all AS tmp1
                      -- нашли док в этом списке
                      LEFT JOIN tmpMovProtocol_complete ON tmpMovProtocol_complete.MovementId = tmp1.MovementId
                                                       AND tmpMovProtocol_complete.Ord_desc   = tmp1.Ord_desc
                      -- предыдущий раз, когда был проведен
                      LEFT JOIN tmpMovProtocol_complete AS tmpMovProtocol_complete_old
                                                        ON tmpMovProtocol_complete_old.MovementId       = tmpMovProtocol_complete.MovementId
                                                       AND tmpMovProtocol_complete_old.Ord_complete_desc = tmpMovProtocol_complete.Ord_complete_desc - 1
                      -- следующая запись для tmpMovProtocol_complete_old
                      LEFT JOIN tmpMovProtocol_all AS tmp2
                                                   ON tmp2.MovementId = tmp1.MovementId
                                                  AND tmp2.Ord_desc    = tmpMovProtocol_complete_old.Ord_desc + 1

                 WHERE tmp1.StatusName ILIKE 'Проведен'
                      -- c Проведенного на любой
                      AND inIsComplete_from = TRUE
                      -- здесь период
                      AND tmp1.OperDate_Protocol >= inStartDate_pr AND tmp1.OperDate_Protocol < inEndDate_pr + INTERVAL '1 DAY'
                      --
                      AND tmp1.StatusName <> tmp2.StatusName
                UNION
                 -- c Любого на Проведенный
                 SELECT tmp2.MovementId
                      , tmp2.StatusId_Movement
                      , tmp2.OperDate_Movement
                      , tmp2.Invnumber_Movement
                      , tmp2.DescId_Movement

                      , COALESCE (tmp1.StatusName, tmp1_ord_1.StatusName)               AS StatusName_1         --статус не проведен или...
                      , COALESCE (tmp1.UserId, tmp1_ord_1.UserId)                       AS UserId_1             --пользователь, установивший статус не проведен или...
                      , COALESCE (tmp1.OperDate_Protocol, tmp1_ord_1.OperDate_Protocol) AS OperDate_Protocol_1  --дата/воремя - статус не проведен или...

                      , tmp2.StatusName        AS StatusName_2         --статус проведен
                      , tmp2.UserId            AS UserId_2             --пользователь, статус проведен
                      , tmp2.OperDate_Protocol AS OperDate_Protocol_2  --дата/воремя - статус проведен            

                 FROM tmpMovProtocol_all AS tmp2
                      -- нашли док в этом списке
                      LEFT JOIN tmpMovProtocol_complete ON tmpMovProtocol_complete.MovementId = tmp2.MovementId
                                                       AND tmpMovProtocol_complete.Ord_asc    = tmp2.Ord_asc
                      -- предыдущий раз, когда был проведен
                      LEFT JOIN tmpMovProtocol_complete AS tmpMovProtocol_complete_old
                                                        ON tmpMovProtocol_complete_old.MovementId       = tmpMovProtocol_complete.MovementId
                                                       AND tmpMovProtocol_complete_old.Ord_complete_asc = tmpMovProtocol_complete.Ord_complete_asc - 1
                      -- следующая запись для tmpMovProtocol_complete_old
                      LEFT JOIN tmpMovProtocol_all AS tmp1
                                                   ON tmp1.MovementId = tmp2.MovementId
                                                  AND tmp1.Ord_asc    = tmpMovProtocol_complete_old.Ord_asc + 1
                      -- первый протокол
                      LEFT JOIN tmpMovProtocol_all AS tmp1_ord_1
                                                   ON tmp1_ord_1.MovementId = tmp2.MovementId
                                                  AND tmp1_ord_1.Ord_asc    = 1
                                                  -- если в первый раз стал Проведен
                                                  AND tmpMovProtocol_complete.Ord_complete_asc = 1
                 WHERE tmp2.StatusName ILIKE 'Проведен' -- AND tmp1.StatusName NOT ILIKE 'Проведен'
                  -- c Любого на Проведенный
                  AND inIsComplete_yes = TRUE
                  -- здесь период
                  AND tmp2.OperDate_Protocol >= inStartDate_pr AND tmp2.OperDate_Protocol < inEndDate_pr + INTERVAL '1 DAY'
                  --
                  AND COALESCE (tmp1.StatusName, tmp1_ord_1.StatusName) <> tmp2.StatusName 
               )          
                      
   , tmpPersonal AS (SELECT View_Personal.MemberId
                          , MAX (View_Personal.PersonalId) AS PersonalId
                          , MAX (View_Personal.UnitId)     AS UnitId
                          , MAX (View_Personal.PositionId) AS PositionId
                     FROM Object_Personal_View AS View_Personal
                     GROUP BY View_Personal.MemberId
                     )
                      
                      
     SELECT tmpData.MovementId                    AS MovementId
          , tmpData.OperDate_Movement             AS OperDate_Movement
          , tmpData.Invnumber_Movement            AS Invnumber_Movement
          , MovementDesc.ItemName                 AS DescName_Movement
          , Object_Status.ObjectCode              AS StatusCode_Movement
          , Object_From.Id                        AS FromId
          , Object_From.ValueData                 AS FromName
          , Object_To.Id                          AS ToId
          , Object_To.ValueData                   AS ToName

          , CASE WHEN tmpData.StatusName_1 = 'Проведен'      THEN 2 
                 WHEN tmpData.StatusName_1 = '"Не проведен"' THEN 1
                 WHEN tmpData.StatusName_1 = 'Удален'        THEN 3
            END      ::Integer  AS StatusCode_1
          , tmpData.StatusName_1      ::TVarChar  AS StatusName_1
          , tmpData.OperDate_Protocol_1           AS OperDate_Protocol_1
          , Object_User1.Id                       AS UserId_1
          , Object_User1.ObjectCode               AS UserCode_1
          , Object_User1.ValueData    ::TVarChar  AS UserName_1
          , Object_Member1.Id                     AS MemberId_1 
          , Object_Member1.ValueData  ::TVarChar  AS MemberName_1
          , Object_Position1.ValueData ::TVarChar AS PositionName_1 
          , Object_Unit1.ValueData     ::TVarChar AS UnitName_1

          , CASE WHEN tmpData.StatusName_2 = 'Проведен'      THEN 2 
                 WHEN tmpData.StatusName_2 = '"Не проведен"' THEN 1
                 WHEN tmpData.StatusName_2 = 'Удален'        THEN 3
            END      ::Integer  AS StatusCode_2
          , tmpData.StatusName_2      ::TVarChar  AS StatusName_2
          , tmpData.OperDate_Protocol_2           AS OperDate_Protocol_2
          , Object_User2.Id                       AS UserId_2
          , Object_User2.ObjectCode               AS UserCode_2
          , Object_User2.ValueData    ::TVarChar  AS UserName_2
          , Object_Member2.Id                     AS MemberId_2 
          , Object_Member2.ValueData  ::TVarChar  AS MemberName_2
          , Object_Position2.ValueData ::TVarChar AS PositionName_2 
          , Object_Unit2.ValueData     ::TVarChar AS UnitName_2
          
          , (EXTRACT (MINUTE FROM tmpData.OperDate_Protocol_2 - tmpData.OperDate_Protocol_1)
           + EXTRACT (HOUR  FROM tmpData.OperDate_Protocol_2 - tmpData.OperDate_Protocol_1)*60
           + EXTRACT (DAY  FROM tmpData.OperDate_Protocol_2 - tmpData.OperDate_Protocol_1)*24*60
            ) :: Integer AS Diff_minute
    FROM tmpData
        LEFT JOIN Object AS Object_User1 ON Object_User1.Id = tmpData.UserId_1
        LEFT JOIN Object AS Object_User2 ON Object_User2.Id = tmpData.UserId_2
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId_Movement 
        LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.DescId_Movement

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = tmpData.MovementId
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = tmpData.MovementId
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_User_Member_1
                             ON ObjectLink_User_Member_1.ObjectId = tmpData.UserId_1
                            AND ObjectLink_User_Member_1.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = ObjectLink_User_Member_1.ChildObjectId
        LEFT JOIN tmpPersonal AS tmpPersonal_1 ON tmpPersonal_1.MemberId = Object_Member1.Id
        LEFT JOIN Object AS Object_Position1 ON Object_Position1.Id = tmpPersonal_1.PositionId
        LEFT JOIN Object AS Object_Unit1 ON Object_Unit1.Id = tmpPersonal_1.UnitId
        
        LEFT JOIN ObjectLink AS ObjectLink_User_Member_2
                             ON ObjectLink_User_Member_2.ObjectId = tmpData.UserId_2
                            AND ObjectLink_User_Member_2.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_User_Member_2.ChildObjectId
        LEFT JOIN tmpPersonal AS tmpPersonal_2 ON tmpPersonal_2.MemberId = Object_Member2.Id 
        LEFT JOIN Object AS Object_Position2 ON Object_Position2.Id = tmpPersonal_2.PositionId
        LEFT JOIN Object AS Object_Unit2 ON Object_Unit2.Id = tmpPersonal_2.UnitId
    ;
     


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.09.15         *
*/

-- тест
-- SELECT * FROM gpReport_Protocol_ChangeStatus ('01.09.2024','01.09.2024', '01.09.2024','01.09.2024',true, true, '5')
