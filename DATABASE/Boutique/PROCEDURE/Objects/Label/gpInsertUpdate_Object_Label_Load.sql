-- �������� ��� �������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label_Load (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label_Load(
    IN inName         TVarChar,      -- �������� ������� <�������� ��� �������>
    IN inName_RUS     TVarChar,      -- �������� ������� <�������� ��� �������> ����
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);


   --  ������� ���� � ObjectString_RUS.ValueData
   vbId := (SELECT ObjectString.ObjectId FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Label_RUS() AND UPPER (TRIM (ObjectString.ValueData) ) = UPPER (TRIM (inName_RUS)) );
   
   -- ���� �� ����� � ���� ������� ����� � Object.ValueData (��������� ��� ������ ��������, ����� ��� ��� ����. ����. ������)
   IF COALESCE (vbId,0) = 0
   THEN
       vbId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND Object.isErased = FALSE AND UPPER (TRIM (Object.ValueData) ) = UPPER (TRIM (inName_RUS) ) );
   END IF;

   -- ���� ����� ���������� ��������
   IF COALESCE (vbId,0) <> 0
   THEN
        PERFORM gpInsertUpdate_Object_Label(ioId       := vbId
                                          , ioCode     := 0
                                          , inName     := TRIM (inName)     :: TVarChar
                                          , inName_RUS := TRIM (inName_RUS) :: TVarChar
                                          , inSession  := inSession
                                          );
   END IF;   
   
   -- ���� �� ����� ������ �� ������ 

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
09.06.20          *
*/

-- ����
--