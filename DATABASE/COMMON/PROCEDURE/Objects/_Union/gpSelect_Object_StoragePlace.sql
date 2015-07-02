-- Function: gpSelect_Object_StoragePlace()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitCarMember (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_StoragePlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StoragePlace(
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       WITH tmpUserTransport AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Transport() AND 1=0)
     SELECT Object_Unit_View.Id
          , Object_Unit_View.Code     
          , Object_Unit_View.Name
          , ObjectDesc.ItemName
          , Object_Unit_View.isErased
     FROM Object_Unit_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit_View.DescId
     WHERE vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
    UNION ALL
     SELECT Object_Car.Id
          , Object_Car.ObjectCode AS Code     
          , Object_Car.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Car.isErased
     FROM Object AS Object_Car
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Car.DescId
     WHERE Object_Car.DescId = zc_Object_Car()
       AND vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
    UNION ALL
     SELECT Object_Member.Id
          , Object_Member.ObjectCode AS Code     
          , Object_Member.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Member.isErased
     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
     WHERE Object_Member.DescId = zc_Object_Member()
       AND vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
   /*
    UNION ALL
     SELECT View_Personal.PersonalId AS Id       
          , View_Personal.PersonalCode     
          , View_Personal.PersonalName
          , ObjectDesc.ItemName
          , View_Personal.isErased
     FROM Object_Personal_View AS View_Personal
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = View_Personal.DescId
     WHERE vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
    UNION ALL
     SELECT View_Personal.PersonalId AS Id       
          , View_Personal.PersonalCode     
          , View_Personal.PersonalName
          , ObjectDesc.ItemName
          , View_Personal.isErased
     FROM lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection
          JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = lfObject_Unit_byProfitLossDirection.UnitId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = View_Personal.DescId
     WHERE vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
       AND (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId = zc_Enum_ProfitLossDirection_40100() -- ���������� ����������
         OR lfObject_Unit_byProfitLossDirection.UnitCode IN (23020)) -- ����� ���������
     */
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_StoragePlace (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.14                                        * add DROP FUNCTION gpSelect_Object_UnitCarMember
 26.01.14                                        * add zc_Object_Car
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        * add tmpUserTransport
 09.11.13                                        * add ItemName
 28.10.13                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_StoragePlace (inSession := '9818')
