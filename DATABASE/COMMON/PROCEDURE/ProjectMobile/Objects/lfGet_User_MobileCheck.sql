 -- Function: lfGet_User_MobileCheck (Integer, Integer)

DROP FUNCTION IF EXISTS lfGet_User_MobileCheck (Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_User_MobileCheck(
    IN inMemberId         Integer   , -- �������� �����
    IN inUserId           Integer     -- ������������
)

-- ������������ - � ������ ����������� ������������ ����� ������������� ������ � ���������� ����������
RETURNS TABLE (MemberId Integer, UserId Integer)
AS
$BODY$
   DECLARE vbIsProjectMobile Boolean;
   DECLARE vbUserId_Member   Integer;
BEGIN
     -- ������ ��� ������������ ��� ������������ inUserId - �������� ����� - �.�. � ���� ���� ��� �������, ������������ - ����� ������� ���� ���� � ����������� �
     vbIsProjectMobile:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inUserId AND ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile());


     IF inMemberId > 0
     THEN
         -- ������������ ��� <���������� ����> - ��� UserId
         vbUserId_Member:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ChildObjectId = inMemberId);
         -- ��������
         IF COALESCE (vbUserId_Member, 0) = 0
         THEN
             RAISE EXCEPTION '������.��� ��� <%> �� ���������� �������� <������������>.', lfGet_Object_ValueData (inMemberId);
         END IF;

     ELSEIF vbIsProjectMobile = TRUE
     THEN
         -- � ���� ������ - ����� ������ ����
         vbUserId_Member:= inUserId;
         -- !!!������ ��������!!! - ������������ ��� UserId - ��� <���������� ����>
         inMemberId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ObjectId = inUserId);
     ELSE
         -- � ���� ������ - ����� ���
         vbUserId_Member:= 0;
         -- !!!������ ��������!!!
         inMemberId:= 0;
     END IF;


     -- �������� - �������� ����� ����� ������ ����
     IF vbIsProjectMobile = TRUE AND vbUserId_Member <> inUserId
     THEN
         RAISE EXCEPTION '������.������������ ���� �������.';
     END IF;



   -- ���������
   RETURN QUERY 
     SELECT inMemberId      AS MemberId
          , vbUserId_Member AS UserId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.05.17                                        *
*/

-- ����
-- SELECT * FROM lfGet_User_MobileCheck (974195, zfCalc_UserAdmin() :: Integer)
