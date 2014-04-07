-- Function: gpInsertUpdate_Object_Partner1CLink (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner1CLink(
    IN inId                     Integer,    -- ���� ������� <����>
    IN inCode                   Integer,    -- ��� ������� <����>
    IN inName                   TVarChar,   -- �������� ������� <����>
    IN inPartnerId              Integer,    -- 
    IN inBranchId               Integer,    -- 
    IN inBranchTopId            Integer,    -- 
    IN inContractId             Integer,    -- 
    IN inIsSybase               Boolean  DEFAULT NULL,    -- 
    IN inSession                TVarChar DEFAULT ''       -- ������ ������������
)
  RETURNS TABLE (Id Integer, BranchId Integer, BranchName TVarChar)
AS
$BODY$
  DECLARE vbBranchId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner1CLink());

   -- ��������� <������>
   inId := lpInsertUpdate_Object (inId, zc_Object_Partner1CLink(), inCode, inName);

   IF COALESCE(inBranchId, 0) = 0 THEN
      vbBranchId := inBranchTopId;
   ELSE
      vbBranchId := inBranchId;
   END IF;
   
   IF COALESCE (inCode, 0) = 0 AND COALESCE (inName, '') = '' THEN
       RAISE EXCEPTION '������.�� ���������� <���>.';
   END IF;
   IF COALESCE (inName, '') = '' THEN
       RAISE EXCEPTION '������.�� ����������� <��������>.';
   END IF;
   IF COALESCE (vbBranchId, 0) = 0 THEN
       RAISE EXCEPTION '������.�� ���������� <������>.';
   END IF;
   

   -- �������� ������������ inCode ��� !!!������!! �������
   IF EXISTS (SELECT ObjectLink.ChildObjectId
              FROM ObjectLink
                   JOIN Object ON Object.Id = ObjectLink.ObjectId
                              AND Object.ObjectCode = inCode
              WHERE ObjectLink.ChildObjectId = vbBranchId
                AND ObjectLink.ObjectId <> COALESCE (inId, 0)
                AND ObjectLink.DescId = zc_ObjectLink_Partner1CLink_Branch())
   THEN
       RAISE EXCEPTION '������. ��� 1� <%> ��� ���������� � <%>. ', inCode, lfGet_Object_ValueData (vbBranchId);
   END IF;


   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Partner(), inId, inPartnerId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Branch(), inId, vbBranchId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner1CLink_Contract(), inId, inContractId);
   IF inIsSybase IS NOT NULL
   THEN PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner1CLink_Sybase(), inId, inIsSybase);
   END IF;

   RETURN 
     QUERY SELECT inId, Object.Id, Object.ValueData
           FROM Object WHERE Object.Id = vbBranchId;
   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.04.14                        * add zc_ObjectBoolean_Partner1CLink_Contract
 15.02.14                                        * add zc_ObjectBoolean_Partner1CLink_Sybase
 11.02.14                        *
*/
