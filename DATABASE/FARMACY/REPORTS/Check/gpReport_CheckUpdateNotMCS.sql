-- Function: gpReport_CheckUpdateNotMCS()

DROP FUNCTION IF EXISTS gpReport_CheckUpdateNotMCS (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckUpdateNotMCS(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , isNotMCS Boolean, OperDateUpdate TDateTime
             , UserCode Integer, UserName TVarChar
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  -- ���������
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , Movement.OperDate
                       FROM Movement
                       WHERE Movement.OperDate >= inStartDate
                         AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                         AND Movement.DescId = zc_Movement_Check()
                         AND Movement.StatusId = zc_Enum_Status_Complete())
     , tmpProtocolAll AS (SELECT Movement.*
                               , MovementProtocol.UserId
                               , MovementProtocol.OperDate                                                         AS OperDateUpdate
                               , MovementProtocol.ProtocolData ILIKE '%�� ��� ���" FieldValue = "True%'            AS isNotMCS
                               , ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.Id) AS Ord
                          FROM tmpMovement AS Movement

                               INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.Id
                          )
                       
  SELECT Movement.Id
       , Movement.InvNumber
       , Movement.OperDate
       , Object_Unit.ObjectCode                                                           AS UnitCode
       , Object_Unit.ValueData                                                            AS UnitName
       , Movement.isNotMCS 
       , Movement.OperDateUpdate 
       , Object_User.ObjectCode                                                           AS UserCode
       , Object_User.ValueData                                                            AS UserName

  FROM tmpProtocolAll AS Movement

       INNER JOIN tmpProtocolAll AS MovementOld
                                 ON MovementOld.Id = Movement.Id
                                AND MovementOld.isNotMCS <> Movement.isNotMCS
                                AND MovementOld.Ord = Movement.Ord - 1
                                
       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                                
       LEFT JOIN Object AS Object_User ON Object_User.Id = Movement.UserId
       
  ORDER BY Object_Unit.ValueData, Movement.OperDate
  ;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_CheckUpdateNotMCS (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.04.22                                                       *
*/

-- ����
--

select * from gpReport_CheckUpdateNotMCS(inStartDate := ('01.04.2022')::TDateTime , inEndDate := ('20.04.2022')::TDateTime ,  inSession := '3');