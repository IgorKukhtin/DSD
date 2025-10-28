-- Function: gpDelete_Object_PersonalByStorageLine( TVarChar)
--������� ��� �������� �����������, ������ ��� ������� ������

DROP FUNCTION IF EXISTS gpDelete_Object_PersonalByStorageLine ( TVarChar);


CREATE OR REPLACE FUNCTION gpDelete_Object_PersonalByStorageLine(
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
   
   
    -- ��������
   IF vbUserId <> zfCalc_UserAdmin()
   THEN
       RAISE EXCEPTION '������. �������� ���� ��������� ����������� ��������� ������ ��������������.';
   END IF;

   PERFORM lpUpdate_Object_isErased (inObjectId:= Object.Id, inUserId:= vbUserId)
   FROM Object
   WHERE Object.DescId = zc_Object_PersonalByStorageLine()
     AND Object.IsErased = FALSE
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.10.25         * 
*/