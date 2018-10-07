-- Function: gpInsertUpdate_MI_ProductionSeparate_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_Calculated (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionSeparate_Calculated(
    IN inId                  Integer   , --
 INOUT ioIsCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionSeparate_Calculated());

   -- ��������������
   ioIsCalculated := NOT ioIsCalculated;
   
   -- ��������� �������� <����� �������������� �� ������� (��/���)>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, ioIsCalculated);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.10.18         *
*/

-- ����
   