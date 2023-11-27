-- Function: gpUpdate_ObjectCode_Basis()

DROP FUNCTION IF EXISTS gpUpdate_ObjectCode_Basis (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ObjectCode_Basis(
    IN inId                  Integer   , -- ���� ������� <�����>
 INOUT ioBasisCode           Integer    , -- ��� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

     -- ��������
     IF COALESCE ((SELECT ObjectFloat.ValueData ::Integer FROM ObjectFloat WHERE ObjectFloat.ObjectId = inId AND ObjectFloat.DescId = zc_ObjectFloat_ObjectCode_Basis()), 0) = COALESCE (ioBasisCode, 0)
     THEN
         RETURN;
     END IF;


     IF vbUserId = 343013 -- �������� �.�.
     THEN
         RAISE EXCEPTION '������.��������� BasisCode � <%> �� <%>'
          , (SELECT ObjectFloat.ValueData ::Integer FROM ObjectFloat WHERE ObjectFloat.ObjectId = inId AND ObjectFloat.DescId = zc_ObjectFloat_ObjectCode_Basis())
          , ioBasisCode
           ;
     END IF;

     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectCode_Basis());
     --vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ObjectCode_Basis(), inId, ioBasisCode);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.04.22         *
*/


-- ����
--