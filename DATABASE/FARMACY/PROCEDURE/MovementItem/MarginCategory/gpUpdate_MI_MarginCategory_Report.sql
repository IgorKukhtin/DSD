-- Function: gpUpdate_MI_MarginCategory_Report()

DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Report (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Report (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Report(
    IN inId                  Integer  , -- ���� ������� <������� ���������>
    IN inisList              Boolean  , -- 
    IN inisReport            Boolean  , -- 
   OUT outisReport           Boolean  ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inisList = TRUE
     THEN
         -- ���������� �������
         outisReport:= NOT inisReport;
     ELSE 
         -- ���������� �������
         outisReport:= inisReport;
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Report(), inId, outisReport);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 26.11.17         *
*/

-- ����