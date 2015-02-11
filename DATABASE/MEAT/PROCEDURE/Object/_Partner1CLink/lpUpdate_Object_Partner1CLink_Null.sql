-- Function: lpUpdate_Object_Partner1CLink_Null (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner1CLink_Null (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner1CLink_Null(
    IN inCode                   Integer,    -- ��� �������
    IN inPartnerId              Integer,    -- 
    IN inBranchId               Integer    -- 
)
  RETURNS VOID
AS
$BODY$
DECLARE 
  vbObjectLinkId Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner1CLink());

       SELECT Object_Partner1CLink.Id INTO vbObjectLinkId

       FROM Object AS Object_Partner1CLink
            JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()

            JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
       
       WHERE ObjectLink_Partner1CLink_Partner.ChildObjectId = inPartnerId 
         AND ObjectLink_Partner1CLink_Branch.ChildObjectId = inBranchId
         AND Object_Partner1CLink.ObjectCode = inCode;


   -- ��������� <������>
   UPDATE Object SET ObjectCode = 0 WHERE Id = vbObjectLinkId;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUpdate_Object_Partner1CLink_Null (Integer, Integer, Integer)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.06.14                        * 
*/
