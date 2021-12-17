-- Function: gpGet_Object_ReasonDifferences_Visible()

DROP FUNCTION IF EXISTS gpGet_Object_ReasonDifferences_Visible(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReasonDifferences_Visible(
   OUT outVisible    Boolean  ,  
    IN inSession     TVarChar       -- ������ ������������ 
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

 -- ��� ���� "������ ������"
   IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
            WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
   THEN
     outVisible := False;
   ELSE
     outVisible := True;   
   END IF;
   
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ReasonDifferences_Visible (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 17.12.21                                                      *
 
*/

-- SELECT * FROM gpGet_Object_ReasonDifferences_Visible ('3');