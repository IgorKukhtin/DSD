  -- Function: gpUpdate_Clear_DefaultUnitUser()

  DROP FUNCTION IF EXISTS gpUpdate_Clear_DefaultUnitUser (TVarChar);


  CREATE OR REPLACE FUNCTION gpUpdate_Clear_DefaultUnitUser(
      IN inSession     TVarChar       -- ������ ������������
  )
    RETURNS Void 
  AS
  $BODY$
    DECLARE vbUserId Integer;
  BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
     vbUserId := inSession;

     PERFORM gpUpdate_Clear_DefaultUnit (vbUserId, '3');
                                
  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;
    
  /*
   ������� ����������: ����, �����
                 ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
   14.01.20                                                       *
  */

  -- ����
  -- select * from gpUpdate_Clear_DefaultUnitUser( inSession := '3');