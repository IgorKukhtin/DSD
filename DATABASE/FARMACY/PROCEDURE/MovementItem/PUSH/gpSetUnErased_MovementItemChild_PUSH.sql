-- Function: gpSetUnErased_MovementItemChild_PUSH (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItemChild_PUSH (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItemChild_PUSH(
    IN inMovementId          Integer             , -- ���� ������� <��������>
 INOUT ioMovementItemId      Integer              , -- ���� ������� <������� ���������>
    IN inUnitId              Integer              , -- ���� ������� <�������������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
  vbUserId:= lpGetUserBySession (inSession);
  
  IF (COALESCE (inMovementId, 0) = 0)
  THEN
    RAISE EXCEPTION '������. �� �������� ����� ����������.';
  END IF;

  IF COALESCE (ioMovementItemId, 0) = 0
  THEN

    IF (COALESCE (inUnitId, 0) = 0)
    THEN
      RAISE EXCEPTION '������. �� ��������� �������������.';
    END IF;
    
    INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
    VALUES (zc_MI_Child(), inUnitId, inMovementId, 0, Null) RETURNING Id INTO ioMovementItemId;
      
    outIsErased:= False;
  ELSE
    -- ������������� ����� ��������
    outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= ioMovementItemId, inUserId:= vbUserId);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItemChild_PUSH (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.14                                        *
*/

-- ����
-- SELECT * FROM gpSetUnErased_MovementItemChild_PUSH (inMovementItemId:= 0, inSession:= '2')


