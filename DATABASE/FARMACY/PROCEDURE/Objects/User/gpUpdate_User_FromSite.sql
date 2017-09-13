-- Function: gpUpdate_User_FromSite()

-- DROP FUNCTION IF EXISTS gpUpdate_User_FromSite (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_User_FromSite (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_FromSite(
    IN inId                  Integer   ,    -- ����
    IN inPhoto               TVarChar  ,    -- ����
    IN inYear                Integer   ,    -- ���� �������� �� ������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- ���� �����
    IF inId <> 0
    THEN
        -- ��������� �������� <����>
        PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_User_Foto(), inId, inPhoto);

        -- ��������� �������� <����>
        /*IF EXISTS (SELECT View_Personal.PersonalId
                   FROM ObjectLink AS ObjectLink_User_Member
                        INNER JOIN Object_Personal_View AS View_Personal
                                                        ON View_Personal.MemberId   = ObjectLink_User_Member.ChildObjectId
                                                       AND View_Personal.isErased   = FALSE
                                                       AND View_Personal.PersonalId > 0
                   WHERE ObjectLink_User_Member.ObjectId = inId
                     AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                  )
        THEN*/

        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_In(), inId, ('01.01.' || inYear :: TVarChar) :: TDateTime);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 11.09.17                                        *
*/
