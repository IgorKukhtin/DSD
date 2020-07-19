-- Function: gpCheckRight_ObjectHistory_JuridicalDetails_OKPO ()

DROP FUNCTION IF EXISTS gpCheckRight_ObjectHistory_JuridicalDetails_OKPO (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckRight_ObjectHistory_JuridicalDetails_OKPO(
    IN inOKPO               TVarChar,   -- ����
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   IF TRIM (COALESCE (inOKPO, '')) = '' AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
   THEN
       RAISE EXCEPTION '������.��� ���� ��������� � ������ <����>.';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.07.20                                        *
*/

-- ����
-- SELECT * FROM gpCheckRight_ObjectHistory_JuridicalDetails_OKPO ('', zfCalc_UserAdmin())
