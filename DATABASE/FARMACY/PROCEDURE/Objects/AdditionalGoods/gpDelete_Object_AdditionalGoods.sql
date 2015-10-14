DROP FUNCTION IF EXISTS gpDelete_Object_AdditionalGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_AdditionalGoods(
    IN inId               Integer   , -- ���� ������� <�������������� ������>
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());
    vbUserId := lpGetUserBySession(inSession);
    --������� ������ <�������������� ������>
    PERFORM lpDelete_Object(inId, inSession);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_AdditionalGoods (Integer, TVarChar) OWNER TO postgres;
  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 16.10.14                                                         *
  
*/