-- Function: gpUpdateObject_Goods_Scale()


DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Scale (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Scale (Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Scale(
    IN inId                Integer   , -- ���� ������� <�����>
    IN inName_Scale        TVarChar  , -- 
    IN inisCheck           Boolean   , --������� �������� ��/���  ��� �������� ��� ��������� 
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Goods_Scale());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION '������.������� ����������� �� ������.';
         --RETURN;
     END IF;

     IF COALESCE (inisCheck, FALSE) = TRUE
     THEN
         IF TRIM (COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Goods_Scale() AND OS.ObjectId = inId),'')) <> '' 
         THEN
             RAISE EXCEPTION '������.������������ (Scale) ��� ���������.';
             --RETURN;                                                     
         END IF;
         
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