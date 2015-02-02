-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemProtocol(
    IN inStartDate           TDateTime , -- 
    IN inEndDate             TDateTime , --
    IN inUserId              Integer,    -- ������������  
    IN inMovementItemId      Integer,    -- ��������  
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime, ProtocolData Text, UserName TVarChar, MovementItemId Integer)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  IF inMovementItemId <> 0 
  THEN

  RETURN QUERY 
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData AS UserName,
     MovementItemProtocol.MovementItemId
  FROM MovementItem
       JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
 WHERE MovementItem.Id = inMovementItemId;

  ELSE

  RETURN QUERY 
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData AS UserName,
     MovementItemProtocol.MovementItemId
  FROM MovementItem
       JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
       JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
                                 AND (Object_User.Id = inUserId or inUserId = 0)
 WHERE MovementItem.Id = inMovementItemId;

  END IF;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_MovementItemProtocol (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.01.15         *              
 14.02.14                         *  
*/

-- ����
--SELECT * FROM gpSelect_MovementItemProtocol (inStartDate:= '01.10.2014', inEndDate:= '01.10.2014', inMovementId:= null, inSession:= '2'); 
                                                                