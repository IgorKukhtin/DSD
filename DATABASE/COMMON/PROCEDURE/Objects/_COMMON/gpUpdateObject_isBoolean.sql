-- Function: gpUpdateObject_isBoolean()

DROP FUNCTION IF EXISTS gpUpdateObject_isBoolean (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_isBoolean(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT ioParam               Boolean   , -- 
    IN inDesc                TVarChar  , -- 
    IN inSession             TVarChar  -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbDescId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession); 

     -- ���������� �������
     ioParam:= NOT ioParam;
     -- 
     vbDescId := (select Id from ObjectBooleanDesc where Code = inDesc);

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (vbDescId, inId, ioParam);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.11.15         *
*/


-- ����
--select * from gpUpdateObject_isBoolean(inId := 363541 , ioParam := 'False' , inDesc := 'zc_ObjectBoolean_ReceiptChild_WeightMain' ,  inSession := '5');
--select * from ObjectBooleanDesc where id =  zc_ObjectBoolean_ReceiptChild_TaxExit();



--select Id from ObjectBooleanDesc where Code = 'zc_ObjectBoolean_ReceiptChild_TaxExit'