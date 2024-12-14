-- Function: gpReport_Protocol_ChangeStatus ()

DROP FUNCTION IF EXISTS gpReport_Protocol_ChangeStatus (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Protocol_ChangeStatus(
    IN inStartDate_pr   Tdatetime,
    IN inEndDate_pr     Tdatetime,
    IN inStartDate_mov  Tdatetime,
    IN inEndDate_mov    Tdatetime,
    IN inisComplete     Boolean   , -- смена статуса на Проведен
    IN inisNotComplete  Boolean   , -- смена статуса на НЕ Проведен    
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId          Integer
             , OperDate_Movement   TDateTime
             , Invnumber_Movement  TVarChar
             , DescName_Movement   TVarChar
             , StatusCode_Movement Integer
             , StatusName_1        TVarChar
             , OperDate_Protocol_1 TDateTime
             , UserId_1            Integer
             , UserCode_1          Integer
             , UserName_1          TVarChar
             , MemberId_1          Integer
             , MemberName_1        TVarChar
             , StatusName_2        TVarChar
             , OperDate_Protocol_2 TDateTime
             , UserId_2            Integer
             , UserCode_2          Integer
             , UserName_2          TVarChar
             , MemberId_2          Integer
             , MemberName_2        TVarChar
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
                             , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Статус"]                       /@FieldValue', MovementProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS StatusName
                             , ROW_NUMBER() OVER(PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate_Protocol) AS Ord
                        FROM (SELECT MovementProtocol.UserId              AS UserId
                                   , MovementProtocol.IsInsert            AS IsInsert
                                   , MovementProtocol.OperDate            AS OperDate_Protocol
                                   , MovementProtocol.MovementId          AS MovementId
                                   , MovementProtocol.ProtocolData
                                   , Movement.StatusId                    AS StatusId_Movement
                                   , Movement.OperDate                    AS OperDate_Movement
                                   , Movement.Invnumber                   AS Invnumber_Movement
                                   , Movement.DescId                      AS DescId_Movement
                              FROM MovementProtocol
                                   INNER JOIN Movement ON Movement.Id = MovementProtocol.MovementId 
                                                      AND Movement.OperDate BETWEEN inStartDate_mov AND inEndDate_mov
                              WHERE MovementProtocol.OperDate BETWEEN inStartDate_pr AND inEndDate_pr
                               AND MovementProtocol.UserId <> zc_Enum_Process_Auto_PrimeCost()
                              ) AS MovementProtocol
                        )

--"Проведен"- ""Не проведен""--
   , tmpData AS (SELECT tmp1.MovementId
                      , tmp1.StatusId_Movement
                      , tmp1.OperDate_Movement
                      , tmp1.Invnumber_Movement
                      , tmp1.DescId_Movement

                      , tmp1.StatusName        AS StatusName_1         --статус проведен
                      , tmp1.UserId            AS UserId_1             --пользователь, утсановивший статус проведен
                      , tmp1.OperDate_Protocol AS OperDate_Protocol_1  --дата/воремя - статус проведен

                      , tmp2.StatusName        AS StatusName_2         --статус не проведен
                      , tmp2.UserId            AS UserId_2             --пользователь, статус не проведен
                      , tmp2.OperDate_Protocol AS OperDate_Protocol_2  --дата/воремя - статус не проведен
                 FROM tmpMovProtocol AS tmp1
                      LEFT JOIN tmpMovProtocol AS tmp2
                                               ON tmp2.MovementId = tmp1.MovementId
                                              AND tmp2.Ord - 1 = tmp1.Ord
                 WHERE tmp1.StatusName = 'Проведен' AND tmp2.StatusName = '"Не проведен"'
                      AND inisNotComplete = TRUE --c проведенного на непроведенный 
                      UNION
                 SELECT tmp1.MovementId
                      , tmp1.StatusId_Movement
                      , tmp1.OperDate_Movement
                      , tmp1.Invnumber_Movement
                      , tmp1.DescId_Movement

                      , tmp1.StatusName        AS StatusName_1         --статус не проведен
                      , tmp1.UserId            AS UserId_1             --пользователь, установивший статус не проведен
                      , tmp1.OperDate_Protocol AS OperDate_Protocol_1  --дата/воремя - статус не проведен

                      , tmp2.StatusName        AS StatusName_2         --статус проведен
                      , tmp2.UserId            AS UserId_2             --пользователь, статус проведен
                      , tmp2.OperDate_Protocol AS OperDate_Protocol_2  --дата/воремя - статус проведен            
                 FROM tmpMovProtocol AS tmp1
                      LEFT JOIN tmpMovProtocol AS tmp2
                                               ON tmp2.MovementId = tmp1.MovementId
                                              AND tmp2.Ord - 1 = tmp1.Ord
                 WHERE tmp1.StatusName = '"Не проведен"' AND tmp2.StatusName = 'Проведен'
                 AND inisComplete = TRUE --c непроведенного на проведенный               
                )          
                      
                        
                      
     SELECT tmpData.MovementId                    AS MovementId
          , tmpData.OperDate_Movement             AS OperDate_Movement
          , tmpData.Invnumber_Movement            AS Invnumber_Movement
          , MovementDesc.ItemName                 AS DescName_Movement
          , Object_Status.ObjectCode              AS StatusCode_Movement
          , tmpData.StatusName_1      ::TVarChar  AS StatusName_1
          , tmpData.OperDate_Protocol_1           AS OperDate_Protocol_1
          , Object_User1.Id                       AS UserId_1
          , Object_User1.ObjectCode               AS UserCode_1
          , Object_User1.ValueData    ::TVarChar  AS UserName_1
          , Object_Member1.Id                     AS MemberId_1 
          , Object_Member1.ValueData  ::TVarChar  AS MemberName_1 
          , tmpData.StatusName_2      ::TVarChar  AS StatusName_2
          , tmpData.OperDate_Protocol_2           AS OperDate_Protocol_2
          , Object_User2.Id                       AS UserId_2
          , Object_User2.ObjectCode               AS UserCode_2
          , Object_User2.ValueData    ::TVarChar  AS UserName_2
          , Object_Member2.Id                     AS MemberId_2 
          , Object_Member2.ValueData  ::TVarChar  AS MemberName_2 
    FROM tmpData
        LEFT JOIN Object AS Object_User1 ON Object_User1.Id = tmpData.UserId_1
        LEFT JOIN Object AS Object_User2 ON Object_User2.Id = tmpData.UserId_2
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId_Movement 
        LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.DescId_Movement
        
        LEFT JOIN ObjectLink AS ObjectLink_User_Member_1
                             ON ObjectLink_User_Member_1.ObjectId = tmpData.UserId_1
                            AND ObjectLink_User_Member_1.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = ObjectLink_User_Member_1.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member_2
                             ON ObjectLink_User_Member_2.ObjectId = tmpData.UserId_2
                            AND ObjectLink_User_Member_2.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_User_Member_2.ChildObjectId
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
 --SELECT * FROM gpReport_Protocol_ChangeStatus ('01.09.2024','01.09.2024', '01.08.2024','01.09.2024',true, true, '5')
