-- Function: gpUpdate_Movement_WeighingProduction_NumSecurity()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingProduction_NumSecurity (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingProduction_NumSecurity(
    IN inId             Integer   , -- ���� ������� <��������>
    IN inNumSecurity    Integer   , -- 
    IN inIsSecurity     Boolean   , -- 
    IN inSession        TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingProduction_Param()); 
     vbUserId:= lpGetUserBySession (inSession);

     --�������� �� ���������� �������� �����, ���� ����� �������
     IF inIsSecurity = TRUE
     THEN 
         --��� ������ ������ ���� �������� ������ 0
         inNumSecurity := CASE WHEN inNumSecurity < 0 THEN inNumSecurity ELSE -1 * inNumSecurity END;
     ELSE
         --��� ������ ������ ���� �������� ������ 0
         inNumSecurity := CASE WHEN inNumSecurity >= 0 THEN inNumSecurity ELSE -1 * inNumSecurity END;
     END IF;
     
     
     -- ��������� ����� � <� ���������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NumSecurity(), inId, inNumSecurity);


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);


     if vbUserId = 9457 
     then
         RAISE EXCEPTION 'Test. Ok <%>', inNumSecurity;
     end if;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.25         *
*/

-- ����
-- 