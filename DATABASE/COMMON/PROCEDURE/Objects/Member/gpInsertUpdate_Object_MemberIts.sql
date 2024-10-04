-- Function: gpInsertUpdate_Object_MemberIts(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIts (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                         TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, 
                                                         TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar); */
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIts (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                         TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, 
                                                         TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberIts(
    IN inId	             Integer   ,    -- ���� ������� <���������� ����> 
    IN inGenderId            Integer   ,    --
    IN inMemberSkillId       Integer   ,    --
    IN inJobSourceId         Integer   ,    --
    IN inRegionId            Integer   ,    --
    IN inRegionId_Real       Integer   ,    --
    IN inCityId              Integer   ,    --
    IN inCityId_Real         Integer   ,    -- 
    IN inRouteNumId          Integer   ,

    IN inBirthday_date       TDateTime ,
    IN inChildren1_date      TDateTime ,
    IN inChildren2_date      TDateTime ,
    IN inChildren3_date      TDateTime ,
    IN inChildren4_date      TDateTime ,
    IN inChildren5_date      TDateTime ,
    IN inPSP_Startdate       TDateTime ,
    IN inPSP_Enddate         TDateTime ,
    IN inDekret_StartDate    TDateTime ,
    IN inDekret_EndDate      TDateTime ,
    
    IN inStreet              TVarChar ,
    IN inStreet_Real         TVarChar ,
    IN inChildren1           TVarChar ,
    IN inChildren2           TVarChar ,
    IN inChildren3           TVarChar ,
    IN inChildren4           TVarChar ,
    IN inChildren5           TVarChar ,
    IN inLaw                 TVarChar ,
    IN inDriverCertificateAdd  TVarChar ,
    IN inPSP_S               TVarChar ,
    IN inPSP_N               TVarChar ,
    IN inPSP_W               TVarChar ,
    IN inPSP_D               TVarChar ,

    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());


   -- ����������� - �������� ���������� ��� ��� ���
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11355513)
   THEN
       --��������
       IF COALESCE (inGenderId,0) = 0 THEN RAISE EXCEPTION '������. �� �������� �������� <���>.' ; END IF;
       IF COALESCE (inBirthday_date, CURRENT_DATE) = CURRENT_DATE THEN RAISE EXCEPTION '������. �� ��������� �������� <���� ��������>.' ; END IF;
       IF COALESCE (inPSP_S,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <�������, �����>.' ; END IF;
       IF COALESCE (inPSP_N,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <�������, �����>.' ; END IF;
       IF COALESCE (inPSP_W,'') = '' THEN RAISE EXCEPTION '������. �� �������� ��������<�������, ��� �����>.' ; END IF;
       IF COALESCE (inPSP_D,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <�������, ���� ������>.' ; END IF;
       IF COALESCE (inRegionId,0) = 0 THEN RAISE EXCEPTION '������. �� ��������� �������� <�������, ��������>.' ; END IF;
       IF COALESCE (inRegionId_Real,0) = 0 THEN RAISE EXCEPTION '������. �� �������� <�������, ����������>.' ; END IF;
       IF COALESCE (inCityId,0) = 0 THEN RAISE EXCEPTION '������. �� �������� �������� <�����/����/���, ��������>.' ; END IF;
       IF COALESCE (inCityId_Real,0) = 0 THEN RAISE EXCEPTION '������. �� �������� �������� <�����/����/���, ����������>.' ; END IF;
       IF COALESCE (inStreet,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <�����, ����� ����, ����� ��������, ��������>.' ; END IF;
       IF COALESCE (inStreet_Real,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <�����, ����� ����, ����� ��������, ����������>.' ; END IF;
       
       IF COALESCE (inChildren1,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <������� 1, ���>.' ; END IF;
       IF COALESCE (inChildren2,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <������� 2, ���>.' ; END IF;
       IF COALESCE (inChildren3,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <������� 3, ���>.' ; END IF; 
       IF COALESCE (inChildren4,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <������� 4, ���>.' ; END IF;
       IF COALESCE (inChildren5,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <������� 5, ���>.' ; END IF;
    
       IF UPPER (TRIM (COALESCE (inChildren1,''))) <> '���' AND COALESCE (inChildren1_date,CURRENT_DATE) = CURRENT_DATE THEN RAISE EXCEPTION '������. �� �������� �������� <������� 1, ���� ��������>.' ; END IF;
       IF UPPER (TRIM (COALESCE (inChildren2,''))) <> '���' AND COALESCE (inChildren2_date,CURRENT_DATE) = CURRENT_DATE THEN RAISE EXCEPTION '������. �� �������� �������� <������� 2, ���� ��������>.' ; END IF;
       IF UPPER (TRIM (COALESCE (inChildren3,''))) <> '���' AND COALESCE (inChildren3_date,CURRENT_DATE) = CURRENT_DATE THEN RAISE EXCEPTION '������. �� �������� �������� <������� 3, ���� ��������>.' ; END IF;
       IF UPPER (TRIM (COALESCE (inChildren4,''))) <> '���' AND COALESCE (inChildren4_date,CURRENT_DATE) = CURRENT_DATE THEN RAISE EXCEPTION '������. �� �������� �������� <������� 4, ���� ��������>.' ; END IF;
       IF UPPER (TRIM (COALESCE (inChildren5,''))) <> '���' AND COALESCE (inChildren5_date,CURRENT_DATE) = CURRENT_DATE THEN RAISE EXCEPTION '������. �� �������� �������� <������� 5, ���� ��������>.' ; END IF;
       
       IF COALESCE (inJobSourceId,0) = 0 THEN RAISE EXCEPTION '������. �� �������� �������� <�������� ���������� � ��������>.' ; END IF; 
   END IF;

   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Street(), inId, inStreet);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Street_Real(), inId, inStreet_Real);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children1(), inId, inChildren1);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children2(), inId, inChildren2);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children3(), inId, inChildren3);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children4(), inId, inChildren4);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children5(), inId, inChildren5);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Law(), inId, inLaw);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificateAdd(), inId, inDriverCertificateAdd);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_S(), inId, inPSP_S);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_N(), inId, inPSP_N);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_W(), inId, inPSP_W);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_D(), inId, inPSP_D);
      
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Birthday(), inId, CASE WHEN inBirthday_date = CURRENT_DATE THEN NULL ELSE inBirthday_date END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children1(), inId, CASE WHEN TRIM (inChildren1) <> '' THEN inChildren1_date ELSE NULL END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children2(), inId, CASE WHEN TRIM (inChildren2) <> '' THEN inChildren2_date ELSE NULL END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children3(), inId, CASE WHEN TRIM (inChildren3) <> '' THEN inChildren3_date ELSE NULL END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children4(), inId, CASE WHEN TRIM (inChildren4) <> '' THEN inChildren4_date ELSE NULL END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children5(), inId, CASE WHEN TRIM (inChildren5) <> '' THEN inChildren5_date ELSE NULL END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_PSP_Start(), inId, CASE WHEN inPSP_StartDate = CURRENT_DATE THEN NULL ELSE inPSP_StartDate END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_PSP_End(), inId, CASE WHEN inPSP_EndDate = CURRENT_DATE THEN NULL ELSE inPSP_EndDate END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Dekret_Start(), inId, CASE WHEN inDekret_StartDate = CURRENT_DATE THEN NULL ELSE inDekret_StartDate END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Dekret_End(), inId, CASE WHEN inDekret_EndDate = CURRENT_DATE THEN NULL ELSE inDekret_EndDate END);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Gender(), inId, inGenderId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_MemberSkill(), inId, inMemberSkillId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_JobSource(), inId, inJobSourceId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Region(), inId, inRegionId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_City(), inId, inCityId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Region_Real(), inId, inRegionId_Real);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_City_Real(), inId, inCityId_Real);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_RouteNum(), inId, inRouteNumId);

   -- IF vbUserId = 9457 THEN RAISE EXCEPTION 'Test. OK'; END IF;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.08.21         * 
*/

--