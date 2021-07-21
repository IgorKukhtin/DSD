-- Function: gpUpdate_Movement_Sale_isDisableSMS()


DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_isDisableSMS (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_isDisableSMS(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inisDisableSMS         Boolean   , -- 
   OUT outisDisableSMS        Boolean   , -- 
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);

     -- �������� - �����������
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

     -- �������� - �����������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION '������.�������� � ������� <%>.��������� ����������', lfGet_Object_ValueData_sh (zc_Enum_Status_Complete());
     END IF;

     -- ��������������
     outisDisableSMS := Not inisDisableSMS;
     
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DisableSMS(), inId, outisDisableSMS);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.21         *
 */

-- ����