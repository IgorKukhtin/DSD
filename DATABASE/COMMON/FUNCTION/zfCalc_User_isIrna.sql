-- Function: zfCalc_User_isIrna

DROP FUNCTION IF EXISTS zfCalc_UserIrna (Integer);
DROP FUNCTION IF EXISTS zfCalc_User_isIrna (Integer);

CREATE OR REPLACE FUNCTION zfCalc_User_isIrna (in inUserId Integer)
RETURNS Boolean
AS
$BODY$
BEGIN

     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId IN (8101714 -- ���� ���� - ���
                                                                                            , 8101715 -- ���� ���� - ������������
                                                                                             ))
     THEN
          RETURN TRUE;

     ELSEIF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
         -- ���� ������ ���� + ����
         OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 8101711)
     THEN
         RETURN NULL;

     ELSE 
          RETURN FALSE;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.05.22                                        *
*/

-- ����
-- SELECT zfCalc_User_isIrna (5) as forAdmin, zfCalc_User_isIrna (10) as forOth, zfCalc_User_isIrna (9457) as forIrna