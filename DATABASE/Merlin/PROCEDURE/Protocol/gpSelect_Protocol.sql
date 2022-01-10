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
RETURNS TABLE (OperDate TDateTime, ProtocolData TBlob, UserName TVarChar, ObjectName TVarChar, ObjectTypeName TVarChar, isInsert Boolean)
AS
$BODY$
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());


  -- ��������
  IF COALESCE (inObjectId, 0) = 0 THEN
     --RAISE EXCEPTION '������.�������� ��������� ����������.';
     RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� ��������� ����������.' :: TVarChar
                                           , inProcedureName := 'gpSelect_Protocol' :: TVarChar
                                           , inUserId        := inUserId
                                           );
  END IF;


  IF inObjectId <> 0 
  THEN

  RETURN QUERY 
  SELECT 
     ObjectProtocol.OperDate,
     ObjectProtocol.ProtocolData,
     Object_User.ValueData AS UserName,
     Object.ValueData AS ObjectName, 
     ObjectDesc.ItemName AS ObjectTypeName,
     ObjectProtocol.isInsert
  FROM ObjectProtocol 
       LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectProtocol.UserId 
       LEFT JOIN Object ON Object.Id = ObjectProtocol.ObjectId 
       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
 WHERE Object.Id = inObjectId;

  ELSE

  RETURN QUERY 
  SELECT 
     ObjectProtocol.OperDate,
     ObjectProtocol.ProtocolData,
     Object_User.ValueData AS UserName,
     Object.ValueData AS ObjectName, 
     ObjectDesc.ItemName AS ObjectTypeName,
     ObjectProtocol.isInsert
  FROM ObjectProtocol 
       LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectProtocol.UserId 
       LEFT JOIN Object ON Object.Id = ObjectProtocol.ObjectId 
       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
 WHERE ObjectProtocol.OperDate BETWEEN inStartDate AND inEndDate
   AND (ObjectProtocol.UserId = inUserId OR 0 = inUserId)
   AND (Object.Id = inObjectId OR 0 = inObjectId)
   AND (Object.DescId = inObjectDescId OR inObjectDescId = 0)
   AND ((inObjectId + inUserId + inObjectDescId) <> 0 );

  END IF;

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
                                                                
