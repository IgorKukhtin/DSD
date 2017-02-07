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
RETURNS TABLE (OperDate TDateTime, ProtocolData Text, UserName TVarChar, 
               InvNumber TVarChar, MovementOperDate TDateTime, MovementDescName TVarChar,
               isInsert Boolean)
AS
$BODY$
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  -- ��������
  IF COALESCE (inMovementId, 0) = 0 THEN
     RAISE EXCEPTION '������.�������� ��������� ����������.';
  END IF;


  IF inMovementId <> 0 AND EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_ProfitLossService(), zc_Movement_Service()))
  THEN
  RETURN QUERY 
  -- real-1
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 UNION ALL
  -- real-2
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementItemDesc.ItemName AS MovementDescName,
     MovementItemProtocol.isInsert
  FROM MovementItemProtocol
  JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
  JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId AND MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
  JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
  JOIN Movement ON Movement.Id = MovementItem.MovementId

 UNION ALL
  -- arc-1
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol_arc AS MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 UNION ALL
  -- arc-2
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementItemDesc.ItemName AS MovementDescName,
     MovementItemProtocol.isInsert
  FROM MovementItemProtocol_arc AS MovementItemProtocol
  JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
  JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId AND MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
  JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
  JOIN Movement ON Movement.Id = MovementItem.MovementId;

  ELSE

  IF inMovementId <> 0 
  THEN
  -- real-1
  RETURN QUERY 
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 UNION ALL
  -- arc-1
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol_arc AS MovementProtocol
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;

  ELSE
     RAISE EXCEPTION '������.�������� ��������� ����������.';

  END IF;
  END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.15         *
 14.02.14                         *  

*/

-- ����
-- SELECT * FROM gpSelect_MovementProtocol (inStartDate:= NULL, inEndDate:= NULL, inUserId:= 0, inMovementDescId:= 0, inMovementId:=  354233, inSession := '5');
