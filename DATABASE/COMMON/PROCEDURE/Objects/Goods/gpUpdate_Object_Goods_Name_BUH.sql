-- Function: gpUpdateObject_Goods_Name_BUH()

DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Name_BUH (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Name_BUH(
    IN inId                Integer   , -- ���� ������� <�����>
    IN inName_BUH          TVarChar  , -- 
    IN inDate_BUH          TDateTime , -- ���� �� ������� ��������� �������� ������(����.)
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Goods_Name_BUH());
     --vbUserId:= lpGetUserBySession (inSession);


     -- �������� ���� ������������ �� ����� ���������
     IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Goods_Name_BUH())
     THEN
         RAISE EXCEPTION '������.��� ���� �� ��������� <�������� �������������>.';
     END IF;

     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION '������.������� ����������� �� ������.';
         --RETURN;
     END IF;

     -- ��������� �������� <�������� ����>
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_BUH(), inId, inName_BUH);
     -- ��������� �������� <���� �� ������� ��������� �������� ������(����.)>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_BUH(), inId, CASE WHEN inDate_BUH = CURRENT_DATE THEN NULL ELSE inDate_BUH END);


     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.09.21         *
*/


-- ����
-- SELECT * FROM gpUpdateObject_Goods_UKTZED (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')