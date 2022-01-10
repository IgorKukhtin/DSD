-- Function: gpUpdate_Object_isErased_Contract (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_Contract (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_Contract(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDebts TFloat;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_Contract());


   IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.isErased = FALSE)
   THEN
       -- ����� ������� ������� ��� ������ ������ - ������, �� ������ ����  ������ (���������� � 1 ���, �.�. ����� ���� >1 ��� <-1)
       vbDebts := (SELECT * FROM gpGet_Object_Contract_debts (inObjectId, inSession) AS tmp);
       IF ABS (COALESCE (vbDebts, 0)) > 0 
       THEN
           RAISE EXCEPTION '������.�� �������� <%> ���� ���� � ����� <%>.', lfGet_Object_ValueData (inObjectId), vbDebts;
       END IF;
   END IF;


   -- ��������
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.05.14                                        *
*/
