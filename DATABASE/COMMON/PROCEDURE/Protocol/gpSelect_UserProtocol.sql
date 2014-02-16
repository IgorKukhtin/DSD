-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_UserProtocol (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_UserProtocol(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inUserId        Integer,    -- ������������  
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime, ProtocolData TBlob, UserName TVarChar)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT 
     UserProtocol.OperDate,
     UserProtocol.ProtocolData,
     Object_User.ValueData AS UserName
  FROM UserProtocol 
  JOIN Object AS Object_User ON Object_User.Id = UserProtocol.UserId AND (UserProtocol.UserId = inUserId OR 0 = inUserId)
 WHERE UserProtocol.OperDate BETWEEN inStartDate AND inEndDate;

--inUserId        Integer,    -- ������������  
  --  IN inObjectDescId  Integer,    -- ��� �������

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_UserProtocol (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.11.13                        *  add inObjectId
 01.11.13                        * 
*/

-- ����
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 
                                                                
