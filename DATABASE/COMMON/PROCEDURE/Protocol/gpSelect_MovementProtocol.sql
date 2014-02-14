-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_Protocol (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Protocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Protocol(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inUserId        Integer,    -- ������������  
    IN inObjectDescId  Integer,    -- ��� �������
    IN inObjectId      Integer,    -- ������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime, ProtocolData TVarChar, UserName TVarChar, ObjectName TVarChar, ObjectTypeName TVarChar)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT 
     ObjectProtocol.OperDate,
     ObjectProtocol.ProtocolData::TVarChar,
     Object_User.ValueData AS UserName,
     Object.ValueData AS ObjectName, 
     ObjectDesc.ItemName AS ObjectTypeName
  FROM ObjectProtocol 
  JOIN Object AS Object_User ON Object_User.Id = ObjectProtocol.UserId
  JOIN Object ON Object.Id = ObjectProtocol.ObjectId AND (Object.Id = inObjectId OR 0 = inObjectId)
   AND (Object.DescId = inObjectDescId OR inObjectDescId = 0)
  JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
 WHERE ObjectProtocol.OperDate BETWEEN inStartDate AND inEndDate;

--inUserId        Integer,    -- ������������  
  --  IN inObjectDescId  Integer,    -- ��� �������

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Protocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.11.13                        *  add inObjectId
 01.11.13                        * 
*/

-- ����
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 
                                                                
