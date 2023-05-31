-- Function: _replica.gpBranchService_Select_MasterConnectParams (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Select_MasterConnectParams (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Select_MasterConnectParams(
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS TABLE (Host         TVarChar
             , DBName       TVarChar
             , Port         Integer
             , UserName     TVarChar
             , Password     TVarChar
             , UserNameUpd  TVarChar
             , PasswordUpd  TVarChar
             , UserSlaveUpd TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= inSession::Integer;

   -- ���������
   RETURN QUERY 
     SELECT '%s'::TVarChar             AS Host
          , '%s'::TVarChar             AS DBName
          , %s                         AS Port
          , '%s'::TVarChar             AS UserName
          , '%s'::TVarChar             AS Password
          , '%s'::TVarChar             AS UserNameUpd
          , '%s'::TVarChar             AS PasswordUpd
          , '%s'::TVarChar             AS UserSlaveUpd;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.23                                                       * 
*/ 

