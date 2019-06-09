-- Function: gpInsertUpdate_Object_Juridical_CreditLimitDistributor()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical_CreditLimitDistributor (Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical_CreditLimitDistributor(
    IN inId                      Integer   ,   	-- ���� ������� <�������������>
    IN inCreditLimit             TFloat    ,    
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId:= inSession;

/*   IF 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 8001630 <> inSession::Integer
   THEN
      RAISE EXCEPTION '��������� <��������� �������> ��� ���������.';
   END IF;
*/
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION '������. �� ������� ��.����';
   ELSE

       -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CreditLimit(), inId, inCreditLimit);

     -- ��������� ��������
     --PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   END IF;
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.06.19                                                        *
 10.04.19                                                        *
*/

-- ����
--