-- Function: gpUpdate_MI_PersonalService_SummAdd()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_SummAdd  (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_SummAdd(
    IN inId                  Integer   , -- 
    IN inSummAdd             TFloat    ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer; 
           vbSummAdd TFloat;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ������� ��������� ����������.';
   END IF;

   SELECT COALESCE (MIFloat_SummAdd.ValueData,0) AS SummAdd
 INTO vbSummAdd
   FROM MovementItemFloat AS MIFloat_SummAdd
   WHERE MIFloat_SummAdd.MovementItemId = inId
     AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd();

   -- ��������
   IF COALESCE (vbSummAdd, 0) <> 0 AND COALESCE (vbSummAdd, 0) <> COALESCE (inSummAdd, 0)
   THEN
       RAISE EXCEPTION '������.����� ������ ���������� �� �����������.';
   END IF; 
   
   --���� ����� ��������� ������ �����
   IF COALESCE (vbSummAdd, 0) <> 0 AND COALESCE (vbSummAdd, 0) = COALESCE (inSummAdd, 0)
   THEN
       RETURN;
   END IF;
 
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd(), inId, inSummAdd);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.04.24         *
*/

-- ����