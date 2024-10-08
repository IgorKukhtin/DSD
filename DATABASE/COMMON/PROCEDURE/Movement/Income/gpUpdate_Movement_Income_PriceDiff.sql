-- Function: gpUpdate_Movement_Income_PriceDiff()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_PriceDiff (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_PriceDiff(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inIsPriceDiff         Boolean   , --  
   OUT outisPriceDiff        Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_PriceDiff());
                             
     outisPriceDiff := NOT inIsPriceDiff;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceDiff(), inId, outisPriceDiff);
     
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.24         *
*/

-- ����
--