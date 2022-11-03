-- Function: gpUpdate_User_PhotosOnSite()

DROP FUNCTION IF EXISTS gpUpdate_User_PhotosOnSite (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_PhotosOnSite(
    IN inUserId              Integer   ,    -- ����
    IN inisPhotosOnSite      Boolean   ,    -- ���� �� �����
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
    IF EXISTS(SELECT 1
              FROM Object AS Object_User
              WHERE Object_User.DescId = zc_Object_User()
                AND Object_User.ID = inUserId) AND  
       NOT EXISTS(SELECT 1
                  FROM ObjectBoolean AS OB_PhotosOnSite
                  WHERE OB_PhotosOnSite.DescId = zc_ObjectBoolean_User_PhotosOnSite()
                    AND OB_PhotosOnSite.ObjectId = inUserId
                    AND COALESCE(OB_PhotosOnSite.ValueData, False) = inisPhotosOnSite)
    THEN

        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_PhotosOnSite(), inUserId, inisPhotosOnSite);

        -- ������� ���������
        PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.22                                                       *
*/