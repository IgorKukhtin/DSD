-- Function: gpUpdate_Movement_WeighingProduction_Param()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingProduction_Param (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingProduction_Param(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inBarCodeBoxId        Integer   , -- 
    IN inGoodsTypeKindId     Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber TVarChar;
   DECLARE vbParentId Integer;
   DECLARE vbStartWeighing TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingProduction_Param());

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BarCodeBox(), inId, inBarCodeBoxId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsTypeKind(), inId, inGoodsTypeKindId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.06.19         *
*/

-- ����
-- 