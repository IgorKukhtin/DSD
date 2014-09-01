-- Function: gpInsertUpdate_Object_Partner1CLink (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner1CLink(
    IN inId                     Integer,    -- ���� �������
    IN inCode                   Integer,    -- ��� �������
    IN inName                   TVarChar,   -- �������� �������
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
  DECLARE vbUserId Integer;
  DECLARE vbBranchId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner1CLink());
   vbUserId := lpGetUserBySession (inSession);


   -- ���-��
   IF COALESCE (inBranchId, 0) = 0 THEN
      vbBranchId := inBranchTopId;
   ELSE
      vbBranchId := inBranchId;
   END IF;

   -- ��������� <������>
   inId:= lpInsertUpdate_Object_Partner1CLink (ioId         := inId
                                             , inCode       := inCode
                                             , inName       := inName
                                             , inPartnerId  := inPartnerId
                                             , inBranchId   := vbBranchId
                                             , inContractId := inContractId
                                             , inUserId     := vbUserId
                                              );

   -- ���������
   RETURN QUERY
      SELECT inId, Object.Id, Object.BranchLinkName FROM Object_BranchLink_View AS Object WHERE Object.Id = vbBranchId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Partner1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.14                                        *
*/
