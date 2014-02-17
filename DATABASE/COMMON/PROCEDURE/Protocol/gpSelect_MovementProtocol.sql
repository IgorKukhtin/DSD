-- Function: gpSelect_Protocol() 

DROP FUNCTION IF EXISTS gpSelect_MovementProtocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementProtocol(
    IN inStartDate       TDateTime , -- 
    IN inEndDate         TDateTime , --
    IN inUserId          Integer,    -- ������������  
    IN inMovementDescId  Integer,    -- ��� �������
    IN inMovementId      Integer,    -- ������
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime, ProtocolData TVarChar, UserName TVarChar, 
               InvNumber TVarChar, MovementOperDate TDateTime, MovementDescName TVarChar)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT 
     ObjectProtocol.OperDate,
     ObjectProtocol.ProtocolData::TVarChar,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName
  FROM ObjectProtocol 
  JOIN Object AS Object_User ON Object_User.Id = ObjectProtocol.UserId
  JOIN Movement ON Movement.Id = ObjectProtocol.MovementId AND (Movement.Id = inMovementId OR 0 = inMovementId)
   AND (Movement.DescId = inMovementDescId OR inMovementDescId = 0)
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 WHERE ObjectProtocol.OperDate BETWEEN inStartDate AND inEndDate;

--inUserId        Integer,    -- ������������  
  --  IN inObjectDescId  Integer,    -- ��� �������

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementProtocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.02.14                         *  

*/

-- ����
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 
                                                                
