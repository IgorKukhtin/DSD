--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Country_Load (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Country_Load(
    IN inCountryName         TVarChar,      -- �������� ����
    IN inShortName           TVarChar,      -- �������� ����������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbCountryId     Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inShortName,'') <> ''
   THEN
       -- ����� 
       vbCountryId := (SELECT ObjectString.ObjectId
                       FROM ObjectString
                       WHERE ObjectString.DescId = zc_ObjectString_Country_ShortName()
                         AND TRIM (ObjectString.ValueData) = TRIM (inShortName)
                       LIMIT 1
                       );

       -- E��� �� ����� ����������
       IF COALESCE (vbCountryId,0) = 0
       THEN
           -- ���������� ����� �������
           PERFORM gpInsertUpdate_Object_Country (ioId          := 0
                                                , ioCode        := 0
                                                , inName        := TRIM (inCountryName)
                                                , inShortName   := TRIM (inShortName)
                                                , inSession     := inSession
                                                 );
       ELSE 
            --��������� � ���� ������ ����������������
            UPDATE Object 
            SET ValueData = TRIM (inCountryName)
              , isErased  = FALSE
            WHERE Object.Id = vbCountryId
              AND Object.DescId = zc_Object_Country();
       END IF;
       
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.23          *
*/

-- ����
--