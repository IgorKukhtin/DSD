-- Function: gpInsertUpdate_Object_Fiscal  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CreditLimitJuridical (Integer,Integer,Integer,Integer,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CreditLimitJuridical(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inProviderId               Integer   ,    --
    IN inJuridicalId              Integer   ,    --
    IN inCreditLimit              TFloat    ,    --
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= inSession;
   
   IF COALESCE(inProviderId, 0) = 0 OR  COALESCE(inJuridicalId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �� ������� ��.���� ��������� ��� ����';
   END IF;
   
   IF EXISTS(SELECT  1
             FROM Object AS Object_CreditLimitJuridical
                                                                                 
                  INNER JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Provider
                                        ON ObjectLink_CreditLimitJuridical_Provider.ObjectId = Object_CreditLimitJuridical.Id 
                                       AND ObjectLink_CreditLimitJuridical_Provider.DescId = zc_ObjectLink_CreditLimitJuridical_Provider()
                                       AND ObjectLink_CreditLimitJuridical_Provider.ChildObjectId = inProviderId

                  INNER JOIN ObjectLink AS ObjectLink_CreditLimitJuridical_Juridical
                                        ON ObjectLink_CreditLimitJuridical_Juridical.ObjectId = Object_CreditLimitJuridical.Id 
                                       AND ObjectLink_CreditLimitJuridical_Juridical.DescId = zc_ObjectLink_CreditLimitJuridical_Juridical()
                                       AND ObjectLink_CreditLimitJuridical_Juridical.ChildObjectId = inJuridicalId

             WHERE Object_CreditLimitJuridical.DescId = zc_Object_CreditLimitJuridical()
               AND (COALESCE (ioId, 0) = 0) OR Object_CreditLimitJuridical.ID <> ioId)
   THEN
     RAISE EXCEPTION '������. ������������ ������� ��������� + ���� ��. ���� ��������� ';   
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CreditLimitJuridical()); 
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CreditLimitJuridical(), vbCode_calc, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CreditLimitJuridical_Provider(), ioId, inProviderId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CreditLimitJuridical_Juridical(), ioId, inJuridicalId);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CreditLimitJuridical_CreditLimit(), ioId, inCreditLimit);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.06.19                                                       *
*/

-- ����
-- 