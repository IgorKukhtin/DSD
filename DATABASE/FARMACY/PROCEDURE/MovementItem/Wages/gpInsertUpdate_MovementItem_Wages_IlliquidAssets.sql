-- Function: gpInsertUpdate_MovementItem_Wages_IlliquidAssets()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_IlliquidAssets(INTEGER, INTEGER, INTEGER, INTEGER, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_IlliquidAssets(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
    IN inUnitId              Integer   , -- �������������
    IN inIlliquidAssets      TFloat    , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� ��������.';
    END IF;
    
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    IF vbIsInsert = TRUE
    THEN

      -- ��������� <������� ���������>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserId, inMovementId, 0, NULL);

      -- ��������� �������� <�������������>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);   
      
    ELSE
    
      IF EXISTS(SELECT 1
                FROM MovementItemBoolean AS MIB_isIssuedBy
                WHERE MIB_isIssuedBy.MovementItemId = ioId
                  AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
                  AND MIB_isIssuedBy.ValueData = True)
      THEN
        RAISE EXCEPTION '������. �������� ������. ��������� ���� ���������.';            
      END IF;
      
    END IF; 

     -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaIlliquidAssets(), ioId, inIlliquidAssets);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

    --RAISE EXCEPTION '������. ������ % %', (select valuedata from Object where id = inUserId), inIlliquidAssets;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.04.21                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages_IlliquidAssets (, inSession:= '3')