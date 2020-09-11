-- Function: gpInsert_Object_ReestrUpdate()

DROP FUNCTION  IF EXISTS gpUpdate_Movement_Reestr_ReestrUpdate(TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Reestr_ReestrUpdate(
    IN inDriver         TVarChar  ,     -- �������� 
   OUT outDriverId      Integer   ,     -- �� ��������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   --
   IF COALESCE (inDriver, '') <> ''
      THEN
          inDriver:= TRIM (COALESCE (inDriver, ''));

          -- ���� �������� � ���.���.���
          outDriverId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inDriver));
          IF COALESCE (outDriverId,0)=0
             THEN 
                 -- ���� �������� � ���.���.���(���������)
                 outDriverId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MemberExternal() AND TRIM(Object.ValueData) LIKE inDriver);
                 IF COALESCE (outDriverId,0)=0 
                    THEN 
                        -- �� ����� ��������� � ���.���.���(���������)
                        outDriverId := lpInsertUpdate_Object_MemberExternal (ioId    := 0
                                                                           , inCode  := lfGet_ObjectCode(0, zc_Object_MemberExternal()) 
                                                                           , inName  := inDriver
                                                                           , inDriverCertificate := '' ::TVarChar
                                                                           , inINN   := '' ::TVarChar
                                                                           , inUserId:= vbUserId
                                                                             );
                 END IF;  
          END IF;
   END IF;
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (outDriverId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.12.16         *

*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Reestr_ReestrUpdate()
--select * from gpUpdate_Movement_Reestr_ReestrUpdate (inDriver := '������',  inSession := '5');

--SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND Object.ValueData LIKE '%������%') 736986