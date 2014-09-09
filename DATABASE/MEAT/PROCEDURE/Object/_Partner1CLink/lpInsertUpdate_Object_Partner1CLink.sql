-- Function: lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Partner1CLink(
 INOUT ioId                     Integer,    -- ���� �������
    IN inCode                   Integer,    -- ��� �������
    IN inName                   TVarChar,   -- �������� �������
    IN inPartnerId              Integer,    -- 
    IN inBranchId               Integer,    -- 
    IN inContractId             Integer,    -- 
    IN inUserId                 Integer     -- ������������
)
  RETURNS Integer
AS
$BODY$
BEGIN

   -- ��������
   -- IF COALESCE (inCode, 0) = 0 AND COALESCE (inName, '') = '' THEN
   --     RAISE EXCEPTION '������.�� ���������� <���>.';
   -- END IF;

   -- ��������
   IF COALESCE (inName, '') = '' AND inCode <> 0 THEN
       RAISE EXCEPTION '������.�� ����������� <��������>.';
   END IF;
   -- ��������
   IF COALESCE (inBranchId, 0) = 0 THEN
       RAISE EXCEPTION '������.�� ���������� <������>.';
   END IF;

   -- �������� ������������ inCode ��� !!!������!! �������
   IF inCode <> 0 
    AND EXISTS (SELECT ObjectLink.ChildObjectId
              FROM ObjectLink
                   JOIN Object ON Object.Id = ObjectLink.ObjectId
                              AND Object.ObjectCode = inCode
              WHERE ObjectLink.ChildObjectId = inBranchId
                AND ObjectLink.ObjectId <> COALESCE (ioId, 0)
                AND ObjectLink.DescId = zc_ObjectLink_Partner1CLink_Branch())
   THEN
       RAISE EXCEPTION '������. ��� 1� <%> ��� ���������� � <%>. ', inCode, lfGet_Object_ValueData (inBranchId);
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner1CLink(), inCode, inName);

   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Partner(), ioId, inPartnerId);
   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Branch(), ioId, inBranchId);
   -- ���������
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Contract(), ioId, inContractId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);

   --
   -- RETURN ioId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.14                                        * set lp
 15.05.14                        * add lpInsert_ObjectProtocol
 07.04.14                        * add zc_ObjectBoolean_Partner1CLink_Contract
 15.02.14                                        * add zc_ObjectBoolean_Partner1CLink_Sybase
 11.02.14                        *
*/
