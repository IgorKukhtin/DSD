-- Function: gpUpdate_Movement_ReestrReturnOut_ReestrStart()

DROP FUNCTION  IF EXISTS gpUpdate_Movement_ReestrReturnOut_ReestrStart(TVarChar,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReestrReturnOut_ReestrStart(
-- INOUT ioId             Integer   ,     -- ���� ������� <�������� ������> 
    IN inDriver         TVarChar  ,     -- �������� 
    IN inMember         TVarChar  ,     -- ����������
    IN inCar            TVarChar  ,     -- � ����
   OUT outDriverId      Integer   ,     -- �� ��������
   OUT outMemberId      Integer   ,     -- �� ����������
   OUT outCarId         Integer   ,     -- �� ����
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS record AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inDriver, '') <> ''
      THEN
          inDriver:= TRIM (COALESCE (inDriver, ''));

          -- ���� �������� � ���.���.���
          outDriverId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inDriver));
          IF COALESCE (outDriverId,0) = 0
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
                        -- ��������� ��������
                        PERFORM lpInsert_ObjectProtocol (outDriverId, vbUserId);
                 END IF;  
          END IF;
   END IF;
  
   IF COALESCE (inMember, '') <> ''
      THEN
          inMember:= TRIM (COALESCE (inMember, ''));

          -- ���� ����������� � ���.���.���
          outMemberId:= (SELECT  Object.Id  FROM Object WHERE Object.DescId = zc_Object_Member() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inMember));
          IF COALESCE (outMemberId,0)=0
             THEN 
                 -- ���� ����������� � ���.���.���(���������)
                 outMemberId:= (SELECT  Object.Id  FROM Object WHERE Object.DescId = zc_Object_MemberExternal() AND Object.ValueData LIKE inMember);
                 IF COALESCE (outMemberId,0) = 0 
                    THEN 
                        -- �� ����� ��������� � ���.���.���(���������)
                        outMemberId := lpInsertUpdate_Object_MemberExternal (ioId    := 0
                                                                           , inCode  := lfGet_ObjectCode(0, zc_Object_MemberExternal()) 
                                                                           , inName  := inMember
                                                                           , inDriverCertificate := '' ::TVarChar
                                                                           , inINN   := '' ::TVarChar
                                                                           , inUserId:= vbUserId
                                                                             );
                        -- ��������� ��������
                        PERFORM lpInsert_ObjectProtocol (outMemberId, vbUserId);
                 END IF;  
          END IF;
   END IF;

   IF COALESCE (inCar, '') <> ''
      THEN
          inCar:= TRIM (COALESCE (inCar, ''));

          -- ���� ����������� � ���.����
          outCarId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Car() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inCar));
          IF COALESCE (outCarId,0)=0
             THEN 
                 -- ���� ����������� � ���.����(���������)
                 outCarId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CarExternal() AND Object.ValueData LIKE inCar);
                 IF COALESCE (outCarId,0) = 0 
                    THEN 
                        -- �� ����� ��������� � ����(���������)
                        outCarId := lpInsertUpdate_Object_CarExternal (ioId	           := 0
                                                                     , inCode          := lfGet_ObjectCode(0, zc_Object_CarExternal())
                                                                     , inName          := inCar
                                                                     , inRegistrationCertificate := '' ::TVarChar
                                                                     , inVIN                     := ''
                                                                     , inComment       := '' ::TVarChar
                                                                     , inCarModelId    := 0
                                                                     , inCarTypeId     := 0
                                                                     , inCarPropertyId := 0
                                                                     , inObjectColorId := 0
                                                                     , inJuridicalId   := 0
                                                                     , inLength        := 0
                                                                     , inWidth         := 0
                                                                     , inHeight        := 0
                                                                     , inWeight        := 0
                                                                     , inYear          := 0
                                                                     , inUserId        := vbUserId
                                                                       );
                        -- ��������� ��������
                        PERFORM lpInsert_ObjectProtocol (outCarId, vbUserId);
                 END IF;  
          END IF;
   END IF;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.21         *
*/

-- ����
--select * from gpUpdate_Movement_ReestrReturnOut_ReestrStart(ioId := 0 , inDriver := '������'  , inMember := '������' , inCar := '5115' ,  inSession := '5');

--SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND Object.ValueData LIKE '%������%') 736986