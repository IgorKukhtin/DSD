-- Function: gpUpdateObject_Goods_Scale()


DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Scale (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Scale(
    IN inId                Integer   , -- ���� ������� <�����>
    IN inName_Scale        TVarChar  , -- 
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Goods_Scale());
     --vbUserId:= lpGetUserBySession (inSession);


     -- �������� ���� ������������ �� ����� ���������
     IF 1=1 AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Goods_Scale())
     THEN
         RAISE EXCEPTION '������.��� ���� �� ��������� <�������� ��� ���������� Scale>.';
     END IF;

     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION '������.������� ����������� �� ������.';
         --RETURN;
     END IF;

     -- ��������� �������� <�������� ��� Scale>
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Scale(), inId, inName_Scale);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.01.24         *
*/


-- ����
--